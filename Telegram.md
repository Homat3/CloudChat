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
### 请求添加联系人
```json
{
  "type": "ADD_CONTACT",
  "payload": {
    "userId": "int",
    "targetId": "int"
  }
}
```
### 请求删除联系人
```json
{
  "type": "DELETE_CONTACT",
  "payload": {
    "userId": "int",
    "targetId": "int"
  }
}
```
## 服务端->客户端
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
### 联系人添加成功
```json
{
  "type": "CONTACT_ADDED",
  "payload": {
    "contactId": "int",
    "userName": "string",
    "online": "boolean",
    "avatar": "string"
  }
}
```
### 联系人添加失败
```json
{
  "type": "CONTACT_ADDED_FAILED",
  "payload": {
    "error": "string"
  }
}
```
### 联系人删除成功
```json
{
  "type": "CONTACT_DELETED",
  "payload": {}
}
```
### 联系人删除失败
```json
{
  "type": "CONTACT_DELETED_FAILED",
  "payload": {
    "error": "string"
  }
}
```
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
