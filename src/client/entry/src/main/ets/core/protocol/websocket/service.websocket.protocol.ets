export interface WebsocketServiceMessage {
  type: WebsocketServiceMessageType;
  payload: ServicePayload;
}

export enum WebsocketServiceMessageType {
  LOGIN_SUCCESS = 'LOGIN_SUCCESS',
  LOGIN_FAILURE = 'LOGIN_FAILURE',
  REGISTER_SUCCESS = 'REGISTER_SUCCESS',
  REGISTER_FAILURE = 'REGISTER_FAILURE'
}

export type ServicePayload =
  LoginSuccessPayload |
  LoginFailurePayload |
  RegisterSuccessPayload |
  RegisterFailurePayload;

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