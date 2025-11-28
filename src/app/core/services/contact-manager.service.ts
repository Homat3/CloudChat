import { Injectable } from '@angular/core';
import { Contact } from '../../components/contact-list/contact-list.component';
import { ChatContact } from '../models/chat-contact';
import { SocketService } from './socket.service';
import { MessageType, ProtocolMessage } from '../protocol/message-protocol';

@Injectable({
  providedIn: 'root'
})
export class ContactManagerService {
  private contacts: Contact[] = [
    {
      id: 1,
      name: '张三',
      avatar: 'ZS',
      isOnline: true
    },
    {
      id: 2,
      name: '李四',
      avatar: 'LS',
      isOnline: false
    },
    {
      id: 3,
      name: '王五',
      avatar: 'WW',
      isOnline: true
    },
    {
      id: 4,
      name: '赵六',
      avatar: 'ZL',
      isOnline: true
    }
  ];

  private selectedContact: ChatContact | null = null;

  constructor(private socketService: SocketService) {
    this.socketService.getMessages().subscribe((message: ProtocolMessage) => {
      switch (message.type) {
        case MessageType.CONTACTS_LOADED:
          this.contacts = message.payload;
          break;
        case MessageType.CONTACT_ADDED:
          this.addContact(message.payload);
          break;
        case MessageType.CONTACT_DELETED:
          this.removeContact(message.payload.id);
          break;
      }
    });
  }

  getContacts(): Contact[] {
    return this.contacts;
  }

  requireLoadContacts(): void {
    this.socketService.sendMessage({
      type: MessageType.LOAD_CONTACTS,
      payload: null
    });
  }

  getContactById(id: number): Contact | undefined {
    return this.contacts.find(contact => contact.id === id);
  }

  requireAddContact(contact: Contact): void {
    this.socketService.sendMessage({
      type: MessageType.ADD_CONTACT,
      payload: contact
    });
  }

  requireDeleteContact(id: number): void {
    this.socketService.sendMessage({
      type: MessageType.DELETE_CONTACT,
      payload: { id }
    });
  }

  updateContact(updatedContact: Contact): void {
    const index = this.contacts.findIndex(c => c.id === updatedContact.id);
    if (index !== -1) {
      this.contacts[index] = updatedContact;
    }
  }

  addContact(newContact: Contact): void {
    this.contacts.push(newContact);
  }

  removeContact(id: number): void {
    this.contacts = this.contacts.filter(contact => contact.id !== id);
  }

  setSelectedContact(contact: Contact | null): void {
    if (contact) {
      this.selectedContact = {
        id: contact.id,
        name: contact.name,
        status: contact.isOnline ? '在线' : '离线',
        avatar: contact.avatar
      };
    } else {
      this.selectedContact = null;
    }
  }

  getSelectedContact(): ChatContact | null {
    return this.selectedContact;
  }
}
