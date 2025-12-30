import { common } from "@kit.AbilityKit";
import { Message } from "../../../core/models/message";
import { Contact } from "../../../core/models/models";

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
  @Prop onSelected: () => void = () => {};


  build() {
    Row() {
      //如果是对方发送，头像在左侧
      if(!this.isCurrentUser) {
        this.buildAvatar()
      }

        Column() {
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
          Text(this.message.timestamp)
            .fontSize(10)
            .fontColor(Color.Gray)
            .margin({ top: 4 })
        }
        .alignItems(this.isCurrentUser ? HorizontalAlign.End : HorizontalAlign.Start)
        .margin({ left: 8, right: 8 })

        //如果是自己发送，头像在右侧
        if(this.isCurrentUser) {
          this.buildAvatar()
        }

    }
    .width('100%')
    .justifyContent(this.isCurrentUser ? FlexAlign.End : FlexAlign.Start)
    .padding({ left: 10, right: 10 })
    .margin({ top: 8, bottom: 8 })
    .onClick(() => this.onSelected())
  }

  @Builder
  buildAvatar() {
    Image($r('app.media.default'))
      .width(40)
      .height(40)
      .borderRadius(20)
  }
}