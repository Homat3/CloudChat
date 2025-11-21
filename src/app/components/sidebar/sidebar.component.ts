import { Component, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ChatContact } from '../../core/models/chat-contact';
import { ContactManagerService } from '../../core/services/contact-manager.service';

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
  sharedFiles: SharedFile[] = [];

  constructor(private contactManager: ContactManagerService) { }

  get selectedContact(): ChatContact | null {
    return this.contactManager.getSelectedContact();
  }

  handleSetting(setting: string) {
    this.settingChanged.emit(setting);
    switch (setting) {
      case 'mute':
        console.log('消息免打扰');
        break;
      case 'clear':
        console.log('清空聊天记录');
        break;
    }
  }

  downloadFile(file: SharedFile) {
    console.log('下载文件:', file.name);
  }

  previewFile(file: SharedFile) {
    console.log('预览文件:', file.name);
  }
}