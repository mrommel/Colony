//
//  ScoreRankingView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct ScoreRankingView: View {

    @ObservedObject
    var viewModel: ScoreRankingViewModel

    private let cornerRadius: CGFloat = 10
    private let cardWidth: CGFloat = 300
    private let cardHeight: CGFloat = 60
    private let imageSize: CGFloat = 42

    public init(viewModel: ScoreRankingViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            HStack {

                Image(nsImage: self.viewModel.image())
                    .resizable()
                    .frame(width: self.imageSize, height: self.imageSize)

                Text(self.viewModel.leaderName)

                Spacer()

                Text("\(self.viewModel.score)")
                    .padding(.leading, 8)
            }
            .padding(.top, 8)
            .padding(.leading, 8)
        }
        .frame(width: self.cardWidth, height: self.cardHeight, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color(Globals.Colors.dialogBorder), lineWidth: 1)
                .frame(width: self.cardWidth, height: self.cardHeight)
                .background(Color(Globals.Colors.buttonBackground))
        )
    }
}

#if DEBUG
struct ScoreRankingView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = ScoreRankingViewModel(
            civilization: .french,
            leader: .cleopatra,
            score: 20)
        ScoreRankingView(viewModel: viewModel)
    }
}
#endif
