import {
  DeleteContactPayload,
  HttpClientMessage,
  HttpClientMessageType,
  LoadContactsPayload } from '../../core/protocol/http/client.http.protocol';
import { HttpService } from '../../core/service/network/http/server.http';
import { http } from '@kit.NetworkKit';
import {
  ContactDeletedFailedPayload,
  ContactDeletedPayload,
  ContactsLoadedFailedPayload,
  ContactsLoadedPayload,
  HttpServiceMessage, HttpServiceMessageType } from '../../core/protocol/http/service.http.protocol';
import { CloudChat } from '../../CloudChat';
import { EventBus } from '../../core/service/event/EventBus';
import { Event } from '../../core/tag/Event';

export function handleLoadContacts(data: LoadContactsPayload) {
  const httpService = CloudChat.httpServer;
  const loginRequest: HttpClientMessage ={
    type : HttpClientMessageType.LOAD_CONTACTS,
    payload : data
  };

  console.log('Send Request:',loginRequest);
  //发送http请求
  httpService.post('/load/contacts', loginRequest, (err: BusinessError, res: http.HttpResponse)=>{
    if(err){
      EventBus.emit(Event.CONTACT_LIST_LOAD_FAILED, { error: err.message } as ContactsLoadedFailedPayload);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;
      console.log('Password_login Response:', resultData);

      if (res.responseCode === 200) {
        switch (resultData.type){
          case HttpServiceMessageType.CONTACTS_LOADED:
            const result = resultData.payload as ContactsLoadedPayload
            CloudChat.contacts = result.contacts;
            EventBus.emit(Event.CONTACT_LIST_LOADED, result);
            break;
          case HttpServiceMessageType.CONTACTS_LOADED_FAILED:
            EventBus.emit(Event.CONTACT_LIST_LOAD_FAILED, resultData.payload as ContactsLoadedFailedPayload);
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

export function handleDeleteContact(data: DeleteContactPayload){
  const httpService = CloudChat.httpServer;
  const loginRequest: HttpClientMessage ={
    type : HttpClientMessageType.DELETE_CONTACT,
    payload : data
  };

  console.log('Send Request:',loginRequest);
  //发送http请求
  httpService.post('/delete/contacts', loginRequest, (err: BusinessError, res: http.HttpResponse)=>{
    if(err){
      EventBus.emit(Event.CONTACT_DELETED_FAILED, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;
      console.log('Password_login Response:', resultData);

      if (res.responseCode === 200) {
        switch (resultData.type){
          case HttpServiceMessageType.CONTACT_DELETED:
            const result = resultData.payload as ContactDeletedPayload
            EventBus.emit(Event.CONTACT_DELETED, result);
            break;
          case HttpServiceMessageType.CONTACT_DELETED_FAILED:
            EventBus.emit(Event.CONTACT_DELETED_FAILED, resultData.payload as ContactDeletedFailedPayload);
            break;
          default:
            throw new Error("Unknown error");
        }
      }
    } catch (e) {
      EventBus.emit(Event.CONTACT_DELETED_FAILED, e);
    }
  });
}