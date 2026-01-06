import { common } from "@kit.AbilityKit";
import { CloudChat } from "../../CloudChat";
import { Message } from "../../core/models/message";
import { HttpClientMessage,
  HttpClientMessageType,
  LoadMessagesPayload } from "../../core/protocol/http/client.http.protocol";
import { HttpServiceMessage, HttpServiceMessageType,
  MessagesLoadedPayload } from "../../core/protocol/http/service.http.protocol";
import { Event } from "../../core/tag/Event";
import { EventBus } from "../../core/service/event/EventBus";
import { HttpService } from "../../core/service/network/http/server.http";
import { http } from "@kit.NetworkKit";
import { SendMessagePayload, WebSocketClientMessage,
  WebsocketClientMessageType } from "../../core/protocol/websocket/client.websocket.protocol";
import {
  MessageReceivedSelfPayload,
  WebsocketServiceMessage,
  WebsocketServiceMessageType } from "../../core/protocol/websocket/service.websocket.protocol";
import { util } from "@kit.ArkTS";

class SentMessageTempStore{
  private static storeMap: Map<string, SendMessagePayload> = new Map();
  private static deletedUuid: string[] = [];
  private static deleteStore(uuid: string){
    SentMessageTempStore.storeMap.delete(uuid);
    SentMessageTempStore.deletedUuid.push(uuid);
    if (SentMessageTempStore.deletedUuid.length >= 100){
      SentMessageTempStore.deletedUuid.splice(0, 49);
    }
  }
  public static pushStore(tempUuid: string, payload: SendMessagePayload){
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
  public static takeStore(tempUuid: string): SendMessagePayload | null {
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

export function handleLoadMessages(data: LoadMessagesPayload) {
  const httpService = CloudChat.httpServer;
  const loginRequest: HttpClientMessage ={
    type : HttpClientMessageType.LOAD_MESSAGES,
    payload : data
  };

  console.log('Send Request:',loginRequest);
  //发送http请求
  httpService.post('/load/contacts', loginRequest, (err: BusinessError, res: http.HttpResponse)=>{
    if(err){
      EventBus.emit(Event.MESSAGES_LOADED_FAILED, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;
      console.log('Password_login Response:', resultData);

      if (res.responseCode === 200) {
        switch (resultData.type){
          case HttpServiceMessageType.MESSAGES_LOADED:
            const result = resultData.payload as MessagesLoadedPayload
            CloudChat.addMessagesOfContact(result.targetId, result.messages);
            if (CloudChat.messageLoadEnd) EventBus.emit(Event.MESSAGES_LOADED);
            break;
          default:
            EventBus.emit(Event.MESSAGES_LOADED_FAILED, "Unknown error");
            throw new Error("Unknown error");
        }
      }
    } catch (e) {
      EventBus.emit(Event.MESSAGES_LOADED_FAILED, e);
    }
  });
}

export function handleSendMessage(data: SendMessagePayload){
  const ws = CloudChat.websocketServer;
  try{
    ws.addMessageObserver((msg)=>{
      //控制台响应
      console.log("Received: "+ msg);
      let receivedObject = JSON.parse(msg) as WebsocketServiceMessage;
      //处理登录响应
      if( receivedObject.type === WebsocketServiceMessageType.MESSAGE_RECEIVED_SELF) {
        const payload = receivedObject.payload as MessageReceivedSelfPayload;
        const localPayload = SentMessageTempStore.takeStore(payload.tempId);
        if (localPayload) EventBus.emit(Event.SEND_MESSAGE_SUCCESS, {
          id: payload.id,
          senderId: localPayload.senderId, receiverId: localPayload.receiverId,
          content: localPayload.content, timestamp: payload.timestamp,
          status: 'sent', type: 'text'
        } as Message);
      }
    });

    let dataAvailable = false;
    do {
      data.tempId = util.generateRandomUUID(true);
      try {
        SentMessageTempStore.pushStore(data.tempId, data)
        dataAvailable = true;
      }
      catch (e) {
        dataAvailable = false;
        continue;
      }
    } while (!dataAvailable)

    const registerInfo: WebSocketClientMessage = {
      type: WebsocketClientMessageType.SEND_MESSAGE,
      payload: data
    }
    ws.send(registerInfo);
  } catch(e){
    EventBus.emit(Event.SEND_MESSAGE_FAILED, e);
  }
}