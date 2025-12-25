/** cloudchatsys.h
 * CloudChat 系统相关头文件
 */

#ifndef CLOUDCHATSYS_H
#define CLOUDCHATSYS_H

#include <iostream>
#include <map>
#include <string>
#include <websocketpp/config/asio_no_tls.hpp>
#include <websocketpp/server.hpp>
#include <vector>
#include <mysql_driver.h>
#include <mysql_connection.h>
#include <cppconn/statement.h>
#include <cppconn/resultset.h>
#include <cppconn/exception.h>
#include <cppconn/prepared_statement.h>
#include <time.h>
#include <cstdlib>
#include <websocketpp/common/connection_hdl.hpp>
#include <websocketpp/error.hpp>
#include <websocketpp/logger/levels.hpp>
#include <fstream>
#include <filesystem>
#include <csignal>
#include <thread>
#include <csignal>
#include <cstdio>
#include <cppconn/resultset.h>
#include <functional>
#include <websocketpp/http/constants.hpp>
#include <websocketpp/base64/base64.hpp>
#include <websocketpp/connection.hpp>

extern int g_server_port;

#define SERVER_PORT g_server_port // 服务器通信端口号
#define BUFF_LEN    2048		  // 字符串缓冲区大小

typedef websocketpp::server<websocketpp::config::asio> server_t; // 服务器对象类型
// 检查 websocket 长连接是否建立
bool check_websocket_open(server_t& cloudchat_srv, websocketpp::connection_hdl hdl);

#endif // CLOUDCHATSYS_H
