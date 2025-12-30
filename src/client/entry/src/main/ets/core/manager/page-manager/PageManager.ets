import { Router } from '@kit.ArkUI';
import { Page } from './Page';
import { PageSwitchError } from './PageManagerError';


/**
 * @description window stage 管理器 负责处理页面切换
 * @author Infinomat
 */
export class PageManager{

  private router: Router;  // 窗口平台

  /**
   * @description window stage 管理器构造函数
   * @author Infinomat
   * @param stage 类型: {@see window.WindowStage} 代表: 窗口容器
   */
  constructor(router: Router) {
    this.router = router;
  }

  /**
   * @description 切换页面
   * @author Infinomat
   * @param targetPage 类型: {@see Page} 代表: 目标页面
   * @throws PageSwitchError 当页面无法加载时抛出此异常
   * @example
   * // 你需要首先在 Page 中定义页面标识
   * ...(假定你定义了页面MY_PAGE)
   * ------------------------------------------------
   * // 然后像这样切换页面
   * ...(假定有一个 WindowStageManager 对象 manager)
   * manager.switchPage(MY_PAGE);
   * ...
   */
  public async switchPage(targetPage: Page): Promise<void> {
    return this.router.pushUrl({ url: targetPage });
  }
}

/**
 * @description 页面规范标识
 * @author Infinomat
 * @example
* ------------------------------------------------
 * // 像这样定义页面
 * export enum Page{
 *   ...
 *   MY_PAGE = "pages/my-page/MyPage",
 *   ...
 * }
 * ------------------------------------------------
 * // 然后就可以使用 WindowStageManager 的 switchPage 方法切换页面
 */