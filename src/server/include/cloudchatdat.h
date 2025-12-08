/** cloudchat.h
 * CloudChat 数据库相关头文件
*/

#ifndef CLOUDCHATDAT_H
#define CLOUDCHATDAT_H

#define DATABASE_USERNAME "cloudchat" // 数据库用户名
#define DATABASE_PASSWORD "1919810" // 数据库密码
#define DATABASE_HOST     "tcp://127.0.0.1:3306" // 数据库主机地址

#define DATABASE_INITIALIZED 0                   // 数据库已初始化
#define DATABASE_INITIALIZATION_FAILED -1        // 数据库初始化失败

#include "cloudchatsys.h"
#include "cloudchatuser.h"

class CloudChatDatabase { // CloudChat 数据库类
private:
	sql::mysql::MySQL_Driver* driver_; // 驱动对象指针
	sql::Connection*          connection_; // MySQL 连接对象指针

	// 构造函数建立与 mysql 的连接，初始化数据库，创建数据表
	CloudChatDatabase();

public:
	static CloudChatDatabase* GetInstance(); // 获取单例模式实例
	// TODO: 编写数据库操作接口

	bool AddUser(CloudChatUser& user);//addUser
	CloudChatUser* GetUserById(int id);//
	bool UpdateUser(CloudChatUser* user);//
	CloudChatUser* GetUserByName(std::string name);
	bool DeleteUser(int id);
};

#endif // CLOUDCHATDAT_H
