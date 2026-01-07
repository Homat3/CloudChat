# 项目基础信息
1. **项目简介**
    - CloudChat 云聊 - 鸿蒙客户端
    - 与 Web 客户端通用服务端

2. **项目编写套件**
    - API Version 21
    - Compatible SDK 6.0.0(20)
    - 建议不要低于这两个版本

---

### 二、项目环境配置
1. **仓库克隆**
   ```bash
   # 通过 Git 工具克隆到本地
   git clone https://gitlab.omniedu.com/root/D2xn61EZeEB82.git
   ```
   你会在当前目录下看到一个名为 D2xn61EZeEB82 的文件夹，方便起见，建议将其重命名为 CloudChat。
   
2. **在开发 IDE 中打开本子项目所在文件夹**
   使用 DevStudio 打开 CloudChat\src\client。

3. **等待 IDE 自动构建项目**
   DevStudio 会自动检测构建相关文件并执行构建命令。

4. **测试运行**
   - 启动 DevStudio 集成的 HUAWEI 虚拟机，或自行连接实体机。（要求版本 API >= 6.0.0(20)）
   - 配置选择默认配置 entry 点击启动按钮即可启动。

---

**三、工程结构说明**
```
CloudChat/
├─ README.md
├─ 登录业务逻辑.md
├─ 注册业务逻辑.md
├─ 聊天消息收发业务逻辑.md
├─ …（其他业务文档）
└─ src/                             # 总源文件
   ├─ client/                       # 鸿蒙客户端子项目
   │  ├─ .gitignore
   │  ├─ build-profile.json5        # 构建配置文件
   │  ├─ oh-package.json5           # 项目包构建结构文件
   │  ├─ README.md                  # 说明文档（本文档）
   │  ├─ AppScope/                  # 全局配置文件
   │  │  ├─ app.json5               # 全局配置
   │  │  └─ resources/              # 全局资源
   │  ├─ entry/                     # 主模块
   │  │  ├─ oh-package.json5        # 主模块项目包构建结构文件
   │  │  ├─ build-profile.json5     # 主模块构建配置文件
   │  │  ├─ obfuscation-rules.txt
   │  │  ├─ build/                  # 构建输出
   │  │  └─ src/                    # 主模块代码文件
   │  │     ├─ main/                # ArkTs 源码
   │  │     │  ├─ CloudChat.ets     # 应用全局属性
   │  │     │  ├─ core/             # 应用运行内核
   │  │     │  ├─ entryability/     # 应用主 Ability 逻辑
   │  │     │  └─ pages/            # 应用 UI
   │  │     └─ resources/           # 主模块资源文件
   │  │        ├─ base/             # 基础资源
   │  │        ├─ dark/             # 深色模式资源
   │  │        └─ zh_CN/            # 中文资源
   │  ├─ hvigor/
   │  └─ oh_modules/
   └─ server/
```

---

**四、参考文档**
1. **ArkTs语言文档**
    - [官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/learning-arkts)

2. **HarmonyOS 6开发文档**
    - [官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/application-dev-overview)

3. **ArkUI开发文档**
    - [官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkui-overview)

4. **Coze 智能体 API 使用文档**
    - [官方文档](https://www.coze.cn/open/docs/developer_guides/preparation)