export interface Message {
  type: ClientMessageType;
  payload: ClientPayload;
}

export enum ClientMessageType {
  LOGIN = 'LOGIN',
  LOGIN_BY_TOKEN = 'LOGIN_BY_TOKEN',
  REGISTER = 'REGISTER',
  UPDATE_PROFILE = 'UPDATE_PROFILE',
  LOGOUT = 'LOGOUT',
  LOAD_CONTACTS = 'LOAD_CONTACTS',
  ADD_CONTACT = 'ADD_CONTACT',
  DELETE_CONTACT = 'DELETE_CONTACT',
  LOAD_MESSAGES = 'LOAD_MESSAGES',
  SEND_MESSAGE = 'SEND_MESSAGE',
  SEND_FILE = 'SEND_FILE',
  SEND_IMAGE = 'SEND_IMAGE',
  MARK_READ = 'MARK_READ',
  CLEAR_MESSAGES = 'CLEAR_MESSAGES',
}

type ClientPayload =
  | LoginPayload
  | LoginByTokenPayload
  | RegisterPayload
  | UpdateProfilePayload
  | LogoutPayload
  | LoadContactsPayload
  | AddContactPayload
  | DeleteContactPayload
  | LoadMessagesPayload
  | SendMessagePayload
  | SendFilePayload
  | SendImagePayload
  | MarkReadPayload
  | ClearMessagesPayload;

export interface LoginPayload {
  username: string;
  password: string;
}

export interface LoginByTokenPayload {
  token: string;
}


export interface RegisterPayload {
  username: string;
  password: string;
  email: string;
}

export interface LogoutPayload {
  userId: number;
}

export interface UpdateProfilePayload {
  userId: number;
  username: string;
  password: string;
  email: string;
  avatar: string;
}


export interface LoadContactsPayload {
  userId: number;
}

export interface AddContactPayload {
  userId: number;
  targetId: number;
}

export interface DeleteContactPayload {
  userId: number;
  targetUserId: number;
}

export interface SendMessagePayload {
  messageId: number;
  senderId: number;
  receiverId: number;
  content: string;
}

export interface SendFilePayload {
  messageId: number;
  senderId: number;
  receiverId: number;
  fileName: string;
  fileContent: String[];
}

export interface SendImagePayload {
  messageId: number;
  senderId: number;
  receiverId: number;
  imageName: string;
  imageContent: String[];
}

export interface LoadMessagesPayload {
  userId: number;
}

export interface MarkReadPayload {
  messageId: number;
}

export interface ClearMessagesPayload {
  requesterUserId: number;
  targetUserId: number;
}
