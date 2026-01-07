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
import {
  AcceptFriendRequestPayload,
  AddFriendRequestPayload,
  DeleteContactPayload,
  LoadContactsPayload,
  LoadFriendRequestPayload,
  LoadMessagesPayload,
  LoginByTokenPayload, LoginPayload,
  RefuseFriendRequestPayload,
  RegisterPayload,
  SearchForUserByIdPayload,
  SearchForUserByUserNamePayload,
  UpdateProfilePayload} from '../core/protocol/http/client.http.protocol';
import { handleLogin, handleLoginByToken } from './server/login-server';
import { handleDeleteContact, handleLoadContacts } from './server/contact-server';
import { handleLoadMessages, handleSendMessage } from './server/message-server';
import { handleRegister } from './server/register-server';
import { CloudChat } from '../CloudChat';
import {
  handleAcceptRequest,
  handleLoadFriendRequest,
  handlePostFriendRequest,
  handleRefuseRequest,
  handleSearchForUsersById, handleSearchForUsersByName } from './server/friend_request-server';
import { SendMessagePayload } from '../core/protocol/websocket/client.websocket.protocol';
import { receive, send } from '../core/protocol/http/agent.http';
import { createNewConversation, deleteConversation, postMessage } from './server/ai-server';
import { handleUpdateProfile } from './server/profile-server';
import { ProfileUpdatedSuccessPayload } from '../core/protocol/http/service.http.protocol';

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

    CloudChat.websocketServer.connect();  // 建立长连接

    EventBus.on(Event.LOGIN, (data: LoginPayload): void => handleLogin(data));
    EventBus.on(Event.LOGIN_BY_TOKEN, (data: LoginByTokenPayload): void => handleLoginByToken(data));
    EventBus.on(Event.REGISTER, (data: RegisterPayload): void => handleRegister(data));

    EventBus.on(Event.LOAD_CONTACT_LIST, (data: LoadContactsPayload): void => handleLoadContacts(data));
    EventBus.on(Event.LOAD_MESSAGES_START, (count: number): void => CloudChat.startLoadMessage(count));
    EventBus.on(Event.LOAD_MESSAGES, (data: LoadMessagesPayload): void => handleLoadMessages(data));
    EventBus.on(Event.DELETE_CONTACT, (data: DeleteContactPayload): void => handleDeleteContact(data));

    EventBus.on(Event.SEND_MESSAGE, (data: SendMessagePayload): void => handleSendMessage(data));

    EventBus.on(Event.SEARCH_FOR_USERS_BY_NAME, (data: SearchForUserByUserNamePayload): void => handleSearchForUsersByName(data));
    EventBus.on(Event.SEARCH_FOR_USERS_BY_ID, (data: SearchForUserByIdPayload): void => handleSearchForUsersById(data));

    EventBus.on(Event.LOAD_FRIEND_REQUEST, (data: LoadFriendRequestPayload): void => handleLoadFriendRequest(data));
    EventBus.on(Event.ACCEPT_REQUEST, (data: AcceptFriendRequestPayload): void => handleAcceptRequest(data));
    EventBus.on(Event.REFUSE_REQUEST, (data: RefuseFriendRequestPayload): void => handleRefuseRequest(data));
    EventBus.on(Event.ADD_FRIEND_REQUEST, (data: AddFriendRequestPayload): void => handlePostFriendRequest(data));

    EventBus.on(Event.UPDATE_PROFILE, (data: UpdateProfilePayload): void => handleUpdateProfile(data));

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

    EventBus.on(Event.AGENT_CONVERSATION_CREATE, (payload: send.CreateNewConversationPayload): void => createNewConversation({ username: payload.username }));
    EventBus.on(Event.AGENT_CONVERSATION_CREATE_FAILED, (error: string) => {
      CloudChat.agentConversation = null;
    })
    EventBus.on(Event.AGENT_CONVERSATION_CREATE_SUCCESS, (payload: receive.ConversationCreateSuccessPayload) => {
      CloudChat.agentConversation = { id: payload.conversationId, name: payload.conversationName };
    })
    EventBus.on(Event.AGENT_CONVERSATION_DELETE, (payload: send.DeleteConversationPayload): void => deleteConversation({ conversationId: payload.conversationId }));
    EventBus.on(Event.AGENT_CONVERSATION_DELETE_FAILED, (error: string) => {
      CloudChat.agentConversation = null;
    })
    EventBus.on(Event.AGENT_CONVERSATION_DELETE_SUCCESS, () => {
      CloudChat.agentConversation = null;
    })
    EventBus.on(Event.AGENT_POST_MESSAGE, (data: send.PostMessagePayload): void => postMessage(data));

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

  onDestroy(): void | Promise<void> {
    CloudChat.websocketServer.disconnect();
  }
}