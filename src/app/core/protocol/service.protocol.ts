export interface Message {
  type: ServiceMessageType;
  payload: ServicePayload;
}

export enum ServiceMessageType {
  LOGIN_SUCCESS = 'LOGIN_SUCCESS',
  LOGIN_FAILURE = 'LOGIN_FAILURE',
  REGISTER_SUCCESS = 'REGISTER_SUCCESS',
  REGISTER_FAILURE = 'REGISTER_FAILURE',
  PROFILE_UPDATED_SUCCESS = 'PROFILE_UPDATED_SUCCESS',
  PROFILE_UPDATED_FAILED = 'PROFILE_UPDATED_FAILED',
  LOGOUT_SUCCESS = 'LOGOUT_SUCCESS',
  CONTACTS_LOADED = 'CONTACTS_LOADED',
  CONTACTS_LOADED_FAILED = 'CONTACTS_LOADED_FAILED',
  CONTACT_ADDED = 'CONTACT_ADDED',
  CONTACT_ADDED_FAILED = 'CONTACT_ADDED_FAILED',
  CONTACT_DELETED = 'CONTACT_DELETED',
  CONTACT_DELETED_FAILED = 'CONTACT_DELETED_FAILED',
  MESSAGES_LOADED = 'MESSAGES_LOADED',
  MESSAGE_RECEIVED_SELF = 'MESSAGE_RECEIVED_SELF',
  MESSAGE_RECEIVED_OTHER = 'MESSAGE_RECEIVED_OTHER',
  MESSAGES_CLEARED = 'MESSAGES_CLEARED'
}

export type ServicePayload =
  LoginSuccessPayload |
  LoginFailurePayload |
  RegisterSuccessPayload |
  RegisterFailurePayload |
  ProfileUpdatedSuccessPayload |
  ProfileUpdatedFailedPayload |
  LogoutSuccessPayload |
  ContactsLoadedPayload |
  ContactsLoadedFailedPayload |
  ContactAddedPayload |
  ContactAddedFailedPayload |
  ContactDeletedPayload |
  ContactDeletedFailedPayload |
  MessagesLoadedPayload |
  SelfMessageReceivedPayload |
  ToSelfMessageReceivedPayload |
  MessagesClearedPayload;

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

export interface LogoutSuccessPayload {}

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

export interface ProfileUpdatedSuccessPayload {
  userId: number;
  username: string;
  password: string;
  email: string;
  avatar: string;
}

export interface ProfileUpdatedFailedPayload {
  error: string;
}

export interface ContactsLoadedPayload {
  contacts: Array<{
    contactId: number;
    username: string;
    avatar: string;
    online: boolean;
  }>;
}

export interface ContactsLoadedFailedPayload {
  error: string;
}

export interface ContactAddedPayload {
  contactId: number;
  userName: string;
  online: boolean;
  avatar: string;
}

export interface ContactAddedFailedPayload {
  error: string;
}

export interface ContactDeletedPayload {
}

export interface ContactDeletedFailedPayload {
  error: string;
}


export interface SelfMessageReceivedPayload {
  messageId: number;
}

export interface ToSelfMessageReceivedPayload {
  id: number;
  senderId: number;
  receiverId: number;
  content: string | string[];
  timestamp: string;
  status: 'sending' | 'sent' | 'read';
  type: 'text' | 'image' | 'file';
}

export interface MessagesLoadedPayload {
  messages: Array<{
    id: number;
    senderId: number;
    receiverId: number;
    content: string | string[];
    timestamp: string;
    status: 'sending' | 'sent' | 'read';
    type: 'text' | 'image' | 'file';
  }>;
}

export interface MessagesClearedPayload {
  userId: number;
  targetUserId: number;
}
