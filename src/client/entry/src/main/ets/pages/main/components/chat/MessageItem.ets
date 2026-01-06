import { common } from "@kit.AbilityKit";
import { Message } from "../../../../core/models/message";
import { Contact } from "../../../../core/models/models";

@Component
  /**
   * 消息项组件，把处理消息的功能提取出来
   */
export struct MessageItem{
  // 状态变量

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  @Prop message: Message;
  @Prop isCurrentUser: boolean;

  build() {
    Column() {
      Row(){
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
      .justifyContent(this.isCurrentUser ? FlexAlign.End : FlexAlign.Start)
      .width('100%')
      Row() {
        Text(this.message.timestamp)
      }
      .justifyContent(this.isCurrentUser ? FlexAlign.End : FlexAlign.Start)
      .width('100%')
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .margin({ left:10, top: 8 })
  }
}