import {Injectable} from '@angular/core';
import {SocketService} from './socket.service';
import {ResponseService} from './response.service';
import {
  AcceptFriendRequestPayload,
  AddFriendRequestPayload,
  ClearMessagesPayload,
  ClientMessageType,
  LoadContactsPayload,
  LoadMessagesPayload,
  LoginByTokenPayload,
  LoginPayload,
  LogoutPayload,
  MarkReadPayload,
  RefuseFriendRequestPayload,
  RegisterPayload,
  SearchForUserByIdPayload,
  SearchForUserByUserNamePayload,
  SendFilePayload,
  SendImagePayload,
  SendMessagePayload,
  UpdateProfilePayload
} from '../protocol/client.protocol';
import {filter, take} from 'rxjs/operators';
import {LoginSuccessPayload} from '../protocol/service.protocol';
import {Observable} from 'rxjs';
import {Message} from '../models';

@Injectable({
    providedIn: 'root'
})
export class RequestService {
    public isReady$: Observable<boolean>;

    constructor(
        private socketService: SocketService,
        private responseService: ResponseService
    ) {
        this.isReady$ = this.socketService.connectionStatus$;
    }

    login(payload: LoginPayload, onSuccess?: (payload: LoginSuccessPayload) => void, onError?: (err: string) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.LOGIN, payload });
        if (onSuccess) {
            this.responseService.loginSuccess$.pipe(take(1)).subscribe((payload) => onSuccess(payload));
        }
        if (onError) {
            this.responseService.loginFailure$.pipe(take(1)).subscribe(err => onError(err.error));
        }
    }

    loginByToken(payload: LoginByTokenPayload, onSuccess?: (payload: LoginSuccessPayload) => void, onError?: (err: string) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.LOGIN_BY_TOKEN, payload });
        if (onSuccess) {
            this.responseService.loginSuccess$.pipe(take(1)).subscribe((payload) => onSuccess(payload));
        }
        if (onError) {
          this.responseService.loginFailure$.pipe(take(1)).subscribe(err => onError(err.error));
        }
    }

    register(payload: RegisterPayload, onSuccess?: (payload: LoginSuccessPayload) => void, onError?: (err: string) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.REGISTER, payload });
        if (onSuccess) {
            this.responseService.registerSuccess$.pipe(take(1)).subscribe((payload) => onSuccess(payload));
        }
        if (onError) {
            this.responseService.registerFailure$.pipe(take(1)).subscribe(err => onError(err.error));
        }
    }

    updateProfile(payload: UpdateProfilePayload, onSuccess?: () => void, onError?: (err: string) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.UPDATE_PROFILE, payload });
        if (onSuccess) {
            this.responseService.profileUpdatedSuccess$.pipe(take(1)).subscribe(() => onSuccess());
        }
        if (onError) {
            this.responseService.profileUpdatedFailed$.pipe(take(1)).subscribe(err => onError(err.error));
        }
    }

    logout(payload: LogoutPayload, onSuccess?: () => void) {
        this.socketService.sendMessage({ type: ClientMessageType.LOGOUT, payload });
        if (onSuccess) {
            this.responseService.logoutSuccess$.pipe(take(1)).subscribe(() => onSuccess());
        }
    }

    loadContacts(payload: LoadContactsPayload, onSuccess?: () => void) {
        this.socketService.sendMessage({ type: ClientMessageType.LOAD_CONTACTS, payload });
        if (onSuccess) {
            this.responseService.contactsLoaded$.pipe(take(1)).subscribe(() => onSuccess());
        }
    }

    searchForUserById(payload: SearchForUserByIdPayload, onSuccess?: (result: Array<{
      contactId: number;
      username: string;
      avatar: string;
    }>) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.SEARCH_FOR_USER_BY_ID, payload });
        if (onSuccess) {
            this.responseService.searchForUserResult$.pipe(take(1)).subscribe((result) => onSuccess(result.users));
        }
    }

    searchForUserByName(payload: SearchForUserByUserNamePayload, onSuccess?: (result: Array<{
      contactId: number;
      username: string;
      avatar: string;
    }>) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.SEARCH_FOR_USER_BY_NAME, payload });
        if (onSuccess) {
            this.responseService.searchForUserResult$.pipe(take(1)).subscribe((result) => onSuccess(result.users));
        }
    }

    loadFriendRequest(payload: LoadContactsPayload, onSuccess?: (requestList: Array<{
      id: number;
      requesterId: number;
      targetId: number;
      requesterUsername: string;
      targetUsername: string;
      requesterAvatar: string;
      targetAvatar: string;
      status: 'pending' | 'accepted' | 'refused';
    }>) => void, onError?: (err: string) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.LOAD_FRIEND_REQUEST, payload });
        if (onSuccess) {
            this.responseService.friendRequestsLoaded$.pipe(take(1)).subscribe((result) => onSuccess(result.requestList));
        }
        if (onError) {
            this.responseService.friendRequestsLoadedFailed$.pipe(take(1)).subscribe(err => onError(err.error));
        }
    }

    addFriendRequest(payload: AddFriendRequestPayload, onSuccess?: (friendRequestId: number) => void, onError?: (err: string) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.ADD_FRIEND_REQUEST, payload });
        if (onSuccess) {
            this.responseService.friendRequestAdded$.pipe(take(1)).subscribe((result) => onSuccess(result.id));
        }
        if (onError) {
            this.responseService.friendRequestAddedFailed$.pipe(take(1)).subscribe(err => onError(err.error));
        }
    }

    refuseFriendRequest(payload: RefuseFriendRequestPayload, onSuccess?: (friendRequestId: number) => void, onError?: (err: string) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.REFUSE_FRIEND_REQUEST, payload });
        if (onSuccess) {
            this.responseService.friendRequestRefused$.pipe(take(1)).subscribe((result) => onSuccess(result.id));
        }
        if (onError) {
            this.responseService.friendRequestRefusedFailed$.pipe(take(1)).subscribe(err => onError(err.error))
        }
    }

    acceptFriendRequest(payload: AcceptFriendRequestPayload, onSuccess?: (friendRequestId: number) => void, onError?: (err: string) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.ACCEPT_FRIEND_REQUEST, payload });
        if (onSuccess) {
            this.responseService.friendRequestAccepted$.pipe(take(1)).subscribe((result) => onSuccess(result.id));
        }
        if (onError) {
            this.responseService.friendRequestAcceptedFailed$.pipe(take(1)).subscribe(err => onError(err.error));
        }
    }

    loadMessages(payload: LoadMessagesPayload, onSuccess?: (messages: Array<Message>) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.LOAD_MESSAGES, payload });
        if (onSuccess) {
            this.responseService.messagesLoaded$.pipe(take(1)).subscribe((result) => onSuccess(result.messages));
        }
    }

    sendMessage(payload: SendMessagePayload, onSuccess?: () => void) {
        this.socketService.sendMessage({ type: ClientMessageType.SEND_MESSAGE, payload });
        if (onSuccess) {
            this.responseService.messageReceivedSelf$.pipe(
                filter(msg => msg.messageId === payload.messageId),
                take(1)
            ).subscribe(() => onSuccess());
        }
    }

    sendFile(payload: SendFilePayload, onSuccess?: () => void) {
        this.socketService.sendMessage({ type: ClientMessageType.SEND_FILE, payload });
        if (onSuccess) {
            this.responseService.messageReceivedSelf$.pipe(
                filter(msg => msg.messageId === payload.messageId),
                take(1)
            ).subscribe(() => onSuccess());
        }
    }

    sendImage(payload: SendImagePayload, onSuccess?: () => void) {
        this.socketService.sendMessage({ type: ClientMessageType.SEND_IMAGE, payload });
        if (onSuccess) {
            this.responseService.messageReceivedSelf$.pipe(
                filter(msg => msg.messageId === payload.messageId),
                take(1)
            ).subscribe(() => onSuccess());
        }
    }

    markRead(payload: MarkReadPayload) {
        this.socketService.sendMessage({ type: ClientMessageType.MARK_READ, payload });
    }

    clearMessages(payload: ClearMessagesPayload, onSuccess?: () => void) {
        this.socketService.sendMessage({ type: ClientMessageType.CLEAR_MESSAGES, payload });
        if (onSuccess) {
            this.responseService.messagesCleared$.pipe(take(1)).subscribe(() => onSuccess());
        }
    }
}
