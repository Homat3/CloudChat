import { common } from "@kit.AbilityKit";

@Component
/**
 * 右侧：此组件为详情面板
 * ===============
 * 加上此组件就是把页面设计成： 联系人|消息页面|详情组件
 * 也可以不要这个组件，就是左右布局的两个组件
 */
export struct DetailPanel{
  // 状态变量

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  build(){

  }
}