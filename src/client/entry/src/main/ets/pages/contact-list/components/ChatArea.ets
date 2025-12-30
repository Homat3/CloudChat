import { MessageItem } from "./MessageItem";
import { common } from "@kit.AbilityKit";
import { Contact, User } from "../../../core/models/models";
import { Message, TextMessage } from "../../../core/models/message";
import { CloudChat } from "../../../CloudChat";

@Component
  /**
   * 中间的聊天界面
   */
export struct ChatArea{
  // 状态变量
  @Prop currentUser: User | null;
  @Prop selectedContact: Contact | null;
  @Link messagesMap: Map<number, Message[]>;
  @Prop onMessageSelected: (msg: Message) => void;
  @Prop onSendMessage: (msg: Message) => void;
  @Prop onFoldPanel: () => void;

  @State messages: Message[] | null = null;
  @State newMessage: string = '';
  @State showEmojiPicker: boolean = false;
  @State showAttachmentMenu: boolean = false;


  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  aboutToAppear(): void {
    // 加载消息
    if (this.selectedContact){
      const messages = this.messagesMap.get(this.selectedContact.contactId);
      if (messages){
        this.messages = this.messages;
      }
    }
  }

  build(){
    Column() {
      //顶部标题
      this.buildHeader()

      //消息区
      this.buildMessageList()

      //输入区
      this.buildInputArea()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.contact_list_chat_background'))
  }

  @Builder
  buildHeader() {
    Row() {
      Text($r("app.string.text_contactList_chatArea_ContactId") + `${this.selectedContact?.contactId}`)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.primary_text'))

      Blank()
      // 右侧功能按钮（如折叠详情面板）
      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Column({ space: 4 }) {
          Circle().width(4).height(4).fill(Color.Gray)
          Circle().width(4).height(4).fill(Color.Gray)
          Circle().width(4).height(4).fill(Color.Gray)
        }
      }
      .width(36)
      .height(36)
      .backgroundColor(Color.Transparent)
      .onClick(() => this.onFoldPanel())
    }
    .width('100%')
    .height(56)
    .padding({ left: 20, right: 20 })
    .backgroundColor($r('app.color.header_background'))
    .border({ width: { bottom: 0.5 }, color: $r('app.color.list_divider') })
  }

  @Builder
  buildMessageList() {
    List({ space: 15 }) {
      ForEach(this.messages, (msg: Message) => {
        ListItem() {
          MessageItem({
            message: msg,
            isCurrentUser: msg.senderId === this.currentUser?.userId,
            onSelected: () => this.onMessageSelected(msg)
          })
        }
      }, (msg: Message) => msg.id.toString())
    }
    .layoutWeight(1)
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16, top: 10, bottom: 10 })
    .scrollBar(BarState.Off)
  }

  @Builder
  buildInputArea() {
    Column() {
      // 附加功能菜单
      if (this.showAttachmentMenu) {
      //   Row() {
      //     Button($r('app.media.ic_file')).onClick(() => {/* 文件处理 */})
      //     Button($r('app.media.ic_image')).onClick(() => {/* 图片处理 */})
      //     Button($r('app.media.ic_emoji')).onClick(() => this.showEmojiPicker = true)
      //   }
      //   .padding(10)
      }

      // 主输入区域
      Row() {
        Button({ type: ButtonType.Circle }) {
          Column({ space: 2 }) {
            Circle().width(4).height(4).fill(Color.Gray)
            Circle().width(4).height(4).fill(Color.Gray)
            Circle().width(4).height(4).fill(Color.Gray)
          }
        }
        .width(36)
        .height(36)
        .backgroundColor(Color.Transparent)
        .margin({ left: 8 })
        .onClick(() => this.showAttachmentMenu = !this.showAttachmentMenu)

        TextInput({ text: this.newMessage, placeholder: $r("app.string.text_contactList_chatArea_PleaseInputMessage") })
          .layoutWeight(1)
          .height(40) // 稍微缩小高度更精致
          .backgroundColor(Color.White)
          .borderRadius(20)
          .onSubmit((): void => this.handleSend())
          .onChange((value: string) => this.newMessage = value)

        Button($r("app.string.text_contactList_chatArea_Send"))
          .backgroundColor($r('app.color.send_button'))
          .onClick(() => this.handleSend())
      }
      .padding(10)
      .backgroundColor($r('app.color.input_background'))
      .borderRadius(24)
    }
    .padding(8)
  }

  private handleSend() {
    if (!this.newMessage.trim() || !this.currentUser || !this.selectedContact) return;

    const newMsg: TextMessage = new TextMessage(
      Date.now(),
      this.currentUser.userId,
      this.selectedContact.contactId,
      this.newMessage,
      new Date().toISOString(),
      'sending'
    );

    this.onSendMessage(newMsg);
  }
}