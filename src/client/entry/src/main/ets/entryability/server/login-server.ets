import {
  LoginByTokenPayload as hLoginByTokenPayload,
  HttpClientMessage,
  HttpClientMessageType,
  LoginPayload
} from '../../core/protocol/http/client.http.protocol';
import { HttpService } from '../../core/service/network/http/server.http';
import {
  LoginFailurePayload as hLoginFailurePayload,
  LoginSuccessPayload as hLoginSuccessPayload,
  HttpServiceMessage,
  HttpServiceMessageType,
  LoginFailurePayload
} from '../../core/protocol/http/service.http.protocol';
import { http } from '@kit.NetworkKit';
import { WebsocketService } from '../../core/service/network/websocket/server.websocket';
import {
  HdlGotPayload,
  LoginSuccessPayload,
  WebsocketServiceMessage,
  WebsocketServiceMessageType
} from '../../core/protocol/websocket/service.websocket.protocol';
import {
  HdlInfoPayload,
  WebSocketClientMessage,
  WebsocketClientMessageType
} from '../../core/protocol/websocket/client.websocket.protocol';
import { Event } from '../../core/tag/Event';
import { EventBus } from '../../core/service/event/EventBus';
import { CloudChat } from '../../CloudChat';

export function handleLogin(data: LoginPayload) {
  const httpService = CloudChat.httpServer;
  const loginRequest: HttpClientMessage = {
    type: HttpClientMessageType.LOGIN,
    payload: data
  };

  console.log('Send Request:', loginRequest);
  //发送http请求
  httpService.post('/login', loginRequest, (err: BusinessError, res: http.HttpResponse) => {
    if (err) {
      EventBus.emit(Event.LOGIN_FAILED, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;
      console.log('Password_login Response:', resultData);

      if (res.responseCode === 200) {
        switch (resultData.type) {
          case HttpServiceMessageType.LOGIN_SUCCESS:
            const successData = resultData.payload as LoginSuccessPayload;
            websocketNormalVerify({ userId: successData.userId }, successData);
            break;
          case HttpServiceMessageType.LOGIN_FAILURE:
            EventBus.emit(Event.LOGIN_FAILED, (resultData.payload as LoginFailurePayload).error);
            break;
          default:
            throw new Error("Unknown error");
        }
      } else {
        EventBus.emit(Event.LOGIN_FAILED, "Http error code: " + res.responseCode);
      }
    } catch (e) {
      EventBus.emit(Event.LOGIN_FAILED, e);
    }
  });
}

function websocketNormalVerify(data: HdlInfoPayload, verifyData: LoginSuccessPayload) {
  const ws = CloudChat.websocketServer;
  try {
    ws.addMessageObserver((msg) => {
      //控制台响应
      console.log("Received: " + msg);
      let receivedObject = JSON.parse(msg) as WebsocketServiceMessage;
      //处理登录相应
      if (receivedObject.type === WebsocketServiceMessageType.HDL_GOT) {
        if ((receivedObject.payload as HdlGotPayload).userId === verifyData.userId) {
          EventBus.emit(Event.LOGIN_SUCCESS, verifyData);
        } else {
          EventBus.emit(Event.LOGIN_FAILED, "Multiple Id");
        }
      }
    });

    const hdlInfo: WebSocketClientMessage = {
      type: WebsocketClientMessageType.HDL_INFO,
      payload: data
    }
    ws.send(hdlInfo);
  } catch (e) {
    EventBus.emit(Event.LOGIN_FAILED, e);
  }
}

//执行令牌登录
export function handleLoginByToken(data: hLoginByTokenPayload): void {
  const httpService = CloudChat.httpServer;
  const loginRequest: HttpClientMessage = {
    type: HttpClientMessageType.LOGIN_BY_TOKEN,
    payload: data
  };

  console.log('Send Request:', loginRequest);
  //发送http请求
  httpService.post('/login', loginRequest, (err: BusinessError, res: http.HttpResponse) => {
    if (err) {
      EventBus.emit(Event.LOGIN_FAILED, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;
      console.log('Token_login Response:', resultData);

      if (res.responseCode === 200) {
        switch (resultData.type) {
          case HttpServiceMessageType.LOGIN_SUCCESS:
            const successData = resultData.payload as hLoginSuccessPayload;
            websocketTokenVerify({ userId: successData.userId }, successData);
            break;
          case HttpServiceMessageType.LOGIN_FAILURE:
            EventBus.emit(Event.LOGIN_FAILED, (resultData.payload as hLoginFailurePayload).error);
            break;
          default:
            throw new Error("Unknown error");
        }
      }
    } catch (e) {
      EventBus.emit(Event.LOGIN_FAILED, e);
    }
  });
}

function websocketTokenVerify(data: HdlInfoPayload, verifyData: hLoginSuccessPayload) {
  const ws = CloudChat.websocketServer;
  try {
    ws.addMessageObserver((msg) => {
      //控制台响应
      console.log("Received: " + msg);
      let receivedObject = JSON.parse(msg) as WebsocketServiceMessage;
      //处理登录相应
      if (receivedObject.type === WebsocketServiceMessageType.HDL_GOT) {
        if ((receivedObject.payload as HdlGotPayload).userId === verifyData.userId) {
          EventBus.emit(Event.LOGIN_SUCCESS, verifyData);
        } else {
          EventBus.emit(Event.LOGIN_FAILED, "Multiple Id");
        }
      }
    });

    const loginInfo: WebSocketClientMessage = {
      type: WebsocketClientMessageType.HDL_INFO,
      payload: data
    }
    ws.send(loginInfo);
  } catch (e) {
    EventBus.emit(Event.LOGIN_FAILED, e);
  }
}