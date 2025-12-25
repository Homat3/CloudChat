import { ContactItem } from "./ContactItem";
import { common } from "@kit.AbilityKit";

@Component
  /**
   * 左侧联系人栏
   */
export struct ContactSidebar{
  // 状态变量

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  build() {
    Column() {
      // 搜索框
      Search({ placeholder: '搜索联系人', controller: this.searchController })
        .onChange((value: string) => {
          this.searchKeyword = value;
        })
        .margin(8)

      // 联系人列表
      List() {
        ForEach(this.contacts, (contact: Contact) => {
          ListItem() {
            ContactItem({
              contact: contact,
              selected: this.selectedContactId === contact.id,
              onSelect: (id: number) => {
                this.selectedContactId = id;
              }
            })
          }
        }, (contact: Contact) => contact.id.toString())
      }
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: '#EEE' })

      // 添加联系人按钮
      Button('添加联系人', { type: ButtonType.Normal })
        .width('80%')
        .margin(12)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/contact-list/add-contact/AddContact'
          });
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

}