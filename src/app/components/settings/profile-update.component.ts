import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { RequestService } from '../../core/services/request.service';
import { AuthService } from '../../core/services/auth.service';
import { User } from '../../core/models';

@Component({
    selector: 'app-profile-update',
    standalone: true,
    imports: [CommonModule, FormsModule],
    templateUrl: './profile-update.component.html',
    styleUrls: ['./profile-update.component.css']
})
export class ProfileUpdateComponent implements OnInit {
    username = '';
    email = '';
    password = '';
    avatar = '';
    presetAvatars: string[] = [
        'default.png'
    ];
    selectedPresetAvatar: number | null = null;
    isLoading = false;
    errorMessage: string | null = null;
    successMessage: string | null = null;
    currentUser: User | null = null;

    constructor(
        private requestService: RequestService,
        private authService: AuthService,
        private router: Router
    ) { }

    ngOnInit() {
        const user = this.authService.currentUserValue;
        if (user) {
            this.currentUser = user;
            this.username = user.username;
            this.email = user.email;
            this.avatar = user.avatar || '';

            // 查找当前头像在预设头像中的位置
            if (user.avatar) {
                const index = this.presetAvatars.indexOf(user.avatar);
                if (index !== -1) {
                    this.selectedPresetAvatar = index;
                }
            }
        }
    }

    onBack(): void {
        this.router.navigate(['/settings']);
    }

    selectPresetAvatar(avatar: string, index: number): void {
        this.selectedPresetAvatar = index;
        this.avatar = avatar;
    }

    onSubmit(): void {
        this.errorMessage = null;
        this.successMessage = null;

        if (!this.username.trim()) {
            this.errorMessage = '用户名不能为空';
            return;
        }

        if (!this.email.trim()) {
            this.errorMessage = '邮箱不能为空';
            return;
        }

        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(this.email)) {
            this.errorMessage = '请输入有效的邮箱地址';
            return;
        }

        if (this.selectedPresetAvatar === null && !this.avatar) {
            this.errorMessage = '请选择一个头像';
            return;
        }

        if (this.currentUser) {
            const isUsernameChanged = this.username !== this.currentUser.username;
            const isEmailChanged = this.email !== this.currentUser.email;
            const isAvatarChanged = this.avatar !== this.currentUser.avatar;

            if (!isUsernameChanged && !isEmailChanged && !isAvatarChanged) {
                this.errorMessage = '没有更改任何信息';
                return;
            }
        }

        this.isLoading = true;

        const payload = {
            userId: this.currentUser?.userId || 0,
            username: this.username,
            password: this.password || '',
            email: this.email,
            avatar: this.avatar || ''
        };

        this.requestService.updateProfile(
            payload,
            () => {
                this.isLoading = false;
                this.successMessage = '个人信息更新成功';

                setTimeout(() => {
                    this.router.navigate(['/settings']);
                }, 200);
            },
            (error) => {
                this.isLoading = false;
                this.errorMessage = error || '更新失败，请稍后重试';
            }
        );


        setTimeout(() => {
          if (!this.successMessage && !this.errorMessage){
            this.isLoading = false;
            this.errorMessage = '更新请求超时，请重试';
          }
        }, 5000);
    }
}
