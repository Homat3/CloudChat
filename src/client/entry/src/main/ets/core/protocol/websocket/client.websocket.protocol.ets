export interface WebSocketClientMessage {
  type: WebsocketClientMessageType;
  payload: ClientPayload;
}

export enum WebsocketClientMessageType {
  LOGIN = 'LOGIN',
  LOGIN_BY_TOKEN = 'LOGIN_BY_TOKEN',
  REGISTER = 'REGISTER',
}

type ClientPayload =
  | LoginPayload
  | LoginByTokenPayload
  | RegisterPayload;

export interface LoginPayload {
  username: string;
  password: string;
}

export interface LoginByTokenPayload {
  username: string;
  token: string;
}

export interface RegisterPayload {
  username: string;
  password: string;
  email: string;
}