@Component
export struct CommonButton{//通用按钮
  @Prop text:string='';
  @Prop bgColor:string='#007DFF'
  @Prop fontColor:Color = Color.White
  @Prop onBtnClick: (event:ClickEvent) => void = ()=> {};

  build() {
    Button(this.text)
      .width('80%')
      .height(50)
      .backgroundColor(this.bgColor)
      .fontColor(this.fontColor)
      .borderRadius(8)
      // 传递ClickEvent参数给外部回调
      .onClick((event: ClickEvent) => this.onBtnClick(event));
  }
}