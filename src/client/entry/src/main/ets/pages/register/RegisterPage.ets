
import { common } from '@kit.AbilityKit';
import { loadStringResource } from '../../core/service/resource/load-resource';
import { EventBus } from '../../core/service/event/EventBus';
import { Event } from '../../core/tag/Event';
import { RegisterFailurePayload, RegisterSuccessPayload } from '../../core/protocol/http/service.http.protocol';
import { CloudChat } from '../../CloudChat';
import { User } from '../../core/models/models';
import { RegisterPayload } from '../../core/protocol/http/client.http.protocol';
import { Page } from '../../core/tag/Page';
@Entry
@Component
struct Register {
  // 状态变量
  @State Title: string = '注册界面'
  @State userName: string = ''
  @State email: string = ''
  @State passWord: string = ''
  @State passWord_check: string = ''
  @State errorMessage: string = ''
  @State isLoading: boolean = false
  // 添加各个字段的独立错误状态，用于实时验证
  @State userNameError: string = ''
  @State emailError: string = ''
  @State passwordError: string = ''
  @State confirmPasswordError: string = ''
  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  aboutToAppear(): void {
    try {
      //注册失败事件
      EventBus.on(Event.REGISTER_FAILED, (payload: RegisterFailurePayload) => {
        this.isLoading = false;
        this.uiContext.getPromptAction().showToast({
          message: loadStringResource(this.uiAbilityContext, $r("app.string.error_register_RegisterFailed")) + ": " +
          payload.error,
          duration: 2000
        });
      });

      //注册成功事件
      EventBus.on(Event.REGISTER_SUCCESS, (payload: RegisterSuccessPayload) => {
        CloudChat.currentUser =
          new User(payload.userId, payload.username, payload.email, payload.avatar, payload.token);
        this.uiContext.getRouter().replaceUrl({ url: Page.MAIN }).catch((err: Error) => {
          console.error(err.message);
        })
      });

    } catch (error) {
      console.error(error);
    }
  }

  build() {
    Column({ space: 8 }) {
      // Logo/标语顶部区域
      Column() {
        Text($r('app.string.text_all_logo'))
          .fontSize(64)
          .margin({ bottom: 8 })
        Column() {
          Text($r("app.string.text_all_Title"))
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor($r("app.color.register_title_font"))

          Text($r("app.string.text_register_RegisterYourAccount"))
            .fontSize(14)
            .fontColor($r("app.color.register_text_registerYourAccount_font"))
        }
      }
      .margin({ top: 40, bottom: 30 })
      .alignItems(HorizontalAlign.Center)

      // 注册表单区域
      Column({ space: 16 }) {
        // 用户名输入框
        TextInput({
          text: this.userName,
          placeholder: $r("app.string.text_register_UsernamePlaceholder")
        })
          .type(InputType.Normal)
          .height(50)
          .width('100%')
          .padding(12)
          .backgroundColor(Color.Transparent)
          .border({
            width: this.userNameError ? 2 : 1,
            color: this.userNameError ? Color.Red : $r("app.color.register_textInput_font_normal")
          })
          .onChange((value: string) => {
            this.userName = value;
            this.errorMessage = '';
          })

        // 用户名错误提示
        if (this.userNameError) {
          Text(this.userNameError)
            .fontColor(Color.Red)
            .fontSize(12)
            .width('100%')
            .textAlign(TextAlign.Start)
            .padding({ left: 4 })
        }

        // 邮箱输入框
        TextInput({
          text: this.email,
          placeholder: $r("app.string.text_register_EmailPlaceholder")
        })
          .type(InputType.Normal)
          .height(50)
          .width('100%')
          .backgroundColor(Color.Transparent)
          .border({
            width: this.emailError ? 2 : 1,
            color: this.emailError ? Color.Red : $r("app.color.register_textInput_font_normal")
          })
          .onChange((value: string) => {
            this.email = value;
            this.errorMessage = '';
          })
        // 密码输入框
        TextInput({
          text: this.passWord,
          placeholder: $r("app.string.text_register_PasswordPlaceholder")
        })
          .type(InputType.Password)
          .height(50)
          .width('100%')
          .backgroundColor(Color.Transparent)
          .border({
            width: this.passwordError ? 2 : 1,
            color: this.passwordError ? Color.Red : $r("app.color.register_textInput_font_normal")
          })
          .onChange((value: string) => {
            this.passWord = value;
            this.errorMessage = '';
          })

        // 密码错误提示（实时）
        if (this.passwordError) {
          Text(this.passwordError)
            .fontColor(Color.Red)
            .fontSize(12)
            .width('100%')
            .textAlign(TextAlign.Start)
            .padding({ left: 4 })
        }

        // 确认密码输入框
        TextInput({
          text: this.passWord_check,
          placeholder: $r("app.string.text_register_PasswordAgainPlaceholder")
        })
          .type(InputType.Password)
          .height(50)
          .width('100%')
          .backgroundColor(Color.Transparent)
          .border({
            width: this.confirmPasswordError ? 2 : 1,
            color: this.confirmPasswordError ? Color.Red : $r("app.color.register_textInput_font_normal")
          })
          .onChange((value: string) => {
            this.passWord_check = value;
            this.errorMessage = '';
          })


        // 注册按钮
        Button(this.isLoading ? $r("app.string.text_register_Registering") : $r("app.string.text_register_Register"))
          .width('100%')
          .height(48)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .backgroundColor(this.canRegister() ? $r("app.color.login_button_login_background_enabled") :
            $r("app.color.login_button_login_background_disabled"))
          .opacity(this.canRegister() ? 1 : 0.6)
          .enabled(this.canRegister() && !this.isLoading)
          .onClick(() => {
            this.handleRegister();
          })

        // 返回登录按钮
        Button($r("app.string.text_register_BackToLogin"))
          .width('100%')
          .height(48)
          .fontSize(16)
          .fontColor($r("app.color.register_button_back_font"))
          .backgroundColor(Color.Transparent)
          .borderRadius(8)
          .border({
            width: 1,
            color: $r("app.color.register_button_back_border")
          })
          .margin({ top: 10 })
          .onClick(() => {
            this.uiContext.getRouter().back();
          });

        // 系统错误提示
        if (this.errorMessage) {
          Row({ space: 8 }) {
            Text(this.errorMessage)
              .fontSize(14)
              .fontColor(Color.Red)
              .lineHeight(20)
          }
          .width('100%')
          .padding({
            left: 8,
            right: 8,
            top: 8,
            bottom: 8
          })
          .backgroundColor($r("app.color.register_row_error_background"))
          .borderRadius(8)
        }

        // 版本信息
        Text($r("app.string.app_version"))
          .fontSize(12)
          .fontColor($r("app.color.register_test_version_font"))
          .margin({ top: 40 })
      }
      .width('85%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r("app.color.register_colum_main_background"))
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  private handleRegister() {
    if (!this.canRegister()) {
      return;
    }
    this.isLoading = true;
    this.errorMessage = '';
    EventBus.emit(Event.REGISTER,
      { username: this.userName, password: this.passWord, email: this.email } as RegisterPayload)
  }

  // 检查是否可以注册
  private canRegister(): boolean {
    // 只有所有字段都有值，且没有正在加载时才能注册
    const canRegister = this.userName.trim().length > 0 &&
      this.email.trim().length > 0 &&
      this.passWord.length > 0 &&
      this.passWord_check.length > 0 &&
      !this.isLoading;

    const usernameValid = !(this.userName.trim().length === 0);
    const emailValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.email);
    const passwordValid = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$/.test(this.passWord);
    const passwordCheckedValid = (this.passWord_check == this.passWord) && !(this.userName.trim().length === 0);

    if (!usernameValid) {
      this.errorMessage =
        loadStringResource(this.uiAbilityContext, $r("app.string.error_register_UsernameRequireNotNull"));
      return false;
    }
    if (!emailValid) {
      this.errorMessage = loadStringResource(this.uiAbilityContext, $r("app.string.error_register_EmailInputError"));
      return false;
    }
    if (!passwordValid) {
      this.errorMessage = loadStringResource(this.uiAbilityContext, $r("app.string.error_register_PasswordInputError"));
      return false;
    }
    if (!passwordCheckedValid) {
      this.errorMessage =
        loadStringResource(this.uiAbilityContext, $r("app.string.error_register_PasswordConfirmError"));
      return false;
    }
    console.log(`canRegister检查: ${canRegister}`);
    return canRegister;
  }
}