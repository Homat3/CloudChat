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
import { Page } from '../core/tag/Page';
import { PermissionManager } from '../core/manager/permission-manager/PermissionManager';
import { EventBus } from '../core/service/event/EventBus';
import { Event } from '../core/tag/Event';
import { LoadContactsPayload, LoginByTokenPayload, LoginPayload } from '../core/protocol/http/client.http.protocol';
import { handleLogin, handleLoginByToken } from './server/login-server';
import { handleLoadContacts } from './server/contact-server';
import { handleLoadMessages } from './server/message-server';
import { handleRegister } from './server/register-server';

const DOMAIN = 0x0000;  //日志域标识

//应用入口
export default class MainUIAbility extends UIAbility {
  private permissionManager = new PermissionManager(this.context, abilityAccessCtrl.createAtManager());

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
      // 权限注册
    this.permissionManager.putPermissionGroup("COMMON", ['ohos.permission.INTERNET']);  // 基本权限集
    this.permissionManager.requestAllPermissions().catch((error: Error) => {
      console.error(error.name + ": " + error.message);
    });   // 权限集申请

    EventBus.on(Event.LOGIN, handleLogin);
    EventBus.on(Event.LOGIN_BY_TOKEN, handleLoginByToken);
    EventBus.on(Event.REGISTER,handleRegister);
    EventBus.on(Event.LOAD_CONTACT_LIST, handleLoadContacts);
    EventBus.on(Event.LOAD_MESSAGES, handleLoadMessages);
    EventBus.on(Event.COLOR_MODE, (colorMode: string) => {
      try {
        switch (colorMode){
          case 'dark':
            this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
            break;
          case 'light':
            this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
            break;
          case 'not_set':
            this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
            break;
          default :
            break;
        }
      } catch (e){
        console.error(e);
      }
    })

    try {
      //颜色跟随系统
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    //日志记录
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
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
}