@Entry
@Component
struct ProfileSetting {
  @State message: string = 'Hello CloudChat';
  @State userAvatar: string = 'https://example.com/avatar.jpg'
  @State userEmail: string = 'zhangsan@example.com'
  @State userPhone: string = '13800138000'
  @State notificationsEnabled: boolean = true
  @State darkMode: boolean = false
  @State language: string = 'zh-CN'

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('PageHelloCloudChat')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome';
        })
    }
    .height('100%')
    .width('100%')
  }
}