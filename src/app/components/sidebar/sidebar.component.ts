import { Component, Output, EventEmitter, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Contact } from '../../core/models';
import { RequestService } from '../../core/services/request.service';
import { AuthService } from '../../core/services/auth.service';

interface SharedFile {
  id: number;
  name: string;
  size: string;
  type: 'image' | 'document';
}

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css'],
  standalone: true,
  imports: [CommonModule]
})
export class SidebarComponent {
  @Output() settingChanged = new EventEmitter<string>();
  @Input() selectedContact: Contact | null = null;
  sharedFiles: SharedFile[] = [];

  constructor(
    private requestService: RequestService,
    private authService: AuthService
  ) { }

  handleSetting(setting: string) {
    this.settingChanged.emit(setting);
    switch (setting) {
      case 'clear':
        const currentUser = this.authService.currentUserValue;
        if (currentUser && this.selectedContact) {
          this.requestService.clearMessages({
            requesterUserId: currentUser.userId,
            targetUserId: this.selectedContact.contactId
          });
          console.log('清空聊天记录');
        }
        break;
      case 'logout':
        const user = this.authService.currentUserValue;
        if (user) {
          this.requestService.logout({ userId: user.userId });
        }
        break;
      default:
        console.log('未定义的设置:', setting);
    }
  }

  downloadFile(file: SharedFile) {
    console.log('下载文件:', file.name);
  }

  previewFile(file: SharedFile) {
    console.log('预览文件:', file.name);
  }
}
