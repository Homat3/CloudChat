export interface HttpServiceMessage {
  type: HttpServiceMessageType;
  payload: ServicePayload;
}

export enum HttpServiceMessageType {
  LOGIN_SUCCESS = 'LOGIN_SUCCESS',
  LOGIN_FAILURE = 'LOGIN_FAILURE',

  REGISTER_SUCCESS = 'REGISTER_SUCCESS',
  REGISTER_FAILURE = 'REGISTER_FAILURE',

  PROFILE_UPDATED_SUCCESS = 'PROFILE_UPDATED_SUCCESS',
  PROFILE_UPDATED_FAILED = 'PROFILE_UPDATED_FAILED',
  CONTACTS_LOADED = 'CONTACTS_LOADED',
  CONTACTS_LOADED_FAILED = 'CONTACTS_LOADED_FAILED',
  CONTACT_DELETED = "CONTACT_DELETED",
  CONTACT_DELETED_FAILED = "CONTACT_DELETED_FAILED",

  SEARCH_FOR_USER_RESULT = 'SEARCH_FOR_USER_RESULT',

  FRIEND_REQUEST_LOADED = 'FRIEND_REQUEST_LOADED',
  FRIEND_REQUEST_LOADED_FAILED = 'FRIEND_REQUEST_LOADED_FAILED',

  FRIEND_REQUEST_ADDED = 'FRIEND_REQUEST_ADDED',
  FRIEND_REQUEST_ADDED_FAILED = 'FRIEND_REQUEST_ADDED_FAILED',

  FRIEND_REQUEST_REFUSED = 'FRIEND_REQUEST_REFUSED',
  FRIEND_REQUEST_ACCEPTED = 'FRIEND_REQUEST_ACCEPTED',
  FRIEND_REQUEST_REFUSED_FAILED = 'FRIEND_REQUEST_REFUSED_FAILED',
  FRIEND_REQUEST_ACCEPTED_FAILED = 'FRIEND_REQUEST_ACCEPTED_FAILED',

  MESSAGES_LOADED = 'MESSAGES_LOADED',

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

  ContactsLoadedPayload |
  ContactsLoadedFailedPayload |
  ContactDeletedPayload |
  ContactDeletedFailedPayload |

  SearchForUserResultPayload |

  FriendRequestLoadedPayload |
  FriendRequestLoadedFailedPayload |

  FriendRequestAddedPayload |
  FriendRequestAddedFailedPayload |

  FriendRequestRefusedPayload |
  FriendRequestAcceptedPayload |
  FriendRequestRefusedFailedPayload |
  FriendRequestAcceptedFailedPayload |

  MessagesLoadedPayload |

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
  error: string;
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

export interface ContactDeletedPayload{
  targetId: number
}

export interface ContactDeletedFailedPayload{
  error: string
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

export interface MessagesLoadedPayload {
  targetId: number,
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

export interface FileUploadedPayload {
  filePath: string;
}

export interface FileUploadedFailedPayload {
  filePath: string;
  error: string;
}
