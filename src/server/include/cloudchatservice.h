#ifndef CLOUDCHAT_SERVICE
#define CLOUDCHAT_SERVICE

#include "cloudchatdat.h"
#include "cloudchatmsg.h"

void Login(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, server_t::message_ptr msg,
		   LoginMsg* login_msg);
void LoginByToken(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  server_t::message_ptr msg, LoginByTokenMsg* login_by_token_msg);
void Register(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, server_t::message_ptr msg,
			  RegisterMsg* register_msg);

#endif // CLOUDCHAT_SERVICE
