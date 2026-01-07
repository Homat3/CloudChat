import { UIAbility } from '@kit.AbilityKit';
import { WebsocketService } from '../../service/network/websocket/server.websocket';

/**
 * @description 在 Ability 的 OnCreate 事件中调用以开启测试函数
 * @param uiAbility
 * @example
* onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
 *   ...
 *   enableTest(this);
 *   ...
 * }
 */
export function enableTest(uiAbility: UIAbility) {
  const context = uiAbility.context;

  context.eventHub.on("test", testWebsocket);
}

// websocket test
function testWebsocket() {
  interface PasswordPayload {
    username: string;
    password: string;
  }

  interface TestInfo {
    type: string;
    payload: PasswordPayload;
  }

  const ws = new WebsocketService("cloudchat.infinomat.com", "14514");
  try {
    ws.connect();
    ws.addMessageObserver((msg) => {
      console.log(JSON.stringify(msg));
    });
    const testInfo: TestInfo = {
      type: "LOGIN",
      payload: {
        username: "test",
        password: "test",
      }
    };
    ws.send(testInfo);
  } catch (e) {
    console.error(e);
  }
}