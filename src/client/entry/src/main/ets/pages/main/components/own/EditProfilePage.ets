import { CloudChat } from "../../../../CloudChat";
import { User } from "../../../../core/models/models";
import { getAvatar } from "../../../../core/util";


@Component
export struct EditProfilePage {
  @State user: User | null = CloudChat.currentUser
  @State newUsername: string = this.user?.username || ''
  @State newEmail: string = this.user?.email || ''
  @State selectedAvatar: string = this.user?.avatar || 'default'

  //预设头像资源名称
  private avatars: string[] = ['Zombatar_1', 'Zombatar_2', 'Zombatar_3', 'Zombatar_4', 'Zombatar_5']

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
            //
          })

        Text("修改个人信息")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 15 })

        Blank()

        Text("保存")
          .fontColor($r('app.color.save'))
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
                  .border({ width: this.selectedAvatar === imgName ? 2 : 0, color: Color.Blue })
                  .onClick(() => this.selectedAvatar = imgName)

                if (this.selectedAvatar === imgName) {
                  Circle({ width: 16, height: 16 })
                    .fill(Color.Blue)
                    .markAnchor({ x: -20, y: -20 })
                }
              }
              .margin(10)
            })
          }
          .padding(10).backgroundColor(Color.White)

          //信息输入区
          List() {
            ListItem() {
              this.buildInputItem("用户名", this.newUsername, (val) => this.newUsername = val)
            }
            ListItem() {
              this.buildInputItem("邮箱地址", this.newEmail, (val) => this.newEmail = val)
            }
          }
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
    if (this.user) {
      //
    }
  }
}