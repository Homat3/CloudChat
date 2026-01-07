import { Message } from '../../../../core/models/message';
import { User } from '../../../../core/models/models';


@Component
export struct AiPage {
  //状态变量
  @Prop currentUser: User;
  @State aiMessages: Message[] = [];
  @State inputText: string = '';
  private scroller: Scroller = new Scroller();

  build() {
    Column() {
      //头部
      this.buildHeader()

      //显示消息
      List({ space: 15, scroller: this.scroller }) {
        ForEach(this.aiMessages, (msg: Message) => {
          ListItem() {
            this.buildMessageItem(msg)
          }
        }, (msg: Message) => msg.id.toString())
      }
      .layoutWeight(1)
      .width('100%')
      .padding({ left: 16, right: 16, top: 10 })
      .backgroundColor($r('app.color.panel_background'))
      .scrollBar(BarState.Auto)

      //输入区域
      this.buildInputArea()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.input_background'))
  }

  // 内部逻辑判断：是否为当前用户发送
  private isCurrentUser(message: Message): boolean {
    return this.currentUser?.userId === message.senderId;
  }

  // 头部构建器
  @Builder
  buildHeader() {
    Row() {
      Row() {
        // AI 头像
        Image($r('app.media.ai'))
          .width(40)
          .height(40)
          .margin({ left: 12, right: 12 })
          .borderRadius(20)

        // 标题
        Column() {
          Text("AI 助手")
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.primary_text'))
          Text("在线")
            .fontSize(10)
            .fontColor(Color.Green)
        }.alignItems(HorizontalAlign.Start)
      }
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height(60)
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.header_background'))
    .border({ width: { bottom: 0.5 }, color: $r('app.color.list_divider') })
  }

  // 消息气泡构建器
  @Builder
  buildMessageItem(msg: Message) {
    Row() {
      // 消息气泡
      Column() {
        Text(msg.content)
          .padding(12)
          .fontSize(16)
          .borderRadius(12)
          .backgroundColor(
            this.isCurrentUser(msg)
              ? $r('app.color.my_message_bg')
              : $r('app.color.other_message_bg')
          )
          .fontColor(
            this.isCurrentUser(msg)
              ? $r('app.color.my_message_text')
              : $r('app.color.other_message_text')
          )

        // 时间戳
        Text(msg.timestamp)
          .fontSize(10)
          .fontColor(Color.Gray)
          .margin({ top: 4 })
      }
      .alignItems(this.isCurrentUser(msg) ? HorizontalAlign.End : HorizontalAlign.Start)
      .constraintSize({ maxWidth: '80%' })
    }
    .width('100%')
    .justifyContent(this.isCurrentUser(msg) ? FlexAlign.End : FlexAlign.Start)
    .margin({ top: 8, bottom: 8 })
  }

  // 输入区域构建器
  @Builder
  buildInputArea() {
    Row() {
      TextInput({
        text: this.inputText,
        placeholder: "请输入..."
      })
        .layoutWeight(1)
        .height(40)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .onChange((value: string) => {
          this.inputText = value;
        })
        .onSubmit(() => this.handleSend())

      Button("发送")
        .margin({ left: 10 })
        .height(40)
        .width(70)
        .borderRadius(20)
        .enabled(this.inputText.trim().length > 0)
        .onClick(() => this.handleSend())
    }
    .width('100%')
    .padding(12)
    .backgroundColor($r('app.color.header_background'))
  }

  // 发送逻辑空实现
  private handleSend() {
    if (this.inputText.trim().length === 0) {
      return;
    }

    // 清空输入框
    this.inputText = '';
  }
}