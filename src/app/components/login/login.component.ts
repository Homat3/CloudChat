import {AfterContentInit, Component, OnDestroy, OnInit} from '@angular/core';
import {CommonModule} from '@angular/common';
import {FormsModule} from '@angular/forms';
import {Router} from '@angular/router';
import {RequestService} from '../../core/services/request.service';
import {AuthService} from '../../core/services/auth.service';
import {Subscription} from 'rxjs';

@Component({
    selector: 'app-login',
    standalone: true,
    imports: [CommonModule, FormsModule],
    templateUrl: './login.component.html',
    styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit, AfterContentInit, OnDestroy {
    username = '';
    password = '';
    isLoading = false;
    errorMessage = '';

    private subscriptions: Subscription[] = [];

    constructor(
        private router: Router,
        private requestService: RequestService,
        private authService: AuthService
    ) { }

    ngOnDestroy(): void {
      this.subscriptions.forEach(sub => sub.unsubscribe());
    }

    ngAfterContentInit(): void {
        this.subscriptions.push(
          this.requestService.isReady$.subscribe(isReady => {
            if (isReady) {
              this.tryToken();
            }
          })
        );
    }

    ngOnInit(): void {
        if (this.authService.currentUser$) {
            this.router.navigate(['/']);
        }
    }

    tryToken() {
      let localToken = localStorage.getItem('localToken');
      let localUsername = localStorage.getItem('localUsername');
      if (localToken && localUsername) {
        this.requestService.loginByToken(
          { token: localToken, username: localUsername },
          () => {
            this.isLoading = false;
          },
          (error) => {
            this.isLoading = false;
            this.errorMessage = error;
          }
        );
      }
    }

    onLogin(): void {
        if (!this.username || !this.password) {
            this.errorMessage = '请输入用户名和密码';
            return;
        }

        this.isLoading = true;
        this.errorMessage = '';

        this.requestService.login(
            { username: this.username, password: this.password },
            () => {
                this.isLoading = false;
            },
            (error) => {
                this.isLoading = false;
                this.errorMessage = error;
            }
        );

        setTimeout(() => {
          if (!this.authService.currentUserValue && !this.errorMessage) {
            this.isLoading = false;
            this.errorMessage = '登录超时，请重试';
          }
        }, 5000);
    }

    onRegister(): void {
        this.router.navigate(['/register']);
    }
}
