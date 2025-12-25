@Entry
@Component
struct ProfileSetting {
  @State userAvatar: string = 'https://example.com/avatar.jpg'
  @State userEmail: string = 'zhangsan@example.com'
  @State userPhone: string = '13800138000'
  @State notificationsEnabled: boolean = true
  @State darkMode: boolean = false
  @State language: string = 'zh-CN'

  build() {
    RelativeContainer() {
      // 用户头像
      Image(this.userAvatar)
        .id('avatar')
        .width(80)
        .height(80)
        .borderRadius(40)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .margin({ top: 40 })
      // 邮箱信息
      Row() {
        Text('邮箱:')
          .fontSize(16)
          .width(80)
        Text(this.userEmail)
          .fontSize(16)
          .fontColor(Color.Gray)
      }
      .id('emailRow')
      .alignRules({
        top: { anchor: 'avatar', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
      .margin({ top: 40, left: 20 })

      // // 手机信息
      // Row() {
      //   Text('手机:')
      //     .fontSize(16)
      //     .width(80)
      //   Text(this.userPhone)
      //     .fontSize(16)
      //     .fontColor(Color.Gray)
      // }
      // .id('phoneRow')
      // .alignRules({
      //   top: { anchor: 'emailRow', align: VerticalAlign.Bottom, offset: 20 },
      //   left: { anchor: '__container__', align: HorizontalAlign.Start, offset: 20 }
      // })
      // 消息通知开关
      Row() {
        Text('消息通知')
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
        Text('深色模式')
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