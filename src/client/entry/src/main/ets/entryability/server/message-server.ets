import { common } from "@kit.AbilityKit";
import { CloudChat } from "../../CloudChat";
import { Message } from "../../core/models/message";
import { HttpClientMessage,
  HttpClientMessageType,
  LoadMessagesPayload } from "../../core/protocol/http/client.http.protocol";
import { HttpServiceMessage, HttpServiceMessageType,
  MessagesLoadedPayload } from "../../core/protocol/http/service.http.protocol";
import { Event } from "../../core/service/event/Event";
import { EventBus } from "../../core/service/event/EventBus";
import { HttpService } from "../../core/service/network/http/server.http";
import { http } from "@kit.NetworkKit";

export function handleLoadMessages(data: LoadMessagesPayload) {
  const httpService = new HttpService("cloudchat.infinomat.com", "14514", false);
  const loginRequest: HttpClientMessage ={
    type : HttpClientMessageType.LOAD_MESSAGES,
    payload : data
  };

  console.log('Send Request:',loginRequest);
  //发送http请求
  httpService.post('/load/contacts', loginRequest, (err: BusinessError, res: http.HttpResponse)=>{
    if(err){
      EventBus.emit(Event.LOAD_MESSAGES, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;
      console.log('Password_login Response:', resultData);

      if (res.responseCode === 200) {
        switch (resultData.type){
          case HttpServiceMessageType.CONTACTS_LOADED:
            const result = resultData.payload as MessagesLoadedPayload
            CloudChat.messageMap = resolveMessages(result.messages);
            EventBus.emit(Event.CONTACT_LIST_LOADED, result);
            break;
          default:
            throw new Error("Unknown error");
        }
      }
    } catch (e) {
      EventBus.emit(Event.CONTACT_LIST_LOAD_FAILED, e);
    }
  });
}

function resolveMessages(messages: Message[]): Map<number, Message[]>{
  return new Map();
}