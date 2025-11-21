import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { User } from '../models/user';
import { SocketService } from './socket.service';
import { MessageType, ProtocolMessage } from '../protocol/message-protocol';

@Injectable({
    providedIn: 'root'
})
export class UserManagerService {
    private currentUserSubject = new BehaviorSubject<User | null>(null);
    public currentUser$ = this.currentUserSubject.asObservable();

    constructor(private socketService: SocketService) {
        const token = localStorage.getItem('user_token');
        if (token) {
            // 恢复用户状态，这里简化处理，直接使用mock用户
            // 实际项目中应该用token去换取用户信息
            this.testUser.token = token;
            this.currentUserSubject.next(this.testUser);
        }

        this.socketService.getMessages().subscribe((message: ProtocolMessage) => {
            switch (message.type) {
                case MessageType.LOGIN_SUCCESS:
                    this.login(message.payload);
                    break;
                case MessageType.REGISTER_SUCCESS:
                    this.register(message.payload);
                    break;
                case MessageType.PROFILE_UPDATED:
                    this.updateProfile(message.payload);
                    break;
            }
        });
    }

    private testUser: User = {
        id: 1,
        username: 'TestUser',
        email: 'test@example.com',
        avatar: 'TU',
        token: 'mock-token-12345'
    };

    // Request functions (placeholders)
    requireLogin(username: string, password: string): void {
        this.socketService.sendMessage({
            type: MessageType.LOGIN,
            payload: { username, password }
        });
    }

    requireRegister(username: string, password: string, email: string): void {
        this.socketService.sendMessage({
            type: MessageType.REGISTER,
            payload: { username, password, email }
        });
    }

    requireLogout(): void {
        this.socketService.sendMessage({
            type: MessageType.LOGOUT,
            payload: null
        });
    }

    requireUpdateProfile(user: Partial<User>): void {
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
        // 注册成功后通常会自动登录，或者跳转到登录页
        // 这里假设注册成功后直接登录
        this.currentUserSubject.next(user);
    }

    updateProfile(updatedUser: User): void {
        const currentUser = this.currentUserSubject.value;
        if (currentUser && currentUser.id === updatedUser.id) {
            this.currentUserSubject.next({ ...currentUser, ...updatedUser });
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
