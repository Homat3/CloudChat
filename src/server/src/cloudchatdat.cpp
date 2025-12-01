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
			token varchar(50) not null
			)
		)");
		std::cout << "数据表 users 已成功创建。" << std::endl;

		// TODO: 创建好友关系数据表
		// 好友关系数据表有两列，均存储用户 id，表示一对好友关系中的两个用户，每一行（即每个条目）表示一对好友关系。
		statement->execute(R"(
		create table if not exists friends (
			user_id1 int not null,
			user_id2 int not null,
			primary key (user_id1, user_id2),
			foreign key (user_id1) references users(id) on delete cascade,
			foreign key (user_id2) references users(id) on delete cascade
		)
		)");
		std::cout << "数据表 friends 已成功创建。" << std::endl;
		// 添加消息表
		statement->execute(R"(
		create table if not exists messages (
			id int auto_increment primary key,
			sender_id int not null,
			receiver_id int not null,
			message_type varchar(20) default 'text',
			content text not null,
			timestamp datetime default current_timestamp,
			is_read boolean default false,
			foreign key (sender_id) references users(id) on delete cascade,
			foreign key (receiver_id) references users(id) on delete cascade
		)
		)");
		std::cout << "数据表 messages 已成功创建。" << std::endl;
		

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
