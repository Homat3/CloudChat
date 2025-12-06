#include "cloudchatmsg.h"
#include <websocketpp/error.hpp>

ProtocalMsg::ProtocalMsg(std::string type) {
	type_ = type;
}

LoginMsg::LoginMsg(std::string username, std::string password) : ClientMsg(LOGIN) {
	username_ = username;
	password_ = password;
}

LoginByTokenMsg::LoginByTokenMsg(std::string username, std::string token) : ClientMsg(
	LOGIN_BY_TOKEN) {
	username_ = username;
	token_ = token;
}

LoginSuccessMsg::LoginSuccessMsg(int user_id, std::string username, std::string email,
										 std::string avatar, std::string token) : ServerMsg(
											 LOGIN_SUCCESS) {
	user_id_ = user_id;
	username_ = username;
	email_    = email;
	avatar_   = avatar;
	token_    = token;
}

LoginFailureMsg::LoginFailureMsg(std::string error) : ServerMsg(LOGIN_FAILURE) {
	error_ = error;
}

RegisterMsg::RegisterMsg(std::string username, std::string password, std::string email) :
	ClientMsg(REGISTER) {
	username_ = username;
	password_ = password;
	email_    = email;
}

RegisterSuccessMsg::RegisterSuccessMsg(int user_id, std::string username, std::string email,
											   std::string avatar, std::string token) :
	ServerMsg(REGISTER_SUCCESS) {
	user_id_ = user_id;
	username_ = username;
	email_ = email;
	avatar_ = avatar;
	token_ = token;
}

RegisterFailureMsg::RegisterFailureMsg(std::string error) : ServerMsg(
	REGISTER_FAILURE) {
	error_ = error;
}

UpdateProfileMsg::UpdateProfileMsg(int user_id, std::string username, std::string password,
										   std::string email, std::string avatar) : ClientMsg(
											   UPDATE_PROFILE
											   ) {
	user_id_ = user_id;
	username_ = username;
	password_ = password;
	email_    = email;
	avatar_   = avatar;
}

ProfileUpdatedSuccessMsg::ProfileUpdatedSuccessMsg(int user_id, std::string username,
												   std::string password, std::string email,
												   std::string avatar) : ServerMsg(
													   PROFILE_UPDATED_SUCCESS) {
	user_id_ = user_id;
	username_ = username;
	password_ = password;
	email_    = email;
	avatar_   = avatar;
}

LogoutMsg::LogoutMsg(int user_id) : ClientMsg(LOGOUT) {
	user_id_ = user_id;
}

LoadContactsMsg::LoadContactsMsg(int user_id) : ClientMsg(LOAD_CONTACTS) {
	user_id_ = user_id;
}

ContactsLoadedMsg::ContactsLoadedMsg(std::vector<Contact> contacts) : ServerMsg(
	CONTACTS_LOADED
	) {
	contacts_ = contacts;
}

AddContactMsg::AddContactMsg(int user_id, int target_id) : ClientMsg(ADD_CONTACT) {
	user_id_ = user_id;
	target_id_ = target_id;
}

ContactAddedMsg::ContactAddedMsg(int contact_id, std::string username, std::string avatar,
										 bool online) : ServerMsg(CONTACT_ADDED) {
	contact_id_ = contact_id;
	username_   = username;
	avatar_     = avatar;
	online_     = online;
}

DeleteContactMsg::DeleteContactMsg(int requester_user_id, int target_user_id) :
	ClientMsg(DELETE_CONTACT) {
	user_id_ = requester_user_id;
	target_id_    = target_user_id;
}

LoadMessagesMsg::LoadMessagesMsg(int user_id, int target_id) : ClientMsg(LOAD_MESSAGES) {
	user_id_ = user_id;
	target_id_ = target_id;
}

SendMessageMsg::SendMessageMsg(int message_id, int sender_id, int receiver_id,
									   std::string content) : ClientMsg(SEND_MESSAGE) {
	message_id_ = message_id;
	sender_id_  = sender_id;
	receiver_id_ = receiver_id;
	content_     = content;
}

SendFileMsg::SendFileMsg(int message_id, int sender_id, int receiver_id, std::string file_name,
						 std::string file_content) : ClientMsg(SEND_FILE) {
	message_id_ = message_id;
	sender_id_  = sender_id;
	receiver_id_ = receiver_id;
	file_name_   = file_name;
	file_content_ = file_content;
}

SendImageMsg::SendImageMsg(int message_id, int sender_id, int receiver_id, std::string image_name,
						   std::string image_content) : ClientMsg(SEND_IMAGE) {
	message_id_ = message_id;
	sender_id_  = sender_id;
	receiver_id_ = receiver_id;
	image_name_  = image_name;
	image_content_ = image_content;
}

MarkReadMsg::MarkReadMsg(int user_id, int target_id) : ClientMsg(MARK_READ) {
	user_id_ = user_id;
	target_id_ = target_id;
}

ClearMessagesMsg::ClearMessagesMsg(int requester_user_id, int target_user_id) : ClientMsg(
	CLEAR_MESSAGES) {
	requester_user_id_ = requester_user_id;
	target_user_id_    = target_user_id;
}

ProfileUpdatedFailedMsg::ProfileUpdatedFailedMsg(std::string error) : ServerMsg(
	PROFILE_UPDATED_FAILED
	) {
	error_ = error;
}

ContactsLoadedFailedMsg::ContactsLoadedFailedMsg(std::string error) : ServerMsg(
	CONTACTS_LOADED_FAILED
	) {
	error_ = error;
}

ContactAddedFailedMsg::ContactAddedFailedMsg(std::string error) : ServerMsg(
	CONTACT_ADDED_FAILED) {
	error_ = error;
}

ContactDeletedFailedMsg::ContactDeletedFailedMsg(std::string error) : ServerMsg(
	CONTACT_DELETED_FAILED
	) {
	error_ = error;
}

SelfMessageReceivedMsg::SelfMessageReceivedMsg(int message_id) : ServerMsg(
	MESSAGE_RECEIVED_SELF) {
	message_id_ = message_id;
}

ToSelfMessageReceivedMsg::ToSelfMessageReceivedMsg(CloudChatMessage message) :
	ServerMsg(MESSAGE_RECEIVED_OTHER) {
	message_ = message;
}

MessagesLoadedMsg::MessagesLoadedMsg(int target_id, std::vector<CloudChatMessage> messages) :
	ServerMsg(MESSAGES_LOADED) {
	target_id_ = target_id;
	messages_  = messages;
}

MessagesClearedMsg::MessagesClearedMsg(int user_id, int target_id) : ServerMsg(MESSAGES_CLEARD) {
	user_id_ = user_id;
	target_id_ = target_id;
}

std::string LoginSuccessMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff,
			"{\"type\":\"%s\",\"payload\":{\"userId\":%d,\"username\":\"%s\",\"email\":\"%s\",\"avatar\":\"%s\",\"token\":\"%s\"}}",
			to_JSON_string(type_).c_str(), user_id_, to_JSON_string(username_).c_str(),
			to_JSON_string(email_).c_str(), to_JSON_string(avatar_).c_str(),
			token_.c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string LoginFailureMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{\"error\":\"%s\"}}", to_JSON_string(type_).c_str(),
			to_JSON_string(error_).c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string LogoutSuccessMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{}}", to_JSON_string(type_).c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string RegisterSuccessMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff,
			"{\"type\":\"%s\",\"payload\":{\"userId\":%d,\"username\":\"%s\",\"email\":\"%s\",\"avatar\":\"%s\",\"token\":\"%s\"}}",
			to_JSON_string(type_).c_str(), user_id_, to_JSON_string(username_).c_str(),
			to_JSON_string(email_).c_str(), to_JSON_string(avatar_).c_str(),
			to_JSON_string(token_).c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string RegisterFailureMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{\"error\":\"%s\"}}", to_JSON_string(type_).c_str(),
			to_JSON_string(error_).c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string ProfileUpdatedSuccessMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff,
			"{\"type\":\"%s\",\"payload\":{\"userId\":%d,\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"avatar\":\"%s\"}}",
			to_JSON_string(type_).c_str(), user_id_, to_JSON_string(username_).c_str(),
			to_JSON_string(password_).c_str(), to_JSON_string(email_).c_str(),
			to_JSON_string(avatar_).c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string ProfileUpdatedFailedMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{\"error\":\"%s\"}}", to_JSON_string(type_).c_str(),
			to_JSON_string(error_).c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string ContactsLoadedMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	std::string contacts_json = "[";
	for (size_t i = 0; i < contacts_.size(); i++) {
		char contact_buff[BUFF_LEN] = "";
		sprintf(contact_buff,
				"{\"contactId\":%d,\"username\":\"%s\",\"avatar\":\"%s\",\"online\":%s}",
				contacts_[i].contact_id, to_JSON_string(contacts_[i].username).c_str(),
				to_JSON_string(contacts_[i].avatar).c_str(),
				contacts_[i].online ? "true" : "false");
		contacts_json += contact_buff;
		if (i != contacts_.size() - 1) {
			contacts_json += ",";
		}
	}
	contacts_json += "]";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{\"contacts\":%s}}", to_JSON_string(type_).c_str(),
			contacts_json.c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string ContactsLoadedFailedMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{\"error\":\"%s\"}}", to_JSON_string(type_).c_str(),
			to_JSON_string(error_).c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string ContactAddedMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff,
			"{\"type\":\"%s\",\"payload\":{\"contactId\":%d,\"username\":\"%s\",\"avatar\":\"%s\",\"online\":%s}}",
			to_JSON_string(type_).c_str(), contact_id_, to_JSON_string(username_).c_str(),
			to_JSON_string(avatar_).c_str(), online_ ? "true" : "false");
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string ContactAddedFailedMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{\"error\":\"%s\"}}", to_JSON_string(type_).c_str(),
			to_JSON_string(error_).c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string ContactDeletedMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{}}", to_JSON_string(type_).c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string ContactDeletedFailedMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff, "{\"type\":\"%s\",\"payload\":{\"error\":\"%s\"}}", to_JSON_string(type_).c_str(),
			to_JSON_string(error_).c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string SelfMessageReceivedMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff,
			"{\"type\":\"%s\",\"payload\":{\"messageId\":%d}}",
			to_JSON_string(type_).c_str(), message_id_);
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string ToSelfMessageReceivedMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	std::time_t created_at = message_.get_created_at();
	sprintf(buff,
			"{\"type\":\"%s\",\"payload\":{\"id\":%d,\"senderId\":%d,\"receiverId\":%d,\"content\":\"%s\",\"timestamp\":\"%s\",\"status\":\"%s\",\"type\":\"%s\"}}",
			to_JSON_string(type_).c_str(),
			message_.get_id(),
			message_.get_sender_id(),
			message_.get_receiver_id(),
			to_JSON_string(message_.get_content()).c_str(),
			c_str_to_JSON_string(ctime(&created_at)).c_str(),
			message_.get_is_read()? "read" : "sent",
			to_JSON_string(message_.get_type_str()).c_str()
	);
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

std::string MessagesLoadedMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	std::string messages_json = "[";
	for (size_t i = 0; i < messages_.size(); i++) {
		char message_buff[BUFF_LEN] = "";
		std::time_t created_at = messages_[i].get_created_at();
		sprintf(message_buff,
				"{\"id\":%d,\"senderId\":%d,\"receiverId\":%d,\"content\":\"%s\",\"timestamp\":\"%s\",\"status\":\"%s\",\"type\":\"%s\"}",
				messages_[i].get_id(),
				messages_[i].get_sender_id(),
				messages_[i].get_receiver_id(),
				to_JSON_string(messages_[i].get_content()).c_str(),
				c_str_to_JSON_string(ctime(&created_at)).c_str(),
				messages_[i].get_is_read()? "read" : "sent",
				to_JSON_string(messages_[i].get_type_str()).c_str()
		);
		messages_json += message_buff;
		if (i != messages_.size() - 1) {
			messages_json += ",";
		}
	}
	messages_json += "]";
	sprintf(buff,
			"{\"type\":\"%s\",\"payload\":{\"targetId\":%d,\"messages\":%s}}",
			to_JSON_string(type_).c_str(), target_id_, messages_json.c_str());
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}


std::string MessagesClearedMsg::to_JSON() {
	char buff[BUFF_LEN] = "";
	sprintf(buff,
			"{\"type\":\"%s\",\"payload\":{\"userId\":%d,\"targetId\":%d}}",
			to_JSON_string(type_).c_str(), user_id_, target_id_);
	std::string JSON;
	for (int i = 0; i < strlen(buff); i++) JSON.push_back(buff[i]);
	return JSON;
}

ClientMsg* parse_protocal_msg(std::string JSON) {
	int len = JSON.length();
	// 找到 "type" 字段的位置
	int type_pos = find_field_pos(JSON, "\"type\"");
	// 找到 "payload" 字段的位置
	int payload_pos = find_field_pos(JSON, "\"payload\"");
	// 提取 type 值
    std::string type = parse_str_from_json(JSON, type_pos, len - 1);
	// 根据 type 值提取相应类型对象
	if (type == LOGIN) {
		return LoginMsg::parse_from_JSON(JSON, payload_pos);
	} else if (type == LOGIN_BY_TOKEN) {
		return LoginByTokenMsg::parse_from_JSON(JSON, payload_pos);
	} else if (type == REGISTER) {
		return RegisterMsg::parse_from_JSON(JSON, payload_pos);
	}
	return new ClientMsg(ILLEGAL_MSG);
}

LoginMsg* LoginMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int len = JSON.length();
	// 找到 username 字段的位置
	int username_pos = find_field_pos(JSON, "\"username\"");
	std::string username = parse_str_from_json(JSON, username_pos, len - 1); // 提取 username 值
	// 找到 password 字段的位置
	int password_pos = find_field_pos(JSON, "\"password\"");
	std::string password = parse_str_from_json(JSON, password_pos, len - 1); // 提取 password 值
	return new LoginMsg(username, password);
}

LoginByTokenMsg* LoginByTokenMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int len = JSON.length();
	// 提取 username 字段值
	int username_pos = find_field_pos(JSON, "\"username\"");
	std::string username = parse_str_from_json(JSON, username_pos, len - 1);
	// 提取 token 字段值
	int token_pos = find_field_pos(JSON, "\"token\"");
	std::string token = parse_str_from_json(JSON, token_pos, len - 1);
	return new LoginByTokenMsg(username, token);
}

RegisterMsg* RegisterMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int len = JSON.length();
	int username_pos = find_field_pos(JSON, "\"username\"");
	std::string username = parse_str_from_json(JSON, username_pos, len - 1); // 提取 username 值
	// 找到 password 字段的位置
	int password_pos = find_field_pos(JSON, "\"password\"");
	std::string password = parse_str_from_json(JSON, password_pos, len - 1); // 提取 password 值
	// 找到 email 字段的位置
	int email_pos = find_field_pos(JSON, "\"email\"");
	std::string email = parse_str_from_json(JSON, email_pos, len - 1); // 提取 email 值
	return new RegisterMsg(username, password, email);
}

std::string ProtocalMsg::get_type() {
	return type_;
}

std::string LoginMsg::get_password() {
	return password_;
}

std::string LoginMsg::get_username() {
	return username_;
}

ClientMsg::ClientMsg(std::string type) : ProtocalMsg(type) {
	
}

ServerMsg::ServerMsg(std::string type) : ProtocalMsg(type) {
	
}

std::string ServerMsg::to_JSON() {
	return "{\"type\":\"" + type_ + "\",payload:{}}";
}

UpdateProfileMsg* UpdateProfileMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int end = JSON.length() - 1;
	int user_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"userId\""), end);
	std::string username = parse_str_from_json(JSON, find_field_pos(JSON, "\"username\""), end);
	std::string password = parse_str_from_json(JSON, find_field_pos(JSON, "\"password\""), end);
	std::string email = parse_str_from_json(JSON, find_field_pos(JSON, "\"email\""), end);
	std::string avatar = parse_str_from_json(JSON, find_field_pos(JSON, "\"avatar\""), end);
	return new UpdateProfileMsg(user_id, username, password, email, avatar);
}

LoadContactsMsg* LoadContactsMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int user_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"userId\""), JSON.length() - 1);
	return new LoadContactsMsg(user_id);
}

AddContactMsg* AddContactMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int user_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"userId\""), JSON.length() - 1);
	int target_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"targetId\""),
										JSON.length() - 1);
	return new AddContactMsg(user_id, target_id);
}

DeleteContactMsg* DeleteContactMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int user_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"userId\""), JSON.length() - 1);
	int target_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"targetId\""),
										JSON.length() - 1);
	return new DeleteContactMsg(user_id, target_id);
}

SendMessageMsg* SendMessageMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int message_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"messageId\""),
										JSON.length() - 1);
	int sender_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"senderId\""),
										JSON.length() - 1);
	int receiver_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"receiverId\""),
										JSON.length() - 1);
	std::string content = parse_str_from_json(JSON, find_field_pos(JSON, "\"content\""),
											JSON.length() - 1);
	return new SendMessageMsg(message_id, sender_id, receiver_id, content);
}

int parse_int_from_json(std::string JSON, int begin, int end) {
    int res = 0, sgn = 1;
	// 寻找数字开头
	for (int i = begin; i <= end; i++) {
		if (JSON[i] >= '0' && JSON[i] <= '9') {
			begin = i;
			break;
		}
	}
	// 检查负号
	if (begin > 0 && JSON[begin - 1] == '-') sgn = -1;
	// 计算绝对值
	for (int i = begin; i <= end; i++) {
		if (JSON[i] >= '0' && JSON[i] <= '9') res = res * 10 + JSON[i] - '0';
		else break;
	}
	return res * sgn;
}

std::string parse_str_from_json(std::string JSON, int begin, int end) {
	// 寻找字符串开头引号
	for (int i = begin; i <= end; i++) {
		if (JSON[i] == '"') {
			begin = i + 1;
			break;
		}
	}
	bool shift = false;			// 是否处于转义状态（此状态下读取转义字符）
	std::string res;			// 读取结果
	for (int i = begin; i <= end; i++) {
		if (!shift && JSON[i] == '"') break; // 非转义状态下遇到引号，代表字符串结束
		else if (shift) {
			if (JSON[i] == 'n') res.push_back('\n');
			else if (JSON[i] == 't') res.push_back('\t');
			else if (JSON[i] == 'r') res.push_back('\r');
			else res.push_back(JSON[i]);
			shift = false;
		} else {
			if (JSON[i] == '\\') shift = true;
			else res.push_back(JSON[i]);
		}
	}
	return res;
}

std::string to_JSON_string(std::string str) {
	std::string JSON;
	for (char c : str) {
		if (c == '\\') JSON.append("\\\\");
		else if (c == '\t') JSON.append("\\t");
		else if (c == '\n') JSON.append("\\n");
		else if (c == '\r') JSON.append("\\r");
		else JSON.push_back(c);
	}
	return JSON;
}

int SendMsgToClient(server_t& cloudchat_srv, websocketpp::connection_hdl hdl,
					server_t::message_ptr msg, ServerMsg* srv_msg) {
	try {
		cloudchat_srv.send(hdl, srv_msg->to_JSON(), msg->get_opcode());
	} catch (websocketpp::exception e) {
		std::cout << "发送失败：" << e.code() << ": " << e.what() << std::endl;
		return SEND_FAILED;
	}
	return SEND_SUCCESSFUL;
}

LogoutMsg* LogoutMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int user_id_pos = find_field_pos(JSON, "\"userId\"");
	int user_id = parse_int_from_json(JSON, user_id_pos, JSON.length() - 1);
	return new LogoutMsg(user_id);
}

int find_field_pos(std::string JSON, std::string target) {
	int len = JSON.length();
	for (int i = 0; i + target.length() < len; i++) {
		bool flag = true;
		for (int j = 0; j < target.length(); j++) {
			if (JSON[i + j] != target[j]) {
				flag = false;
				break;
			}
		}
		if (flag) return i + target.length();
	}
	return 0;
}

SendFileMsg* SendFileMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int len = JSON.length();
	int message_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"messageId\""),
										JSON.length() - 1);
	int sender_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"senderId\""),
										JSON.length() - 1);
	int receiver_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"receiverId\""),
										JSON.length() - 1);
	std::string file_name = parse_str_from_json(JSON, find_field_pos(JSON, "\"fileName\""),
											   JSON.length() - 1);
	std::string file_content = parse_str_from_json(JSON,
												   find_field_pos(JSON, "\"fileContent\""),
												   JSON.length() - 1);
	return new SendFileMsg(message_id, sender_id, receiver_id, file_name, file_content);
}

SendImageMsg* SendImageMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int len = JSON.length();
	int message_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"messageId\""),
										JSON.length() - 1);
	int sender_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"senderId\""),
										JSON.length() - 1);
	int receiver_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"receiverId\""),
										JSON.length() - 1);
	std::string image_name = parse_str_from_json(JSON, find_field_pos(JSON, "\"imageName\""),
												JSON.length() - 1);
	std::string image_content = parse_str_from_json(JSON,
													find_field_pos(JSON, "\"imageContent\""),
													JSON.length() - 1);
	return new SendImageMsg(message_id, sender_id, receiver_id, image_name, image_content);
}

LoadMessagesMsg* LoadMessagesMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int user_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"userId\""),
									 JSON.length() - 1);
	int target_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"targetId\""),
									   JSON.length() - 1);
	return new LoadMessagesMsg(user_id, target_id);
}

MarkReadMsg* MarkReadMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int user_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"userId\""),
									 JSON.length() - 1);
	int target_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"targetId\""),
									   JSON.length() - 1);
	return new MarkReadMsg(user_id, target_id);
}

ClearMessagesMsg* ClearMessagesMsg::parse_from_JSON(std::string JSON, int payload_pos) {
	int requester_user_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"requesterUserId\""),
											   JSON.length() - 1);
	int target_user_id = parse_int_from_json(JSON, find_field_pos(JSON, "\"targetUserId\""),
											JSON.length() - 1);
	return new ClearMessagesMsg(requester_user_id, target_user_id);
}

int CloudChatMessage::get_id() {
	return id_;
}

bool CloudChatMessage::get_is_group() {
	return is_group_;
}

int CloudChatMessage::get_type() {
	return type_;
}

int CloudChatMessage::get_sender_id() {
	return sender_id_;
}

int CloudChatMessage::get_receiver_id() {
	return receiver_id_;
}

std::string CloudChatMessage::get_content() {
	return content_;
}

std::string CloudChatMessage::get_file_name() {
	return file_name_;
}

int CloudChatMessage::get_file_size() {
	return file_size_;
}

std::string CloudChatMessage::get_file_path() {
	return file_path_;
}

bool CloudChatMessage::get_is_read() {
	return is_read_;
}

time_t CloudChatMessage::get_created_at() {
	return created_at_;
}

std::string CloudChatMessage::get_type_str() {
	switch (type_) {
		case TEXT_MESSAGE:
			return "text";
		case IMAGE_MESSAGE:
			return "image";
		case FILE_MESSAGE:
			return "file";
		default:
			return "unknown";
	}
}

std::string c_str_to_JSON_string(const char* c_str) {
	std::string JSON;
	for (int i = 0; i < strlen(c_str); i++) {
		if (c_str[i] == '\\') JSON.append("\\\\");
		else if (c_str[i] == '\t') JSON.append("\\t");
		else if (c_str[i] == '\n') JSON.append("\\n");
		else if (c_str[i] == '\r') JSON.append("\\r");
		else JSON.push_back(c_str[i]);
	}
	return JSON;
}
