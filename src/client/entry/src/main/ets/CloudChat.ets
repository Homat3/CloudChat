import { common } from '@kit.AbilityKit';
import { Message, TextMessage } from './core/models/message';
import { Contact, User } from './core/models/models';

/**
 * @description CloudChat 全局属性
 */
export class CloudChat{
  private static _currentUser: User | null = null;
  private static _messageMap: Map<number, Message[]>;
  private static _contactList: Contact[];

  public static get currentUser(){
    return CloudChat._currentUser;
  }

  public static set currentUser(user: User | null){
    CloudChat._currentUser = user;
  }

  public static get messageMap(){
    return CloudChat._messageMap;
  }

  public static set messageMap(messageMap: Map<number, Message[]>){
    CloudChat._messageMap = messageMap;
  }

  public static get contacts() {
    return CloudChat._contactList;
  }

  public static set contacts(contacts: Contact[]){
    CloudChat._contactList = contacts;
  }
}