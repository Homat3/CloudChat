/** cloudchatsys.h
 * CloudChat 系统相关头文件
 */

#ifndef CLOUDCHATSYS_H
#define CLOUDCHATSYS_H

#include <iostream>
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

#define SERVER_PORT 14514 // 服务器通信端口号
// 114.116.245.123
// server
// 1234567SSH

typedef websocketpp::server<websocketpp::config::asio> server_t; // 服务器对象类型

#endif // CLOUDCHATSYS_H
