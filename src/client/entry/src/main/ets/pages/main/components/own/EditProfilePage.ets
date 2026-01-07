import { CloudChat } from "../../../../CloudChat";
import { User } from "../../../../core/models/models";
import { EventBus } from "../../../../core/service/event/EventBus";
import { Event } from "../../../../core/tag/Event";
import { AVATAR, getAvatar } from "../../../../core/util";
import { common } from "@kit.AbilityKit";
import { UpdateProfilePayload } from "../../../../core/protocol/http/client.http.protocol";


@Component
export struct EditProfilePage {
  @Prop currentUser: User;

  @State newUsername: string = this.currentUser.username
  @State newEmail: string = this.currentUser.email
  @State selectedAvatar: string = this.currentUser.avatar

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  //预设头像资源名称
  private avatars: string[] = [
    AVATAR.DEFAULT, AVATAR.ZOMBATAR_1, AVATAR.ZOMBATAR_2, AVATAR.ZOMBATAR_3, AVATAR.ZOMBATAR_4, AVATAR.ZOMBATAR_5
  ]

  aboutToAppear(): void {
    try {
      EventBus.on(Event.PROFILE_UPDATED, EditProfilePage.name, (): void => {
        try {
          this.uiContext.getPromptAction().showToast({
            message: "个人信息更新成功",
            duration: 2000
          });
        } catch (error) {
          console.error(error);
        }
      });
      EventBus.on(Event.PROFILE_UPDATE_FAILED, EditProfilePage.name, (error: string): void => {
        try {
          this.uiContext.getPromptAction().showToast({
            message: "个人信息更新失败：" + error,
            duration: 2000
          });
        } catch (error) {
          console.error(error);
        }
      });
    } catch (e) {
      console.error(e)
    }
  }

  build() {
    Column() {
      //顶部导航栏
      Row() {
        //返回键
        Image($r('app.media.backicon'))
          .height(24)
          .width(24)
          .padding(0)
          .margin({ left: 8 })
          .onClick(() => {
            EventBus.emit(Event.CLOSE_EDIT_PROFILE);
          })

        Text("修改个人信息")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 15 })

        Blank()

        Text("保存")
          .fontColor($r('app.color.brand_primary'))
          .fontWeight(FontWeight.Medium)
          .onClick(() => this.handleSave())
      }
      .width('100%')
      .height(56)
      .padding({ left: 15, right: 15 })
      .backgroundColor($r('app.color.panel_background'))

      Scroll() {
        Column() {
          //头像选择区
          Text("选择头像")
            .fontSize(14)
            .fontColor($r('app.color.primary'))
            .margin({ top: 20, bottom: 10, left: 20 })
            .alignSelf(ItemAlign.Start)

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround }) {
            ForEach(this.avatars, (imgName: string) => {
              Stack() {
                Image(getAvatar(imgName))
                  .width(60)
                  .height(60)
                  .borderRadius(30)
                  .border({ width: this.selectedAvatar === imgName ? 2 : 0, color:$r('app.color.brand_primary') })
                  .onClick(() => this.selectedAvatar = imgName)

                if (this.selectedAvatar === imgName) {
                  Circle({ width: 16, height: 16 })
                    .fill($r('app.color.brand_primary'))
                    .markAnchor({ x: -20, y: -20 })
                }
              }
              .margin(10)
            })
          }
          .padding(10).backgroundColor($r('app.color.card_background'))

          //信息输入区
          List() {
            ListItem() {
              this.buildInputItem("用户名", this.newUsername, (val) => this.newUsername = val)
            }
            ListItem() {
              this.buildInputItem("邮箱地址", this.newEmail, (val) => this.newEmail = val)
            }
          }
          .width('100%')
          .height('100%')
          .margin({ top: 20 })
          .backgroundColor($r('app.color.input_background'))
          .divider({ strokeWidth: 0.5, color: $r('app.color.list_divider'), startMargin: 20 })
        }
      }
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .backgroundColor($r("app.color.profileSetting_relativeContainer_background"))
  }

  @Builder
  buildInputItem(label: string, value: string, onChange: (val: string) => void) {
    Row() {
      Text(label)
        .width(80)
        .fontSize(16)
      TextInput({ text: value })
        .layoutWeight(1)
        .backgroundColor(Color.Transparent)
        .onChange(onChange)
    }
    .width('100%')
    .height(56)
    .padding({ left: 20, right: 20 })
  }

  private handleSave() {
    EventBus.emit(Event.UPDATE_PROFILE, {
        userId: this.currentUser.userId, username: this.newUsername,
        email: this.newEmail, avatar: this.selectedAvatar, password: ''
      } as UpdateProfilePayload)
  }
}