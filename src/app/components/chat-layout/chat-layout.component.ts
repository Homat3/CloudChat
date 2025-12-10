import {Component, Inject, PLATFORM_ID} from '@angular/core';
import {isPlatformBrowser} from '@angular/common';
import {ContactListComponent} from '../contact-list/contact-list.component';
import {Contact} from '../../core/models';
import {ChatAreaComponent} from '../chat-area/chat-area.component';
import {SidebarComponent} from '../sidebar/sidebar.component';
import {AddContactComponent} from '../add-contact/add-contact.component';

// 定义视图部分枚举
enum ActiveView {
  Contacts = 'contacts',
  Chat = 'chat',
  Settings = 'settings'
}

@Component({
  selector: 'app-chat-layout',
  templateUrl: './chat-layout.component.html',
  styleUrls: ['./chat-layout.component.css'],
  standalone: true,
  imports: [ContactListComponent, ChatAreaComponent, SidebarComponent, AddContactComponent]
})
export class ChatLayoutComponent {
  activeView: ActiveView = ActiveView.Contacts; // 默认激活联系人视图
  ActiveView = ActiveView; // 使枚举在模板中可用
  isMobile = false;
  showAddContact = false;

  constructor(
    @Inject(PLATFORM_ID) private platformId: Object
  ) {
    if (isPlatformBrowser(this.platformId)) {
      this.isMobile = window.innerWidth <= 768;
      // 监听窗口大小变化
      window.addEventListener('resize', () => {
        this.isMobile = window.innerWidth <= 768;
      });

      // 监听显示添加联系人对话框事件
      window.addEventListener('showAddContactDialog', () => {
        this.showAddContactDialog();
      });
    }
  }

  selectedContactState: Contact | null = null;

  onContactSelected(contact: Contact) {
    this.selectedContactState = contact;
    // 在移动端，选择联系人后切换到聊天视图
    if (this.isMobile) {
      this.activeView = ActiveView.Chat;
    }
  }

  onSettingChanged(setting: string) {
    console.log('设置已更改:', setting);
  }

  get selectedContact(): Contact | null {
    return this.selectedContactState;
  }

  // 切换视图的方法
  setActiveView(view: ActiveView) {
    this.activeView = view;
  }

  // 显示添加联系人对话框
  showAddContactDialog() {
    this.showAddContact = true;
  }
}
