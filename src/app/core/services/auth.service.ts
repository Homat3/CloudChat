import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { User } from '../models';
import { ResponseService } from './response.service';
import { Router } from '@angular/router';

@Injectable({
    providedIn: 'root'
})
export class AuthService {
    public isReady$: Observable<boolean>;

    private currentUserSubject = new BehaviorSubject<User | null>(null);
    public currentUser$ = this.currentUserSubject.asObservable();

    constructor(
        private responseService: ResponseService,
        private router: Router
    ) {
        this.responseService.loginSuccess$.subscribe(payload => {
            const user = new User(payload.userId, payload.username, payload.email, payload.avatar, payload.token);
            this.currentUserSubject.next(user);
            localStorage.setItem('localToken', payload.token)
            localStorage.setItem('localUsername', payload.username)
            this.router.navigate(['/']); // Assuming '/chat' is the main route
        });

        this.responseService.registerSuccess$.subscribe(payload => {
            const user = new User(payload.userId, payload.username, payload.email, payload.avatar, payload.token);
            this.currentUserSubject.next(user);
            localStorage.setItem('localToken', payload.token)
            localStorage.setItem('localUsername', payload.username)
            this.router.navigate(['/']);
        });

        this.responseService.logoutSuccess$.subscribe(() => {
            this.currentUserSubject.next(null);
            localStorage.removeItem('localToken')
            localStorage.removeItem('localUsername')
            this.router.navigate(['/login']);
        });

        this.isReady$ = this.responseService.isReady$;
    }

    public get currentUserValue(): User | null {
        return this.currentUserSubject.value;
    }
}
