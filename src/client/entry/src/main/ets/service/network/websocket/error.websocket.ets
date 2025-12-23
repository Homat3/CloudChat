import { NetworkServiceError } from "../error/NetWorkServiceError";

export class WebsocketServiceError extends NetworkServiceError{
  constructor(message: string) {
    super("Websocket Service Error: " + message);
  }
}

export class ConnectFailedError extends WebsocketServiceError{
  constructor(message: string, errorCode: number) {
    super("Connect Error" + '(' + errorCode + '): ' + message );
  }
}

export class ServiceOpenError extends WebsocketServiceError{
  constructor(message: string) {
    super("Websocket Open Error: " + message);
  }
}

export class ServiceReceiveError extends WebsocketServiceError{
  constructor(message: string) {
    super("Websocket Receive Error: " + message);
  }
}

export class ServiceCloseError extends WebsocketServiceError{
  constructor(message: string) {
    super("Websocket Close Error: " + message);
  }
}

export class SendError extends WebsocketServiceError{
  constructor(message: string) {
    super("Send Error: " + message);
  }
}