# 项目基础信息
1. **项目简介**
    - CloudChat 云聊 - 服务端

2. **项目编写环境**
    - 语言/标准/版本/运行操作系统（待编写）

---

### 二、项目环境配置
1. **仓库克隆**
    ```bash
    # 通过 Git 工具克隆到本地
    git clone https://gitlab.omniedu.com/root/D2xn61EZeEB82.git
    ```
    你会在当前目录下看到一个名为 D2xn61EZeEB82 的文件夹，方便起见，建议将其重命名为 CloudChat。
   
2. **打开本子项目所在文件夹**
    打开 CloudChat\src\server。

3. **（中间的步骤）**
    （待编写）

4. **测试运行**(待编写)
    执行命令...
    ```bash
    # 通过 Git 工具克隆到本地
    git clone https://gitlab.omniedu.com/root/D2xn61EZeEB82.git
    ```

---

**三、工程结构说明**
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
        │  └─ ...
        └─ src/
            ├─ cloudchatdat.cpp
            ├─ cloudchatgroup.cpp
            ├─ cloudchatmsg.cpp
            ├─ cloudchatuser.cpp
            └─ main.cpp
```

---

**四、参考文档**
1. **CPP Websocket**
    - [文档名](文档链接)