export interface WebSocketClientMessage {
  type: WebsocketClientMessageType;
  payload: ClientPayload;
}

export enum WebsocketClientMessageType {
  HDL_INFO = 'HDL_INFO',
  REGISTER = 'REGISTER',
  SEND_MESSAGE = 'SEND_MESSAGE',
  MARK_READ = 'MARK_READ'
}

type ClientPayload =
  | HdlInfoPayload
  | RegisterPayload
  | SendMessagePayload
  | MarkReadPayload;

export interface HdlInfoPayload {
  userId: number;
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