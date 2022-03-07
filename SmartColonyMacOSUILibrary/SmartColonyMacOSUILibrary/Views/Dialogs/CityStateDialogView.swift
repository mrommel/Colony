//
//  CityStateDialogView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 07.03.22.
//

import SwiftUI
import SmartAssets

struct CityStateDialogView: View {

    @ObservedObject
    var viewModel: CityStateDialogViewModel

    public init(viewModel: CityStateDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(
            title: self.viewModel.title,
            mode: .portrait,
            buttonText: "TXT_KEY_CANCEL",
            viewModel: self.viewModel) {

                VStack(alignment: .center, spacing: 4) {

                    self.headerView

                    self.buttonsView

                    self.reportsView
                }
                .frame(width: 350, height: 330, alignment: .top)
                .background(
                    Globals.Style.dialogBackground
                )
            }
    }

    var headerView: some View {

        VStack(alignment: .center, spacing: 4) {
            Text("of")
                .font(.body)

            HStack {
                Image(nsImage: self.viewModel.cityStateImage())
                    .resizable()
                    .frame(width: 42, height: 42)

                Text(self.viewModel.cityStateName)
                    .font(.title)
            }
        }
        .frame(width: 300)
    }

    var buttonsView: some View {

        VStack(alignment: .center, spacing: 4) {

            Button("Declare War".localized()) {
                print("declare war")
            }.buttonStyle(DialogButtonStyle(state: .normal))
        }
        .frame(width: 300)
    }

    var reportsView: some View {

        VStack(alignment: .center, spacing: 4) {

            Text("Report")
                .font(.headline)

            HStack {

                Text("Type:")
                    .frame(width: 145, alignment: .trailing)

                Text(self.viewModel.typeName)
                    .frame(width: 145, alignment: .leading)
            }

            HStack {

                Text("Suzerain:")
                    .frame(width: 145, alignment: .trailing)

                Text(self.viewModel.suzerainName)
                    .frame(width: 145, alignment: .leading)
            }

            HStack {

                Text("Envoys sent:")
                    .frame(width: 145, alignment: .trailing)

                Text(self.viewModel.envoysSentName)
                    .frame(width: 145, alignment: .leading)
            }

            HStack {

                Text("Influenced by:")
                    .frame(width: 145, alignment: .trailing)

                Text(self.viewModel.influencedByName)
                    .frame(width: 145, alignment: .leading)
            }

            HStack {

                Text("Quests:")
                    .frame(width: 145, alignment: .trailing)

                Text(self.viewModel.questsName)
                    .frame(width: 145, alignment: .leading)
            }
        }
        .frame(width: 300)
    }
}

#if DEBUG
import SmartAILibrary

struct CityStateDialogView_Previews: PreviewProvider {

    static func viewModel() -> CityStateDialogViewModel {

        let game = DemoGameModel()
        let cityStatePlayer = game.cityStatePlayer(for: .amsterdam)

        let city = City(name: "Amsterdam", at: HexPoint(x: 7, y: 7), capital: true, owner: cityStatePlayer)
        city.initialize(in: game)
        game.add(city: city)

        let viewModel = CityStateDialogViewModel()

        viewModel.gameEnvironment.game.value = game
        viewModel.update(for: city)

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = CityStateDialogView_Previews.viewModel()
        CityStateDialogView(viewModel: viewModel)
    }
}
#endif
