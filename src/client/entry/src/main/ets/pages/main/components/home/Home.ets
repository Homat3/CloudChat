import { Contact } from '../../../../core/models/models';
import { common } from '@kit.AbilityKit';
import { ContactList } from './contact/ContactList';

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