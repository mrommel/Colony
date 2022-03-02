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

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "City-States"
        self.cityStateViewModels = []
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

        var tmpCityStateViewModels: [CityStateViewModel] = []

        for cityState in cityStatesMetByHuman {

            let numEnvoys = humanPlayer.envoysAssigned(to: cityState)

            let cityStateViewModel = CityStateViewModel(cityState: cityState, quest: .none, envoys: numEnvoys)
            cityStateViewModel.delegate = self
            tmpCityStateViewModels.append(cityStateViewModel)
        }

        self.cityStateViewModels = tmpCityStateViewModels
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
