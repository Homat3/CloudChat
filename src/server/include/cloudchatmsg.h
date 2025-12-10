/** cloudchatmsg.h
 * CloudChat 消息头文件
 */

#ifndef CLOUDCHATMSG_H
#define CLOUDCHATMSG_H

#include "cloudchatuser.h"

// 聊天消息类型宏
#define TEXT_MESSAGE  0	// 文本消息
#define IMAGE_MESSAGE 1	// 图片
#define FILE_MESSAGE  2	// 文件

// 通信消息发送结果
#define SEND_SUCCESSFUL	 0		// 发送成功
#define SEND_FAILED	    -1		// 发送失败

// 通信消息类型宏
// 两端通用
#define ILLEGAL_MSG "ILLEGAL_MSG"						  // 无效消息
#define ADD_FRIEND_REQUEST "ADD_FRIEND_REQUEST"			  // 添加好友请求
#define REFUSE_FRIEND_REQUEST "REFUSE_FRIEND_REQUEST"	  // 拒绝好友请求
#define ACCEPT_FRIEND_REQUEST "ACCEPT_FRIEND_REQUEST"	  // 通过好友请求
// 客户端消息
#define LOGIN "LOGIN"			// 账密登录
#define LOGIN_BY_TOKEN "LOGIN_BY_TOKEN" // 令牌登录
#define REGISTER       "REGISTER"		// 注册
#define UPDATE_PROFILE "UPDATE_PROFILE" // 更新个人信息
#define LOGOUT         "LOGOUT"			// 退出登录
#define LOAD_CONTACTS  "LOAD_CONTACTS"	// 加载联系人列表
#define SEARCH_FOR_USER_BY_ID "SEARCH_FOR_USER_BY_ID"	  // 根据用户 id 搜索用户
#define SEARCH_FOR_UESR_BY_NAME "SEARCH_FOR_USER_BY_NAME" // 根据用户名搜索用户
#define ADD_CONTACT             "ADD_CONTACT"			  // 添加联系人
#define DELETE_CONTACT          "DELETE_CONTACT"		  // 删除联系人
#define LOAD_MESSAGES           "LOAD_MESSAGES"			  // 加载聊天记录
#define SEND_MESSAGE            "SEND_MESSAGE"			  // 发送聊天消息
#define SEND_FILE               "SEND_FILE"				  // 发送文件
#define SEND_IMAGE              "SEND_IMAGE"			  // 发送图片
#define MARK_READ               "MARK_READ"				  // 标记为已读
#define CLEAR_MESSAGES          "CLEAR_MESSAGES"		  // 清空聊天记录
#define LOAD_FRIEND_REQUEST     "LOAD_FRIEND_REQUEST"	  // 加载好友请求列表
// 服务端消息
#define LOGIN_SUCCESS           "LOGIN_SUCCESS"			  // 登录成功
#define LOGIN_FAILURE           "LOGIN_FAILURE"			  // 登录失败
#define REGISTER_SUCCESS        "REGISTER_SUCCESS"		  // 注册成功
#define REGISTER_FAILURE        "REGISTER_FAILURE"		  // 注册失败
#define PROFILE_UPDATED_SUCCESS "PROFILE_UPDATED_SUCCESS" // 成功更新个人信息
#define PROFILE_UPDATED_FAILED  "PROFILE_UPDATED_FAILED"  // 更新个人信息失败
#define LOGOUT_SUCCESS          "LOGOUT_SUCCESS"		  // 退出登录成功
#define CONTACTS_LOADED         "CONTACTS_LOADED"		  // 已加载联系人列表
#define CONTACTS_LOADED_FAILED  "CONTACTS_LOADED_FAILED"  // 加载联系人列表失败
#define SEARCH_FOR_USER_RESULT  "SEARCH_FOR_USER_RESULT"  // 搜索联系人结果
#define CONTACT_ADDED           "CONTACT_ADDED"			  // 已添加联系人
#define CONTACT_ADDED_FAILED    "CONTACT_ADDED_FAILED"	  // 添加联系人失败
#define CONTACT_DELETED         "CONTACT_DELETED"		  // 已删除联系人
#define CONTACT_DELETED_FAILED  "CONTACT_DELETED_FAILED"  // 删除联系人失败
#define MESSAGES_LOADED         "MESSAGES_LOADED"		  // 已加载聊天记录
#define MESSAGE_RECEIVED_SELF   "MESSAGE_RECEIVED_SELF"	  // 客户端发送的聊天消息已被服务器接收
#define MESSAGE_RECEIVED_OTHER  "MESSAGE_RECEIVED_OTHER"  // 有其他用户向客户端发送聊天消息（新消息提醒）
#define MESSAGES_CLEARD         "MESSAGES_CLEARD"		  // 已清空聊天记录
#define FRIEND_REQUEST_LOADED   "FRIEND_REQUEST_LOADED"	  // 已加载好友请求列表
#define FRIEND_REQUEST_LOADED_FAILED "FRIEND_REQUEST_LOADED_FAILED"	// 加载好友请求列表失败
#define FRIEND_REQUEST_ADDED         "FRIEND_REQUEST_ADDED"			// 已添加好友请求
#define FRIEND_REQUEST_ADDED_FAILED  "FRIEND_REQUEST_ADDED_FAILED"	// 添加好友请求失败
#define FRIEND_REQUEST_REFUSED       "FRIEND_REQUEST_REFUSED"		// 已拒绝好友请求
#define FRIEND_REQUEST_REFUSED_FAILED "FRIEND_REQUEST_REFUSED_FAILED" // 拒绝好友请求失败
#define FRIEND_REQUEST_ACCEPTED       "FRIEND_REQUEST_ACCEPTED"		  // 已通过好友请求
#define FRIEND_REQUEST_ACCEPTED_FAILED "FRIEND_REQUEST_ACCEPTED_FAILED" // 通过好友请求失败

class CloudChatMessage { // 聊天消息类
private:
	int id_; // 消息 id
	bool is_group_; // 是否群聊消息
	int type_;      // 消息类型（文字、图片或文件），取值自聊天消息类型宏
	int sender_id_; // 发送者用户 id
	int receiver_id_; // 接收者 id（可能是用户或群聊）
	std::string content_; // 消息内容（文字消息内容）
	std::string file_name_; // 文件名
	int         file_size_; // 文件大小
	std::string file_path_; // 文件路径
	bool        is_read_;   // 消息是否已读
	time_t      created_at_; // 发送时间

public:
	// getter
	int get_id();
	bool get_is_group();
	int get_type();
	std::string get_type_str();
	int get_sender_id();
	int get_receiver_id();
	std::string get_content();
	std::string get_file_name();
	int         get_file_size();
	std::string get_file_path();
	bool        get_is_read();
	time_t      get_created_at();
};

// 客户端和服务端之间通信的消息类
class ProtocalMsg { // 通信消息基类
protected:
	std::string type_; // 取值自通信消息类型宏

public:
	ProtocalMsg(std::string type);
	std::string get_type();
};

class ClientMsg : public ProtocalMsg { // 客户端发送的消息
public:
	ClientMsg(std::string type);
};

class ServerMsg : public ProtocalMsg { // 服务端发送的消息
public:
	ServerMsg(std::string type);
	virtual std::string to_JSON();
};

class LoginMsg : public ClientMsg { // 账密登录消息
private:
	std::string username_; // 用户名
	std::string password_; // 密码

public:
	LoginMsg(std::string username, std::string password);
	static LoginMsg* parse_from_JSON(std::string JSON, int payload_pos);
	std::string get_username();
	std::string get_password();
};

class LoginByTokenMsg : public ClientMsg { // 令牌登录消息
private:
	std::string username_;		// 用户名
	std::string token_;			// 令牌

public:
	LoginByTokenMsg(std::string username, std::string token);
	static LoginByTokenMsg* parse_from_JSON(std::string JSON, int payload_pos);
	std::string get_username();
	std::string get_token();
};

class RegisterMsg : public ClientMsg { // 注册消息
private:
	std::string username_; // 用户名
	std::string password_; // 密码
	std::string email_;	   // 邮箱地址

public:
	RegisterMsg(std::string username, std::string password, std::string email);
	static RegisterMsg* parse_from_JSON(std::string JSON, int payload_pos);
	std::string get_username();
	std::string get_password();
	std::string get_email();
};

class LogoutMsg : public ClientMsg { // 退出登录消息
private:
	int user_id_; // 用户 id

public:
	LogoutMsg(int user_id);
	static LogoutMsg* parse_from_JSON(std::string JSON, int payload_pos);
	int get_user_id();
};

class UpdateProfileMsg : public ClientMsg { // 更新用户信息消息
private:
	int user_id_; // 用户 id
	std::string username_; // 用户名
	std::string password_; // 密码
	std::string email_;	   // 邮箱地址
	std::string avatar_;   // 头像文件地址

public:
	UpdateProfileMsg(int user_id, std::string username, std::string password, std::string email,
						 std::string avatar);
	static UpdateProfileMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class LoadContactsMsg : public ClientMsg { // 加载联系人列表消息
private:
	int user_id_; // 用户 id

public:
	LoadContactsMsg(int user_id);
	static LoadContactsMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class SearchForUserByIdMsg : public ClientMsg { // 根据 id 搜索用户
private:
	int user_id_;				// 目标用户 id
public:
	SearchForUserByIdMsg(int user_id);
	static SearchForUserByIdMsg* parse_from_JSON(std::string JSON, int payload_pos);
	int get_user_id();
};

class SearchForUserByNameMsg : public ClientMsg { // 根据用户名搜索用户
private:
	std::string username_;
public:
	SearchForUserByNameMsg(std::string username);
	static SearchForUserByNameMsg* parse_from_JSON(std::string JSON, int payload_pos);
	std::string get_username();
};

class AddContactMsg : public ClientMsg { // 添加联系人消息
private:
	int user_id_;				// 用户 id
	int target_id_;				// 联系人 id

public:
	AddContactMsg(int user_id, int target_id);
	static AddContactMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class DeleteContactMsg : public ClientMsg { // 删除联系人消息
private:
	int user_id_;		// 用户 id
	int target_id_;		// 目标联系人 id

public:
	DeleteContactMsg(int requester_user_id, int target_uesr_id);
	static DeleteContactMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class SendMessageMsg : public ClientMsg { // 发送聊天消息消息
private:
	int message_id_;		    // 消息 id
	int sender_id_;				// 发送者用户 id
	int receiver_id_;			// 接收者用户 id
	std::string content_;		// 消息内容

public:
	SendMessageMsg(int message_id, int sender_id, int receiver_id, std::string content);
	static SendMessageMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class SendFileMsg : public ClientMsg { // 发送文件消息
private:
	int message_id_;			// 消息 id
	int sender_id_;				// 发送者 id
	int receiver_id_;			// 接收者 id
	std::string file_name_;		// 文件名
	std::string file_content_;  // 文件内容

public:
	SendFileMsg(int message_id, int sender_id, int recever_id, std::string file_name,
				std::string file_content);
	static SendFileMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class SendImageMsg : public ClientMsg { // 发送图片消息
private:
	int message_id_;			// 消息 id
	int sender_id_;				// 发送者 id
	int receiver_id_;			// 接收者 id
	std::string image_name_;	// 图片文件名
	std::string image_content_; // 图片内容

public:
	SendImageMsg(int message_id, int sender_id, int receiver_id, std::string image_name,
				 std::string image_content);
	static SendImageMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class LoadMessagesMsg : public ClientMsg { // 加载聊天记录消息
private:
	int user_id_;		// 用户 id
	int target_id_;		// 目标联系人 id

public:
	LoadMessagesMsg(int user_id, int target_id);
	static LoadMessagesMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class MarkReadMsg : public ClientMsg { // 标记为已读消息
private:
	int user_id_;				// 用户 id
	int target_id_;				// 目标联系人 id

public:
	MarkReadMsg(int user_id, int target_id);
	static MarkReadMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class ClearMessagesMsg : public ClientMsg { // 清空聊天记录
private:
	int requester_user_id_;		// 用户 id
	int target_user_id_;		// 目标用户 id

public:
	ClearMessagesMsg(int requester_user_id, int target_user_id);
	static ClearMessagesMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class LoginSuccessMsg : public ServerMsg { // 登录成功消息
private:
	int user_id_; // 用户 id
	std::string username_; // 用户名
	std::string email_;    // 邮箱地址
	std::string avatar_;   // 头像文件地址
	std::string token_;	   // 令牌

public:
	LoginSuccessMsg(int user_id, std::string username, std::string email, std::string avatar,
						std::string token);
	std::string to_JSON() override;
};

class LoginFailureMsg : public ServerMsg { // 登录失败消息
private:
	std::string error_; // 错误信息

public:
	LoginFailureMsg(std::string error);
	std::string to_JSON() override;
};

class LogoutSuccessMsg : public ServerMsg { // 成功退出登录消息
public:
	std::string to_JSON() override;
};

class RegisterSuccessMsg : public ServerMsg { // 注册成功消息
private:
	int user_id_; // 用户 id
	std::string username_; // 用户名
	std::string email_;	   // 邮箱地址
	std::string avatar_;   // 头像文件地址
	std::string token_;	   // 令牌

public:
	RegisterSuccessMsg(int user_id, std::string username, std::string email, std::string avatar,
						   std::string token);
	std::string to_JSON() override;
};

class RegisterFailureMsg : public ServerMsg { // 注册失败消息
private:
	std::string error_; // 错误信息
	
public:
	RegisterFailureMsg(std::string error);
	std::string to_JSON() override;
};

class ProfileUpdatedSuccessMsg : public ServerMsg { // 用户信息已更新消息
private:
	int user_id_; // 用户 id
	std::string username_; // 用户名
	std::string password_; // 密码
	std::string email_;	   // 邮箱地址
	std::string avatar_;   // 头像文件地址

public:
	ProfileUpdatedSuccessMsg(int user_id, std::string username, std::string password,
							 std::string email, std::string avatar);
	std::string to_JSON() override;
};

class ProfileUpdatedFailedMsg : public ServerMsg { // 更新用户信息失败
private:
	std::string error_;

public:
	ProfileUpdatedFailedMsg(std::string error);
	std::string to_JSON() override;
};

class ContactsLoadedMsg : public ServerMsg { // 已加载联系人消息
private:
	std::vector<CloudChatUser> contacts_; // 联系人列表

public:
	ContactsLoadedMsg(std::vector<CloudChatUser> contacts);
	std::string to_JSON() override;
};

class ContactsLoadedFailedMsg : public ServerMsg { // 加载联系人列表失败
private:
	std::string error_;

public:
	ContactsLoadedFailedMsg(std::string error);
	std::string to_JSON() override;
};

class SearchForUserResultMsg : public ServerMsg { // 搜索联系人结果
private:
	std::vector<CloudChatUser> users_;
public:
	SearchForUserResultMsg(std::vector<CloudChatUser> users);
	std::string to_JSON() override;
};

class ContactAddedMsg : public ServerMsg { // 联系人已添加消息
private:
	int contact_id_;			// 联系人用户 id
	std::string username_; 		// 联系人用户名
	std::string avatar_;		// 联系人头像文件地址
	bool        online_;		// 联系人在线状态
public:
	ContactAddedMsg(int contact_id, std::string username, std::string avatar, bool online);
	std::string to_JSON() override;
};

class ContactAddedFailedMsg : public ServerMsg { // 添加联系人失败
private:
	std::string error_;

public:
	ContactAddedFailedMsg(std::string error);
	std::string to_JSON() override;
};

class ContactDeletedMsg : public ServerMsg { // 联系人已删除消息
public:
	std::string to_JSON() override;
};

class ContactDeletedFailedMsg : public ServerMsg { // 联系人删除失败
private:
	std::string error_;

public:
	ContactDeletedFailedMsg(std::string error);
	std::string to_JSON() override;
};

class SelfMessageReceivedMsg : public ServerMsg { // 聊天消息被接收
private:
	int message_id_;

public:
	SelfMessageReceivedMsg(int message_id);
	std::string to_JSON() override;
};

class ToSelfMessageReceivedMsg : public ServerMsg { // 收到新聊天消息
private:
	CloudChatMessage message_;	// 收到的新消息

public:
	ToSelfMessageReceivedMsg(CloudChatMessage message);
	std::string to_JSON() override;
};

class MessagesLoadedMsg : public ServerMsg { // 已加载聊天记录
private:
	int target_id_;				// 目标联系人
	std::vector<CloudChatMessage> messages_; // 加载的聊天记录

public:
	MessagesLoadedMsg(int target_id, std::vector<CloudChatMessage> messages);
	std::string to_JSON() override;
};

class MessagesClearedMsg : public ServerMsg { // 已清空聊天记录
private:
	int user_id_;				// 用户 id
	int target_id_;				// 目标联系人 id

public:
	MessagesClearedMsg(int user_id, int target_id);
	std::string to_JSON() override;
};

class LoadFriendRequestMsg : public ClientMsg { // 加载好友请求列表
private:
	int userId_;				// 请求加载好友请求列表的用户 id

public:
	LoadFriendRequestMsg(int userId);
	static LoadFriendRequestMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class AddFriendRequestClientMsg : public ClientMsg { // 添加好友请求
private:
	FriendRequest friend_request_;

public:
	AddFriendRequestClientMsg(FriendRequest friend_request);
	static AddFriendRequestClientMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class AddFriendRequestServerMsg : public ServerMsg { // 添加好友请求
private:
	FriendRequest friend_request_;

public:
	AddFriendRequestServerMsg(FriendRequest friend_request);
	std::string to_JSON() override;
};

class RefuseFriendRequestClientMsg : public ClientMsg { // 拒绝好友请求
private:
	int id_;					// 被拒绝的好友请求 id

public:
	RefuseFriendRequestClientMsg(int id);
	static RefuseFriendRequestClientMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class RefuseFriendRequestServerMsg : public ServerMsg { // 拒绝好友请求
private:
	int id_;					// 被拒绝的好友请求 id

public:
	RefuseFriendRequestServerMsg(int id);
	std::string to_JSON() override;
};

class AcceptFriendRequestClientMsg : public ClientMsg { // 通过好友请求
private:
	int id_;					// 被通过的好友请求 id

public:
	AcceptFriendRequestClientMsg(int id);
	static AcceptFriendRequestClientMsg* parse_from_JSON(std::string JSON, int payload_pos);
};

class AcceptFriendRequestServerMsg : public ServerMsg { // 通过好友请求
private:
	int id_;					// 被通过的好友请求 id
	
public:
	AcceptFriendRequestServerMsg(int id);
	std::string to_JSON() override;
};

class FriendRequestLoadedMsg : public ServerMsg { // 已加载好友请求列表
private:
	std::vector<FriendRequest> requestList_; // 好友请求列表

public:
	FriendRequestLoadedMsg(std::vector<FriendRequest> requestList);
	std::string to_JSON() override;
};

class FriendRequestAddedMsg : public ServerMsg { // 已添加好友请求
private:
	FriendRequest friend_request_; // 添加的好友请求

public:
	FriendRequestAddedMsg(FriendRequest friend_request);
	std::string to_JSON() override;
};

class FriendRequestAddedFailedMsg : public ServerMsg { // 好友请求添加失败
private:
	std::string error_;			// 错误信息

public:
	FriendRequestAddedFailedMsg(std::string error);
	std::string to_JSON() override;
};

class FriendRequestRefusedMsg : public ServerMsg { // 已拒绝好友请求
private:
	int id_;					// 好友请求 id

public:
	FriendRequestRefusedMsg(int id);
	std::string to_JSON() override;
};

class FriendRequestRefusedFailedMsg : public ServerMsg { // 好友请求拒绝失败
private:
	std::string error_;			// 错误信息

public:
	FriendRequestRefusedFailedMsg(std::string error);
	std::string to_JSON() override;
};

class FriendRequestAcceptedMsg : public ServerMsg { // 已通过好友请求
private:
	int id_;					// 好友请求 id

public:
	FriendRequestAcceptedMsg(int id);
	std::string to_JSON() override;
};

class FriendRequestAcceptedFailedMsg : public ServerMsg { // 好友请求通过失败
private:
	std::string error_;			// 错误信息

public:
	FriendRequestAcceptedFailedMsg(std::string error);
	std::string to_JSON() override;
};

class FriendRequestLoadedFailedMsg : public ServerMsg { // 加载好友请求列表失败
private:
	std::string error_;			// 错误信息

public:
	FriendRequestLoadedFailedMsg(std::string error);
	std::string to_JSON() override;
};

ClientMsg* parse_protocal_msg(std::string JSON); // 将 JSON 字符串解析为 ClientMsg 对象
int parse_int_from_json(std::string JSON, int begin, int end); // 从 JSON 字符串中解析出 int 整数
// 从 JSON 字符串中解析出转义后的字符串
std::string parse_str_from_json(std::string JSON, int begin, int end);
std::string to_JSON_string(std::string str); // 转为 JSON 字符串（添加转义字符）
std::string c_str_to_JSON_string(const char* c_str);
// 向客户端发送消息
int SendMsgToClient(server_t& cloudchat_srv, websocketpp::connection_hdl hdl, ServerMsg* srv_msg);
int find_field_pos(std::string JSON, std::string target); // 在 JSON 中找出字段位置

#endif // CLOUDCHATMSG_H
