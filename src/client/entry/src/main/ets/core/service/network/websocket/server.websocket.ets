import { webSocket } from '@kit.NetworkKit';
import {
  ConnectFailedError,
  SendError,
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
  private newMessageObservers: Array<(newMessage: string) => void> = [];

  private retryCount = 0;
  private maxRetryCount = 5;

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

  public constructor(serverUrl: string, port: string | null) {
    this.port = port;
    this.serverUrl = serverUrl;
  }

  public connect() {
    let errorOccurs = this.retryCount > this.maxRetryCount;
    this.retryCount++;
    // 定义WebSocket连接的URL前缀
    const prefix = 'ws://';
    // 根据端口是否存在，决定是否添加端口号
    const endfix = this.port ? ":" + this.port : "";
    // 拼接完整的WebSocket连接地址
    let n = prefix + this.serverUrl + endfix;
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
        if (errorOccurs) throw new ConnectFailedError(err.message, err.code);
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

  public send(message: object) {
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
