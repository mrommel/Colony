//
//  EraProgressDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.12.21.
//

import SwiftUI
import SmartAILibrary

struct EraProgressDialogView: View {

    @ObservedObject
    var viewModel: EraProgressDialogViewModel

    public init(viewModel: EraProgressDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(
            title: self.viewModel.title,
            mode: .portrait,
            buttonText: "Cancel",
            viewModel: self.viewModel) {

                ScrollView(.vertical, showsIndicators: true, content: {

                    VStack {
                        Text("The " + self.viewModel.eraTitle + " Era")
                            .font(.title)

                        self.turnsView

                        self.civilizationsView

                        self.earnView

                        Spacer()
                    }
                    .padding()

                })

            }
    }

    var turnsView: some View {

        VStack {
            Divider()

            HStack {

                Text("Turns until next era:")

                Spacer()

                Text("35-55")
            }

            Divider()

            HStack(alignment: .top) {

                LeaderView(viewModel: self.viewModel.leaderViewModel)

                VStack {

                    HStack {

                        Text("Current Score:")

                        Spacer()

                        Text("172")
                    }

                    HStack {

                        Text("Current Age:")

                        Spacer()

                        Text("normal")
                    }
                }
            }
        }
    }

    var civilizationsView: some View {

        VStack {
            Divider()

            Text("Current age by Civilization")
                .font(.caption)

            Divider()

            CivilizationView(viewModel: CivilizationViewModel(civilization: .aztecs))
        }
    }

    var earnView: some View {

        VStack {
            Divider()

            Text("To earn a new age next era")
                .font(.caption)

            Divider()

            HStack {

                Image(nsImage: self.viewModel.darkAgeImage)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Dark Age")

                Spacer()

                Text("0-206")
                Image(nsImage: self.viewModel.darkAgeCheckmarkImage)
                    .resizable()
                    .frame(width: 20, height: 20)
            }

            HStack {

                Text("Normal Age")

                Spacer()

                Text("207-220")
            }

            HStack {

                Text("Golden Age")

                Spacer()

                Text("221+")
            }
        }
    }
}

#if DEBUG
struct EraProgressDialogView_Previews: PreviewProvider {

    static func viewModel(leader: LeaderType) -> EraProgressDialogViewModel {

        let viewModel = EraProgressDialogViewModel()

        let game = DemoGameModel()
        game.rankingData.add(culturePerTurn: 1, for: .alexander)
        game.rankingData.add(culturePerTurn: 0, for: .victoria)
        game.rankingData.add(culturePerTurn: 2, for: .alexander)
        game.rankingData.add(culturePerTurn: 1, for: .victoria)

        viewModel.gameEnvironment.game.value = game
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = EraProgressDialogView_Previews.viewModel(
            leader: .alexander
        )
        EraProgressDialogView(viewModel: viewModel)
    }
}
#endif
