/** cloudchatgroup.h
 * CloudChat 群聊头文件
 */

#ifndef CLOUDCHATGROUP_H
#define CLOUDCHATGROUP_H

#include "cloudchatuser.h"

class CloudChatGroup { // 群聊类
private:
	int id_; // 群聊 id
	std::string name_; // 群聊名称
	std::vector<CloudChatUser> members_; // 群聊成员

public:
	CloudChatGroup(std::string name, std::vector<CloudChatUser> original_members);
};

#endif // CLOUDCHATGROUP_H
