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

@Component({
  selector: 'app-chat-area',
  templateUrl: './chat-area.component.html',
  styleUrls: ['./chat-area.component.css'],
  standalone: true,
  imports: [CommonModule, FormsModule]
})
export class ChatAreaComponent implements OnChanges, AfterViewChecked, OnDestroy {
  @Input() selectedContact: Contact | null = null;
  @ViewChild('chatMessagesContainer', { static: false }) private chatMessagesContainer!: ElementRef;

  messages: Message[] = [];
  newMessage = '';
  private subscriptions: Subscription[] = [];

  constructor(
    private requestService: RequestService,
    private authService: AuthService,
    private messageService: MessageService
  ) {
    this.subscriptions.push(
      this.messageService.messageMap$.subscribe(messagesMap => {
        let refreshedMessages = messagesMap.get(<number>this.currentContact?.contactId);
        if (refreshedMessages){
          this.messages = refreshedMessages;
        }
      })
    );
  }

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
        toMark ||= message.status != 'read'
        if (toMark) return;
      });
      if (toMark){
        this.markMessagesAsRead(this.authService.currentUserValue?.userId || 0, contactId);
      }
      console.log('切换到联系人:', changes['selectedContact'].currentValue.username);
    }
  }

  private loadContactMessages(targetId: number): void {
    this.messages = this.messageService.messagesMapValue?.get(targetId) || [];
  }

  private markMessagesAsRead(userId: number, targetId: number): void {
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

  sendMessage(event: Event) {
    if (!this.newMessage.trim() || !this.selectedContact) return;

    const currentUser = this.authService.currentUserValue;
    if (!currentUser) {
      console.error('User not logged in');
      return;
    }

    const tempMessageId = Date.now(); // Temporary ID
    const content = this.newMessage;
    const receiverId = this.selectedContact.contactId;

    const messagePayload = {
      messageId: tempMessageId,
      senderId: currentUser.userId,
      receiverId: receiverId,
      content: content
    };

    this.requestService.sendMessage(messagePayload, () => {
      // Success callback - update local state here
      const sentMsg = new TextMessage(
        tempMessageId,
        currentUser.userId,
        receiverId,
        content,
        new Date().toISOString(), // Use local time as server doesn't return it in ack
        'sent'
      );
      this.messages.push(sentMsg);
      this.newMessage = '';
      this.scrollToBottom();
    });
  }

  isNewMessage(message: Message): boolean {
    const currentUser = this.authService.currentUserValue;
    return !!currentUser && message.senderId === currentUser.userId;
  }

  isNewReceivedMessage(message: Message): boolean {
    const currentUser = this.authService.currentUserValue;
    return !!currentUser && message.senderId !== currentUser.userId;
  }

  sendFile() {
    // TODO: Implement file selection and sending logic
    console.log('File sending not implemented yet');
  }

  sendImage() {
    // TODO: Implement image selection and sending logic
    console.log('Image sending not implemented yet');
  }

  appendEmoji() {
    this.newMessage += '😊'; // Simple example
  }

  ngOnDestroy() {
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }

  private mapToMessage(data: any): Message {
    if (data.type === 'text') {
      return new TextMessage(data.id, data.senderId, data.receiverId, data.content, data.timestamp, data.status);
    } else if (data.type === 'image') {
      return new ImageMessage(data.id, data.senderId, data.receiverId, data.content, data.timestamp, data.status);
    } else if (data.type === 'file') {
      return new FileMessage(data.id, data.senderId, data.receiverId, data.content, data.timestamp, data.status);
    }
    // Default to text if unknown
    return new TextMessage(data.id, data.senderId, data.receiverId, typeof data.content === 'string' ? data.content : '', data.timestamp, data.status);
  }
}
