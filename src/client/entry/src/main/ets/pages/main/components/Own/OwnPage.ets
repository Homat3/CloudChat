
import { common } from "@kit.AbilityKit";
import { User } from "../../../../core/models/models";

@Entry
@Component
struct ContactInfoPage {
  // 从外部接收的用户参数
  @State user: User | null = null
  @State notificationsEnabled: boolean = true

  // 上下文
  private uiContext: UIContext = this.getUIContext();
  private uiAbilityContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;

  aboutToAppear() {
    // 这里可以接收路由参数，例如：
    // const params = router.getParams() as { user: User };
    // if (params && params.user) {
    //   this.user = params.user;
    // }

    // 如果没有传入用户，可以设置一个默认值（仅用于测试）
    if (!this.user) {
      // 测试用数据
      this.user = new User(1, "张三", "zhangsan@example.com", "https://example.com/avatar.jpg", "在线");
    }
  }

  build() {
    Column() {
      // 标题栏
      this.buildHeader()

      // 头像和基本信息区域
      Column() {
        // 头像
        Image(this.user?.avatar || "https://via.placeholder.com/100")
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({ top: 20, bottom: 20 })

        // 用户ID
        Row() {
          Text("用户ID")
            .fontSize(16)
            .fontColor(Color.Gray)
            .width(80)
          Text(this.user?.userId?.toString() || '未知')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .margin({ left: 16 })
        }
        .width('100%')
        .padding({ left: 24, right: 24 })
        .margin({ top: 10, bottom: 10 })

        // 用户名
        Row() {
          Text("用户名")
            .fontSize(16)
            .fontColor(Color.Gray)
            .width(80)
          Text(this.user?.username || '未知用户')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .margin({ left: 16 })
        }
        .width('100%')
        .padding({ left: 24, right: 24 })
        .margin({ top: 10, bottom: 10 })

        // 邮箱
        Row() {
          Text("邮箱")
            .fontSize(16)
            .fontColor(Color.Gray)
            .width(80)
          Text(this.user?.email || '未设置')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .margin({ left: 16 })
        }
        .width('100%')
        .padding({ left: 24, right: 24 })
        .margin({ top: 10, bottom: 10 })

      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(12)
      .margin({ top: 20, left: 16, right: 16 })
      .padding({ bottom: 20 })

      // 消息通知开关
      Row() {
        Text("消息通知")
          .fontSize(16)
          .fontColor(Color.Gray)
          .layoutWeight(1)
        Toggle({ type: ToggleType.Switch, isOn: this.notificationsEnabled })
          .onChange((isOn: boolean) => {
            this.notificationsEnabled = isOn;
          })
      }
      .width('100%')
      .padding({ left: 24, right: 24, top: 16, bottom: 16 })
      .backgroundColor(Color.White)
      .margin({ top: 12, left: 16, right: 16 })
      .borderRadius(12)

      // 中间空白区域
      Blank()
        .layoutWeight(1)

      // 删除好友按钮
      Button("删除好友", { type: ButtonType.Capsule })
        .width('90%')
        .height(48)
        .backgroundColor("#FF3B30")
        .fontColor(Color.White)
        .fontSize(16)
        .margin({ bottom: 40 })
        .onClick(() => {
          // 删除好友逻辑
          this.deleteFriend();
        })
    }
    .height('100%')
    .width('100%')
    .backgroundColor("#F5F5F5")
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildHeader() {
    Row() {
      // 返回按钮
      Button("<")
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor("#000000")
        .width(40)
        .height(40)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          // 返回上一页逻辑
          // router.back();
        })

      // 标题
      Text("个人资料")
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor("#000000")
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      // 右侧占位
      Text("")
        .width(40)
        .height(40)
    }
    .width('100%')
    .height(60)
    .backgroundColor("#FFFFFF")
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .border({ width: { bottom: 1 }, color: "#E0E0E0" })
  }

  private deleteFriend() {
    // 删除好友的逻辑
    if (this.user) {
      // 这里添加删除好友的API调用
      console.log(`删除好友: ${this.user.username}`);

      // 确认对话框
      AlertDialog.show(
        {
          title: "删除好友",
          message: `确定要删除好友 ${this.user.username} 吗？`,
          primaryButton: {
            value: "取消",
            action: () => {
              console.log("取消删除");
            }
          },
          secondaryButton: {
            value: "删除",
            action: () => {
              console.log("确认删除");
              // 执行删除操作
              // EventBus.emit(Event.DELETE_FRIEND, this.user.userId);

              // 删除成功后返回上一页
              // router.back();
            }
          }
        }
      );
    }
  }
}

export { ContactInfoPage }