import {AfterContentInit, Component, Inject, OnDestroy, Output, PLATFORM_ID} from '@angular/core';
import {isPlatformBrowser} from '@angular/common';
import {ContactListComponent} from '../contact-list/contact-list.component';
import {Contact, Message, User} from '../../core/models';
import {ChatAreaComponent} from '../chat-area/chat-area.component';
import {SidebarComponent} from '../sidebar/sidebar.component';
import {AddContactComponent} from '../contact-list/add-contact/add-contact.component';
import {Subscription} from 'rxjs';
import {MessageService} from '../../core/services/message.service';
import {RequestService} from '../../core/services/request.service';
import {AuthService} from '../../core/services/auth.service';
import {ContactService} from '../../core/services/contact.service';

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
export class ChatLayoutComponent implements AfterContentInit, OnDestroy{
  messageMap: Map<number, Message[]> = new Map();
  currentUser: User | null = null;
  contactList: Contact[] = [];
  selectedContactState: Contact | null = null;
  activeView: ActiveView = ActiveView.Contacts; // 默认激活联系人视图
  ActiveView = ActiveView; // 使枚举在模板中可用
  isMobile = false;
  showAddContact = false;

  subscriptions: Subscription[] = [];

  constructor(
    @Inject(PLATFORM_ID) private platformId: Object,
    private authService: AuthService,
    private messageService: MessageService,
    private contactService: ContactService,
    private requestService: RequestService
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

  ngAfterContentInit() {
    this.subscriptions.push(
      this.authService.isReady$.subscribe(isReady => {
        if (isReady) {
          this.subscriptions.push(
            this.authService.currentUser$.subscribe(user => {
              // 只有当用户发生变化时才加载联系人和消息
              if (user && (!this.currentUser || this.currentUser.userId !== user.userId)) {
                this.currentUser = user;
                this.loadInitialData();
              }
            })
          );
        }
      }),
      this.messageService.isReady$.subscribe(isReady => {
        if (isReady) {
          this.subscriptions.push(
            this.messageService.messageMap$.subscribe(messageMap => {
              this.messageMap = messageMap;
            })
          );
        }
      }),
      this.contactService.isReady$.subscribe(isReady => {
        if (isReady) {
          this.subscriptions.push(
            this.contactService.contactList$.subscribe(contacts => {
              this.contactList = contacts;
              if (this.contactList) {this.contactList.forEach(contact => this.loadMessagesForContact(contact));}
            })
          );
        }
      })
    )
  }

  ngOnDestroy() {
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }

  private loadInitialData() {
    if (this.currentUser) {
      const currentUserId = this.currentUser.userId;
      this.requestService.loadContacts({ userId: currentUserId });
    }
  }

  private loadMessagesForContact(contact: Contact) {
    if (this.currentUser) {
      const currentUserId = this.currentUser.userId;
      this.requestService.loadMessages({ userId: currentUserId, targetId: contact.contactId });
    }
  }

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

  messagesWithContact(contact: Contact | null, messageMap: Map<number, Message[]>): Message[] | null {
    if (!contact) {
      return null;
    }
    const messages = messageMap.get(contact.contactId);
    if (messages) {
      return messages;
    }
    return null;
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
