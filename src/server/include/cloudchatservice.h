#ifndef CLOUDCHAT_SERVICE
#define CLOUDCHAT_SERVICE

#include "cloudchatdat.h"
#include "cloudchatmsg.h"
#include "cloudchatsys.h"

void Login(websocketpp::connection_hdl hdl, LoginMsg* msg);
void LoginByToken(websocketpp::connection_hdl hdl, LoginByTokenMsg* msg);
void Register(websocketpp::connection_hdl hdl, RegisterMsg* msg);

#endif // CLOUDCHAT_SERVICE
