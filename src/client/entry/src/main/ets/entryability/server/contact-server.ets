import { common } from '@kit.AbilityKit';
import { HttpClientMessage,
  HttpClientMessageType,
  LoadContactsPayload } from '../../core/protocol/http/client.http.protocol';
import { HttpService } from '../../core/service/network/http/server.http';
import { http } from '@kit.NetworkKit';
import {
  ContactsLoadedFailedPayload,
  ContactsLoadedPayload,
  HttpServiceMessage, HttpServiceMessageType } from '../../core/protocol/http/service.http.protocol';
import { CloudChat } from '../../CloudChat';
import { EventBus } from '../../core/service/event/EventBus';
import { Event } from '../../core/service/event/Event';

export function handleLoadContacts(context: common.UIAbilityContext, data: LoadContactsPayload) {
  const httpService = new HttpService("cloudchat.infinomat.com", "14514", false);
  const loginRequest: HttpClientMessage ={
    type : HttpClientMessageType.LOAD_CONTACTS,
    payload : data
  };

  console.log('Send Request:',loginRequest);
  //发送http请求
  httpService.post('/load/contacts', loginRequest, (err: BusinessError, res: http.HttpResponse)=>{
    if(err){
      EventBus.emit(Event.CONTACT_LIST_LOAD_FAILED, err.message);
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