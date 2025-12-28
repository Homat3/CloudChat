import { common } from "@kit.AbilityKit";
import { CloudChat } from "../../../CloudChat";
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

  @Prop selectedContactId: number;
  @Prop selectedMessageId: number;
  @Prop onClose: () => void;
  @Prop contacts: Contact[] = [];

  get currentContact(): Contact | undefined {
    return this.contacts.find(c => c.contactId === this.selectedContactId);
  }
  aboutToAppear() {

  }

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
      if (this.currentContact) {
        // Info Area
        Column() {
          Image(this.currentContact.avatar ? this.currentContact.avatar : $r('app.media.default'))
            .width(100)
            .height(100)
            .margin(20)
            .borderRadius(50)

          Text(this.currentContact.username)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10 })

          Row() {
            Text('状态: ')
              .fontColor($r('app.color.secondary_text'))
            Text(this.currentContact.online ? '在线' : '离线')
              .fontColor(this.currentContact.online ? Color.Green : Color.Gray)
              .fontWeight(FontWeight.Medium)
          }
          .margin({ bottom: 20 })

          Divider().width('80%').color($r('app.color.list_divider'))

          // Action Buttons
          Button('发送消息')
            .width('80%')
            .margin({ top: 20 })
            .onClick(() => {
              // Logic to just close panel and focus chat
              this.onClose();
            })

          Button('删除好友')
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
          Text("未选择联系人")
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