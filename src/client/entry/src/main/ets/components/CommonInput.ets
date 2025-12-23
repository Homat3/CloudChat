// CommonInput.ets
@Component
export struct CommonInput {//复选框通用样式

  @Prop placeholder: string = '请输入内容'
  @Prop text: string = ''
  @Prop bgColor: string = '#FFFFFF'
  @Prop fontColor: Color = Color.Black
  @Prop borderColor: string = '#E5E5E5'
  @Prop borderRadius: number = 8
  @Prop type: InputType = InputType.Normal
  @Prop enabled: boolean = true
  @Prop maxLength: number = 50
  @Prop onTextChange: (text: string) => void = () => {}
  @Prop onFocus: () => void = () => {}
  @Prop onBlur: () => void = () => {}

  build() {
    Column() {
      TextInput({
        placeholder: this.placeholder,
        text: this.text
      })
        .width('90%')
        .height(48)
        .backgroundColor(this.bgColor)
        .placeholderColor(Color.Gray)
        .placeholderFont({
          size: 16,
          weight: FontWeight.Normal
        })
        .caretColor('#007DFF')
        .fontColor(this.fontColor)
        .fontSize(16)
        .type(this.type)
        .enabled(this.enabled)
        .maxLength(this.maxLength)
        .border({
          color: this.borderColor,
          width: 1,
          radius: this.borderRadius
        })
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          this.onTextChange(value)
        })
        .onFocus(() => {
          this.onFocus()
        })
        .onBlur(() => {
          this.onBlur()
        })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}