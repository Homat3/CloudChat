
import { common } from "@kit.AbilityKit";
import { User } from "../../../../core/models/models";

@Entry
@Component
struct DetailPanel{
  // 从外部接收的用户参数
  @State user: User | null = null
  @State notificationsEnabled: boolean = true

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  aboutToAppear() {
    // 接受路由参数

  }

  build() {
    Column() {
      // 标题栏
      this.buildHeader()

      // 头像和基本信息区域
      Column() {
        // 头像
        Image(this.user?.avatar)
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({ top: 20, bottom: 20 })

        // 用户ID
        Row() {
          Text($r('app.string.text_DetailPanel_userId'))
            .fontSize(16)
            .fontColor(Color.Gray)
            .width(80)
          Text(this.user?.userId?.toString())
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .margin({ left: 16 })
        }
        .width('100%')
        .padding({ left: 24, right: 24 })
        .margin({ top: 10, bottom: 10 })

        // 用户名
        Row() {
          Text($r('app.string.text_DetailPanel_username'))
            .fontSize(16)
            .fontColor(Color.Gray)
            .width(80)
          Text(this.user?.username || $r('app.string.text_DetailPanel_unknownUser'))
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .margin({ left: 16 })
        }
        .width('100%')
        .padding({ left: 24, right: 24 })
        .margin({ top: 10, bottom: 10 })

        // 邮箱
        Row() {
          Text($r('app.string.text_DetailPanel_email'))
            .fontSize(16)
            .fontColor(Color.Gray)
            .width(80)
          Text(this.user?.email || $r('app.string.text_DetailPanel_unSet'))
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .margin({ left: 16 })
        }
        .width('100%')
        .padding({ left: 24, right: 24 })
        .margin({ top: 10, bottom: 10 })

      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(12)
      .margin({ top: 20, left: 16, right: 16 })
      .padding({ bottom: 20 })

      // 消息通知开关
      Row() {
        Text($r('app.string.text_DetailPanel_messageNotice'))
          .fontSize(16)
          .fontColor(Color.Gray)
          .layoutWeight(1)
        Toggle({ type: ToggleType.Switch, isOn: this.notificationsEnabled })
          .onChange((isOn: boolean) => {
            this.notificationsEnabled = isOn;
          })
      }
      .width('100%')
      .padding({ left: 24, right: 24, top: 16, bottom: 16 })
      .backgroundColor(Color.White)
      .margin({ top: 12, left: 16, right: 16 })
      .borderRadius(12)

      // 中间空白区域
      Blank()
        .layoutWeight(1)

      // 删除好友按钮
      Button($r('app.string.text_DetailPanel_deleteContact'), { type: ButtonType.Capsule })
        .width('90%')
        .height(48)
        .backgroundColor($r('app.color.DetailPanel_deleteBackground'))
        .fontColor(Color.White)
        .fontSize(16)
        .margin({ bottom: 40 })
        .onClick(() => {
          // 删除好友逻辑
          this.deleteFriend();
        })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.DetailPanel_wholeBackground'))
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildHeader() {
    Row() {
      // 返回按钮
      Image($r('app.media.backicon'))
        .height(24)
        .width(24)
        .margin({left:8})
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          // 返回上一页逻辑
          // router.back();
        })

      // 标题
      Text($r('app.string.text_DetailPanel_PersonalInfo'))
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Gray)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      // 右侧占位
      Text("")
        .width(40)
        .height(40)
    }
    .width('100%')
    .height(60)
    .backgroundColor($r('app.color.DetailPanel_background'))
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .border({ width: { bottom: 1 }, color: $r('app.color.DetailPanel_border') })
  }

  private deleteFriend() {
    // 删除好友的逻辑
  }
}