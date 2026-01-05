import { Home } from './components/home/Home';
import { ContactRequest } from './components/contact-request/ContactRequest';
import { OwnPage } from './components/own/OwnPage';

@Entry
@Component
struct MainContainer {
  @State currentIndex : number = 0;
  //导航栏
  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
      TabContent() {
        Home()
      }.tabBar('主页');

      TabContent() {
        ContactRequest()
      }.tabBar('添加联系人');

      TabContent() {
        OwnPage()
      }.tabBar('个人');
    }
    .width('100%')
    .onChange((index: number) => {
      this.currentIndex = index;
    })
    .width('100%')
  }
}