import { webSocket } from '@kit.NetworkKit'
import { ConnectFailedError, ServiceCloseError, ServiceOpenError, ServiceReceiveError,
  WebsocketServiceError, SendError } from './error.websocket';

export class WebsocketService {
  private websocketBase = webSocket.createWebSocket();
  private serverUrl: string;
  private _newMessage: string = "";
  private newMessageObservers: Array<(newMessage: string) => void> = [];

  set newMessage(value: string){
    if (!(this._newMessage === value)){
      this._newMessage = value;
      this.OnNewMessage(value);
    }
  }
  get newMessage(){
    return this._newMessage;
  }
  public addNewMessageObserver(observer: (newMessage: string) => void): void {
    this.newMessageObservers.push(observer);
  }
  private OnNewMessage(newValue: string){
    this.newMessageObservers.forEach(it => it(newValue));
  }

  public constructor(serverUrl: string, port: string) {
    this.serverUrl = serverUrl + ':' + port;

    this.websocketBase.connect('ws://' + this.serverUrl, (err: BusinessError) => {
      if (!err) {
        console.info("Connected successfully");
        this.subscribe();
      }
      else {
        throw new ConnectFailedError(err.message, err.code);
      }
    });
  }

  private subscribe(){// 连接成功事件
    this.websocketBase.on('open', (err: BusinessError, value: Object) => {
      if (err != undefined) {
        const msg = JSON.stringify(err);
        console.error(msg);
        throw new ServiceOpenError(msg);
      }
    });

    // 接收消息事件
    this.websocketBase.on('message',(err: BusinessError, value: string | ArrayBuffer) => {
      if (err != undefined) {
        const msg = JSON.stringify(err);
        console.error(msg);
        throw new ServiceReceiveError(msg)
      }
      console.log("Message:" + value);
      this.newMessage = value as string;
    });

    // 连接关闭事件
    this.websocketBase.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
      if (err != undefined) {
        const msg = JSON.stringify(err);
        console.error(msg);
        throw new ServiceCloseError(msg)
      }
      console.log("Websocket closed, code is " + value.code + ", reason is " + value.reason);
    });

    // 错误事件
    this.websocketBase.on('error', (err: BusinessError) => {
      const msg = JSON.stringify(err);
      console.error(msg);
      throw new WebsocketServiceError(msg);
    });
  }

  public send(message: object){
    this.websocketBase.send(JSON.stringify(message), (err: BusinessError, value: boolean) => {
      if (!err) {
        console.log("send success");
      } else {
        const msg = JSON.stringify(err);
        console.error(msg);
        throw new SendError(msg);
      }
    });
  }
}
