import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { RequestService } from '../../../core/services/request.service';
import { AuthService } from '../../../core/services/auth.service';
import { User } from '../../../core/models';

@Component({
    selector: 'app-profile-update',
    standalone: true,
    imports: [CommonModule, FormsModule],
    templateUrl: './profile-update.component.html',
    styleUrls: ['./profile-update.component.css']
})
export class ProfileUpdateComponent implements OnInit {
    username: string = '';
    email: string = '';
    avatar: string = '';
    preloadAvatars: string[] = [
      'default.png',
      'avatar/Zombatar_1.jpg',
      'avatar/Zombatar_2.jpg',
      'avatar/Zombatar_3.jpg',
      'avatar/Zombatar_4.jpg',
      'avatar/Zombatar_5.jpg'
    ]; // 预设头像列表
    selectedAvatar: string = ''; // 当前选中的头像

    isLoading = false;
    errorMessage: string | null = null;
    successMessage: string | null = null;

    currentUser: User | null = null;

    constructor(
        private requestService: RequestService,
        private authService: AuthService,
        private router: Router,
    ) { }

    ngOnInit() {
        const user = this.authService.currentUserValue;
        if (user) {
            this.currentUser = user;
            this.username = user.username;
            this.email = user.email;
            this.avatar = user.avatar;
            this.selectedAvatar = user.avatar;
        }
    }

    onBack(): void {
        this.router.navigate(['/settings']);
    }

    /**
     * 选择头像
     * @param avatar 头像文件名
     */
    selectAvatar(avatar: string): void {
        this.selectedAvatar = avatar;
    }

    onSubmit(): void {
        this.errorMessage = null;
        this.successMessage = null;
        this.isLoading = true;

        // 更新avatar值为选中的头像
        this.avatar = this.selectedAvatar;

        if (!this.username.trim()) {
            this.isLoading = false;
            this.errorMessage = '用户名不能为空';
            return;
        }

        if (!this.email.trim()) {
            this.isLoading = false;
            this.errorMessage = '邮箱不能为空';
            return;
        }

        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(this.email)) {
            this.isLoading = false;
            this.errorMessage = '请输入有效的邮箱地址';
            return;
        }

        if (this.currentUser) {
            const isUsernameChanged = this.username !== this.currentUser.username;
            const isEmailChanged = this.email !== this.currentUser.email;
            const isAvatarChanged = this.avatar !== this.currentUser.avatar;

            if (!isUsernameChanged && !isEmailChanged && !isAvatarChanged) {
                this.isLoading = false;
                this.errorMessage = '没有更改任何信息';
                return;
            }

            const payload = {
                userId: this.currentUser.userId,
                username: this.username,
                password: "placeholder",
                email: this.email,
                avatar: this.avatar
            };

            this.requestService.updateProfile(
                payload,
                () => {
                    this.isLoading = false;
                    this.successMessage = '个人信息更新成功';

                    // 更新当前用户信息
                    if (this.currentUser) {
                        this.currentUser.username = this.username;
                        this.currentUser.email = this.email;
                        this.currentUser.avatar = this.avatar;
                    }
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
        else {
            this.isLoading = false;
            this.errorMessage = '登录过期';
        }
    }
}
