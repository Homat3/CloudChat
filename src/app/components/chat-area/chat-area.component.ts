import {
  Component,
  Input,
  OnChanges,
  SimpleChanges,
  ViewChild,
  ElementRef,
  AfterViewChecked,
  Output, EventEmitter
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ContactManagerService } from '../../core/services/contact-manager.service';
import { MessageManagerService } from '../../core/services/message-manager.service';
import { Message, ChatContact } from '../../core/models';

@Component({
  selector: 'app-chat-area',
  templateUrl: './chat-area.component.html',
  styleUrls: ['./chat-area.component.css'],
  standalone: true,
  imports: [CommonModule, FormsModule]
})
export class ChatAreaComponent implements OnChanges, AfterViewChecked {
  @Input() selectedContact: ChatContact | null = null;
  @ViewChild('chatMessagesContainer', { static: false }) private chatMessagesContainer!: ElementRef;

  messages: Message[] = [];
  newMessage = '';

  constructor(
    private contactManager: ContactManagerService,
    private messageManager: MessageManagerService
  ) { }

  get currentContact(): ChatContact | null {
    return this.contactManager.getSelectedContact();
  }

  ngOnChanges(changes: SimpleChanges) {
    if (changes['selectedContact'] && changes['selectedContact'].currentValue) {
      this.newMessage = '';
      const contactId = changes['selectedContact'].currentValue.id;
      this.loadContactMessages(contactId);
      this.messageManager.markMessagesAsRead(contactId);
      console.log('切换到联系人:', changes['selectedContact'].currentValue.name);
    }
  }

  private loadContactMessages(contactId: number): void {
    this.messages = [...this.messageManager.getMessages(contactId)];
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

  sendMessage(event?: Event) {
    if (event && event instanceof KeyboardEvent && event.key === 'Enter') {
      event.preventDefault();

      if (!event.shiftKey) {
        if (this.newMessage.trim() && this.selectedContact) {
          this.processSendMessage();
        }
        return;
      }

      return;
    }

    if (this.newMessage.trim() && this.selectedContact) {
      this.processSendMessage();
    }
  }

  private processSendMessage() {
    if (!this.selectedContact) return;

    this.messageManager.sendMessage(this.selectedContact.id, this.newMessage);
    this.messages = this.messageManager.getMessages(this.selectedContact.id);
    this.newMessage = '';

    setTimeout(() => {
      this.scrollToBottom();
    }, 0);
  }

  // simulateReceiveMessage removed as it's now handled by service/socket

  isNewMessage(message: Message): boolean {
    return message.sender === 'me' && message.status === 'sent';
  }

  isNewReceivedMessage(message: Message): boolean {
    return message.sender === 'other' && message.status === 'sent';
  }

  sendFile() {
    const input = document.createElement('input');
    input.type = 'file';
    input.onchange = (e: any) => {
      const file = e.target.files[0];
      if (file && this.selectedContact) {
        this.messageManager.sendFile(this.selectedContact.id, file);
        this.messages = this.messageManager.getMessages(this.selectedContact.id);
        setTimeout(() => this.scrollToBottom(), 0);
      }
    };
    input.click();
  }

  sendImage() {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = 'image/*';
    input.onchange = (e: any) => {
      const file = e.target.files[0];
      if (file && this.selectedContact) {
        this.messageManager.sendImage(this.selectedContact.id, file);
        this.messages = this.messageManager.getMessages(this.selectedContact.id);
        setTimeout(() => this.scrollToBottom(), 0);
      }
    };
    input.click();
  }

  sendEmoji(emoji: string) {
    this.newMessage += emoji;
  }
}
