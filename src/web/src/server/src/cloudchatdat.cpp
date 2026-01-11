#include "cloudchatdat.h"
#include "cloudchatmsg.h"
#include "cloudchatuser.h"
#include <cppconn/exception.h>
#include <cppconn/prepared_statement.h>
#include <cppconn/resultset.h>

CloudChatDatabase::CloudChatDatabase() {
	try {
		driver_ = sql::mysql::get_mysql_driver_instance(); // 获取驱动实例
		// 建立连接
		connection_ = driver_->connect(DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD);
		// 创建 Statement 对象
		sql::Statement *statement = connection_->createStatement();
		// 执行创建数据库的 SQL 语句
		statement->execute("create database if not exists cloudchat");

		std::cout << "数据库 cloudchat 已成功创建。" << std::endl;
		
		statement->execute("use cloudchat;"); // 选择 cloudchat 数据库

		// 创建用户数据表
		statement->execute(R"(
			create table if not exists users (
			id int auto_increment primary key,
			username varchar(255) not null unique,
			email varchar(255) not null unique,
			password varchar(255) not null,
			avatar varchar(255) not null,
			token varchar(255) not null,
			online boolean default false,  
			last_active timestamp,         
			created_at timestamp default current_timestamp
			)
			)"
		);
		std::cout << "数据表 users 已成功创建。" << std::endl;

		// 好友关系数据表有两列，均存储用户 id，表示一对好友关系中的两个用户，每一行（即每个条目）表示一对好友关系。
		statement->execute(R"(
			create table if not exists friends (
			user_id1 int not null,
			user_id2 int not null,
			primary key (user_id1, user_id2),
			foreign key (user_id1) references users(id) on delete cascade,
			foreign key (user_id2) references users(id) on delete cascade
			)
			)"
		);
		std::cout << "数据表 friends 已成功创建。" << std::endl;
		// 添加消息表
		statement->execute(R"(
			create table if not exists messages (
			id int auto_increment primary key,
			sender_id int not null,
			receiver_id int not null,
			message_type enum('text', 'image', 'file') not null default 'text',
			content text,
			file_name varchar(255),       
			file_size int,                
			file_path varchar(500),       
			is_read boolean default false,
			created_at int,
			foreign key (sender_id) references users(id) on delete cascade,
			foreign key (receiver_id) references users(id) on delete cascade,
			index idx_conversation (sender_id, receiver_id, created_at) 
			)
			)"
		);
		std::cout << "数据表 messages 已成功创建。" << std::endl;
		/*
		// 创建群聊表
        statement->execute(R"(
			create table if not exists groups (
			id int auto_increment primary key,
			name varchar(100) not null,
			description text,
			owner_id int not null,
			avatar varchar(100),
			created_at timestamp default current_timestamp,
			foreign key (creator_id) references users(id) on delete cascade
			)
			)"
		);
        std::cout << "数据表 groups 已成功创建。" << std::endl;

        // 创建用户-群聊关系表
        statement->execute(R"(
			create table if not exists user_groups (
			user_id int not null,
			group_id int not null,
			role enum('admin', 'member') default 'member',
			joined_at timestamp default current_timestamp,
			primary key (user_id, group_id),
			foreign key (user_id) references users(id) on delete cascade,
			foreign key (group_id) references groups(id) on delete cascade
			)
			)"
		);
        std::cout << "数据表 user_groups 已成功创建。" << std::endl;

		//创建群聊消息表
		statement->execute(R"(
			create table if not exist group_messages (
			id int auto_increment primary key,
			 group_id int not null,
			sender_id int not null,
			message_type enum('text', 'image', 'file') not null default 'text',
			content text,
			file_name varchar(255),       -- 文件名
			file_size int,                -- 文件大小
			file_path varchar(500),       -- 文件存储路径
			created_at timestamp default current_timestamp,
			foreign key (group_id) references groups(id) on delete cascade,
			foreign key (sender_id) references users(id) on delete cascade,
			index idx_group_messages (group_id, created_at)  
			)
			)"
		);
		std::cout << "数据表 group_messages 已成功创建。" << std::endl;
		*/
		//添加好友请求表
		statement->execute(R"(
			create table if not exists friend_requests (
			id int auto_increment primary key,
			requester_id int not null,
			target_id int not null,
            requester_username varchar(255) not null,
            target_username varchar(255) not null,
            requester_avatar varchar(255) not null,
            target_avatar varchar(255) not null,
			status enum('pending', 'accepted', 'refused') default 'pending',
			foreign key (requester_id) references users(id) on delete cascade,
			foreign key (target_id) references users(id) on delete cascade,
			unique key unique_friend_request (requester_id, target_id)  
			)
			)"
		);
		std::cout << "数据表 friend_requests 已成功创建。" << std::endl;

		// 清理资源
		delete statement;
	} catch (sql::SQLException &e) { // 发生错误
		std::cerr << "MySQL 错误：" << e.what() << std::endl;
		std::cerr << "错误代码：" << e.getErrorCode() << std::endl;
		throw;
	}
	th_pump_ = std::thread(&CloudChatDatabase::Pump, this);
}

CloudChatDatabase* CloudChatDatabase::GetInstance() {
	static CloudChatDatabase instance_;   // 单例模式实例
	return &instance_;
}

CloudChatUser* CloudChatDatabase::GetUserById(int id){
	try{
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"SELECT* FROM users WHERE id = ?"
		);
		pstmt->setInt(1,id);

		sql::ResultSet* res = pstmt->executeQuery();
		CloudChatUser* user = nullptr;

		if(res->next()){
			user = new CloudChatUser(
				res->getInt("id"),
				res->getString("username"),
				res->getString("password"),
				res->getString("avatar"),
				res->getString("token"),
				res->getString("email"),
				res->getBoolean("online")
			);
		}

		delete res;
		delete pstmt;
		return user;
	}catch(sql::SQLException &e){
		std::cerr << "getById-failed:" << e.what() << std::endl;
		std::cerr << "wrong-code:" << e.getErrorCode() << std::endl;
		return nullptr;
	}
}

bool CloudChatDatabase::AddUser(CloudChatUser& user){ 
	try{
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"INSERT INTO users(username,email,password,avatar,token,online)"
			"VALUES(?,?,?,?,?,?)"
		);
		
		pstmt->setString(1,user.get_username());
		pstmt->setString(2,user.get_email());
		pstmt->setString(3,user.get_password());
		pstmt->setString(4,user.get_avatar());
		pstmt->setString(5,user.get_token());
		pstmt->setBoolean(6,user.is_online());

		return pstmt->executeUpdate() > 0;

		delete pstmt;

	}catch(sql::SQLException &e){
		std::cerr << "add-failed:" << e.what() << std::endl;
		std::cerr << "wrong-code:" << e.getErrorCode() << std::endl;
		return false;
	}
}

bool CloudChatDatabase::DeleteUser(int id){
	try{
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"DELETE FROM users WHERE id = ?"
		);
		pstmt->setInt(1,id);

		int affectedRows = pstmt->executeUpdate();
		delete pstmt;
		return affectedRows > 0;
	}catch(sql::SQLException &e){
		std::cerr << "delete-failed:" << e.what() << std::endl;
		return false;
	}
}

bool CloudChatDatabase::UpdateUser(CloudChatUser *user){ 
	if(user == nullptr){
		std::cerr << "update-failed: user is null" << std::endl;
		return false;
	}
	try{
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"UPDATE users SET username = ?, email = ?, password = ?, avatar = ?, token = ?, online = ?  WHERE id = ?"
		);
		pstmt->setString(1,user->get_username());
		pstmt->setString(2,user->get_email());
		pstmt->setString(3,user->get_password());
		pstmt->setString(4,user->get_avatar());
		pstmt->setString(5,user->get_token());
		pstmt->setBoolean(6, user->is_online());
		pstmt->setInt(7,user->get_id());

		int rowsAffected = pstmt->executeUpdate();
		delete pstmt;
		return rowsAffected;

	}catch(sql::SQLException &e){
		std::cout << "# ERR: SQLException in " << e.what() << std::endl;
		return false;
	}
}

CloudChatUser* CloudChatDatabase::GetUserByName(std::string username){
	try{
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"SELECT * FROM users WHERE username = ?"
		);
		pstmt->setString(1,username);

		sql::ResultSet* res = pstmt->executeQuery();
		CloudChatUser* user = nullptr;

		if(res->next()){
			user = new CloudChatUser(
				res->getInt("id"),
				res->getString("username"),
				res->getString("password"),
				res->getString("avatar"),
				res->getString("token"),
				res->getString("email"),
				res->getBoolean("online")
			);
			delete res;
			delete pstmt;
			return user;
		}
	}catch(sql::SQLException &e){
		std::cout << "# ERR: SQLException in " << e.what() << std::endl;
		return nullptr;
	}
	return nullptr;
}

std::vector<CloudChatUser> CloudChatDatabase::SearchUsersByName(std::string username) {
	std::vector<CloudChatUser> results;
	try {
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"select * from users where username like ?"
			);
		pstmt->setString(1, "%" + username + "%");

		sql::ResultSet* res = pstmt->executeQuery();
		while (res->next()) {
			results.push_back(*(new CloudChatUser(res->getInt("id"),
												  res->getString("username"),
												  res->getString("password"),
												  res->getString("avatar"),
												  res->getString("token"),
												  res->getString("email"),
												  res->getBoolean("online"))));
		}
		delete res;
		delete pstmt;
	} catch (sql::SQLException &e) {
		std::cout << "# ERR: SQLException in " << e.what() << std::endl;
		return results;
	}
	return results;
}

bool CloudChatDatabase::AddFriendRequest(FriendRequest friend_request) {
	try {
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"INSERT INTO friend_requests(requester_id, target_id, requester_username, target_username, requester_avatar, target_avatar)"
			"VALUES(?,?,?,?,?,?)"
		);
		
		pstmt->setInt(1, friend_request.get_requester_id());
		pstmt->setInt(2, friend_request.get_target_id());
		pstmt->setString(3, friend_request.get_requester_username());
		pstmt->setString(4, friend_request.get_target_username());
		pstmt->setString(5, friend_request.get_requester_avatar());
		pstmt->setString(6, friend_request.get_target_avatar());

		return pstmt->executeUpdate() > 0;

		delete pstmt;

	} catch (sql::SQLException &e) {
		std::cerr << "add-failed:" << e.what() << std::endl;
		std::cerr << "wrong-code:" << e.getErrorCode() << std::endl;
		return false;
	}
}

std::vector<FriendRequest> CloudChatDatabase::GetFriendRequestsByUserId(int user_id) {
	std::vector<FriendRequest> results;
	try {
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"SELECT * FROM friend_requests WHERE requester_id = ? or target_id = ?"
		);
		pstmt->setInt(1, user_id);
		pstmt->setInt(2, user_id);

		sql::ResultSet* res = pstmt->executeQuery();
		while (res->next()) {
			results.push_back(*(new FriendRequest(res->getInt("id"),
												  res->getInt("requester_id"),
												  res->getInt("target_id"),
												  res->getString("requester_username"),
												  res->getString("target_username"),
												  res->getString("requester_avatar"),
												  res->getString("target_avatar"),
												  res->getString("status"))));
		}
		delete res;
		delete pstmt;
	} catch (sql::SQLException &e) {
		std::cout << "# ERR: SQLException in " << e.what() << std::endl;
		return results;
	}
	return results;
}

FriendRequest* CloudChatDatabase::GetFriendRequestById(int id) {
	try {
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"SELECT * FROM friend_requests WHERE id = ?"
		);
		pstmt->setInt(1, id);

		sql::ResultSet* res = pstmt->executeQuery();
		if (res->next()) {
			FriendRequest* friend_request = new FriendRequest(res->getInt("id"),
															  res->getInt("requester_id"),
															  res->getInt("target_id"),
															  res->getString("requester_username"),
															  res->getString("target_username"),
															  res->getString("requester_avatar"),
															  res->getString("target_avatar"),
															  res->getString("status"));
			delete res;
			delete pstmt;
			return friend_request;
		}
		delete res;
		delete pstmt;
	} catch (sql::SQLException &e) {
		std::cout << "# ERR: SQLException in " << e.what() << std::endl;
	}
	return nullptr;
}

bool CloudChatDatabase::UpdateFriendRequest(FriendRequest* friend_request) {
	if (friend_request == nullptr) {
		std::cerr << "update-failed: friend_request is null" << std::endl;
		return false;
	}
	try {
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"UPDATE friend_requests SET status = ? where id = ?"
		);
		pstmt->setString(1, friend_request->get_status());
		pstmt->setInt(2, friend_request->get_id());

		int rowsAffected = pstmt->executeUpdate();
		delete pstmt;
		return rowsAffected;
	} catch(sql::SQLException &e) {
		std::cout << "# ERR: SQLException in " << e.what() << std::endl;
	}
	return false;
}

FriendRequest* CloudChatDatabase::GetFriendRequestByTwoIds(int requester_id, int target_id) {
	try {
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"SELECT * FROM friend_requests WHERE requester_id = ? and target_id = ?"
		);
		pstmt->setInt(1, requester_id);
		pstmt->setInt(2, target_id);

		sql::ResultSet* res = pstmt->executeQuery();
		if (res->next()) {
			FriendRequest* friend_request = new FriendRequest(res->getInt("id"),
															  res->getInt("requester_id"),
															  res->getInt("target_id"),
															  res->getString("requester_username"),
															  res->getString("target_username"),
															  res->getString("requester_avatar"),
															  res->getString("target_avatar"),
															  res->getString("status"));
			delete res;
			delete pstmt;
			return friend_request;
		}
		delete res;
		delete pstmt;
	} catch (sql::SQLException &e) {
		std::cout << "# ERR: SQLException in " << e.what() << std::endl;
	}
	return nullptr;
}

bool CloudChatDatabase::AddFriend(int user_id1, int user_id2) {
	try {
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"INSERT INTO friends(user_id1, user_id2)"
			"VALUES(?,?)"
		);
		
		pstmt->setInt(1, user_id1);
		pstmt->setInt(2, user_id2);

		return pstmt->executeUpdate() > 0;

		delete pstmt;
	} catch (sql::SQLException &e) {
		std::cerr << "add-failed:" << e.what() << std::endl;
		std::cerr << "wrong-code:" << e.getErrorCode() << std::endl;
		return false;
	}
}

std::vector<CloudChatUser> CloudChatDatabase::get_contacts(int user_id) {
	std::vector<CloudChatUser> results;
	try {
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"SELECT * FROM friends WHERE user_id1 = ? or user_id2 = ?"
		);
		pstmt->setInt(1, user_id);
		pstmt->setInt(2, user_id);

		sql::ResultSet* res = pstmt->executeQuery();
		while (res->next()) {
			int user_id1 = res->getInt("user_id1");
			int user_id2 = res->getInt("user_id2");
			if (user_id1 == user_id) results.push_back(*(GetUserById(user_id2)));
			else results.push_back(*(GetUserById(user_id1)));
		}
		delete res;
		delete pstmt;
	} catch (sql::SQLException &e) {
		std::cout << "# ERR: SQLException in " << e.what() << std::endl;
		return results;
	}
	return results;
}

bool CloudChatDatabase::is_friend(int user_id1, int user_id2) {
	bool result = false;
	try {
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"SELECT * FROM friends WHERE user_id1 = ? and user_id2 = ?"
		);
		pstmt->setInt(1, user_id1);
		pstmt->setInt(2, user_id2);

		sql::ResultSet* res = pstmt->executeQuery();
		if (res->next()) result = true;
		else {
			pstmt = connection_->prepareStatement(
				"SELECT * FROM friends WHERE user_id1 = ? and user_id2 = ?"
				);
			pstmt->setInt(1, user_id2);
			pstmt->setInt(2, user_id1);

			res = pstmt->executeQuery();
			if (res->next()) result = true;
		}
		delete res;
		delete pstmt;
	} catch (sql::SQLException &e) {
		std::cout << "# ERR: SQLException in " << e.what() << std::endl;
	}
	return result;
}

bool CloudChatDatabase::AddMessage(CloudChatMessage* message) {
	try {
		sql::PreparedStatement* pstmt = connection_->prepareStatement(
			"insert into messages(sender_id, receiver_id, message_type, content, file_name, file_size, file_path, is_read, created_at)"
			"values(?, ?, ?, ?, ?, ?, ?, ?, ?)"
			);
		pstmt->setInt(1, message->get_sender_id());
		pstmt->setInt(2, message->get_receiver_id());
		pstmt->setString(3, message->get_type_str());
		pstmt->setString(4, message->get_content());
		pstmt->setString(5, message->get_file_name());
		pstmt->setInt(6, message->get_file_size());
		pstmt->setString(7, message->get_file_path());
		pstmt->setBoolean(8, message->get_is_read());
		pstmt->setInt(9, message->get_created_at());

		int res = pstmt->executeUpdate();
		delete pstmt;
		return res > 0;
	} catch (sql::SQLException& e) {
		std::cout << "更新 messages 数据表失败：" << e.what() << std::endl;
	}
	return false;
}

std::vector<CloudChatMessage> CloudChatDatabase::GetMessagesByTwoIds(int user_id, int target_id) {
	std::vector<CloudChatMessage> results;
	try {
		sql::PreparedStatement* pstmt = connection_->prepareStatement(
			"select * from messages where (sender_id = ? and receiver_id = ?) or (sender_id = ? and receiver_id = ?)"
			);
		pstmt->setInt(1, user_id);
		pstmt->setInt(2, target_id);
		pstmt->setInt(3, target_id);
		pstmt->setInt(4, user_id);

		sql::ResultSet* res = pstmt->executeQuery();
		while (res->next()) {
		    int id = res->getInt("id");
			bool is_group = false;
			std::string type_str = res->getString("message_type");
			int type = (type_str == "text") * TEXT_MESSAGE + (type_str == "file") * FILE_MESSAGE +
				(type_str == "image") * IMAGE_MESSAGE;
			int sender_id = res->getInt("sender_id");
			int receiver_id = res->getInt("receiver_id");
			std::string content = res->getString("content");
			std::string file_name = res->getString("file_name");
			int file_size = res->getInt("file_size");
			std::string file_path = res->getString("file_path");
			bool is_read = res->getBoolean("is_read");
			time_t created_at = res->getInt("created_at");

			results.push_back(*(new CloudChatMessage(id, is_group, type, sender_id, receiver_id,
												   content, file_name, file_size, file_path, is_read,
												   created_at)));
		}
		delete res;
		delete pstmt;
	} catch (sql::SQLException& e) {
		std::cout << "筛选 messages 数据表失败：" << e.what() << std::endl;
	}
	return results;
}

bool CloudChatDatabase::UpdateMessage(CloudChatMessage* message) {
	try {
		sql::PreparedStatement* pstmt = connection_->prepareStatement(
			"update messages set message_type = ?, sender_id = ?, receiver_id = ?, content = ?, file_name = ?, file_size = ?, file_path = ?, is_read = ?, created_at = ? where id = ?"
			);
		pstmt->setString(1, message->get_type_str());
		pstmt->setInt(2, message->get_sender_id());
		pstmt->setInt(3, message->get_receiver_id());
		pstmt->setString(4, message->get_content());
		pstmt->setString(5, message->get_file_name());
		pstmt->setInt(6, message->get_file_size());
		pstmt->setString(7, message->get_file_path());
		pstmt->setBoolean(8, message->get_is_read());
		pstmt->setInt(9, message->get_created_at());
		pstmt->setInt(10, message->get_id());

		int res = pstmt->executeUpdate();
		delete pstmt;
		return res > 0;
	} catch (sql::SQLException& e) {
		std::cout << "更新 messages 数据表失败：" << e.what() << std::endl;
	}
	return false;
}

void CloudChatDatabase::Pump() {
	while (1) {
		GetUserById(1);
		sleep(7 * 60 * 60);
	}
}

CloudChatDatabase::~CloudChatDatabase() {
	th_pump_.join();
}
