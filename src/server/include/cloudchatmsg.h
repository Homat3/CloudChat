/** cloudchatmsg.h
 * CloudChat 消息头文件
 */

#ifndef CLOUDCHATMSG_H
#define CLOUDCHATMSG_H

#include "cloudchatsys.h"
#include <string>
#include <vector>

// 聊天消息类型宏
#define TEXT_MESSAGE  "text"	// 文本消息
#define IMAGE_MESSAGE "image"	// 图片
#define FILE_MESSAGE  "file"	// 文件

// 通信消息类型宏
#define ILLEGAL_MSG "ILLEGAL_MSG"						  // 无效消息
// 客户端消息
#define LOGIN "LOGIN"			// 账密登录
#define LOGIN_BY_TOKEN "LOGIN_BY_TOKEN" // 令牌登录
#define REGISTER       "REGISTER"		// 注册
#define UPDATE_PROFILE "UPDATE_PROFILE" // 更新个人信息
#define LOGOUT         "LOGOUT"			// 退出登录
#define LOAD_CONTACTS  "LOAD_CONTACTS"	// 加载联系人列表
#define ADD_CONTACT    "ADD_CONTACT"	// 添加联系人
#define DELETE_CONTACT "DELETE_CONTACT" // 删除联系人
#define LOAD_MESSAGES  "LOAD_MESSAGES"	// 加载聊天记录
#define SEND_MESSAGE   "SEND_MESSAGE"	// 发送聊天消息
#define SEND_FILE      "SEND_FILE"		// 发送文件
#define SEND_IMAGE     "SEND_IMAGE"		// 发送图片
#define MARK_READ      "MARK_READ"		// 标记为已读
#define CLEAR_MESSAGES "CLEAR_MESSAGES" // 清空聊天记录
// 服务端消息
#define LOGIN_SUCCESS  "LOGIN_SUCCESS" // 登录成功
#define LOGIN_FAILURE  "LOGIN_FAILURE" // 登录失败
#define REGISTER_SUCCESS "REGISTER_SUCCESS" // 注册成功
#define REGISTER_FAILURE "REGISTER_FAILURE" // 注册失败
#define PROFILE_UPDATED_SUCCESS "PROFILE_UPDATED_SUCCESS" // 成功更新个人信息
#define PROFILE_UPDATED_FAILED  "PROFILE_UPDATED_FAILED"  // 更新个人信息失败
#define LOGOUT_SUCCESS          "LOGOUT_SUCCESS"		  // 退出登录成功
#define CONTACTS_LOADED         "CONTACTS_LOADED"		  // 已加载联系人列表
#define CONTACTS_LOADED_FAILED  "CONTACTS_LOADED_FAILED"  // 加载联系人列表失败
#define CONTACT_ADDED           "CONTACT_ADDED"			  // 已添加联系人
#define CONTACT_ADDED_FAILED    "CONTACT_ADDED_FAILED"	  // 添加联系人失败
#define CONTACT_DELETED         "CONTACT_DELETED"		  // 已删除联系人
#define CONTACT_DELETED_FAILED  "CONTACT_DELETED_FAILED"  // 删除联系人失败
#define MESSAGES_LOADED         "MESSAGES_LOADED"		  // 已加载聊天记录
#define MESSAGE_RECEIVED_SELF   "MESSAGE_RECEIVED_SELF"	  // 客户端发送的聊天消息已被服务器接收
#define MESSAGE_RECEIVED_OTHER  "MESSAGE_RECEIVED_OTHER"  // 有其他用户向客户端发送聊天消息（新消息提醒）
#define MESSAGES_CLEARD         "MESSAGES_CLEARD"		  // 已清空聊天记录

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
};

// 客户端和服务端之间通信的消息类
class ProtocalMsg { // 通信消息基类
protected:
	std::string type_; // 取值自通信消息类型宏

public:
	ProtocalMsg(std::string type);
};

class LoginMsg : public ProtocalMsg { // 账密登录消息
private:
	std::string username_; // 用户名
	std::string password_; // 密码

public:
	LoginMsg(std::string username, std::string password);
	static LoginMsg parse_from_JSON(std::string JSON, int payload_pos);
};

class LoginByTokenMsg : public ProtocalMsg { // 令牌登录消息
private:
	std::string username_;		// 用户名
	std::string token_;			// 令牌

public:
	LoginByTokenMsg(std::string username, std::string token);
	static LoginByTokenMsg parse_from_JSON(std::string JSON, int payload_pos);
};

class RegisterMsg : public ProtocalMsg { // 注册消息
private:
	std::string username_; // 用户名
	std::string password_; // 密码
	std::string email_;	   // 邮箱地址

public:
	RegisterMsg(std::string username, std::string password, std::string email);
	static RegisterMsg parse_from_JSON(std::string JSON, int payload_pos);
};

class LogoutMsg : public ProtocalMsg { // 退出登录消息
private:
	int user_id_; // 用户 id

public:
	LogoutMsg(int user_id);
};

class UpdateProfileMsg : public ProtocalMsg { // 更新用户信息消息
private:
	int user_id_; // 用户 id
	std::string username_; // 用户名
	std::string password_; // 密码
	std::string email_;	   // 邮箱地址
	std::string avatar_;   // 头像文件地址

public:
	UpdateProfileMsg(int user_id, std::string username, std::string password, std::string email,
						 std::string avatar);
};

class LoadContactsMsg : public ProtocalMsg { // 加载联系人列表消息
private:
	int user_id_; // 用户 id

public:
	LoadContactsMsg(int user_id);
};

class AddContactMsg : public ProtocalMsg { // 添加联系人消息
private:
	int user_id_;				// 用户 id
	int target_id_;				// 联系人 id

public:
	AddContactMsg(int user_id, int target_id);
};

class DeleteContactMsg : public ProtocalMsg { // 删除联系人消息
private:
	int user_id_;		// 用户 id
	int target_id_;		// 目标联系人 id

public:
	DeleteContactMsg(int requester_user_id, int target_uesr_id);
};

class SendMessageMsg : public ProtocalMsg { // 发送聊天消息消息
private:
	int message_id_;		    // 消息 id
	int sender_id_;				// 发送者用户 id
	int receiver_id_;			// 接收者用户 id
	std::string content_;		// 消息内容

public:
	SendMessageMsg(int message_id, int sender_id, int receiver_id, std::string content);
};

class SendFileMsg : public ProtocalMsg { // 发送文件消息
private:
	int message_id_;			// 消息 id
	int sender_id_;				// 发送者 id
	int receiver_id_;			// 接收者 id
	std::string file_name_;		// 文件名
	std::vector<std::string> file_content_; // 文件内容

public:
	SendFileMsg(int message_id, int sender_id, int recever_id, std::string file_name,
				std::vector<std::string> file_content);
};

class SendImageMsg : public ProtocalMsg { // 发送图片消息
private:
	int message_id_;			// 消息 id
	int sender_id_;				// 发送者 id
	int receiver_id_;			// 接收者 id
	std::string image_name_;	// 图片文件名
	std::vector<std::string> image_content_; // 图片内容

public:
	SendImageMsg(int message_id, int sender_id, int receiver_id, std::string image_name,
				 std::vector<std::string> image_content);
};

class LoadMessagesMsg : public ProtocalMsg { // 加载聊天记录消息
private:
	int user_id_;		// 用户 id
	int target_id_;		// 目标联系人 id

public:
	LoadMessagesMsg(int user_id, int target_id);
};

class MarkReadMsg : public ProtocalMsg { // 标记为已读消息
private:
	int user_id_;				// 用户 id
	int target_id_;				// 目标联系人 id

public:
	MarkReadMsg(int user_id, int target_id);
};

class ClearMessagesMsg : public ProtocalMsg { // 清空聊天记录
private:
	int requester_user_id_;		// 用户 id
	int target_user_id_;		// 目标用户 id

public:
	ClearMessagesMsg(int requester_user_id, int target_user_id);
};

class LoginSuccessMsg : public ProtocalMsg { // 登录成功消息
private:
	int user_id_; // 用户 id
	std::string username_; // 用户名
	std::string email_;    // 邮箱地址
	std::string avatar_;   // 头像文件地址
	std::string token_;	   // 令牌

public:
	LoginSuccessMsg(int user_id, std::string username, std::string email, std::string avatar,
						std::string token);
	std::string ToJSON();
};

class LoginFailureMsg : public ProtocalMsg { // 登录失败消息
private:
	std::string error_; // 错误信息

public:
	LoginFailureMsg(std::string error);
	std::string ToJSON();
};

class LogoutSuccessMsg : public ProtocalMsg { // 成功退出登录消息
public:
	std::string ToJSON();
};

class RegisterSuccessMsg : public ProtocalMsg { // 注册成功消息
private:
	int user_id_; // 用户 id
	std::string username_; // 用户名
	std::string email_;	   // 邮箱地址
	std::string avatar_;   // 头像文件地址
	std::string token_;	   // 令牌

public:
	RegisterSuccessMsg(int user_id, std::string username, std::string email, std::string avatar,
						   std::string token);
	std::string ToJSON();
};

class RegisterFailureMsg : public ProtocalMsg { // 注册失败消息
private:
	std::string error_; // 错误信息
	
public:
	RegisterFailureMsg(std::string error);
	std::string ToJSON();
};

class ProfileUpdatedSuccessMsg : public ProtocalMsg { // 用户信息已更新消息
private:
	int user_id_; // 用户 id
	std::string username_; // 用户名
	std::string password_; // 密码
	std::string email_;	   // 邮箱地址
	std::string avatar_;   // 头像文件地址

public:
	ProfileUpdatedSuccessMsg(int user_id, std::string username, std::string password,
							 std::string email, std::string avatar);
	std::string ToJSON();
};

class ProfileUpdatedFailedMsg : public ProtocalMsg { // 更新用户信息失败
private:
	std::string error_;

public:
	ProfileUpdatedFailedMsg(std::string error);
	std::string ToJSON();
};

class ContactsLoadedMsg : public ProtocalMsg { // 已加载联系人消息
private:
	struct Contact { // 联系人结构体
		int contact_id; // 联系人用户 id
		std::string username; // 联系人用户名
		std::string avatar;	  // 联系人头像文件地址
		bool        online;	  // 联系人在线状态
	};
	std::vector<Contact> contacts_; // 联系人列表

public:
	ContactsLoadedMsg(std::vector<Contact> contacts);
	std::string ToJSON();
};

class ContactsLoadedFailedMsg : public ProtocalMsg { // 加载联系人列表失败
private:
	std::string error_;

public:
	ContactsLoadedFailedMsg(std::string error);
	std::string ToJSON();
};

class ContactAddedMsg : public ProtocalMsg { // 联系人已添加消息
private:
	int contact_id_;			// 联系人用户 id
	std::string username_; 		// 联系人用户名
	std::string avatar_;		// 联系人头像文件地址
	bool        online_;		// 联系人在线状态
public:
	ContactAddedMsg(int contact_id, std::string username, std::string avatar, bool online);
	std::string ToJSON();
};

class ContactAddedFailedMsg : public ProtocalMsg { // 添加联系人失败
private:
	std::string error_;

public:
	ContactAddedFailedMsg(std::string error);
	std::string ToJSON();
};

class ContactDeletedMsg : public ProtocalMsg { // 联系人已删除消息
public:
	std::string ToJSON();
};

class ContactDeletedFailedMsg : public ProtocalMsg { // 联系人删除失败
private:
	std::string error_;

public:
	ContactDeletedFailedMsg(std::string error);
	std::string ToJSON();
};

class SelfMessageReceivedMsg : public ProtocalMsg { // 聊天消息被接收
private:
	int message_id_;

public:
	SelfMessageReceivedMsg(int message_id);
	std::string ToJSON();
};

class ToSelfMessageReceivedMsg : public ProtocalMsg { // 收到新聊天消息
private:
	CloudChatMessage message_;	// 收到的新消息

public:
	ToSelfMessageReceivedMsg(CloudChatMessage message);
	std::string ToJSON();
};

class MessagesLoadedMsg : public ProtocalMsg { // 已加载聊天记录
private:
	int target_id_;				// 目标联系人
	std::vector<CloudChatMessage> messages_; // 加载的聊天记录

public:
	MessagesLoadedMsg(int target_id, std::vector<CloudChatMessage> messages);
	std::string ToJSON();
};

class MessagesClearedMsg : public ProtocalMsg { // 已清空聊天记录
private:
	int user_id_;				// 用户 id
	int target_id_;				// 目标联系人 id

public:
	MessagesClearedMsg(int user_id, int target_id);
	std::string ToJSON();
};

ProtocalMsg parse_protocal_msg(std::string JSON); // 将 JSON 字符串解析为 ProtocalMsg 对象

#endif // CLOUDCHATMSG_H
