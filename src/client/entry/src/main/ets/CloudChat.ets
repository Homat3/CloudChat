import { common } from '@kit.AbilityKit';
import { Message, TextMessage } from './core/models/message';
import { Contact, User } from './core/models/models';

/**
 * @description CloudChat 全局属性
 */
export class CloudChat{
  private static _currentUser: User | null = null;
  private static _messageMap: Map<number, Message[]>;
  private static _messageMapBuilder: Map<number, Message[]> | null = null;
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

  public static get contacts() {
    return CloudChat._contactList;
  }

  public static set contacts(contacts: Contact[]){
    CloudChat._contactList = contacts;
  }

  public static startLoadMessage(){
    if (CloudChat._messageMapBuilder){
      throw new Error("Not start loading, call endLoadMessage first");
    }
    else {
      CloudChat._messageMapBuilder = new Map();
    }
  }

  public static addMessagesOfContact(messages: Message[]){
    if (CloudChat._messageMapBuilder){
      if (CloudChat.currentUser){
        const contactId = messages[0].senderId === CloudChat.currentUser.userId ? messages[0].receiverId : messages[0].senderId;
        for (const message of messages) {
          if (message.senderId === contactId || message.receiverId === contactId){
            const contactMessages = CloudChat._messageMapBuilder.get(contactId);
            if (contactMessages) {
              contactMessages.push(message);
            }
            else {
              CloudChat._messageMapBuilder.set(contactId, [message]);
            }
          }
          else {
            throw new Error("Multiple contact id");
          }
        }
      }
      else {
        throw new Error("No user");
      }
    }
    else {
      throw new Error("Not start loading, call startLoadMessage first");
    }
  }

  public static endLoadMessage(){
    if (CloudChat._messageMapBuilder){
      CloudChat._messageMap = CloudChat._messageMapBuilder;
      CloudChat._messageMapBuilder = null;
    }
    else {
      throw new Error("Not start loading, call startLoadMessage first");
    }
  }
}