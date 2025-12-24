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
import { WebsocketService } from '../core/service/network/websocket/server.websocket';
import { JSON } from '@kit.ArkTS';
import { ClientMessage, ClientMessageType, LoginPayload } from '../core/protocol/websocket/client.protocol';
import { LoginFailurePayload, ServiceMessage, ServiceMessageType } from '../core/protocol/websocket/service.protocol';
import { Page, WindowStageManager } from './manager/window-stage-manager/WindowStageManager';
import { CallBackManager } from './manager/call-back-manager/CallBackManager';

const DOMAIN = 0x0000;  //日志域标识

//应用入口
export default class MainUIAbility extends UIAbility {
  private windowStageManager: WindowStageManager | null = null;   // window stage 管理器
  private callBackManager: CallBackManager | null = null;   // call back 管理器

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 权限申请
    let permissions: Array<Permissions> = ['ohos.permission.INTERNET'];

    abilityAccessCtrl.createAtManager().requestPermissionsFromUser(this.context, permissions)
      .then((data) => {
        console.info("Internet权限申请结果：" + JSON.stringify(data));
      })
      .catch((err: Error) => {
        console.error("权限申请失败：" + JSON.stringify(err));
      });

    // 消息响应注册
    this.callBackManager = new CallBackManager(this.context.eventHub);

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

    this.windowStageManager = new WindowStageManager(windowStage);

    // 初始化加载联系人列表
    this.windowStageManager.switchPage(Page.LOGIN_PAGE);
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
  private handleLogin(data: LoginPayload): void {
    const ws = new WebsocketService("cloudchat.infinomat.com", "14514");
    try {
      ws.connect();
      ws.addNewMessageObserver((msg) => {
        //控制台响应
        console.log("Received: " + msg);
        let receivedObject = JSON.parse(msg) as ServiceMessage;
        //处理登录相应
        if( receivedObject.type === ServiceMessageType.LOGIN_SUCCESS) {
          this.windowStageManager?.switchPage(Page.MAIN_PAGE);
        } else if(receivedObject.type === ServiceMessageType.LOGIN_FAILURE) {
          //更新UI显示错误信息
          this.context.eventHub.emit("loginError", (receivedObject.payload as LoginFailurePayload).error);
        }
      });

      const loginInfo: ClientMessage = {
        type: ClientMessageType.LOGIN,
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
}