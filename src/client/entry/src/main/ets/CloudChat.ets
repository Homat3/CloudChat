import { common } from '@kit.AbilityKit';
import { Message, TextMessage } from './core/models/message';
import { Contact, User } from './core/models/models';

/**
 * @description CloudChat 全局属性
 */
export class CloudChat{
  private static _currentUser: User | null = null;
  private static _contactList: Contact[];

  public static get currentUser(){
    return CloudChat._currentUser;
  }

  public static set currentUser(user: User | null){
    CloudChat.currentUser = user;
  }

  /**
   * 模拟获取联系人列表
   */
  public static get contacts() {
    return CloudChat._contactList;
  }

  public static set contacts(contacts: Contact[]){
    CloudChat._contactList = contacts;
  }

  /**
   * 模拟获取某个联系人的消息记录
   */
  public static async getMessages(contactId: number): Promise<Message[]> {
    return new Promise((resolve) => {
      // // 模拟一些历史消息
      // const msgs: Message[] = [
      //   new TextMessage(Date.now() - 100000, contactId, 999, "你好，最近怎么样？", "", "sent"),
      //   new TextMessage(Date.now() - 80000, 999, contactId, "挺好的，你呢？", "", "read"),
      // ];
      // resolve(msgs);
    });
  }

  /**
   * 发送消息
   */
  public static async sendMessage(msg: Message): Promise<boolean> {
    return new Promise((resolve) => {
      setTimeout(() => {
        console.log(`[CloudChat] Message Sent: ${msg.content}`);
        resolve(true);
      }, 300);
    });
  }
}