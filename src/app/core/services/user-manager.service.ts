import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { isUser, User } from '../models/user';
import { SocketService } from './socket.service';
import {
  LoginByTokenPayload,
  LoginPayload,
  LoginSuccessPayload, LogoutPayload,
  MessageType,
  ProtocolMessage,
  RegisterPayload, UpdateProfilePayload
} from '../protocol/message-protocol';

@Injectable({
    providedIn: 'root'
})
export class UserManagerService {
    private currentUserSubject = new BehaviorSubject<User | null>(null);
    public currentUser$ = this.currentUserSubject.asObservable();

    private loginFailedCallback: ( message: string ) => void = () => {};
    private registerFailedCallback: ( message: string ) => void = () => {};

    constructor(private socketService: SocketService) {
        const token = localStorage.getItem('user_token');
        if (token) {
          this.requireLoginFromToken(token)
        }

        this.socketService.getMessages().subscribe((message: ProtocolMessage) => {
            switch (message.type) {
              case MessageType.LOGIN_SUCCESS: {
                if (isUser(message.payload))
                  this.login(message.payload);
                else
                  this.loginFailedCallback('Invalid login response');
                break;
              }
              case MessageType.LOGIN_FAILURE: {
                this.loginFailedCallback(message.payload.error);
                break;
              }
              case MessageType.REGISTER_SUCCESS:{
                if (isUser(message.payload))
                  this.register(message.payload);
                else
                  this.registerFailedCallback('Invalid login response');
                break;
              }
              case MessageType.PROFILE_UPDATED: {
                this.registerFailedCallback(message.payload.error);
                break;
              }
              case MessageType.LOGOUT: {
                this.logout();
                break;
              }
            }
        });
    }

  // Request functions (placeholders)
    requireLoginFromToken(token: string): void{
      let info: LoginByTokenPayload = {
        token: token
      };
      this.socketService.sendMessage({
        type: MessageType.LOGIN_BY_TOKEN,
        payload: info
      });
    }

    requireLogin(username: string, password: string, callback: ( message: string ) => void): void {
      let info: LoginPayload = {
        username : username,
        password : password
      };
      this.loginFailedCallback = callback;
      this.socketService.sendMessage({
          type: MessageType.LOGIN,
          payload: info
      });
    }

    requireRegister(username: string, password: string, email: string, callback: ( message: string ) => void): void {
      let info: RegisterPayload = {
        username : username,
        password : password,
        email : email
      };
      this.registerFailedCallback = callback;
      this.socketService.sendMessage({
          type: MessageType.REGISTER,
          payload: info
      });
    }

    requireLogout(): void {
      if (!this.isLoggedIn() || !this.isLoggedIn()) return;
      let info: LogoutPayload = {
        userId : this.getCurrentUser()!!.userId
      };
      this.socketService.sendMessage({
          type: MessageType.LOGOUT,
          payload: info
      });
    }

    requireUpdateProfile(user: User, password: string): void {
      let info: UpdateProfilePayload = {
        userId : user.userId,
        username : user.username,
        password : password,
        email : user.email,
        avatar : user.avatar
      }
      this.socketService.sendMessage({
          type: MessageType.UPDATE_PROFILE,
          payload: user
      });
    }

    // Callback functions (local state updates)
    login(user: User): void {
        this.currentUserSubject.next(user);
        if (user.token) {
            localStorage.setItem('user_token', user.token);
        }
    }

    register(user: User): void {
        this.currentUserSubject.next(user);
    }

    updateProfile(updatedUser: User): void {
        const currentUser = this.currentUserSubject.value;
        if (currentUser && currentUser.userId === updatedUser.userId) {
          let newUser: User = {
            userId: currentUser.userId,
            username: updatedUser.username,
            email: updatedUser.email,
            avatar: updatedUser.avatar,
            token: currentUser.token
          };
          this.currentUserSubject.next(newUser);
        }
    }

    logout(): void {
        this.currentUserSubject.next(null);
        localStorage.removeItem('user_token');
    }

    isLoggedIn(): boolean {
        return !!this.currentUserSubject.value;
    }

    getCurrentUser(): User | null {
        return this.currentUserSubject.value;
    }
}
