import { common } from "@kit.AbilityKit";
import { Message } from "../../../core/models/message";

@Component
  /**
   * 消息项组件，把处理消息的功能提取出来
   * ==============================
   */
export struct MessageItem{
  // 状态变量

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  @Prop message: Message;
  @Prop isCurrentUser: boolean = false;
  @Prop onSelected: () => void = () => {};

  @Builder
  TimeText(time: number) {
    Text(new Date(time).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }))
      .fontSize(10)
      .fontColor($r('app.color.secondary_text'))
  }

  build() {
    Column() {
      Row() {
        if (!this.isCurrentUser) {
          Image(this.message.senderAvatar ? this.message.senderAvatar : $r('app.media.default'))
            .width(32)
            .height(32)
            .margin({ right: 8 })
            .borderRadius(16)
        }

        Column() {
          if (!this.isCurrentUser) {
            Text(this.message.senderName)
              .fontSize(12)
              .fontColor($r('app.color.secondary_text'))
          }

          Text(this.message.content)
            .padding(12)
            .backgroundColor(
              this.isCurrentUser
                ? $r('app.color.my_message_bg')
                : $r('app.color.other_message_bg')
            )
            .borderRadius(12)
            .fontColor(
              this.isCurrentUser
                ? $r('app.color.my_message_text')
                : $r('app.color.other_message_text')
            )
        }
      }
      .justifyContent(this.isCurrentUser ? FlexAlign.End : FlexAlign.Start)
      .width('80%')

    //   this.TimeText(this.message.timestamp)
    //     .align(this.isCurrentUser ? Alignment.End : Alignment.Start)
    }
    .margin({ top: 8, bottom: 8 })
    .width('100%')
    .onClick(() => this.onSelected())
  }
}