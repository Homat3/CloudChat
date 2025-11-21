import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { UserManagerService } from '../../core/services/user-manager.service';

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
        private userManager: UserManagerService,
        private router: Router
    ) { }

    ngOnInit(): void {
        // 监听登录状态，如果已登录则跳转到主页
        this.userManager.currentUser$.subscribe(user => {
            if (user) {
                this.router.navigate(['/']);
            }
        });
    }

    onLogin(): void {
        if (!this.username || !this.password) {
            this.errorMessage = '请输入用户名和密码';
            return;
        }

        this.isLoading = true;
        this.errorMessage = '';

        // 调用服务层的登录请求
        this.userManager.requireLogin(this.username, this.password);

        // 由于requireLogin是异步的且没有直接返回Promise/Observable，
        // 我们这里简单处理loading状态。实际项目中应该有更完善的状态管理。
        // 这里我们假设3秒后如果还没跳转就是超时或失败（配合Service里的console.error）
        setTimeout(() => {
            if (this.isLoading) {
                this.isLoading = false;
                // 简单提示，实际应由Service通过ErrorSubject通知
                if (!this.userManager.getCurrentUser()) {
                    this.errorMessage = '登录失败或超时，请检查用户名密码 (TestUser/123456)';
                }
            }
        }, 1500);
    }
}
