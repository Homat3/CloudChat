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

#define SERVER_PORT 14514 // 服务器通信端口号
// 114.116.245.123
// server
// 1234567SSH

#define BUFF_LEN    2048		// 字符串缓冲区大小

typedef websocketpp::server<websocketpp::config::asio> server_t; // 服务器对象类型

std::string base64Decode(const std::string& encoded); // Base64解码函数

#endif // CLOUDCHATSYS_H
