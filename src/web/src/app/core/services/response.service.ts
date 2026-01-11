import {Injectable} from '@angular/core';
import {Observable, Subject} from 'rxjs';
import {SocketService} from './socket.service';
import {
  AcceptFriendRequestPayload,
  AddFriendRequestPayload,
  ContactAddedPayload,
  ContactsLoadedFailedPayload,
  ContactsLoadedPayload, FileUploadedFailedPayload, FileUploadedPayload,
  FriendRequestAcceptedFailedPayload,
  FriendRequestAcceptedPayload,
  FriendRequestAddedFailedPayload,
  FriendRequestAddedPayload,
  FriendRequestLoadedFailedPayload,
  FriendRequestLoadedPayload,
  FriendRequestRefusedPayload,
  LoginFailurePayload,
  LoginSuccessPayload,
  MessageSendFailedPayload,
  MessagesLoadedPayload,
  ProfileUpdatedFailedPayload,
  ProfileUpdatedSuccessPayload,
  RefuseFriendRequestPayload,
  RegisterFailurePayload,
  RegisterSuccessPayload,
  SearchForUserResultPayload,
  MessageReceivedSelfPayload,
  ServiceMessageType,
  MessageReceivedOtherPayload
} from '../protocol/service.protocol';

@Injectable({
    providedIn: 'root'
})
export class ResponseService {
    public isReady$: Observable<boolean>;

    public loginSuccess$ = new Subject<LoginSuccessPayload>();
    public loginFailure$ = new Subject<LoginFailurePayload>();
    public registerSuccess$ = new Subject<RegisterSuccessPayload>();
    public registerFailure$ = new Subject<RegisterFailurePayload>();
    public profileUpdatedSuccess$ = new Subject<ProfileUpdatedSuccessPayload>();
    public profileUpdatedFailed$ = new Subject<ProfileUpdatedFailedPayload>();
    public contactsLoaded$ = new Subject<ContactsLoadedPayload>();
    public contactsLoadedFailed$ = new Subject<ContactsLoadedFailedPayload>();
    public contactAdded$ = new Subject<ContactAddedPayload>();
    public searchForUserResult$ = new Subject<SearchForUserResultPayload>();
    public friendRequestLoaded$ = new Subject<FriendRequestLoadedPayload>();
    public friendRequestLoadedFailed$ = new Subject<FriendRequestLoadedFailedPayload>();
    public friendRequestAdded$ = new Subject<FriendRequestAddedPayload>();
    public friendRequestAddedFailed$ = new Subject<FriendRequestAddedFailedPayload>();
    public addFriendRequest$ = new Subject<AddFriendRequestPayload>();
    public friendRequestRefused$ = new Subject<FriendRequestRefusedPayload>();
    public friendRequestAccepted$ = new Subject<FriendRequestAcceptedPayload>();
    public friendRequestRefusedFailed$ = new Subject<FriendRequestAddedFailedPayload>();
    public friendRequestAcceptedFailed$ = new Subject<FriendRequestAcceptedFailedPayload>();
    public refuseFriendRequest$ = new Subject<RefuseFriendRequestPayload>();
    public acceptFriendRequest$ = new Subject<AcceptFriendRequestPayload>();
    public messagesLoaded$ = new Subject<MessagesLoadedPayload>();
    public messageReceivedSelf$ = new Subject<MessageReceivedSelfPayload>();
    public messageSendFailed$ = new Subject<MessageSendFailedPayload>();
    public messageReceivedOther$ = new Subject<MessageReceivedOtherPayload>();
    public fileUploaded$ = new Subject<FileUploadedPayload>();
    public fileUploadedFailed$ = new Subject<FileUploadedFailedPayload>();

    constructor(private socketService: SocketService) {
        this.socketService.getMessages().subscribe(message => {
            this.handleMessage(message);
        });
        this.isReady$ = this.socketService.connectionStatus$;
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
            case ServiceMessageType.CONTACTS_LOADED:
                this.contactsLoaded$.next(message.payload);
                break;
            case ServiceMessageType.CONTACTS_LOADED_FAILED:
                this.contactsLoadedFailed$.next(message.payload);
                break;
            case ServiceMessageType.CONTACT_ADDED:
                this.contactAdded$.next(message.payload);
                break;
            case ServiceMessageType.SEARCH_FOR_USER_RESULT:
                this.searchForUserResult$.next(message.payload);
                break;
            case ServiceMessageType.FRIEND_REQUEST_LOADED:
                this.friendRequestLoaded$.next(message.payload);
                break;
            case ServiceMessageType.FRIEND_REQUEST_LOADED_FAILED:
                this.friendRequestLoadedFailed$.next(message.payload);
                break;
            case ServiceMessageType.FRIEND_REQUEST_ADDED:
                this.friendRequestAdded$.next(message.payload);
                break;
            case ServiceMessageType.FRIEND_REQUEST_ADDED_FAILED:
                this.friendRequestAddedFailed$.next(message.payload);
                break;
            case ServiceMessageType.ADD_FRIEND_REQUEST:
                this.addFriendRequest$.next(message.payload);
                break;
            case ServiceMessageType.FRIEND_REQUEST_REFUSED:
                this.friendRequestRefused$.next(message.payload);
                break;
            case ServiceMessageType.FRIEND_REQUEST_REFUSED_FAILED:
                this.friendRequestRefusedFailed$.next(message.payload);
                break;
            case ServiceMessageType.FRIEND_REQUEST_ACCEPTED:
                this.friendRequestAccepted$.next(message.payload);
                break;
            case ServiceMessageType.FRIEND_REQUEST_ACCEPTED_FAILED:
                this.friendRequestAcceptedFailed$.next(message.payload);
                break;
            case ServiceMessageType.REFUSE_FRIEND_REQUEST:
                this.refuseFriendRequest$.next(message.payload);
                break;
            case ServiceMessageType.ACCEPT_FRIEND_REQUEST:
                this.acceptFriendRequest$.next(message.payload);
                break;
            case ServiceMessageType.MESSAGES_LOADED:
                this.messagesLoaded$.next(message.payload);
                break;
            case ServiceMessageType.MESSAGE_RECEIVED_SELF:
                this.messageReceivedSelf$.next(message.payload);
                break;
            case ServiceMessageType.MESSAGE_SEND_FAILED:
                this.messageSendFailed$.next(message.payload);
                break;
            case ServiceMessageType.MESSAGE_RECEIVED_OTHER:
                this.messageReceivedOther$.next(message.payload);
                break;
            case ServiceMessageType.FILE_UPLOADED:
                this.fileUploaded$.next(message.payload);
                break;
            case ServiceMessageType.FILE_UPLOADED_FAILED:
                this.fileUploadedFailed$.next(message.payload);
                break;
            default:
                console.warn('Unknown message type:', message.type);
        }
    }
}
