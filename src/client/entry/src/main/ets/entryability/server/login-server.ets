import { HttpClientMessage,
  HttpClientMessageType,
  LoginByTokenPayload as hLoginByTokenPayload,
  LoginPayload as hLoginPayload } from "../../core/protocol/http/client.http.protocol";
import { HttpService } from "../../core/service/network/http/server.http";
import { common } from '@kit.AbilityKit';
import { Event } from "../manager/call-back-manager/CallBackManager"
import {
  HttpServiceMessage,
  HttpServiceMessageType,
  LoginSuccessPayload as hLoginSuccessPayload } from "../../core/protocol/http/service.http.protocol";
import { http } from "@kit.NetworkKit";
import { WebsocketService } from "../../core/service/network/websocket/server.websocket";
import {
  LoginFailurePayload as wLoginFailurePayload,
  LoginSuccessPayload as wLoginSuccessPayload,
  WebsocketServiceMessage,
  WebsocketServiceMessageType } from "../../core/protocol/websocket/service.websocket.protocol";
import {
  LoginPayload as wLoginPayload,
  WebSocketClientMessage,
  LoginByTokenPayload as wLoginByTokenPayload,
  WebsocketClientMessageType } from "../../core/protocol/websocket/client.websocket.protocol";

export function handleLogin(context: common.UIAbilityContext, data: hLoginPayload) {
  const httpService = new HttpService("cloudchat.infinomat.com", "14514", false);
  const loginRequest: HttpClientMessage ={
    type : HttpClientMessageType.LOGIN,
    payload : data
  };

  console.log('Send Request:',loginRequest);
  //发送http请求
  httpService.post('/login', loginRequest, (err: BusinessError, res: http.HttpResponse)=>{
    if(err){
      context.eventHub.emit(Event.LOGIN_FAILED, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;
      console.log('Password_login Response:', resultData);

      if (res.responseCode === 200 && resultData.type === HttpServiceMessageType.LOGIN_SUCCESS) {
        websocketNormalVerify(context, data as wLoginPayload, resultData.payload as hLoginSuccessPayload)
      }
    } catch (e) {
      context.eventHub.emit(Event.LOGIN_FAILED, e);
    }
  });
}

function websocketNormalVerify(context: common.UIAbilityContext, data: wLoginPayload, verifyData: hLoginSuccessPayload){
  const ws = new WebsocketService("cloudchat.infinomat.com", "14514");
  try {
    ws.connect();
    ws.addNewMessageObserver((msg) => {
      //控制台响应
      console.log("Received: " + msg);
      let receivedObject = JSON.parse(msg) as WebsocketServiceMessage;
      //处理登录相应
      if( receivedObject.type === WebsocketServiceMessageType.LOGIN_SUCCESS) {
        const wData = receivedObject.payload as wLoginSuccessPayload;
        if (verifyData == wData){
          context.eventHub.emit(Event.LOGIN_SUCCESS, wData);
        } else {
          context.eventHub.emit(Event.LOGIN_FAILED, "Multiple results");
        }
      } else if(receivedObject.type === WebsocketServiceMessageType.LOGIN_FAILURE) {
        context.eventHub.emit(Event.LOGIN_FAILED, (receivedObject.payload as wLoginFailurePayload).error);
      }
    });

    const loginInfo: WebSocketClientMessage = {
      type: WebsocketClientMessageType.LOGIN,
      payload: data
    }
    ws.send(loginInfo);
  } catch(e) {
    console.error(e);
    context.eventHub.emit(Event.LOGIN_FAILED, "Failed to connect the service");
  }
}

//执行令牌登录
export function handleLoginByToken(context: common.UIAbilityContext, data: hLoginByTokenPayload): void{
  const httpService = new HttpService("cloudchat.infinomat.com", "14514", false);
  const loginRequest: HttpClientMessage ={
    type : HttpClientMessageType.LOGIN_BY_TOKEN,
    payload : data
  };

  console.log('Send Request:',loginRequest);
  //发送http请求
  httpService.post('/login', loginRequest, (err: BusinessError, res: http.HttpResponse)=>{
    if(err){
      context.eventHub.emit(Event.LOGIN_FAILED, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;
      console.log('Password_login Response:', resultData);

      if (res.responseCode === 200 && resultData.type === HttpServiceMessageType.LOGIN_SUCCESS) {
        websocketTokenVerify(context, data as wLoginByTokenPayload, resultData.payload as hLoginSuccessPayload)
      }
    } catch (e) {
      context.eventHub.emit(Event.LOGIN_FAILED, e);
    }
  });
}

function websocketTokenVerify(context: common.UIAbilityContext, data: wLoginByTokenPayload, verifyData: hLoginSuccessPayload){
  const ws = new WebsocketService("cloudchat.infinomat.com", "14514");
  try {
    ws.connect();
    ws.addNewMessageObserver((msg) => {
      //控制台响应
      console.log("Received: " + msg);
      let receivedObject = JSON.parse(msg) as WebsocketServiceMessage;
      //处理登录相应
      if( receivedObject.type === WebsocketServiceMessageType.LOGIN_SUCCESS) {
        const wData = receivedObject.payload as wLoginSuccessPayload;
        if (verifyData == wData){
          context.eventHub.emit(Event.LOGIN_SUCCESS, wData);
        } else {
          context.eventHub.emit(Event.LOGIN_FAILED, "Multiple results");
        }
      } else if(receivedObject.type === WebsocketServiceMessageType.LOGIN_FAILURE) {
        context.eventHub.emit(Event.LOGIN_FAILED, (receivedObject.payload as wLoginFailurePayload).error);
      }
    });

    const loginInfo: WebSocketClientMessage = {
      type: WebsocketClientMessageType.LOGIN_BY_TOKEN,
      payload: data
    }
    ws.send(loginInfo);
  } catch(e) {
    console.error(e);
    context.eventHub.emit(Event.LOGIN_FAILED, "Failed to connect the service");
  }
}