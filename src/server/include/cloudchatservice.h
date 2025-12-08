#ifndef CLOUDCHAT_SERVICE
#define CLOUDCHAT_SERVICE

#include <websocketpp/common/connection_hdl.hpp>
#define DEFAULT_AVATAR_URL "default.png"	// 默认用户头像 URL

#include "cloudchatdat.h"
#include "cloudchatmsg.h"

void Login(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, server_t::message_ptr msg,
		   LoginMsg* login_msg);
void LoginByToken(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  server_t::message_ptr msg, LoginByTokenMsg* login_by_token_msg);
void Register(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, server_t::message_ptr msg,
			  RegisterMsg* register_msg);
void Logout(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, server_t::message_ptr msg,
			LogoutMsg* logout_msg);
void UpdateProfile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   server_t::message_ptr msg, UpdateProfileMsg* update_profile_msg);
void LoadContacts(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  server_t::message_ptr msg, LoadContactsMsg* load_contacts_msg);
void AddContact(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				server_t::message_ptr msg, AddContactMsg* add_contact_msg);
void DeleteContact(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   server_t::message_ptr msg, DeleteContactMsg* delete_contact_msg);
void LoadMessages(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  server_t::message_ptr msg, LoadMessagesMsg* load_messages_msg);
void SendMessage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				 server_t::message_ptr msg, SendMessageMsg* send_message_msg);
void SendFile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			  server_t::message_ptr msg, SendFileMsg* send_file_msg);
void SendImage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			   server_t::message_ptr msg, SendImageMsg* send_image_msg);
void MarkRead(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			  server_t::message_ptr msg, MarkReadMsg* mark_read_msg);
void ClearMessages(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   server_t::message_ptr msg, ClearMessagesMsg* clear_messages_msg);
void SearchForUserById(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					   server_t::message_ptr msg, SearchForUserByIdMsg* search_for_user_by_id_msg);
void SearchForUserByName(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 server_t::message_ptr msg,
						 SearchForUserByNameMsg* search_for_user_by_name_msg);

#endif // CLOUDCHAT_SERVICE
