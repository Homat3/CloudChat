import { CallBackManagerError } from './CallBackManagerError';
import { UIAbility } from '@kit.AbilityKit';
import { common } from '@kit.AbilityKit';

// call back 管理器 负责处理消息响应
export class CallBackManager{
  private eventHub: common.EventHub;
  constructor(eventHub: common.EventHub) {
    this.eventHub = eventHub;
  }
}