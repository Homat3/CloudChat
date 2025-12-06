/** cloudchatuser.h
 * CloudChat 用户头文件
 */

#ifndef CLOUDCHATUSER_H
#define CLOUDCHATUSER_H

#include "cloudchatsys.h"

class CloudChatUser {
private:
	int id_;
	std::string username_;
	std::string password_;
	std::string avatar_;
	std::string token_;
	std::string email_;

public:
	CloudChatUser(int id, std::string username, std::string password, std::string avatar,
				  std::string token, std::string email);
	// getter
	int get_id();
	std::string get_user_name();
	std::string get_password();
	std::string get_avatar();
	std::string get_token();
	std::string get_email();
	// setter
	void SetId(int id);
	void SetUserName(std::string username);
	void SetPassword(std::string password);
	void SetAvatar(std::string avatar);
	void SetToken(std::string token);
	void SetEmail(std::string email);
};

std::string generate_token();	// 生成令牌

#endif // CLOUDCHATUSER_H
