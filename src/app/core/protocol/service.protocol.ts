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
  CONTACT_ADDED = 'CONTACT_ADDED',
  CONTACTS_LOADED = 'CONTACTS_LOADED',
  CONTACTS_LOADED_FAILED = 'CONTACTS_LOADED_FAILED',
  SEARCH_FOR_USER_RESULT = 'SEARCH_FOR_USER_RESULT',
  FRIEND_REQUEST_LOADED = 'FRIEND_REQUEST_LOADED',
  FRIEND_REQUEST_LOADED_FAILED = 'FRIEND_REQUEST_LOADED_FAILED',
  FRIEND_REQUEST_ADDED = 'FRIEND_REQUEST_ADDED',
  FRIEND_REQUEST_ADDED_FAILED = 'FRIEND_REQUEST_ADDED_FAILED',
  ADD_FRIEND_REQUEST = 'ADD_FRIEND_REQUEST',
  FRIEND_REQUEST_REFUSED = 'FRIEND_REQUEST_REFUSED',
  FRIEND_REQUEST_ACCEPTED = 'FRIEND_REQUEST_ACCEPTED',
  FRIEND_REQUEST_REFUSED_FAILED = 'FRIEND_REQUEST_REFUSED_FAILED',
  FRIEND_REQUEST_ACCEPTED_FAILED = 'FRIEND_REQUEST_ACCEPTED_FAILED',
  REFUSE_FRIEND_REQUEST = 'REFUSE_FRIEND_REQUEST',
  ACCEPT_FRIEND_REQUEST = 'ACCEPT_FRIEND_REQUEST',
  MESSAGES_LOADED = 'MESSAGES_LOADED',
  MESSAGE_RECEIVED_SELF = 'MESSAGE_RECEIVED_SELF',
  MESSAGE_RECEIVED_OTHER = 'MESSAGE_RECEIVED_OTHER',
  MESSAGES_CLEARED = 'MESSAGES_CLEARED',
  FILE_UPLOADED = 'FILE_UPLOADED',
  FILE_UPLOADED_FAILED = 'FILE_UPLOADED_FAILED'
}

export type ServicePayload =
  LoginSuccessPayload |
  LoginFailurePayload |
  RegisterSuccessPayload |
  RegisterFailurePayload |
  ProfileUpdatedSuccessPayload |
  ProfileUpdatedFailedPayload |
  ContactAddedPayload |
  ContactsLoadedPayload |
  ContactsLoadedFailedPayload |
  FriendRequestLoadedPayload |
  FriendRequestLoadedFailedPayload |
  FriendRequestAddedPayload |
  FriendRequestAddedFailedPayload |
  AddFriendRequestPayload |
  FriendRequestRefusedPayload |
  FriendRequestAcceptedPayload |
  FriendRequestRefusedFailedPayload |
  FriendRequestAcceptedFailedPayload |
  RefuseFriendRequestPayload |
  AcceptFriendRequestPayload |
  SearchForUserResultPayload |
  MessagesLoadedPayload |
  SelfMessageReceivedPayload |
  ToSelfMessageReceivedPayload |
  MessagesClearedPayload|
  FileUploadedPayload|
  FileUploadedFailedPayload;

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

export interface ContactAddedPayload {
  userId: number;
  username: string;
  online: boolean;
  avatar: string;
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

export interface SearchForUserResultPayload {
  users: Array<{
    contactId: number;
    username: string;
    online: boolean;
    avatar: string;
  }>;
}

export interface FriendRequestLoadedPayload {
  requests: Array<{
    id: number;
    requesterId: number;
    targetId: number;
    requesterUsername: string;
    targetUsername: string;
    requesterAvatar: string;
    targetAvatar: string;
    status: 'pending' | 'accepted' | 'refused';
  }>;
}

export interface FriendRequestLoadedFailedPayload {
  error: string;
}

export interface FriendRequestAddedPayload {
  id: number;
  requesterId: number;
  targetId: number;
  requesterUsername: string;
  targetUsername: string;
  requesterAvatar: string;
  targetAvatar: string;
  status: 'pending' | 'accepted' | 'refused';
}

export interface FriendRequestAddedFailedPayload {
  error: string;
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

export interface FriendRequestRefusedPayload {
  id: number;
}

export interface FriendRequestAcceptedPayload {
  id: number;
}

export interface FriendRequestRefusedFailedPayload {
  error: string;
}

export interface FriendRequestAcceptedFailedPayload {
  error: string;
}

export interface RefuseFriendRequestPayload {
  id: number;
}

export interface AcceptFriendRequestPayload {
  id: number;
}

export interface SelfMessageReceivedPayload {
  messageId: number;
}

export interface ToSelfMessageReceivedPayload {
  id: number;
  senderId: number;
  receiverId: number;
  content: string;
  timestamp: string;
  status: 'sending' | 'sent' | 'read';
  type: 'text' | 'image' | 'file';
}

export interface MessagesLoadedPayload {
  messages: Array<{
    id: number;
    senderId: number;
    receiverId: number;
    content: string;
    timestamp: string;
    status: 'sending' | 'sent' | 'read';
    type: 'text' | 'image' | 'file';
  }>;
}

export interface MessagesClearedPayload {
  userId: number;
  targetUserId: number;
}

export interface FileUploadedPayload {
  filePath: string;
}

export interface FileUploadedFailedPayload {
  filePath: string;
  error: string;
}
