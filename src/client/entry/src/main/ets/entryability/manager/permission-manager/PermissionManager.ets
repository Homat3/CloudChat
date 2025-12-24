import { abilityAccessCtrl, Permissions, common, PermissionRequestResult } from "@kit.AbilityKit";
import {
  PermissionRequestFailedError,
  NoSuchPermissionGroupError,
  PermissionCheckFailedError,
  NoSuchPermissionError,
  PermissionManagerError,
  PermissionGroupAlreadyExistError
} from "./PermissionManagerError";
import bundleManager from '@ohos.bundle.bundleManager';

// permission 管理器 负责处理应用权限
export class PermissionManager{
  private atManager: abilityAccessCtrl.AtManager;
  private context: common.UIAbilityContext;

  private permissionGroupMap: Map<string, Permissions[]> = new Map;

  constructor(context: common.UIAbilityContext, atManager: abilityAccessCtrl.AtManager) {
    this.atManager = atManager;
    this.context = context;
  }

  public putPermissionGroup(groupName: string, permissions: Permissions[]){
    if (this.permissionGroupMap.has(groupName)){
      throw new PermissionGroupAlreadyExistError(groupName);
    }
    else this.permissionGroupMap.set(groupName, permissions);
  }

  public requestAllPermissions(){
    for (let group of this.permissionGroupMap.keys()){
      this.requestPermissionGroup(group);
    }
  }

  public requestPermissionGroup(groupName: string){
    const permissions = this.permissionGroupMap.get(groupName);
    if (permissions){
      this.atManager.requestPermissionsFromUser(this.context, permissions)
        .then((result) => {
          this.handlePermissionsRequestResult(result, permissions);
        })
        .catch((err: Error) => {
          throw new PermissionRequestFailedError(err.name + ": " + err.message);
        });
    }
    else throw new NoSuchPermissionGroupError(groupName);
  }

  public requestPermission(permission: Permissions){
    this.atManager.requestPermissionsFromUser(this.context, [permission])
      .then((data) => {
        console.info("权限申请结果：" + JSON.stringify(data));
      })
      .catch((err: Error) => {
        throw new PermissionRequestFailedError(err.name + ": " + err.message);
      });
  }

  private handlePermissionsRequestResult(result: PermissionRequestResult, permissions: Permissions[]){
    for (let i = 0; i < result.authResults.length; i++){
      switch (result.authResults[i]){
        case 0:
          console.info("Permission \"" + permissions[i] + "\" has been approved");
          break;
        case -1:
          console.info("Permission \"" + permissions[i] + "\" has been denied");
          break;
        case 2:
          throw new NoSuchPermissionError(permissions[i]);
          break;
        default :
          throw new PermissionManagerError("Unknown Error");
      }
    }
  }

  public isPermissionApproved(permission: Permissions): boolean{
    // 获取应用唯一标识 tokenID
    const bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    const tokenID = bundleInfo.appInfo.accessTokenId;

    // 检查权限
    try {
      const status = this.atManager.checkAccessTokenSync(tokenID, permission);
      return (status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED);
    } catch (error) {
      throw new PermissionCheckFailedError(error);
    }
  }
}