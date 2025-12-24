import { common } from '@kit.AbilityKit';

@Entry
@Component
struct LoginPage {
  @State username: string = '';
  @State password: string = '';
  @State errorMessage: string = '';
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext

  build() {
    Column() {
      //上方系统标题
      Column(){
        Text('欢迎使用')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#409EFF')

        Text('CloudChat聊天')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#409EFF')
      }
      .margin({top:40,bottom:30})
      .alignItems(HorizontalAlign.Center)



      // 用户名输入框
      TextInput({
        text: this.username,
        placeholder: '请输入用户名'
      })
        .id('usernameInput')
        .type(InputType.Normal)
        .height(50)
        .width('80%')
        .padding(12)
        .backgroundColor('Color.Transparent')
        .border({
          width: 1,
          color: '#DCDFE6'
        })
        .alignRules({
          top: { anchor: 'welcomeTitle', align: VerticalAlign.Bottom },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .margin({top:30})
        .onChange((value: string) => {
          this.username = value;
        })

      // 密码输入框
      TextInput({
        text: this.password,
        placeholder: '请输入密码'
      })
        .id('passwordInput')
        .type(InputType.Password)
        .height(50)
        .width('80%')
        .padding(12)
        .backgroundColor('')
        .border({
          width: 1,
          color: '#DCDFE6'
        })
        .alignRules({
          top: { anchor: 'usernameInput', align: VerticalAlign.Bottom },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .margin({ top: 20 })
        .onChange((value: string) => {
          this.password = value;
        })
      //登录按钮
      Button('登录')
        .id('loginButton')
        .width('80%')
        .height(50)
        .alignRules({
        top: { anchor: 'passwordInput', align: VerticalAlign.Bottom },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .margin({ top: 40 })
      .onClick(() => {
        this.handleLogin();
      })

      //注册按钮
      Button('注册账号')
        .id('registerButton')
        .width('80%')
        .height(50)
        .fontSize(16)
        .backgroundColor(Color.Transparent)
        .fontColor('#409EFF')
        .borderRadius(8)
        .border({
          width:1,
          color:'#409EFF'
        })
        .margin({top:20})
        .onClick(()=>{})


      //错误提示
      if (this.errorMessage) {
        Text(this.errorMessage)
          .id('errorText')
          .fontColor(Color.Red)
          .fontSize(14)
          .alignRules({
            top: { anchor: 'loginButton', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .margin({ top: 10 })
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

    const context = this.context as common.UIAbilityContext;
    context.eventHub.emit("login", {
      username: this.username,
      password: this.password
    });
  }
}