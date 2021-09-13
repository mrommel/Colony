//
//  CityListDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.09.21.
//

import SwiftUI
import SmartAILibrary

class CityListDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    weak var delegate: GameViewModelDelegate?

    @Published
    var cityViewModels: [CityViewModel] = []

    init() {

    }

#if DEBUG
    init(with cities: [AbstractCity?]) {

        var tempCityViewModels: [CityViewModel] = []

        for cityRef in cities {

            guard let city = cityRef else {
                continue
            }

            let cityViewModel = CityViewModel(city: city)
            cityViewModel.delegate = self
            tempCityViewModels.append(cityViewModel)
        }

        self.cityViewModels = tempCityViewModels
    }
#endif

    func update(for player: AbstractPlayer) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        var tempCityViewModels: [CityViewModel] = []
        let cities = gameModel.cities(of: player)

        for cityRef in cities {

            guard let city = cityRef else {
                continue
            }

            let cityViewModel = CityViewModel(city: city)
            cityViewModel.delegate = self
            tempCityViewModels.append(cityViewModel)
        }

        self.cityViewModels = tempCityViewModels
    }
}

extension CityListDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}

extension CityListDialogViewModel: CityViewModelDelegate {

    func selected(city: AbstractCity?) {

        self.delegate?.closeDialog()
        self.delegate?.showCityDialog(for: city)
    }
}
