import { http } from '@kit.NetworkKit'
import { AsyncCallback } from '@kit.BasicServicesKit';

export class HttpService {
  private constructor() {
  }
  private static instance: HttpService;
  private httpBase = http.createHttp();

  static getInstance(): HttpService {
    if (!HttpService.instance) {
      HttpService.instance = new HttpService();
    }
    return HttpService.instance;
  }

  async request(url: string, requestOptions: http.HttpRequestOptions, callback: AsyncCallback<http.HttpResponse>) {
    try {
      this.httpBase.request(url, requestOptions, callback);
    } catch (error) {
      throw new Error(`Network Error: ${error.code}`);
    }
  }
}