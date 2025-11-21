import { Injectable } from '@angular/core';
import { UserManagerService } from './user-manager.service';
import { Router } from '@angular/router';

@Injectable({
    providedIn: 'root'
})
export class SettingsManagerService {

    constructor(
        private userManager: UserManagerService,
        private router: Router
    ) { }

    logout(): void {
        // 调用UserManagerService的logout方法清除token和状态
        this.userManager.logout();
        // 跳转到登录页
        this.router.navigate(['/login']);
    }

    // 其他设置相关的请求方法
}
