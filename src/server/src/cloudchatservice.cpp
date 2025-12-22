#include "cloudchatservice.h"
#include "cloudchatdat.h"
#include "cloudchatmsg.h"
#include "cloudchatuser.h"
#include <websocketpp/base64/base64.hpp>

std::map<websocketpp::connection_hdl, int,
	std::owner_less<websocketpp::connection_hdl>> g_online_users;
// 账密登录业务
void Login(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, LoginMsg* login_msg) {
	std::string username = login_msg->get_username(), password = login_msg->get_password();
	std::cout << "用户登录消息：" << std::endl;
	std::cout << "username: " << username << std::endl;
	std::cout << "password: " << password << std::endl;
	// 检查用户名是否存在
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserByName(username);
	if (user == nullptr) { // 用户不存在
		SendMsgToClient(cloudchat_srv, hdl, new LoginFailureMsg("用户不存在"));
		return;
	}
	// 检查密码是否正确
	if (user->get_password() != password) {
		SendMsgToClient(cloudchat_srv, hdl, new LoginFailureMsg("密码错误"));
		return;
	}
	// 登录成功
	int user_id = user->get_id();
	std::string email = user->get_email();
	std::string avatar = user->get_avatar();
	std::string token = generate_token();
	user->SetToken(token);
	user->SetOnline(true);
	CloudChatDatabase::GetInstance()->UpdateUser(user); // 更新令牌
	// 将用户加入在线列表
	g_online_users[hdl] = user_id;
	// 回复消息
	SendMsgToClient(cloudchat_srv, hdl, new LoginSuccessMsg(user_id, username, email, avatar,
															token));
}

void LoginByToken(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoginByTokenMsg* login_by_token_msg) { // 令牌登录业务
	std::string username = login_by_token_msg->get_username();
	std::string token = login_by_token_msg->get_token();
	std::cout << "令牌登录消息：" << std::endl;
	std::cout << "username: " << username << std::endl;
	std::cout << "token: " << token << std::endl;
	// 检查用户名是否存在
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserByName(username);
	if (user == nullptr) { // 用户不存在
		SendMsgToClient(cloudchat_srv, hdl, new LoginFailureMsg("用户不存在"));
		return;
	}
	// 检查令牌
	if (user->get_token() != token) {
		SendMsgToClient(cloudchat_srv, hdl, new LoginFailureMsg("令牌已失效，请重新登录"));
		return;
	}
	// 登录成功
	int user_id = user->get_id();
	std::string email = user->get_email();
	std::string avatar = user->get_avatar();
	token = generate_token();
	user->SetToken(token);
	user->SetOnline(true);
	CloudChatDatabase::GetInstance()->UpdateUser(user); // 更新令牌
	g_online_users[hdl] = user_id;
	SendMsgToClient(cloudchat_srv, hdl, new LoginSuccessMsg(user_id, username, email, avatar,
															token));
}
// 注册业务
void Register(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, RegisterMsg* register_msg) { 
	std::string username = register_msg->get_username();
	std::string password = register_msg->get_password();
	std::string email = register_msg->get_email();
	std::cout << "用户注册消息：" << std::endl;
	std::cout << "username: " << username << std::endl;
	std::cout << "password: " << password << std::endl;
	std::cout << "email: " << email << std::endl;
	// 检查用户名是否存在
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserByName(username);
	if (user != nullptr) { // 用户名已存在
		SendMsgToClient(cloudchat_srv, hdl, new RegisterFailureMsg("用户名已存在"));
		return;
	}
	// 用户不存在，注册成功
	user = new CloudChatUser(0, username, password, DEFAULT_AVATAR_URL, generate_token(), email,
							 true);
	CloudChatDatabase::GetInstance()->AddUser(*user);
	user = CloudChatDatabase::GetInstance()->GetUserByName(username);
	g_online_users[hdl] = user->get_id();
	SendMsgToClient(cloudchat_srv, hdl, new RegisterSuccessMsg(user->get_id(), username,
															   email, user->get_avatar(),
															   user->get_token()));
}
// 退出登录业务
void Logout(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, LogoutMsg* logout_msg) {
	int user_id = logout_msg->get_user_id();
	std::cout << "用户下线：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;

	if (g_online_users.find(hdl) != g_online_users.end()) g_online_users.erase(hdl);
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserById(user_id);
	user->SetOnline(false);
	CloudChatDatabase::GetInstance()->UpdateUser(user);
}

void UpdateProfile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   UpdateProfileMsg* update_profile_msg) { // 更新个人信息业务
	int user_id = update_profile_msg->get_user_id();
	std::string username = update_profile_msg->get_username();
	std::string password = update_profile_msg->get_password();
	std::string email    = update_profile_msg->get_email();
	std::string avatar   = update_profile_msg->get_avatar();

	std::cout << "更新个人信息：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;
	std::cout << "username: " << username << std::endl;
	std::cout << "email: " << email << std::endl;
	std::cout << "avatar: " << avatar << std::endl;

	CloudChatUser* old_profile = CloudChatDatabase::GetInstance()->GetUserById(user_id);
	password = old_profile->get_password();
	CloudChatUser* new_profile = new CloudChatUser(user_id, username, password, avatar,
												   generate_token(), email, true);
	if (!CloudChatDatabase::GetInstance()->UpdateUser(new_profile)) {
		// 更新 users 数据表失败
		SendMsgToClient(cloudchat_srv, hdl, new ProfileUpdatedFailedMsg("更新 users 数据表失败"));
		return;
	}
	SendMsgToClient(cloudchat_srv, hdl, new ProfileUpdatedSuccessMsg(user_id, username, password,
																	 email, avatar));
}

void LoadContacts(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoadContactsMsg* load_contacts_msg) { // 加载联系人列表业务
	int user_id = load_contacts_msg->get_user_id();

	std::cout << "加载联系人列表：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;

	SendMsgToClient(cloudchat_srv, hdl, new ContactsLoadedMsg(CloudChatDatabase::GetInstance()->
															  get_contacts(user_id)));
}

void AddContact(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				AddContactMsg* add_contact_msg) {
	// TODO: 添加联系人业务
}

void DeleteContact(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   DeleteContactMsg* delete_contact_msg) {
	// TODO: 删除联系人业务
}

void LoadMessages(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoadMessagesMsg* load_messages_msg) { // 加载聊天记录业务
	int user_id = load_messages_msg->get_user_id();
	int target_id = load_messages_msg->get_target_id();

	std::cout << "加载聊天记录：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;
	std::cout << "targetId: " << target_id << std::endl;

	std::vector<CloudChatMessage> messages = CloudChatDatabase::GetInstance()->GetMessagesByTwoIds(
		user_id, target_id);
	SendMsgToClient(cloudchat_srv, hdl, new MessagesLoadedMsg(target_id, messages));
}

void SendMessage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				 SendMessageMsg* send_message_msg) { // 发送消息业务
	std::string temp_id = send_message_msg->get_temp_id();
	int sender_id = send_message_msg->get_sender_id();
	int receiver_id = send_message_msg->get_receiver_id();
	std::string content = send_message_msg->get_content();
	time_t created_at = time(0);

	std::cout << "发送消息：" << std::endl;
	std::cout << "temp_id: " << temp_id << std::endl;
	std::cout << "sender_id: " << sender_id << std::endl;
	std::cout << "receiver_id: " << receiver_id << std::endl;
	std::cout << "content: " << content << std::endl;

	CloudChatMessage* message = new CloudChatMessage(0, false, TEXT_MESSAGE, sender_id, receiver_id,
													 content, "", 0, "", false, created_at);
	if (!CloudChatDatabase::GetInstance()->AddMessage(message)) {
		SendMsgToClient(cloudchat_srv, hdl, new MessageSendFailedMsg(temp_id,
																	 "messages 数据表更新失败"));
		return;
	}

	SendMsgToClient(cloudchat_srv, hdl, new SelfMessageReceivedMsg(temp_id, 0, ctime(&created_at)));
	CloudChatUser* target = CloudChatDatabase::GetInstance()->GetUserById(receiver_id);
	if (target == nullptr) return;
	if (target->is_online()) {
		for (auto& p : g_online_users) {
			if (p.second == receiver_id) {
				SendMsgToClient(cloudchat_srv, p.first, new ToSelfMessageReceivedMsg(*message));
				break;
			}
		}
	}
}

void SendFile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			  SendFileMsg* send_file_msg) {
	// TODO: 发送文件业务
}

void SendImage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			   SendImageMsg* send_image_msg) {
	// TODO: 发送图片业务
}

void MarkRead(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			  MarkReadMsg* mark_read_msg) { // 标记已读业务
	int user_id = mark_read_msg->get_user_id();
	int target_id = mark_read_msg->get_target_id();

	std::cout << "标记已读：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;
	std::cout << "targetId: " << target_id << std::endl;

	std::vector<CloudChatMessage> messages = CloudChatDatabase::GetInstance()->GetMessagesByTwoIds(
		user_id, target_id);
	for (CloudChatMessage message : messages) {
		if (message.get_receiver_id() == user_id) message.SetIsRead(true);
		CloudChatDatabase::GetInstance()->UpdateMessage(&message);
	}
}

void ClearMessages(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   ClearMessagesMsg* clear_messages_msg) {
	// TODO: 清空聊天记录业务
}

void SearchForUserById(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,				   
					   SearchForUserByIdMsg* search_for_user_by_id_msg) { // 根据 id 搜索用户
	int id = search_for_user_by_id_msg->get_user_id();
	
	std::cout << "搜索指定用户：" << std::endl;
	std::cout << "userId: " << id << std::endl;
	
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserById(id);
	std::vector<CloudChatUser> users;
	if (user) users.push_back(*user); // 找到了指定用户
	SendMsgToClient(cloudchat_srv, hdl, new SearchForUserResultMsg(users));
}

void SearchForUserByName(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 SearchForUserByNameMsg* search_for_user_by_name_msg) { // 根据用户名搜索用户
	std::string username = search_for_user_by_name_msg->get_username();
	std::cout << "搜索指定用户：" << std::endl;
	std::cout << "username: " << username << std::endl;
	std::vector<CloudChatUser> users = CloudChatDatabase::GetInstance()->SearchUsersByName(
		username);
	SendMsgToClient(cloudchat_srv, hdl, new SearchForUserResultMsg(users));
}

void AddFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					  AddFriendRequestClientMsg* add_friend_request_client_msg) {
	FriendRequest friend_request = add_friend_request_client_msg->get_friend_request();
	
	std::cout << "添加好友请求：" << std::endl;
	std::cout << "requesterId: " << friend_request.get_requester_id() << std::endl;
	std::cout << "requesterUsername: " << friend_request.get_requester_username() << std::endl;
	std::cout << "targetId: " << std::endl;
	std::cout << "targetUsername: " << friend_request.get_target_username() << std::endl;

	// 检查是否已经是好友
	if (CloudChatDatabase::GetInstance()->is_friend(friend_request.get_requester_id(),
													friend_request.get_target_id())) {
		SendMsgToClient(cloudchat_srv, hdl, new FriendRequestAddedFailedMsg("你和 TA 已经是好友了"));
		return;
	}

	FriendRequest* res = CloudChatDatabase::GetInstance()->GetFriendRequestByTwoIds(
		friend_request.get_requester_id(), friend_request.get_target_id()
		);
	if (res != nullptr) {		// 已经发送过请求
		SendMsgToClient(cloudchat_srv, hdl, new FriendRequestAddedFailedMsg("已向 TA 发送过好友请求"));
		return;
	}
	res = CloudChatDatabase::GetInstance()->GetFriendRequestByTwoIds(
		friend_request.get_target_id(),
		friend_request.get_requester_id()
		);
	if (res != nullptr) {		// 已经收到过请求
		SendMsgToClient(cloudchat_srv, hdl,
						new FriendRequestAddedFailedMsg("已收到过 TA 发来的好友请求"));
		return;
	}
	
	if (CloudChatDatabase::GetInstance()->AddFriendRequest(friend_request)) {
		res = CloudChatDatabase::GetInstance()->GetFriendRequestByTwoIds(
			friend_request.get_requester_id(), friend_request.get_target_id());
		SendMsgToClient(cloudchat_srv, hdl, new FriendRequestAddedMsg(*res));
		CloudChatUser* target_user = CloudChatDatabase::GetInstance()->GetUserById(
			friend_request.get_target_id());
		if (target_user->is_online()) {
			for (auto& p : g_online_users) {
				if (p.second == target_user->get_id()) {
					SendMsgToClient(cloudchat_srv, p.first,
									new AddFriendRequestServerMsg(friend_request));
					break;
				}
			}
		}
	} else SendMsgToClient(cloudchat_srv, hdl, new FriendRequestAddedFailedMsg("数据库操作失败"));
}

void RefuseFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 RefuseFriendRequestClientMsg* refuse_friend_request_client_msg) {
	int id = refuse_friend_request_client_msg->get_id();

	std::cout << "拒绝好友请求：" << std::endl;
	std::cout << "id: " << id << std::endl;

	FriendRequest* friend_request = CloudChatDatabase::GetInstance()->GetFriendRequestById(id);
	if (friend_request == nullptr) {
		SendMsgToClient(cloudchat_srv, hdl, new FriendRequestRefusedFailedMsg("该条好友请求不存在"));
		return;
	}

	friend_request->SetStatus(FRIEND_REQUEST_STATUS_REFUSED);
	if (!CloudChatDatabase::GetInstance()->UpdateFriendRequest(friend_request)) {
		// friend_requests 数据表更新失败
		SendMsgToClient(cloudchat_srv, hdl, new FriendRequestRefusedFailedMsg("好友请求列表更新失败"));
		return;
	}
	// 回复消息
	SendMsgToClient(cloudchat_srv, hdl, new FriendRequestRefusedMsg(id));
	CloudChatUser* requester = CloudChatDatabase::GetInstance()->GetUserById(
		friend_request->get_requester_id());
	if (requester->is_online()) {
		for (auto& p : g_online_users) {
			if (p.second == requester->get_id()) {
				SendMsgToClient(cloudchat_srv, p.first, new RefuseFriendRequestServerMsg(id));
				break;
			}
		}
	}
}

void AcceptFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 AcceptFriendRequestClientMsg* accept_friend_request_client_msg) {
	int id = accept_friend_request_client_msg->get_id();

	std::cout << "接受好友请求：" << std::endl;
	std::cout << "id: " << id << std::endl;

	FriendRequest* friend_request = CloudChatDatabase::GetInstance()->GetFriendRequestById(id);
	if (friend_request == nullptr) {
		SendMsgToClient(cloudchat_srv, hdl, new FriendRequestRefusedFailedMsg("该条好友请求不存在"));
		return;
	}

	friend_request->SetStatus(FRIEND_REQUEST_STATUS_ACCEPTED);
	if (!CloudChatDatabase::GetInstance()->UpdateFriendRequest(friend_request)) {
		// friend_requests 数据表更新失败
		SendMsgToClient(cloudchat_srv, hdl, new FriendRequestAcceptedFailedMsg("好友请求列表更新失败"));
		return;
	}
	if (!CloudChatDatabase::GetInstance()->AddFriend(friend_request->get_requester_id(),
													 friend_request->get_target_id())) {
		// friends 数据表更新失败
		SendMsgToClient(cloudchat_srv, hdl, new FriendRequestAcceptedFailedMsg("联系人列表更新失败"));
		friend_request->SetStatus(FRIEND_REQUEST_STATUS_PENDING);
		CloudChatDatabase::GetInstance()->UpdateFriendRequest(friend_request);
		return;
	}
	// 回复消息
	SendMsgToClient(cloudchat_srv, hdl, new FriendRequestAcceptedMsg(id));
	CloudChatUser* requester = CloudChatDatabase::GetInstance()->GetUserById(
		friend_request->get_requester_id());
	CloudChatUser* target = CloudChatDatabase::GetInstance()->GetUserById(
		friend_request->get_target_id());
	SendMsgToClient(cloudchat_srv, hdl, new ContactAddedMsg(requester->get_id(),
															requester->get_username(),
															requester->get_avatar(),
															requester->is_online()));
	if (requester->is_online()) {
		for (auto& p : g_online_users) {
			if (p.second == requester->get_id()) {
				SendMsgToClient(cloudchat_srv, p.first, new AcceptFriendRequestServerMsg(id));
				SendMsgToClient(cloudchat_srv, p.first, new ContactAddedMsg(target->get_id(),
																			target->get_username(),
																			target->get_avatar(),
																			target->is_online()));
				break;
			}
		}
	}
}

void LoadFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					   LoadFriendRequestMsg* load_friend_request_msg) {
	int user_id = load_friend_request_msg->get_user_id();

	std::cout << "加载好友请求列表：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;

	std::vector<FriendRequest> friend_requests =
		CloudChatDatabase::GetInstance()->GetFriendRequestsByUserId(user_id);

	SendMsgToClient(cloudchat_srv, hdl, new FriendRequestLoadedMsg(friend_requests));
}

void UploadFile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				UploadFileMsg* upload_file_msg) {
	std::string file_path = upload_file_msg->get_file_path();
	std::string data_stream = websocketpp::base64_decode(upload_file_msg->get_data_stream());

	std::cout << "上传文件：" << std::endl;
	std::cout << "filePath: " << file_path << std::endl;

	std::ofstream fout;
	fout.open(file_path, std::ios::out | std::ios::binary);
	if (!fout.is_open()) {
		SendMsgToClient(cloudchat_srv, hdl, new FileUploadedFailedMsg(file_path,
																	  "文件保存路径不存在"));
		return;
	}

	try {
		fout.write(data_stream.c_str(), data_stream.size());
		SendMsgToClient(cloudchat_srv, hdl, new FileUploadedMsg(file_path));
	} catch (...) {
		SendMsgToClient(cloudchat_srv, hdl, new FileUploadedFailedMsg(file_path, "未知错误"));
	}

	fout.close();
}

std::string HTTPLogin(LoginMsg* login_msg) {
	return "";
}

std::string HTTPLoginByToken(LoginByTokenMsg* login_by_token_msg) {
	return "";
}

std::string HTTPRegister(RegisterMsg* register_msg) {
	return "";
}

std::string HTTPLogout(LogoutMsg* logout_msg) {
	return "";
}

std::string HTTPUpdateProfile(UpdateProfileMsg* update_profile_msg) {
	return "";
}

std::string HTTPLoadContacts(LoadContactsMsg* load_contacts_msg) {
	return "";
}

std::string HTTPLoadMessages(LoadMessagesMsg* load_messages_msg) {
	return "";
}

std::string HTTPMarkRead(MarkReadMsg* mark_read_msg) {
	return "";
}

std::string HTTPSearchForUserById(SearchForUserByIdMsg* search_for_user_by_id_msg) {
	return "";
}

std::string HTTPSearchForUserByName(SearchForUserByNameMsg* search_for_user_by_name_msg) {
	return "";
}

std::string HTTPLoadFriendRequest(LoadFriendRequestMsg* load_friend_request_msg) {
	return "";
}
