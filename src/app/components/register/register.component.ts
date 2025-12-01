import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { UserManagerService } from '../../core/services/user-manager.service';

@Component({
    selector: 'app-register',
    standalone: true,
    imports: [CommonModule, FormsModule],
    templateUrl: './register.component.html',
    styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {
    username = '';
    password = '';
    password_repeat = '';
    email = '';
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

    onRegister(): void {
      if (!this.username || !this.password) {
        this.errorMessage = '请输入用户名和密码';
        return;
      }

      if (this.username != this.password_repeat) {
        this.errorMessage = '两次输入密码不一致';
        return;
      }

      if (!this.email) {
        this.errorMessage = '请输入邮箱';
        return;
      }

      this.isLoading = true;
      this.errorMessage = '';

      // 调用服务层的登录请求
      this.userManager.requireRegister(this.username, this.password, this.email, message => {this.errorMessage = message});
    }
}
