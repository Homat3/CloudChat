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
  SEARCH_FOR_USER_BY_ID = 'SEARCH_FOR_USER_BY_ID',
  SEARCH_FOR_USER_BY_NAME = 'SEARCH_FOR_USER_BY_NAME',
  LOAD_FRIEND_REQUEST = 'LOAD_FRIEND_REQUEST',
  ADD_FRIEND_REQUEST = 'ADD_FRIEND_REQUEST',
  REFUSE_FRIEND_REQUEST = 'REFUSE_FRIEND_REQUEST',
  ACCEPT_FRIEND_REQUEST = 'ACCEPT_FRIEND_REQUEST',
  LOAD_MESSAGES = 'LOAD_MESSAGES',
  SEND_MESSAGE = 'SEND_MESSAGE',
  MARK_READ = 'MARK_READ',
  UPLOAD_FILE = 'UPLOAD_FILE'
}

type ClientPayload =
  | LoginPayload
  | LoginByTokenPayload
  | RegisterPayload
  | UpdateProfilePayload
  | LogoutPayload
  | LoadContactsPayload
  | SearchForUserByIdPayload
  | SearchForUserByUserNamePayload
  | LoadFriendRequestPayload
  | AddFriendRequestPayload
  | RefuseFriendRequestPayload
  | AcceptFriendRequestPayload
  | LoadMessagesPayload
  | SendMessagePayload
  | MarkReadPayload
  | UploadFilePayload;

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

export interface SearchForUserByIdPayload {
  userId: number;
}

export interface SearchForUserByUserNamePayload {
  username: string;
}

export interface LoadFriendRequestPayload {
  userId: number;
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

export interface AcceptFriendRequestPayload {
  id: number;
}

export interface SendMessagePayload {
  tempId: string;
  senderId: number;
  receiverId: number;
  content: string;
}

export interface LoadMessagesPayload {
  userId: number;
  targetId: number;
}

export interface MarkReadPayload {
  userId: number;
  targetId: number;
}

export interface UploadFilePayload {
  filePath: string;
  dataStream: String;
}
