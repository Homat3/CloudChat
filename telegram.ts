import {
  AddContactPayload, ClearMessagesPayload,
  ContactAddedPayload, ContactDeletedPayload, ContactsLoadedPayload, DeleteContactPayload,
  LoadContactsPayload, LoadMessagesPayload, LoginByTokenPayload,
  LoginFailurePayload,
  LoginPayload,
  LoginSuccessPayload, LogoutPayload, MarkReadPayload, MessageReceivedPayload,
  MessagesClearedPayload, MessagesLoadedPayload,
  MessageType,
  ProfileUpdatedPayload, RegisterFailurePayload, RegisterPayload, RegisterSuccessPayload,
  SendFilePayload, SendImagePayload, SendMessagePayload, UpdateProfilePayload
} from './src/app/core/protocol/message-protocol';

type Protocol =
  // 登录模块
  //  客户端->服务端
  //    账密登录
  | { type: MessageType.LOGIN; payload: LoginPayload }
  //    令牌登录
  | { type: MessageType.LOGIN_BY_TOKEN; payload: LoginByTokenPayload }
  //    登出
  | { type: MessageType.LOGOUT; payload: LogoutPayload }
  //  服务端->客户端
  //    登录成功
  | { type: MessageType.LOGIN_SUCCESS; payload: LoginSuccessPayload }
  //    登录失败
  | { type: MessageType.LOGIN_FAILURE; payload: LoginFailurePayload }
  //    登出成功
  | { type: MessageType.LOGOUT_SUCCESS; payload: LogoutPayload }
  // 注册模块
  //  客户端->服务端
  //    注册
  | { type: MessageType.REGISTER; payload: RegisterPayload }
  //  服务端->客户端
  //    注册成功
  | { type: MessageType.REGISTER_SUCCESS; payload: RegisterSuccessPayload }
  //    注册失败
  | { type: MessageType.REGISTER_FAILURE; payload: RegisterFailurePayload }
  // 个人资料模块
  //  客户端->服务端
  //    更新个人资料
  | { type: MessageType.UPDATE_PROFILE; payload: UpdateProfilePayload }
  //  服务端->客户端
  //    个人资料更新成功
  | { type: MessageType.PROFILE_UPDATED; payload: ProfileUpdatedPayload }
   // 联系人模块
  | { type: MessageType.LOAD_CONTACTS; payload: LoadContactsPayload }
  | { type: MessageType.CONTACTS_LOADED; payload: ContactsLoadedPayload }
  | { type: MessageType.ADD_CONTACT; payload: AddContactPayload }
  | { type: MessageType.CONTACT_ADDED; payload: ContactAddedPayload }
  | { type: MessageType.DELETE_CONTACT; payload: DeleteContactPayload }
  | { type: MessageType.CONTACT_DELETED; payload: ContactDeletedPayload }
  // 消息模块
  | { type: MessageType.LOAD_MESSAGES; payload: LoadMessagesPayload }
  | { type: MessageType.MESSAGES_LOADED; payload: MessagesLoadedPayload }
  | { type: MessageType.SEND_MESSAGE; payload: SendMessagePayload }
  | { type: MessageType.SEND_FILE; payload: SendFilePayload }
  | { type: MessageType.SEND_IMAGE; payload: SendImagePayload }
  | { type: MessageType.MARK_READ; payload: MarkReadPayload }
  | { type: MessageType.MESSAGE_RECEIVED; payload: MessageReceivedPayload }
  | { type: MessageType.CLEAR_MESSAGES; payload: ClearMessagesPayload }
  | { type: MessageType.MESSAGES_CLEARED; payload: MessagesClearedPayload };
