//
//  CityLoyaltyViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.09.21.
//

import SwiftUI
import SmartAILibrary

class CityLoyaltyViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

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

            let governor = city.governor()
        }
    }
}
