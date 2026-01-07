import { common } from '@kit.AbilityKit';
import { Contact, User } from '../../../../core/models/models';
import { CloudChat } from '../../../../CloudChat';
import { EventBus } from '../../../../core/service/event/EventBus';
import { Event } from '../../../../core/tag/Event';
import {
  AcceptFriendRequestPayload,
  AddFriendRequestPayload,
  LoadFriendRequestPayload,
  RefuseFriendRequestPayload,
  SearchForUserByIdPayload,
  SearchForUserByUserNamePayload
} from '../../../../core/protocol/http/client.http.protocol';
import {
  FriendRequestAcceptedPayload,
  FriendRequestAddedPayload,
  FriendRequestLoadedFailedPayload,
  FriendRequestLoadedPayload,
  FriendRequestRefusedPayload,
  SearchForUserResultPayload
} from '../../../../core/protocol/http/service.http.protocol';
import { getAvatar } from '../../../../core/util';
import { FriendRequest } from '../../../../core/models/friend_request';
import {
  AcceptFriendRequestPayload as RequireAcceptFriendRequestPayload,
  AddFriendRequestPayload as RequireAddFriendRequestPayload,
  RefuseFriendRequestPayload as RequireRefuseFriendRequestPayload,
  WebsocketServiceMessage,
  WebsocketServiceMessageType,
} from '../../../../core/protocol/websocket/service.websocket.protocol';
import { loadStringResource } from '../../../../core/service/resource/load-resource';

@Component
export struct ContactRequest {
  // 添加好友相关状态
  @State @Watch("onSearchForUsers") searchKeyword: string = '';
  @State searchedContacts: Contact[] = [];
  @State hasSearched: boolean = false;
  @State isLoading: boolean = false;
  @State searchError: string = '';
  @State sentRequests: FriendRequest[] = [];
  @State receivedRequests: FriendRequest[] = [];
  @State isSearchByName: boolean = false;
  @State activeTab: number = 0; // 当前激活的标签页
  @Prop currentUser: User | null;
  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  onSearchForUsers() {
    if (this.isSearchByName) {
      EventBus.emit(Event.SEARCH_FOR_USERS_BY_NAME, { username: this.searchKeyword } as SearchForUserByUserNamePayload);
    } else {
      EventBus.emit(Event.SEARCH_FOR_USERS_BY_ID, { userId: parseInt(this.searchKeyword) } as SearchForUserByIdPayload);
    }
  }

  aboutToAppear(): void {
    EventBus.on(Event.FRIEND_REQUEST_LOADED, ContactRequest.name, (payload: FriendRequestLoadedPayload) => {
      for (const friendRequest of payload.requests) {
        const newFriendRequest = new FriendRequest(
          friendRequest.id,
          friendRequest.requesterId, friendRequest.targetId,
          friendRequest.requesterUsername, friendRequest.targetUsername,
          friendRequest.requesterAvatar, friendRequest.targetAvatar,
          friendRequest.status
        );
        if (friendRequest.requesterId === this.currentUser?.userId) {
          this.sentRequests.push(newFriendRequest);
        } else if (friendRequest.targetId === this.currentUser?.userId) {
          this.receivedRequests.push(newFriendRequest);
        } else {
          try {
            this.uiContext.getPromptAction().showToast({
              message: "一个加载失败的好友请求：{" + newFriendRequest.requesterId + " -> " + newFriendRequest.targetId +
                '}',
              duration: 2000
            });
          } catch (error) {
            console.error(error)
          }
        }
      }
    })
    EventBus.on(Event.FRIEND_REQUEST_LOADED_FAILED, ContactRequest.name, (payload: FriendRequestLoadedFailedPayload) => {
      try {
        this.uiContext.getPromptAction().showToast({
          message: "好友请求列表加载失败" + payload.error,
          duration: 2000
        });
      } catch (error) {
        console.error(error)
      }
    })

    EventBus.on(Event.SEARCH_FOR_USERS_RESULT, ContactRequest.name, (payload: SearchForUserResultPayload) => {
      this.searchedContacts =
        payload.users.filter((contact: Contact) => !(contact.contactId === this.currentUser?.userId));
    })
    EventBus.on(Event.SEARCH_FOR_USERS_FAILED, ContactRequest.name, (err: string) => {
      try {
        this.uiContext.getPromptAction().showToast({
          message: err.toString(),
          duration: 2000
        });
      } catch (error) {
        console.error(error);
      }
    })

    EventBus.on(Event.REQUIRE_ADD_FRIEND_REQUEST, ContactRequest.name, (payload: RequireAddFriendRequestPayload) => {
      this.receivedRequests.push(new FriendRequest(
        payload.id,
        payload.requesterId, payload.targetId,
        payload.requesterUsername, payload.targetUsername,
        payload.requesterAvatar, payload.targetAvatar,
        payload.status
      ))
    });
    EventBus.on(Event.REQUIRE_REFUSE_FRIEND_REQUEST, ContactRequest.name, (payload: RequireRefuseFriendRequestPayload) => {
      this.sentRequests = this.sentRequests.map((request) => {
        if (request.id === payload.id) {
          request.status = 'refused';
        }
        return request;
      })
    });
    EventBus.on(Event.REQUIRE_ACCEPT_FRIEND_REQUEST, ContactRequest.name, (payload: RequireAcceptFriendRequestPayload) => {
      this.sentRequests = this.sentRequests.map((request) => {
        if (request.id === payload.id) {
          request.status = 'accepted';
        }
        return request;
      })
    });
    EventBus.on(Event.FRIEND_REQUEST_ADDED, ContactRequest.name, (payload: FriendRequestAddedPayload) => {
      this.sentRequests.push(new FriendRequest(
        payload.id,
        payload.requesterId, payload.targetId,
        payload.requesterUsername, payload.targetUsername,
        payload.requesterAvatar, payload.targetAvatar,
        payload.status
      ))
    })
    EventBus.on(Event.FRIEND_REQUEST_ACCEPTED, ContactRequest.name, (payload: FriendRequestAcceptedPayload) => {
      this.receivedRequests = this.receivedRequests.map((request) => {
        if (request.id === payload.id) {
          request.status = 'accepted';
        }
        return request;
      })
      this.activeTab = 0;
      EventBus.emit(Event.CHANGE_INDEX, 0);
    })
    EventBus.on(Event.FRIEND_REQUEST_REFUSED, ContactRequest.name, (payload: FriendRequestRefusedPayload) => {
      this.receivedRequests = this.receivedRequests.map((request) => {
        if (request.id === payload.id) {
          request.status = 'refused';
        }
        return request;
      })
      this.activeTab = 0;
      EventBus.emit(Event.CHANGE_INDEX, 0);
    })
    EventBus.on(Event.FRIEND_REQUEST_ERROR, ContactRequest.name, (error: string) => {
      try {
        this.uiContext.getPromptAction().showToast({
          message: error.toString(),
          duration: 2000
        });
      } catch (error) {
        console.error(error)
      }
    })

    CloudChat.websocketServer.addMessageObserver((msg: string) => {
      //控制台响应
      console.log("Received: " + msg);
      let receivedObject = JSON.parse(msg) as WebsocketServiceMessage;
      //处理响应
      switch (receivedObject.type) {
        case WebsocketServiceMessageType.ADD_FRIEND_REQUEST: {
          const payload = receivedObject.payload as RequireAddFriendRequestPayload;
          EventBus.emit(Event.REQUIRE_ADD_FRIEND_REQUEST, payload);
          break;
        }
        case WebsocketServiceMessageType.ACCEPT_FRIEND_REQUEST: {
          const payload = receivedObject.payload as RequireAcceptFriendRequestPayload;
          EventBus.emit(Event.REQUIRE_REFUSE_FRIEND_REQUEST, payload);
          break;
        }
        case WebsocketServiceMessageType.REFUSE_FRIEND_REQUEST: {
          const payload = receivedObject.payload as RequireRefuseFriendRequestPayload;
          EventBus.emit(Event.REQUIRE_ACCEPT_FRIEND_REQUEST, payload);
          break;
        }
      }
    })

    this.loadFriendRequest();
  }

  build() {
    Column() {
      // 搜索区域
      this.SearchSection()
      Scroll() {
        Column() {
          if (this.searchedContacts.length > 0) {
            this.SectionTitle(
              loadStringResource(this.uiAbilityContext, $r('app.string.text_ContactRequest_sectionTitle'))
            )
            this.SearchUserCard(this.searchedContacts)
          } else if (this.searchKeyword.length > 0 && this.searchedContacts.length <= 0) {
            this.EmptyState(
              loadStringResource(this.uiAbilityContext,
                $r('app.string.text_ContactRequest_emptyState_noSearched_title')),
              loadStringResource(this.uiAbilityContext,
                $r('app.string.text_ContactRequest_emptyState_noSearched_description'))
            )
          } else {
            // 标签页切换
            this.TabSection()

            // 内容区域
            if (this.activeTab === 0) {
              if (this.sentRequests.length > 0) {
                ForEach(this.sentRequests, (request: FriendRequest) => {
                  this.SentRequestCard(request)
                }, (request: FriendRequest) => request.id.toString())
              } else {
                this.EmptyState(
                  loadStringResource(this.uiAbilityContext,
                    $r('app.string.text_ContactRequest_emptyState_noSend_title')),
                  loadStringResource(this.uiAbilityContext,
                    $r('app.string.text_ContactRequest_emptyState_noSend_description'))
                )
              }
            } else {
              if (this.receivedRequests.length > 0) {
                ForEach(this.receivedRequests, (request: FriendRequest) => {
                  this.ReceivedRequestCard(request)
                }, (request: FriendRequest, index: number) => index + request.id.toString())
              } else {
                this.EmptyState(
                  loadStringResource(this.uiAbilityContext,
                    $r('app.string.text_ContactRequest_emptyState_noReceived_title')),
                  loadStringResource(this.uiAbilityContext,
                    $r('app.string.text_ContactRequest_emptyState_noReceived_description'))
                )
              }
            }
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding({ top: 8 })
      }
      .scrollBar(BarState.Off)
      .width('100%')
    }
    .padding({
      top: 12,
      left: 16,
      right: 16,
      bottom: 16
    })
    .backgroundColor($r('app.color.input_background'))
    .height('100%')
  }

  @Builder
  SearchSection() {
    Row() {
      Search({
        value: this.searchKeyword,
        placeholder: $r('app.string.text_ContactRequest_SearchSection_searchPlaceholder')
      })
        .searchButton($r('app.string.text_ContactRequest_SearchSection_searchButton'))
        .placeholderFont({ size: 14 })
        .height(42)
        .width('100%')
        .backgroundColor($r('app.color.input_background'))
        .borderRadius(21)
        .padding({ left: 16, right: 16 })
        .onChange((value: string) => {
          this.searchKeyword = value.trim();
          if (this.searchKeyword.length <= 0) {
            this.searchedContacts = [];
          }
        })
    }
    .width('100%')
    .padding({ bottom: 20 })
  }

  @Builder
  TabSection() {
    Row({ space: 0 }) {
      // 已发送标签
      Column() {
        Text($r('app.string.text_ContactRequest_TabSection_Send'))
          .fontSize(16)
          .fontWeight(this.activeTab === 0 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.activeTab === 0 ? $r('app.color.primary') : $r('app.color.secondary_text'))
          .padding({ bottom: 8 })

        // 激活指示器
        if (this.activeTab === 0) {
          Divider()
            .color($r('app.color.primary'))
            .height(2)
            .width(24)
            .align(Alignment.Bottom)
        }
      }
      .height(48)
      .layoutWeight(1)
      .onClick(() => {
        this.activeTab = 0;
      })

      // 收到的请求标签
      Column() {
        Text($r('app.string.text_ContactRequest_TabSection_Received'))
          .fontSize(16)
          .fontWeight(this.activeTab === 1 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.activeTab === 1 ? $r('app.color.primary_text') : $r('app.color.secondary_text'))
          .padding({ bottom: 8 })

        // 激活指示器
        if (this.activeTab === 1) {
          Divider()
            .color($r('app.color.primary'))
            .height(2)
            .width(24)
            .align(Alignment.Bottom)
        }
      }
      .height(48)
      .layoutWeight(1)
      .onClick(() => {
        this.activeTab = 1;
      })
    }
    .width('100%')
    .borderWidth({ bottom: 1 })
    .borderColor({ bottom: $r('app.color.divider') })
    .margin({ bottom: 16 })
  }

  @Builder
  SectionTitle(title: string) {
    Text(title)
      .fontSize(14)
      .fontColor($r('app.color.secondary_text'))
      .fontWeight(FontWeight.Medium)
      .margin({ top: 8, bottom: 12, left: 4 })
  }

  @Builder
  SearchUserCard(user: Contact[]) {
    List({ space: 10, initialIndex: 0 }) {
      ForEach(user, (user: Contact) => {
        ListItem() {
          Row() {
            // 头像
            Image(getAvatar(user.avatar))
              .width(48)
              .height(48)
              .borderRadius(24)
              .margin({ right: 12 })
              .backgroundColor($r('app.color.header_background'))

            // 用户信息
            Column({ space: 2 }) {
              Text(user.username)
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.primary_text'))
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Row({ space: 4 }) {
                Text($r('app.string.text_ContactRequest_SentRequestCard_ID'))
                  .fontSize(12)
                  .fontColor($r('app.color.secondary_text'))
                Text(user.contactId.toString())
                  .fontSize(12)
                  .fontColor($r('app.color.secondary_text'))
                  .fontWeight(FontWeight.Medium)
              }
              .margin({ top: 2 })
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Center)

            // 操作按钮
            Button($r('app.string.text_ContactRequest_SearchUserCard'), { type: ButtonType.Normal })
              .fontSize(14)
              .fontColor($r('app.color.card_background'))
              .height(36)
              .width(80)
              .backgroundColor($r('app.color.primary'))
              .borderRadius(18)
              .onClick(() => {
                if (this.currentUser) {
                  EventBus.emit(Event.ADD_FRIEND_REQUEST, {
                    id: 0,
                    requesterId: this.currentUser.userId,
                    targetId: user.contactId,
                    requesterUsername: this.currentUser.username,
                    targetUsername: user.username,
                    requesterAvatar: this.currentUser.avatar,
                    targetAvatar: user.avatar,
                    status: 'pending'
                  } as AddFriendRequestPayload)
                }
              })
          }
          .width('100%')
          .padding(12)
        }
      }, (user: Contact) => user.contactId.toString())
    }
    .height('100%')
    .width('100%')
    .layoutWeight(1)
    .scrollBar(BarState.Auto)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
    .shadow({
      radius: 8,
      color: $r('app.color.ContactRequest_shadow'),
      offsetX: 0,
      offsetY: 2
    })
    .margin({ bottom: 12 })
  }

  @Builder
  RequestList(status: 'pending' | 'accepted' | 'refused') {
    // 状态标签
    Row() {
      if (status === 'refused') {
        Image('✖️')
          .width(14)
          .height(14)
          .margin({ right: 4 })
        Text($r('app.string.text_ContactRequest_RequestList_refuse'))
          .fontSize(12)
          .fontColor($r('app.color.warning'))
      } else if (status === 'accepted') {
        Image('✔️')
          .width(14)
          .height(14)
          .margin({ right: 4 })
        Text($r('app.string.text_ContactRequest_RequestList_accept'))
          .fontSize(12)
          .fontColor($r('app.color.warning'))
      } else {
        Image($r('app.media.clock'))
          .width(14)
          .height(14)
          .margin({ right: 4 })
        Text($r('app.string.text_ContactRequest_wait'))
          .fontSize(12)
          .fontColor($r('app.color.warning'))
      }
    }
    .padding({
      left: 10,
      right: 10,
      top: 6,
      bottom: 6
    })
    .backgroundColor($r('app.color.warning_bg'))
    .borderRadius(15)
  }

  @Builder
  SentRequestCard(request: FriendRequest) {
    Column() {
      Row() {
        // 头像
        Image(getAvatar(request.targetAvatar))
          .width(48)
          .height(48)
          .borderRadius(24)
          .margin({ right: 12 })
          .backgroundColor($r('app.color.avatar_bg'))

        // 用户信息
        Column({ space: 2 }) {
          Text(request.targetUsername)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.primary_text'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Row({ space: 4 }) {
            Text($r('app.string.text_ContactRequest_SentRequestCard_ID'))
              .fontSize(12)
              .fontColor($r('app.color.secondary_text'))
            Text(request.targetId.toString())
              .fontSize(12)
              .fontColor($r('app.color.secondary_text'))
              .fontWeight(FontWeight.Medium)
          }
          .margin({ top: 2 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)

        this.RequestList(request.status)
      }
      .width('100%')
      .padding(12)
    }
    .width('100%')
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
    .shadow({
      radius: 4,
      color: $r('app.color.ContactRequest_shadow'),
      offsetX: 0,
      offsetY: 1
    })
    .margin({ bottom: 10 })
  }

  @Builder
  ReceivedRequestCard(request: FriendRequest) {
    Column() {
      Row() {
        // 头像
        Image(getAvatar(request.requesterAvatar))
          .width(48)
          .height(48)
          .borderRadius(24)
          .margin({ right: 12 })
          .backgroundColor($r('app.color.avatar_bg'))

        // 用户信息
        Column({ space: 2 }) {
          Text(request.requesterUsername)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.primary_text'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text($r('app.string.text_ContactRequest_ReceivedRequestCard_Title'))
            .fontSize(12)
            .fontColor($r('app.color.secondary_text'))
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)

        if (request.status === 'pending') {
          // 操作按钮
          Row({ space: 8 }) {
            Button($r('app.string.text_ContactRequest_ReceivedRequestCard_Accept'), { type: ButtonType.Normal })
              .fontSize(14)
              .fontColor($r('app.color.secondary_text'))
              .height(36)
              .width(70)
              .backgroundColor(Color.Transparent)
              .border({
                width: 1,
                color: $r('app.color.divider'),
                style: BorderStyle.Solid
              })
              .borderRadius(18)
              .onClick(() => {
                EventBus.emit(Event.ACCEPT_REQUEST, { id: request.id } as AcceptFriendRequestPayload)
              })

            Button($r('app.string.text_ContactRequest_ReceivedRequestCard_Refuse'), { type: ButtonType.Normal })
              .fontSize(14)
              .fontColor($r('app.color.card_background'))
              .height(36)
              .width(70)
              .backgroundColor($r('app.color.primary'))
              .borderRadius(18)
              .onClick(() => {
                EventBus.emit(Event.REFUSE_REQUEST, { id: request.id } as RefuseFriendRequestPayload)
              })
          }
        } else {
          this.RequestList(request.status)
        }
      }
      .width('100%')
      .padding(12)
    }
    .width('100%')
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
    .shadow({
      radius: 4,
      color: $r('app.color.ContactRequest_shadow'),
      offsetX: 0,
      offsetY: 1
    })
    .margin({ bottom: 10 })
  }

  @Builder
  EmptyState(title: string, description: string) {
    Column() {
      Image($r('app.media.empty'))
        .width(120)
        .height(120)
        .margin({ bottom: 16 })
        .opacity(0.6)

      Text(title)
        .fontSize(16)
        .fontColor($r('app.color.secondary_text'))
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 8 })

      Text(description)
        .fontSize(14)
        .fontColor($r('app.color.tertiary_text'))
        .textAlign(TextAlign.Center)
        .padding({ left: 32, right: 32 })
    }
    .width('100%')
    .height(300)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  private loadFriendRequest() {
    this.isLoading = true;
    if (this.currentUser) {
      EventBus.emit(Event.LOAD_FRIEND_REQUEST, { userId: this.currentUser?.userId } as LoadFriendRequestPayload);
    }
  }
}
