import { Injectable } from '@angular/core';
import { Contact } from '../../components/contact-list/contact-list.component';
import { ChatContact } from '../models';
import { SocketService } from './socket.service';
import {ClearMessagesPayload, DeleteContactPayload, MessageType} from '../protocol/message-protocol';

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
    // TODO
    // this.socketService.getMessages().subscribe((message: ProtocolMessage) => {
    //   switch (message.type) {
    //     case MessageType.CONTACTS_LOADED:
    //       this.contacts = message.payload;
    //       break;
    //     case MessageType.CONTACT_ADDED:
    //       this.addContact(message.payload);
    //       break;
    //     case MessageType.CONTACT_DELETED:
    //       this.removeContact(message.payload.id);
    //       break;
    //   }
    // });
  }

  getContacts(): Contact[] {
    return this.contacts;
  }

  requireLoadContacts(thisId: number): void {
    // TODO
    // this.socketService.sendMessage({
    //   type: MessageType.LOAD_CONTACTS,
    //   payload: thisId
    // });
  }

  getContactById(id: number): Contact | undefined {
    return this.contacts.find(contact => contact.id === id);
  }

  requireAddContact(contact: Contact): void {
    // TODO
    // this.socketService.sendMessage({
    //   type: MessageType.ADD_CONTACT,
    //   payload: contact
    // });
  }

  requireDeleteContact(thisId: number, toId: number): void {
    let info : DeleteContactPayload = {
      requesterUserId: thisId,
      targetUserId: toId
    }
    this.socketService.sendMessage({
      type: MessageType.DELETE_CONTACT,
      payload: info
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
        contactId: contact.id,
        userName: contact.name,
        online: contact.isOnline,
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
