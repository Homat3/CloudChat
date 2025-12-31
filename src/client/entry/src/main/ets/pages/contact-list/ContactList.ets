import {MessagePage} from './components/MessagePage'
import {ProfileSetting} from  '../profile-setting/ProfileSetting'

@Entry
@Component
struct ContactList {
  @State currentIndex : number = 0;
  //导航栏
  build() {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        TabContent() {
          MessagePage()
        }.tabBar('消息主页');

        TabContent() {
          ProfileSetting()
        }.tabBar('个人主页');
      }
      .width('100%')
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .width('100%')

  }
}