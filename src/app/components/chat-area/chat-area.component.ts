import {
  Component,
  Input,
  OnChanges,
  SimpleChanges,
  ViewChild,
  ElementRef,
  AfterViewChecked,
  OnDestroy
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Message, TextMessage, ImageMessage, FileMessage } from '../../core/models';
import { Contact } from '../../core/models';
import { RequestService } from '../../core/services/request.service';
import { ResponseService } from '../../core/services/response.service';
import { AuthService } from '../../core/services/auth.service';
import { Subscription } from 'rxjs';

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
    private responseService: ResponseService,
    private authService: AuthService
  ) {
    this.subscriptions.push(
      this.responseService.messagesLoaded$.subscribe(payload => {
        this.messages = payload.messages.map(msg => this.mapToMessage(msg));
        this.scrollToBottom();
      }),
      this.responseService.messageReceivedSelf$.subscribe(payload => {
        // We might need to fetch the full message or optimistically add it.
        // For now, let's assume we handle optimistic updates in sendMessage
        // or we reload/wait for the echo.
        // Actually, the protocol says MESSAGE_RECEIVED_SELF returns { messageId }.
        // It doesn't return the full content.
        // So we should probably add the message to the list when we send it,
        // and maybe update its status when we get this confirmation.
      }),
      this.responseService.messageReceivedOther$.subscribe(payload => {
        if (this.selectedContact && payload.senderId === this.selectedContact.contactId) {
          this.messages.push(this.mapToMessage(payload));
          this.scrollToBottom();
          this.markMessagesAsRead(<number>this.authService.currentUserValue?.userId, this.selectedContact.contactId);
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
      this.loadContactMessages(<number>this.authService.currentUserValue?.userId, contactId);
      console.log('切换到联系人:', changes['selectedContact'].currentValue.username);
    }
  }

  private loadContactMessages(contactId: number, targetId: number): void {
    this.messages = []; // Clear current messages
    this.requestService.loadMessages({ userId: contactId, targetId: targetId });
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
