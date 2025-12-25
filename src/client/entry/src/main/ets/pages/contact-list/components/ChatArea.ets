import { MessageItem } from "./MessageItem";
import { common } from "@kit.AbilityKit";

@Component
/**
 * 中间的聊天界面
 */
export struct ChatArea{
  // 状态变量

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  build(){

  }
}