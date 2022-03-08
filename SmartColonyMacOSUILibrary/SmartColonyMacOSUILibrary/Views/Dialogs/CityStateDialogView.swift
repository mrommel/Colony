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
            Text("TXT_KEY_CITY_STATE_OF".localized())
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

            Button("TXT_KEY_CITY_STATE_DECLARE_WAR".localized()) {
                print("declare war")
            }.buttonStyle(DialogButtonStyle(state: .normal))
        }
        .frame(width: 340)
    }

    var reportsView: some View {

        VStack(alignment: .center, spacing: 4) {

            Divider()

            Text("TXT_KEY_CITY_STATE_REPORT".localized())
                .font(.headline)

            Divider()

            HStack {

                Text("TXT_KEY_CITY_STATE_TYPE_TITLE".localized())
                    .frame(width: 155, alignment: .trailing)

                Text(self.viewModel.typeName)
                    .frame(width: 155, alignment: .leading)
            }

            HStack {

                Text("TXT_KEY_CITY_STATE_SUZERAIN_TITLE".localized())
                    .frame(width: 155, alignment: .trailing)

                Text(self.viewModel.suzerainName)
                    .frame(width: 155, alignment: .leading)
            }

            HStack {

                Text("TXT_KEY_CITY_STATE_ENVOYS_SENT_TITLE".localized())
                    .frame(width: 155, alignment: .trailing)
                    .onTapGesture {
                        self.viewModel.showEnvoysSent()
                    }

                Text(self.viewModel.envoysSentName)
                    .frame(width: 155, alignment: .leading)
            }

            HStack {

                Text("TXT_KEY_CITY_STATE_INFLUENCE_BY_TITLE".localized())
                    .frame(width: 155, alignment: .trailing)
                    .onTapGesture {
                        self.viewModel.showInfluencedBy()
                    }

                Text(self.viewModel.influencedByName)
                    .frame(width: 155, alignment: .leading)
            }

            HStack {

                Text("TXT_KEY_CITY_STATE_QUESTS_TITLE".localized())
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

            Text("TXT_KEY_CITY_STATE_ENVOYS_SENT".localized())
                .font(.headline)

            Label(self.viewModel.envoysSentDetailText)
        }
    }

    var influencedByView: some View {

        VStack(alignment: .center, spacing: 4) {

            Divider()

            Text("TXT_KEY_CITY_STATE_INFLUENCE_BY".localized())
                .font(.headline)
        }
    }

    var questView: some View {

        VStack(alignment: .center, spacing: 4) {

            Divider()

            Text("TXT_KEY_CITY_STATE_AVAILABLE_QUEST".localized())
                .font(.headline)

            Label(self.viewModel.questDetailText)

            Label("TXT_KEY_CITY_STATE_REWARD".localized())
        }
    }

    var bonusesView: some View {

        VStack(alignment: .center, spacing: 4) {

            Divider()

            Text("TXT_KEY_CITY_STATE_BONUSES".localized())
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
