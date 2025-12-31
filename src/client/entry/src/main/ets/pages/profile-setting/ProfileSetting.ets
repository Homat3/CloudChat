import { common } from '@kit.AbilityKit'
import { CloudChat } from '../../CloudChat';
import { User } from '../../core/models/models';

@Entry
@Component
struct ProfileSetting {
  @State user:User | null = CloudChat.currentUser
  @State notificationsEnabled: boolean = true
  @State darkMode: boolean = false
  @State language: string = 'zh-CN'

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  build() {
    RelativeContainer() {
      // 用户头像
      Image(this.user?.avatar)
        .id('avatar')
        .width(80)
        .height(80)
        .borderRadius(40)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .margin({ top: 40 })

      //用户名
      Row(){
        Text($r('app.string.text_profileList_username'))
          .fontSize(16)
          .width(80)
        Text(this.user?.email)
          .fontSize(16)
          .fontColor(Color.Gray)
      }
      .id('usernameRow')
      .alignRules({
        top: { anchor: 'avatar', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
      .margin({ top: 40, left: 20 })

      // 邮箱信息
      Row() {
        Text($r("app.string.text_profileSetting_Email"))
          .fontSize(16)
          .width(80)
        Text(this.user?.email)
          .fontSize(16)
          .fontColor(Color.Gray)
      }
      .id('emailRow')
      .alignRules({
        top: { anchor: 'avatar', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
      .margin({ top: 40, left: 20 })

      //

      // 消息通知开关
      Row() {
        Text($r("app.string.text_profileSetting_MessageNotify"))
          .fontSize(16)
          .width(80)
        Toggle({ type: ToggleType.Switch, isOn: this.notificationsEnabled })
          .onChange((isOn: boolean) => {
            this.notificationsEnabled = isOn;
          })
      }
      .id('notifyRow')
      .alignRules({
        top: { anchor: 'emailRow', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
      .margin({ top: 40, left: 20 })

      // 深色模式开关
      Row() {
        Text($r("app.string.text_profileSetting_DarkMode"))
          .fontSize(16)
          .width(80)
        Toggle({ type: ToggleType.Switch, isOn: this.darkMode })
          .onChange((isOn: boolean) => {
            this.darkMode = isOn;
          })
      }
      .id('darkModeRow')
      .alignRules({
        top: { anchor: 'notifyRow', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
      .margin({ top: 20, left: 20 })

    }
    .height('100%')
    .width('100%')
    .backgroundColor(this.darkMode ? Color.Black : Color.White)
  }
}

export { ProfileSetting }
