//
//  WonderBuiltPopupView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct WonderBuiltPopupView: View {

    @ObservedObject
    var viewModel: WonderBuiltPopupViewModel

    public init(viewModel: WonderBuiltPopupViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 0) {

                Text(self.viewModel.title)
                    .font(.title2)
                    .bold()
                    .padding(.top, 12)
                    .padding(.bottom, 10)

                VStack(alignment: .center, spacing: 6) {

                    Image(nsImage: self.viewModel.icon())
                        .resizable()
                        .frame(width: 48, height: 48, alignment: .topLeading)
                        .padding(.top, 6)

                    Text(self.viewModel.nameText)
                        .font(.headline)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 10)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)

                    ForEach(self.viewModel.bonusTexts, id: \.self) { bonusText in

                        Label(bonusText)
                    }
                    .padding(.top, 2)
                    .padding(.trailing, 0)
                    .padding(.leading, 0)

                    Spacer()

                    Button(action: {
                        self.viewModel.closePopup()
                    }, label: {
                        Text("Close")
                    })
                    .buttonStyle(DialogButtonStyle())
                    .padding(.bottom, 8)
                }
                .frame(width: 362, height: 284, alignment: .center)
                .background(Color(Globals.Colors.dialogBackground))
            }
            .padding(.bottom, 43)
            .padding(.leading, 19)
            .padding(.trailing, 19)
        }
        .frame(width: 400, height: 370, alignment: .top)
        .dialogBackground()
    }
}

#if DEBUG
struct WonderBuiltPopupView_Previews: PreviewProvider {

    static func viewModel() -> WonderBuiltPopupViewModel {

        let viewModel = WonderBuiltPopupViewModel()
        viewModel.update(for: .pyramids)

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = WonderBuiltPopupView_Previews.viewModel()
        WonderBuiltPopupView(viewModel: viewModel)
    }
}
#endif
