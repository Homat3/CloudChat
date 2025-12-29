import { EventAlreadySubscribedError, NoSuchEventSubscribedError } from './CallBackManagerError';
import { common } from '@kit.AbilityKit';

/**
 * @description call back 管理器 负责处理特定组件的消息响应
 * @author Infinomat
 */
export class CallBackManager {
  private eventHub: common.EventHub;
  private callBackMap: Map<Event, Function> = new Map();

  /**
   * @description call back 管理器构造函数
   * @author Infinomat
   * @param eventHub 类型: {@see common.EventHub} 代表: 事件容器
   */
  constructor(eventHub: common.EventHub) {
    this.eventHub = eventHub;
  }

  /**
   * @description 订阅事件
   * @author Infinomat
   * @param event 类型: {@see Event} 代表: 事件
   * @param callBack 类型: Function 代表: 回调函数
   * @throws EventAlreadySubscribedError 当事件已经被注册过了的时候抛出
   * @example
  * // 你需要首先在 Event 中定义事件标识
   * ...(假定你定义了事件MY_EVENT)
   * ------------------------------------------------
   * // 然后像这样订阅事件
   * ...(假定有一个 WindowStageManager 对象 manager, 和一个回调函数 callBack)
   * manager.put(MY_EVENT, callBack);
   * ...
   */
  public addEventSubscription(event: Event, callBack: Function) {
    this.eventHub.on(event, callBack);
    if (!this.callBackMap.has(event)) {
      this.callBackMap.set(event, callBack);
    } else {
      throw new EventAlreadySubscribedError(event);
    }
  }

  /**
   * @description 删除注册事件
   * @author Infinomat
   * @param event 类型: {@see Event} 代表: 事件
   * @throws NoSuchEventSubscribedError 当事件本就没被注册的时候抛出
   */
  public removeEventSubscription(event: Event) {
    if (this.callBackMap.has(event)) {
      this.eventHub.off(event);
      this.callBackMap.delete(event);
    } else {
      throw new NoSuchEventSubscribedError(event);
    }
  }

  /**
   * @description 获取事件的回调函数
   * @author Infinomat
   * @param event 类型: {@see Event} 代表: 事件
   * @throws NoSuchEventSubscribedError 当事件本身没被注册的时候抛出
   */
  public getCallBackFunction(event: Event): Function {
    const functions = this.callBackMap.get(event);
    if (functions) {
      return functions;
    } else {
      throw new NoSuchEventSubscribedError(event);
    }
  }
}

/**
 * @description 事件规范标识
 * @author Infinomat
 * @example
* ------------------------------------------------
 * // 像这样定义事件
 * export enum Event{
 *   ...
 *   MY_EVENT = "MY_EVENT",
 *   ...
 * }
 * ------------------------------------------------
 * // 然后就可以使用 CallBackManager 的 put 方法订阅
 */
export enum Event {
  LOGIN = "LOGIN",
  LOGIN_BY_TOKEN = "LOGIN_BY_TOKEN",
  LOGIN_SUCCESS = "LOGIN_SUCCESS",
  LOGIN_FAILED = "LOGIN_FAILED"
}