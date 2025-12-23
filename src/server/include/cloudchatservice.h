#ifndef CLOUDCHAT_SERVICE
#define CLOUDCHAT_SERVICE

#define DEFAULT_AVATAR_URL "default.png"	// 默认用户头像 URL

#include "cloudchatdat.h"
#include "cloudchatmsg.h"

extern std::map<websocketpp::connection_hdl, int,
				std::owner_less<websocketpp::connection_hdl>> g_online_users;
// 请求服务
std::string Login(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, LoginMsg* login_msg);
std::string LoginByToken(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoginByTokenMsg* login_by_token_msg);
std::string Register(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, RegisterMsg* register_msg);
std::string Logout(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, LogoutMsg* logout_msg);
std::string UpdateProfile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   UpdateProfileMsg* update_profile_msg);
std::string LoadContacts(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoadContactsMsg* load_contacts_msg);
std::string LoadMessages(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoadMessagesMsg* load_messages_msg);
void SendMessage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				 SendMessageMsg* send_message_msg);
void SendFile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, SendFileMsg* send_file_msg);
void SendImage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			   SendImageMsg* send_image_msg);
std::string MarkRead(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, MarkReadMsg* mark_read_msg);
std::string ClearMessages(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   ClearMessagesMsg* clear_messages_msg);
std::string SearchForUserById(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					   SearchForUserByIdMsg* search_for_user_by_id_msg);
std::string SearchForUserByName(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 SearchForUserByNameMsg* search_for_user_by_name_msg);
void AddFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					  AddFriendRequestClientMsg* add_friend_request_client_msg);
void RefuseFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 RefuseFriendRequestClientMsg* refuse_friend_request_client_msg);
void AcceptFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 AcceptFriendRequestClientMsg* accept_friend_request_client_msg);
std::string LoadFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					   LoadFriendRequestMsg* load_friend_request_msg);
/*
std::string UploadFile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				UploadFileMsg* upload_file_msg);
*/
void        GetHdlInfo(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, HdlInfoMsg* hdl_info_msg);

#endif // CLOUDCHAT_SERVICE
