import { Home } from './components/home/Home';
import { ContactRequest } from './components/contact-request/ContactRequest';
import { OwnPage } from './components/own/OwnPage';
import { EventBus } from '../../core/service/event/EventBus';
import { Event } from '../../core/tag/Event';
import { ChatArea } from './components/chat/ChatArea';
import { Message } from '../../core/models/message';
import { Contact, User } from '../../core/models/models';
import { CloudChat } from '../../CloudChat';
import { ContactsLoadedFailedPayload } from '../../core/protocol/http/service.http.protocol';
import { common } from '@kit.AbilityKit';
import { LoadContactsPayload, LoadMessagesPayload } from '../../core/protocol/http/client.http.protocol';
import {
  MessageReceivedOtherPayload,
  WebsocketServiceMessage,
  WebsocketServiceMessageType } from '../../core/protocol/websocket/service.websocket.protocol';

@Entry
@Component
struct MainContainer {
  @State currentIndex : number = 0;

  @State @Watch("onSwitchToChatArea") selectedContact: Contact | null = null;
  @State selectedMessages: Message[] | null = null;
  @State currentUser: User | null = CloudChat.currentUser;
  @State contacts: Contact[] | null = null;
  @State messagesMap: Map<number, Message[]> | null = null;

  @State isLoading: boolean = true;
  @State isChatAreaOpen: boolean = false;

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  onSwitchToChatArea(){
    EventBus.emit(Event.OPEN_CHAT_AREA);
  }

  // 添加页面生命周期
  aboutToAppear() {
    console.log('Main 页面加载');

    //注册监听
    try {
      EventBus.on(Event.CONTACT_LIST_LOADED, (): void => this.catchContacts());
      EventBus.on(Event.CONTACT_LIST_LOAD_FAILED, (payload: ContactsLoadedFailedPayload): void => this.loadContactsFailed(payload));

      EventBus.on(Event.MESSAGES_LOADED, (): void => this.catchMessages());
      EventBus.on(Event.MESSAGES_LOADED_FAILED, (msg: string): void => this.loadMessagesFailed(msg));

      EventBus.on(Event.SEND_MESSAGE_SUCCESS, (message: Message): void => {
        if (this.messagesMap){
          let changedMessageList = this.messagesMap.get(message.receiverId);
          if (changedMessageList) {
            changedMessageList.push(message);
          }
          else {
            changedMessageList = [message];
          }
          this.messagesMap.set(message.receiverId, changedMessageList);
          if (this.selectedContact?.contactId === message.receiverId){
            this.selectedMessages = changedMessageList;
          }
        }
      })
      EventBus.on(Event.SEND_MESSAGE_FAILED, (e: string): void => {
        try {
          this.uiContext.getPromptAction().showToast({
            message: "消息发送失败：" + e,
            duration: 2000
          });
        } catch (error) {
          console.error(error);
        }
      })
      EventBus.on(Event.RECEIVE_MESSAGE, (payload: MessageReceivedOtherPayload): void => {
        const message = payload as Message;
        if (this.messagesMap){
          let changedMessageList = this.messagesMap.get(message.senderId);
          if (changedMessageList) {
            changedMessageList.push(message);
          }
          else {
            changedMessageList = [message];
          }
          this.messagesMap.set(message.senderId, changedMessageList);
          if (this.selectedContact?.contactId === message.senderId){
            this.selectedMessages = changedMessageList;
          }
        }
      })

      EventBus.on(Event.OPEN_CHAT_AREA, (): void => {
        if (this.selectedContact){
          const messageList = this.messagesMap?.get(this.selectedContact?.contactId);
          if (messageList) {
            this.selectedMessages = messageList;
          }
        }
        this.isChatAreaOpen = true;
      });
      EventBus.on(Event.CLOSE_CHAT_AREA, (): void => {
        this.isChatAreaOpen = false;
      })

      EventBus.on(Event.REFRESH_CONTACT_LIST, (): void => this.loadContacts());
    } catch (error) {
      console.error(error);
    }

    CloudChat.websocketServer.addMessageObserver((msg: string) => {
      //控制台响应
      console.log("Received: " + msg);
      let receivedObject = JSON.parse(msg) as WebsocketServiceMessage;
      //处理响应
      switch (receivedObject.type) {
        case WebsocketServiceMessageType.MESSAGE_RECEIVED_OTHER: {
          const payload = receivedObject.payload as MessageReceivedOtherPayload;
          EventBus.emit(Event.RECEIVE_MESSAGE, payload);
          break;
        }
      }
    })
    //加载数据
    this.loadContacts();
  }

  catchContacts(){
    this.contacts = CloudChat.contacts;
    try {
      this.uiContext.getPromptAction().showToast({
        message: $r("app.string.text_mainContainer_Loaded"),
        duration: 2000
      });
    } catch (error) {
      console.error(error);
    }
    this.loadMessages();
    this.isLoading = false;
  }

  loadContactsFailed(payload: ContactsLoadedFailedPayload){
    try {
      this.uiContext.getPromptAction().showToast({ message: $r("app.string.error_mainContainer_LoadFailed") + ": " + payload.error });
    } catch (error) {
      console.error(error);
    }
  }

  loadContacts() {
    this.isLoading = true;
    EventBus.emit(Event.LOAD_CONTACT_LIST, { userId: this.currentUser?.userId } as LoadContactsPayload);
  }

  loadMessages() {
    if(this.contacts){
      EventBus.emit(Event.LOAD_MESSAGES_START, this.contacts.length);
      for (const contact of this.contacts){
        EventBus.emit(Event.LOAD_MESSAGES, { userId: this.currentUser?.userId, targetId: contact.contactId } as LoadMessagesPayload);
      }
    }
  }

  catchMessages(){
    this.messagesMap = CloudChat.messageMap;
  }

  loadMessagesFailed(msg: string){
    try {
      this.uiContext.getPromptAction().showToast({ message: $r("app.string.error_mainContainer_LoadFailed") + ": " + msg });
    } catch (error) {
      console.error(error);
    }
  }


  //导航栏
  build() {
    if (this.isChatAreaOpen && this.currentUser && this.selectedContact && this.selectedMessages){
      ChatArea({
        currentUser: this.currentUser,
        selectedContact: this.selectedContact,
        messages: this.selectedMessages
      })
    }
    else {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        TabContent() {
          Home({
            selectedContact: this.selectedContact,
            selectedMessages: this.selectedMessages,
            currentUser: this.currentUser,
            contacts: this.contacts,
            messagesMap: this.messagesMap,
          })
        }.tabBar($r('app.string.text_MainContainer_homePage'));

        TabContent() {
          ContactRequest({
            currentUser: this.currentUser
          })
        }.tabBar($r('app.string.text_MainContainer_contactRequest'));

        TabContent() {
          OwnPage()
        }.tabBar($r('app.string.text_MainContainer_ownPage'));
      }
      .width('100%')
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .width('100%')
    }
  }
}