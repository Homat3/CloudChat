import { Injectable } from '@angular/core';
import {Message} from '../models';
import { ResponseService } from './response.service';
import {BehaviorSubject} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MessageService {
  private messageMapSubject: BehaviorSubject<Map<number, Message[]>> = new BehaviorSubject(new Map)
  public messageMap$ = this.messageMapSubject.asObservable();

  constructor(
    private responseService: ResponseService
  ) {
    this.responseService.contactDeleted$.subscribe(payload => {

    });

    this.responseService.contactAdded$.subscribe(payload => {

    });

    this.responseService.contactsLoaded$.subscribe(payload => {

    });

    this.responseService.messagesLoaded$.subscribe(payload => {

    });

    this.responseService.messageReceivedSelf$.subscribe(payload => {

    });

    this.responseService.messageReceivedOther$.subscribe(payload => {

    });

    this.responseService.messagesCleared$.subscribe(payload => {

    });
  }

  public get messagesMapValue(): Map<number, Message[]> | null {
    return this.messageMapSubject.value;
  }
}
