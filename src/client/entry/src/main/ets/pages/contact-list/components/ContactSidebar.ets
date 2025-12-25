import { ContactItem } from "./ContactItem";
import { common } from "@kit.AbilityKit";

@Component
/**
 * 左侧联系人栏
 */
export struct ContactSidebar{
  // 状态变量

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  build(){

  }

}