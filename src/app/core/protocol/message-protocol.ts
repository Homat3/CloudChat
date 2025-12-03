import {ChatContact} from '../models';

export enum MessageType {
  LOGIN = 'LOGIN',
  LOGIN_BY_TOKEN = 'LOGIN_BY_TOKEN',
  LOGIN_SUCCESS = 'LOGIN_SUCCESS',
  LOGIN_FAILURE = 'LOGIN_FAILURE',
  REGISTER = 'REGISTER',
  REGISTER_SUCCESS = 'REGISTER_SUCCESS',
  REGISTER_FAILURE = 'REGISTER_FAILURE',
  UPDATE_PROFILE = 'UPDATE_PROFILE',
  PROFILE_UPDATED = 'PROFILE_UPDATED',
  LOGOUT = 'LOGOUT',
  LOGOUT_SUCCESS = 'LOGOUT_SUCCESS',
  LOAD_CONTACTS = 'LOAD_CONTACTS',
  CONTACTS_LOADED = 'CONTACTS_LOADED',
  ADD_CONTACT = 'ADD_CONTACT',
  CONTACT_ADDED = 'CONTACT_ADDED',
  DELETE_CONTACT = 'DELETE_CONTACT',
  CONTACT_DELETED = 'CONTACT_DELETED',
  LOAD_MESSAGES = 'LOAD_MESSAGES',
  MESSAGES_LOADED = 'MESSAGES_LOADED',
  SEND_MESSAGE = 'SEND_MESSAGE',
  SEND_FILE = 'SEND_FILE',
  SEND_IMAGE = 'SEND_IMAGE',
  MARK_READ = 'MARK_READ',
  MESSAGE_RECEIVED = 'MESSAGE_RECEIVED',
  MESSAGE_RECEIVED_ACK = 'MESSAGE_RECEIVED_ACK',
  CLEAR_MESSAGES = 'CLEAR_MESSAGES',
  MESSAGES_CLEARED = 'MESSAGES_CLEARED'
}

//  Message
export interface ProtocolMessage {
  type: MessageType;
  payload: any;
}

// Pay loads
export interface LoginPayload {
  username: string;
  password: string;
}

export interface LoginByTokenPayload {
  token: string;
}

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

export interface RegisterPayload {
  username: string;
  password: string;
  email: string;
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

export interface UpdateProfilePayload {
  userId: number;
  username: string;
  password: string;
  email: string;
  avatar: string;
}

export interface ProfileUpdatedPayload {
  userId: number;
  username: string;
  password: string;
  email: string;
  avatar: string;
}

export interface LogoutPayload {
  userId: number;
}

export interface LoadContactsPayload {
  userId: number;
}

export interface ContactsLoadedPayload {
  contacts: Array<{
    contactId: number;
    username: string;
    avatar: string;
    online: boolean;
  }>;
}

export interface AddContactPayload {
  userId: number;
  targetId: number;
}

export interface ContactAddedPayload {
  contact: ChatContact;
}

export interface DeleteContactPayload {
  requesterUserId: number;
  targetUserId: number;
}

export interface ContactDeletedPayload {
  success: boolean;
}

export interface LoadMessagesPayload {
  requesterUserId: number;
}

export interface SendMessagePayload {
  requesterUserId: number;
  senderId: number;
  receiverId: number;
  content: string;
}

export interface SendFilePayload {
  requesterUserId: number;
  fileName: string;
  fileContent: Uint8Array;
}

export interface SendImagePayload {
  requesterUserId: number;
  imageName: string;
  imageContent: Uint8Array;
}

export interface MarkReadPayload {
  requesterUserId: number;
}

export interface ClearMessagesPayload {
  requesterUserId: number;
  targetUserId: number;
}

export interface MessagesLoadedPayload {}

export interface LogoutSuccessPayload {}

export interface MessageReceivedPayload {}

export interface MessagesClearedPayload {
  targetUserId: number;
}

export interface ProtocolMessage {
    type: MessageType;

    /**
      {@link LoginPayload} - LOGIN

      {@link LoginSuccessPayload} - LOGIN_SUCCESS

      {@link LoginFailurePayload} - LOGIN_FAILURE

      {@link RegisterPayload} - REGISTER

      {@link RegisterSuccessPayload} - REGISTER_SUCCESS

      {@link RegisterFailurePayload} - REGISTER_FAILURE

      {@link LogoutPayload} - LOGOUT

      {@link LogoutSuccessPayload} - LOGOUT_SUCCESS

      {@link UpdateProfilePayload} - UPDATE_PROFILE

      {@link ProfileUpdatedPayload} - PROFILE_UPDATED

      {@link ClearMessagesPayload} - CLEAR_MESSAGES

      {@link MessagesClearedPayload} - MESSAGES_CLEARED
     */
    payload: any;
}
