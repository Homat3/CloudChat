import { common } from "@kit.AbilityKit";

@Component
/**
 * 聊天人项组件，便于实现聊天人相关业务
 */
export struct ContactItem{
    // 状态变量

    // 上下文
    private uiContext: UIContext = this.getUIContext();
    private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

    build(){

    }
}