# 登录模块
## 客户端->服务端
### 请求账密登录
```json
{
  "type": "LOGIN",
  "payload": {
    "username": "string",
    "password": "string"
  }
}
```
### 请求令牌登录
```json
{
  "type": "LOGIN_BY_TOKEN",
  "payload": {
    "username": "string",
    "token": "string"
  }
}
```
### 请求登出
```json
{
  "type": "LOGOUT",
  "payload": {
    "userId": "int"
  }
}
```
## 服务端->客户端
### 登录成功
```json
{
  "type": "LOGIN_SUCCESS",
  "payload": {
    "userId": "int",
    "username": "string",
    "email": "string",
    "avatar": "string",
    "token": "string"
  }
}
```
### 登录失败
```json
{
  "type": "LOGIN_FAILURE",
  "payload": {
    "error": "string"
  }
}
```
### 登出成功
```json
{
  "type": "LOGOUT_SUCCESS",
  "payload": {}
}
```
# 注册模块
## 客户端->服务端
### 请求注册
```json
{
  "type": "REGISTER",
  "payload": {
    "username": "string",
    "password": "string",
    "email": "string"
  }
}
```
## 服务端->客户端
### 注册成功
```json
{
  "type": "REGISTER_SUCCESS",
  "payload": {
    "userId": "int",
    "username": "string",
    "email": "string",
    "avatar": "string",
    "token": "string"
  }
}
```
### 注册失败
```json
{
  "type": "REGISTER_SUCCESS",
  "payload": {
    "error": "string"
  }
}
```
# 个人资料模块
## 客户端->服务端
### 请求更新个人资料
```json
{
  "type": "UPDATE_PROFILE",
  "payload": {
    "userId": "int",
    "username": "string",
    "password": "string",
    "email": "string",
    "avatar": "string"
  }
}
```
## 服务端->客户端
### 个人资料更新成功
```json
{
  "type": "PROFILE_UPDATED_SUCCESS",
  "payload": {
    "userId": "int",
    "username": "string",
    "password": "string",
    "email": "string",
    "avatar": "string"
  }
}
```
### 个人资料更新失败
```json
{
  "type": "PROFILE_UPDATED_SUCCESS",
  "payload": {
    "error": "string"
  }
}
```
# 联系人模块
## 客户端->服务端
### 请求加载联系人
```json
{
  "type": "LOAD_CONTACTS",
  "payload": {
    "userId": "int"
  }
}
```
### 请求搜索联系人
```json
{
  "type": "SEARCH_FOR_USER_BY_ID",
  "payload": {
    "userId": "int"
  }
}
```
```json
{
  "type": "SEARCH_FOR_USER_BY_NAME",
  "payload": {
    "username": "string"
  }
}
```
## 服务端->客户端
### 联系人已添加
```json
{
  "type": "CONTACT_ADDED",
  "payload": {
    "userId": "int",
    "username": "string",
    "online": "boolean",
    "avater": "string"
  }
}
```
### 联系人加载成功
```json
{
  "type": "CONTACTS_LOADED",
  "payload": {
    "contacts": [
      {
        "contactId": "int",
        "username": "string",
        "online": "boolean",
        "avatar": "string"
      },
      {
        "contactId": "int",
        "username": "string",
        "online": "boolean",
        "avatar": "string"
      },
      "..."
    ]
  }
}
```
### 联系人加载失败
```json
{
  "type": "CONTACTS_LOADED_FAILED",
  "payload": {
    "error": "string"
  }
}
```
### 搜索联系人结果
```json
{
  "type": "SEARCH_FOR_USER_RESULT",
  "payload": {
    "users": [
      {
        "contactId": "int",
        "username": "string",
        "avatar": "string"
      },{
        "contactId": "int",
        "username": "string",
        "avatar": "string"
      }
    ]
  }
}
```
# 好友请求模块
## 客户端->服务端
### 请求加载好友请求
```json
{
  "type": "LOAD_FRIEND_REQUEST",
  "payload": {
    "userId": "int"
  }
}
```
### 请求发送好友请求
```json
{
  "type": "ADD_FRIEND_REQUEST",
  "payload": {
    "id": "int",
    "requesterId": "int",
    "targetId": "int",
    "requesterUsername": "string",
    "targetUsername": "string",
    "requesterAvatar": "string",
    "targetAvatar": "string",
    "status": "string"
  }
}
```
### 请求拒绝好友请求
```json
{
  "type": "REFUSE_FRIEND_REQUEST",
  "payload": {
    "id": "int"
  }
}
```
### 请求同意好友请求
```json
{
  "type": "ACCEPT_FRIEND_REQUEST",
  "payload": {
    "id": "int"
  }
}
```
## 服务端->客户端
### 已加载好友请求
```json
{
  "type": "FRIEND_REQUESTS_LOADED",
  "payload": {
    "requestList": [
      {
        "id": "int",
        "requesterId": "int",
        "targetId": "int",
        "requesterUsername": "string",
        "targetUsername": "string",
        "requesterAvatar": "string",
        "targetAvatar": "string",
        "status": "string"
      }
    ]
  }
}
```
### 加载好友请求失败
```json
{
  "type": "FRIEND_REQUESTS_LOADED_FAILED",
  "payload": {
    "error": "string"
  }
}
```
### 服务端已收到好友请求
```json
{
  "type": "FRIEND_REQUEST_ADDED",
  "payload": {
    "id": "int",
    "requesterId": "int",
    "targetId": "int",
    "requesterUsername": "string",
    "targetUsername": "string",
    "requesterAvatar": "string",
    "targetAvatar": "string",
    "status": "string"
  }
}
```
### 服务端收到好友请求失败
```json
{
  "type": "FRIEND_REQUEST_ADDED_FAILED",
  "payload": {
    "error": "string"
  }
}
```
### 有新的好友请求
```json
{
  "type": "ADD_FRIEND_REQUEST",
  "payload": {
    "id": "int",
    "requesterId": "int",
    "targetId": "int",
    "requesterUsername": "string",
    "targetUsername": "string",
    "requesterAvatar": "string",
    "targetAvatar": "string",
    "status": "string"
  }
}
```
### 拒绝好友请求成功
```json
{
  "type": "FRIEND_REQUEST_REFUSED",
  "payload": {
    "id": "int"
  }
}
```
### 同意好友请求成功
```json
{
  "type": "FRIEND_REQUEST_ACCEPTED",
  "payload": {
    "id": "int"
  }
}
```
### 拒绝好友请求失败
```json
{
  "type": "FRIEND_REQUEST_REFUSED_FAILED",
  "payload": {
    "id": "int",
    "error": "string"
  }
}
```
### 同意好友请求失败
```json
{
  "type": "FRIEND_REQUEST_ACCEPTED_FAILED",
  "payload": {
    "id": "int",
    "error": "string"
  }
}
```
### 好友请求被拒绝
```json
{
  "type": "REFUSE_FRIEND_REQUEST",
  "payload": {
    "id": "int"
  }
}
 ```
### 好友请求被同意
```json
{
  "type": "ACCEPT_FRIEND_REQUEST",
  "payload": {
    "id": "int"
  }
}
 ```
### 
# 消息模块
## 客户端->服务端
### 请求发送普通消息
```json
{
  "type": "SEND_MESSAGE",
  "payload": {
    "messageId": "int",
    "senderId": "int",
    "receiverId": "int",
    "content": "string"
  }
}
```
### 请求发送文件
```json
{
  "type": "SEND_FILE",
  "payload": {
    "messageId": "int",
    "senderId": "int",
    "receiverId": "int",
    "fileName": "string",
    "fileContent": [
      "","","","","..."
    ]
  }
}
```
### 请求发送图片
```json
{
  "type": "SEND_IMAGE",
  "payload": {
    "messageId": "int",
    "senderId": "int",
    "receiverId": "int",
    "imageName": "string",
    "imageContent": [
      "","","","","..."
    ]
  }
}
```
### 请求加载消息
```json
{
  "type": "LOAD_MESSAGES",
  "payload": {
    "userId": "int",
    "targetId": "int"
  }
}
```
### 请求标记消息已读
```json
{
  "type": "MARK_READ",
  "payload": {
    "messageId": "int"
  }
}
```
### 请求清除消息记录
```json
{
  "type": "CLEAR_MESSAGES",
  "payload": {
    "requesterUserId": "int",
    "targetUserId": "int"
  }
}
```
## 服务端->客户端
### 接收到当前客户端发的消息
```json
{
  "type": "MESSAGE_RECEIVED_SELF",
  "payload": {
    "messageId": "int"
  }
}
```
### 接收到其他客户端给当前客户端发的消息
文本消息
```json
{
  "type": "MESSAGE_RECEIVED_OTHER",
  "payload": {
    "id": "int",
    "senderId": "int",
    "receiverId": "int",
    "content": "string",
    "timestamp": "string",
    "status": "string = sent",
    "type": "string = text"
  }
}
```
文件消息
```json
{
  "type": "MESSAGE_RECEIVED_OTHER",
  "payload": {
    "id": "int",
    "senderId": "int",
    "receiverId": "int",
    "content": "string",
    "timestamp": "string",
    "status": "string = sent",
    "type": "string = file"
  }
}
```
图片消息
```json
{
  "type": "MESSAGE_RECEIVED_OTHER",
  "payload": {
    "id": "int",
    "senderId": "int",
    "receiverId": "int",
    "content": "string",
    "timestamp": "string",
    "status": "string = sent",
    "type": "string = image"
  }
}
```
### 消息加载成功
```json
{
  "type": "MESSAGES_LOADED",
  "payload": [
    {
      "id": "int",
      "senderId": "int",
      "receiverId": "int",
      "content": "string",
      "timestamp": "string",
      "status": "string = sent",
      "type": "string = text"
    },
    {
      "id": "int",
      "senderId": "int",
      "receiverId": "int",
      "content": "string",
      "timestamp": "string",
      "status": "string = sent",
      "type": "string = file"
    },
    {
      "id": "int",
      "senderId": "int",
      "receiverId": "int",
      "content": "string",
      "timestamp": "string",
      "status": "string = sent",
      "type": "string = image"
    }
  ]
}
```
### 消息记录已清除
```json
{
  "type": "MESSAGE_RECEIVED_OTHER",
  "payload": {
    "userId": "int",
    "targetUserId": "int"
  }
}
```
