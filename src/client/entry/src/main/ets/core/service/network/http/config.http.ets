import { http } from '@kit.NetworkKit'; // 导入ArkTS的网络模块

export function createDefaultRequestOptions(): http.HttpRequestOptions{
  return new RequestOptionsBuilder().build();
}

interface HttpHeaderInterface {
  'Content-Type': string;
}
interface HttpConfigInterface {
  header: HttpHeaderInterface,
  expectDataType: http.HttpDataType,
  readTimeout: number,
  connectTimeout: number // 5s
}

export class HttpConfig implements HttpConfigInterface{
  //单例模式
  private static instance = new HttpConfig();
  public static getInstance(): HttpConfig{
    return HttpConfig.instance;
  }
  private constructor() {
    this.header = { //默认请求头
      'Content-Type': 'application/json'
    };
    this.readTimeout = 5000;  //管理连接超时
    this.connectTimeout = 5000; //管理读取超时
  }


  public header: HttpHeaderInterface;
  public expectDataType: http.HttpDataType = http.HttpDataType.OBJECT;

  private _readTimeout: number = 5000
  public get readTimeout(){
    return this._readTimeout;
  }
  public set readTimeout(value: number){
    if (value > 10000) {
      this._readTimeout = 10000;
      console.warn("Http Config: Property readTimeout is too great, at most 10000ms")
    }
    else if (value < 1000) {
      this._readTimeout = 1000;
      console.warn("Http Config: Property readTimeout is too small, at least 1000ms")
    } else {
      this._readTimeout = value;
    }
  }

  private _connectTimeout: number = 5000; // 5s
  public get connectTimeout() {
    return this._connectTimeout;
  }
  public set connectTimeout(value: number) {
    if (value > 10000) {
      this._connectTimeout = 10000;
      console.warn("Http Config: Property connectTimeout is too great, at most 10000ms")
    } else if (value < 1000) {
      this._connectTimeout = 1000;
      console.warn("Http Config: Property connectTimeout is too small, at least 1000ms")
    } else {
      this._connectTimeout = value;
    }
  }
};

export class RequestOptionsBuilder{ //建造者模式
  private config: HttpConfigInterface = HttpConfig.getInstance();
  private requestOptions: http.HttpRequestOptions = { //配置HTTP方法
    method: http.RequestMethod.GET,
    header: this.config.header,
    extraData: "",
    expectDataType: this.config.expectDataType,
    readTimeout: this.config.readTimeout,
    connectTimeout: this.config.connectTimeout
  };

  public method(method: string): RequestOptionsBuilder{
    switch (method) {
        case 'GET':
          this.requestOptions.method = http.RequestMethod.GET;
          break;
        case 'POST':
          this.requestOptions.method = http.RequestMethod.POST;
          break;
        case 'PUT':
          this.requestOptions.method = http.RequestMethod.PUT;
          break;
        case 'DELETE':
          this.requestOptions.method = http.RequestMethod.DELETE;
          break;
        default:
          console.error("Not Implement")
          break;
    }
    return this;
  }

  public body(body: object): RequestOptionsBuilder {
    this.requestOptions.extraData = JSON.stringify(body);
    return this;
  }

  public build(): http.HttpRequestOptions{
    //使用默认配置
    return this.requestOptions;
  }
}