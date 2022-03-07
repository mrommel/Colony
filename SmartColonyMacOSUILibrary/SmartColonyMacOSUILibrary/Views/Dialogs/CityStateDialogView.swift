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

                    ScrollView {

                        self.buttonsView

                        self.reportsView

                        self.detailView

                        self.bonusesView
                    }
                    .frame(width: 340)
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
                    .frame(width: 32, height: 32)

                Text(self.viewModel.cityStateName)
                    .font(.title)
            }

            Divider()
        }
        .frame(width: 340)
    }

    var buttonsView: some View {

        VStack(alignment: .center, spacing: 4) {

            Button("Declare War".localized()) {
                print("declare war")
            }.buttonStyle(DialogButtonStyle(state: .normal))
        }
        .frame(width: 340)
    }

    var reportsView: some View {

        VStack(alignment: .center, spacing: 4) {

            Divider()

            Text("Report")
                .font(.headline)

            Divider()

            HStack {

                Text("Type:")
                    .frame(width: 155, alignment: .trailing)

                Text(self.viewModel.typeName)
                    .frame(width: 155, alignment: .leading)
            }

            HStack {

                Text("Suzerain:")
                    .frame(width: 155, alignment: .trailing)

                Text(self.viewModel.suzerainName)
                    .frame(width: 155, alignment: .leading)
            }

            HStack {

                Text("Envoys sent:")
                    .frame(width: 155, alignment: .trailing)
                    .onTapGesture {
                        self.viewModel.showEnvoysSent()
                    }

                Text(self.viewModel.envoysSentName)
                    .frame(width: 155, alignment: .leading)
            }

            HStack {

                Text("Influenced by:")
                    .frame(width: 155, alignment: .trailing)
                    .onTapGesture {
                        self.viewModel.showInfluencedBy()
                    }

                Text(self.viewModel.influencedByName)
                    .frame(width: 155, alignment: .leading)
            }

            HStack {

                Text("Quests:")
                    .frame(width: 155, alignment: .trailing)
                    .onTapGesture {
                        self.viewModel.showQuests()
                    }

                Text(self.viewModel.questsName)
                    .frame(width: 155, alignment: .leading)
            }
        }
        .frame(width: 340)
    }

    var detailView: some View {

        switch self.viewModel.detail {

        case .envoysSent:
            return AnyView(self.envoysSentView)
        case .influencedBy:
            return AnyView(self.influencedByView)
        case .quest:
            return AnyView(self.questView)
        }
    }

    var envoysSentView: some View {

        VStack(alignment: .center, spacing: 4) {

            Divider()

            Text("Envoys Sent")
                .font(.headline)

            Label(self.viewModel.envoysSentDetailText)

            Label("Reward: 1 [Envoy] Envoy")
        }
    }

    var influencedByView: some View {

        VStack(alignment: .center, spacing: 4) {

            Divider()

            Text("Influenced by")
                .font(.headline)

            Label("Reward: 1 [Envoy] Envoy")
        }
    }

    var questView: some View {

        VStack(alignment: .center, spacing: 4) {

            Divider()

            Text("Available Quest")
                .font(.headline)

            Label(self.viewModel.questDetailText)

            Label("Reward: 1 [Envoy] Envoy")
        }
    }

    var bonusesView: some View {

        VStack(alignment: .center, spacing: 4) {

            Divider()

            Text("Bonuses")
                .font(.headline)

            // list of all (enabled / disabled) bonuses
            LazyVStack(alignment: .leading) {

                ForEach(self.viewModel.envoyEffectViewModels, id: \.self) { envoyEffectViewModel in

                    EnvoyEffectView(viewModel: envoyEffectViewModel)
                }
            }
            .frame(width: 340)
        }
        .frame(width: 340)
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
