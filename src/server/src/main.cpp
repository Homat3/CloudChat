#include "cloudchatdat.h"

#define SERVER_INITIALIZED 0 // 服务器已初始化
#define SERVER_INITIALIZATION_FAILED -1 // 服务器初始化失败
#define NETWORK_INITIALIZED           0 // 网络已初始化
#define NETWORK_INITIALIZATION_FAILED -1 // 网络初始化失败

int InitServer(); // 初始化服务器
int InitNetwork(); // 初始化网络
int InitDatabase(); // 初始化数据库

int main() {
	printf("CloudChat 服务器正在初始化...\n");
	
	printf("正在初始化数据库...\n");
	if (InitServer() != SERVER_INITIALIZED) {
		printf("数据库初始化失败。\n");
		return 0;
	}
	printf("数据库初始化完毕。\n");
	
	printf("正在初始化网络...\n");
	if (InitNetwork() != NETWORK_INITIALIZED) {
		printf("网络初始化失败。\n");
		return 0;
	}
	printf("网络初始化完毕。\n");
	printf("服务器初始化完毕。\n");
	return 0;
}

int InitDatabase() {
	try {
		CloudChatDatabase::GetInstance(); // 实例化数据库
	} catch (sql::SQLException &e) {
		return DATABASE_INITIALIZATION_FAILED;
	}
	return DATABASE_INITIALIZED;
}

int InitServer() {
	if (InitDatabase() != DATABASE_INITIALIZED) return SERVER_INITIALIZATION_FAILED;
	return SERVER_INITIALIZED;
}

int InitNetwork() {
	// TODO: 初始化网络
	return NETWORK_INITIALIZED;
}
