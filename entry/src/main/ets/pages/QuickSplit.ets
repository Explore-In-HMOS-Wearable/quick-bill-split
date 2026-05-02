import { SplitViewModel, SplitRecord } from '../viewmodel/SplitViewmodel';
import { ArcList, ArcListItem, ComponentContent } from '@kit.ArkUI';

@Component
export struct QuickSplit {
  watchSize: string = '466px'
  context: UIContext = this.getUIContext()
  header: ComponentContent<object> = new ComponentContent(this.context, wrapBuilder(header))
  @Consume('pathStack') pathStack: NavPathStack;
  @State vm: SplitViewModel = new SplitViewModel()

  build() {
    NavDestination() {
      Flex() {
        ArcList({ header: this.header }) {

          // Input 1: Total Amount
          ArcListItem() {
            TextInput({ placeholder: $r('app.string.p1') })
              .type(InputType.Number)
              .width($r('app.float.input_width'))
              .margin({ bottom: 12 })
              .onChange(value => {
                this.vm.setTotal(Number(value))
              })
          }

          // Input 2: Service Fee %
          ArcListItem() {
            TextInput({ placeholder: $r('app.string.p2') })
              .type(InputType.Number)
              .width($r('app.float.input_width'))
              .margin({ bottom: 12 })
              .onChange(value => {
                this.vm.setServiceFee(Number(value))
              })
          }

          // Input 3: Tip %
          ArcListItem() {
            TextInput({ placeholder: $r('app.string.p4') })
              .type(InputType.Number)
              .width($r('app.float.input_width'))
              .margin({ bottom: 12 })
              .onChange(value => {
                this.vm.setTip(Number(value))
              })
          }

          // Input 4: Number of People
          ArcListItem() {
            TextInput({ placeholder: $r('app.string.p3') })
              .type(InputType.Number)
              .width($r('app.float.input_width'))
              .margin({ bottom: 30 })
              .onChange(value => {
                this.vm.setPeople(Number(value))
              })
          }

          // Result card
          ArcListItem() {
            Column() {
              if (!this.vm.isValid) {
                Text($r('app.string.err_people'))
                  .fontSize($r('app.float.result_font_size_small'))
                  .fontColor(Color.Orange)
                  .textAlign(TextAlign.Center)
              } else {
                Text($r('app.string.total'))
                  .fontSize($r('app.float.result_font_size_small'))

                Text(`${this.vm.totalWithService.toFixed(2)} ₺`)
                  .fontSize($r('app.float.result_font_size_small'))
                  .margin({ bottom: 8 })

                Text($r('app.string.perperson'))
                  .fontSize($r('app.float.result_font_size_large'))
                  .fontWeight(FontWeight.Bold)

                Text(`${this.vm.perPerson.toFixed(2)} ₺`)
                  .fontSize($r('app.float.result_font_size_large'))
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.accent'))

                if (this.vm.remainder !== 0) {
                  Row() {
                    Text($r('app.string.remainder'))
                      .fontSize(11)
                      .opacity(0.7)
                    Text(`: ₺${this.vm.remainder.toFixed(2)}`)
                      .fontSize(11)
                      .opacity(0.7)
                  }
                  .margin({ top: 4 })
                }
              }

              // Save and Reset buttons
              Row() {
                Button($r('app.string.save'))
                  .fontSize(12)
                  .height(32)
                  .onClick(() => {
                    this.vm.saveRecord()
                  })
                  .margin({ right: 8 })

                Button($r('app.string.reset'))
                  .fontSize(12)
                  .height(32)
                  .onClick(() => {
                    this.vm.reset()
                  })
              }
              .margin({ top: 12 })
            }
            .width('70%')
            .padding($r('app.float.result_card_padding'))
            .backgroundColor($r('app.color.fg'))
            .borderRadius($r('app.float.result_card_border_radius'))
            .alignItems(HorizontalAlign.Center)
          }

          // History section header
          ArcListItem() {
            Text($r('app.string.history_title'))
              .fontSize($r('app.float.result_font_size_small'))
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
              .width('100%')
              .padding({ top: 8, bottom: 4 })
          }

          // History items or empty state
          ArcListItem() {
            Column() {
              if (this.vm.history.length === 0) {
                Text($r('app.string.history_empty'))
                  .fontSize($r('app.float.result_font_size_small'))
                  .opacity(0.6)
                  .textAlign(TextAlign.Center)
              } else {
                ForEach(this.vm.history, (record: SplitRecord) => {
                  Column() {
                    Text(`${record.perPerson.toFixed(2)} ₺`)
                      .fontSize($r('app.float.result_font_size_small'))
                      .fontColor($r('app.color.accent'))
                      .fontWeight(FontWeight.Bold)
                    Row() {
                      Text(`${record.people}`)
                        .fontSize(11)
                        .opacity(0.7)
                      Text($r('app.string.ppl'))
                        .fontSize(11)
                        .opacity(0.7)
                        .margin({ left: 4 })
                    }
                  }
                  .padding({ top: 6, bottom: 6 })
                  .width('100%')
                  .alignItems(HorizontalAlign.Center)
                }, (record: SplitRecord) => record.timestamp.toString())
              }
            }
            .width('70%')
            .padding($r('app.float.result_card_padding'))
            .backgroundColor($r('app.color.fg'))
            .borderRadius($r('app.float.result_card_border_radius'))
            .alignItems(HorizontalAlign.Center)
          }

        }
      }
      .width(this.watchSize)
      .height(this.watchSize)
      .backgroundColor($r('app.color.bg'))
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}

@Builder
function header() {
  Text($r('app.string.title'))
    .fontSize($r('app.float.header_font_size'))
    .fontWeight(FontWeight.Bold)
    .textAlign(TextAlign.Center)
    .margin({ top: 16, bottom: 12 })
    .fontColor(Color.White)
}
