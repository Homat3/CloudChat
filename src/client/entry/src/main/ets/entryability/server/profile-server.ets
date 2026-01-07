import { CloudChat } from "../../CloudChat";
import { HttpClientMessage,
  HttpClientMessageType,
  UpdateProfilePayload } from "../../core/protocol/http/client.http.protocol";
import { http } from "@kit.NetworkKit";
import { EventBus } from "../../core/service/event/EventBus";
import { HttpServiceMessage, HttpServiceMessageType,
  ProfileUpdatedFailedPayload,
  ProfileUpdatedSuccessPayload} from "../../core/protocol/http/service.http.protocol";
import { Event } from "../../core/tag/Event";

export function handleUpdateProfile(data: UpdateProfilePayload) {
  const httpService = CloudChat.httpServer;
  const loginRequest: HttpClientMessage = {
    type: HttpClientMessageType.UPDATE_PROFILE,
    payload: data
  };

  console.log('Send Request:', loginRequest);
  //发送http请求
  httpService.post('/profile/update', loginRequest, (err: BusinessError, res: http.HttpResponse) => {
    if (err) {
      EventBus.emit(Event.PROFILE_UPDATE_FAILED, err.message);
      return;
    }
    //解析数据
    try {
      const resultData = res.result as HttpServiceMessage;
      console.log('Response:', resultData);

      if (res.responseCode === 200) {
        switch (resultData.type) {
          case HttpServiceMessageType.PROFILE_UPDATED_SUCCESS:
            const successData = resultData.payload as ProfileUpdatedSuccessPayload;
            EventBus.emit(Event.PROFILE_UPDATED, successData);
            break;
          case HttpServiceMessageType.PROFILE_UPDATED_FAILED:
            EventBus.emit(Event.PROFILE_UPDATE_FAILED, (resultData.payload as ProfileUpdatedFailedPayload).error);
            break;
          default:
            throw new Error("Unknown error");
        }
      } else {
        EventBus.emit(Event.PROFILE_UPDATE_FAILED, "Http error code: " + res.responseCode);
      }
    } catch (e) {
      EventBus.emit(Event.PROFILE_UPDATE_FAILED, e);
    }
  });
}
