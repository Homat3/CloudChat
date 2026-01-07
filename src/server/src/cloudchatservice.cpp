#include "cloudchatservice.h"
#include "cloudchatdat.h"
#include "cloudchatmsg.h"
#include "cloudchatuser.h"
#include <termios.h>

std::map<websocketpp::connection_hdl, int,
	std::owner_less<websocketpp::connection_hdl>> g_online_users;
// 账密登录业务
std::string Login(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, LoginMsg* login_msg) {
    bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
	std::string username = login_msg->get_username(), password = login_msg->get_password();
	std::cout << "用户登录消息：" << std::endl;
	std::cout << "username: " << username << std::endl;
	std::cout << "password: " << password << std::endl;
	// 检查用户名是否存在
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserByName(username);
	if (user == nullptr) { // 用户不存在
		LoginFailureMsg* login_failure_msg = new LoginFailureMsg("用户不存在");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, login_failure_msg);
		return login_failure_msg->to_JSON();
	}
	// 检查密码是否正确
	if (user->get_password() != password) {
		LoginFailureMsg* login_failure_msg = new LoginFailureMsg("密码错误");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, login_failure_msg);
		return login_failure_msg->to_JSON();
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
	if (websocket_open) g_online_users[hdl] = user_id;
	// 回复消息
	LoginSuccessMsg* login_success_msg = new LoginSuccessMsg(user_id, username, email, avatar,
															 token);
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, login_success_msg);
	return login_success_msg->to_JSON();
}

std::string LoginByToken(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoginByTokenMsg* login_by_token_msg) { // 令牌登录业务
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
	std::string username = login_by_token_msg->get_username();
	std::string token = login_by_token_msg->get_token();
	std::cout << "令牌登录消息：" << std::endl;
	std::cout << "username: " << username << std::endl;
	std::cout << "token: " << token << std::endl;
	// 检查用户名是否存在
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserByName(username);
	if (user == nullptr) { // 用户不存在
		LoginFailureMsg* login_failure_msg = new LoginFailureMsg("用户不存在");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, login_failure_msg);
		return login_failure_msg->to_JSON();
	}
	// 检查令牌
	if (user->get_token() != token) {
		LoginFailureMsg* login_failure_msg = new LoginFailureMsg("令牌已失效，请重新登录");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, login_failure_msg);
		return login_failure_msg->to_JSON();
	}
	// 登录成功
	int user_id = user->get_id();
	std::string email = user->get_email();
	std::string avatar = user->get_avatar();
	token = generate_token();
	user->SetToken(token);
	user->SetOnline(true);
	CloudChatDatabase::GetInstance()->UpdateUser(user); // 更新令牌
	if (websocket_open) g_online_users[hdl] = user_id;
	LoginSuccessMsg* login_success_msg = new LoginSuccessMsg(user_id, username, email, avatar,
															 token);
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, login_success_msg);
	return login_success_msg->to_JSON();
}
// 注册业务
std::string Register(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, RegisterMsg* register_msg) {
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
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
		RegisterFailureMsg* register_failure_msg = new RegisterFailureMsg("用户名已存在");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, register_failure_msg);
		return register_failure_msg->to_JSON();
	}
	// 检查邮箱地址是否存在
	user = CloudChatDatabase::GetInstance()->GetUserByEmail(email);
	if (user != nullptr) {		// 邮箱地址已存在
		RegisterFailureMsg* register_failure_msg = new RegisterFailureMsg("邮箱已存在");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, register_failure_msg);
		return register_failure_msg->to_JSON();
	}
	// 用户名和邮箱地址都不存在，注册成功
	user = new CloudChatUser(0, username, password, DEFAULT_AVATAR_URL, generate_token(), email,
							 true);
	CloudChatDatabase::GetInstance()->AddUser(*user);
	user = CloudChatDatabase::GetInstance()->GetUserByName(username);
	if (websocket_open) g_online_users[hdl] = user->get_id();
	RegisterSuccessMsg* register_success_msg = new RegisterSuccessMsg(user->get_id(), username,
																	  email, user->get_avatar(),
																	  user->get_token());
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, register_success_msg);
	return register_success_msg->to_JSON();
}
// 退出登录业务
std::string Logout(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, LogoutMsg* logout_msg) {
	int user_id = logout_msg->get_user_id();
	std::cout << "用户下线：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;

	if (g_online_users.find(hdl) != g_online_users.end()) g_online_users.erase(hdl);
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserById(user_id);
	user->SetOnline(false);
	CloudChatDatabase::GetInstance()->UpdateUser(user);

	return "";
}

std::string UpdateProfile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   UpdateProfileMsg* update_profile_msg) { // 更新个人信息业务
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
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
	if (!CloudChatDatabase::GetInstance()->UpdateUser(new_profile)) { // 更新 users 数据表失败
		ProfileUpdatedFailedMsg* profile_updated_failure_msg =
			new ProfileUpdatedFailedMsg("更新 users 数据表失败");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, profile_updated_failure_msg);
		return profile_updated_failure_msg->to_JSON();
	}

	ProfileUpdatedSuccessMsg* profile_updated_success_msg = new ProfileUpdatedSuccessMsg(user_id,
																						 username,
																						 password,
																						 email,
																						 avatar);
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, profile_updated_success_msg);
	return profile_updated_success_msg->to_JSON();
}

std::string LoadContacts(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoadContactsMsg* load_contacts_msg) { // 加载联系人列表业务
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
	int user_id = load_contacts_msg->get_user_id();

	std::cout << "加载联系人列表：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;

	ContactsLoadedMsg* contacts_loaded_msg = new ContactsLoadedMsg(CloudChatDatabase::GetInstance()->
																   get_contacts(user_id));
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, contacts_loaded_msg);
	return contacts_loaded_msg->to_JSON();
}

std::string LoadMessages(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoadMessagesMsg* load_messages_msg) { // 加载聊天记录业务
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
	int user_id = load_messages_msg->get_user_id();
	int target_id = load_messages_msg->get_target_id();

	std::cout << "加载聊天记录：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;
	std::cout << "targetId: " << target_id << std::endl;

	std::vector<CloudChatMessage> messages = CloudChatDatabase::GetInstance()->GetMessagesByTwoIds(
		user_id, target_id);
	MessagesLoadedMsg* messages_loaded_msg = new MessagesLoadedMsg(target_id, messages);
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, messages_loaded_msg);
	return messages_loaded_msg->to_JSON();
}

std::string SendMessage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				 SendMessageMsg* send_message_msg) { // 发送消息业务
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
	std::string temp_id = send_message_msg->get_temp_id();
	int         sender_id = send_message_msg->get_sender_id();
	int         receiver_id = send_message_msg->get_receiver_id();
	std::string content     = send_message_msg->get_content();
	time_t      created_at  = time(0);

	std::cout << "发送消息：" << std::endl;
	std::cout << "temp_id: " << temp_id << std::endl;
	std::cout << "sender_id: " << sender_id << std::endl;
	std::cout << "receiver_id: " << receiver_id << std::endl;
	std::cout << "content: " << content << std::endl;

	CloudChatMessage* message = new CloudChatMessage(0, false, TEXT_MESSAGE, sender_id, receiver_id,
													 content, "", 0, "", false, created_at);
	if (!CloudChatDatabase::GetInstance()->AddMessage(message)) {
		MessageSendFailedMsg* message_send_failed_msg =
			new MessageSendFailedMsg(temp_id, "messages 数据表更新失败");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, message_send_failed_msg);
		return message_send_failed_msg->to_JSON();
	}

	SelfMessageReceivedMsg* self_message_received_msg =
		new SelfMessageReceivedMsg(temp_id, 0, ctime(&created_at));
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, self_message_received_msg);
	CloudChatUser* target = CloudChatDatabase::GetInstance()->GetUserById(receiver_id);
	if (target == nullptr) return self_message_received_msg->to_JSON();
	if (target->is_online()) {
		for (auto& p : g_online_users) {
			if (p.second == receiver_id) {
				SendMsgToClient(cloudchat_srv, p.first, new ToSelfMessageReceivedMsg(*message));
				break;
			}
		}
	}
	return self_message_received_msg->to_JSON();
}

void SendFile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			  SendFileMsg* send_file_msg) {
	// TODO: 发送文件业务
}

void SendImage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			   SendImageMsg* send_image_msg) {
	// TODO: 发送图片业务
}

std::string MarkRead(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
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
	return "";
}

std::string ClearMessages(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   ClearMessagesMsg* clear_messages_msg) {
	// TODO: 清空聊天记录业务
	return "";
}

std::string SearchForUserById(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,				   
					   SearchForUserByIdMsg* search_for_user_by_id_msg) { // 根据 id 搜索用户
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
	int id = search_for_user_by_id_msg->get_user_id();
	
	std::cout << "搜索指定用户：" << std::endl;
	std::cout << "userId: " << id << std::endl;
	
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserById(id);
	std::vector<CloudChatUser> users;
	if (user) users.push_back(*user); // 找到了指定用户
	SearchForUserResultMsg* search_for_user_result_msg = new SearchForUserResultMsg(users);
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, search_for_user_result_msg);
	return search_for_user_result_msg->to_JSON();
}

std::string SearchForUserByName(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 SearchForUserByNameMsg* search_for_user_by_name_msg) { // 根据用户名搜索用户
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
	std::string username = search_for_user_by_name_msg->get_username();
	std::cout << "搜索指定用户：" << std::endl;
	std::cout << "username: " << username << std::endl;
	
	std::vector<CloudChatUser> users = CloudChatDatabase::GetInstance()->SearchUsersByName(
		username);
	SearchForUserResultMsg* search_for_user_result_msg = new SearchForUserResultMsg(users);
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, search_for_user_result_msg);
	return search_for_user_result_msg->to_JSON();
}

std::string AddFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					  AddFriendRequestClientMsg* add_friend_request_client_msg) {
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
	FriendRequest friend_request = add_friend_request_client_msg->get_friend_request();
	
	std::cout << "添加好友请求：" << std::endl;
	std::cout << "requesterId: " << friend_request.get_requester_id() << std::endl;
	std::cout << "requesterUsername: " << friend_request.get_requester_username() << std::endl;
	std::cout << "targetId: " << std::endl;
	std::cout << "targetUsername: " << friend_request.get_target_username() << std::endl;

	// 检查是否已经是好友
	if (CloudChatDatabase::GetInstance()->is_friend(friend_request.get_requester_id(),
													friend_request.get_target_id())) {
		FriendRequestAddedFailedMsg* friend_request_added_failed_msg =
			new FriendRequestAddedFailedMsg("你和 TA 已经是好友了");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_request_added_failed_msg);
		return friend_request_added_failed_msg->to_JSON();
	}

	FriendRequest* res = CloudChatDatabase::GetInstance()->GetFriendRequestByTwoIds(
		friend_request.get_requester_id(), friend_request.get_target_id()
		);
	if (res != nullptr && res->get_status() == FRIEND_REQUEST_STATUS_PENDING) {		// 已经发送过请求
		FriendRequestAddedFailedMsg* friend_request_added_failed_msg =
			new FriendRequestAddedFailedMsg("已向 TA 发送过好友请求");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_request_added_failed_msg);
		return friend_request_added_failed_msg->to_JSON();
	} else if (res != nullptr) CloudChatDatabase::GetInstance()->RemoveFriendRequest(*res);
	
	res = CloudChatDatabase::GetInstance()->GetFriendRequestByTwoIds(
		friend_request.get_target_id(),
		friend_request.get_requester_id()
		);
	if (res != nullptr && res->get_status() == FRIEND_REQUEST_STATUS_PENDING) {		// 已经收到过请求
		FriendRequestAddedFailedMsg* friend_request_added_failed_msg =
			new FriendRequestAddedFailedMsg("已收到过 TA 发来的好友请求");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_request_added_failed_msg);
		return friend_request_added_failed_msg->to_JSON();
	} else if (res != nullptr) CloudChatDatabase::GetInstance()->RemoveFriendRequest(*res);
	
	if (CloudChatDatabase::GetInstance()->AddFriendRequest(friend_request)) {
		res = CloudChatDatabase::GetInstance()->GetFriendRequestByTwoIds(
			friend_request.get_requester_id(), friend_request.get_target_id());
		FriendRequestAddedMsg* friend_request_added_msg = new FriendRequestAddedMsg(*res);
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_request_added_msg);
		CloudChatUser* target_user = CloudChatDatabase::GetInstance()->GetUserById(
			friend_request.get_target_id());
		if (target_user->is_online()) {
			for (auto& p : g_online_users) {
				if (p.second == target_user->get_id()) {
					SendMsgToClient(cloudchat_srv, p.first, new AddFriendRequestServerMsg(*res));
					break;
				}
			}
		}
		return friend_request_added_msg->to_JSON();
	}
	FriendRequestAddedFailedMsg* friend_request_added_failed_msg =
		new FriendRequestAddedFailedMsg("数据库操作失败");
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_request_added_failed_msg);
	return friend_request_added_failed_msg->to_JSON();
}

std::string RefuseFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 RefuseFriendRequestClientMsg* refuse_friend_request_client_msg) {
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
	int id = refuse_friend_request_client_msg->get_id();

	std::cout << "拒绝好友请求：" << std::endl;
	std::cout << "id: " << id << std::endl;

	FriendRequest* friend_request = CloudChatDatabase::GetInstance()->GetFriendRequestById(id);
	if (friend_request == nullptr) {
		FriendRequestRefusedFailedMsg* friend_request_refused_failed_msg =
			new FriendRequestRefusedFailedMsg("该条好友请求不存在");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_request_refused_failed_msg);
		return friend_request_refused_failed_msg->to_JSON();
	}

	friend_request->SetStatus(FRIEND_REQUEST_STATUS_REFUSED);
	if (!CloudChatDatabase::GetInstance()->UpdateFriendRequest(friend_request)) {
		// friend_requests 数据表更新失败
		FriendRequestRefusedFailedMsg* friend_request_refused_failed_msg =
			new FriendRequestRefusedFailedMsg("好友请求列表更新失败");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_request_refused_failed_msg);
		return friend_request_refused_failed_msg->to_JSON();
	}
	// 回复消息
	FriendRequestRefusedMsg* friend_request_refused_msg = new FriendRequestRefusedMsg(id);
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_request_refused_msg);
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
	return friend_request_refused_msg->to_JSON();
}

std::string AcceptFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 AcceptFriendRequestClientMsg* accept_friend_request_client_msg) {
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
	int id = accept_friend_request_client_msg->get_id();

	std::cout << "接受好友请求：" << std::endl;
	std::cout << "id: " << id << std::endl;

	FriendRequest* friend_request = CloudChatDatabase::GetInstance()->GetFriendRequestById(id);
	if (friend_request == nullptr) {
		FriendRequestAcceptedFailedMsg* friend_request_accepted_failed_msg =
			new FriendRequestAcceptedFailedMsg("该条好友请求不存在");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_request_accepted_failed_msg);
		return friend_request_accepted_failed_msg->to_JSON();
	}

	friend_request->SetStatus(FRIEND_REQUEST_STATUS_ACCEPTED);
	if (!CloudChatDatabase::GetInstance()->UpdateFriendRequest(friend_request)) {
		// friend_requests 数据表更新失败
		FriendRequestAcceptedFailedMsg* friend_request_accepted_failed_msg =
			new FriendRequestAcceptedFailedMsg("好友请求列表更新失败");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_request_accepted_failed_msg);
		return friend_request_accepted_failed_msg->to_JSON();
	}
	if (!CloudChatDatabase::GetInstance()->AddFriend(friend_request->get_requester_id(),
													 friend_request->get_target_id())) {
		// friends 数据表更新失败
		FriendRequestAcceptedFailedMsg* friend_request_accepted_failed_msg =
			new FriendRequestAcceptedFailedMsg("联系人列表更新失败");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_request_accepted_failed_msg);
		friend_request->SetStatus(FRIEND_REQUEST_STATUS_PENDING);
		CloudChatDatabase::GetInstance()->UpdateFriendRequest(friend_request);
		return friend_request_accepted_failed_msg->to_JSON();
	}
	// 回复消息
	FriendRequestAcceptedMsg* friend_request_accepted_msg = new FriendRequestAcceptedMsg(id);
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_request_accepted_msg);
	CloudChatUser* requester = CloudChatDatabase::GetInstance()->GetUserById(
		friend_request->get_requester_id());
	CloudChatUser* target = CloudChatDatabase::GetInstance()->GetUserById(
		friend_request->get_target_id());
	if (websocket_open) {
		SendMsgToClient(cloudchat_srv, hdl, new ContactAddedMsg(requester->get_id(),
																requester->get_username(),
																requester->get_avatar(),
																requester->is_online()));
	} else {
		for (auto& p : g_online_users) {
			if (p.second == friend_request->get_target_id()) {
				SendMsgToClient(cloudchat_srv, p.first,
								new ContactAddedMsg(requester->get_id(), requester->get_username(),
													requester->get_avatar(),
													requester->is_online()));
				break;
			}
		}
	}
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
	return friend_request_accepted_msg->to_JSON();
}

std::string LoadFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					   LoadFriendRequestMsg* load_friend_request_msg) {
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);
	
	int user_id = load_friend_request_msg->get_user_id();

	std::cout << "加载好友请求列表：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;

	std::vector<FriendRequest> friend_requests =
		CloudChatDatabase::GetInstance()->GetFriendRequestsByUserId(user_id);

	FriendRequestLoadedMsg* friend_requests_loaded_msg = new FriendRequestLoadedMsg(friend_requests);
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, friend_requests_loaded_msg);
	return friend_requests_loaded_msg->to_JSON();
}
/*
std::string UploadFile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
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
*/
void GetHdlInfo(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, HdlInfoMsg* hdl_info_msg) {
	int user_id = hdl_info_msg->get_user_id();

	std::cout << "获得 hdl 信息：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;

	g_online_users[hdl] = user_id; // 保存 hdl 信息

	SendMsgToClient(cloudchat_srv, hdl, new HdlGotMsg(user_id)); // 回复客户端
}

std::string DeleteContact(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						  DeleteContactMsg* delete_contact_msg) {
	bool websocket_open = check_websocket_open(cloudchat_srv, hdl);

	int user_id = delete_contact_msg->get_user_id();
	int target_id = delete_contact_msg->get_target_id();

	std::cout << "删除联系人：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;
	std::cout << "targetId: " << target_id << std::endl;

	// 检查是否是好友
	if (!CloudChatDatabase::GetInstance()->is_friend(user_id, target_id)) {
		ContactDeletedFailedMsg* contact_deleted_failed_msg =
			new ContactDeletedFailedMsg("你和 TA 不是好友");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, contact_deleted_failed_msg);
		return contact_deleted_failed_msg->to_JSON();
	}

	if (!CloudChatDatabase::GetInstance()->DeleteFriendship(user_id, target_id)) {
		// 数据表 friends 操作失败
		ContactDeletedFailedMsg* contact_deleted_failed_msg =
			new ContactDeletedFailedMsg("数据表 friends 操作失败");
		if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, contact_deleted_failed_msg);
		return contact_deleted_failed_msg->to_JSON();
	}

	// 删除成功
	ContactDeletedMsg* contact_deleted_msg = new ContactDeletedMsg(target_id);
	if (websocket_open) SendMsgToClient(cloudchat_srv, hdl, contact_deleted_msg); // Websocket 回复
	// 通知被删用户
	CloudChatUser* target = CloudChatDatabase::GetInstance()->GetUserById(target_id);
	if (target == nullptr) return contact_deleted_msg->to_JSON();
	if (target->is_online()) {
		for (auto& p : g_online_users) {
			if (p.second == target->get_id()) {
			    SendMsgToClient(cloudchat_srv, p.first, new DeletedByContactMsg(user_id));
				break;
			}
		}
	}
	return contact_deleted_msg->to_JSON();
}
