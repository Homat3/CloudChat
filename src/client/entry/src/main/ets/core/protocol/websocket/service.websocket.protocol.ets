export interface WebsocketServiceMessage {
  type: WebsocketServiceMessageType;
  payload: ServicePayload;
}


export enum WebsocketServiceMessageType {
  LOGIN_SUCCESS = 'LOGIN_SUCCESS',
  LOGIN_FAILURE = 'LOGIN_FAILURE',
  HDL_GOT = 'HDL_GOT',
  REGISTER_SUCCESS = 'REGISTER_SUCCESS',
  REGISTER_FAILURE = 'REGISTER_FAILURE',
  MESSAGE_RECEIVED_SELF = 'MESSAGE_RECEIVED_SELF',
  MESSAGE_SEND_FAILED = 'MESSAGE_SEND_FAILED',
  MESSAGE_RECEIVED_OTHER = 'MESSAGE_RECEIVED_OTHER',
  ADD_FRIEND_REQUEST = 'ADD_FRIEND_REQUEST',
  REFUSE_FRIEND_REQUEST = 'REFUSE_FRIEND_REQUEST',
  ACCEPT_FRIEND_REQUEST = 'ACCEPT_FRIEND_REQUEST',
  CONTACT_ADDED = "CONTACT_ADDED",
  DELETED_BY_CONTACT = "DELETED_BY_CONTACT"
}

export type ServicePayload =
  LoginSuccessPayload |
  LoginFailurePayload |
  HdlGotPayload |
  RegisterSuccessPayload |
  RegisterFailurePayload |
  MessageReceivedSelfPayload |
  MessageSendFailedPayload |
  MessageReceivedOtherPayload |
  AddFriendRequestPayload |
  RefuseFriendRequestPayload |
  DeleteByContactPayload |
  ContactAddedPayload |
  AcceptFriendRequestPayload;

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

export interface HdlGotPayload{
  userId: number
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

export interface AddFriendRequestPayload {
  id: number;
  requesterId: number;
  targetId: number;
  requesterUsername: string;
  targetUsername: string;
  requesterAvatar: string;
  targetAvatar: string;
  status: 'pending' | 'accepted' | 'refused';
}

export interface RefuseFriendRequestPayload {
  id: number;
}

export interface DeleteByContactPayload{
  contactId: number;
}

export interface ContactAddedPayload {
  contactId: number,
  username: string,
  online: boolean,
  avatar: string
}

export interface AcceptFriendRequestPayload {
  id: number;
}
