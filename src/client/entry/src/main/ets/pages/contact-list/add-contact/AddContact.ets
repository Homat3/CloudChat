import { common } from '@kit.AbilityKit';
import { User } from '../../../core/models/models';
import { CloudChat } from '../../../CloudChat'; // Assuming this exists based on your context

@Component
export struct AddContact {
  @State searchKeyword: string = '';
  @State searchResults: User[] = [];
  @State isSearching: boolean = false;

  // Callback to close the panel or go back
  @Prop onBack: () => void = () => {};

  private uiContext: UIContext = this.getUIContext();

  build() {
    Column() {
      // 有返回标签的头
      Row() {
        Button({ type: ButtonType.Normal, stateEffect: true }) {
          Text('<')
            .fontSize(22)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.primary_text'))
        }
        .width(40)
        .height(40)
        .backgroundColor(Color.Transparent)
        .onClick(() => this.onBack())

        Text('添加联系人')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
      }
      .width('100%')
      .padding(16)
      .backgroundColor($r('app.color.header_background'))

      // 搜索框
      Row() {
        TextInput({ placeholder: '输入用户名或邮箱搜索', text: this.searchKeyword })
          .layoutWeight(1)
          .height(48)
          .onChange((value: string) => {
            this.searchKeyword = value;
          })
          .onSubmit(() => {
            this.handleSearch();
          })

        Button('搜索')
          .margin({ left: 12 })
          .onClick(() => {
            this.handleSearch();
          })
      }
      .padding(16)
      .width('100%')

      // 搜索结果展示
      if (this.isSearching) {
        LoadingProgress().width(40).height(40).margin({ top: 50 })
      } else {
        List({ space: 12 }) {
          ForEach(this.searchResults, (user: User) => {
            ListItem() {
              this.UserResultItem(user)
            }
          }, (user: User) => user.userId.toString())
        }
        .layoutWeight(1)
        .width('100%')
        .padding(16)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.contact_list_whole_background'))
  }

  @Builder
  UserResultItem(user: User) {
    Row() {
      Image(user.avatar ? user.avatar : $r('app.media.default'))
        .width(48)
        .height(48)
        .borderRadius(24)
        .margin({ right: 12 })

      Column() {
        Text(user.username)
          .fontSize(16)
          .fontColor($r('app.color.primary_text'))
        Text(user.email)
          .fontSize(12)
          .fontColor($r('app.color.secondary_text'))
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Button('添加')
        .fontSize(12)
        .height(28)
        .onClick(() => {
          this.sendFriendRequest(user.userId);
        })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(12)
  }

  // Logic to search users
  async handleSearch() {
    if (!this.searchKeyword.trim()) return;
    this.isSearching = true;
    try {
      // Simulate API call or use CloudChat.searchUsers(this.searchKeyword)
      // const results = await CloudChat.searchUsers(this.searchKeyword);

      // Mock Data for demonstration
      await new Promise<void>((resolve) => {
        setTimeout(() => {
          resolve();
        }, 500);
      });
      this.searchResults = [
        new User(101, 'MockUser1', 'test1@email.com', ''),
        new User(102, 'MockUser2', 'test2@email.com', '')
      ];

    } catch (error) {
      console.error('Search failed', error);
    } finally {
      this.isSearching = false;
    }
  }

  // Logic to send request
  async sendFriendRequest(targetId: number) {
    try {
      // await CloudChat.sendFriendRequest(targetId);
      this.uiContext.getPromptAction().showToast({ message: '好友请求已发送' });
    } catch (error) {
      this.uiContext.getPromptAction().showToast({ message: '发送失败' });
    }
  }
}