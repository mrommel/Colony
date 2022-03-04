//
//  CityStatesDialogViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 28.02.22.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

class CityStatesDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var cityStateViewModels: [CityStateViewModel]

    @Published
    var envoyEffectViewModels: [EnvoyEffectViewModel]

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "TXT_KEY_CITY_STATE_TITLE".localized()
        self.cityStateViewModels = []
        self.envoyEffectViewModels = []
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard let diplomacyAI = humanPlayer.diplomacyAI else {
            fatalError("cant get human diplomacyAI")
        }

        var cityStatesMetByHuman: [CityStateType] = []

        for player in gameModel.players {

            if player.isCityState() {
                if diplomacyAI.hasMet(with: player) {
                    if case .cityState(type: let cityStateType) = player.leader {
                        cityStatesMetByHuman.append(cityStateType)
                    }
                }
            }
        }

        // city states
        var tmpCityStateViewModels: [CityStateViewModel] = []

        for cityState in cityStatesMetByHuman {

            let numEnvoys = humanPlayer.envoysAssigned(to: cityState)
            let suzerain: String = gameModel.cityStatePlayer(for: cityState)?.suzerain()?.name() ?? "none"

            let cityStateViewModel = CityStateViewModel(
                cityState: cityState,
                suzerainName: suzerain,
                quest: .none,
                envoys: numEnvoys
            )
            cityStateViewModel.delegate = self
            tmpCityStateViewModels.append(cityStateViewModel)
        }

        self.cityStateViewModels = tmpCityStateViewModels

        // effects
        var tmpEnvoyEffectViewModels: [EnvoyEffectViewModel] = []

        for envoyEffect in humanPlayer.envoyEffects(in: gameModel) {

            tmpEnvoyEffectViewModels.append(EnvoyEffectViewModel(envoyEffect: envoyEffect))
        }

        self.envoyEffectViewModels = tmpEnvoyEffectViewModels
    }

    func cityStateIcon() -> NSImage {

        return ImageCache.shared.image(for: "city-states")
    }
}

extension CityStatesDialogViewModel: CityStateViewModelDelegate {

    func assignEnvoy(to cityState: CityStateType) -> Bool {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        return humanPlayer.assignEnvoy(to: cityState, in: gameModel)
    }

    func unassignEnvoy(from cityState: CityStateType) -> Bool {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        return humanPlayer.unassignEnvoy(from: cityState, in: gameModel)
    }

    func center(on cityState: CityStateType) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let cityStatePlayer = gameModel.cityStatePlayer(for: cityState) else {
            fatalError("cant get city state player")
        }

        if let capital = cityStatePlayer.capitalCity(in: gameModel) {
            self.delegate?.focus(on: capital.location)
        } else {
            print("cannot center on \(cityState) - no capital")
        }

        self.delegate?.closeDialog()
    }
}

extension CityStatesDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
