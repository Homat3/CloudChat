export interface WebSocketClientMessage {
  type: WebsocketClientMessageType;
  payload: ClientPayload;
}

export enum WebsocketClientMessageType {
  LOGIN = 'LOGIN',
  LOGIN_BY_TOKEN = 'LOGIN_BY_TOKEN',
  REGISTER = 'REGISTER',
  SEND_MESSAGE = 'SEND_MESSAGE',
  MARK_READ = 'MARK_READ'
}

type ClientPayload =
  | LoginPayload
  | LoginByTokenPayload
  | RegisterPayload
  | SendMessagePayload
  | MarkReadPayload;

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

export interface SendMessagePayload {
  tempId: string;
  senderId: number;
  receiverId: number;
  content: string;
}

export interface MarkReadPayload {
  userId: number;
  targetId: number;
}