import { webSocket } from '@kit.NetworkKit';
import {
  ConnectFailedError,
  ServiceCloseError,
  ServiceOpenError,
  ServiceReceiveError,
  WebsocketServiceError
} from './error.websocket';

export class WebsocketService {
  private websocketBase = webSocket.createWebSocket();
  private serverUrl: string;
  private port: string | null;
  private _newMessage: string = "";
  private messageObservers: Array<(newMessage: string) => void> = [];
  private retryCount = 0;
  private maxRetryCount = 5;

  private get newMessage() {
    return this._newMessage;
  }

  private set newMessage(value: string) {
    if (!(this._newMessage === value)) {
      this._newMessage = value;
      this.OnNewMessage(value);
    }
  }

  public connect() {
    let errorOccurs = this.retryCount > this.maxRetryCount;
    this.retryCount++;
    // 定义WebSocket连接的URL前缀
    const prefix = 'ws://';
    // 根据端口是否存在，决定是否添加端口号
    const endfix = this.port ? ":" + this.port : "";
    // 调用WebSocket连接方法，进行实际连接
    this.websocketBase.connect(prefix + this.serverUrl + endfix, (err: BusinessError) => {
      if (!err) {
        // 连接成功，输出日志并订阅消息
        console.info("Connected successfully");
        this.subscribe();
      } else {
        // 连接失败，抛出连接失败错误
        console.error(`连接失败，3秒后重试 Code:${err.code}`);
        setTimeout((): void => this.connect(), 3000);
        if (errorOccurs) {
          throw new ConnectFailedError(err.message, err.code);
        }
      }
    });
  }

  public disconnect() {
    this.websocketBase.close({
      code: 100,
      reason: "App exit"
    }).catch((error: Error) => {
      console.error(error.message)
    })
  }

  public constructor(serverUrl: string, port: string | null) {
    this.port = port;
    this.serverUrl = serverUrl;
  }

  public addMessageObserver(observer: (newMessage: string) => void): void {
    this.messageObservers.push(observer);
  }

  private OnNewMessage(newValue: string) {
    this.messageObservers.forEach(it => it(newValue));
  }

  private subscribe() { // 连接成功事件
    this.websocketBase.on('open', (err: BusinessError, value: Object) => {
      if (err != undefined) {
        const msg = JSON.stringify(err);
        console.error(msg);
        throw new ServiceOpenError(msg);
      }
    });

    // 接收消息事件
    this.websocketBase.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
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

  public send(message: object) {
    this.websocketBase.send(JSON.stringify(message), (err: BusinessError, value: boolean) => {
      if (!err) {
        console.log("send success");
      } else {
        const msg = JSON.stringify(err);
        console.error(msg);
        setTimeout((): void => this.send(message), 2000);
      }
    });
  }
}
