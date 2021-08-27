//
//  WonderBuiltPopupView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.08.21.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

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

                    /*Image(nsImage: self.viewModel.icon())
                        .resizable()
                        .frame(width: 48, height: 48, alignment: .topLeading)
                        .padding(.top, 6)*/

                    Text(self.viewModel.nameText)
                        .font(.headline)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 10)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)

                    Button(action: {
                        self.viewModel.closePopup()
                    }, label: {
                        Text("Close")
                    })
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
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}

#if DEBUG
struct WonderBuiltPopupView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = WonderBuiltPopupViewModel(wonderType: .pyramids)

        WonderBuiltPopupView(viewModel: viewModel)
    }
}
#endif
