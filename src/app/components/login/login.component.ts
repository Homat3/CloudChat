import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { RequestService } from '../../core/services/request.service';
import { AuthService } from '../../core/services/auth.service';

@Component({
    selector: 'app-login',
    standalone: true,
    imports: [CommonModule, FormsModule],
    templateUrl: './login.component.html',
    styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
    username = '';
    password = '';
    isLoading = false;
    errorMessage = '';

    constructor(
        private router: Router,
        private requestService: RequestService,
        private authService: AuthService
    ) { }

    ngOnInit(): void {
        if (this.authService.currentUserValue) {
            this.router.navigate(['/chat']);
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
                // Navigation is handled in AuthService
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
