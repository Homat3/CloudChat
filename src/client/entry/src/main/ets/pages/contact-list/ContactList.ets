// pages/contact-list/ContactList.ets
import { ContactSidebar } from './components/ContactSidebar';
import { ChatArea } from './components/ChatArea';
import { DetailPanel } from './components/DetailPanel';
import { App, promptAction, router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { User } from '../../core/models/models';

@Entry
@Component
struct ContactList {
  // 状态变量
  @State selectedContactId: number = 0;
  @State selectedMessageId: number = 0;
  @State searchKeyword: string = '';
  @State curUser:User | null = null ;
  @State isPanelFolded : boolean = false//是否选择折叠

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  // 添加页面生命周期
  aboutToAppear() {
    console.log('[DEBUG] ContactList 页面加载了');
    try {
      this.uiContext.getPromptAction().showToast({
        message: 'ContactList 页面加载成功',
        duration: 2000
      });
    } catch (error) {
      console.error(error);
    }
  }

  build() {
    //三栏布局
    Row(){
      //左侧联系人栏
      ContactSidebar({

      })
        .width('20%')
        .height('100%')

      //中间区域
      ChatArea({

      })
        .layoutWeight(1)
        .height('100%')

      if(!this.isPanelFolded){
        DetailPanel({

        })
          .width('20%')
          .height('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.contact_list_whole_background'))
  }
}