#include "cloudchatuser.h"

int CloudChatUser::GetId() {
	return id_;
}

std::string CloudChatUser::GetUserName() {
	return username_;
}

std::string CloudChatUser::GetPassword() {
	return password_;
}

std::string CloudChatUser::GetAvatar() {
	return avatar_;
}

std::string CloudChatUser::GetToken() {
	return token_;
}

void CloudChatUser::SetId(int id) {
	id_ = id;
}

void CloudChatUser::SetUserName(std::string username) {
	username_ = username;
}

void CloudChatUser::SetPassword(std::string password) {
	password_ = password;
}

void CloudChatUser::SetAvatar(std::string avatar) {
	avatar_ = avatar;
}

void CloudChatUser::SetToken(std::string token) {
	token_ = token;
}

CloudChatUser::CloudChatUser(int id, std::string username, std::string password, std::string avatar,
							 std::string token) {
	id_ = id;
	username_ = username;
	password_ = password;
	avatar_   = avatar;
	token_    = token;
}
