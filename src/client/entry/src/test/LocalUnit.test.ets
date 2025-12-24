import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { HttpService } from '../main/ets/core/service/network/http/server.http'
import { AsyncCallback } from '@kit.BasicServicesKit';
import { http } from '@kit.NetworkKit';
import { WebsocketService } from '../main/ets/core/service/network/websocket/server.websocket';
import { ConnectFailedError } from '../main/ets/core/service/network/websocket/error.websocket';

export function localUnitTest() {
  describe('LocalUnitTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    it('assertContain', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
    });
  });
}

interface PasswordPayload{
  username: string,
  password: string
}
interface TestInfo{
  type: string,
  payload: PasswordPayload
}
export function httpServiceTest(){
  describe('HttpServiceTest', () => {
    let httpService: HttpService;
    const uri = '/test';

    beforeAll(() => {
      httpService = new HttpService("cloudchat.infinomat.com", "14514", false);
    });

    it('HttpServiceGetRequestTest', 0, async () => {
      const callback: AsyncCallback<http.HttpResponse> = (err, res) => {
        if (err) {
          console.error(JSON.stringify(err));
        } else {
          console.info("Received: " + JSON.stringify(res));
          response = JSON.stringify(res);
        }
      };
      const testInfo: TestInfo = {
        type: "LOGIN",
        payload: {
          username: "test",
          password: "test",
        }
      }
      let response: string | null = null;
      httpService.post(uri, testInfo, callback);
      const startTime = Date.now();
      while (!response && Date.now() - startTime < 5000) {
        await new Promise<void>(resolve => setTimeout(resolve, 100));
      }
      expect(response).not().assertNull();
    });

    it('HttpServicePostRequestTest', 0, async () => {
      const callback: AsyncCallback<http.HttpResponse> = (err, res) => {
        if (err) {
          console.error(JSON.stringify(err));
        } else {
          console.info("Received: " + JSON.stringify(res));
          response = JSON.stringify(res);
        }
      };
      const testInfo: TestInfo = {
        type: "LOGIN",
        payload: {
          username: "test",
          password: "test",
        }
      }
      let response: string | null = null;
      httpService.post(uri, testInfo, callback);
      const startTime = Date.now();
      while (!response && Date.now() - startTime < 5000) {
        await new Promise<void>(resolve => setTimeout(resolve, 100));
      }
      expect(response).not().assertNull();
    });
  });
}

export function websocketServiceTest(){
  describe('WebsocketServiceTest', () => {
    let websocketService: WebsocketService;

    beforeAll(() => {
      websocketService = new WebsocketService("cloudchat.infinomat.com", "14514");
      try {
        websocketService.connect();
      }
      catch (e){
        console.error(e);
      }
    });

    it('WebsocketServiceRequestTest', 0, async () => {
      let receive: string | null = null;
      websocketService.addNewMessageObserver((get) => {
        receive = get;
      })
      setTimeout(() => {
        expect(receive).not().assertNull();
      }, 5000)
      const testInfo: TestInfo = {
        type: "LOGIN",
        payload: {
          username: "test",
          password: "test",
        }
      }
      try {
        websocketService.send(testInfo);
      }
      catch (e) {
        console.error(e);
      }
      const startTime = Date.now();
      while (!receive && Date.now() - startTime < 5000) {
        await new Promise<void>(resolve => setTimeout(resolve, 100));
      }
      expect(receive).not().assertNull();
    });
  });
}