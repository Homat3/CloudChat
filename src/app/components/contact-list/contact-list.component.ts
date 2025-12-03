import { Component, Output, EventEmitter, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { Contact } from '../../core/models/models';
import { RequestService } from '../../core/services/request.service';
import { ResponseService } from '../../core/services/response.service';
import { AuthService } from '../../core/services/auth.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-contact-list',
  templateUrl: './contact-list.component.html',
  styleUrls: ['./contact-list.component.css'],
  standalone: true,
  imports: [CommonModule, RouterLink]
})
export class ContactListComponent implements OnInit, OnDestroy {
  @Output() contactSelected = new EventEmitter<Contact>();
  selectedContactId: number | null = null;
  contactsList: Contact[] = [];
  private subscriptions: Subscription[] = [];

  constructor(
    private requestService: RequestService,
    private responseService: ResponseService,
    private authService: AuthService
  ) { }

  ngOnInit() {
    const currentUser = this.authService.currentUserValue;
    if (currentUser) {
      this.requestService.loadContacts({ userId: currentUser.userId });
    }

    this.subscriptions.push(
      this.responseService.contactsLoaded$.subscribe(payload => {
        this.contactsList = payload.contacts.map(c => new Contact(c.contactId, c.username, c.online, c.avatar));
      }),
      this.responseService.contactAdded$.subscribe(payload => {
        this.contactsList.push(new Contact(payload.contactId, payload.userName, payload.online, payload.avatar));
      }),
      this.responseService.contactDeleted$.subscribe(() => {
        // Reload contacts or remove locally if we had the ID.
        // The protocol for delete success doesn't return the ID, so we might need to reload.
        const currentUser = this.authService.currentUserValue;
        if (currentUser) {
          this.requestService.loadContacts({ userId: currentUser.userId });
        }
      })
    );
  }

  get contacts(): Contact[] {
    return this.contactsList;
  }

  selectContact(contact: Contact) {
    this.selectedContactId = contact.contactId;
    this.contactSelected.emit(contact);
  }

  getLastMessage(contact: Contact): string {
    // Placeholder: Real implementation would require a message store service
    return '';
  }

  getLastMessageTime(contact: Contact): string {
    // Placeholder
    return '';
  }

  getUnreadCount(contact: Contact): number {
    // Placeholder
    return 0;
  }

  ngOnDestroy() {
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }
}
