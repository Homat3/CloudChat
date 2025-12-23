@Component
export struct CommonInput {
//默认内容
  @Prop placeholder: string = '请输入内容'
  @Prop text: string = ''

  //默认样式
  @Prop inputBgColor: string = '#FFFFFF'
  @Prop inputFontColor: Color = Color.Black
  @Prop inputBorderColor: string = '#E5E5E5'
  @Prop inputBorderRadius: number = 8

  // 该变量
  @Prop inputType: InputType = InputType.Normal
  @Prop isEnabled: boolean = true
  @Prop maxLength: number = 50

  // 回调函数
  @Prop onTextChange: (text: string) => void = () => {}
  @Prop onInputFocus: () => void = () => {}
  @Prop onInputBlur: () => void = () => {}

  build() {
    Column() {
      TextInput({
        placeholder: this.placeholder,
        text: this.text
      })
        .width('90%')
        .height(48)
        .backgroundColor(this.inputBgColor)
        .placeholderColor(Color.Gray)
        .placeholderFont({
          size: 16,
          weight: FontWeight.Normal
        })
        .caretColor('#007DFF')
        .fontColor(this.inputFontColor)
        .fontSize(16)
        .type(this.inputType)
        .enabled(this.isEnabled)
        .maxLength(this.maxLength)
        .border({
          color: this.inputBorderColor,
          width: 1,
          radius: this.inputBorderRadius
        })
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          this.onTextChange(value)
        })
        .onFocus(() => {
          this.onInputFocus()
        })
        .onBlur(() => {
          this.onInputBlur()
        })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}