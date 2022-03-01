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

        var cityStates: [CityStateType] = []

        for player in gameModel.players {

            if player.isMinorCiv() {
                if diplomacyAI.hasMet(with: player) {
                    if case .cityState(type: let cityStateType) = player.leader {
                        cityStates.append(cityStateType)
                    }
                }
            }
        }

        var tmpCityStateViewModels: [CityStateViewModel] = []

        for cityState in cityStates {

            let cityStateViewModel = CityStateViewModel(cityState: cityState, quest: .none)
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

        print("todo: assignEnvoy to \(cityState)")
        return true
    }

    func unassignEnvoy(from cityState: CityStateType) -> Bool {

        print("todo: unassignEnvoy from \(cityState)")
        return true
    }

    func center(on cityState: CityStateType) {

        print("todo: center on \(cityState)")

        self.delegate?.closeDialog()
    }
}

extension CityStatesDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
