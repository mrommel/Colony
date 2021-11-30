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

        if self.viewModel.show {
            ZStack {

                Image(nsImage: self.viewModel.badgeImage())
                    .resizable()
                    .frame(width: 52, height: 52)

                Image(nsImage: self.viewModel.image())
                    .resizable()
                    .frame(width: 42, height: 42)
                    .onTapGesture {
                        self.viewModel.clicked()
                    }
            }
            .frame(width: 52, height: 52)
            .toolTip(self.viewModel.toolTip)
        } else {
            EmptyView()
        }
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
