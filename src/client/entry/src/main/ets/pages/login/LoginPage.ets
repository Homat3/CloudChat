import { common } from '@kit.AbilityKit';
import { loadStringResource } from '../../core/service/resource/load-resource';
import { Event } from '../../core/tag/Event';
import { Page } from '../../core/tag/Page';
import { UserManager } from '../../core/manager/user-manager/user-manager';
import { LoginFailurePayload, LoginSuccessPayload } from '../../core/protocol/websocket/service.websocket.protocol';
import { CloudChat } from '../../CloudChat';
import { User } from '../../core/models/models';
import { EventBus } from '../../core/service/event/EventBus';
import { LoginPayload } from '../../core/protocol/http/client.http.protocol';


@Entry
@Component
struct LoginPage {
  // 状态
  @State username: string = '';
  @State password: string = '';
  @State errorMessage: string = "";
  @State isLoading: boolean = false;
  @State rememberMe: boolean = false;
  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  //尝试读取保存的用户名
  aboutToAppear(): void {
    try {
      //记住的用户名
      const rememberedUsername = UserManager.getRememberedUsername();
      if(rememberedUsername){
        this.username = rememberedUsername;
        this.rememberMe = true;
      }

      // 监听登录失败事件
      EventBus.on(Event.LOGIN_FAILED, (payload: LoginFailurePayload) => {
        this.isLoading = false;
        try {
          this.uiContext.getPromptAction().showToast({
            message: loadStringResource(this.uiAbilityContext, $r("app.string.error_login_LoginFailed")) + ': ' + payload.error,
            duration: 2000
          });
        }
        catch (e) {
          console.error(e);
        }
      });

      // 监听登录成功事件
      EventBus.on(Event.LOGIN_SUCCESS, (payload: LoginSuccessPayload) => {
        CloudChat.currentUser = new User(payload.userId, payload.username, payload.email, payload.avatar, payload.token);
        this.uiContext.getRouter().replaceUrl({ url: Page.MAIN }).catch((err: Error) => {
          console.error(err.message);
        });
      });

      this.checkLocalTokenAndAutoLogin();

    } catch (error) {
      console.error(error);
    }
  }

  build() {
    Column({ space: 8 }) {
      Column() {
        //Logo
        Text($r('app.string.text_all_logo')).fontSize(64).margin({ bottom: 8 })
        Column() {
          Text($r("app.string.text_all_Title")).fontSize(28).fontWeight(FontWeight.Bold).fontColor($r("app.color.login_title_font"))
          Text($r("app.string.text_all_Subtitle")).fontSize(14).fontWeight(FontWeight.Bold).fontColor($r("app.color.login_title_font"))
        }
      }
      .margin({ top: 40, bottom: 30 })
      .alignItems(HorizontalAlign.Center)

      //登录表单
      Column({ space: 16 }) {
        // 用户名输入框
        TextInput({
          text: this.username,
          placeholder: $r("app.string.text_login_UsernamePlaceholder")
        })
          .id('usernameInput')
          .type(InputType.Normal)
          .height(50)
          .width('80%')
          .padding(12)
          .backgroundColor(Color.Transparent)
          .border({
            width: 1,
            color: $r("app.color.login_textInput_all_border")
          })
          .alignRules({
            top: { anchor: 'welcomeTitle', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .margin({ top: 30 })
          .onChange((value: string) => {
            this.username = value;
            this.errorMessage = "";
          })

        // 密码输入框
        TextInput({
          text: this.password,
          placeholder: $r("app.string.text_login_PasswordPlaceholder")
        })
          .id('passwordInput')
          .type(InputType.Password)
          .height(50)
          .width('80%')
          .backgroundColor('')
          .border({
            width: 1,
            color: $r("app.color.login_textInput_all_border")
          })
          .alignRules({
            top: { anchor: 'passwordInput', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onChange((value: string) => {
            this.password = value;
            this.errorMessage = "";
          })

        Row() {
          //记住我
          Row({ space: 0 }) {
            Checkbox().select(this.rememberMe).onChange((checked: boolean) => {
              this.rememberMe = checked;
            }).size({ width: 18, height: 18 })

            Text($r("app.string.text_login_RememberMe")).margin({ left: 4 }).fontSize(14).fontColor($r("app.color.login_text_rememberMe_font"))
          }
          .margin({ left: 20 })
          .onClick(() => {
            this.rememberMe = !this.rememberMe;
          })

          Blank()

          //忘记密码
          Text($r("app.string.text_login_ForgotPassword")).margin({ right: 4 }).fontSize(14).fontColor($r("app.color.login_text_forgetPassword_font"))
            .onClick(() => {
              try {
                this.uiContext.getPromptAction().showToast({
                  message: $r("app.string.text_login_MoreAbilities"),
                  duration: 2000
                })
              } catch (error) {
                console.error(error);
              }
            })
        }.width('100%').padding({ left: 4, right: 4 })


        //登录按钮
        Button(this.isLoading ? $r("app.string.text_login_LoggingIn") : $r("app.string.text_login_Login"))
          .id('loginButton')
          .width('80%')
          .height(50)
          .backgroundColor(this.canLogin() && !this.isLoading ?
            $r("app.color.login_button_login_background_enabled") : $r("app.color.login_button_login_background_disabled")
          )
          .alignRules({
            top: { anchor: 'passwordInput', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .margin({ top: 20 })
          .fontColor($r("app.color.login_button_login_font"))
          .enabled(this.canLogin() && !this.isLoading)  //登录时禁用
          .onClick(() => {
            this.handleLogin();
          })

        //注册按钮
        Button($r('app.string.text_login_RegisterAccount'))
          .id('registerButton')
          .width('80%')
          .height(50)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .fontColor($r("app.color.login_button_login_background_enabled"))
          .borderRadius(8)
          .border({
            width: 1,
            color: $r("app.color.login_button_login_border")
          })
          .margin({ top: 10 })
          .onClick(() => {
            this.uiContext.getRouter().pushUrl({ url: Page.REGISTER_PAGE }).catch((error: Error) => {
              console.error('Route failed:', error);
              try {
                this.uiContext.getPromptAction().showToast({
                  message: $r("app.string.error_login_UnableToOpenRegisterPage"),
                  duration: 2000
                });
              } catch (error) {
                console.error("Unknown error")
              }
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

          // 版本信息
          Text($r("app.string.app_version"))
            .fontSize(12)
            .fontColor($r("app.color.register_test_version_font"))
            .margin({ top: 40 })
        }
      }
    }
  }

  //检查本地令牌并尝试自动登录
  private checkLocalTokenAndAutoLogin():void{
    const localTokenInfo = UserManager.getLocalTokenInfo();

    if(localTokenInfo){
      console.log('Local Token is found,login...');
      this.isLoading = true;

      this.username = localTokenInfo.username;

      EventBus.emit(Event.LOGIN_BY_TOKEN, localTokenInfo);
    }
  }

  //登录
  private handleLogin() {
    if (!this.canLogin()) {
      return;
    }

    this.isLoading = true;
    this.errorMessage = "";

    EventBus.emit(Event.LOGIN, {username: this.username, password: this.password} as LoginPayload);
  }

  //本地验证表单信息
  private canLogin(): boolean {
    const usernameValid = !(this.username.trim().length === 0);
    const passwordValid = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$/.test(this.password);

    if (!usernameValid) {
      this.errorMessage = loadStringResource(this.uiAbilityContext, $r("app.string.error_login_UsernameInputError"));
      return false;
    }

    if (!passwordValid) {
      this.errorMessage = loadStringResource(this.uiAbilityContext, $r("app.string.error_login_PasswordInputError"));
      return false;
    }

    this.errorMessage = "";
    return true;
  }
}
