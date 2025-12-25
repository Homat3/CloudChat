import { common } from '@kit.AbilityKit';
import { ColorResourceLoadError, FloatResourceLoadError, StringResourceLoadError } from './error/ResourceLoadError';

/**
 * @description 从资源文件加载文本资源
 * @author Infinomat
 * @param context 类型: {@see common.UIAbilityContext} 代表: UIAbility 的上下文
 * @param resource 类型: {@see Resource} 代表: 文本资源
 * @returns 类型: string 代表: 加载到的文本数据
 */
export function loadStringResource(context: common.UIAbilityContext, resource: Resource): string{
  try {
    return context.resourceManager.getStringSync(resource.id);
  } catch (error) {
    throw new StringResourceLoadError(resource.moduleName);
  }
}

/**
 * @description 从资源文件加载颜色资源
 * @author Infinomat
 * @param context 类型: {@see common.UIAbilityContext} 代表: UIAbility 的上下文
 * @param resource 类型: {@see Resource} 代表: 颜色资源
 * @returns 类型: string 代表: 加载到的颜色数据
 */
export function loadColorResource(context: common.UIAbilityContext, resource: Resource): string{
  try {
    return context.resourceManager.getStringSync(resource.id);
  } catch (error) {
    throw new ColorResourceLoadError(resource.moduleName);
  }
}

/**
 * @description 从资源文件加载浮点资源
 * @author Infinomat
 * @param context 类型: {@see common.UIAbilityContext} 代表: UIAbility 的上下文
 * @param resource 类型: {@see Resource} 代表: 浮点资源
 * @returns 类型: string 代表: 加载到的浮点数据
 */
export function loadFloatResource(context: common.UIAbilityContext, resource: Resource): string{
  try {
    return context.resourceManager.getStringSync(resource.id);
  } catch (error) {
    throw new FloatResourceLoadError(resource.moduleName);
  }
}