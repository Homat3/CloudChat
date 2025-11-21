import { Injectable } from '@angular/core';
import { Message, MessageImpl } from '../models/message';
import { Contact } from '../../components/contact-list/contact-list.component';
import { SocketService } from './socket.service';
import { MessageType, ProtocolMessage, FilePayload } from '../protocol/message-protocol';

@Injectable({
  providedIn: 'root'
})
export class MessageManagerService {
  private messagesByContact: Map<number, Message[]> = new Map();

  constructor(private socketService: SocketService) {
    this.initializeSampleMessages();
    this.socketService.getMessages().subscribe((message: ProtocolMessage) => {
      switch (message.type) {
        case MessageType.MESSAGES_LOADED:
          // Assuming payload is { contactId: number, messages: Message[] }
          this.updateMessages(message.payload.contactId, message.payload.messages);
          break;
        case MessageType.MESSAGES_CLEARED:
          this.clearMessages(message.payload.contactId);
          break;
        case MessageType.MESSAGE_RECEIVED:
          // Handle incoming message
          this.receiveMessage(message.payload.contactId, message.payload.content);
          break;
      }
    });
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

  sendMessage(contactId: number, content: string): void {
    const message = this.createMessage(contactId, 'me', content, 'sending', 'text');
    this.addMessage(contactId, message);

    this.socketService.sendMessage({
      type: MessageType.SEND_MESSAGE,
      payload: { contactId, content }
    });

    // Simulate server response for now (or rely on actual server ack if implemented)
    // For now, we'll just mark it as sent immediately to keep UI responsive
    setTimeout(() => {
      message.status = 'sent';
    }, 100);
  }

  sendFile(contactId: number, file: File): void {
    const reader = new FileReader();
    reader.onload = (e: any) => {
      const arrayBuffer = e.target.result;
      const bytes = new Uint8Array(arrayBuffer);
      const hexList: string[] = [];
      for (let i = 0; i < bytes.length; i++) {
        hexList.push(bytes[i].toString(16).padStart(2, '0'));
      }

      const payload: FilePayload = {
        fileName: file.name,
        content: hexList,
        contactId: contactId
      };

      this.socketService.sendMessage({
        type: MessageType.SEND_FILE,
        payload: payload
      });

      // Add a local message to show it's sent
      const message = this.createMessage(contactId, 'me', `Sent file: ${file.name}`, 'sent', 'file');
      this.addMessage(contactId, message);
    };
    reader.readAsArrayBuffer(file);
  }

  sendImage(contactId: number, file: File): void {
    const reader = new FileReader();
    reader.onload = (e: any) => {
      const arrayBuffer = e.target.result;
      const bytes = new Uint8Array(arrayBuffer);
      const hexList: string[] = [];
      for (let i = 0; i < bytes.length; i++) {
        hexList.push(bytes[i].toString(16).padStart(2, '0'));
      }

      const payload: FilePayload = {
        fileName: file.name,
        content: hexList,
        contactId: contactId
      };

      this.socketService.sendMessage({
        type: MessageType.SEND_IMAGE,
        payload: payload
      });

      // Add a local message to show it's sent
      const message = this.createMessage(contactId, 'me', `Sent image: ${file.name}`, 'sent', 'image');
      this.addMessage(contactId, message);
    };
    reader.readAsArrayBuffer(file);
  }

  markMessagesAsRead(contactId: number): void {
    const messages = this.getMessages(contactId);
    let hasUnread = false;

    messages.forEach(msg => {
      if (msg.sender === 'other' && msg.status !== 'read') {
        msg.status = 'read';
        hasUnread = true;
      }
    });

    if (hasUnread) {
      this.socketService.sendMessage({
        type: MessageType.MARK_READ,
        payload: { contactId }
      });
    }
  }

  receiveMessage(contactId: number, content: string): Message {
    const message = this.createMessage(contactId, 'other', content, 'sent', 'text');
    this.addMessage(contactId, message);
    return message;
  }

  getLastMessage(contactId: number): string {
    const messages = this.getMessages(contactId);
    if (messages.length === 0) return '';
    const lastMsg = messages[messages.length - 1];
    return lastMsg.content; // Or handle different types like [Image], [File]
  }

  getLastMessageTime(contactId: number): string {
    const messages = this.getMessages(contactId);
    if (messages.length === 0) return '';
    return messages[messages.length - 1].timestamp;
  }

  requireLoadMessage(contactId: number): void {
    this.socketService.sendMessage({
      type: MessageType.LOAD_MESSAGES,
      payload: { contactId }
    });
  }

  requireClearMessages(contactId: number): void {
    this.socketService.sendMessage({
      type: MessageType.CLEAR_MESSAGES,
      payload: { contactId }
    });
  }

  clearMessages(contactId: number): void {
    this.messagesByContact.set(contactId, []);
  }

  getUnreadCount(contactId: number): number {
    const messages = this.getMessages(contactId);
    return messages.filter(m => m.status === 'sent' && m.sender === 'other').length;
  }

  updateMessages(contactId: number, messages: Message[]) {
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
