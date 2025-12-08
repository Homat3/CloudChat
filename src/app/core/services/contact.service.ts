import { Injectable } from '@angular/core';
import {BehaviorSubject, Observable} from 'rxjs';
import { Contact } from '../models';
import { ResponseService } from './response.service';

@Injectable({
  providedIn: 'root'
})
export class ContactService {
  public isReady$: Observable<boolean>;

  private contactListSubject: BehaviorSubject<Contact[]> = new BehaviorSubject<Contact[]>([]);
  public contactList$ = this.contactListSubject.asObservable();

  constructor(private responseService: ResponseService) {
    // 监听联系人相关事件并更新联系人列表
    this.responseService.contactsLoaded$.subscribe(payload => {
      this.contactListSubject.next(payload.contacts.map(c => new Contact(c.contactId, c.username, c.online, c.avatar)));
    });

    this.responseService.contactAdded$.subscribe(payload => {
      const currentContacts = this.contactListSubject.value;
      const newContact = new Contact(payload.contactId, payload.userName, payload.online, payload.avatar);
      this.contactListSubject.next([...currentContacts, newContact]);
    });

    this.responseService.contactDeleted$.subscribe(() => {
      // 可以根据需要重新加载联系人或者移除特定联系人
      // 这里暂时不处理，因为删除联系人的响应没有返回具体ID
    });

    this.isReady$ = this.responseService.isReady$;
  }

  public get contactListValue(): Contact[] {
    return this.contactListSubject.value;
  }

  public updateContactList(contacts: Contact[]): void {
    this.contactListSubject.next(contacts);
  }
}
