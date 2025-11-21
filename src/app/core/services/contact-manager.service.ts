import { Injectable } from '@angular/core';
import { Contact } from '../../components/contact-list/contact-list.component';
import { ChatContact } from '../models/chat-contact';

@Injectable({
  providedIn: 'root'
})
export class ContactManagerService {
  private contacts: Contact[] = [
    {
      id: 1,
      name: '张三',
      lastMessage: '好的，明天见',
      timestamp: '10:30',
      avatar: 'ZS',
      unreadCount: 0,
      isOnline: true
    },
    {
      id: 2,
      name: '李四',
      lastMessage: '这个需求有点复杂',
      timestamp: '昨天',
      avatar: 'LS',
      unreadCount: 0,
      isOnline: false
    },
    {
      id: 3,
      name: '王五',
      lastMessage: '好的，我看看',
      timestamp: '12:45',
      avatar: 'WW',
      unreadCount: 0,
      isOnline: true
    },
    {
      id: 4,
      name: '赵六',
      lastMessage: '会议时间改了吗？',
      timestamp: '09:15',
      avatar: 'ZL',
      unreadCount: 0,
      isOnline: true
    }
  ];

  private selectedContact: ChatContact | null = null;

  getContacts(): Contact[] {
    return this.contacts;
  }

  getContactById(id: number): Contact | undefined {
    return this.contacts.find(contact => contact.id === id);
  }

  addContact(contact: Contact): void {
    const maxId = this.contacts.reduce((max, c) => c.id > max ? c.id : max, 0);
    contact.id = maxId + 1;
    this.contacts.push(contact);
  }

  updateContact(updatedContact: Contact): void {
    const index = this.contacts.findIndex(c => c.id === updatedContact.id);
    if (index !== -1) {
      this.contacts[index] = updatedContact;
    }
  }

  deleteContact(id: number): void {
    const index = this.contacts.findIndex(c => c.id === id);
    if (index !== -1) {
      this.contacts.splice(index, 1);
    }
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