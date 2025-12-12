import {
  AfterViewChecked,
  Component,
  ElementRef,
  Input,
  OnChanges,
  OnDestroy,
  SimpleChanges,
  ViewChild
} from '@angular/core';
import {CommonModule, NgOptimizedImage} from '@angular/common';
import {FormsModule} from '@angular/forms';
import {Contact, FileMessage, ImageMessage, Message, TextMessage} from '../../core/models';
import {RequestService} from '../../core/services/request.service';
import {AuthService} from '../../core/services/auth.service';
import {MessageService} from '../../core/services/message.service';
import {Subscription} from 'rxjs';
import { v4 as uuidv4 } from 'uuid';

@Component({
  selector: 'app-chat-area',
  templateUrl: './chat-area.component.html',
  styleUrls: ['./chat-area.component.css'],
  standalone: true,
  imports: [CommonModule, FormsModule]
})
export class ChatAreaComponent implements OnChanges{
  @Input() selectedContact: Contact | null = null;
  @ViewChild('chatMessagesContainer', { static: false }) private chatMessagesContainer!: ElementRef;

  @Input() messages: Message[] = [];
  newMessage = '';
  private subscriptions: Subscription[] = [];

  constructor(
    private requestService: RequestService,
    private authService: AuthService,
    private messageService: MessageService
  ) {}

  get currentContact(): Contact | null {
    return this.selectedContact;
  }

  ngOnChanges(changes: SimpleChanges) {
    if (changes['selectedContact'] && changes['selectedContact'].currentValue) {
      this.newMessage = '';
      const contactId = changes['selectedContact'].currentValue.contactId;
      this.loadContactMessages(contactId);
      let toMark = false
      this.messages.forEach((message) => {
        toMark ||= (message.receiverId == this.currentContact?.contactId && message.status != 'read')
        if (toMark) return;
      });
      if (toMark){
        this.markMessagesAsRead(this.authService.currentUserValue?.userId || -1, contactId);
      }
      console.log('切换到联系人:', changes['selectedContact'].currentValue.username);
    }
  }

  private loadContactMessages(targetId: number): void {
    this.messages = this.messageService.messagesMapValue?.get(targetId) || [];
  }

  private markMessagesAsRead(userId: number, targetId: number): void {
    if (userId == -1) return;
    this.requestService.markRead({ userId, targetId });
  }

  ngAfterViewChecked() {
    this.scrollToBottom();
  }

  scrollToBottom(): void {
    try {
      if (this.chatMessagesContainer) {
        const container = this.chatMessagesContainer.nativeElement;
        container.scrollTop = container.scrollHeight;
      }
    } catch (err) {
      console.log('滚动到底部失败:', err);
    }
  }

  sendMessage() {
    if (!this.newMessage.trim() || !this.selectedContact) return;

    const currentUser = this.authService.currentUserValue;
    if (!currentUser) {
      window.alert('请先登录');
      console.error('用户未登录');
      return;
    }

    const tempMessageId = uuidv4(); // Temporary ID
    const content = this.newMessage;
    const receiverId = this.selectedContact.contactId;

    const messagePayload = {
      tempId: tempMessageId,
      senderId: currentUser.userId,
      receiverId: receiverId,
      content: content,
      type: 'text' as 'text' | 'image' | 'file'
    };

    this.messageService.putWaitingMessage(messagePayload);
    this.requestService.sendMessage(messagePayload,
      () => {
      this.newMessage = '';
      this.scrollToBottom();
      },
      (error) => {
        console.error('发送消息失败:', error);
        window.alert('发送消息失败: ' + error);
      }
      );
  }

  private formatTimestamp(date: Date){
    return date.getFullYear().toString() + ' ' +
      date.getMonth().toString() + ' ' +
      date.getDate().toString() + ' | ' +
      date.getHours().toString() + ':' +
      date.getMinutes().toString()
  }

  isNewMessage(message: Message): boolean {
    const currentUser = this.authService.currentUserValue;
    return !!currentUser && message.senderId === currentUser.userId;
  }

  isNewReceivedMessage(message: Message): boolean {
    const currentUser = this.authService.currentUserValue;
    return !!currentUser && message.senderId !== currentUser.userId;
  }

  appendEmoji() {
    this.newMessage += '😊'; // Simple example
  }
}
