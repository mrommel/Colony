//
//  CanFoundPantheonPopupView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 15.07.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CanFoundPantheonPopupView: View {

    @ObservedObject
    var viewModel: CanFoundPantheonPopupViewModel

    public init(viewModel: CanFoundPantheonPopupViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 0) {

                Text(self.viewModel.title)
                    .font(.title2)
                    .bold()
                    .padding(.top, 13)
                    .padding(.bottom, 8)

                VStack(spacing: 10) {

                    Text(self.viewModel.text)
                        .padding(.bottom, 10)

                    HStack(spacing: 10) {

                        Button(action: {
                            self.viewModel.foundPantheon()
                        }, label: {
                            Text(self.viewModel.foundText)
                        })
                        .padding(.bottom, 8)

                        Button(action: {
                            self.viewModel.closePopup()
                        }, label: {
                            Text("Close")
                        })
                        .padding(.bottom, 8)
                    }
                }
                .frame(width: 274, height: 128, alignment: .center)
                .background(Color(Globals.Colors.dialogBackground))
            }
            .padding(.bottom, 43)
            .padding(.leading, 19)
            .padding(.trailing, 19)

        }
        .frame(width: 300, height: 200, alignment: .top)
        .dialogBackground()
    }
}

#if DEBUG
struct CanFoundPantheonPopupView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = CanFoundPantheonPopupViewModel()

        CanFoundPantheonPopupView(viewModel: viewModel)
    }
}
#endif
