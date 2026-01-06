
import { common } from "@kit.AbilityKit";
import { Contact, User } from "../../../../core/models/models";
import { Message, TextMessage } from "../../../../core/models/message";
import { Event } from "../../../../core/tag/Event";
import { EventBus } from "../../../../core/service/event/EventBus";
import { Home } from "../home/Home";
import { getAvatar } from "../../../../core/util";
import { MessageItem } from "./MessageItem";

/**
 * 预览界面
 */
@Preview
struct ChatAreaInstance{
  // 状态变量
  @State currentUser: User = new User(1,'name','email@test.com','','');
  @State selectedContact: Contact = new Contact(1,'name',true,'');
  //@Link messagesMap: Map<number, Message[]>;
  @State selectedMessage: Message = {
    id: 0,
    senderId: 0,
    receiverId: 0,
    content: "",
    timestamp: "",
    status: "sending",
    type: "text"
  }

  @State messages: Message[] = [];

  //@State messages: Message[] | null = null;
  @State newMessage: string = '';
  @State showEmojiPicker: boolean = false;
  @State showAttachmentMenu: boolean = false;


  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  aboutToAppear(): void {

  }

  build(){
    Column() {
      //头部
      this.buildHeader()

      Column(){
        this.buildMessageList()
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor($r('app.color.contact_list_contact_background'))

      this.buildInputArea()
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

        Image($r('app.media.Zombatar_1'))
          .width(40)
          .height(40)
          .margin({left:4,right:8})
          .borderRadius(24)

        //用户名
        Text(this.selectedContact.username)
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
        //跳转到详情页
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

  @Builder
  buildMessageList() {
    //消息列表
    List({ space: 10, initialIndex: this.messages.length - 1 }) {
      ForEach(this.messages, (message: Message) => {
        ListItem() {
          MessageItem({
            message: message,
            isCurrentUser: this.currentUser.userId === this.selectedContact.contactId
          })
        }
      }, (message: Message) => message.id.toString())
    }
    .height('100%')
    .width('100%')
    .layoutWeight(1)
    .scrollBar(BarState.Auto)
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

    EventBus.emit(Event.SEND_MESSAGE, this.newMessage);
  }
}

@Component
  /**
   * 中间的聊天界面
   */
export struct ChatArea{
  // 状态变量
  @Prop currentUser: User;  //当前用户
  @Prop selectedContact: Contact;
  @Link messages: Message[];

  @State newMessage: string = '';
  @State showEmojiPicker: boolean = false;
  @State showAttachmentMenu: boolean = false;


  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  aboutToAppear(): void {

  }

  build(){
    Column() {
      //头部
      this.buildHeader()

      Column(){
        this.buildMessageList()
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor($r('app.color.contact_list_contact_background'))

      this.buildInputArea()
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

        Image(getAvatar(this.selectedContact.avatar))
          .width(40)
          .height(40)
          .margin({left:4,right:8})
          .borderRadius(24)

        //用户名
        Text(this.selectedContact.username)
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
        //跳转到详情页
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

  @Builder
  buildMessageList() {
    //消息列表
    List({ space: 10, initialIndex: this.messages.length - 1 }) {
      ForEach(this.messages, (message: Message) => {
        ListItem() {
          MessageItem({
            message: message,
            isCurrentUser: this.currentUser.userId === this.selectedContact.contactId
          })
        }
      }, (message: Message) => message.id.toString())
    }
    .height('100%')
    .width('100%')
    .layoutWeight(1)
    .scrollBar(BarState.Auto)
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

    EventBus.emit(Event.SEND_MESSAGE, this.newMessage);
  }
}