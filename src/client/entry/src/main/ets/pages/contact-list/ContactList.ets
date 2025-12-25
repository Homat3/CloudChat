// pages/contact-list/ContactList.ets
import { ContactSidebar } from './components/ContactSidebar';
import { ChatArea } from './components/ChatArea';
import { DetailPanel } from './components/DetailPanel';
import { promptAction, router } from '@kit.ArkUI';

@Entry
@Component
struct ContactList {
  @State selectedContactId: number = 0;
  @State selectedMessageId: number = 0;
  @State searchKeyword: string = '';

  // 添加页面生命周期
  aboutToAppear() {
    console.log('[DEBUG] ContactList 页面加载了');
    promptAction.showToast({
      message: 'ContactList 页面加载成功',
      duration: 2000
    });
  }

  build() {
    // 先使用最简单的布局确认页面能显示
    Column() {
      // 顶部调试条
      Row() {
        Text('✅ ContactList 页面已加载')
          .fontSize(20)
          .fontColor('#FFFFFF')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height(60)
      .backgroundColor('#409EFF')
      .padding(10)

      // 主内容区域
      Row() {
        // 左侧栏 - 固定宽度
        Column() {
          Text('左侧联系人栏')
            .fontSize(18)
            .fontColor('#333')
            .margin({ top: 20 })
        }
        .width(240)
        .height('100%')
        .backgroundColor('#f5f5f5')
        .padding(10)

        // 中间聊天区域 - 自适应
        Column() {
          Text('中间聊天区域')
            .fontSize(18)
            .fontColor('#333')
            .margin({ top: 20 })
        }
        .layoutWeight(1)
        .height('100%')
        .backgroundColor('#FFFFFF')
        .padding(10)

        // 右侧详情栏 - 固定宽度
        Column() {
          Text('右侧详情面板')
            .fontSize(18)
            .fontColor('#333')
            .margin({ top: 20 })
        }
        .width(320)
        .height('100%')
        .backgroundColor('#FFF8E1')
        .padding(10)
      }
      .layoutWeight(1)
      .width('100%')

      // 底部调试信息
      Row() {
        Text('调试信息：页面加载完成')
          .fontSize(12)
          .fontColor('#666')
      }
      .width('100%')
      .height(40)
      .backgroundColor('#F5F7FA')
      .padding(10)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}