import { common } from "@kit.AbilityKit";
import { CloudChat } from "../../../CloudChat";
import { Message } from "../../../core/models/message";
import { Contact } from "../../../core/models/models";

@Component
  /**
   * 右侧：此组件为详情面板
   * ===============
   * 加上此组件就是把页面设计成： 联系人|消息页面|详情组件
   * 也可以不要这个组件，就是左右布局的两个组件
   */
export struct DetailPanel{
  // 状态变量

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  @Prop selectedContact: Contact | null;
  @Prop selectedMessage: Message | null;
  @Prop onClose: () => void;

  build() {
    Column() {
      // 头部关闭按钮
      Row() {
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          // 使用文本替代图标，确保无资源也能运行
          Text('×')
            .fontSize(20)
            .fontColor($r('app.color.secondary_text'))
            .fontWeight(FontWeight.Lighter)
        }
        .width(32)
        .height(32)
        .backgroundColor(Color.Transparent)
        .margin(12)
        .onClick(() => this.onClose())
      }
      .width('100%')
      .justifyContent(FlexAlign.End)

      // 详细信息区域
      if (this.selectedContact) {
        // Info Area
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

          // Action Buttons
          Button($r("app.string.text_contactList_detailPanel_SendMessage"))
            .width('80%')
            .margin({ top: 20 })
            .onClick(() => {
              // Logic to just close panel and focus chat
              this.onClose();
            })

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
        // No contact selected state
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