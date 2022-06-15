//
//  HeaderButtonView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAssets

struct HeaderButtonView: View {

    @ObservedObject
    public var viewModel: HeaderButtonViewModel

    public init(viewModel: HeaderButtonViewModel) {

        self.viewModel = viewModel
    }

    public var body: some View {

        ZStack(alignment: .topLeading) {

            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 38, height: 38, alignment: .center)
                .padding(.top, 4)
                .padding(.leading, 9.5)

            Image(nsImage: self.viewModel.alertImage())
                .resizable()
                .frame(width: 38, height: 38, alignment: .center)
                .padding(.top, 4)
                .padding(.leading, 9.5)
                .onTapGesture {
                    self.viewModel.clicked()
                }
        }
        .frame(width: 56, height: 47, alignment: .topLeading)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "header-bar-button"))
                .resizable()
        )
        .tooltip(self.viewModel.toolTip(), side: self.viewModel.toolTipSide)
    }
}

#if DEBUG
struct HeaderButtonView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = HeaderButtonViewModel(type: .government, toolTipSide: .bottom)

        HeaderButtonView(viewModel: viewModel)
    }
}
#endif
