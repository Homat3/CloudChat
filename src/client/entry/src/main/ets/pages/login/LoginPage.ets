
import { common } from '@kit.AbilityKit';
import { promptAction, router } from '@kit.ArkUI';
import { Page } from '../../entryability/manager/window-stage-manager/WindowStageManager';

@Entry
@Component
struct LoginPage {
  @State username: string = '';
  @State password: string = '';
  @State errorMessage: string = '';
  @State isLoading:boolean = false;
  @State rememberMe:boolean=false;
  private context:common.UIAbilityContext | null = null;

  //尝试读取保存的用户名
  aboutToAppear(): void {
      this.context = getContext(this) as common.UIAbilityContext;
    // 监听登录成功事件
    this.context?.eventHub.on('loginSuccess', () => {
      router.replaceUrl({ url: 'pages/Home' });
    });

    // 监听登录失败事件
    this.context?.eventHub.on('loginFailed', (err: Error) => {
      this.isLoading = false;
      this.errorMessage = err.message || '登录失败';
    });
  }

  aboutToDisappear(): void {
    // 移除事件监听
    this.context?.eventHub.off('loginSuccess');
    this.context?.eventHub.off('loginFailed');
  }

  build() {
    Column({space : 8}) {
      Column() {
        //Logo
        Text('💬')
          .fontSize(64)
          .margin({ bottom: 8 })
        Column() {
          Text('CloudChat')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor('#409EFF')

          Text('智能聊天')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#409EFF')
        }
      }
      .margin({ top: 40, bottom: 30 })
      .alignItems(HorizontalAlign.Center)

      //登录表单
      Column({ space: 16 }) {
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
          .margin({ top: 30 })
          .onChange((value: string) => {
            this.username = value;
            this.errorMessage = '';
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
          .backgroundColor('')
          .border({
            width: 1,
            color: '#DCDFE6'
          })
          .alignRules({
            top: { anchor: 'usernameInput', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onChange((value: string) => {
            this.password = value;
            this.errorMessage = '';
          })

        Row() {
          //记住我
          Row({ space: 0 }) {
            Checkbox()
              .select(this.rememberMe)
              .onChange((checked: boolean) => {
                this.rememberMe = checked;
              })
              .size({ width: 18, height: 18 })

            Text('记住我')
              .fontSize(14)
              .fontColor('#606266')
              .margin({ left: 4 })
          }
          .margin({left:20})
          .onClick(() => {
            this.rememberMe = !this.rememberMe;
          })

          Blank()

          //忘记密码
          Text('忘记密码？')
            .fontSize(14)
            .fontColor('#409EFF')
            .margin({right:4})
            .onClick(() => {
              promptAction.showToast({
                message: '功能开发中...',
                duration: 2000
              });
            })
        }
        .width('100%')
        .padding({ left: 4, right: 4 })


        //登录按钮
        Button(this.isLoading ? '登录中...' : '登录')
          .id('loginButton')
          .width('80%')
          .height(50)
          .backgroundColor(this.canLogin() && !this.isLoading ? '#409EFF' : '#c0c4cc')
          .alignRules({
            top: { anchor: 'passwordInput', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .margin({ top: 20 })
          .fontColor('#ffffff')
          .enabled(this.canLogin() && !this.isLoading)//登录时禁用
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
            width: 1,
            color: '#409EFF'
          })
          .margin({ top: 10 })
          .onClick(() => {
            router.pushUrl({
              url: Page.REGISTER_PAGE
            }).catch((error: Error) => {
              console.error('Route failed:', error);
              promptAction.showToast({
                message: '无法打开注册页面',
                duration: 2000
              });
            })
          })
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
            .padding(8)
        }

      }

    }
  }



  private handleLogin() {
    if (!this.canLogin()) {
      this.errorMessage = '用户名需5位以上字母数字，密码需8位以上';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    // const context = this.context as common.UIAbilityContext;
    // try {
    //   context.eventHub.emit(Event.LOGIN, {
    //     username: this.username,
    //     password: this.password
    //   });
    // } catch (error) {
    //   this.isLoading = false;
    //   this.errorMessage = '连接服务器失败，请稍后重试';
    //   console.error('Login error:', error);
    // }
  }
  private canLogin(): boolean {
    const usernameValid = /^[a-zA-Z0-9_]{5,20}$/.test(this.username);
    const passwordValid = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$/.test(this.password);

    if (!usernameValid) {
      this.errorMessage = '用户名需5-20位字母数字或下划线';
      return false;
    }

    if (!passwordValid) {
      this.errorMessage = '密码需至少8位，包含字母和数字';
      return false;
    }

    return true;
  }
}


