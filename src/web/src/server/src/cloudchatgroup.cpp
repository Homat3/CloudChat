#include "cloudchatgroup.h"

CloudChatGroup::CloudChatGroup(std::string name, std::vector<CloudChatUser> original_members) {
	name_ = name;
	members_ = original_members;
}
