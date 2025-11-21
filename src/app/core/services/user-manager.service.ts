import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { User } from '../models/user';

@Injectable({
    providedIn: 'root'
})
export class UserManagerService {
    private currentUserSubject = new BehaviorSubject<User | null>(null);
    public currentUser$ = this.currentUserSubject.asObservable();

    constructor() {
        const token = localStorage.getItem('user_token');
        if (token) {
            // 恢复用户状态，这里简化处理，直接使用mock用户
            // 实际项目中应该用token去换取用户信息
            this.testUser.token = token;
            this.currentUserSubject.next(this.testUser);
        }
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
        // 模拟服务器请求延迟
        setTimeout(() => {
            if (username === 'TestUser' && password === '123456') {
                this.login(this.testUser);
            } else {
                console.error('登录失败：用户名或密码错误');
                // 实际项目中这里应该触发一个错误回调或Subject
            }
        }, 1000);
    }

    requireRegister(username: string, password: string, email: string): void {
        // TODO: 向服务器发出注册请求
        // TODO: 回调register
    }

    requireUpdateProfile(user: Partial<User>): void {
        // TODO: 向服务器发出更新个人信息请求
        // TODO: 回调updateProfile
    }

    requireLogout(): void {
        // TODO: 向服务器发出登出请求
        // TODO: 回调logout
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
