//
//  CityReligionViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.05.21.
//

import SwiftUI
import SmartAILibrary

class CityReligionViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var pantheonViewModel: PantheonViewModel?

    @Published
    var citizenReligionViewModels: [CitizenReligionViewModel] = []

    private var city: AbstractCity?

    init(city: AbstractCity? = nil) {

        if city != nil {
            self.update(for: city)
        }
    }

    func update(for city: AbstractCity?) {

        self.city = city

        // populate values
        if let city = city {

            guard let game = self.gameEnvironment.game.value else {
                return
            }

            guard let humanPlayer = game.humanPlayer() else {
                fatalError("cant get human player")
            }

            guard humanPlayer.leader == city.player?.leader else {
                fatalError("human player not city owner")
            }

            guard let cityReligion = city.cityReligion else {
                fatalError("cant get city religion")
            }

            if let pantheonType = humanPlayer.religion?.pantheon() {
                if pantheonType != .none {
                    self.pantheonViewModel = PantheonViewModel(pantheonType: pantheonType)
                } else {
                    self.pantheonViewModel = nil
                }
            } else {
                self.pantheonViewModel = nil
            }

            if cityReligion.religiousMajority() != .atheism {

            }

            self.citizenReligionViewModels = cityReligion.citizens().keys.map { religionType in

                return CitizenReligionViewModel(
                    religionType: religionType,
                    amount: Int(cityReligion.citizens().weight(of: religionType))
                )
            }
        }
    }
}
