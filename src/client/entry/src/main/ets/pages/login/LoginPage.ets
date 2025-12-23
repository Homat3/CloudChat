@Entry
@Component
struct LoginPage {
  @State username: string = '';
  @State password: string = '';
  @State errorMessage: string = '';

  build() {
    RelativeContainer() {
      //用户名输入
      TextInput({ text: this.username })
        .id('usernameInput')
        .placeholder('请输入用户名')
        .type(InputType.Normal)
        .height(50)
        .width('80%')
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top, offset: 200 },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onChange((value: string) => {
          this.username = value;
        })

      //密码输入框
      TextInput({ text: this.password })
        .id('passwordInput')
        .placeholder('请输入密码')
        .type(InputType.Password)
        .height(50)
        .width('80%')
        .alignRules({
          top: { anchor: 'usernameInput', align: VerticalAlign.Bottom, offset: 20},
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onChange((value: string) => {
          this.password = value;
        })

      //登录按钮
      Button('登录')
        .id('loginButton')
        .width('80%')
        .height(50)
        .alignRules({
          top: { anchor: 'passwordInput', align: VerticalAlign.Bottom, offset: 40 },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.handleLogin();
        })

      //错误提示
      if(this.errorMessage) {
        Text(this.errorMessage)
          .id('errorText')
          .fontColor(Color.Red)
          .fontSize(14)
          .alignRules({
            top: { anchor: 'loginButton', align: VerticalAlign.Bottom, offset: 20 },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
    }
    .height('100%')
    .width('100%')
  }

  private handleLogin() {
    if(!this.username || !this.password) {
      this.errorMessage = '用户名和密码不能为空';
      return;
    }

    const context = getContext(this) as common.UIAbilityContext;
    context.eventHub.emit("login", {
      username: this.username,
      password: this.password
    });
  }
}