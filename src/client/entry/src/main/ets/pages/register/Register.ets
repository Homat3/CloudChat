import { User } from '../../core/models/models'
import { promptAction, router } from '@kit.ArkUI';
import { Page } from '../../entryability/manager/window-stage-manager/WindowStageManager';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Register {
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

  build() {
    Column({ space: 8 }) {
      // Logo/标语顶部区域
      Column() {
        Text('💬')
          .fontSize(64)
          .margin({ bottom: 8 })
        Column() {
          Text('CloudChat')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor('#409EFF')

          Text('注册界面')
            .fontSize(14)
            .fontColor('#909399')
        }
      }
      .margin({ top: 40, bottom: 30 })
      .alignItems(HorizontalAlign.Center)

      // 注册表单区域
      Column({ space: 16 }) {
        // 用户名输入框
        TextInput({
          text: this.userName,
          placeholder: '请输入用户名（5-20位字母数字）'
        })
          .type(InputType.Normal)
          .height(50)
          .width('100%')
          .padding(12)
          .backgroundColor('Color.Transparent')
          .border({
            width: this.userNameError ? 2 : 1,
            color: this.userNameError ? Color.Red : '#DCDFE6'
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
          placeholder: '请输入邮箱号'
        })
          .type(InputType.Normal)
          .height(50)
          .width('100%')
          .backgroundColor('Color.Transparent')
          .border({
            width: this.emailError ? 2 : 1,
            color: this.emailError ? Color.Red : '#DCDFE6'
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
          placeholder: '请输入密码（至少8位，含字母数字）'
        })
          .type(InputType.Password)
          .height(50)
          .width('100%')
          .backgroundColor('Color.Transparent')
          .border({
            width: this.passwordError ? 2 : 1,
            color: this.passwordError ? Color.Red : '#DCDFE6'
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
          placeholder: '请再次输入密码'
        })
          .type(InputType.Password)
          .height(50)
          .width('100%')
          .backgroundColor('Color.Transparent')
          .border({
            width: this.confirmPasswordError ? 2 : 1,
            color: this.confirmPasswordError ? Color.Red : '#DCDFE6'
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
        Button(this.isLoading ? '注册中...' : '注册')
          .width('100%')
          .height(48)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .backgroundColor(this.canRegister() ? '#409EFF' : '#A0CFFF')
          .opacity(this.canRegister() ? 1 : 0.6)
          .enabled(this.canRegister() && !this.isLoading)
          .onClick(() => {
            this.handleRegister();
          })

        // 返回登录按钮
        Button('返回登录')
          .width('100%')
          .height(48)
          .fontSize(16)
          .fontColor('#409EFF')
          .backgroundColor(Color.Transparent)
          .borderRadius(8)
          .border({
            width: 1,
            color: '#409EFF'
          })
          .margin({ top: 10 })
          .onClick(() => {
            router.pushUrl({
              url: Page.LOGIN_PAGE
            }).catch(() => {
              router.pushUrl({
                url: 'pages/login/LoginPage'
              });
            });
          })

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
          .backgroundColor('#FFEBEE')
          .borderRadius(8)
        }

        // 版本信息
        Text('CloudChat v2.0.0 · 鸿蒙版')
          .fontSize(12)
          .fontColor('#909399')
          .margin({ top: 40 })
      }
      .width('85%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7FA')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  //内部实现

  // 直接跳转版本
  private handleRegister() {
    console.log('开始注册处理');
    // 1. 验证表单
    if (!this.validateAll()) {
      console.log('表单验证失败');
      return;
    }
    // 2. 设置加载状态
    this.isLoading = true;
    this.errorMessage = '';
    console.log('表单验证通过，准备直接跳转');

    // 这里假设注册总是成功，直接跳转到联系人页面
    console.log('跳转到:', Page.CONTACT_LIST_PAGE);
    // 先显示成功提示
    promptAction.showToast({
      message: '注册成功',
      duration: 1500
    });
    // 直接跳转
    router.pushUrl({
      url: Page.CONTACT_LIST_PAGE
    }).then(() => {
      console.log('跳转成功');
      this.isLoading = false; // 理论上跳转成功后这个页面就销毁了
    }).catch((err: Error) => {
      console.error('跳转失败:', err);
      this.isLoading = false;
      this.errorMessage = `跳转失败: ${err.message || '页面不存在'}`;
      // 显示更详细的错误
      promptAction.showToast({
        message: `跳转失败: ${err.message || '未知错误'}`,
        duration: 3000
      });
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
      return '用户名不能为空';
    }
    const usernameRegex = /^[a-zA-Z0-9_]{5,20}$/;
    if (!usernameRegex.test(username)) {
      return '用户名需5-20位字母数字或下划线';
    }
    return '';
  }


  //实时表单元素检验
  private validateEmail(email: string): string {
    if (!email.trim()) {
      return '邮箱不能为空';
    }
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return '请输入有效的邮箱地址';
    }
    return '';
  }

  private validatePassword(password: string): string {
    if (!password) {
      return '密码不能为空';
    }
    if (password.length < 8) {
      return '密码至少需要8位';
    }
    const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$/;
    if (!passwordRegex.test(password)) {
      return '密码需包含字母和数字';
    }
    return '';
  }

  private validateConfirmPassword(password: string, confirmPassword: string): string {
    if (!confirmPassword) {
      return '请确认密码';
    }
    if (password !== confirmPassword) {
      return '两次输入的密码不一致';
    }
    return '';
  }
}