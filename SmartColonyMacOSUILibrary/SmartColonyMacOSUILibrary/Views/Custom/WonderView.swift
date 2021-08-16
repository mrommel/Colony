//
//  WonderView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary

struct WonderView: View {

    @ObservedObject
    var viewModel: WonderViewModel

    var body: some View {
        HStack(alignment: .center, spacing: 10) {

            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 24, height: 24, alignment: .topLeading)
                .padding(.leading, 16)
                .padding(.top, 9)

            Text(self.viewModel.title())
                .padding(.top, 9)

            Spacer()

            if self.viewModel.showYields {

                HStack(alignment: .center, spacing: 0) {
                    ForEach(self.viewModel.yieldValueViewModels(), id: \.self) { yieldValueViewModel in

                        YieldValueView(viewModel: yieldValueViewModel)
                            .padding(.trailing, 0)
                            .padding(.leading, -8)
                    }
                }
                .padding(.top, 9)
                .padding(.trailing, 16)
                .padding(.leading, 0)
            } else {
                Text(self.viewModel.turnsText())
                    .padding(.top, 9)
                    .padding(.trailing, 0)

                Image(nsImage: self.viewModel.turnsIcon())
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .topLeading)
                    .padding(.trailing, 16)
                    .padding(.top, 9)
            }
        }
        .frame(width: 300, height: 42, alignment: .topLeading)
        .background(
            Image(nsImage: self.viewModel.background())
                .resizable(capInsets: EdgeInsets(all: 15))
        )
        .onTapGesture {
            self.viewModel.clicked()
        }
    }
}

#if DEBUG
struct WonderView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        WonderView(viewModel: WonderViewModel(wonderType: .pyramids, turns: 34))

        WonderView(viewModel: WonderViewModel(wonderType: .pyramids, turns: 34, showYields: true))
    }
}
#endif
