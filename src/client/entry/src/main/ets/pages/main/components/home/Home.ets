import { Message } from '../../../../core/models/message';
import { Contact, User } from '../../../../core/models/models';
import { common } from '@kit.AbilityKit';
import { CloudChat } from '../../../../CloudChat';
import { EventBus } from '../../../../core/service/event/EventBus';
import { Event } from '../../../../core/tag/Event';
import { ContactList } from './contact/ContactList';
import { LoadContactsPayload, LoadMessagesPayload } from '../../../../core/protocol/http/client.http.protocol';
import { ContactsLoadedFailedPayload } from '../../../../core/protocol/http/service.http.protocol';
import { Page } from '../../../../core/tag/Page';
import { ChatArea } from '../chat/ChatArea';

@Component
export struct Home {
  // 状态变量
  @State @Watch("onSwitchToChatArea") selectedContact: Contact | null = null;
  @State selectedMessages: Message[] | null = null;
  @State searchKeyword: string = '';
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
    console.log('ContactList 页面加载了');

    //注册监听
    try {
      EventBus.on(Event.CONTACT_LIST_LOADED, (): void => this.catchContacts());
      EventBus.on(Event.CONTACT_LIST_LOAD_FAILED, (payload: ContactsLoadedFailedPayload): void => this.loadContactsFailed(payload));

      EventBus.on(Event.MESSAGES_LOADED, (): void => this.catchMessages());
      EventBus.on(Event.MESSAGES_LOADED_FAILED, (msg: string): void => this.loadMessagesFailed(msg));

      EventBus.on(Event.OPEN_CHAT_AREA, (): void => {
        if (this.selectedContact){
          const messageList = this.messagesMap?.get(this.selectedContact?.contactId);
          if (messageList) {
            this.selectedMessages = messageList;
          }
        }
        this.isChatAreaOpen = true
      });

      EventBus.on(Event.REFRESH_CONTACT_LIST, (): void => this.loadContacts());

      EventBus.on(Event.SEND_MESSAGE, (message: string): void => this.sendMessage(message));
    } catch (error) {
      console.error(error);
    }

    //加载数据
    this.loadContacts();
  }

  catchContacts(){
    this.contacts = CloudChat.contacts;
    try {
      this.uiContext.getPromptAction().showToast({
        message: $r("app.string.text_contactList_ContactListPageLoaded"),
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
      this.uiContext.getPromptAction().showToast({ message: $r("app.string.error_contactList_ContactListLoadFailed") + ": " + payload.error });
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
      this.uiContext.getPromptAction().showToast({ message: $r("app.string.error_contactList_ContactListLoadFailed") + ": " + msg });
    } catch (error) {
      console.error(error);
    }
  }

  sendMessage(message: string){
    // TODO
  }

  build(){
    if (this.isChatAreaOpen && this.currentUser && this.selectedContact && this.selectedMessages){
      ChatArea({
        currentUser: this.currentUser,
        selectedContact: this.selectedContact,
        messages: this.selectedMessages
      })
    }
    else {
      ContactList({
        contacts: this.contacts ? this.contacts : [],
        selectedContact: this.selectedContact,
        searchKeyword: this.searchKeyword
      })
        .width('100%')
        .height('100%')
        .border({ width: { right: 1 }, color: $r('app.color.list_divider') })
    }
  }
}