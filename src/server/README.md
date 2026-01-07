## 一、项目基础信息
1. **项目简介**
    - CloudChat 云聊 - 服务端

2. **项目编写环境**
    - 语言：C++ 17
    - 操作系统：Ubuntu 24.04 LTS
    - 编译器：g++
    - 构建工具：GNU make
    - 依赖库：libboost-dev、libboost-system-dev、libwebsocketpp-dev、libmysqlcppconn-dev

---

## 二、项目环境配置
1. **仓库克隆**
    ```bash
    # 通过 Git 工具克隆到本地
    git clone https://gitlab.omniedu.com/root/D2xn61EZeEB82.git
    ```
    你会在当前目录下看到一个名为 D2xn61EZeEB82 的文件夹，方便起见，建议将其重命名为 CloudChat。
   
2. **打开本子项目所在文件夹**

    打开 CloudChat/src/server。

3. **安装依赖库**
    ```bash
    sudo apt install libboost-dev libboost-system-dev libwebsocketpp-dev libmysqlcppconn-dev
    ```

4. **编辑配置信息**

    默认配置信息编写在代码中，如需自定义，则在 config.json 文件中编辑。

5. **测试运行**

    进入 makefile 文件所在目录，执行命令
    ```bash
    make
    ```
    进行构建，成功完成构建后该目录下将生成可执行文件 cloudchat_server，即服务端主程序，执行命令
    ```bash
    ./cloudchat_server
    ```
    进行前台启动，如需后台启动，则执行
    ```bash
    nohup ./cloudchat_server &
    ```
    测试结束后，执行
    ```bash
    make clean
    ```
    清除所有构建过程中生成的文件（包括可执行文件和 .o 文件）。

---

## 三、工程结构说明
```
CloudChat/
├─ README.md
├─ 登录业务逻辑.md
├─ 注册业务逻辑.md
├─ 聊天消息收发业务逻辑.md
├─ …（其他业务文档）
└─ src/                                 # 总源文件
    ├─ client/                          # 鸿蒙客户端子项目
    └─ server/
        ├─ config.json
        ├─ makefile
        ├─ README.md                    # 说明文档（本文档）
        ├─ include/
        │  ├─ cloudchatdat.h
        │  ├─ cloudchatgroup.h
        │  ├─ cloudchatmsg.h
        │  ├─ cloudchatuser.h
        │  ├─ cloudchatsys.h
        │  └─ cloudchatservice.h
        └─ src/
            ├─ cloudchatdat.cpp
            ├─ cloudchatgroup.cpp
            ├─ cloudchatmsg.cpp
            ├─ cloudchatuser.cpp
            ├─ cloudchatsys.cpp
            ├─ cloudchatservice.cpp
            └─ main.cpp
```

---

## 四、参考文档
1. **WebSocket++**
    - [WebSocket++ Documentation](https://docs.websocketpp.org/)

2. **MySQL Connector/C++**
    - [MySQL Connector/C++ 9.0 开发者指南](https://dev.mysqlserver.cn/doc/connector-cpp/9.0/en/)