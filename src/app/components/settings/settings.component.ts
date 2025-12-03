import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { RequestService } from '../../core/services/request.service';
import { AuthService } from '../../core/services/auth.service';

@Component({
    selector: 'app-settings',
    standalone: true,
    imports: [CommonModule, RouterLink, FormsModule],
    templateUrl: './settings.component.html',
    styleUrls: ['./settings.component.css']
})
export class SettingsComponent implements OnInit {
    username = '';
    email = '';
    password = '';
    avatar = '';
    isLoading = false;
    errorMessage = '';
    successMessage = '';

    constructor(
        private requestService: RequestService,
        private authService: AuthService
    ) { }

    ngOnInit() {
        const user = this.authService.currentUserValue;
        if (user) {
            this.username = user.username;
            this.email = user.email;
            this.avatar = user.avatar;
        }
    }

    onLogout(): void {
        const user = this.authService.currentUserValue;
        if (user) {
            this.requestService.logout({ userId: user.userId });
        }
    }

    onUpdateProfile(): void {
        const user = this.authService.currentUserValue;
        if (!user) return;

        this.isLoading = true;
        this.errorMessage = '';
        this.successMessage = '';

        this.requestService.updateProfile(
            {
                userId: user.userId,
                username: this.username,
                email: this.email,
                password: this.password, // Only send if changed? Protocol requires it.
                avatar: this.avatar
            },
            () => {
                this.isLoading = false;
                this.successMessage = '个人资料更新成功';
            },
            (error) => {
                this.isLoading = false;
                this.errorMessage = error;
            }
        );
    }
}
