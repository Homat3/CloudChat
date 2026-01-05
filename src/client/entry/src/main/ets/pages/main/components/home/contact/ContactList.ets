import { ContactItem } from "./ContactItem";
import { common } from "@kit.AbilityKit";
import { Contact } from "../../../../../core/models/models";
import { Message } from "../../../../../core/models/message";

@Component
/**
 * 联系人栏
 */
export struct ContactList {
  // 状态变量
  @Prop contacts: Array<Contact> = [];
  @Link selectedContact: Contact | null;
  @Link searchKeyword: string

  @State refreshing: boolean = false
  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  aboutToAppear() {
  }

  //过滤联系人
  private filterContacts(key: string): Contact[] {
    if(key.trim() === '') {
      return [...this.contacts];
    } else {
      return this.contacts.filter(contact =>
        contact.username.toLowerCase().includes(key.toLowerCase())
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
        })

      //联系人列表
      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.filterContacts(this.searchKeyword), (contact: Contact) => {
          ListItem() {
            ContactItem({
              contact: contact,
              selectedContact: this.selectedContact,
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