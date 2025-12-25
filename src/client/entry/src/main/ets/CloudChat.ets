import { common } from '@kit.AbilityKit';
import { User } from './core/models/models';

/**
 * @description CloudChat 全局属性
 */
export class CloudChat{
  private static contexts = new Map<string, object>();
  private static _currentUser: User | null = null;

  public static get currentUser(){
    return CloudChat._currentUser;
  }

  public static set currentUser(user: User | null){
    CloudChat.currentUser = user;
  }

  public static getContext(key: string): object | undefined {
    return CloudChat.contexts.get(key);
  }

  public static setContext(key: string, value: object): void {
    CloudChat.contexts.set(key, value);
  }
}