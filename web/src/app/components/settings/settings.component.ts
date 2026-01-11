import {Component, OnInit} from '@angular/core';
import {CommonModule} from '@angular/common';
import {Router, RouterLink} from '@angular/router';
import {FormsModule} from '@angular/forms';
import {RequestService} from '../../core/services/request.service';
import {AuthService} from '../../core/services/auth.service';
import {User} from '../../core/models';

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
            this.avatar = user.avatar;
        }
    }

    onLogout(): void {
        const user = this.authService.currentUserValue;
        if (user) {
            this.requestService.logout({ userId: user.userId });
            this.authService.logout();
        }
    }

    onEditProfile(): void {
        this.router.navigate(['/profile-update']);
    }
}
