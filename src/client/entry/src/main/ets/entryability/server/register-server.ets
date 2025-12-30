import { common } from "@kit.AbilityKit";
import { HttpClientMessage,
  HttpClientMessageType,
  RegisterPayload as hRegisterPayload,
  } from "../../core/protocol/http/client.http.protocol";
import { HttpService } from "../../core/service/network/http/server.http";
import { http } from "@kit.NetworkKit";
import { EventBus } from "../../core/service/event/EventBus";
import { Event } from "../../core/service/event/Event";
import { HttpServiceMessage, HttpServiceMessageType,
  RegisterFailurePayload as hRegisterFailurePayload,
  RegisterSuccessPayload as hRegisterSuccessPayload,
} from "../../core/protocol/http/service.http.protocol";
import {
  RegisterPayload as wRegisterPayload,
  WebSocketClientMessage,
  WebsocketClientMessageType } from "../../core/protocol/websocket/client.websocket.protocol";
import { WebsocketService } from "../../core/service/network/websocket/server.websocket";
import {
  RegisterFailurePayload as wRegisterFailurePayload,
  RegisterSuccessPayload as wRegisterSuccessPayload,
  WebsocketServiceMessage,
  WebsocketServiceMessageType } from "../../core/protocol/websocket/service.websocket.protocol";

export function handleRegister(context: common.UIAbilityContext,data: hRegisterPayload){
  const uri = 'cloudchat.infinomat.com';
  const httpService  = new HttpService(uri,"14514",false);
  const registerRequest: HttpClientMessage = {
    type : HttpClientMessageType.REGISTER,
    payload : data
  };

  //发送http协议
  httpService.post('/register',registerRequest,(err:BusinessError,res:http.HttpResponse)=>{
    if(err){
      console.error(err.message);
      EventBus.emit(Event.REGISTER_FAILED, err.message);
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
            const responsePayload : wRegisterPayload = {
              username : successData.username,
              password : data.password,
              email : successData.email,
            }
            WebSocketVerify(responsePayload, successData);
            break;
          case HttpServiceMessageType.REGISTER_FAILURE:
            EventBus.emit(Event.REGISTER_FAILED, resultData.payload as hRegisterFailurePayload);
            break;
          default:
            throw new Error("Unknown error");
        }
      }
    }catch(e){
      console.error(e);
    }
  });
}


function WebSocketVerify (data: wRegisterPayload, verifyData: hRegisterSuccessPayload){
  const uri = "cloudchat.infinomat.com";
  const ws = new WebsocketService(uri,"14514");
  try{
    ws.connect();
    ws.addNewMessageObserver((msg)=>{
      //控制台响应
      console.log("Received: "+ msg);
      let receivedObject = JSON.parse(msg) as WebsocketServiceMessage;
      //处理登录响应
      if( receivedObject.type === WebsocketServiceMessageType.REGISTER_SUCCESS){
        const wData = receivedObject.payload as wRegisterSuccessPayload;
        if(verifyData == wData){
          EventBus.emit(Event.REGISTER_SUCCESS,wData);
        }else{
          EventBus.emit(Event.REGISTER_FAILED,"Multiple results");
        }
      }else if(receivedObject.type === WebsocketServiceMessageType.REGISTER_FAILURE){
        EventBus.emit(Event.REGISTER_FAILED,(receivedObject.payload as wRegisterFailurePayload));
      }
    });

    const registerInfo:WebSocketClientMessage = {
      type : WebsocketClientMessageType.REGISTER,
      payload:data
    }
    ws.send(registerInfo);
  }catch(e){
    console.error(e);
  }
}