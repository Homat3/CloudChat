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
    private loginTimeout: any;

    constructor(
        private router: Router,
        private requestService: RequestService,
        private authService: AuthService
    ) { }

    ngOnDestroy(): void {
      this.subscriptions.forEach(sub => sub.unsubscribe());
      if (this.loginTimeout) {
        clearTimeout(this.loginTimeout);
      }
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
        if (this.authService.currentUserValue) {
            this.router.navigate(['/']);
        }
    }

    tryToken() {
      let localToken = localStorage.getItem('localToken');
      let localUsername = localStorage.getItem('localUsername');
      if (localToken && localUsername) {
        this.isLoading = true;
        this.errorMessage = '';
        this.requestService.loginByToken(
          { token: localToken, username: localUsername },
          () => {
            this.isLoading = false;
            if (this.loginTimeout) {
              clearTimeout(this.loginTimeout);
              this.loginTimeout = null;
            }
          },
          (error) => {
            this.isLoading = false;
            this.errorMessage = error;
            if (this.loginTimeout) {
              clearTimeout(this.loginTimeout);
              this.loginTimeout = null;
            }
          }
        );
      }

      this.loginTimeout = setTimeout(() => {
        if (!this.authService.currentUserValue && !this.errorMessage) {
          this.isLoading = false;
          this.errorMessage = '登录超时，请重试';
        }
        this.loginTimeout = null;
      }, 5000);
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
                if (this.loginTimeout) {
                  clearTimeout(this.loginTimeout);
                  this.loginTimeout = null;
                }
            },
            (error) => {
                this.isLoading = false;
                this.errorMessage = error;
                if (this.loginTimeout) {
                  clearTimeout(this.loginTimeout);
                  this.loginTimeout = null;
                }
            }
        );

        this.loginTimeout = setTimeout(() => {
          if (!this.authService.currentUserValue && !this.errorMessage) {
            this.isLoading = false;
            this.errorMessage = '登录超时，请重试';
          }
          this.loginTimeout = null;
        }, 5000);
    }

    onRegister(): void {
        this.router.navigate(['/register']);
    }
}
