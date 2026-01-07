import { Message } from "../../../../core/models/message";

@Component
export struct MessageItem {
  @Prop message: Message;
  @Prop isCurrentUser: boolean;

  build() {

    Column() {
      // 消息气泡行
      Row() {
        Text(this.message.content)
          .fontSize(16)
          .padding(12)
          .backgroundColor(
            this.isCurrentUser
              ? $r('app.color.my_message_bg')
              : $r('app.color.other_message_bg')
          )
          .borderRadius({
            topLeft: this.isCurrentUser ? 12 : 0,
            topRight: this.isCurrentUser ? 0 : 12,
            bottomLeft: 12,
            bottomRight: 12
          })
          .fontColor(
            this.isCurrentUser
              ? $r('app.color.my_message_text')
              : $r('app.color.other_message_text')
          )
          .textAlign(this.isCurrentUser ? TextAlign.End : TextAlign.Start)
          .constraintSize({
            minWidth: 40,
            maxWidth: '75%'
          })
          .margin({
            left: this.isCurrentUser ? 0 : 12,
            right: this.isCurrentUser ? 12 : 0
          })
      }
      .width('100%')
      .justifyContent(this.isCurrentUser ? FlexAlign.End : FlexAlign.Start)

      // 时间戳行
      Row() {
        Text(this.message.timestamp)
          .fontSize(12)
          .fontColor($r('app.color.text_timestamp'))
          .textAlign(this.isCurrentUser ? TextAlign.End : TextAlign.Start)
          .margin({
            left: this.isCurrentUser ? 0 : 12,
            right: this.isCurrentUser ? 12 : 0
          })
      }
      .width('100%')
      .padding({ top: 2 })
      .justifyContent(this.isCurrentUser ? FlexAlign.End : FlexAlign.Start)
    }
    .width('100%')
    .margin({ top: 8 })
  }
}