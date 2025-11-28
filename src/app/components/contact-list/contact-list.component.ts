import { Component, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ContactManagerService } from '../../core/services/contact-manager.service';
import { MessageManagerService } from '../../core/services/message-manager.service';

export interface Contact {
  id: number;
  name: string;
  avatar: string;
  isOnline: boolean;
}

@Component({
  selector: 'app-contact-list',
  templateUrl: './contact-list.component.html',
  styleUrls: ['./contact-list.component.css'],
  standalone: true,
  imports: [CommonModule, RouterLink]
})
export class ContactListComponent {
  @Output() contactSelected = new EventEmitter<Contact>();
  selectedContactId: number | null = null;

  constructor(
    private contactManager: ContactManagerService,
    private messageManager: MessageManagerService
  ) { }

  get contacts(): Contact[] {
    return this.contactManager.getContacts();
  }

  selectContact(contact: Contact) {
    this.selectedContactId = contact.id;
    this.contactSelected.emit(contact);
  }

  getLastMessage(contact: Contact): string {
    return this.messageManager.getLastMessage(contact.id);
  }

  getLastMessageTime(contact: Contact): string {
    return this.messageManager.getLastMessageTime(contact.id);
  }

  getUnreadCount(contact: Contact): number {
    return this.messageManager.getUnreadCount(contact.id);
  }
}