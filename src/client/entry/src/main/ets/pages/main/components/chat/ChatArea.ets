
import { common } from "@kit.AbilityKit";
import { Contact, User } from "../../../../core/models/models";
import { Message, TextMessage } from "../../../../core/models/message";
import { Event } from "../../../../core/tag/Event";
import { EventBus } from "../../../../core/service/event/EventBus";
import { getAvatar } from "../../../../core/util";
import { MessageItem } from "./MessageItem";
import { SendMessagePayload } from "../../../../core/protocol/websocket/client.websocket.protocol";
import { MessageUpdateData } from "../../MainContainer";
import { Page } from "../../../../core/tag/Page";
import { DetailPanel } from "./DetailPanel";

@Component
  /**
   * 中间的聊天界面
   */
export struct ChatArea{
  // 状态变量
  @Prop currentUser: User;  //当前用户
  @Prop selectedContact: Contact;
  @Prop contacts: Contact[];

  @State selectedMessages: Message[] | null = null;
  @State newMessage: string = '';
  @State showEmojiPicker: boolean = false;
  @State showAttachmentMenu: boolean = false;
  @State showPanel: boolean = false;

  private scroller: Scroller = new Scroller();

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  aboutToAppear(): void {
    try {
      EventBus.on(Event.UPDATE_MESSAGES, (data: MessageUpdateData) => {
        this.selectedMessages = data.messages;
        this.scroller.scrollToIndex(this.selectedMessages.length - 1);
      });
      EventBus.on(Event.OPEN_PANEL, () => {
        this.showPanel = true;
      });
      EventBus.on(Event.CLOSE_PANEL, () => {
        this.showPanel = false;
      })
    } catch (e) {
      console.error(e);
    }
  }

  build(){
    Column() {
      if (this.showPanel){
        DetailPanel({
          contact: this.selectedContact,
          currentUser: this.currentUser
        });
      }
      else {
        //头部
        this.buildHeader()

        Column() {
          List({ space: 10, scroller: this.scroller }) {
            ForEach(this.selectedMessages, (message: Message) => {
              ListItem() {
                MessageItem({
                  message: message,
                  isCurrentUser: this.isCurrentUser(message)
                })
              }
            }, (message: Message) => message.id.toString() + message.timestamp) // 添加时间戳保证key唯一
          }
          .onAppear(() => {
            if (this.selectedMessages?.length) {
              this.scroller.scrollToIndex(this.selectedMessages.length - 1);
            }
          })
          .height('100%')
          .width('100%')
          .layoutWeight(1)
          .scrollBar(BarState.Auto)
        }
        .layoutWeight(1)
        .width('100%')
        .backgroundColor($r('app.color.contact_list_contact_background'))

        this.buildInputArea()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.contact_list_chat_background'))
  }

  @Builder
  buildHeader() {
    Row() {
      Row(){
        //返回键
        Image($r('app.media.backicon'))
          .height(24)
          .width(24)
          .padding(0)
          .margin({left:8})
          .onClick(()=>{
            EventBus.emit(Event.CLOSE_CHAT_AREA);
          })

        Image(getAvatar(this.selectedContact?.avatar))
          .width(40)
          .height(40)
          .margin({left:4,right:8})
          .borderRadius(24)

        //用户名
        Text(this.selectedContact?.username)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_text'))
      }
      .alignItems(VerticalAlign.Center)
      .height('100%')

      //详情栏
      Row(){
        Image($r('app.media.detail'))
          .width(24)
          .height(24)
      }
      .backgroundColor(Color.Transparent)
      .width(40)
      .height(40)
      .padding(0)
      .onClick(()=>{
        EventBus.emit(Event.OPEN_PANEL);
      })
    }
    .width('100%')
    .height(60)
    .padding({right: 8 })
    .backgroundColor($r('app.color.header_background'))
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .border({ width: { bottom: 0.5 }, color: $r('app.color.list_divider') })
  }

  private getLastIndex(messages: Message[] | null): number{
    return messages? messages.length - 1 : 0;
  }

  private isCurrentUser(message: Message): boolean{
    return this.currentUser?.userId === message.senderId
  }

  @Builder
  buildInputArea() {
    Row() {
      Row() {
        //输入框
        TextInput({
          text: this.newMessage,
          placeholder: $r("app.string.text_contactList_chatArea_PleaseInputMessage")
        })
          .layoutWeight(1)
          .height(32)
          .backgroundColor(Color.White)
          .borderRadius(6)
          .padding({ left: 12, right: 12 })
          .fontSize(15)
          .onSubmit((): void => this.handleSend())
          .onChange((value: string) => this.newMessage = value)
      }
      .layoutWeight(0.6)
      .padding({ left: 10, right: 10 })
      .backgroundColor(Color.White)
      .borderRadius(10)
      .height(40)

      //发送按钮
      Button($r("app.string.text_contactList_chatArea_Send"))
        .width(70)
        .height(32)
        .backgroundColor(this.newMessage.trim().length > 0 ? $r('app.color.send_button') : Color.Gray)
        .fontColor(Color.White)
        .fontSize(14)
        .margin({ left: 8 })
        .borderRadius(16)
        .onClick(() => this.handleSend())
        .enabled(this.newMessage.trim().length > 0)
    }
    .padding({ left: 16, right: 16, bottom: 16, top: 8 })
    .width('100%')
    .alignItems(VerticalAlign.Center)  // 确保输入框和按钮垂直居中对齐
  }

  private handleSend() {
    if (!this.newMessage.trim() || !this.currentUser || !this.selectedContact) return;

    EventBus.emit(Event.SEND_MESSAGE, {
      tempId: "server generates",
      senderId: this.currentUser.userId,
      receiverId: this.selectedContact.contactId,
      content: this.newMessage
    } as SendMessagePayload);
  }
}