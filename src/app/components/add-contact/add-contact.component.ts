import {AfterContentInit, Component, EventEmitter, Output} from '@angular/core';
import {CommonModule} from '@angular/common';
import {FormsModule} from '@angular/forms';
import {RequestService} from '../../core/services/request.service';
import {FriendRequest, FriendRequestInfo, User} from '../../core/models';
import {AuthService} from '../../core/services/auth.service';
import {FriendRequestService} from '../../core/services/friend_request.service';

@Component({
  selector: 'app-add-contact',
  templateUrl: './add-contact.component.html',
  styleUrls: ['./add-contact.component.css'],
  standalone: true,
  imports: [CommonModule, FormsModule]
})
export class AddContactComponent implements AfterContentInit  {
  @Output() closeAddContact = new EventEmitter<void>();

  searchType: 'id' | 'username' = 'id';
  searchId: number | null = null;
  searchUsername: string = '';
  searchResult: Array<{ contactId: number; username: string; avatar: string; }> | null = null;
  searchError: string = '';
  selectedContact: { contactId: number; username: string; avatar: string; } | null = null;

  friendRequests: Map<number, FriendRequestInfo> | undefined;

  constructor(
    private requestService: RequestService,
    private friendRequestService: FriendRequestService,
    private authService: AuthService
  ) {}

  ngAfterContentInit(): void {
    let subscription = this.requestService.isReady$.subscribe(isReady => {
      if (isReady) {
        this.loadFriendRequests();
        subscription.unsubscribe();
      }
    });
    this.friendRequestService.isReady$.subscribe(isReady => {
      if (isReady) {
        this.friendRequestService.friendRequestMap$.subscribe(requests => {
          this.friendRequests = requests;
        })
      }
    })
  }

  loadFriendRequests(): void {
    const currentUser = this.authService.currentUserValue;
    if (currentUser) {
      this.requestService.loadFriendRequest({ userId: currentUser.userId });
    }
  }

  onSearchTypeChange() {
    this.searchResult = null;
    this.searchError = '';
    this.selectedContact = null;
  }

  searchContact() {
    this.searchResult = null;
    this.searchError = '';
    this.selectedContact = null;

    const currentUser = this.authService.currentUserValue;
    if (!currentUser) {
      this.searchError = '用户未登录';
      return;
    }

    if (this.searchType === 'id' && this.searchId) {
      // 通过ID搜索
      this.requestService.searchForUserById({ userId: this.searchId },
        result => {
        this.searchResult = result.filter(contact => contact.contactId !== currentUser.userId);
      });
    } else if (this.searchType === 'username' && this.searchUsername.trim()) {
      // 通过用户名搜索
      this.requestService.searchForUserByName({ username: this.searchUsername.trim() },
        result => {
          this.searchResult = result.filter(contact => contact.contactId !== currentUser.userId);
        });
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

  addContact() {
    const currentUser = this.authService.currentUserValue;
    if (currentUser) {
      this.requestService.addFriendRequest(this.createFriendRequest(currentUser, this.selectedContact!));
      console.log('请求添加联系人: ' + this.selectedContact?.username + '(' + this.selectedContact!.contactId + ')');
      this.close();
    }
  }

  private createFriendRequest(currentUser: User, targetContact: { contactId: number; username: string; avatar: string; }): FriendRequestInfo {
    return {
      id: -1,
      requesterId: currentUser.userId,
      requesterUsername: currentUser.username,
      requesterAvatar: currentUser.avatar,
      targetId: targetContact.contactId,
      targetUsername: targetContact.username,
      targetAvatar: targetContact.avatar,
      status: 'pending'
    };
  }

  // 判断是否是当前用户发起的请求
  isCurrentUserRequester(request: FriendRequest): boolean {
    const currentUser = this.authService.currentUserValue;
    return currentUser ? request.requesterId === currentUser.userId : false;
  }

  // 接受好友请求
  acceptRequest(request: FriendRequest): void {
    this.requestService.acceptFriendRequest({
      id: request.id
    }, );
  }

  // 拒绝好友请求
  refuseRequest(request: FriendRequest): void {
    this.requestService.refuseFriendRequest({
      id: request.id
    });
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
