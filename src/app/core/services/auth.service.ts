import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { User } from '../models';
import { ResponseService } from './response.service';
import { Router } from '@angular/router';

@Injectable({
    providedIn: 'root'
})
export class AuthService {
    private currentUserSubject = new BehaviorSubject<User | null>(null);
    public currentUser$ = this.currentUserSubject.asObservable();

    constructor(
        private responseService: ResponseService,
        private router: Router
    ) {
        this.responseService.loginSuccess$.subscribe(payload => {
            const user = new User(payload.userId, payload.username, payload.email, payload.avatar, payload.token);
            this.currentUserSubject.next(user);
            localStorage.setItem('token', payload.token);
            this.router.navigate(['/']); // Assuming '/chat' is the main route
        });

        this.responseService.registerSuccess$.subscribe(payload => {
            const user = new User(payload.userId, payload.username, payload.email, payload.avatar, payload.token);
            this.currentUserSubject.next(user);
            localStorage.setItem('token', payload.token);
            this.router.navigate(['/']);
        });

        this.responseService.logoutSuccess$.subscribe(() => {
            this.currentUserSubject.next(null);
            localStorage.removeItem('token');
            this.router.navigate(['/login']);
        });
    }

    public get currentUserValue(): User | null {
        return this.currentUserSubject.value;
    }
}
