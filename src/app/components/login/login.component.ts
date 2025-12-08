import {AfterContentInit, Component, OnInit} from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { RequestService } from '../../core/services/request.service';
import { AuthService } from '../../core/services/auth.service';
import {timeout} from 'rxjs';
import {timeoutProvider} from 'rxjs/internal/scheduler/timeoutProvider';

@Component({
    selector: 'app-login',
    standalone: true,
    imports: [CommonModule, FormsModule],
    templateUrl: './login.component.html',
    styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit, AfterContentInit {
    username = '';
    password = '';
    isLoading = false;
    errorMessage = '';

    constructor(
        private router: Router,
        private requestService: RequestService,
        private authService: AuthService
    ) { }

    ngAfterContentInit(): void {
        let subscription = this.authService.isReady$.subscribe(isReady => {
          if (isReady) {
            this.tryToken();
            subscription.unsubscribe();
          }
        });
    }

    ngOnInit(): void {
        if (this.authService.currentUser$) {
            this.router.navigate(['/']);
        }
    }

    async tryToken(): Promise<void> {
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
    }

    onRegister(): void {
        this.router.navigate(['/register']);
    }
}
