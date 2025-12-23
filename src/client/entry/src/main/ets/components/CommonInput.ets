// CommonInput.ets
@Component
export struct CommonInput {
  // 输入框提示文本
  @Prop placeholder: string = '请输入内容'

  // 输入框当前值
  @Prop text: string = ''

  // 背景颜色
  @Prop inputBgColor: string = '#FFFFFF'

  // 字体颜色
  @Prop inputFontColor: Color = Color.Black

  // 边框颜色（重命名避免冲突）
  @Prop inputBorderColor: string = '#E5E5E5'

  // 边框圆角（重命名避免冲突）
  @Prop inputBorderRadius: number = 8

  // 输入框类型
  @Prop inputType: InputType = InputType.Normal

  // 是否禁用（重命名避免冲突）
  @Prop isEnabled: boolean = true

  // 最大输入长度
  @Prop maxLength: number = 50

  // 输入变化回调
  @Prop onTextChange: (text: string) => void = () => {}

  // 获取焦点回调（重命名避免冲突）
  @Prop onInputFocus: () => void = () => {}

  // 失去焦点回调（重命名避免冲突）
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
        .enabled(this.isEnabled)  // 使用重命名后的属性
        .maxLength(this.maxLength)
        .border({
          color: this.inputBorderColor,  // 使用重命名后的属性
          width: 1,
          radius: this.inputBorderRadius  // 使用重命名后的属性
        })
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          this.onTextChange(value)
        })
        .onFocus(() => {
          this.onInputFocus()  // 使用重命名后的回调
        })
        .onBlur(() => {
          this.onInputBlur()  // 使用重命名后的回调
        })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}