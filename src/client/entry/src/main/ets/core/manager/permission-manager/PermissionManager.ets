import { abilityAccessCtrl, common, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import {
  NoSuchPermissionError,
  NoSuchPermissionGroupError,
  PermissionCheckFailedError,
  PermissionGroupAlreadyExistError,
  PermissionManagerError
} from './PermissionManagerError';
import bundleManager from '@ohos.bundle.bundleManager';


/**
 * @description permission 管理器 负责处理页面切换
 * @author Infinomat
 */
export class PermissionManager {
  private atManager: abilityAccessCtrl.AtManager;
  private context: common.UIAbilityContext;
  private permissionGroupMap: Map<string, Permissions[]> = new Map;

  /**
   * @description permission 管理器构造函数
   * @author Infinomat
   * @param context 类型: {@see common.UIAbilityContext} 代表: Ability 运行上下文
   * @param atManager 类型: {@see abilityAccessCtrl.AtManager} 代表: Ability 运行权限控制器
   */
  constructor(context: common.UIAbilityContext, atManager: abilityAccessCtrl.AtManager) {
    this.atManager = atManager;
    this.context = context;
  }

  /**
   * @description 添加新的权限组 当某模块需要用到一些基本权限中没有的特殊权限时，可以为这个模块添加一个权限组
   * @author Infinomat
   * @param groupName 类型: string 代表: 权限组名称(这是权限组的唯一标识符，不可重复)
   * @param permissions 类型: {@see Permissions}[] 代表: 权限组中的各个权限
   * @example
  * ...(假定有一个 PermissionManager 对象 manager)
   * // 现在添加一个权限组 myGroup, 里面有一个权限为 ohos.permission.INTERNET
   * manager.putPermissionGroup("myGroup", new Array('ohos.permission.INTERNET')); // 也可以写成列表形式
   * ...
   */
  public putPermissionGroup(groupName: string, permissions: Permissions[]) {
    if (this.permissionGroupMap.has(groupName)) {
      throw new PermissionGroupAlreadyExistError(groupName);
    } else {
      this.permissionGroupMap.set(groupName, permissions);
    }
  }

  /**
   * @description 向用户请求所有权限组的权限
   * @author Infinomat
   * @throws PermissionRequestFailedError 因为一些离奇问题导致权限申请失败时抛出
   * @throws NoSuchPermissionGroupError groupName 参数未在 {@see putPermissionGroup} 中定义时抛出
   */
  public async requestAllPermissions() {
    for (let group of this.permissionGroupMap.keys()) {
      await this.requestPermissionGroup(group);
    }
  }

  /**
   * @description 向用户请求特定权限组的权限
   * @author Infinomat
   * @param groupName 类型: string 代表: 权限组名称(在 {@see putPermissionGroup} 中定义的那个)
   * @throws PermissionRequestFailedError 因为一些离奇问题导致权限申请失败时抛出
   * @throws NoSuchPermissionGroupError groupName 参数未在 {@see putPermissionGroup} 中定义时抛出
   */
  public async requestPermissionGroup(groupName: string) {
    const permissions = this.permissionGroupMap.get(groupName);
    if (permissions) {
      const result = await this.atManager.requestPermissionsFromUser(this.context, permissions);
      this.handlePermissionsRequestResult(result, permissions);
    } else {
      throw new NoSuchPermissionGroupError(groupName);
    }
  }

  /**
   * @description 向用户请求特定权限
   * @author Infinomat
   * @param permission 类型: {@see Permissions} 代表: 权限名称
   * @throws PermissionRequestFailedError 因为一些离奇问题导致权限申请失败时抛出
   * @throws NoSuchPermissionError 请求权限未知时抛出
   * @throws PermissionManagerError 因为一些离奇问题导致权限申请结果无法解析时抛出
   */
  public async requestPermission(permission: Permissions) {
    const result = await this.atManager.requestPermissionsFromUser(this.context, [permission]);
    this.handlePermissionsRequestResult(result, [permission]);
  }

  /**
   * @description 检查特定权限是否已获批准
   * @author Infinomat
   * @param permission 类型: {@see Permissions} 代表: 权限名称
   * @throws PermissionCheckFailedError 因为一些离奇问题导致权限无法查看时抛出
   */
  public isPermissionApproved(permission: Permissions): boolean {
    // 获取应用唯一标识 tokenID
    const bundleInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    const tokenID = bundleInfo.appInfo.accessTokenId;

    // 检查权限
    try {
      const status = this.atManager.checkAccessTokenSync(tokenID, permission);
      return (status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED);
    } catch (error) {
      throw new PermissionCheckFailedError(error);
    }
  }

  /**
   * @description 处理权限请求结果
   * @author Infinomat
   * @param result 类型: {@see PermissionRequestResult} 代表: 权限请求结果
   * @param permissions 类型: {@see Permissions}[] 代表: 对应的权限列表
   * @throws NoSuchPermissionError 请求权限未知时抛出
   * @throws PermissionManagerError 因为一些离奇问题导致权限申请结果无法解析时抛出
   */
  private handlePermissionsRequestResult(result: PermissionRequestResult, permissions: Permissions[]) {
    for (let i = 0; i < result.authResults.length; i++) {
      switch (result.authResults[i]) {
        case 0:
          console.info("Permission \"" + permissions[i] + "\" has been approved");
          break;
        case -1:
          console.info("Permission \"" + permissions[i] + "\" has been denied");
          break;
        case 2:
          throw new NoSuchPermissionError(permissions[i]);
          break;
        default:
          throw new PermissionManagerError("Unknown Error");
      }
    }
  }
}