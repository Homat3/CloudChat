import { AiMessage } from '../../../../core/models/message';
import { User } from '../../../../core/models/models';
import { send } from '../../../../core/protocol/http/agent.http';
import { EventBus } from '../../../../core/service/event/EventBus';
import { Event } from '../../../../core/tag/Event';
import { common } from '@kit.AbilityKit';
import { CloudChat } from '../../../../CloudChat';


@Component
export struct AiPage {
  //状态变量
  @Prop currentUser: User;
  @State aiMessages: AiMessage[] = [];
  @State inputText: string = '';
  @State isProcessing: boolean = false;
  private scroller: Scroller = new Scroller();

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  aboutToAppear(): void {
    try {
      EventBus.on(Event.AGENT_POST_MESSAGE_SUCCESS, AiPage.name, (data: AiMessage) => {
        this.inputText = '';
        this.isProcessing = true;
        this.aiMessages = [...this.aiMessages, data];
        this.scroller.scrollToIndex(this.aiMessages.length - 1);
      });
      EventBus.on(Event.AGENT_POST_MESSAGE_FAILED, AiPage.name, (error: string) => {
        this.isProcessing = false;
        try {
          this.uiContext.getPromptAction().showToast({
            message: "消息发送失败：" + error,
            duration: 2000
          });
        } catch (error) {
          console.error(error);
        }
      });
      EventBus.on(Event.AGENT_REPLY_SUCCESS, AiPage.name, (data: AiMessage) => {
        this.isProcessing = false;
        this.aiMessages = [...this.aiMessages, data];
      });
      EventBus.on(Event.AGENT_REPLY_FAILED, AiPage.name, (error: string) => {
        this.isProcessing = false;
        try {
          this.uiContext.getPromptAction().showToast({
            message: "智能体回复失败：" + error,
            duration: 2000
          });
        } catch (error) {
          console.error(error);
        }
      });
    } catch (e) {
      console.error(e);
    }
  }

  build() {
    Column() {
      //头部
      this.buildHeader()

      //显示消息
      List({ space: 15, scroller: this.scroller }) {
        ForEach(this.aiMessages, (msg: AiMessage) => {
          ListItem() {
            this.buildMessageItem(msg)
          }
        }, (msg: AiMessage) => msg.id.toString())
        if (this.isProcessing){
          ListItem() {
            this.buildMessageItem({ role: 'assistant', content: 'Processing', timestamp: new Date().toLocaleTimeString(), id: '0' })
          }
        }
      }
      .layoutWeight(1)
      .width('100%')
      .height('100%')
      .padding({ left: 16, right: 16, top: 10 })
      .backgroundColor($r('app.color.panel_background'))
      .scrollBar(BarState.Auto)
      .onAppear(() => {
        this.scroller.scrollToIndex(this.aiMessages.length - 1);
      })

      //输入区域
      this.buildInputArea()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.input_background'))
  }

  // 内部逻辑判断：是否为当前用户发送
  private isUser(message: AiMessage): boolean {
    return message.role == 'user';
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
            .fontColor($r('app.color.online_status'))
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
  buildMessageItem(msg: AiMessage) {
    Row() {
      // 消息气泡
      Column() {
        Text(msg.content)
          .padding(12)
          .fontSize(16)
          .borderRadius(12)
          .backgroundColor(
            this.isUser(msg)
              ? $r('app.color.my_message_bg')
              : $r('app.color.other_message_bg')
          )
          .fontColor(
            this.isUser(msg)
              ? $r('app.color.my_message_text')
              : $r('app.color.other_message_text')
          )

        // 时间戳
        Text(msg.timestamp)
          .fontSize(10)
          .fontColor($r('app.color.tertiary_text'))
          .margin({ top: 4 })
      }
      .alignItems(this.isUser(msg) ? HorizontalAlign.End : HorizontalAlign.Start)
      .constraintSize({ maxWidth: '80%' })
    }
    .width('100%')
    .justifyContent(this.isUser(msg) ? FlexAlign.End : FlexAlign.Start)
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
        .backgroundColor($r('app.color.input_background'))
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
      this.inputText = '';
      return;
    }
    if (CloudChat.agentConversation){
      EventBus.emit(Event.AGENT_POST_MESSAGE, {
        conversationId: CloudChat.agentConversation.id,
        username: this.currentUser.username, userId: this.currentUser.userId,
        message: this.inputText
      } as send.PostMessagePayload)
    }
    else {
      EventBus.emit(Event.AGENT_POST_MESSAGE_FAILED, "智能体未初始化")
    }
  }
}