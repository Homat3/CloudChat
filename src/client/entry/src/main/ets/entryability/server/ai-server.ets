import { CloudChat } from "../../CloudChat";
import { send, receive } from "../../core/protocol/http/agent.http";
import { RequestOptionsBuilder } from "../../core/service/network/http/config.http";
import { http } from "@kit.NetworkKit";
import { Event } from "../../core/tag/Event";
import { EventBus } from "../../core/service/event/EventBus";
import { util } from "@kit.ArkTS";
import { AiMessage } from "../../core/models/message";
import utils from "@arkts.utils";

class SentMessageTempStore{
  private static storeMap: Map<string, send.PostMessagePayload> = new Map();
  private static deletedUuid: string[] = [];
  private static deleteStore(uuid: string){
    SentMessageTempStore.storeMap.delete(uuid);
    SentMessageTempStore.deletedUuid.push(uuid);
    if (SentMessageTempStore.deletedUuid.length >= 100){
      SentMessageTempStore.deletedUuid.splice(0, 49);
    }
  }
  public static pushStore(tempUuid: string, payload: send.PostMessagePayload){
    if (SentMessageTempStore.storeMap.has(tempUuid)){
      throw new Error("This UUID has been used");
    }
    SentMessageTempStore.storeMap.set(tempUuid, payload);
    setTimeout(() => {
      if (SentMessageTempStore.storeMap.has(tempUuid)){
        SentMessageTempStore.takeStore(tempUuid);
        EventBus.emit(Event.SEND_MESSAGE_FAILED, "Service response time out: 5s");
      }
    }, 5000)
  }
  public static takeStore(tempUuid: string): send.PostMessagePayload | null {
    const payload = SentMessageTempStore.storeMap.get(tempUuid);
    if (payload){
      SentMessageTempStore.deleteStore(tempUuid);
      return payload;
    }
    else {
      if (SentMessageTempStore.deletedUuid.reverse().includes(tempUuid)){
        console.warn("The message has been taken");
        return null;
      }
      else {
        throw new Error("Not found");
      }
    }
  }
}

namespace Agent {
  interface Header {
    'Content-Type': string,
    'Authorization': string
  }
  export const header: Header = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${CloudChat.aiToken}`
  }
  export interface EnterMessage{
    role: 'user' | 'assistant',
    type: 'question' | 'answer',
    content: string,
    content_type: 'text'
  }
  export interface ChatData{
    id: string,
    conversation_id: string,
    created_at: number,
    bot_id: string,
    status: 'created' | 'in_progress' | 'completed' | 'failed' | 'requires_action' | 'canceled',
    meta_data: MetaData
  }
  export interface MessageData{
    id: string,
    conversation_id: string,
    updated_at: number,
    role: 'user' | 'assistant',
    type: 'question' | 'answer',
    content: string,
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

export function createNewConversation(data: send.CreateNewConversationPayload) {
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

  const body: Body = {
    bot_id: CloudChat.botId,
    name: `${data.username}-${Date.now().toString()}`
  }
  const httpServer = CloudChat.aiHttpServer;
  httpServer.request('/v1/conversation/create',
    new RequestOptionsBuilder().header(Agent.header).method('POST').body(body).build(),
    (err: BusinessError, res: http.HttpResponse)=>{
      if(err){
        EventBus.emit(Event.AGENT_CONVERSATION_CREATE_FAILED, err.message);
        return;
      }
      const resultData = res.result as Response;
      console.log('Response:', resultData);
      if (res.responseCode === 200) {
        if (resultData.code === 0) {
          EventBus.emit(Event.AGENT_CONVERSATION_CREATE_SUCCESS, { conversationId: resultData.data.id, conversationName: resultData.data.name } as receive.ConversationCreateSuccessPayload);
        }
        else {
          EventBus.emit(Event.AGENT_CONVERSATION_CREATE_FAILED, resultData.msg);
        }
      }
  })
}

export function deleteConversation(data: send.DeleteConversationPayload){
  interface Response{
    code: number,
    msg: string,
    detail: Agent.ResponseDetail
  }

  const httpServer = CloudChat.aiHttpServer;
  httpServer.request(`/v1/conversations/${data.conversationId}`,
    new RequestOptionsBuilder().header(Agent.header).method('DELETE').build(),
    (err: BusinessError, res: http.HttpResponse)=>{
      if(err){
        EventBus.emit(Event.AGENT_CONVERSATION_DELETE_FAILED, err.message);
        return;
      }
      const resultData = res.result as Response;
      console.log('Response:', resultData);
      if (res.responseCode === 200) {
        if (resultData.code === 0) {
          EventBus.emit(Event.AGENT_CONVERSATION_DELETE_SUCCESS);
        }
        else {
          EventBus.emit(Event.AGENT_CONVERSATION_DELETE_FAILED, resultData.msg);
        }
      }
    })
}

export function postMessage(data: send.PostMessagePayload){
  interface Body{
    bot_id: string,
    user_id: string,
    additional_messages: Agent.EnterMessage[],
    stream: boolean,
    meta_data: Agent.MetaData,
  }
  interface Response{
    data: Agent.ChatData
    code: number,
    msg: string
  }

  const uuid = util.generateRandomUUID(true);
  const body: Body = {
    bot_id: CloudChat.botId,
    user_id: `CloudChat:${data.username}(${data.userId})`,
    additional_messages: [{
      role: 'user',
      type: 'question',
      content: data.message,
      content_type: 'text'
    }],
    stream: false,
    meta_data: {
      uuid: uuid
    }
  }
  const httpServer = CloudChat.aiHttpServer;
  SentMessageTempStore.pushStore(uuid, data);
  httpServer.request(`/v3/chat?conversation_id=${data.conversationId}`,
    new RequestOptionsBuilder().header(Agent.header).method('POST').body(body).build(),
    (err: BusinessError, res: http.HttpResponse)=>{
      if(err){
        EventBus.emit(Event.AGENT_POST_MESSAGE_FAILED, err.message);
        return;
      }
      const resultData = res.result as Response;
      console.log('Response:', resultData);
      if (res.responseCode === 200) {
        if (resultData.code === 0) {
          EventBus.emit(Event.AGENT_POST_MESSAGE_SUCCESS, {
            id: resultData.data.meta_data.uuid,
            content: SentMessageTempStore.takeStore(resultData.data.meta_data.uuid)?.message,
            role: 'user',
            timestamp: new Date(resultData.data.created_at).toLocaleDateString()
          } as AiMessage);
          setTimeout(() => {
            console.info("Start Check For Agent Reply");
            checkForReply(resultData.data.conversation_id, resultData.data.id);
          }, 1200);
        }
        else {
          EventBus.emit(Event.AGENT_POST_MESSAGE_FAILED, resultData.msg);
        }
      }
    })
}

function checkForReply(conversationId: string, chatId: string){
  interface Response{
    data: Agent.ChatData,
    detail: Agent.ResponseDetail,
    code: number,
    msg: string
  }

  const httpServer = CloudChat.aiHttpServer;
  httpServer.request(`/v3/chat/retrieve?conversation_id=${conversationId}&chat_id=${chatId}`,
    new RequestOptionsBuilder().header(Agent.header).method('GET').build(),
    (err: BusinessError, res: http.HttpResponse)=>{
      if(err){
        EventBus.emit(Event.AGENT_REPLY_FAILED, err.message);
        return;
      }
      const resultData = res.result as Response;
      console.log('Response:', resultData);
      if (res.responseCode === 200) {
        if (resultData.code === 0) {
          switch (resultData.data.status){
            case 'in_progress' :
            case 'created': {
              setTimeout(() => {
                console.info("Start Check For Agent Reply");
                checkForReply(resultData.data.conversation_id, resultData.data.id);
              }, 1200);
              break;
            }
            case 'completed':{
              console.info("Get Agent Reply");
              getReply(conversationId, chatId);
            }
            default : {
              EventBus.emit(Event.AGENT_REPLY_FAILED, resultData.data);
              break;
            }
          }
        }
        else {
          EventBus.emit(Event.AGENT_REPLY_FAILED, resultData.msg);
        }
      }
    })
}

function getReply(conversationId: string, chatId: string){
  interface Response{
    data: Agent.MessageData,
    detail: Agent.ResponseDetail,
    code: number,
    msg: string
  }

  const httpServer = CloudChat.aiHttpServer;
  httpServer.request(`/v3/chat/message/list?conversation_id=${conversationId}&chat_id=${chatId}`,
    new RequestOptionsBuilder().header(Agent.header).method('GET').build(),
    (err: BusinessError, res: http.HttpResponse)=>{
      if(err){
        EventBus.emit(Event.AGENT_REPLY_FAILED, err.message);
        return;
      }
      const resultData = res.result as Response;
      console.log('Response:', resultData);
      if (res.responseCode === 200) {
        if (resultData.code === 0) {
          EventBus.emit(Event.AGENT_REPLY_SUCCESS, {
            id: resultData.data.id,
            content: resultData.data.content,
            role: 'assistant',
            timestamp: new Date(resultData.data.updated_at).toLocaleDateString()
          } as AiMessage);
        }
        else {
          EventBus.emit(Event.AGENT_REPLY_FAILED, resultData.msg);
        }
      }
    })
}