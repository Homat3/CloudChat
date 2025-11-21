import { Component, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ContactManagerService } from '../../core/services/contact-manager.service';

export interface Contact {
  id: number;
  name: string;
  lastMessage: string;
  timestamp: string;
  avatar: string;
  unreadCount: number;
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

  constructor(private contactManager: ContactManagerService) { }

  get contacts(): Contact[] {
    return this.contactManager.getContacts();
  }

  selectContact(contact: Contact) {
    this.selectedContactId = contact.id;
    this.contactSelected.emit(contact);
  }
}