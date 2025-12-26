import { common } from '@kit.AbilityKit';
import { HttpService } from '../../core/service/network/http/server.http';
import { CallBackManager, Event } from '../../entryability/manager/call-back-manager/CallBackManager';
import { Page } from '../../entryability/manager/window-stage-manager/WindowStageManager';
import { http } from '@kit.NetworkKit';
import { HttpClientMessage, HttpClientMessageType } from '../../core/protocol/http/client.http.protocol';
import { LoginPayload } from '../../core/protocol/websocket/client.websocket.protocol';
import { beforeAll, expect } from '@ohos/hypium';
import { AsyncCallback } from '@kit.BasicServicesKit';

interface LoginInfo{
  type : HttpClientMessageType
  payload :LoginPayload
}

@Entry
@Component
struct LoginPage {
  // 状态
  @State username: string = '';
  @State password: string = '';
  @State errorMessage: string = '';
  @State isLoading: boolean = false;
  @State rememberMe: boolean = false;
  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;
  // 管理器
  private callBackManager: CallBackManager = new CallBackManager(this.uiAbilityContext.eventHub);   // call back 管理器

  //尝试读取保存的用户名
  aboutToAppear(): void {
    try {
      // 监听登录成功事件
      this.callBackManager.addEventSubscription(Event.LOGIN_SUCCESS, () => {
        this.uiContext.getRouter().replaceUrl({ url: 'pages/Home' }).catch((e: Error) => {
          console.error(e.message);
        });
      });
      // 监听登录失败事件
      this.callBackManager.addEventSubscription(Event.LOGIN_FAILED, (err: Error) => {
        this.isLoading = false;
        this.errorMessage = err.message || '登录失败';
      });
    } catch (error) {
      console.error(error);
    }
  }

  aboutToDisappear(): void {
    // 移除事件监听
    try {
      this.callBackManager.removeEventSubscription(Event.LOGIN_SUCCESS);
      this.callBackManager.removeEventSubscription(Event.LOGIN_FAILED);
    } catch (error) {
      console.error(error);
    }
  }

  build() {
    Column({ space: 8 }) {
      Column() {
        //Logo
        Text('💬').fontSize(64).margin({ bottom: 8 })
        Column() {
          Text('CloudChat').fontSize(28).fontWeight(FontWeight.Bold).fontColor($r("app.color.login_title_font"))
          Text('智能聊天').fontSize(14).fontWeight(FontWeight.Bold).fontColor($r("app.color.login_title_font"))
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
            color: $r("app.color.login_textInput_all_border")
          })
          .alignRules({
            top: { anchor: 'passwordInput', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onChange((value: string) => {
            this.password = value;
            this.errorMessage = '';
          })

        Row() {
          //记住我
          Row({ space: 0 }) {
            Checkbox().select(this.rememberMe).onChange((checked: boolean) => {
              this.rememberMe = checked;
            }).size({ width: 18, height: 18 })

            Text('记住我').margin({ left: 4 }).fontSize(14).fontColor($r("app.color.login_text_rememberMe_font"))
          }
          .margin({ left: 20 })
          .onClick(() => {
            this.rememberMe = !this.rememberMe;
          })

          Blank()

          //忘记密码
          Text('忘记密码？').margin({ right: 4 }).fontSize(14).fontColor($r("app.color.login_text_forgetPassword_font"))
            .onClick(() => {
              try {
                this.uiContext.getPromptAction().showToast({
                  message: '功能开发中...',
                  duration: 2000
                })
              } catch (error) {
                console.error(error);
              }
            })
        }.width('100%').padding({ left: 4, right: 4 })


        //登录按钮
        Button(this.isLoading ? '登录中...' : '登录')
          .id('loginButton')
          .width('80%')
          .height(50)
          .backgroundColor($r(this.canLogin() && !this.isLoading ?
            "app.color.login_button_login_background_enabled" : "app.color.login_button_login_background_disabled")
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
        Button($r('app.string.Register_label'))
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
            this.uiContext.getRouter().pushUrl({
              url: Page.REGISTER_PAGE
            }).catch((error: Error) => {
              console.error('Route failed:', error);
              try {
                this.uiContext.getPromptAction().showToast({
                  message: '无法打开注册页面',
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
        }
      }
    }
  }

  //检测登录验证
  private async handleLogin() {
      if(!this.canLogin()){
        return;
      }

      this.isLoading = true;
      this.errorMessage = '';

      //初始化Http服务
      const httpService = new HttpService("cloudchat.infinomat.com","14514",false);
      const uri = '/test';
     // let response : string | null = null;
      // const callback : AsyncCallback<http.HttpResponse> = (err,res)=>{
      //   if(err){
      //     console.error(JSON.stringify(err));
      //   }else{
      //     console.info("Re:"+JSON.stringify(res));
      //     response = JSON.stringify(res);
      //   }
      // }
      const loginInfo : LoginInfo = {
        type : HttpClientMessageType.LOGIN,
        payload : {
          username : this.username,
          password : this.password
        }
      };
      console.log("Request:",loginInfo)
    //发送POST请求
    httpService.post(uri,loginInfo,(err,res)=>{
        console.log("Http Response:",err,res);
        this.isLoading = false;

        if(err){
          this.errorMessage = 'HTTP Failed';
          //TODO:此处错误处理
          this.callBackManager.emit(Event.LOGIN_FAILED,new Error(this.errorMessage));
          return ;
        }

    try{
          const result = JSON.stringify(res);
          console.info("Received:",result);

          //检验响应码
          if(res.responseCode !== 200){
            this.errorMessage = `Server Failed:${res.responseCode}`;
            this.callBackManager.emit(Event.LOGIN_FAILED,new Error(this.errorMessage));
            return;
          }

         //TODO:成功返回
    }catch(err){

    }

    });


  }



  //本地验证表单信息
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


