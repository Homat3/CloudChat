import { Injectable } from '@angular/core';
import { Subject } from 'rxjs';
import { SocketService } from './socket.service';
import { ServiceMessageType, ServicePayload, LoginSuccessPayload, LoginFailurePayload, RegisterSuccessPayload, RegisterFailurePayload, ProfileUpdatedSuccessPayload, ProfileUpdatedFailedPayload, ContactsLoadedPayload, ContactsLoadedFailedPayload, ContactAddedPayload, ContactAddedFailedPayload, ContactDeletedPayload, ContactDeletedFailedPayload, MessagesLoadedPayload, SelfMessageReceivedPayload, ToSelfMessageReceivedPayload, MessagesClearedPayload } from '../protocol/service.protocol';

@Injectable({
    providedIn: 'root'
})
export class ResponseService {

    public loginSuccess$ = new Subject<LoginSuccessPayload>();
    public loginFailure$ = new Subject<LoginFailurePayload>();
    public registerSuccess$ = new Subject<RegisterSuccessPayload>();
    public registerFailure$ = new Subject<RegisterFailurePayload>();
    public profileUpdatedSuccess$ = new Subject<ProfileUpdatedSuccessPayload>();
    public profileUpdatedFailed$ = new Subject<ProfileUpdatedFailedPayload>();
    public logoutSuccess$ = new Subject<void>();
    public contactsLoaded$ = new Subject<ContactsLoadedPayload>();
    public contactsLoadedFailed$ = new Subject<ContactsLoadedFailedPayload>();
    public contactAdded$ = new Subject<ContactAddedPayload>();
    public contactAddedFailed$ = new Subject<ContactAddedFailedPayload>();
    public contactDeleted$ = new Subject<ContactDeletedPayload>();
    public contactDeletedFailed$ = new Subject<ContactDeletedFailedPayload>();
    public messagesLoaded$ = new Subject<MessagesLoadedPayload>();
    public messageReceivedSelf$ = new Subject<SelfMessageReceivedPayload>();
    public messageReceivedOther$ = new Subject<ToSelfMessageReceivedPayload>();
    public messagesCleared$ = new Subject<MessagesClearedPayload>();

    constructor(private socketService: SocketService) {
        this.socketService.getMessages().subscribe(message => {
            this.handleMessage(message);
        });
    }

    private handleMessage(message: any) {
        console.log('ResponseService received:', message);
        if (!message || !message.type) return;

        switch (message.type) {
            case ServiceMessageType.LOGIN_SUCCESS:
                this.loginSuccess$.next(message.payload);
                break;
            case ServiceMessageType.LOGIN_FAILURE:
                this.loginFailure$.next(message.payload);
                break;
            case ServiceMessageType.REGISTER_SUCCESS:
                this.registerSuccess$.next(message.payload);
                break;
            case ServiceMessageType.REGISTER_FAILURE:
                this.registerFailure$.next(message.payload);
                break;
            case ServiceMessageType.PROFILE_UPDATED_SUCCESS:
                this.profileUpdatedSuccess$.next(message.payload);
                break;
            case ServiceMessageType.PROFILE_UPDATED_FAILED:
                this.profileUpdatedFailed$.next(message.payload);
                break;
            case ServiceMessageType.LOGOUT_SUCCESS:
                this.logoutSuccess$.next();
                break;
            case ServiceMessageType.CONTACTS_LOADED:
                this.contactsLoaded$.next(message.payload);
                break;
            case ServiceMessageType.CONTACTS_LOADED_FAILED:
                this.contactsLoadedFailed$.next(message.payload);
                break;
            case ServiceMessageType.CONTACT_ADDED:
                this.contactAdded$.next(message.payload);
                break;
            case ServiceMessageType.CONTACT_ADDED_FAILED:
                this.contactAddedFailed$.next(message.payload);
                break;
            case ServiceMessageType.CONTACT_DELETED:
                this.contactDeleted$.next(message.payload);
                break;
            case ServiceMessageType.CONTACT_DELETED_FAILED:
                this.contactDeletedFailed$.next(message.payload);
                break;
            case ServiceMessageType.MESSAGES_LOADED:
                this.messagesLoaded$.next(message.payload);
                break;
            case ServiceMessageType.MESSAGE_RECEIVED_SELF:
                this.messageReceivedSelf$.next(message.payload);
                break;
            case ServiceMessageType.MESSAGE_RECEIVED_OTHER:
                this.messageReceivedOther$.next(message.payload);
                break;
            case ServiceMessageType.MESSAGES_CLEARED:
                this.messagesCleared$.next(message.payload);
                break;
            default:
                console.warn('Unknown message type:', message.type);
        }
    }
}
