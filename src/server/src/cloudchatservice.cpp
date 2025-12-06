#include "cloudchatservice.h"
#include "cloudchatmsg.h"

void Login(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, server_t::message_ptr msg,
		   LoginMsg* login_msg) {
	// TODO: 账密登录业务
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
