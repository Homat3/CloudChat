import { ContactItem } from "./ContactItem";
import { common } from "@kit.AbilityKit";
import { Contact } from "../../../core/models/models";
import { Message } from "../../../core/models/message";

@Component
/**
 * 左侧联系人栏
 */
export struct ContactSidebar{
  // 状态变量
  @Prop contacts: Array<Contact> = [];
  @Prop selectedContact: Contact | null;
  @Prop searchKeyword: string = ''
  @Prop onContactSelected: (contact: Contact) => void
  @Prop onSearchChanged: (keyword: string) => void
  @Prop onRefresh: () => void

  @State filteredContacts: Array<Contact> = []
  @State refreshing: boolean = false
  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  //初始化联系人数据
  aboutToAppear() {
    // 加载真实数据
    this.filterContacts();
  }

  //过滤联系人
  private filterContacts() {
    if(this.searchKeyword.trim() === '') {
      this.filteredContacts = [...this.contacts];
    } else {
      this.filteredContacts = this.contacts.filter(contact =>
        contact.username.toLowerCase().includes(this.searchKeyword.toLowerCase())
      );
    }
  }

  build(){
    Column() {
      //搜索框
      Search({ placeholder: $r("app.string.text_contactList_contactSidebar_SearchForUsers") })
        .width('90%')
        .margin(10)
        .onChange((value: string) => {
          //处理搜索逻辑
          this.searchKeyword = value;
          this.filterContacts();
          this.onSearchChanged(value);
        })

      //联系人列表
      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.filteredContacts, (contact: Contact) => {
          ListItem() {
            ContactItem({
              contact: contact,
              selected: contact.contactId === this.selectedContact?.contactId,
              onSelected: (contact: Contact) => {
                this.onContactSelected(contact);
              }
            })
          }
        }, (contact: Contact) => contact.contactId.toString())
      }
      .height('100%')
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: $r('app.color.list_divider')})
    }
  }

}