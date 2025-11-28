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

public:
	CloudChatUser(int id, std::string username, std::string password, std::string avatar,
				  std::string token);
	// getter
	int GetId();
	std::string GetUserName();
	std::string GetPassword();
	std::string GetAvatar();
	std::string GetToken();
	// setter
	void SetId(int id);
	void SetUserName(std::string username);
	void SetPassword(std::string password);
	void SetAvatar(std::string avatar);
	void SetToken(std::string token);
};

#endif // CLOUDCHATUSER_H
