import {AfterContentInit, Component, EventEmitter, Input, OnDestroy, OnInit, Output} from '@angular/core';
import {CommonModule} from '@angular/common';
import {RouterLink} from '@angular/router';
import {Contact, Message, User} from '../../core/models';
import {RequestService} from '../../core/services/request.service';
import {ResponseService} from '../../core/services/response.service';
import {AuthService} from '../../core/services/auth.service';
import {Subscription} from 'rxjs';
import {MessageService} from '../../core/services/message.service';
import {ContactService} from '../../core/services/contact.service';

@Component({
  selector: 'app-contact-list',
  templateUrl: './contact-list.component.html',
  styleUrls: ['./contact-list.component.css'],
  standalone: true,
  imports: [CommonModule, RouterLink]
})
export class ContactListComponent {
  @Output() contactSelected = new EventEmitter<Contact>();
  @Input() messagesMap: Map<number, Message[]> | null = null;
  @Input() contactList: Contact[] = [];
  @Input() currentUser: User | null = null;
  selectedContactId: number | null = null;

  constructor() { }

  get contacts(): Contact[] {
    return this.contactList;
  }

  selectContact(contact: Contact) {
    this.selectedContactId = contact.contactId;
    this.contactSelected.emit(contact);
  }

  getLastMessage(contact: Contact): Message | undefined {
    let messages = this.messagesMap?.get(contact.contactId)
    if (messages) {
      return messages[messages.length - 1];
    }
    return undefined;
  }

  getLastMessageContent(contact: Contact): string | undefined {
    return this.getLastMessage(contact)?.content;
  }
  getLastMessageTime(contact: Contact): string | undefined {
    return this.getLastMessage(contact)?.timestamp;
  }

  getUnreadCount(contact: Contact): number {
    return this.messagesMap?.get(contact.contactId)?.filter(m => m.senderId == contact.contactId && m.status === 'sent').length || 0;
  }

  showAddContact() {
    // 触发显示添加联系人模态框
    // 使用自定义事件方式触发
    const event = new CustomEvent('showAddContactDialog');
    window.dispatchEvent(event);
  }
}
