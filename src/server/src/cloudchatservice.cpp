#include "cloudchatservice.h"

void Login(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, server_t::message_ptr msg,
		   LoginMsg* login_msg) {
	// TODO: 账密登录业务
	std::cout << "用户登录消息：" << std::endl;
	std::cout << "username: " << login_msg->get_username() << std::endl;
	std::cout << "password: " << login_msg->get_password() << std::endl;
	LoginSuccessMsg login_success_msg(114514, login_msg->get_username(), "1919810@mail.com",
									  "/default/avatar/path", "hajimitsunameruto");
	SendMsgToClient(cloudchat_srv, hdl, msg, &login_success_msg);
}

void LoginByToken(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  server_t::message_ptr msg, LoginByTokenMsg* login_by_token_msg) {
	// TODO: 令牌登录业务
}

void Register(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, server_t::message_ptr msg,
			  RegisterMsg* register_msg) {
	// TODO: 注册业务
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
