import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { HttpService } from '../main/ets/service/network/http/server.http'
import { createDefaultRequestOptions } from '../main/ets/service/network/http/config.http'
import { AsyncCallback } from '@kit.BasicServicesKit';
import { http } from '@kit.NetworkKit';
import { WebsocketService } from '../main/ets/service/network/websocket/server.websocket';

export default function localUnitTest() {
  describe('localUnitTest', () => {
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

function networkServiceTest(){
  httpServiceTest();
  websocketServiceTest();
}
function httpServiceTest(){
  describe('Http Service Test', () => {
    let httpService: HttpService;
    const uri = '/test';

    beforeAll(() => {
      httpService = new HttpService("cloudchat.infinomat.com", false);
    });

    it('Http Service - GET request test', async () => {
      const callback: AsyncCallback<http.HttpResponse> = (err, res) => {
        if (err) {
          console.error(JSON.stringify(err));
        } else {
          console.info("Received: " + JSON.stringify(res));
          response = JSON.stringify(res);
        }
      };
      let response: string | null = null;
      httpService.get(uri, callback);
      setTimeout(() => {
        expect(response).not().assertNull();
      }, 5000)
    });

    it('Http Service - POST request test', async () => {
      const callback: AsyncCallback<http.HttpResponse> = (err, res) => {
        if (err) {
          console.error(JSON.stringify(err));
        } else {
          console.info("Received: " + JSON.stringify(res));
          response = JSON.stringify(res);
        }
      };
      let response: string | null = null;
      httpService.post(uri, callback);
      setTimeout(() => {
        expect(response).not().assertNull();
      }, 5000)
    });
  });
}

function websocketServiceTest(){
  interface WebsocketTestInfo{
    type: string
  }
  describe('Websocket Service Test', () => {
    let websocketService: WebsocketService;

    beforeAll(() => {
      websocketService = new WebsocketService("cloudchat.infinomat.com", "14514");
    });

    it('Websocket Service - request test', async () => {
      let receive: string | null = null;
      websocketService.addNewMessageObserver((get) => {
        receive = get;
      })
      setTimeout(() => {
        expect(receive).not().assertNull();
      }, 5000)
      const testInfo: WebsocketTestInfo = {
        type: "test"
      }
      websocketService.send(testInfo);
    });
  });
}