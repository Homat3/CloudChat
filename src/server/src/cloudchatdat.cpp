#include "cloudchatdat.h"

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
			username varchar(50) not null unique,
			email varchar(50) not null unique,
			password varchar(50) not null,
			avatar varchar(50) not null unique,
			token varchar(50) not null,
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
			created_at timestamp default current_timestamp,
			primary key (user_id1, user_id2),
			foreign key (user_id1) references users(id) on delete cascade,
			foreign key (user_id2) references users(id) on delete cascade
			)
			)"
		);
		std::cout << "数据表 friends 已成功创建。" << std::endl;
		// 添加消息表
		statement->execute(R"(
			create table if not exists private_messages (
			id int auto_increment primary key,
			sender_id int not null,
			receiver_id int not null,
			message_type enum('text', 'image', 'file') not null default 'text',
			content text,
			file_name varchar(255),       
			file_size int,                
			file_path varchar(500),       
			is_read boolean default false,
			created_at timestamp default current_timestamp,
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
			sender_id int not null,
			receiver_id int not null,
			status enum('pending', 'accepted', 'rejected') default 'pending',
			message varchar(255),          
			created_at timestamp default current_timestamp,
			updated_at timestamp default current_timestamp on update current_timestamp,
			foreign key (sender_id) references users(id) on delete cascade,
			foreign key (receiver_id) references users(id) on delete cascade,
			unique key unique_friend_request (sender_id, receiver_id)  
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
				res->getString("email")
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
			"INSERT INTO users(username,email,password,avatar,token)"
			"VALUES(?,?,?,?,?)"
		);
		
		pstmt->setString(1,user.get_user_name());
		pstmt->setString(2,user.get_email());
		pstmt->setString(3,user.get_password());
		pstmt->setString(4,user.get_avatar());
		pstmt->setString(5,user.get_token());
		pstmt->setInt(6,user.get_id());

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

bool CloudDatabase::UpdateUser(CloudChatUser *user){ 
	if(user == nullptr){
		std::cerr << "update-failed: user is null" << std::endl;
		return false;
	}
	try{
		sql::PreparedStatement *pstmt = connection_->prepareStatement(
			"UPDATE users SET username = ?, email = ?, password = ?, avatar = ?, token = ?, WHERE id = ?"
		);
		pstmt->setString(1,user->get_user_name());
		pstmt->setString(2,user->get_email());
		pstmt->setString(3,user->get_password());
		pstmt->setString(4,user->get_avatar());
		pstmt->setString(5,user->get_token());
		pstmt->setInt(6,user->get_id());

		int rowsAffected = pstmt->executeUpdate();
		delete pstmt;
		return rowsAffected;

	}catch(sql::SQLException &e){
		std::cout << "# ERR: SQLException in " << std::endl;
		return false;
	}
}


