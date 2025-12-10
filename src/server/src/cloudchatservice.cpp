#include "cloudchatservice.h"
#include "cloudchatdat.h"

std::map<int, websocketpp::connection_hdl> g_online_users_hdl;
std::map<websocketpp::connection_hdl, int> g_online_users_id;
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
	g_online_users_hdl[user_id] = hdl;
	g_online_users_id[hdl] = user_id;
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
	g_online_users_hdl[user_id] = hdl;
	g_online_users_id[hdl] = user_id;
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
	g_online_users_hdl[user->get_id()] = hdl;
	g_online_users_id[hdl] = user->get_id();
	SendMsgToClient(cloudchat_srv, hdl, new RegisterSuccessMsg(user->get_id(), username,
															   email, user->get_avatar(),
															   user->get_token()));
}
// 退出登录业务
void Logout(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, LogoutMsg* logout_msg) {
	int user_id = logout_msg->get_user_id();
	std::cout << "用户下线：" << std::endl;
	std::cout << "userId: " << user_id << std::endl;

	g_online_users_hdl.erase(user_id);
	g_online_users_id.erase(hdl);
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserById(user_id);
	user->SetOnline(false);
	CloudChatDatabase::GetInstance()->UpdateUser(user);
}

void UpdateProfile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   UpdateProfileMsg* update_profile_msg) {
	// TODO: 更新个人信息业务
}

void LoadContacts(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoadContactsMsg* load_contacts_msg) {
	// TODO: 加载联系人列表业务
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
				  LoadMessagesMsg* load_messages_msg) {
	// TODO: 加载聊天记录业务
}

void SendMessage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				 SendMessageMsg* send_message_msg) {
	// TODO: 发送消息业务
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
			  MarkReadMsg* mark_read_msg) {
	// TODO: 标记已读业务
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
	
}

void RefuseFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 RefuseFriendRequestClientMsg* refuse_friend_request_client_msg) {
	
}

void AcceptFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 AcceptFriendRequestClientMsg* accept_friend_request_client_msg) {
	
}

void LoadFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					   LoadFriendRequestMsg* load_friend_request_msg) {
	
}
