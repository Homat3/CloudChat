import { Injectable } from '@angular/core';
import { SocketService } from './socket.service';
import { ResponseService } from './response.service';
import { ClientMessageType, LoginPayload, LoginByTokenPayload, RegisterPayload, UpdateProfilePayload, LogoutPayload, LoadContactsPayload, AddContactPayload, DeleteContactPayload, LoadMessagesPayload, SendMessagePayload, SendFilePayload, SendImagePayload, MarkReadPayload, ClearMessagesPayload } from '../protocol/client.protocol';
import { filter, take } from 'rxjs/operators';
import {LoginSuccessPayload} from '../protocol/service.protocol';

@Injectable({
    providedIn: 'root'
})
export class RequestService {

    constructor(
        private socketService: SocketService,
        private responseService: ResponseService
    ) { }

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

    register(payload: RegisterPayload, onSuccess?: () => void, onError?: (err: string) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.REGISTER, payload });
        if (onSuccess) {
            this.responseService.registerSuccess$.pipe(take(1)).subscribe(() => onSuccess());
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

    addContact(payload: AddContactPayload, onSuccess?: () => void, onError?: (err: string) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.ADD_CONTACT, payload });
        if (onSuccess) {
            this.responseService.contactAdded$.pipe(take(1)).subscribe(() => onSuccess());
        }
        if (onError) {
            this.responseService.contactAddedFailed$.pipe(take(1)).subscribe(err => onError(err.error));
        }
    }

    deleteContact(payload: DeleteContactPayload, onSuccess?: () => void, onError?: (err: string) => void) {
        this.socketService.sendMessage({ type: ClientMessageType.DELETE_CONTACT, payload });
        if (onSuccess) {
            this.responseService.contactDeleted$.pipe(take(1)).subscribe(() => onSuccess());
        }
        if (onError) {
            this.responseService.contactDeletedFailed$.pipe(take(1)).subscribe(err => onError(err.error));
        }
    }

    loadMessages(payload: LoadMessagesPayload, onSuccess?: () => void) {
        this.socketService.sendMessage({ type: ClientMessageType.LOAD_MESSAGES, payload });
        if (onSuccess) {
            this.responseService.messagesLoaded$.pipe(take(1)).subscribe(() => onSuccess());
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
