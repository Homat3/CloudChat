CloudChat 服务端 数据流说明

- 文件: server_dataflow.svg
- 目的: 可视化服务端中 HTTP 与 WebSocket 两种协议的数据处理路径、WebSocket 通知路径以及与数据库的交互。

主要路径与组件说明：

1. Client
   - ArkUI 客户端通过 HTTP 或 WebSocket 与服务器交互。

2. HTTP Handler
   - 处理一次性请求/响应：登录、注册、文件上传、查询等。
   - 相关实现/调用链可在 `src/server/src` 中找到，主要由 `cloudchatservice.cpp` 的 HTTP 部分处理。

3. WebSocket Handler
   - 处理长连接消息收发：接收客户端实时消息、心跳、订阅等；负责向客户端推送通知。
   - 相关文件: `cloudchatmsg.cpp`、`server.websocket` 相关实现。

4. Main / Dispatcher
   - `main.cpp` 负责启动服务器、监听端口并分发收到的协议请求到 Service 层。

5. Service 层
   - `cloudchatservice.cpp` / `cloudchatsys.cpp` 实现业务逻辑：消息路由、会话管理、权限校验、群组处理等。

6. Message / Group 处理
   - `cloudchatmsg.cpp` 与 `cloudchatgroup.cpp` 负责消息格式、转发规则与群组广播。

7. 数据层 / 持久化
   - `cloudchatdat.cpp` / `cloudchatrecord.cpp` 负责与数据库或文件系统的读写：消息历史、用户信息、好友关系等。

8. DB / 外部存储
   - 可以是 MySQL / SQLite / 本地文件系统等，用于持久化存储。

通知流程示例：
- 客户端 A 通过 WS 发送一条消息到服务器 -> WebSocket Handler 接收并转给 Service 层 -> Service 保存到数据层并写入 DB -> Service 调用消息层查找目标客户端连接 -> 通过 WebSocket 将消息推送到目标客户端 B。

HTTP 请求示例：
- 客户端 发起文件上传/查询等 HTTP 请求 -> HTTP Handler 处理并调用 Service -> Service 与 Data Layer 交互 -> 返回 HTTP 响应。

如何生成 PNG（可选）：

```bash
# 使用 Inkscape
inkscape server_dataflow.svg --export-type=png --export-filename=server_dataflow.png

# 或使用 rsvg-convert
rsvg-convert -o server_dataflow.png server_dataflow.svg
```

文件位置: [src/server/architecture](../architecture)
