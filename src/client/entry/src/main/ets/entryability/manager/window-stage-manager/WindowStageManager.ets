import { window } from '@kit.ArkUI';
import { PageSwitchError } from './WindowStageManagerError';

// window stage 管理器 负责处理页面切换
export class WindowStageManager{

  private windowStage: window.WindowStage;

  constructor(stage: window.WindowStage) {
    this.windowStage = stage;
  }

  public switchPage(targetPage: Page){
    this.windowStage.loadContent(targetPage, (err) => {
      if (err.code) {
        throw new PageSwitchError("Failed to load the page: " + JSON.stringify(err) + " Check if the path \"" + targetPage + "\" is correct");
      }
      console.info('Succeeded in loading the content.');
    });
  }
}

export enum Page{
  CONTACT_LIST_PAGE = "pages/contact-list/ContactList",
  LOGIN_PAGE = "pages/login/LoginPage"
}