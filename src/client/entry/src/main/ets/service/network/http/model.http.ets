import { http } from '@kit.NetworkKit'



export function createDefaultRequestOptions(): http.HttpRequestOptions{
  return new RequestOptionsBuilder().build();
}

export class RequestOptionsBuilder{
  private requestOptions: http.HttpRequestOptions = {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json'
    },
    readTimeout: 10000,
    connectTimeout: 10000 // 10s
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

  public contentType(type: string): RequestOptionsBuilder{
    this.requestOptions.header = {
      'Content-Type': type
    }
    return this;
  }

  public readTimeOut(timeOut: number): RequestOptionsBuilder{
    this.requestOptions.readTimeout = timeOut
    return this;
  }

  public connectTimeOut(timeOut: number): RequestOptionsBuilder{
    this.requestOptions.connectTimeout = timeOut
    return this;
  }

  public build(): http.HttpRequestOptions{
    return this.requestOptions;
  }
}