//
//  TradePostView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.05.21.
//

import SwiftUI

struct TradePostView: View {

    @ObservedObject
    var viewModel: TradePostViewModel

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
        }
        .frame(width: 300, height: 42, alignment: .topLeading)
        .background(
            Image(nsImage: self.viewModel.background())
                .resizable(capInsets: EdgeInsets(all: 15))
        )
    }
}

#if DEBUG
struct TradePostView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        TradePostView(viewModel: TradePostViewModel(leaderType: .alexander))

        TradePostView(viewModel: TradePostViewModel(leaderType: .napoleon))
    }
}
#endif
