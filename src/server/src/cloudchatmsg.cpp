#include "cloudchatmsg.h"
#include "cloudchatsys.h"

ProtocalMsg::ProtocalMsg(std::string type) {
	type_ = type;
}

LoginMsg::LoginMsg(std::string username, std::string password) : ProtocalMsg(LOGIN) {
	username_ = username;
	password = password_;
}

LoginByTokenMsg::LoginByTokenMsg(std::string username, std::string token) : ProtocalMsg(
	LOGIN_BY_TOKEN) {
	username_ = username;
	token_ = token;
}

LoginSuccessMsg::LoginSuccessMsg(int user_id, std::string username, std::string email,
										 std::string avatar, std::string token) : ProtocalMsg(
											 LOGIN_SUCCESS) {
	user_id_ = user_id;
	username_ = username;
	email_    = email;
	avatar_   = avatar;
	token_    = token;
}

LoginFailureMsg::LoginFailureMsg(std::string error) : ProtocalMsg(LOGIN_FAILURE) {
	error_ = error;
}

RegisterMsg::RegisterMsg(std::string username, std::string password, std::string email) :
	ProtocalMsg(REGISTER) {
	username_ = username;
	password_ = password;
	email_    = email;
}

RegisterSuccessMsg::RegisterSuccessMsg(int user_id, std::string username, std::string email,
											   std::string avatar, std::string token) :
	ProtocalMsg(REGISTER_SUCCESS) {
	user_id_ = user_id;
	username_ = username;
	email_ = email;
	avatar_ = avatar;
	token_ = token;
}

RegisterFailureMsg::RegisterFailureMsg(std::string error) : ProtocalMsg(
	REGISTER_FAILURE) {
	error_ = error;
}

UpdateProfileMsg::UpdateProfileMsg(int user_id, std::string username, std::string password,
										   std::string email, std::string avatar) : ProtocalMsg(
											   UPDATE_PROFILE
											   ) {
	user_id_ = user_id;
	username_ = username;
	password_ = password;
	email_    = email;
	avatar_   = avatar;
}

ProfileUpdatedSuccessMsg::ProfileUpdatedSuccessMsg(int user_id, std::string username, std::string password,
											 std::string email, std::string avatar) :
	ProtocalMsg(PROFILE_UPDATED_SUCCESS) {
	user_id_ = user_id;
	username_ = username;
	password_ = password;
	email_    = email;
	avatar_   = avatar;
}

LogoutMsg::LogoutMsg(int user_id) : ProtocalMsg(LOGOUT) {
	user_id_ = user_id;
}

LoadContactsMsg::LoadContactsMsg(int user_id) : ProtocalMsg(LOAD_CONTACTS) {
	user_id_ = user_id;
}

ContactsLoadedMsg::ContactsLoadedMsg(std::vector<Contact> contacts) : ProtocalMsg(
	CONTACTS_LOADED
	) {
	contacts_ = contacts;
}

AddContactMsg::AddContactMsg(int user_id, int target_id) : ProtocalMsg(ADD_CONTACT) {
	user_id_ = user_id;
	target_id_ = target_id;
}

ContactAddedMsg::ContactAddedMsg(int contact_id, std::string username, std::string avatar,
										 bool online) : ProtocalMsg(CONTACT_ADDED) {
	contact_id_ = contact_id;
	username_   = username;
	avatar_     = avatar;
	online_     = online;
}

DeleteContactMsg::DeleteContactMsg(int requester_user_id, int target_user_id) :
	ProtocalMsg(DELETE_CONTACT) {
	user_id_ = requester_user_id;
	target_id_    = target_user_id;
}

LoadMessagesMsg::LoadMessagesMsg(int user_id, int target_id) : ProtocalMsg(LOAD_MESSAGES) {
	user_id_ = user_id;
	target_id_ = target_id;
}

SendMessageMsg::SendMessageMsg(int message_id, int sender_id, int receiver_id,
									   std::string content) : ProtocalMsg(SEND_MESSAGE) {
	message_id_ = message_id;
	sender_id_  = sender_id;
	receiver_id_ = receiver_id;
	content_     = content;
}

SendFileMsg::SendFileMsg(int message_id, int sender_id, int receiver_id, std::string file_name,
						 std::vector<std::string> file_content) : ProtocalMsg(SEND_FILE) {
	message_id_ = message_id;
	sender_id_  = sender_id;
	receiver_id_ = receiver_id;
	file_name_   = file_name;
	file_content_ = file_content;
}

SendImageMsg::SendImageMsg(int message_id, int sender_id, int receiver_id, std::string image_name,
						   std::vector<std::string> image_content) : ProtocalMsg(SEND_IMAGE) {
	message_id_ = message_id;
	sender_id_  = sender_id;
	receiver_id_ = receiver_id;
	image_name_  = image_name;
	image_content_ = image_content;
}

MarkReadMsg::MarkReadMsg(int user_id, int target_id) : ProtocalMsg(MARK_READ) {
	user_id_ = user_id;
	target_id_ = target_id;
}

ClearMessagesMsg::ClearMessagesMsg(int requester_user_id, int target_user_id) : ProtocalMsg(
	CLEAR_MESSAGES) {
	requester_user_id_ = requester_user_id;
	target_user_id_    = target_user_id;
}

ProfileUpdatedFailedMsg::ProfileUpdatedFailedMsg(std::string error) : ProtocalMsg(
	PROFILE_UPDATED_FAILED
	) {
	error_ = error;
}

ContactsLoadedFailedMsg::ContactsLoadedFailedMsg(std::string error) : ProtocalMsg(
	CONTACTS_LOADED_FAILED
	) {
	error_ = error;
}

ContactAddedFailedMsg::ContactAddedFailedMsg(std::string error) : ProtocalMsg(
	CONTACT_ADDED_FAILED) {
	error_ = error;
}

ContactDeletedFailedMsg::ContactDeletedFailedMsg(std::string error) : ProtocalMsg(
	CONTACT_DELETED_FAILED
	) {
	error_ = error;
}

SelfMessageReceivedMsg::SelfMessageReceivedMsg(int message_id) : ProtocalMsg(
	MESSAGE_RECEIVED_SELF) {
	message_id_ = message_id;
}

ToSelfMessageReceivedMsg::ToSelfMessageReceivedMsg(CloudChatMessage message) :
	ProtocalMsg(MESSAGE_RECEIVED_OTHER) {
	message_ = message;
}

MessagesLoadedMsg::MessagesLoadedMsg(int target_id, std::vector<CloudChatMessage> messages) :
	ProtocalMsg(MESSAGES_LOADED) {
	target_id_ = target_id;
	messages_  = messages;
}

MessagesClearedMsg::MessagesClearedMsg(int user_id, int target_id) : ProtocalMsg(MESSAGES_CLEARD) {
	user_id_ = user_id;
	target_id_ = target_id;
}

std::string LoginSuccessMsg::ToJSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{\"userId\":%d,\"username\":\"%s\",\"email\":\"%s\",\"avatar\":\"%s\",\"token\":\"%s\"}}",
			type_.c_str(), user_id_, username_.c_str(), email_.c_str(), avatar_.c_str(),
			token_.c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string LoginFailureMsg::ToJSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{\"error\":\"%s\"}}", type_.c_str(),
			error_.c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string LogoutSuccessMsg::ToJSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{}}", type_.c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string RegisterSuccessMsg::ToJSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{\"userId\":%d,\"username\":\"%s\",\"email\":\"%s\",\"avatar\":\"%s\",\"token\":\"%s\"}}",
			type_.c_str(), user_id_, username_.c_str(), email_.c_str(), avatar_.c_str(),
			token_.c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string RegisterFailureMsg::ToJSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{\"error\":\"%s\"}}", type_.c_str(),
			error_.c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string ProfileUpdatedSuccessMsg::ToJSON() {
	
}

std::string ProfileUpdatedFailedMsg::ToJSON() {
	
}

std::string ContactsLoadedMsg::ToJSON() {
	
}

std::string ContactsLoadedFailedMsg::ToJSON() {
	
}

std::string ContactAddedMsg::ToJSON() {
	
}

std::string ContactAddedFailedMsg::ToJSON() {
	
}

std::string ContactDeletedMsg::ToJSON() {
	
}

std::string ContactDeletedFailedMsg::ToJSON() {
	
}

std::string SelfMessageReceivedMsg::ToJSON() {
	
}

std::string ToSelfMessageReceivedMsg::ToJSON() {
	
}

std::string MessagesLoadedMsg::ToJSON() {
	
}


std::string MessagesClearedMsg::ToJSON() {
	
}

ProtocalMsg parse_protocal_msg(std::string JSON) {
	int len = JSON.length();
	// 找到 "type" 字段的位置
	int type_pos = 0;
	for (int i = 0; i + 5 < len; i++) {
		std::string target = "\"type\"";
		bool flag = true;
		for (int j = 0; j < 6; j++) {
			if (JSON[i + j] != target[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			type_pos = i;
			break;
		}
	}
	// 找到 "payload" 字段的位置
	int payload_pos = 0;
	for (int i = 0; i + 8 < len; i++) {
		std::string target = "\"payload\"";
		bool flag = true;
		for (int j = 0; j < 9; j++) {
			if (JSON[i + j] != target[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			payload_pos = i;
			break;
		}
	}
	// 提取 type 值
	int first_quote = 0, second_quote = 0; // 两个双引号的位置
	for (int i = type_pos + 6; i < payload_pos; i++) {
		if (JSON[i] == '"') {
			first_quote = i;
			break;
		}
	}
	for (int i = payload_pos - 1; i >= type_pos + 6; i--) {
		if (JSON[i] == '"') {
			second_quote = i;
			break;
		}
	}
	std::string type;
	for (int i = first_quote + 1; i < second_quote; i++) type.push_back(JSON[i]);
	// 根据 type 值提取相应类型对象
	if (type == LOGIN) {
		return LoginMsg::parse_from_JSON(JSON, payload_pos);
	} else if (type == LOGIN_BY_TOKEN) {
		return LoginByTokenMsg::parse_from_JSON(JSON, payload_pos);
	} else if (type == REGISTER) {
		return RegisterMsg::parse_from_JSON(JSON, payload_pos);
	}
	return ProtocalMsg(ILLEGAL_MSG);
}

LoginMsg LoginMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int len = JSON.length();
	std::string username, password;
	int first_quote = 0, second_quote = 0; // 两个引号的位置
	// 找到 username 字段的位置
	int username_pos = 0;
	for (int i = payload_pos + 9; i < len; i++) {
		std::string target = "\"username\"";
		bool flag = true;
		for (int j = 0; j < target.length(); j++) {
			if (JSON[i + j] != target[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			username_pos = i;
			break;
		}
	}
	// 找到 password 字段的位置
	int password_pos = 0;
	for (int i = payload_pos + 9; i < len; i++) {
		std::string target = "\"password\"";
		bool flag = true;
		for (int j = 0; j < target.length(); j++) {
			if (JSON[i + j] != target[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			password_pos = i;
			break;
		}
	}
	// 提取 username 值
	for (int i = username_pos + 10; i < len; i++) {
		if (JSON[i] == '"') {
			if (first_quote == 0) {
				first_quote = i;
			} else {
				second_quote = i;
				break;
			}
		}
	}
	for (int i = first_quote + 1; i < second_quote; i++) {
		username.push_back(JSON[i]);
	}
	// 提取 password 值
	first_quote = 0;
	second_quote = 0;
	for (int i = password_pos + 10; i < len; i++) {
		if (JSON[i] == '"') {
			if (first_quote == 0) {
				first_quote = i;
			} else {
				second_quote = i;
				break;
			}
		}
	}
	for (int i = first_quote + 1; i < second_quote; i++) {
		password.push_back(JSON[i]);
	}
	return LoginMsg(username, password);
}

LoginByTokenMsg LoginByTokenMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int len = JSON.length();
	std::string username, token;
	int first_quote = 0, second_quote = 0; // 两个引号的位置
	// 找到 username 字段的位置
	int username_pos = 0;
	for (int i = payload_pos + 9; i < len; i++) {
		std::string target = "\"username\"";
		bool flag = true;
		for (int j = 0; j < target.length(); j++) {
			if (JSON[i + j] != target[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			username_pos = i;
			break;
		}
	}
	// 找到 token 字段的位置
	int token_pos = 0;
	for (int i = payload_pos + 9; i < len; i++) {
		std::string target = "\"token\"";
		bool flag = true;
		for (int j = 0; j < target.length(); j++) {
			if (JSON[i + j] != target[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			token_pos = i;
			break;
		}
	}
	// 提取 username 值
	for (int i = username_pos + 10; i < len; i++) {
		if (JSON[i] == '"') {
			if (first_quote == 0) {
				first_quote = i;
			} else {
				second_quote = i;
				break;
			}
		}
	}
	for (int i = first_quote + 1; i < second_quote; i++) {
		username.push_back(JSON[i]);
	}
	// 提取 token 值
	first_quote = 0;
	second_quote = 0;
	for (int i = token_pos + 8; i < len; i++) {
		if (JSON[i] == '"') {
			if (first_quote == 0) {
				first_quote = i;
			} else {
				second_quote = i;
				break;
			}
		}
	}
	for (int i = first_quote + 1; i < second_quote; i++) {
		token.push_back(JSON[i]);
	}
	return LoginByTokenMsg(username, token);
}

RegisterMsg RegisterMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int len = JSON.length();
	std::string username, password, email;
	int first_quote = 0, second_quote = 0; // 两个引号的位置
	// 找到 username 字段的位置
	int username_pos = 0;
	for (int i = payload_pos + 9; i < len; i++) {
		std::string target = "\"username\"";
		bool flag = true;
		for (int j = 0; j < target.length(); j++) {
			if (JSON[i + j] != target[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			username_pos = i;
			break;
		}
	}
	// 找到 password 字段的位置
	int password_pos = 0;
	for (int i = payload_pos + 9; i < len; i++) {
		std::string target = "\"password\"";
		bool flag = true;
		for (int j = 0; j < target.length(); j++) {
			if (JSON[i + j] != target[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			password_pos = i;
			break;
		}
	}
	// 找到 email 字段的位置
	int email_pos = 0;
	for (int i = payload_pos + 9; i < len; i++) {
		std::string target = "\"email\"";
		bool flag = true;
		for (int j = 0; j < target.length(); j++) {
			if (JSON[i + j] != target[j]) {
				flag = false;
				break;
			}
		}
		if (flag) {
			email_pos = i;
			break;
		}
	}
	// 提取 username 值
	for (int i = username_pos + 10; i < len; i++) {
		if (JSON[i] == '"') {
			if (first_quote == 0) {
				first_quote = i;
			} else {
				second_quote = i;
				break;
			}
		}
	}
	for (int i = first_quote + 1; i < second_quote; i++) {
		username.push_back(JSON[i]);
	}
	// 提取 password 值
	first_quote = 0;
	second_quote = 0;
	for (int i = password_pos + 10; i < len; i++) {
		if (JSON[i] == '"') {
			if (first_quote == 0) {
				first_quote = i;
			} else {
				second_quote = i;
				break;
			}
		}
	}
	for (int i = first_quote + 1; i < second_quote; i++) {
		password.push_back(JSON[i]);
	}
	// 提取 email 值
	first_quote = 0;
	second_quote = 0;
	for (int i = email_pos + 8; i < len; i++) {
		if (JSON[i] == '"') {
			if (first_quote == 0) {
				first_quote = i;
			} else {
				second_quote = i;
				break;
			}
		}
	}
	for (int i = first_quote + 1; i < second_quote; i++) {
		email.push_back(JSON[i]);
	}
	return RegisterMsg(username, password, email);
}
