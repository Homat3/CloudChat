import { http } from '@kit.NetworkKit'
import { AsyncCallback } from '@kit.BasicServicesKit';
import { DeleteServiceError, GetServiceError, PostServiceError, PutServiceError } from './error.http';
import { RequestOptionsBuilder } from './config.http';

export class HttpService {
  private httpBase = http.createHttp();
  private baseUrl: string;
  private port: string | null = null
  private SSL_Available: boolean;

  /**
   * @param baseUrl 目标域名/ip
   * @example const exampleService = new HttpService('example.com');
   */
  public constructor(baseUrl: string, port: string | null = null, SSL_Available: boolean = true) {
    this.baseUrl = baseUrl;
    this.port = port;
    this.SSL_Available = SSL_Available;
  }

  async request(uri: string, requestOptions: http.HttpRequestOptions, callback: AsyncCallback<http.HttpResponse>) {
    try {
      const prefix = this.SSL_Available ? "https://" : "http://";
      const endfix = this.port ? ":" + this.port : "";
      this.httpBase.request(prefix + this.baseUrl + endfix + uri, requestOptions, callback);
    } catch (error) {
      throw new Error(`Error code: ${error.code}`);
    }
  }

  async post(uri: string, body: object, callback: AsyncCallback<http.HttpResponse>){
    const requestOptions = new RequestOptionsBuilder().method('POST').body(body).build();
    try {
      this.request(uri, requestOptions, callback);
    } catch (error){
      throw new PostServiceError(error);
    }
  }

  async get(uri: string, body: object, callback: AsyncCallback<http.HttpResponse>){
    const requestOptions = new RequestOptionsBuilder().method('GET').body(body).build();
    try {
      this.request(uri, requestOptions, callback);
    } catch (error){
      throw new GetServiceError(error);
    }
  }

  async put(uri: string, body: object, callback: AsyncCallback<http.HttpResponse>){
    const requestOptions = new RequestOptionsBuilder().method('PUT').body(body).build();
    try {
      this.request(uri, requestOptions, callback);
    } catch (error){
      throw new PutServiceError(error);
    }
  }

  async delete(uri: string, body: object, callback: AsyncCallback<http.HttpResponse>){
    const requestOptions = new RequestOptionsBuilder().method('DELETE').body(body).build();
    try {
      this.request(uri, requestOptions, callback);
    } catch (error){
      throw new DeleteServiceError(error);
    }
  }
}