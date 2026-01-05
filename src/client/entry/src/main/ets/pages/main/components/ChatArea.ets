
import { common } from "@kit.AbilityKit";
import { Contact, User } from "../../../core/models/models";
import { Message, TextMessage } from "../../../core/models/message";
import { Event } from "../../../core/tag/Event";
import { EventBus } from "../../../core/service/event/EventBus";
import { Home } from "./home/Home";

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
        Button($r('app.string.text_chatArea_backButton'))
          .backgroundColor($r('app.color.chatArea_backButton'))
          .fontColor($r('app.color.primary_text'))
          .type(ButtonType.Normal)
          .height(40)
          .width(40)
          .padding(0)
          .margin({ right: 4 })
          .onClick(()=>{
              this.uiContext.getRouter().back();
          })

        //用户名
        Text(this.currentUser.username)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_text'))
      }
      .alignItems(VerticalAlign.Center)
      .height('100%')

      //详情栏
        Image($r('app.media.startIcon'))
          .width(24)
          .height(24)
      .backgroundColor(Color.Transparent)
      .width(40)
      .height(40)
      .padding(0)
      .onClick(()=>{
        this.uiContext.getRouter().replaceUrl({url:'../components/DetailPanel'})
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

  }

  @Builder
  buildInputArea() {
    Row() {
      // 左侧：附件按钮 + 输入框
      Row() {
        // Button({ type: ButtonType.Circle }) {
        //   Image($r('app.media.ic_add')) // 使用+图标
        //     .width(20)
        //     .height(20)
        // }
        // .width(36)
        // .height(36)
        // .backgroundColor(Color.White)
        // .borderRadius(18)
        // .margin({ right: 8 })
        // .onClick(() => this.showAttachmentMenu = !this.showAttachmentMenu)

        TextInput({ text: this.newMessage, placeholder: $r("app.string.text_contactList_chatArea_PleaseInputMessage") })
          .layoutWeight(1)
          .height(36)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .padding({ left: 16, right: 16 })
          .fontSize(16)
          .onSubmit((): void => this.handleSend())
          .onChange((value: string) => this.newMessage = value)
      }
      .layoutWeight(1)
      .padding({ left: 8, right: 8 })
      .backgroundColor(Color.White)
      .borderRadius(24)
      .height(52)

      // 右侧：发送按钮
      Button($r("app.string.text_contactList_chatArea_Send"))
        .width(70)
        .height(36)
        .backgroundColor(this.newMessage.trim().length > 0 ? $r('app.color.send_button') : Color.Gray)
        .fontColor(Color.White)
        .fontSize(14)
        .margin({ left: 8 })
        .borderRadius(18)
        .onClick(() => this.handleSend())
        .enabled(this.newMessage.trim().length > 0)
    }
    .padding({ left: 16, right: 16, bottom: 16, top: 8 })
    .width('100%')
    .alignItems(VerticalAlign.Center)
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

    EventBus.emit(Event.SEND_MESSAGE, this.newMessage);
  }
}











@Component
  /**
   * 中间的聊天界面
   */
export struct ChatArea{
  // 状态变量
  @Prop currentUser: User ;//当前用户
  @Prop selectedContact: Contact | null;
  //@Link messagesMap: Map<number, Message[]>;
  @Link selectedMessage: Message | null;

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
        Button($r('app.string.text_chatArea_backButton'))
          .backgroundColor($r('app.color.chatArea_backButton'))
          .fontColor($r('app.color.primary_text'))
          .type(ButtonType.Normal)
          .height(40)
          .width(40)
          .padding(0)
          .margin({ right: 4 })
          .onClick(()=>{
            this.uiContext.getRouter().back();
          })

        //用户名
        Text(this.currentUser.username)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_text'))
      }
      .alignItems(VerticalAlign.Center)
      .height('100%')

      //详情栏
      Row(){
        Image($r('app.media.startIcon'))
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

  }

  @Builder
  buildInputArea() {
    Column() {
      // 附加功能菜单
      if (this.showAttachmentMenu) {

      }
      Row() {
        Row(){
          //返回键
          Button($r('app.string.text_chatArea_backButton'))
            .backgroundColor($r('app.color.chatArea_backButton'))
            .fontColor($r('app.color.primary_text'))
            .type(ButtonType.Normal)
            .height(40)
            .width(40)
            .padding(0)
            .margin({ right: 4 })
            .onClick(()=>{
              this.uiContext.getRouter().back();
            })

          //用户名
          Text(this.currentUser.username)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.primary_text'))
        }
        .alignItems(VerticalAlign.Center)
        .height('100%')

        //详情栏
        Row(){
          Image($r('app.media.startIcon'))
            .width(24)
            .height(24)
        }
        .backgroundColor(Color.Transparent)
        .width(40)
        .height(40)
        .padding(0)
        .onClick(()=>{
          
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
    .padding({left:8,right:8,bottom:8})
    .width('100%')
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

    EventBus.emit(Event.SEND_MESSAGE, this.newMessage);
  }
}