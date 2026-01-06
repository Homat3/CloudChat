import { Message } from '../../../../core/models/message';
import { Contact, User } from '../../../../core/models/models';
import { common } from '@kit.AbilityKit';
import { CloudChat } from '../../../../CloudChat';
import { EventBus } from '../../../../core/service/event/EventBus';
import { Event } from '../../../../core/tag/Event';
import { ContactList } from './contact/ContactList';
import { LoadContactsPayload, LoadMessagesPayload } from '../../../../core/protocol/http/client.http.protocol';
import { ContactsLoadedFailedPayload } from '../../../../core/protocol/http/service.http.protocol';
import { Page } from '../../../../core/tag/Page';
import { ChatArea } from '../chat/ChatArea';

@Component
export struct Home {
  // 状态变量
  @Link selectedContact: Contact | null;
  @Prop contacts: Contact[];
  @State searchKeyword: string = '';

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  build() {
    ContactList({
      contacts: this.contacts,
      selectedContact: this.selectedContact,
      searchKeyword: this.searchKeyword
    })
      .width('100%')
      .height('100%')
      .border({ width: { right: 1 }, color: $r('app.color.list_divider') })
  }
}