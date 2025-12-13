#include "cloudchatdat.h"
#include "cloudchatmsg.h"
#include "cloudchatservice.h"
#include <csignal>
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
void signal_handler(int signal);

int main() {
	srand(time(0));
	std::signal(SIGABRT, signal_handler);
	std::signal(SIGSEGV, signal_handler);
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
		g_cloudchat_srv.set_error_channels(websocketpp::log::elevel::none);
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

	if (!con) {
		std::cerr << "无法获取连接对象" << std::endl;
		return;
	}

	try {
		// 获取底层socket，然后获取远程端点
		boost::asio::ip::tcp::socket &sock = con->get_raw_socket();
		boost::asio::ip::tcp::endpoint remote_ep = sock.remote_endpoint();
    
		// 获取IP地址（字符串形式）
		std::string remote_ip = remote_ep.address().to_string();
		std::cout << "客户端已断开连接，IP地址: " << remote_ip << std::endl;
	} catch (const boost::system::system_error& e) {
		std::cerr << "获取远程端点失败：" << e.what() << std::endl;
	}

	// 更新用户在线状态
	auto it = g_online_users.find(hdl);
	if (it == g_online_users.end()) return;
	int user_id = it->second;
	CloudChatUser* user = CloudChatDatabase::GetInstance()->GetUserById(user_id);
	user->SetOnline(false);
	CloudChatDatabase::GetInstance()->UpdateUser(user);
	g_online_users.erase(it);
}

void OnMessage(websocketpp::connection_hdl hdl, server_t::message_ptr msg) {
	// TODO: 收到客户端的消息并解析处理
	std::string JSON_msg = msg->get_payload();
	ClientMsg* client_msg = parse_protocal_msg(JSON_msg);
	std::string type = client_msg->get_type();

	if (type == LOGIN) {
		Login(g_cloudchat_srv, hdl, (LoginMsg*)client_msg);
	} else if (type == LOGIN_BY_TOKEN) {
		LoginByToken(g_cloudchat_srv, hdl, (LoginByTokenMsg*)client_msg);
	} else if (type == REGISTER) {
		Register(g_cloudchat_srv, hdl, (RegisterMsg*)client_msg);
	} else if (type == LOGOUT) {
		Logout(g_cloudchat_srv, hdl, (LogoutMsg*)client_msg);
	} else if (type == UPDATE_PROFILE) {
		UpdateProfile(g_cloudchat_srv, hdl, (UpdateProfileMsg*)client_msg);
	} else if (type == LOAD_CONTACTS) {
		LoadContacts(g_cloudchat_srv, hdl, (LoadContactsMsg*)client_msg);
	} else if (type == ADD_CONTACT) {
		AddContact(g_cloudchat_srv, hdl, (AddContactMsg*)client_msg);
	} else if (type == DELETE_CONTACT) {
		DeleteContact(g_cloudchat_srv, hdl, (DeleteContactMsg*)client_msg);
	} else if (type == LOAD_MESSAGES) {
		LoadMessages(g_cloudchat_srv, hdl, (LoadMessagesMsg*)client_msg);
	} else if (type == SEND_MESSAGE) {
		SendMessage(g_cloudchat_srv, hdl, (SendMessageMsg*)client_msg);
	} else if (type == SEND_FILE) {
		SendFile(g_cloudchat_srv, hdl, (SendFileMsg*)client_msg);	
	} else if (type == SEND_IMAGE) {
		SendImage(g_cloudchat_srv, hdl, (SendImageMsg*)client_msg);
	} else if (type == MARK_READ) {
		MarkRead(g_cloudchat_srv, hdl, (MarkReadMsg*)client_msg);
	} else if (type == CLEAR_MESSAGES) {
		ClearMessages(g_cloudchat_srv, hdl, (ClearMessagesMsg*)client_msg);
	} else if (type == SEARCH_FOR_USER_BY_ID) {
		SearchForUserById(g_cloudchat_srv, hdl, (SearchForUserByIdMsg*)client_msg);
	} else if (type == SEARCH_FOR_UESR_BY_NAME) {
		SearchForUserByName(g_cloudchat_srv, hdl, (SearchForUserByNameMsg*)client_msg);
	} else if (type == ADD_FRIEND_REQUEST) {
		AddFriendRequest(g_cloudchat_srv, hdl, (AddFriendRequestClientMsg*)client_msg);
	} else if (type == REFUSE_FRIEND_REQUEST) {
		RefuseFriendRequest(g_cloudchat_srv, hdl, (RefuseFriendRequestClientMsg*)client_msg);
	} else if (type == ACCEPT_FRIEND_REQUEST) {
		AcceptFriendRequest(g_cloudchat_srv, hdl, (AcceptFriendRequestClientMsg*)client_msg);
	} else if (type == LOAD_FRIEND_REQUEST) {
		LoadFriendRequest(g_cloudchat_srv, hdl, (LoadFriendRequestMsg*)client_msg);
	} else if (type == UPLOAD_FILE) {
		UploadFile(g_cloudchat_srv, hdl, (UploadFileMsg*)client_msg);
	}
}

void signal_handler(int signal) {
	std::cout << "收到信号：" << signal << std::endl;
	std::exit(signal);
}
