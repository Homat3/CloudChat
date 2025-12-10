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

FriendRequest::FriendRequest(int id, int requesterId, int targetId, std::string requesterUsername,
							 std::string targetUsername, std::string requesterAvatar,
							 std::string targetAvatar, std::string status) {
	id_ = id;
	requesterId_ = requesterId;
	targetId_    = targetId;
	requesterUsername_ = requesterUsername;
	targetUsername_    = targetUsername;
	requesterAvatar_   = requesterAvatar;
	targetAvatar_      = targetAvatar;
	status_            = status;
}

int FriendRequest::get_requester_id() {
	return requesterId_;
}

int FriendRequest::get_target_id() {
	return targetId_;
}

std::string FriendRequest::get_requester_username() {
	return requesterUsername_;
}

std::string FriendRequest::get_target_username() {
	return targetUsername_;
}

std::string FriendRequest::get_requester_avatar() {
	return requesterAvatar_;
}

std::string FriendRequest::get_target_avatar() {
	return targetAvatar_;
}

std::string FriendRequest::get_status() {
	return status_;
}

void FriendRequest::SetRequesterId(int requesterId) {
	requesterId_ = requesterId;
}

void FriendRequest::SetTargetId(int targetId) {
	targetId_ = targetId;
}

void FriendRequest::SetRequesterUsername(std::string requesterUsername) {
	requesterUsername_ = requesterUsername;
}

void FriendRequest::SetTargetUsername(std::string targetUsername) {
	targetUsername_ = targetUsername;
}

void FriendRequest::SetRequesterAvatar(std::string requesterAvatar) {
	requesterAvatar_ = requesterAvatar;
}

void FriendRequest::SetTargetAvatar(std::string targetAvatar) {
	targetAvatar_ = targetAvatar;
}

void FriendRequest::SetStatus(std::string status) {
	status_ = status;
}

int FriendRequest::get_id() {
	return id_;
}

void FriendRequest::SetId(int id) {
	id_ = id;
}

FriendRequest::FriendRequest() {
	
}
