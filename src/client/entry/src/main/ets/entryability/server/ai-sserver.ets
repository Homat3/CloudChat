import { CloudChat } from "../../CloudChat";
import { send, receive } from "../../core/protocol/http/agent.http";
import { RequestOptionsBuilder } from "../../core/service/network/http/config.http";
import { http } from "@kit.NetworkKit";
import { Event } from "../../core/tag/Event";
import { EventBus } from "../../core/service/event/EventBus";

namespace Agent {
  export interface EnterMessage{
    role: 'user' | 'assistant',
    type: 'question' | 'answer',
    content: MessageItem[],
    meta_data: MetaData,
    content_type: 'text'
  }
  export interface MessageItem{
    type: 'text',
    text: string
  }
  export interface MetaData{
    uuid: string
  }
  export interface ConversationData{
    id: string,
    name: string,
    meta_data: MetaData,
    creator_id: string,
    created_at: number,
    updated_at: number,
    last_section_id: string,
    connector_id: string
  }
  export interface ResponseDetail{
    logid: string
  }
}

export function createNewConversation(username: string) {
  interface Header{
    'Content-Type': string,
    'Authorization': string
  }
  interface Body{
    bot_id: string,
    name: string
  }
  interface Response{
    data: Agent.ConversationData,
    detail: Agent.ResponseDetail,
    code: number,
    msg: string
  }

  const header: Header = {
    'Content-Type': 'application/json',
    'Authorization': CloudChat.aiToken
  }
  const body: Body = {
    bot_id: CloudChat.botId,
    name: `${username}-${Date.now().toString()}`
  }
  const httpServer = CloudChat.aiHttpServer;
  httpServer.request('/v1/conversation/create',
    new RequestOptionsBuilder().header(header).method('POST').body(body).build(),
    (err: BusinessError, res: http.HttpResponse)=>{
      if(err){
        EventBus.emit(Event.AGENT_INIT_FAILED, err.message);
        return;
      }
      const resultData = res.result as Response;
      console.log('Response:', resultData);
      if (res.responseCode === 200) {
        if (resultData.code === 0) {
          EventBus.emit(Event.AGENT_INIT_SUCCESS, { id: resultData.data.id, name: resultData.data.name } as receive.ConversationCreateSuccessPayload);
        }
        else {
          EventBus.emit(Event.AGENT_INIT_FAILED, resultData.msg);
        }
      }
  })
}