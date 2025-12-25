import { common } from "@kit.AbilityKit";

@Component
/**
 * 消息项组件，把处理消息的功能提取出来
 * ==============================
 */
export struct MessageItem{
  // 状态变量

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  build() {

  }
}