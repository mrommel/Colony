//
//  VictoryDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.11.21.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

struct VictoryDialogView: View {

    @ObservedObject
    var viewModel: VictoryDialogViewModel

    private let cornerRadius: CGFloat = 5
    private let cardWidth: CGFloat = 300
    private let cardHeight: CGFloat = 160
    private let imageSize: CGFloat = 50

    public init(viewModel: VictoryDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(title: self.viewModel.title, mode: .landscape, viewModel: self.viewModel) {

            VStack(alignment: .center) {

                self.bannerView

                self.buttonView

                self.contentView

                Spacer()
            }
            .frame(width: 750, height: 330)
            .background(
                Globals.Style.dialogBackground
            )
        }
    }

    var bannerView: some View {

        ZStack(alignment: .center) {

            Image(nsImage: self.viewModel.bannerImage())
                .resizable()
                .frame(width: 750, height: 53)
                .padding(.top, 35)

            Text(self.viewModel.title)
                .font(.title)
                .padding(.top, 35)
                .padding(.leading, -140)
        }
    }

    var buttonView: some View {

        HStack {

            Spacer()

            Button(
                action: {
                    self.viewModel.set(detailType: .info)
                },
                label: {
                    Text("Info")
                }
            )
                .buttonStyle(DialogButtonStyle(state: self.viewModel.detailType == .info ? .highlighted : .normal))

            Button(
                action: {
                    self.viewModel.set(detailType: .ranking)
                },
                label: {
                    Text("Ranking")
                }
            )
                .buttonStyle(DialogButtonStyle(state: self.viewModel.detailType == .ranking ? .highlighted : .normal))

            Button(
                action: {
                    self.viewModel.set(detailType: .graphs)
                },
                label: {
                    Text("Graphs")
                }
            )
                .buttonStyle(DialogButtonStyle(state: self.viewModel.detailType == .graphs ? .highlighted : .normal))

            Spacer()
        }
        .background(Color(Globals.Colors.dialogBackground))
    }

    var contentView: AnyView {

        switch self.viewModel.detailType {

        case .info:
            return AnyView(self.infoContainerView)
        case .ranking:
            return AnyView(self.rankingContainerView)
        case .graphs:
            return AnyView(self.graphsContainerView)
        }
    }

    private var infoContainerView: some View {

        ZStack(alignment: .topLeading) {

            RoundedRectangle(cornerRadius: self.cornerRadius)
                .strokeBorder(Color(Globals.Colors.dialogBorder), lineWidth: 1)
                .frame(width: self.cardWidth, height: self.cardHeight)
                .background(Color(Globals.Colors.dialogBackground))

            VStack(alignment: .leading, spacing: 4) {

                HStack {
                    Image(nsImage: self.viewModel.image())
                        .resizable()
                        .frame(width: 42, height: 42)

                    Text(self.viewModel.victoryTitle)
                        .font(.title)

                    Spacer()
                }

                Text(self.viewModel.civilizationTitle)

                Text(self.viewModel.victorySummary)
            }
            .padding()
            .frame(width: self.cardWidth)
        }
        .frame(width: self.cardWidth, height: self.cardHeight, alignment: .center)
        .cornerRadius(self.cornerRadius)
    }

    private var rankingContainerView: some View {

        ScrollView(.vertical, showsIndicators: true, content: {

            LazyVStack(spacing: 10) {

                ForEach(self.viewModel.victoryRankingViewModels, id: \.self) { victoryRankingViewModel in

                    HStack(alignment: .top) {

                        Text("\(victoryRankingViewModel.index)")
                            .frame(width: 20)

                        Text(victoryRankingViewModel.name)
                            .frame(width: 150)

                        Spacer()

                        Text("\(victoryRankingViewModel.minScore)")
                    }
                    .frame(width: 250)
                    .background(victoryRankingViewModel.selected ? Color.red : Color.clear)
                }
            }
        })
            .frame(width: self.cardWidth, height: self.cardHeight, alignment: .center)
    }

    private var graphsContainerView: some View {

        VStack {

            DataPicker(
                title: "Value",
                data: self.viewModel.graphValues,
                selection: self.$viewModel.selectedGraphValueIndex)

            ScoreChartView(data: self.$viewModel.graphData)
                .frame(width: self.cardWidth, height: self.cardHeight, alignment: .center)
        }
    }
}

#if DEBUG
struct VictoryDialogView_Previews: PreviewProvider {

    static func viewModel(leader: LeaderType, victory: VictoryType) -> VictoryDialogViewModel {

        let viewModel = VictoryDialogViewModel()

        let game = DemoGameModel()
        game.set(winner: leader, for: victory)

        viewModel.gameEnvironment.game.value = game
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = VictoryDialogView_Previews.viewModel(
            leader: .alexander,
            victory: .domination
        )
        VictoryDialogView(viewModel: viewModel)
    }
}
#endif
