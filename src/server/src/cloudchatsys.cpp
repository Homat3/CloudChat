#include "cloudchatsys.h"

int g_server_port = 14514;
int g_buff_len    = 2048;

// Base64解码函数
std::string base64Decode(const std::string& encoded) {
    const std::string base64_chars = 
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz"
        "0123456789+/";
    
    std::string decoded;
    int i = 0;
    int in_len = encoded.size();
    int in_ = 0;
    
    while (in_len-- && (encoded[in_] != '=') && 
           (isalnum(encoded[in_]) || (encoded[in_] == '+') || (encoded[in_] == '/'))) {
        
        uint32_t char_array_4[4], char_array_3[3];
        int j = 0;
        
        for (int k = 0; k < 4; k++) {
            if (in_ >= encoded.size()) break;
            char_array_4[k] = base64_chars.find(encoded[in_]);
            if (char_array_4[k] != std::string::npos) {
                in_++;
                j++;
            } else {
                char_array_4[k] = 0;
            }
        }
        
        if (j == 4) {
            char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
            char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
            char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];
            
            for (int k = 0; k < 3; k++) {
                decoded += static_cast<char>(char_array_3[k]);
            }
        }
    }
    
    return decoded;
}
