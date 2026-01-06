import {
  AddFriendRequestPayload,
  HttpClientMessage,
  HttpClientMessageType,
  LoadFriendRequestPayload,
  RefuseFriendRequestPayload,
  SearchForUserByIdPayload,
  SearchForUserByUserNamePayload } from "../../core/protocol/http/client.http.protocol";
import { HttpService } from "../../core/service/network/http/server.http";
import { http } from "@kit.NetworkKit";
import { EventBus } from "../../core/service/event/EventBus";
import { Event } from "../../core/tag/Event";
import {
  FriendRequestAcceptedFailedPayload,
  FriendRequestAcceptedPayload,
  FriendRequestAddedFailedPayload,
  FriendRequestAddedPayload,
  FriendRequestLoadedFailedPayload,
  FriendRequestLoadedPayload,
  FriendRequestRefusedFailedPayload,
  FriendRequestRefusedPayload,
  HttpServiceMessage, HttpServiceMessageType } from "../../core/protocol/http/service.http.protocol";
import { AcceptFriendRequestPayload } from "../../core/protocol/http/client.http.protocol";
import { CloudChat } from "../../CloudChat";

export function handleLoadFriendRequest(data: LoadFriendRequestPayload){
  const refuseRequest: HttpClientMessage = {
    type: HttpClientMessageType.LOAD_FRIEND_REQUEST,
    payload: data
  };
  const httpService = CloudChat.httpServer;
  console.log('Send Request:', refuseRequest);
  //发送http请求
  httpService.post('/friend/request/load', refuseRequest, (err: BusinessError, res: http.HttpResponse) => {
    if (err) {
      EventBus.emit(Event.FRIEND_REQUEST_LOADED_FAILED, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;

      if (res.responseCode === 200){
        switch (resultData.type){
          case HttpServiceMessageType.FRIEND_REQUEST_LOADED:
            EventBus.emit(Event.FRIEND_REQUEST_LOADED, resultData.payload as FriendRequestLoadedPayload);
            break;
          case HttpServiceMessageType.FRIEND_REQUEST_LOADED_FAILED:
            EventBus.emit(Event.FRIEND_REQUEST_LOADED_FAILED, (resultData.payload as FriendRequestLoadedFailedPayload).error);
            break;
          default :
            throw new Error("Unknown error");
        }
      } else {
        EventBus.emit(Event.FRIEND_REQUEST_LOADED_FAILED, "Http error code: " + res.responseCode);
      }
    } catch (e) {
      EventBus.emit(Event.FRIEND_REQUEST_LOADED_FAILED, e);
    }
  });
}

export function handleSearchForUsersByName(data: SearchForUserByUserNamePayload) {
  const searchRequest: HttpClientMessage = {
    type: HttpClientMessageType.SEARCH_FOR_USER_BY_NAME,
    payload: data
  };
  sendSearchForUsersRequest('/search/friend/name', searchRequest);
}

export function handleSearchForUsersById(data: SearchForUserByIdPayload) {
  const searchRequest: HttpClientMessage = {
    type: HttpClientMessageType.SEARCH_FOR_USER_BY_ID,
    payload: data
  };
  sendSearchForUsersRequest('/search/friend/id', searchRequest);
}

function sendSearchForUsersRequest(uri: string, request: HttpClientMessage){
  const httpService = CloudChat.httpServer;
  console.log('Send Request:', request);
  //发送http请求
  httpService.post(uri, request, (err: BusinessError, res: http.HttpResponse) => {
    if (err) {
      EventBus.emit(Event.SEARCH_FOR_USERS_FAILED, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;

      if (res.responseCode === 200 && resultData.type === HttpServiceMessageType.SEARCH_FOR_USER_RESULT) {
        EventBus.emit(Event.SEARCH_FOR_USERS_RESULT, resultData.payload);
      } else {
        EventBus.emit(Event.SEARCH_FOR_USERS_FAILED, "Http error code: " + res.responseCode);
      }
    } catch (e) {
      EventBus.emit(Event.SEARCH_FOR_USERS_FAILED, e);
    }
  });
}

export function handleAcceptRequest(data: AcceptFriendRequestPayload){
  const acceptRequest: HttpClientMessage = {
    type: HttpClientMessageType.ACCEPT_FRIEND_REQUEST,
    payload: data
  };

  const httpService = CloudChat.httpServer;
  console.log('Send Request:', acceptRequest);
  //发送http请求
  httpService.post('/friend/request/accept', acceptRequest, (err: BusinessError, res: http.HttpResponse) => {
    if (err) {
      EventBus.emit(Event.FRIEND_REQUEST_ERROR, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;

      if (res.responseCode === 200) {
        switch (resultData.type) {
          case HttpServiceMessageType.FRIEND_REQUEST_ACCEPTED:
            EventBus.emit(Event.FRIEND_REQUEST_ACCEPTED, resultData.payload as FriendRequestAcceptedPayload);
            break;
          case HttpServiceMessageType.FRIEND_REQUEST_ACCEPTED_FAILED:
            EventBus.emit(Event.FRIEND_REQUEST_ERROR, (resultData.payload as FriendRequestAcceptedFailedPayload).error);
            break;
          default:
            throw new Error("Unknown error");
        }
      }
    } catch (e) {
      EventBus.emit(Event.FRIEND_REQUEST_ERROR, e);
    }
  });
}

export function handleRefuseRequest(data: RefuseFriendRequestPayload){
  const refuseRequest: HttpClientMessage = {
    type: HttpClientMessageType.REFUSE_FRIEND_REQUEST,
    payload: data
  };
  const httpService = CloudChat.httpServer;
  console.log('Send Request:', refuseRequest);
  //发送http请求
  httpService.post('/friend/request/refuse', refuseRequest, (err: BusinessError, res: http.HttpResponse) => {
    if (err) {
      EventBus.emit(Event.FRIEND_REQUEST_ERROR, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;

      if (res.responseCode === 200){
        switch (resultData.type){
          case HttpServiceMessageType.FRIEND_REQUEST_REFUSED:
            EventBus.emit(Event.FRIEND_REQUEST_REFUSED, resultData.payload as FriendRequestRefusedPayload);
            break;
          case HttpServiceMessageType.FRIEND_REQUEST_REFUSED_FAILED:
            EventBus.emit(Event.FRIEND_REQUEST_ERROR, (resultData.payload as FriendRequestRefusedFailedPayload).error);
            break;
          default :
            throw new Error("Unknown error");
        }
      } else {
        EventBus.emit(Event.FRIEND_REQUEST_ERROR, "Http error code: " + res.responseCode);
      }
    } catch (e) {
      EventBus.emit(Event.FRIEND_REQUEST_ERROR, e);
    }
  });
}

export function handlePostFriendRequest(data: AddFriendRequestPayload){
  const refuseRequest: HttpClientMessage = {
    type: HttpClientMessageType.ADD_FRIEND_REQUEST,
    payload: data
  };
  const httpService = CloudChat.httpServer;
  console.log('Send Request:', refuseRequest);
  //发送http请求
  httpService.post('/friend/request/add', refuseRequest, (err: BusinessError, res: http.HttpResponse) => {
    if (err) {
      EventBus.emit(Event.FRIEND_REQUEST_ERROR, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;

      if (res.responseCode === 200){
        switch (resultData.type){
          case HttpServiceMessageType.FRIEND_REQUEST_ADDED:
            EventBus.emit(Event.FRIEND_REQUEST_ADDED, resultData.payload as FriendRequestAddedPayload);
            break;
          case HttpServiceMessageType.FRIEND_REQUEST_ADDED_FAILED:
            EventBus.emit(Event.FRIEND_REQUEST_ERROR, (resultData.payload as FriendRequestAddedFailedPayload).error);
            break;
          default :
            throw new Error("Unknown error");
        }
      }
    } catch (e) {
      EventBus.emit(Event.FRIEND_REQUEST_ERROR, e);
    }
  });
}