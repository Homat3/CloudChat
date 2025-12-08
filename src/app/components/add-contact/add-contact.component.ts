import { Component, EventEmitter, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RequestService } from '../../core/services/request.service';
import { ResponseService } from '../../core/services/response.service';
import { Contact } from '../../core/models';
import { AuthService } from '../../core/services/auth.service';

@Component({
  selector: 'app-add-contact',
  templateUrl: './add-contact.component.html',
  styleUrls: ['./add-contact.component.css'],
  standalone: true,
  imports: [CommonModule, FormsModule]
})
export class AddContactComponent {
  @Output() closeAddContact = new EventEmitter<void>();

  searchType: 'id' | 'username' = 'id';
  searchId: number | null = null;
  searchUsername: string = '';
  searchResult: Array<{ contactId: number; username: string; avatar: string; }> | null = null;
  searchError: string = '';
  selectedContactId: number | null = null;

  constructor(
    private requestService: RequestService,
    private authService: AuthService
  ) {}

  onSearchTypeChange() {
    this.searchResult = null;
    this.searchError = '';
    this.selectedContactId = null;
  }

  searchContact() {
    this.searchResult = [];
    this.searchError = '';
    this.selectedContactId = null;

    const currentUser = this.authService.currentUserValue;
    if (!currentUser) {
      this.searchError = '用户未登录';
      return;
    }

    if (this.searchType === 'id' && this.searchId) {
      // 通过ID搜索
      this.requestService.searchForUserById({ userId: this.searchId },
        result => {this.searchResult = result;}
      );
    } else if (this.searchType === 'username' && this.searchUsername.trim()) {
      // 通过用户名搜索
      this.requestService.searchForUserByName({ username: this.searchUsername.trim() },
        result => {this.searchResult = result;}
      );
    } else {
      this.searchError = '请输入有效的搜索条件';
      return;
    }

    // 设置超时处理
    setTimeout(() => {
      if (!this.searchResult) {
        this.searchError = '搜索超时，请重试';
      }
    }, 5000);
  }

  addSelectedContact() {
    if (this.selectedContactId) {
      this.addContact(this.selectedContactId);
    }
  }

  addContact(targetId: number) {
    const currentUser = this.authService.currentUserValue;
    if (currentUser) {
      this.requestService.addContact({ userId: currentUser.userId, targetId: targetId });
      // 可以在这里添加成功提示
      this.close();
    }
  }

  close() {
    this.closeAddContact.emit();
  }

  closeOverlay(event: Event) {
    if (event.target === event.currentTarget) {
      this.close();
    }
  }
}