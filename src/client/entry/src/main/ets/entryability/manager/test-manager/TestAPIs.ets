import { UIAbility } from "@kit.AbilityKit";
import { WebsocketService } from "../../../core/service/network/websocket/server.websocket";

export function enableTest(uiAbility: UIAbility) {
  const context = uiAbility.context;

  // websocket test
  context.eventHub.on("test", testWebsocket);
}

function testWebsocket(){
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
    ws.addNewMessageObserver((msg) => {
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