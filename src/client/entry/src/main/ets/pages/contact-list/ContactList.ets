@Entry
@Component
struct ContactList {
  @State message: string = 'Hello CloudChat';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('PageHelloCloudChat')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          //垂直居中
          center: { anchor: '__container__', align: VerticalAlign.Center },
          //水平居中
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome'; //点击后更新触发UI重绘
        })
    }
    //容器高与宽占满
    .height('100%')
    .width('100%')
  }
}