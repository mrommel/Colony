//
//  LeaderView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.11.21.
//

import SwiftUI

struct LeaderView: View {

    @ObservedObject
    var viewModel: LeaderViewModel

    var body: some View {

        HStack(alignment: .top, spacing: 4) {

            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 42, height: 42, alignment: .topLeading)
                .onTapGesture {
                    self.viewModel.clicked()
                }
        }
        .toolTip(self.viewModel.toolTip)
    }
}

#if DEBUG
struct LeaderView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        LeaderView(viewModel: LeaderViewModel(leaderType: .cyrus))

        LeaderView(viewModel: LeaderViewModel(leaderType: .cleopatra))
    }
}
#endif
