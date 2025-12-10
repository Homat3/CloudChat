import {Injectable} from '@angular/core';
import {BehaviorSubject, Observable} from 'rxjs';
import {User} from '../models';
import {ResponseService} from './response.service';
import {Router} from '@angular/router';
import {LoginSuccessPayload, RegisterSuccessPayload} from '../protocol/service.protocol';

type LoginPayload = LoginSuccessPayload | RegisterSuccessPayload;

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
        this.responseService.loginSuccess$.subscribe((payload) => this.login(payload, this.currentUserSubject));

        this.responseService.registerSuccess$.subscribe((payload) => this.login(payload, this.currentUserSubject));

        this.responseService.profileUpdatedSuccess$.subscribe((payload) => {
          this.currentUserSubject.next(new User(payload.userId, payload.username, payload.email, payload.avatar));
        });

        this.isReady$ = this.responseService.isReady$;
    }

    private login(payload: LoginPayload, currentUserSubject: BehaviorSubject<User | null>){
      const user = new User(payload.userId, payload.username, payload.email, payload.avatar, payload.token);
      currentUserSubject.next(user);
      localStorage.setItem('localToken', payload.token)
      localStorage.setItem('localUsername', payload.username)
      this.router.navigate(['/']);
    }

    public get currentUserValue(): User | null {
        return this.currentUserSubject.value;
    }

    public logout() {
        this.currentUserSubject.next(null);
        localStorage.removeItem('localToken')
        localStorage.removeItem('localUsername')
        this.router.navigate(['/login']);
    }
}
