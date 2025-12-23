import {
  abilityAccessCtrl,
  AbilityConstant,
  ConfigurationConstant,
  Permissions,
  UIAbility,
  Want
} from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { WebsocketService } from '../service/network/websocket/server.websocket';
import { JSON } from '@kit.ArkTS';

const DOMAIN = 0x0000;  //日志域标识

//应用入口
export default class MainUIAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    let context = this.context;
    let permissions: Array<Permissions> = ['ohos.permission.INTERNET'];

    abilityAccessCtrl.createAtManager().requestPermissionsFromUser(context, permissions)
      .then((data) => {
        console.info("Internet权限申请结果：" + JSON.stringify(data));
      })
      .catch((err: Error) => {
        console.error("权限申请失败：" + JSON.stringify(err));
      });

    this.context.eventHub.on("test", this.testWebsocket);

    try {
      //颜色跟随系统
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    //日志记录
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    //Ability销毁时调用，释放资源
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    //窗口阶段对象，管理UI显示
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/contact-list/ContactList', (err) => {
      //加载第一个页面
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    //窗口销毁后释放UI资源
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    //回到应用前台
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    //回到应用后台
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  //登录逻辑
  private handleLogin(data: {username: string, password: string }): void {
    interface LoginPayload {  //负载
      username: string,
      password: string
    }
    interface LoginInfo {
      type: string,
      payload: LoginPayload
    }

    const ws = new WebsocketService("cloudchat.infinomat.com", "14514");
    try {
      ws.connect();
      ws.addNewMessageObserver((msg) => {
        //控制台响应
        console.log(JSON.stringify(msg));
        //处理登录相应
        if( msg.type === 'LOGIN_SUCCESS') {
          window.getLastWindow(this.context).then((win) => {
            win.loadContent('pages/contact-list/ContactList');
          });
        } else if(msg.type === 'LOGIN_FAILED') {
          //更新UI显示错误信息
          this.context.eventHub.emit("loginError", msg.reason);
        }
      });

      const loginInfo = {
        type: "LOGIN",
        payload: {
          username: data.username,
          password: data.password
        }
      }
      ws.send(loginInfo);
    } catch(e) {
      console.error(e);
      this.context.eventHub.emit("loginError", "连接服务器失败");
    }
  }

  // websocket test
  testWebsocket(): void{
    interface PasswordPayload{
      username: string,
      password: string
    }
    interface TestInfo{
      type: string,
      payload: PasswordPayload
    }
    const ws = new WebsocketService("cloudchat.infinomat.com", "14514");
    try {
      ws.connect();
      ws.addNewMessageObserver((msg)=>{
        console.log(JSON.stringify(msg));
      })
      const testInfo: TestInfo = {
        type: "LOGIN",
        payload: {
          username: "test",
          password: "test",
        }
      }
      ws.send(testInfo)
    } catch (e) {
      console.error(e);
    }
  }
}