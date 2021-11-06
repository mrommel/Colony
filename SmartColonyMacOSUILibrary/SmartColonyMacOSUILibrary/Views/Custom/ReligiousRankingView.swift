//
//  ReligiousRankingView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct ReligiousRankingView: View {

    @ObservedObject
    var viewModel: ReligiousRankingViewModel

    private let cornerRadius: CGFloat = 10
    private let cardWidth: CGFloat = 300
    private let cardHeight: CGFloat = 60
    private let imageSize: CGFloat = 42

    public init(viewModel: ReligiousRankingViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            HStack {

                Image(nsImage: self.viewModel.image())
                    .resizable()
                    .frame(width: self.imageSize, height: self.imageSize)

                VStack(alignment: .leading, spacing: 2) {
                    Text(self.viewModel.leaderName)
                        .font(.headline)

                    Text(self.viewModel.religionName)
                        .font(.caption2)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {

                    Text("\(self.viewModel.convertedCivilizations.count) converted to \(self.viewModel.religionName)")
                        .font(.caption2)

                    LazyHStack(alignment: .top, spacing: 4) {

                        ForEach(self.viewModel.convertedCivilizations, id: \.self) { civilizationViewModel in

                            CivilizationView(viewModel: civilizationViewModel)
                        }
                    }
                    .scaleEffect(0.50)
                    .frame(width: 22 * CGFloat(self.viewModel.convertedCivilizations.count), height: 21)
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
struct ReligiousRankingView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = ReligiousRankingViewModel(
            civilization: .french,
            leader: .cleopatra,
            religion: .buddhism,
            convertedCivilizations: [.english, .aztecs]

        )
        ReligiousRankingView(viewModel: viewModel)
    }
}
#endif
