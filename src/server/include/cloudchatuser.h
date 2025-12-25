/** cloudchatuser.h
 * CloudChat 用户头文件
 */

#ifndef CLOUDCHATUSER_H
#define CLOUDCHATUSER_H

#include "cloudchatsys.h"

#define FRIEND_REQUEST_STATUS_PENDING "pending" // 好友请求等待验证
#define FRIEND_REQUEST_STATUS_ACCEPTED "accepted" // 好友请求被通过
#define FRIEND_REQUEST_STATUS_REFUSED  "refused"  // 好友请求被拒绝

class CloudChatUser {
private:
	int id_;
	std::string username_;
	std::string password_;
	std::string avatar_;
	std::string token_;
	std::string email_;
	bool        is_online_;

public:
	CloudChatUser(int id, std::string username, std::string password, std::string avatar,
				  std::string token, std::string email, bool is_online);
	// getter
	int get_id();
	std::string get_username();
	std::string get_password();
	std::string get_avatar();
	std::string get_token();
	std::string get_email();
	bool        is_online();
	// setter
	void SetId(int id);
	void SetUserName(std::string username);
	void SetPassword(std::string password);
	void SetAvatar(std::string avatar);
	void SetToken(std::string token);
	void SetEmail(std::string email);
	void SetOnline(bool is_online);
};

class FriendRequest { // 好友请求
private:
	int id_;
	int requesterId_;
	int targetId_;
	std::string requesterUsername_;
	std::string targetUsername_;
	std::string requesterAvatar_;
	std::string targetAvatar_;
	std::string status_;

public:
	FriendRequest();
	FriendRequest(int id, int requesterId, int targetId, std::string requesterUsername,
				  std::string targetUsername, std::string requesterAvatar,
				  std::string targetAvatar, std::string status);
	// getter
	int get_id();
	int get_requester_id();
	int get_target_id();
	std::string get_requester_username();
	std::string get_target_username();
	std::string get_requester_avatar();
	std::string get_target_avatar();
	std::string get_status();
	// setter
	void SetId(int id);
	void SetRequesterId(int requesterId);
	void SetTargetId(int targetId);
	void SetRequesterUsername(std::string requesterUsername);
	void SetTargetUsername(std::string targetUsername);
	void SetRequesterAvatar(std::string requesterAvatar);
	void SetTargetAvatar(std::string targetAvatar);
	void SetStatus(std::string status);
};

std::string generate_token();	// 生成令牌

#endif // CLOUDCHATUSER_H
