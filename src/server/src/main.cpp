#include "cloudchatservice.h"

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

void OnOpen(websocketpp::connection_hdl hdl) { // 客户端连接建立时服务端的提示信息
    // 通过连接句柄获取连接指针
    server_t::connection_ptr con = g_cloudchat_srv.get_con_from_hdl(hdl);
    
    // 获取底层socket，然后获取远程端点
    boost::asio::ip::tcp::socket &sock = con->get_raw_socket();
    boost::asio::ip::tcp::endpoint remote_ep = sock.remote_endpoint();
    
    // 获取IP地址（字符串形式）
    std::string remote_ip = remote_ep.address().to_string();
    std::cout << "客户端已连接，IP地址: " << remote_ip << std::endl;
}

void OnClose(websocketpp::connection_hdl hdl) {	// 客户端断开连接时服务端的提示信息
	// 通过连接句柄获取连接指针
    server_t::connection_ptr con = g_cloudchat_srv.get_con_from_hdl(hdl);
    
    // 获取底层socket，然后获取远程端点
    boost::asio::ip::tcp::socket &sock = con->get_raw_socket();
    boost::asio::ip::tcp::endpoint remote_ep = sock.remote_endpoint();
    
    // 获取IP地址（字符串形式）
    std::string remote_ip = remote_ep.address().to_string();
    std::cout << "客户端已断开连接，IP地址: " << remote_ip << std::endl;
}

void OnMessage(websocketpp::connection_hdl hdl, server_t::message_ptr msg) {
	// TODO: 收到客户端的消息并解析处理
	std::string JSON_msg = msg->get_payload();
	ProtocalMsg* protocal_msg = parse_protocal_msg(JSON_msg);
	std::string type = protocal_msg->get_type();

	if (type == LOGIN) Login(hdl, (LoginMsg*)protocal_msg);
	else if (type == LOGIN_BY_TOKEN) LoginByToken(hdl, (LoginByTokenMsg*)protocal_msg);
    else if (type == REGISTER) Register(hdl, (RegisterMsg*)protocal_msg);
}
