import {Injectable} from '@angular/core';
import {BehaviorSubject, Observable} from 'rxjs';
import {FriendRequest, FriendRequestInfo} from '../models';
import {ResponseService} from './response.service';

@Injectable({
  providedIn: 'root'
})
export class FriendRequestService {
  public isReady$: Observable<boolean>;

  private friendRequestMapSubject: BehaviorSubject<Map<number, FriendRequestInfo>> = new BehaviorSubject<Map<number, FriendRequestInfo>>(new Map<number, FriendRequest>());
  public friendRequestMap$ = this.friendRequestMapSubject.asObservable();

  constructor(private responseService: ResponseService) {
    // 监听好友请求相关事件并更新好友请求列表
    this.responseService.friendRequestsLoaded$.subscribe(payload => {
      let newFriendRequests = new Map<number, FriendRequestInfo>();
      payload.requestList.forEach(r => newFriendRequests.set(r.id, r));
      this.friendRequestMapSubject.next(newFriendRequests);
    });

    this.responseService.friendRequestAdded$.subscribe(payload => {
      let newFriendRequests = this.friendRequestMapSubject.value;
      newFriendRequests.set(payload.id, payload);
      this.friendRequestMapSubject.next(newFriendRequests);
    });

    this.responseService.addFriendRequest$.subscribe(payload => {
      let newFriendRequests = this.friendRequestMapSubject.value;
      newFriendRequests.set(payload.id, payload);
      this.friendRequestMapSubject.next(newFriendRequests);
    });

    this.responseService.friendRequestAccepted$.subscribe(payload => {
      let newFriendRequests = this.friendRequestMapSubject.value;
      let updateFriendRequests = newFriendRequests.get(payload.id);
      if (updateFriendRequests) {
        updateFriendRequests.status = 'accepted';
        this.friendRequestMapSubject.next(newFriendRequests);
      }
      else {
        this.responseService.friendRequestAcceptedFailed$.next({error: "接受好友请求超时，请重试"})
      }
    });

    this.responseService.friendRequestRefused$.subscribe(payload => {
      let newFriendRequests = this.friendRequestMapSubject.value;
      let updateFriendRequests = newFriendRequests.get(payload.id);
      if (updateFriendRequests) {
        updateFriendRequests.status = 'refused';
        this.friendRequestMapSubject.next(newFriendRequests);
      }
      else {
        this.responseService.friendRequestAddedFailed$.next({error: "拒绝好友请求超时，请重试"})
      }
    });

    this.responseService.acceptFriendRequest$.subscribe(payload => {
      let newFriendRequests = this.friendRequestMapSubject.value;
      let updateFriendRequests = newFriendRequests.get(payload.id);
      if (updateFriendRequests) {
        updateFriendRequests.status = 'accepted';
        this.friendRequestMapSubject.next(newFriendRequests);
      }
    })

    this.responseService.refuseFriendRequest$.subscribe(payload => {
      let newFriendRequests = this.friendRequestMapSubject.value;
      let updateFriendRequests = newFriendRequests.get(payload.id);
      if (updateFriendRequests) {
        updateFriendRequests.status = 'refused';
        this.friendRequestMapSubject.next(newFriendRequests);
      }
    })

    this.isReady$ = this.responseService.isReady$;
  }

  public get friendRequestMapValue(): Map<number, FriendRequestInfo> {
    return this.friendRequestMapSubject.value;
  }
}
