#include "cloudchatservice.h"
#include "cloudchatdat.h"
#include "cloudchatmsg.h"
#include "cloudchatuser.h"

void Login(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, server_t::message_ptr msg,
		   LoginMsg* login_msg) { // 账密登录业务
	std::string username = login_msg->get_username(), password = login_msg->get_password();
	std::cout << "用户登录消息：" << std::endl;
	std::cout << "username: " << username << std::endl;
	std::cout << "password: " << password << std::endl;
	// 检查用户名是否存在
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserByName(username);
	if (user == nullptr) { // 用户不存在
		SendMsgToClient(cloudchat_srv, hdl, msg, new LoginFailureMsg("用户不存在"));
		return;
	}
	// 检查密码是否正确
	if (user->get_password() != password) {
		SendMsgToClient(cloudchat_srv, hdl, msg, new LoginFailureMsg("密码错误"));
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
	SendMsgToClient(cloudchat_srv, hdl, msg, new LoginSuccessMsg(user_id, username, email, avatar,
																 token));
}

void LoginByToken(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  server_t::message_ptr msg, LoginByTokenMsg* login_by_token_msg) { // 令牌登录业务
	std::string username = login_by_token_msg->get_username();
	std::string token = login_by_token_msg->get_token();
	std::cout << "令牌登录消息：" << std::endl;
	std::cout << "username: " << username << std::endl;
	std::cout << "token: " << token << std::endl;
	// 检查用户名是否存在
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserByName(username);
	if (user == nullptr) { // 用户不存在
		SendMsgToClient(cloudchat_srv, hdl, msg, new LoginFailureMsg("用户不存在"));
		return;
	}
	// 检查令牌
	if (user->get_token() != token) {
		SendMsgToClient(cloudchat_srv, hdl, msg, new LoginFailureMsg("令牌已失效，请重新登录"));
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
	SendMsgToClient(cloudchat_srv, hdl, msg, new LoginSuccessMsg(user_id, username, email, avatar,
																 token));
}

void Register(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, server_t::message_ptr msg,
			  RegisterMsg* register_msg) { // 注册业务
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
		SendMsgToClient(cloudchat_srv, hdl, msg, new RegisterFailureMsg("用户名已存在"));
		return;
	}
	// 用户不存在，注册成功
	user = new CloudChatUser(0, username, password, DEFAULT_AVATAR_URL, generate_token(), email,
							 true);
	CloudChatDatabase::GetInstance()->AddUser(*user);
	user = CloudChatDatabase::GetInstance()->GetUserByName(username);
	SendMsgToClient(cloudchat_srv, hdl, msg, new RegisterSuccessMsg(user->get_id(), username, email,
																	user->get_avatar(),
																	user->get_token()));
}

void Logout(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, server_t::message_ptr msg,
			LogoutMsg* logout_msg) {
	// TODO: 退出登录业务
}

void UpdateProfile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   server_t::message_ptr msg, UpdateProfileMsg* update_profile_msg) {
	// TODO: 更新个人信息业务
}

void LoadContacts(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  server_t::message_ptr msg, LoadContactsMsg* load_contacts_msg) {
	// TODO: 加载联系人列表业务
}

void AddContact(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				server_t::message_ptr msg, AddContactMsg* add_contact_msg) {
	// TODO: 添加联系人业务
}

void DeleteContact(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   server_t::message_ptr msg, DeleteContactMsg* delete_contact_msg) {
	// TODO: 删除联系人业务
}

void LoadMessages(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  server_t::message_ptr msg, LoadMessagesMsg* load_messages_msg) {
	// TODO: 加载聊天记录业务
}

void SendMessage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				 server_t::message_ptr msg, SendMessageMsg* send_message_msg) {
	// TODO: 发送消息业务
}

void SendFile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			  server_t::message_ptr msg, SendFileMsg* send_file_msg) {
	// TODO: 发送文件业务
}

void SendImage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			   server_t::message_ptr msg, SendImageMsg* send_image_msg) {
	// TODO: 发送图片业务
}

void MarkRead(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			  server_t::message_ptr msg, MarkReadMsg* mark_read_msg) {
	// TODO: 标记已读业务
}

void ClearMessages(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   server_t::message_ptr msg, ClearMessagesMsg* clear_messages_msg) {
	// TODO: 清空聊天记录业务
}

void SearchForUserById(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					   server_t::message_ptr msg, SearchForUserByIdMsg* search_for_user_by_id_msg) {
	// TODO: 根据 id 搜索用户
}

void SearchForUserByName(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 server_t::message_ptr msg,
						 SearchForUserByNameMsg* search_for_user_by_name_msg) {
	// TODO: 根据用户名搜索用户
}
