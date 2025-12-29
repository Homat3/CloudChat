import { User } from '../../core/models/models'
import { App, promptAction, router } from '@kit.ArkUI';
import { Page } from '../../entryability/manager/window-stage-manager/WindowStageManager';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';
import { loadStringResource } from '../../core/util/load-resource';
import { RegisterResult, RegisterService } from './register-service';
import { UserManager } from './user-manager';
import { RegisterSuccessPayload } from '../../core/protocol/http/service.http.protocol';

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

  private registerService:RegisterService = new RegisterService();

  build() {
    Column({ space: 8 }) {
      // Logo/标语顶部区域
      Column() {
        Text('💬')
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
            this.userNameError = this.validateUserName(value);
            this.updateErrorMessage();
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
            this.emailError = this.validateEmail(value);
            this.updateErrorMessage();
          })

        // 邮箱错误提示（实时）
        if (this.emailError) {
          Text(this.emailError)
            .fontColor(Color.Red)
            .fontSize(12)
            .width('100%')
            .textAlign(TextAlign.Start)
            .padding({ left: 4 })
        }

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
            this.passwordError = this.validatePassword(value);
            // 如果确认密码已输入，需要重新验证确认密码
            if (this.passWord_check) {
              this.confirmPasswordError = this.validateConfirmPassword(value, this.passWord_check);
            }
            this.updateErrorMessage();
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
            this.confirmPasswordError = this.validateConfirmPassword(this.passWord, value);
            this.updateErrorMessage();
          })

        // 确认密码错误提示（实时）
        if (this.confirmPasswordError) {
          Text(this.confirmPasswordError)
            .fontColor(Color.Red)
            .fontSize(12)
            .width('100%')
            .textAlign(TextAlign.Start)
            .padding({ left: 4 })
        }

        // 注册按钮
        //TODO:发送注册信息
        Button(this.isLoading ? $r("app.string.text_register_Registering") : $r("app.string.text_register_Register"))
          .width('100%')
          .height(48)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .backgroundColor(this.canRegister() ? $r("app.color.login_button_login_background_enabled") : $r("app.color.login_button_login_background_disabled"))
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
            this.uiContext.getRouter().pushUrl({
              url: Page.LOGIN_PAGE
            }).catch((e: Error) => {
              console.error(e.message);
            });
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
          .padding({ left: 8, right: 8, top: 8, bottom: 8 })
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

  //内部实现

  // 直接跳转版本
  private handleRegister() {
    console.log('开始注册处理');
    // 验证表单
    if (!this.validateAll()) {
      console.log('表单验证失败');
      return;
    }
    // 设置加载状态
    this.isLoading = true;
    this.errorMessage = '';
    console.log('表单验证通过，准备直接跳转');

    // // 这里假设注册总是成功，直接跳转到联系人页面
    // console.log('跳转到:', Page.CONTACT_LIST_PAGE);

    this.registerService.register(this.userName,this.passWord,this.email)
      .then((result:RegisterResult)=>{
        this.isLoading = false;

        if (result.success && result.user) {
          console.log('注册成功，用户对象:', result.user);

          // 注册成功，保存用户数据
          // 注意：UserManager.saveUserData现在需要RegisterSuccessPayload，但我们可以传递User对象转换
          const userPayload : RegisterSuccessPayload= {
            userId: result.user.userId,
            username: result.user.username,
            email: result.user.email,
            avatar: result.user.avatar,
            token: result.user.token || ''
          };
          const savedUser = UserManager.saveUserData(userPayload, true);


          // 显示成功提示
          promptAction.showToast({
            message: loadStringResource(this.uiAbilityContext, $r("app.string.text_register_RegisterSuccess")),
            duration: 1500
          });
          router.pushUrl({
            url: Page.CONTACT_LIST_PAGE
          }).catch((err:Error) => {
            console.error('跳转失败:',err);
          })
        } else {
          // 注册失败
          console.log('注册失败:', result.error);
          this.errorMessage = result.error || '注册失败';
        }
      })
      .catch((err: Error) => {
          console.error('跳转失败:', err);
          this.isLoading = false;
          this.errorMessage = loadStringResource(this.uiAbilityContext, $r("app.string.text_register_RegisterFailed")) + `: ${err.message}`;
    });
  }

  // 更新全局错误信息
  private updateErrorMessage(): void {
    this.errorMessage = '';
  }

  // 验证所有字段
  private validateAll(): boolean {
    console.log('验证所有字段');

    this.userNameError = this.validateUserName(this.userName);
    this.emailError = this.validateEmail(this.email);
    this.passwordError = this.validatePassword(this.passWord);
    this.confirmPasswordError = this.validateConfirmPassword(this.passWord, this.passWord_check);

    const hasError = !!(this.userNameError || this.emailError || this.passwordError || this.confirmPasswordError);

    if (hasError) {
      console.log('验证失败，存在错误');
    } else {
      console.log('所有字段验证通过');
    }

    return !hasError;
  }

  // 检查是否可以注册
  private canRegister(): boolean {
    // 只有所有字段都有值，且没有正在加载时才能注册
    const canRegister = this.userName.trim().length > 0 &&
      this.email.trim().length > 0 &&
      this.passWord.length > 0 &&
      this.passWord_check.length > 0 &&
      !this.isLoading;

    console.log(`canRegister检查: ${canRegister}`);
    return canRegister;
  }

  // 各个字段的验证函数
  private validateUserName(username: string): string {
    if (!username.trim()) {
      return loadStringResource(this.uiAbilityContext, $r("app.string.error_register_UsernameRequireNotNull"));
    }
    const usernameRegex = /^[a-zA-Z0-9_]{5,20}$/;
    if (!usernameRegex.test(username)) {
      return loadStringResource(this.uiAbilityContext, $r("app.string.error_register_UsernameInputError"));
    }
    return '';
  }


  //实时表单元素检验
  private validateEmail(email: string): string {
    if (!email.trim()) {
      return loadStringResource(this.uiAbilityContext, $r("app.string.error_register_EmailRequireNotNull"));
    }
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return loadStringResource(this.uiAbilityContext, $r("app.string.error_register_EmailInputError"));
    }
    return '';
  }

  private validatePassword(password: string): string {
    if (!password) {
      return loadStringResource(this.uiAbilityContext, $r("app.string.error_register_PasswordRequireNotNull"));
    }
    if (password.length < 8) {
      return loadStringResource(this.uiAbilityContext, $r("app.string.error_register_PasswordInputError"));
    }
    const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$/;
    if (!passwordRegex.test(password)) {
      return loadStringResource(this.uiAbilityContext, $r("app.string.error_register_PasswordRequireLettersAndNumbers"));
    }
    return '';
  }

  private validateConfirmPassword(password: string, confirmPassword: string): string {
    if (!confirmPassword) {
      return loadStringResource(this.uiAbilityContext, $r("app.string.error_register_PasswordRequireConfirm"));
    }
    if (password !== confirmPassword) {
      return loadStringResource(this.uiAbilityContext, $r("app.string.error_register_PasswordConfirmError"));
    }
    return '';
  }
}