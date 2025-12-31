/** cloudchat.h
 * CloudChat 数据库相关头文件
*/

#ifndef CLOUDCHATDAT_H
#define CLOUDCHATDAT_H

#include "cloudchatmsg.h"
#include "cloudchatuser.h"

extern std::string g_database_username;
extern std::string g_database_password;
extern std::string g_database_host;

#define DATABASE_USERNAME g_database_username // 数据库用户名
#define DATABASE_PASSWORD g_database_password // 数据库密码
#define DATABASE_HOST     g_database_host	  // 数据库主机地址

#define DATABASE_INITIALIZED 0                   // 数据库已初始化
#define DATABASE_INITIALIZATION_FAILED -1        // 数据库初始化失败

class CloudChatDatabase { // CloudChat 数据库类
private:
	sql::mysql::MySQL_Driver* driver_; // 驱动对象指针
	sql::Connection*          connection_; // MySQL 连接对象指针
	std::thread               th_pump_;    // 心跳线程，定时执行数据库操作，防止断连

	CloudChatDatabase(); // 构造函数建立与 mysql 的连接，初始化数据库，创建数据表
	~CloudChatDatabase();
	void Pump();		 // 心跳函数，在心跳线程中执行

public:
	static CloudChatDatabase* GetInstance(); // 获取单例模式实例
	// 数据库操作接口
	// users
	bool AddUser(CloudChatUser& user);									// 添加用户
	CloudChatUser* GetUserById(int id);									// 通过 ID 获取用户
	bool UpdateUser(CloudChatUser* user);								// 更新用户数据表
	CloudChatUser* GetUserByName(std::string name);						// 通过用户名获取用户
	bool DeleteUser(int id);											// 删除用户
	std::vector<CloudChatUser> SearchUsersByName(std::string username); // 通过用户名搜索相关用户
	CloudChatUser* GetUserByEmail(std::string email);					// 通过邮箱地址获取用户
	// friend_requests
	bool AddFriendRequest(FriendRequest friend_request);			   // 添加好友请求
	std::vector<FriendRequest> GetFriendRequestsByUserId(int user_id); // 根据用户 ID 获取好友请求列表
	FriendRequest*             GetFriendRequestById(int id);		   // 根据好友请求 ID 获取好友请求
	bool                       UpdateFriendRequest(FriendRequest* friend_request); // 更新好友请求列表
	// 根据请求者和被请求者用户 ID 获取好友请求
	FriendRequest*             GetFriendRequestByTwoIds(int requester_id, int target_id);
	// friends
	bool AddFriend(int user_id1, int user_id2);			  // 添加好友关系
	std::vector<CloudChatUser> get_contacts(int user_id); // 根据用户 ID 获取联系人列表
	bool is_friend(int user_id1, int user_id2);			  // 判断两个用户是否是好友
	// messages
	bool AddMessage(CloudChatMessage* message);	// 添加聊天消息
	// 根据发送者和接收者用户 ID 获取聊天消息列表
	std::vector<CloudChatMessage> GetMessagesByTwoIds(int user_id, int target_id);
	bool UpdateMessage(CloudChatMessage* message); // 更新聊天消息
};

#endif // CLOUDCHATDAT_H
