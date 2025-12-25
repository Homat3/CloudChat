import { ContactItem } from "./ContactItem";
import { common } from "@kit.AbilityKit";
import { Contact } from "../../../core/models/models";

@Component
/**
 * 左侧联系人栏
 */
export struct ContactSidebar{
  // 状态变量
  @State contacts: Array<Contact> = []
  @State selectedIds: string[] = []
  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  //初始化联系人数据
  aboutToAppear() {
    // 加载真实数据
  }

  build(){
    Column() {
      //搜索框
      Search({ placeholder: '搜索联系人' })
        .width('90%')
        .margin(10)
        .onChange((value: string) => {
          //处理搜索逻辑
        })

      //联系人列表
      List() {
        // ForEach(this.contacts, (contact: Contact) => {
        //   ListItem() {
        //     ContactItem({ contact: contact })
        //       .selected(this.selectedIds.includes(contact.id))
        //       .onClick(() => {
        //         //处理选中逻辑
        //         this.toggleSelection(contact.id)
        //       })
        //   }
        // }, (contact: Contact) => contact.id)  //指定唯一key
      }
    }
  }

}