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
                this.router.navigate(['/'])
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
        this.userManager.requireLogin(this.username, this.password, message => {this.errorMessage = message});
    }

    onRegister(): void {
        this.router.navigate(['/register']);
    }
}
