import { common } from '@kit.AbilityKit';
import { User } from '../../../core/models/models';
import { CloudChat } from '../../../CloudChat';

@Component
export struct ContactRequest {
  // 添加好友相关状态
  @State searchKeyword: string = '';
  @State searchedUser: User | null = null;
  @State hasSearched: boolean = false;
  @State isLoading: boolean = false;
  @State searchError: string = '';
  @State sentRequests: User[] = [];
  @State receivedRequests: User[] = [];

  // 好友请求相关状态
  // @State pendingRequests: User[] = CloudChat.pendingRequests; // 从云服务获取待处理请求
  @State activeTab: number = 0; // 当前激活的标签页

  build() {
    Column() {
      Search({
        value: this.searchKeyword,
        placeholder: '请输入用户id...'
      })
        .searchButton('search')
        .width('100%')
        .height(40)
        .margin({ bottom: 20 })
        .onChange((value: string) => {
          this.searchKeyword = value;
          if(value.length > 0) {
            let searchId = Number.parseInt(value);
            if(!isNaN(searchId)) {
              // TODO
              // this.searchedUser = {
              //   userId: searchId,
              //   username: `${searchId}`,
              //   email: `${searchId}`,
              //   avatar: `${searchId}`,
              // };
            }
          } else {
            this.searchedUser = null;
          }
        })

      Scroll() {
        Column() {
          if(this.searchKeyword.length > 0) {
            this.SectionTitle('搜索结果')
            if(this.searchedUser) {
              this.SearchUserCard(this.searchedUser)
            }
          } else {
            this.SectionTitle('已发送的请求')
            ForEach(this.sentRequests, (user: User) => {
              this.SentRequestCard(user)
            }, (item: User) => item.userId.toString())

            this.SectionTitle('收到的好友请求')
            ForEach(this.receivedRequests, (user: User) => {
              this.ReceivedRequestCard(user)
            }, (item: User) => item.userId.toString())
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .padding(16)
    .backgroundColor($r('app.color.panel_background'))
    .height('100%')
  }

  @Builder SectionTitle(title: string) {
    Text(title)
      .fontSize(13)
      .fontColor($r('app.color.header_text'))
      .margin({ top: 10, bottom: 10, left: 4 })
  }

  @Builder SearchUserCard(user: User) {
    Row() {
      Image(user.avatar)
        .width(45)
        .height(45)
        .borderRadius(8)
        .margin({ right: 12 })
      Column() {
        Text(user.username)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
        Text(`ID: ${user.userId}`)
          .fontSize(12)
          .fontColor($r('app.color.header_text'))
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Button('发送请求')
        .fontSize(12)
        .height(30)
        .backgroundColor($r('app.color.send_button'))
        .borderRadius(15)
    }
    .cardStyle()
  }

  @Builder SentRequestCard(user: User) {
    Row() {
      Image(user.avatar)
        .width(45)
        .height(45)
        .borderRadius(8)
        .margin({ right: 12 })
      Column() {
        Text(user.username)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
        Text(`ID: ${user.userId}`)
          .fontSize(12)
          .fontColor($r('app.color.header_text'))
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Text('等待验证')
        .fontSize(12)
        .fontColor($r('app.color.primary_text'))
    }
    .cardStyle()
  }

  @Builder ReceivedRequestCard(user: User) {
    Row() {
      Image(user.avatar)
        .width(45)
        .height(45)
        .borderRadius(8)
        .margin({ right: 12 })
      Column() {
        Text(user.username)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
        Text(`ID: ${user.userId} 申请添加`)
          .fontSize(12)
          .fontColor($r('app.color.header_text'))
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Row({ space: 10 }) {
        Text('拒绝')
          .fontSize(14)
          .fontColor($r('app.color.primary_text'))
        Button('同意')
          .fontSize(12)
          .height(30)
          .backgroundColor($r('app.color.panel_background'))
          .borderRadius(6)
      }
    }
    .cardStyle()
  }

  @Styles cardStyle() {
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .margin({ bottom: 8 })
  }
}
//   @Builder
//   buildFriendRequestsTab() {
//     Column() {
//       if (this.pendingRequests.length > 0) {
//         List({ space: 10 }) {
//           ForEach(this.pendingRequests, (request) => {
//             ListItem() {
//               this.buildRequestItem(request)
//             }
//           })
//         }
//         .width('100%')
//         .layoutWeight(1)
//       } else {
//         this.buildEmptyState("暂无待处理的好友请求")
//       }
//     }
//     .width('100%')
//     .height('100%')
//   }
//
//   @Builder
//   buildRequestItem(user: User) {
//     Row() {
//       Image($r('app.media.user_placeholder'))
//         .width(60)
//         .height(60)
//         .borderRadius(30)
//
//       Column() {
//         Text(user.username)
//           .fontSize(18)
//           .fontWeight(FontWeight.Bold)
//         Text(`申请添加您为好友`)
//           .fontSize(14)
//           .fontColor(Color.Gray)
//           .margin({ top: 4 })
//       }
//       .alignItems(HorizontalAlign.Start)
//       .margin({ left: 15})
//       .layoutWeight(1)
//
//       Button("通过")
//         .backgroundColor($r('app.color.accept_button'))
//         .margin({ right: 10 })
//         .onClick(() => this.handleRespondToRequest(user, true))
//
//       Button("拒绝")
//         .backgroundColor($r('app.color.reject_button'))
//         .onClick(() => this.handleRespondToRequest(user, false))
//     }
//     .width('92%')
//     .padding(15)
//     .backgroundColor(Color.White)
//     .borderRadius(12)
//     .shadow({ radius: 10, color: '#10000000' })
//   }
//
//   private handleRespondToRequest(user: User, accept: boolean) {
//     if (accept) {
//       CloudChat.acceptRequest(user.userId);
//     } else {
//       CloudChat.rejectRequest(user.userId);
//     }
//     this.pendingRequests = this.pendingRequests.filter(u => u.userId !== user.userId);
//   }
//
//   build() {
//     Column() {
//       // 标签页切换
//       Tabs({ barPosition: BarPosition.Start }) {
//         TabContent() {
//           this.buildAddFriendTab()
//         }.tabBar('添加好友')
//
//         TabContent() {
//           this.buildFriendRequestsTab()
//         }.tabBar('好友请求')
//       }
//       .barWidth('80%')
//       .barHeight(48)
//       .animationDuration(0)
//       .onChange((index: number) => {
//         this.activeTab = index;
//         if (index === 1) {
//           this.pendingRequests = CloudChat.pendingRequests; // 切换时刷新请求列表
//         }
//       })
//     }
//     .width('100%')
//     .height('100%')
//   }
//
//   @Builder
//   buildAddFriendTab() {
//     Column() {
//       Text("添加联系人")
//         .fontSize(20)
//         .fontWeight(FontWeight.Bold)
//         .margin({ top: 30, bottom: 20 })
//         .fontColor($r('app.color.primary_text'))
//       Row() {
//         Search({ value: this.searchKeyword, placeholder: '请输入用户 ID' })
//           .layoutWeight(1)
//           .height(48)
//           .backgroundColor(Color.White)
//           .onSubmit(() => this.executeSearch()) // 键盘点击“搜索/确定”触发
//           .onChange((value: string) => {
//             this.searchKeyword = value;
//             this.searchError = '';
//           })
//
//         Button("搜索")
//           .height(48)
//           .margin({ left: 10 })
//           .padding({ left: 20, right: 20 })
//           .onClick(() => this.executeSearch()) // 点击按钮触发
//           .enabled(!this.isLoading) //加载时禁用按钮
//       }
//       .width('92%')
//
//       // 显示加载状态
//       if (this.isLoading) {
//         this.buildLoadingState()
//       }
//       // 显示错误信息
//       else if (this.searchError) {
//         this.buildErrorState(this.searchError)
//       }
//       // 结果展示区
//       if (this.searchedUser) {
//         this.buildUserCard(this.searchedUser)
//       } else if (this.hasSearched) {
//         this.buildEmptyState("未找到该用户，请检查 ID 是否正确")
//       } else {
//         this.buildEmptyState("搜索 ID 以添加好友")
//       }
//     }
//     .width('100%')
//     .height('100%')
//   }
//
//   // 搜索核心逻辑
//   private executeSearch() {
//     if (!this.searchKeyword.trim()) return;
//
//     this.hasSearched = true;
//     this.isLoading = true;
//     this.searchError = '';
//     this.searchedUser = null;
//     // 精确匹配 ID
//     const result = CloudChat.allUsers.find(u =>
//     u.userId.toString() === this.searchKeyword.trim()
//     );
//
//     this.searchedUser = result ? result : null;
//   }
//
//   @Builder
//   buildUserCard(user: User) {
//     Row() {
//       Image($r('app.media.user_placeholder'))
//         .width(60)
//         .height(60)
//         .borderRadius(30)
//
//       Column() {
//         Text(user.username)
//           .fontSize(18)
//           .fontWeight(FontWeight.Bold)
//         Text(`用户 ID: ${user.userId}`)
//           .fontSize(14)
//           .fontColor(Color.Gray)
//           .margin({ top: 4 })
//       }
//       .alignItems(HorizontalAlign.Start)
//       .margin({ left: 15 })
//       .layoutWeight(1)
//
//       Button("发送申请")
//         .backgroundColor($r('app.color.send_button'))
//         .onClick(() => this.onSendRequest(user))
//     }
//     .width('92%')
//     .margin({ top: 20 })
//     .padding(15)
//     .backgroundColor(Color.White)
//     .borderRadius(12)
//     .shadow({ radius: 10, color: '#10000000' })
//   }
//
//   @Builder
//   buildEmptyState(tips: string) {
//     Column() {
//       Image($r('app.media.ic_search_empty'))
//         .width(80)
//         .height(80)
//         .opacity(0.2)
//       Text(tips)
//         .fontSize(14)
//         .fontColor(Color.Gray)
//         .margin({ top: 10 })
//     }
//     .margin({ top: 100 })
//   }
// }