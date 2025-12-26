export interface WebsocketServiceMessage {
  type: WebsocketServiceMessageType;
  payload: ServicePayload;
}

export enum WebsocketServiceMessageType {
  LOGIN_SUCCESS = 'LOGIN_SUCCESS',
  LOGIN_FAILURE = 'LOGIN_FAILURE',
  REGISTER_SUCCESS = 'REGISTER_SUCCESS',
  REGISTER_FAILURE = 'REGISTER_FAILURE',
  MESSAGE_RECEIVED_SELF = 'MESSAGE_RECEIVED_SELF',
  MESSAGE_SEND_FAILED = 'MESSAGE_SEND_FAILED',
  MESSAGE_RECEIVED_OTHER = 'MESSAGE_RECEIVED_OTHER',
}

export type ServicePayload =
  LoginSuccessPayload |
  LoginFailurePayload |
  RegisterSuccessPayload |
  RegisterFailurePayload |
  MessageReceivedSelfPayload |
  MessageSendFailedPayload |
  MessageReceivedOtherPayload;

export interface LoginSuccessPayload {
  userId: number;
  username: string;
  email: string;
  avatar: string;
  token: string;
}

export interface LoginFailurePayload {
  error: string;
}

export interface RegisterSuccessPayload {
  userId: number;
  username: string;
  email: string;
  avatar: string;
  token: string;
}

export interface RegisterFailurePayload {
  error: string;
}

export interface MessageReceivedSelfPayload {
  tempId: string;
  id: number;
  timestamp: string;
}

export interface MessageSendFailedPayload {
  tempId: string;
  error: string;
}

export interface MessageReceivedOtherPayload {
  id: number;
  senderId: number;
  receiverId: number;
  content: string;
  timestamp: string;
  status: 'sending' | 'sent' | 'read';
  type: 'text' | 'image' | 'file';
}
