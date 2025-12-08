#include "cloudchatuser.h"

int CloudChatUser::get_id() {
	return id_;
}

std::string CloudChatUser::get_username() {
	return username_;
}

std::string CloudChatUser::get_password() {
	return password_;
}

std::string CloudChatUser::get_avatar() {
	return avatar_;
}

std::string CloudChatUser::get_token() {
	return token_;
}

bool CloudChatUser::is_online() {
	return is_online_;
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
							 std::string token, std::string email, bool is_online) {
	id_ = id;
	username_ = username;
	password_ = password;
	avatar_   = avatar;
	token_    = token;
	email_    = email;
	is_online_ = is_online;
}

std::string CloudChatUser::get_email() {
	return email_;
}

void CloudChatUser::SetEmail(std::string email) {
	email_ = email;
}

void CloudChatUser::SetOnline(bool is_online) {
	is_online_ = is_online;
}

std::string generate_token() {
	int len = 15 + rand() % 5;
	std::string token;
	for (int i = 0; i < len; i++) {
		token.push_back(33 + rand() % 94);
	}
	return token;
}
