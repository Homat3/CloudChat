import { NoSuchEventSubscribedError, EventAlreadySubscribedError } from './CallBackManagerError';
import { common } from '@kit.AbilityKit';

// call back 管理器 负责处理消息响应
export class CallBackManager{
  private eventHub: common.EventHub;

  private callBackMap: Map<Event, Function> = new Map();
  constructor(eventHub: common.EventHub) {
    this.eventHub = eventHub;
  }

  public put(event: Event, callBack: Function){
    this.eventHub.on(event, callBack);
    if (!this.callBackMap.has(event)){
      this.callBackMap.set(event, callBack);
    }
    else throw new EventAlreadySubscribedError(event);
  }

  public removeEventSubscription(event: Event){
    if (this.callBackMap.has(event)){
      this.eventHub.off(event);
      this.callBackMap.delete(event);
    }
    else throw new NoSuchEventSubscribedError(event);
  }

  public getCallBackFunction(event: Event): Function {
    const functions = this.callBackMap.get(event);
    if (functions){
      return functions;
    }
    else throw new NoSuchEventSubscribedError(event);
  }
}

export enum Event{
  LOGIN = "LOGIN"
}