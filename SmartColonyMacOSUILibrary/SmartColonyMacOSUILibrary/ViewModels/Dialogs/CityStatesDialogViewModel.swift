//
//  CityStatesDialogViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 28.02.22.
//

import Foundation
import SwiftUI
import SmartAssets

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

        /* guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        } */

        var tmpCityStateViewModels: [CityStateViewModel] = []

        tmpCityStateViewModels.append(CityStateViewModel(cityState: .amsterdam))
        tmpCityStateViewModels.append(CityStateViewModel(cityState: .antioch))
        tmpCityStateViewModels.append(CityStateViewModel(cityState: .brussels))

        self.cityStateViewModels = tmpCityStateViewModels
    }

    func cityStateIcon() -> NSImage {

        return ImageCache.shared.image(for: "city-states")
    }
}

extension CityStatesDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
