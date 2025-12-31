import { common } from "@kit.AbilityKit";
import { CloudChat } from "../../../CloudChat";
import { Message } from "../../../core/models/message";
import { Contact } from "../../../core/models/models";
import { Event } from "../../../core/tag/Event";
import { EventBus } from "../../../core/service/event/EventBus";

@Component
  /**
   * 右侧：此组件为详情面板
   * ===============
   * 加上此组件就是把页面设计成： 联系人|消息页面|详情组件
   * 也可以不要这个组件，就是左右布局的两个组件
   */
export struct DetailPanel{
  // 状态变量
  @Prop selectedContact: Contact | null;
  @Prop selectedMessage: Message | null;

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  build() {
    Column() {
      // 详细信息区域
      if (this.selectedContact) {
        // 消息区域
        Column() {
          Image(this.selectedContact.avatar)
            .width(100)
            .height(100)
            .margin(20)
            .borderRadius(50)

          Text(this.selectedContact.username)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10 })

          Row() {
            Text($r("app.string.text_contactList_detailPanel_Status"))
              .fontColor($r('app.color.secondary_text'))
            Text(this.selectedContact.online ? $r("app.string.text_contactList_all_Online") : $r("app.string.text_contactList_all_Offline"))
              .fontColor(this.selectedContact.online ? Color.Green : Color.Gray)
              .fontWeight(FontWeight.Medium)
          }
          .margin({ bottom: 20 })

          Divider().width('80%').color($r('app.color.list_divider'))

          // 激活键
          Button($r("app.string.text_contactList_detailPanel_SendMessage"))
            .width('80%')
            .margin({ top: 20 })

          Button($r("app.string.text_contactList_detailPanel_DeleteFriend"))
            .width('80%')
            .margin({ top: 10 })
            .backgroundColor(Color.Red)
            .onClick(() => {
              // Delete logic
            })

        }
        .alignItems(HorizontalAlign.Center)
        .width('100%')
      } else {
        // 无选中联系人状态
        Column() {
          Text($r("app.string.text_contactList_detailPanel_NoContactSelected"))
            .fontColor(Color.Gray)
            .margin({top: 50})
        }.width('100%').alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.panel_background'))
    .border({ width: { left: 1 }, color: $r('app.color.list_divider') })
  }
}