import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { UserManagerService } from '../services/user-manager.service';

export const authGuard: CanActivateFn = (route, state) => {
    const userManager = inject(UserManagerService);
    const router = inject(Router);

    if (userManager.isLoggedIn()) {
        return true;
    }

    // 如果未登录，重定向到登录页
    return router.createUrlTree(['/login']);
};
