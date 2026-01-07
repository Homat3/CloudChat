UI 路由结构说明

- 文件: ui_routing.svg
- 目的: 可视化 `Tab` 控件（直接路由控制）与 `EventBus`（通过 boolean 属性控制组件可见性）之间的关系。

关键点与文件位置：

- 入口与容器:
  - `CloudChat.ets`: [entry/src/main/ets/CloudChat.ets](../entry/src/main/ets/CloudChat.ets)
  - `MainContainer`: [entry/src/main/ets/pages/main/MainContainer.ets](../entry/src/main/ets/pages/main/MainContainer.ets)

- Tab 与页面:
  - `MainContainer` 内的 Tab 控件直接切换渲染页面（例如 Home / Chat / Own / AI）
  - 页面文件示例:
    - Home: [entry/src/main/ets/pages/main/home/Home.ets](../entry/src/main/ets/pages/main/components/home/Home.ets)
    - Chat: [entry/src/main/ets/pages/main/components/chat/ChatArea.ets](../entry/src/main/ets/pages/main/components/chat/ChatArea.ets)
    - Own: [entry/src/main/ets/pages/main/own/OwnPage.ets](../entry/src/main/ets/pages/main/components/own/OwnPage.ets)
    - AI: [entry/src/main/ets/pages/main/components/ai-chat/AiPage.ets](../entry/src/main/ets/pages/main/components/ai-chat/AiPage.ets)

- EventBus (跨组件事件通信):
  - 实现文件: [entry/src/main/ets/service/event/EventBus.ets](../entry/src/main/ets/core/service/event/EventBus.ets)
  - 用法: 页面或组件发布事件，订阅者接收后切换本地 boolean 状态（例如 `showDetail`, `showRequestPanel`），以控制弹窗/面板可见性。

- 例子: 当 ChatArea 需要打开消息详情时，发布 `show-detail` 事件；DetailPanel 订阅该事件并将 `showDetail = true`，从而显示面板。

如何生成 PNG（可选）：

```bash
inkscape ui_routing.svg --export-type=png --export-filename=ui_routing.png
rsvg-convert -o ui_routing.png ui_routing.svg
```

文件位置: [src/client/architecture](../architecture)
