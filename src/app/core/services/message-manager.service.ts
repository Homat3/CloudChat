import { Injectable } from '@angular/core';
import { Message, MessageImpl } from '../models/message';
import { Contact } from '../../components/contact-list/contact-list.component';

@Injectable({
  providedIn: 'root'
})
export class MessageManagerService {
  private messagesByContact: Map<number, Message[]> = new Map();

  constructor() {
    this.initializeSampleMessages();
  }

  getMessages(contactId: number): Message[] {
    if (!this.messagesByContact.has(contactId)) {
      this.messagesByContact.set(contactId, []);
    }
    return this.messagesByContact.get(contactId) || [];
  }

  addMessage(contactId: number, message: Message): void {
    if (!this.messagesByContact.has(contactId)) {
      this.messagesByContact.set(contactId, []);
    }
    this.messagesByContact.get(contactId)?.push(message);
  }

  createMessage(
    contactId: number,
    sender: 'me' | 'other',
    content: string,
    status: 'sending' | 'sent' | 'read' = 'sent',
    type: 'text' | 'image' | 'file' = 'text'
  ): Message {
    const messages = this.getMessages(contactId);
    const id = messages.length > 0 ? Math.max(...messages.map(m => m.id)) + 1 : 1;
    const timestamp = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    return new MessageImpl(id, sender, content, timestamp, status, type);
  }

  receiveMessage(contactId: number, content: string): Message {
    const message = this.createMessage(contactId, 'other', content, 'sent', 'text');
    this.addMessage(contactId, message);
    return message;
  }

  requireLoadMessage(contactId: number): void {
    // TODO: 向服务器发出加载消息请求
    // TODO: 回调updateMessage
  }

  requireClearMessages(contactId: number): void {
    // TODO: 向服务器发出清除消息请求
    // TODO: 回调clearMessages
  }

  clearMessages(contactId: number): void {
    this.messagesByContact.set(contactId, []);
  }

  getUnreadCount(contactId: number): number {
    const messages = this.getMessages(contactId);
    return messages.filter(m => m.status === 'sent' && m.sender === 'other').length;
  }

  updateMessages(contactId: number, messages: Message[]){
    this.messagesByContact.set(contactId, messages);
  }

  private initializeSampleMessages(): void {
    // TODO: requireLoadMessage
    this.messagesByContact.set(1, [
      new MessageImpl(1, 'other', '你好，今天怎么样？', '10:25', 'sent', 'text'),
      new MessageImpl(2, 'me', '我很好，谢谢！你呢？', '10:26', 'sent', 'text'),
      new MessageImpl(3, 'other', '我也很好，有个项目想和你讨论一下', '10:28', 'sent', 'text'),
      new MessageImpl(4, 'me', '好的，你说吧', '10:30', 'sent', 'text')
    ]);

    this.messagesByContact.set(2, [
      new MessageImpl(1, 'other', '这个需求有点复杂', '昨天', 'sent', 'text'),
      new MessageImpl(2, 'me', '我们可以分步骤实现', '昨天', 'sent', 'text')
    ]);

    this.messagesByContact.set(3, [
      new MessageImpl(1, 'other', '好的，我看看', '12:40', 'sent', 'text'),
      new MessageImpl(2, 'me', '有什么问题随时联系我', '12:42', 'sent', 'text'),
      new MessageImpl(3, 'other', '明白，谢谢', '12:45', 'sent', 'text')
    ]);

    this.messagesByContact.set(4, [
      new MessageImpl(1, 'other', '会议时间改了吗？', '09:10', 'sent', 'text'),
      new MessageImpl(2, 'me', '没有，还是下午2点', '09:12', 'sent', 'text'),
      new MessageImpl(3, 'other', '好的，我会准时参加', '09:15', 'sent', 'text')
    ]);
  }
}
