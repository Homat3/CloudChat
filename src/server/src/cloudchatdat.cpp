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

		// TODO: 创建数据表
		statement->execute(R"(
create table if not exists users (
id int auto_increment primary key,
username varchar(50) not null unique,
password varchar(50) not null,
avatar varchar(50) not null unique,
token varchar(50) not null
)
)");
		std::cout << "数据表 users 已成功创建。" << std::endl;

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
