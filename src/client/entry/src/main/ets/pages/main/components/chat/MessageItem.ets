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
          .padding(12)
          .backgroundColor(
            this.isCurrentUser
              ? $r('app.color.my_message_bg')
              : $r('app.color.other_message_bg')
          )
          // 优化：差异化圆角，更符合聊天场景视觉习惯
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
          // 显式声明换行，避免极端情况文本溢出
          .constraintSize({
            minWidth: 0,
            maxWidth: '75%'
          })
          .textOverflow({overflow:TextOverflow.Clip})
          .maxLines(0)
          .margin({
            left: this.isCurrentUser ? 0 : 12,  // 对方消息左间距
            right: this.isCurrentUser ? 12 : 0   // 自己消息右间距
          })
      }
      .width('100%')
      .justifyContent(this.isCurrentUser ? FlexAlign.End : FlexAlign.Start)

      // 时间戳行：同步优化对齐和间距
      Row() {
        Text(this.message.timestamp)
          .fontSize(12)
          .fontColor(Color.Gray)
          .textAlign(this.isCurrentUser ? TextAlign.End : TextAlign.Start)
          // 时间戳和消息气泡对齐，保留边缘间距
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