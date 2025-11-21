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

  trackByFn(index: number, item: Message) {
    return item.id;
  }

  ngOnChanges(changes: SimpleChanges) {
    if (changes['selectedContact'] && changes['selectedContact'].currentValue) {
      this.newMessage = '';
      this.loadContactMessages(changes['selectedContact'].currentValue.id);
      console.log('切换到联系人:', changes['selectedContact'].currentValue.name);
    }
  }

  private loadContactMessages(contactId: number): void {
    this.messages = [...this.messageManager.getMessages(contactId)];
  }

  ngAfterViewChecked() {
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

    const message = this.messageManager.createMessage(
      this.selectedContact.id,
      'me',
      this.newMessage,
      'sending',
      'text'
    );

    this.messageManager.addMessage(this.selectedContact.id, message);
    this.messages = this.messageManager.getMessages(this.selectedContact.id);
    this.newMessage = '';

    setTimeout(() => {
      this.scrollToBottom();
      console.log('消息已发送');
      message.status = 'sent';
      this.messages = [...this.messageManager.getMessages(this.selectedContact!.id)];
    }, 0);
  }

  simulateReceiveMessage() {
    if (!this.selectedContact) return;

    const message = this.messageManager.receiveMessage(
      this.selectedContact.id,
      '这是一条模拟的新接收消息'
    );

    this.messages = [...this.messageManager.getMessages(this.selectedContact.id)];

    setTimeout(() => {
      this.scrollToBottom();
    }, 0);
  }

  isNewMessage(message: Message): boolean {
    return message.sender === 'me' && message.status === 'sent';
  }

  isNewReceivedMessage(message: Message): boolean {
    return message.sender === 'other' && message.status === 'sent';
  }

  sendFile() {
    console.log('发送文件');
  }

  sendImage() {
    console.log('发送图片');
  }

  sendEmoji(emoji: string) {
    this.newMessage += emoji;
  }
}
