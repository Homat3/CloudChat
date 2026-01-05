import { EventBus } from "../../../../core/service/event/EventBus";
import { Event } from "../../../../core/tag/Event";
import { common } from "@kit.AbilityKit";
import { User } from "../../../../core/models/models";
import { CloudChat } from "../../../../CloudChat";

@Entry
@Component
struct ProfileSetting{
  @State user:User | null = CloudChat.currentUser
  @State notificationsEnabled: boolean = true
  @State language: string = 'zh-CN'

  // 颜色模式状态
  @State colorMode: string = 'not_set'

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  build() {
    Column() {
      // 用户头像
      Image(this.user?.avatar)
        .id('avatar')
        .width(80)
        .height(80)
        .borderRadius(40)
        .margin({ top: 40 })
        .alignSelf(ItemAlign.Center)

      //用户ID
      Row(){
        Text($r('app.string.text_profileSetting_userId'))
          .fontSize(16)
          .width(100)
        Text(this.user?.userId.toString())
          .fontSize(16)
          .fontColor(Color.Gray)
          .margin({left:16})
      }
      .width('100%')
      .padding({ left: 20 , right:20})
      .margin({top:60})


      //用户名
      Row() {
        Text($r('app.string.text_profileList_username'))
          .fontSize(16)
          .width(100)
        Text(this.user?.email)
          .fontSize(16)
          .fontColor(Color.Gray)
          .margin({ left: 16 })
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .margin({ top: 20 })

      // 邮箱信息
      Row() {
        Text($r("app.string.text_profileSetting_Email"))
          .fontSize(16)
          .width(100)
        Text(this.user?.email)
          .fontSize(16)
          .fontColor(Color.Gray)
          .margin({ left: 16 })
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .margin({ top: 20 })

      // 消息通知开关
      Row() {
        Text($r("app.string.text_profileSetting_MessageNotify"))
          .fontSize(16)
          .width(100)
        Toggle({ type: ToggleType.Switch, isOn: this.notificationsEnabled })
          .onChange((isOn: boolean) => {
            this.notificationsEnabled = isOn;
          })
          .margin({ left: 16 })
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .margin({ top: 20 })


      // 颜色模式选择
      Column() {
        Text('主题模式')
          .fontSize(16)
          .width('100%')
          .margin({ bottom: 16 })

        Row() {
          Column() {
            Radio({ value: 'not_set', group: 'colorMode' })
              .checked(this.colorMode === 'not_set')
              .height(24)
              .width(24)
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.colorMode = 'not_set';
                  EventBus.emit(Event.COLOR_MODE, "not_set");
                }
              })
            Text('跟随系统')
              .fontSize(14)
          }
          .margin({ right: 40 })

          Column() {
            Radio({ value: 'dark', group: 'colorMode' })
              .checked(this.colorMode === 'dark')
              .height(24)
              .width(24)
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.colorMode = 'dark';
                  EventBus.emit(Event.COLOR_MODE, "dark");
                }
              })
            Text('深色')
              .fontSize(14)
          }
          .margin({ right: 40 })

          Column() {
            Radio({ value: 'light', group: 'colorMode' })
              .checked(this.colorMode === 'light')
              .height(24)
              .width(24)
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.colorMode = 'light';
                  EventBus.emit(Event.COLOR_MODE, "light");
                }
              })
            Text('浅色')
              .fontSize(14)
          }
        }
        .justifyContent(FlexAlign.Start)
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .margin({ top: 60 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.profileSetting_relativeContainer_background"))
    .alignItems(HorizontalAlign.Start) // 确保列内容从左侧开始
  }
}