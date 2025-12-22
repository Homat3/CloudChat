#ifndef CLOUDCHAT_SERVICE
#define CLOUDCHAT_SERVICE

#define DEFAULT_AVATAR_URL "default.png"	// 默认用户头像 URL

#include "cloudchatdat.h"
#include "cloudchatmsg.h"

extern std::map<websocketpp::connection_hdl, int,
				std::owner_less<websocketpp::connection_hdl>> g_online_users;
// Websocket 请求服务
void Login(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, LoginMsg* login_msg);
void LoginByToken(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoginByTokenMsg* login_by_token_msg);
void Register(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, RegisterMsg* register_msg);
void Logout(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, LogoutMsg* logout_msg);
void UpdateProfile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   UpdateProfileMsg* update_profile_msg);
void LoadContacts(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoadContactsMsg* load_contacts_msg);
void AddContact(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				AddContactMsg* add_contact_msg);
void DeleteContact(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   DeleteContactMsg* delete_contact_msg);
void LoadMessages(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				  LoadMessagesMsg* load_messages_msg);
void SendMessage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				 SendMessageMsg* send_message_msg);
void SendFile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, SendFileMsg* send_file_msg);
void SendImage(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
			   SendImageMsg* send_image_msg);
void MarkRead(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, MarkReadMsg* mark_read_msg);
void ClearMessages(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				   ClearMessagesMsg* clear_messages_msg);
void SearchForUserById(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					   SearchForUserByIdMsg* search_for_user_by_id_msg);
void SearchForUserByName(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 SearchForUserByNameMsg* search_for_user_by_name_msg);
void AddFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					  AddFriendRequestClientMsg* add_friend_request_client_msg);
void RefuseFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 RefuseFriendRequestClientMsg* refuse_friend_request_client_msg);
void AcceptFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
						 AcceptFriendRequestClientMsg* accept_friend_request_client_msg);
void LoadFriendRequest(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					   LoadFriendRequestMsg* load_friend_request_msg);
void UploadFile(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
				UploadFileMsg* upload_file_msg);
// HTTP 请求服务
std::string HTTPLogin(LoginMsg* login_msg);
std::string HTTPLoginByToken(LoginByTokenMsg* login_by_token_msg);
std::string HTTPRegister(RegisterMsg* register_msg);
std::string HTTPLogout(LogoutMsg* logout_msg);
std::string HTTPUpdateProfile(UpdateProfileMsg* update_profile_msg);
std::string HTTPLoadContacts(LoadContactsMsg* load_contacts_msg);
std::string HTTPLoadMessages(LoadMessagesMsg* load_messages_msg);
std::string HTTPMarkRead(MarkReadMsg* mark_read_msg);
std::string HTTPSearchForUserById(SearchForUserByIdMsg* search_for_user_by_id_msg);
std::string HTTPSearchForUserByName(SearchForUserByNameMsg* search_for_user_by_name_msg);
std::string HTTPLoadFriendRequest(LoadFriendRequestMsg* load_friend_request_msg);

#endif // CLOUDCHAT_SERVICE
