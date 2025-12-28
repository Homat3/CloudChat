// pages/contact-list/ContactList.ets
import { ContactSidebar } from './components/ContactSidebar';
import { ChatArea } from './components/ChatArea';
import { DetailPanel } from './components/DetailPanel';
import { App, promptAction, router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { Contact, User } from '../../core/models/models';
import { Message } from '../../core/models/message';
import { CloudChat } from '../../CloudChat';

@Entry
@Component
struct ContactList {
  // 状态变量
  @State selectedContactId: number = 0;
  @State selectedMessageId: number = 0;
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

  // 添加页面生命周期
  aboutToAppear() {
    console.log('ContactList 页面加载了');

    //获取当前用户
    this.curUser = CloudChat.currentUser;

    //加载数据
    this.loadContacts();
    try {
      this.uiContext.getPromptAction().showToast({
        message: 'ContactList 页面加载成功',
        duration: 2000
      });
    } catch (error) {
      console.error(error);
    }
  }

  //加载数据
  // async loadData() {
  //   try {
  //     this.isLoading = true;
  //
  //     //异步加载联系人列表
  //     this.contacts = await
  //   }
  // }
  async loadContacts() {
    try {
      this.isLoading = true;
      const contacts = await CloudChat.getContacts();
      this.contacts = contacts;
      if (this.contacts.length > 0) {
        this.selectedContactId = this.contacts[0].contactId;
      }
    } catch (error) {
      promptAction.showToast({ message: '加载联系人失败' });
    } finally {
      this.isLoading = false;
    }
  }

  //三栏布局
  build() {
    Row(){
      //左侧联系人栏
      ContactSidebar({
        contacts: this.contacts,
        messagesMap: $messagesMap,
        selectedContactId: this.selectedContactId,
        searchKeyword: this.searchKeyword,
        onContactSelected: (id: number) => {
          this.selectedContactId = id;
          this.isPanelFolded = true; // Optional: Auto close detail when switching
        },
        onSearchChanged: (val: string) => {
          this.searchKeyword = val;
        },
        onRefresh: (): Promise<void> => this.loadContacts()
        // You might want to add an 'onAddClick' prop to ContactSidebar to toggle showAddContact
      })
        .width('25%')
        .height('100%')
        .border({ width: { right: 1 }, color: $r('app.color.list_divider') })

      //中间区域
      ChatArea({
        currentUser: this.curUser,
        selectedContactId: this.selectedContactId,
        messagesMap: this.messages,
        onMessageSelected: (id: number) => {
          this.selectedMessageId = id;
        },
        onSendMessage: (content: string) => {
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
          selectedContactId: this.selectedContactId,
          selectedMessageId: this.selectedMessageId,
          contacts: this.contacts,
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