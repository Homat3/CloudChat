import {Injectable} from '@angular/core';
import {Message} from '../models';
import {ResponseService} from './response.service';
import {BehaviorSubject, Observable} from 'rxjs';
import {AuthService} from './auth.service';
import {SendMessagePayload} from '../protocol/client.protocol';
import {ContactService} from './contact.service';
import {RequestService} from './request.service';

@Injectable({
  providedIn: 'root'
})
export class MessageService {
  public isReady$: Observable<boolean>;

  private messageMapSubject: BehaviorSubject<Map<number, Message[]>> = new BehaviorSubject(new Map)
  public messageMap$ = this.messageMapSubject.asObservable();

  private messagesWaitingForEmit: Map<string, {
    tempId: string,
    senderId: number,
    receiverId: number,
    content: string,
    type: 'text' | 'image' | 'file'
  }> = new Map();

  constructor(
    private reqestService: RequestService,
    private responseService: ResponseService,
    private authService: AuthService,
    private contactService: ContactService
  ) {
    this.responseService.messagesLoaded$.subscribe(payload => {
      if (this.authService.currentUserValue){
        let oldMessageMap = this.messagesMapValue;
        let newMessageMap = oldMessageMap == null ? new Map<number, Message[]>() : oldMessageMap;
        payload.messages.forEach(message => {
          const contactId = message.receiverId == this.authService.currentUserValue?.userId ? message.senderId : message.receiverId;
          newMessageMap.set(contactId, [...(newMessageMap.get(contactId) || []), message]);
        })
        this.messageMapSubject.next(newMessageMap);
      }
    });

    this.responseService.messageReceivedSelf$.subscribe(payload => {if (this.authService.currentUserValue){
      let newMessageMap = this.messagesMapValue;
      if (newMessageMap){
        let newMessage = this.messagesWaitingForEmit.get(payload.tempId);
        if (newMessage) {
          let currentMessageList = newMessageMap.get(newMessage.receiverId);
          if (currentMessageList) {
            currentMessageList.push({
              id: payload.id,
              senderId: newMessage.senderId,
              receiverId: newMessage.receiverId,
              content: newMessage.content,
              timestamp: payload.timestamp,
              status: 'sent',
              type: newMessage.type
            });
            newMessageMap.set(newMessage.receiverId, currentMessageList);
          }
          else {
            newMessageMap.set(newMessage.receiverId, [
              {
                id: payload.id,
                senderId: newMessage.senderId,
                receiverId: newMessage.receiverId,
                content: newMessage.content,
                timestamp: payload.timestamp,
                status: 'sent',
                type: newMessage.type
              }
            ])
          }
        }
        else {
          console.error("消息发送超时")
          this.responseService.messageSendFailed$.next({tempId: payload.tempId, error: "消息发送超时"});
        }
        this.messageMapSubject.next(newMessageMap);
      }
      else {
        console.error("消息列表解析失败")
      }
    }
    });

    this.responseService.messageReceivedOther$.subscribe(payload => { if (this.authService.currentUserValue) {
      let newMessageMap = this.messagesMapValue;
      if (newMessageMap) {
        let newMessage : Message ={
          id: payload.id,
          senderId: payload.senderId,
          receiverId: payload.receiverId,
          content: payload.content,
          timestamp: payload.timestamp,
          status: payload.status,
          type: payload.type
        };
        let currentMessageList = newMessageMap.get(newMessage.senderId);
        if (currentMessageList) {
          currentMessageList.push(newMessage);
          newMessageMap.set(newMessage.senderId, currentMessageList);
        }
        else {
          newMessageMap.set(newMessage.senderId, [newMessage]);
        }
        this.messageMapSubject.next(newMessageMap);

        const currentContact = this.contactService.getCurrentContact();
        if (currentContact) {
          if (currentContact.contactId === newMessage.senderId) {
            this.markRead(newMessage.senderId);
          }
        }
      } else {
        console.error("消息列表解析失败")
      }
    }
    });

    this.isReady$ = this.responseService.isReady$;
  }

  public get messagesMapValue(): Map<number, Message[]> | null {
    return this.messageMapSubject.value;
  }

  public putWaitingMessage(message: {
    tempId: string,
    senderId: number,
    receiverId: number,
    content: string,
    type: 'text' | 'image' | 'file'
  }){
    this.messagesWaitingForEmit.set(message.tempId, message)
    setTimeout(() => {
      this.messagesWaitingForEmit.delete(message.tempId)
    }, 5000);
  }

  public markRead(targetId: number) {
    if (this.messagesMapValue && this.authService.currentUserValue){
      this.reqestService.markRead({userId: this.authService.currentUserValue.userId, targetId: targetId});
      this.messagesMapValue.get(targetId)?.forEach(message => {
        if (message.status != 'read' && message.senderId == targetId) {
          message.status = 'read';
        }
      })
      this.messageMapSubject.next(this.messagesMapValue);
    }
  }
}
