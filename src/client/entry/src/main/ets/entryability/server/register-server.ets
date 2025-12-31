import { common } from "@kit.AbilityKit";
import { HttpClientMessage,
  HttpClientMessageType,
  RegisterPayload as hRegisterPayload,
  } from "../../core/protocol/http/client.http.protocol";
import { HttpService } from "../../core/service/network/http/server.http";
import { http } from "@kit.NetworkKit";
import { EventBus } from "../../core/service/event/EventBus";
import { Event } from "../../core/tag/Event";
import { HttpServiceMessage, HttpServiceMessageType,
  RegisterFailurePayload as hRegisterFailurePayload,
  RegisterSuccessPayload as hRegisterSuccessPayload,
} from "../../core/protocol/http/service.http.protocol";
import {
  HdlInfoPayload,
  RegisterPayload as wRegisterPayload,
  WebSocketClientMessage,
  WebsocketClientMessageType } from "../../core/protocol/websocket/client.websocket.protocol";
import { WebsocketService } from "../../core/service/network/websocket/server.websocket";
import {
  HdlGotPayload,
  RegisterFailurePayload,
  RegisterFailurePayload as wRegisterFailurePayload,
  RegisterSuccessPayload as wRegisterSuccessPayload,
  WebsocketServiceMessage,
  WebsocketServiceMessageType } from "../../core/protocol/websocket/service.websocket.protocol";

export function handleRegister(data: hRegisterPayload){
  const uri = 'cloudchat.infinomat.com';
  const httpService  = new HttpService(uri,"14514",false);
  const registerRequest: HttpClientMessage = {
    type : HttpClientMessageType.REGISTER,
    payload : data
  };

  //发送http协议
  httpService.post('/register',registerRequest,(err: BusinessError,res:http.HttpResponse)=>{
    if(err){
      EventBus.emit(Event.REGISTER_FAILED, { error: err.message } as RegisterFailurePayload);
      return;
    }

    //解析数据
    try{
      const resultData = res.result as HttpServiceMessage;
      console.log('Register_login Response:', resultData);

      if(res.responseCode === 200){
        switch (resultData.type){
          case HttpServiceMessageType.REGISTER_SUCCESS:
            const successData = resultData.payload as hRegisterSuccessPayload;
            WebSocketVerify({ userId: successData.userId }, successData);
            break;
          case HttpServiceMessageType.REGISTER_FAILURE:
            EventBus.emit(Event.REGISTER_FAILED, resultData.payload as hRegisterFailurePayload);
            break;
          default:
            throw new Error("Unknown error");
        }
      }
    }catch(e){
      EventBus.emit(Event.LOGIN_FAILED, { error: e } as RegisterFailurePayload);
    }
  });
}


function WebSocketVerify (data: HdlInfoPayload, verifyData: hRegisterSuccessPayload){
  const ws = new WebsocketService("cloudchat.infinomat.com", "14514");
  try{
    ws.connect();
    ws.addNewMessageObserver((msg)=>{
      //控制台响应
      console.log("Received: "+ msg);
      let receivedObject = JSON.parse(msg) as WebsocketServiceMessage;
      //处理登录响应
      if( receivedObject.type === WebsocketServiceMessageType.HDL_GOT) {
        if ((receivedObject.payload as HdlGotPayload).userId === verifyData.userId) {
          EventBus.emit(Event.LOGIN_SUCCESS, verifyData);
        }
        else {
          EventBus.emit(Event.LOGIN_FAILED, { error: "Multiple Id" } as RegisterFailurePayload);
        }
      }
    });

    const registerInfo: WebSocketClientMessage = {
      type: WebsocketClientMessageType.HDL_INFO,
      payload: data
    }
    ws.send(registerInfo);
  } catch(e){
    EventBus.emit(Event.LOGIN_FAILED, { error: e } as RegisterFailurePayload);
  }
}