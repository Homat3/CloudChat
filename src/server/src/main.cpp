#include "cloudchatdat.h"
#include "cloudchatsys.h"
#include <iostream>
#include <websocketpp/common/connection_hdl.hpp>
#include <websocketpp/error.hpp>
#include <websocketpp/logger/levels.hpp>

#define SERVER_INITIALIZED 0 // 服务器已初始化
#define SERVER_INITIALIZATION_FAILED -1 // 服务器初始化失败
#define NETWORK_INITIALIZED           0 // 网络已初始化
#define NETWORK_INITIALIZATION_FAILED -1 // 网络初始化失败

server_t g_cloudchat_srv; // 服务器对象

int InitServer(); // 初始化服务器
int InitNetwork(); // 初始化网络
int InitDatabase(); // 初始化数据库

void OnOpen(websocketpp::connection_hdl hdl);
void OnClose(websocketpp::connection_hdl hdl);
void OnMessage(websocketpp::connection_hdl hdl, server_t::message_ptr msg);

int main() {
	// 初始化服务器
	printf("CloudChat 服务器正在初始化...\n");
	if (InitServer() != SERVER_INITIALIZED) {
		printf("服务器初始化失败。\n");
		return 0;
	}
	printf("服务器初始化完毕。\n");
	
	// 启动服务器
	printf("服务器正在运行...\n");
	g_cloudchat_srv.run();
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
	printf("正在初始化数据库...\n");
	if (InitDatabase() != DATABASE_INITIALIZED) {
		printf("数据库初始化失败。\n");
		return SERVER_INITIALIZATION_FAILED;
	}
	printf("数据库初始化完毕。\n");
	
	printf("正在初始化网络...\n");
	if (InitNetwork() != NETWORK_INITIALIZED) {
		printf("网络初始化失败。\n");
		return SERVER_INITIALIZATION_FAILED;
	}
	printf("网络初始化完毕。\n");
	return SERVER_INITIALIZED;
}

int InitNetwork() {
	try {
		// 初始化日志输出 --> 关闭日志输出
		g_cloudchat_srv.set_access_channels(websocketpp::log::alevel::none);
		g_cloudchat_srv.init_asio(); // 初始化ASIO框架
		// 设置消息处理/连接握手成功/连接关闭回调函数
		g_cloudchat_srv.set_open_handler(OnOpen);
		g_cloudchat_srv.set_close_handler(OnClose);
		auto msg_handler = std::bind(OnMessage, std::placeholders::_1,
									 std::placeholders::_2);
		g_cloudchat_srv.set_message_handler(msg_handler);
		// 启用地址重用
		g_cloudchat_srv.set_reuse_addr(true);
		// 设置监听端口
		g_cloudchat_srv.listen(SERVER_PORT);
		// 开始监听
		g_cloudchat_srv.start_accept();
	} catch (websocketpp::exception &e) {
		std::cerr << "Websocket 错误：" << e.what() << std::endl;
		std::cerr << "错误代码：" << e.code() << std::endl;
		return NETWORK_INITIALIZATION_FAILED;
	}
	return NETWORK_INITIALIZED;
}

void OnOpen(websocketpp::connection_hdl hdl) {
	
}

void OnClose(websocketpp::connection_hdl hdl) {
	
}

void OnMessage(websocketpp::connection_hdl hdl, server_t::message_ptr msg) {
	
}
