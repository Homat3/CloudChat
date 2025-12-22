# 项目说明

仓库地址：https://github.com/Homat3/CloudChat

# 项目进度

本项目从2025年11月14日开始，预计于2025年12月16日完成所有任务。

## 进度表
---

### 1. 项目进度表

| 阶段 | 时间周期 | 任务模块 | 详细内容与里程碑 | 主要负责人 | 状态 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **P1** | 11.14 - 11.15 | **项目初始化** | • 初始化 Web 端架构<br>• 清理默认文件与环境配置<br>• 编写 README 文档 | Infinomat | ✅ 完成 |
| **P2** | 11.21 - 11.28 | **框架与协议设计** | • 搭建服务端初始化框架（DB、User类）<br>• 制定初步通信协议<br>• 搭建服务端消息接收框架 | PeterWinchester<br>Infinomat | ✅ 完成 |
| **P3** | 12.01 - 12.05 | **数据库与认证系统** | • 建立数据库表（Users, Friends, Messages）<br>• 实现注册、登录（含 Token 登录）<br>• 客户端登录模块 UI 与逻辑 | PeterWinchester<br>quenquenwhynot<br>Infinomat | ✅ 完成 |
| **P4** | 12.06 - 12.08 | **基础消息与搜索** | • 消息系统基础框架完成<br>• 全局联系人搜索与监听<br>• 用户信息与头像显示 | Infinomat<br>Jsion-908<br>PeterWinchester | ✅ 完成 |
| **P5** | 12.10 - 12.11 | **社交关系链管理** | • 好友添加功能（请求收发、状态维护）<br>• 联系人列表优化（在线状态、自动刷新）<br>• 个人资料修改与头像更新机制 | PeterWinchester<br>Infinomat | ✅ 完成 |
| **P6** | 12.12 - 12.13 | **核心聊天业务** | • 聊天消息收发完整逻辑闭环<br>• 消息已读标记修复<br>• 邮箱验证修复 | Infinomat<br>PeterWinchester | ✅ 完成 |
| **P7** | 12.18 | **文档与收尾** | • 文档结构整理<br>• 阶段性代码合并 | Infinomat | ✅ 完成 |

---

### 2. 项目进度甘特图 (Mermaid)

```mermaid
gantt
    title CloudChat 项目开发进度甘特图 (2025)
    dateFormat  YYYY-MM-DD
    axisFormat  %m-%d
    excludes    weekends

    section 初始化阶段
    项目Init & 环境配置       :done, init, 2025-11-14, 2025-11-15
    UI初步更新               :done, ui1, 2025-11-21, 1d

    section 架构与协议
    服务端框架搭建           :done, server1, 2025-11-28, 2d
    通信协议制定             :done, proto, 2025-11-28, 2025-12-03
    数据库建表               :done, db, 2025-12-01, 1d

    section 核心功能开发
    注册与登录业务           :done, auth, 2025-12-01, 2025-12-07
    消息系统基础             :done, msg_base, 2025-12-06, 2d
    搜索与用户资料           :done, user_info, 2025-12-08, 2025-12-09

    section 社交与聊天优化
    好友添加与状态管理       :done, friends, 2025-12-10, 2025-12-11
    界面修复与体验优化       :done, ui_fix, 2025-12-10, 2025-12-11
    完整聊天收发逻辑         :done, chat_full, 2025-12-12, 2025-12-13
    Bug修复(邮箱/已读)       :crit, bugfix, 2025-12-13, 1d

    section 文档与维护
    文档结构整理             :active, docs, 2025-12-18, 1d
```
