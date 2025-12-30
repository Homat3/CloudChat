import {
  abilityAccessCtrl,
  AbilityConstant,
  ConfigurationConstant,
  UIAbility,
  Want
} from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { JSON } from '@kit.ArkTS';
import { LoginSuccessPayload } from '../core/protocol/websocket/service.websocket.protocol';
import { Page, WindowStageManager } from '../core/manager/page-manager/PageManager';
import { CallBackManager, Event } from '../core/manager/call-back-manager/CallBackManager';
import { PermissionManager } from '../core/manager/permission-manager/PermissionManager';
import { CloudChat } from '../CloudChat';
import { User } from '../core/models/models';
import { handleLogin, handleLoginByToken } from './server/login-server';
import { LoadContactsPayload, LoginByTokenPayload, LoginPayload } from '../core/protocol/http/client.http.protocol';
import { handleLoadContacts } from './server/contact-server';

const DOMAIN = 0x0000;  //日志域标识

//应用入口
export default class MainUIAbility extends UIAbility {
  private get permissionManager(): PermissionManager{
    return new PermissionManager(this.context, abilityAccessCtrl.createAtManager());
  }
  private get callBackManager(): CallBackManager {
    return new CallBackManager(this.context.eventHub);
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
      // 权限注册
    this.permissionManager.putPermissionGroup("COMMON", ['ohos.permission.INTERNET']);  // 基本权限集
    this.permissionManager.requestAllPermissions().catch((error: Error) => {
      console.error(error.name + ": " + error.message);
    });   // 权限集申请

    // 消息响应注册
    try {
      this.callBackManager.addEventSubscription(Event.LOGIN, (payload: LoginPayload): void => handleLogin(this.context, payload));
      this.callBackManager.addEventSubscription(Event.LOGIN_BY_TOKEN, (payload: LoginByTokenPayload): void => handleLoginByToken(this.context, payload));
      this.callBackManager.addEventSubscription(Event.LOGIN_FAILED, this.handleLoginFailed);
      this.callBackManager.addEventSubscription(Event.LOGIN_SUCCESS, this.handleLoginSuccess);

      this.callBackManager.addEventSubscription(Event.LOAD_CONTACT_LIST, (payload: LoadContactsPayload): void => handleLoadContacts(this.context, payload));
    } catch (error) {
      console.error("Unknown error");
    }

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
    if (this.callBackManager){
      // 移除事件监听
      try {
        this.callBackManager.removeEventSubscription(Event.LOGIN);
        this.callBackManager.removeEventSubscription(Event.LOGIN_FAILED);
        this.callBackManager.removeEventSubscription(Event.LOGIN_SUCCESS);
      } catch (error) {
        console.error(error);
      }
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    //窗口阶段对象，管理UI显示
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 初始化加载联系人列表
    try {
      windowStage.loadContent(Page.LOGIN_PAGE, (err) => {
        if (err.code) {
          console.error("Failed to load the page: " + JSON.stringify(err) + " Check if the path \"" + Page.LOGIN_PAGE + "\" is correct");
        }
        console.info('Succeeded in loading the content.');
      });
    } catch (error) {
      console.error(error);
    }
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

  // 登录错误逻辑
  private handleLoginFailed(errorMessage: string){
    console.error(errorMessage);
  }

  // 登录成功逻辑
  private handleLoginSuccess(successInfo: LoginSuccessPayload){
    CloudChat.currentUser = new User(successInfo.userId, successInfo.username, successInfo.email, successInfo.avatar, successInfo.token);
  }
}