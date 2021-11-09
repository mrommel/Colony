//
//  OverallRankingView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct OverallRankingView: View {

    @ObservedObject
    var viewModel: OverallRankingViewModel

    private let cornerRadius: CGFloat = 10
    private let cardWidth: CGFloat = 300
    private let cardHeight: CGFloat = 130
    private let imageSize: CGFloat = 42

    public init(viewModel: OverallRankingViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            HStack {

                Image(nsImage: self.viewModel.image())
                    .resizable()
                    .frame(width: self.imageSize, height: self.imageSize)

                Text(self.viewModel.title)
                    .font(.title)
            }
            .padding(.top, 8)
            .padding(.leading, 8)

            Text(self.viewModel.summary)
                .padding(.leading, 8)

            LazyHStack(spacing: 4) {

                ForEach(self.viewModel.civilizationViewModels, id: \.self) { civilizationViewModel in

                    CivilizationView(viewModel: civilizationViewModel)
                }
            }
            .frame(height: 42)
            .padding(.top, 4)
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
struct OverallRankingView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = OverallRankingViewModel(
            type: .overall,
            summary: "You are leading",
            civilizations: [.english, .aztecs, .egyptian])
        OverallRankingView(viewModel: viewModel)
    }
}
#endif
