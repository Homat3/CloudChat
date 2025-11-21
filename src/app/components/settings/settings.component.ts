import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SettingsManagerService } from '../../core/services/settings-manager.service';
import { RouterLink } from '@angular/router';

@Component({
    selector: 'app-settings',
    standalone: true,
    imports: [CommonModule, RouterLink],
    templateUrl: './settings.component.html',
    styleUrls: ['./settings.component.css']
})
export class SettingsComponent {

    constructor(private settingsManager: SettingsManagerService) { }

    onLogout(): void {
        this.settingsManager.logout();
    }
}
