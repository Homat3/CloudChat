// pages/contact-list/ContactList.ets
import { ContactSidebar } from './components/ContactSidebar';
import { ChatArea } from './components/ChatArea';
import { DetailPanel } from './components/DetailPanel';
import { common } from '@kit.AbilityKit';
import { Contact, User } from '../../core/models/models';
import { Message } from '../../core/models/message';
import { CloudChat } from '../../CloudChat';
import { Event } from '../../core/tag/Event';
import { EventBus } from '../../core/service/event/EventBus';

@Entry
@Component
struct ContactList {
  // 状态变量
  @State selectedContact: Contact | null = null;
  @State selectedMessage: Message | null = null;
  @State searchKeyword: string = '';
  @State curUser:User | null = null ;
  @State isPanelFolded : boolean = true//是否选择折叠
  @State showAddContact: boolean = false;
  @State messagesMap: Map<number, Message[]> | null = null;

  @State contacts: Contact[] = [];
  @State filteredContacts: Array<Contact> = [];
  @State isLoading: boolean = true;

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  // 添加页面生命周期
  aboutToAppear() {
    console.log('ContactList 页面加载了');

    //获取当前用户
    this.curUser = CloudChat.currentUser;
    this.messagesMap = CloudChat.messageMap;

    //注册监听
    try {
      EventBus.on(Event.CONTACT_LIST_LOADED, this.catchContacts);
      EventBus.on(Event.CONTACT_LIST_LOAD_FAILED, this.loadContactsFailed);

      EventBus.on(Event.REFRESH_CONTACT_LIST, this.loadContacts);
      EventBus.on(Event.SEND_MESSAGE, this.sendMessage);
      EventBus.on(Event.CONTACT_CHANGED, this.contactChanged);
    } catch (error) {
      console.error(error);
    }

    //加载数据
    this.loadContacts();
  }

  catchContacts(){
    this.contacts = CloudChat.contacts;
    this.isLoading = false;
    try {
      this.uiContext.getPromptAction().showToast({
        message: $r("app.string.text_contactList_ContactListPageLoaded"),
        duration: 2000
      });
    } catch (error) {
      console.error(error);
    }
    this.isLoading = false;
  }

  loadContactsFailed(){
    try {
      this.uiContext.getPromptAction().showToast({ message: $r("app.string.error_contactList_ContactListLoadFailed") });
    } catch (error) {
      console.error(error);
    }
  }

  loadContacts() {
    this.isLoading = true;
    EventBus.emit(Event.LOAD_CONTACT_LIST);
    EventBus.emit(Event.LOAD_MESSAGES);
  }

  sendMessage(message: string){
    // TODO
  }

  contactChanged(contact: Contact){
    this.selectedContact = contact;
  }

  //三栏布局
  build() {
    Row(){
      //左侧联系人栏
      ContactSidebar({
        contacts: this.contacts,
        selectedContact: this.selectedContact,
        searchKeyword: this.searchKeyword
      })
        .width('25%')
        .height('100%')
        .border({ width: { right: 1 }, color: $r('app.color.list_divider') })

      //中间区域
      ChatArea({
        currentUser: this.curUser,
        //messagesMap: this.messagesMap,
        selectedContact: this.selectedContact,
        selectedMessage: this.selectedMessage
      })
        .layoutWeight(1)
        .height('100%')

      Column(){
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          // 使用文本替代图标，确保无资源也能运行
          Text('D')
            .fontSize(20)
            .fontColor($r('app.color.secondary_text'))
            .fontWeight(FontWeight.Lighter)
        }
        .width(32)
        .height(32)
        .backgroundColor(Color.Transparent)
        .margin(12)
        .onClick(() => this.isPanelFolded = !this.isPanelFolded)
        if(!this.isPanelFolded){
          DetailPanel({
            selectedContact: this.selectedContact,
            selectedMessage: this.selectedMessage
          })
            .width('20%')
            .height('100%')
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.contact_list_whole_background'))
  }
}