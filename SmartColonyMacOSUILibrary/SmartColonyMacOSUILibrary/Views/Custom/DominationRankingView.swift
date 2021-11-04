//
//  DominationRankingView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct DominationRankingView: View {

    @ObservedObject
    var viewModel: DominationRankingViewModel

    private let cornerRadius: CGFloat = 10
    private let cardWidth: CGFloat = 300
    private let cardHeight: CGFloat = 60
    private let imageSize: CGFloat = 42

    public init(viewModel: DominationRankingViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            HStack {

                Image(nsImage: self.viewModel.image())
                    .resizable()
                    .frame(width: self.imageSize, height: self.imageSize)

                Text(self.viewModel.leaderName)
                    .font(.title)

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {

                    Text("\(self.viewModel.capturedCapitals.count) Capitals captured")
                        .font(.caption2)

                    LazyHStack(alignment: .top, spacing: 4) {

                        ForEach(self.viewModel.capturedCapitals, id: \.self) { civilizationViewModel in

                            CivilizationView(viewModel: civilizationViewModel)
                        }
                    }
                    .scaleEffect(0.50)
                    .frame(width: 21 * CGFloat(self.viewModel.capturedCapitals.count), height: 21)
                }
                .padding(.trailing, 8)
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
struct DominationRankingView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = DominationRankingViewModel(
            civilization: .french,
            leader: .cleopatra,
            capturedCapitals: [.english, .aztecs]

        )
        DominationRankingView(viewModel: viewModel)
    }
}
#endif
