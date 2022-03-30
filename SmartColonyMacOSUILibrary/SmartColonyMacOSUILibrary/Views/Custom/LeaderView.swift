//
//  LeaderView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.11.21.
//

import SwiftUI
import SmartAILibrary

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

                Image(nsImage: self.viewModel.approachImage)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.top, 24)
                    .padding(.trailing, 24)
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

    static func viewModel(leader: LeaderType) -> LeaderViewModel {

        let viewModel = LeaderViewModel(leaderType: leader)
        viewModel.show = true

        let game = DemoGameModel()

        viewModel.gameEnvironment.game.value = game
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        LeaderView(
            viewModel: LeaderView_Previews.viewModel(
                leader: .cyrus
            )
        )

        LeaderView(
            viewModel: LeaderView_Previews.viewModel(
                leader: .cleopatra
            )
        )
    }
}
#endif
