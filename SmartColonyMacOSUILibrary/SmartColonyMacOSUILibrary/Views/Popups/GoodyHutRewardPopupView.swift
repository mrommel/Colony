//
//  GoodyHutRewardPopupView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct GoodyHutRewardPopupView: View {

    @ObservedObject
    var viewModel: GoodyHutRewardPopupViewModel

    public init(viewModel: GoodyHutRewardPopupViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 0) {

                Text(self.viewModel.title)
                    .font(.title2)
                    .bold()
                    .padding(.top, 13)
                    .padding(.bottom, 10)

                VStack(spacing: 10) {

                    Label(self.viewModel.text)
                        .padding(.bottom, 10)

                    Button(action: {
                        self.viewModel.closePopup()
                    }, label: {
                        Text("Close")
                    })
                    .padding(.bottom, 8)
                }
                .frame(width: 262, height: 114, alignment: .center)
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
struct GoodyHutRewardPopupView_Previews: PreviewProvider {

    static func viewModel() -> GoodyHutRewardPopupViewModel {

        let viewModel = GoodyHutRewardPopupViewModel()
        viewModel.update(for: .additionalPopulation, at: HexPoint.zero)

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = GoodyHutRewardPopupView_Previews.viewModel()
        GoodyHutRewardPopupView(viewModel: viewModel)
    }
}
#endif
