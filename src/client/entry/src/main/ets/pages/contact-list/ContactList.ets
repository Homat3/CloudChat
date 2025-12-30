// pages/contact-list/ContactList.ets
import { ContactSidebar } from './components/ContactSidebar';
import { ChatArea } from './components/ChatArea';
import { DetailPanel } from './components/DetailPanel';
import { common } from '@kit.AbilityKit';
import { Contact, User } from '../../core/models/models';
import { Message } from '../../core/models/message';
import { CloudChat } from '../../CloudChat';
import { CallBackManager, Event } from '../../core/manager/call-back-manager/CallBackManager';

@Entry
@Component
struct ContactList {
  // 状态变量
  @State selectedContact: Contact | null = null;
  @State selectedMessage: Message | null = null;
  @State searchKeyword: string = '';
  @State curUser:User | null = null ;
  @State isPanelFolded : boolean = false//是否选择折叠
  @State showAddContact: boolean = false;

  @State contacts: Contact[] = [];
  @State messages: Map<number, Message[]> = new Map();
  @State filteredContacts: Array<Contact> = [];
  @State isLoading: boolean = true;

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;
  // 管理器
  private callBackManager: CallBackManager = new CallBackManager(this.uiAbilityContext.eventHub);   // call back 管理器

  // 添加页面生命周期
  aboutToAppear() {
    console.log('ContactList 页面加载了');

    //获取当前用户
    this.curUser = CloudChat.currentUser;

    //注册监听
    try {
      this.callBackManager.addEventSubscription(Event.CONTACT_LIST_LOADED, this.catchContacts);
      this.callBackManager.addEventSubscription(Event.CONTACT_LIST_LOAD_FAILED, this.loadContactsFailed);
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
    this.uiAbilityContext.eventHub.emit(Event.LOAD_CONTACT_LIST);
  }

  //三栏布局
  build() {
    Row(){
      //左侧联系人栏
      ContactSidebar({
        contacts: this.contacts,
        messagesMap: $messagesMap,
        selectedContact: this.selectedContact,
        searchKeyword: this.searchKeyword,
        onContactSelected: (contact: Contact) => {
          this.selectedContact = contact;
          this.isPanelFolded = true; // Optional: Auto close detail when switching
        },
        onSearchChanged: (val: string) => {
          this.searchKeyword = val;
        },
        onRefresh: this.loadContacts
      })
        .width('25%')
        .height('100%')
        .border({ width: { right: 1 }, color: $r('app.color.list_divider') })

      //中间区域
      ChatArea({
        currentUser: this.curUser,
        selectedContact: this.selectedContact,
        messagesMap: this.messages,
        onMessageSelected: (msg: Message) => {
          this.selectedMessage = msg;
        },
        onSendMessage: (msg: Message) => {
          // TODO websocket发送消息
        },
        onFoldPanel: () => {
          this.isPanelFolded = !this.isPanelFolded;
        }
      })
        .layoutWeight(1)
        .height('100%')

      if(!this.isPanelFolded){
        DetailPanel({
          selectedContact: this.selectedContact,
          selectedMessage: this.selectedMessage,
          onClose: () => {
            this.isPanelFolded = true;
          }
        })
          .width('20%')
          .height('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.contact_list_whole_background'))
  }
}