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

    this.isReady$ = this.responseService.isReady$;
  }

  public get contactListValue(): Contact[] {
    return this.contactListSubject.value;
  }
}
