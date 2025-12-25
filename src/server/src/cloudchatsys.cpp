#include "cloudchatsys.h"

int g_server_port = 14514;

bool check_websocket_open(server_t& cloudchat_srv, websocketpp::connection_hdl hdl) {
	auto con = cloudchat_srv.get_con_from_hdl(hdl);
	websocketpp::session::state::value state = con->get_state();
	return state == websocketpp::session::state::open; // 长连接建立则返回 true
}
