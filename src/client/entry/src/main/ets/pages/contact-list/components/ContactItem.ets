import { common } from "@kit.AbilityKit";
import { Contact } from "../../../core/models/models";

@Component
/**
 * 聊天人项组件，便于实现聊天人相关业务
 */
export struct ContactItem{
    // 状态变量

    // 上下文
    private uiContext: UIContext = this.getUIContext();
    private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

    @Prop contact: Contact;
    @Prop selected: boolean = false;
    @Prop onSelected: (id: number) => void = () => {};

    build(){
        Row() {
            Image(this.contact.avatar ? this.contact.avatar : $r('app.media.default'))
                .width(48)
                .height(48)
                .margin(8)
                .borderRadius(24)

            Column() {
                Text(this.contact.username)
                    .fontSize(16)
                    .fontColor($r('app.color.primary_text'))

                Text(this.contact.online ? '在线' : '离线')
                    .fontSize(12)
                    .fontColor(this.contact.online ? $r('app.color.online_status'): $r('app.color.offline_status'))
            }
            .layoutWeight(1)
            .margin({ right: 8})

            // if(this.contact.unreadCount > 0) {
            //     Badge({
            //         count: this.contact.unreadCount,
            //         position: BadgePosition.RightTop,
            //         style: { color: $r('app.color.badge_text'), backgroundColor: $r('app.color.badge_background') }
            //     })
            // }
        }
        .width('100%')
        .padding(8)
        .backgroundColor(this.selected ? $r('app.color.item_selected_bg') : Color.Transparent)
        .borderRadius(8)
        .onClick(() => {
            this.onSelected(this.contact.contactId);
        })
    }
}