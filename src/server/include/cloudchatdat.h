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
	// TODO: 编写数据库操作接口
	// users
	bool AddUser(CloudChatUser& user);//addUser
	CloudChatUser* GetUserById(int id);//
	bool           UpdateUser(CloudChatUser* user);//
	CloudChatUser* GetUserByName(std::string name);
	bool           DeleteUser(int id);
	std::vector<CloudChatUser> SearchUsersByName(std::string username);
	// friend_requests
	bool AddFriendRequest(FriendRequest friend_request);
	std::vector<FriendRequest> GetFriendRequestsByUserId(int user_id);
	FriendRequest*             GetFriendRequestById(int id);
	bool                       UpdateFriendRequest(FriendRequest* friend_request);
	FriendRequest*             GetFriendRequestByTwoIds(int requester_id, int target_id);
	// friends
	bool AddFriend(int user_id1, int user_id2);
	std::vector<CloudChatUser> get_contacts(int user_id);
	bool is_friend(int user_id1, int user_id2);
	// messages
	bool AddMessage(CloudChatMessage* message);
	std::vector<CloudChatMessage> GetMessagesByTwoIds(int user_id, int target_id);
	bool UpdateMessage(CloudChatMessage* message);
};

#endif // CLOUDCHATDAT_H
