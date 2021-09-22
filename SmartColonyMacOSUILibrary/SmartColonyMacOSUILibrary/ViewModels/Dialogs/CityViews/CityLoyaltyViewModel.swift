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

    @Published
    var loyaltyValue: CGFloat

    @Published
    var loyaltyState: String

    @Published
    var loyaltyEffect: String

    // data
    @Published
    var loyaltyPressure: String

    @Published
    var loyaltyFromGovernors: String

    @Published
    var loyaltyFromHappiness: String

    @Published
    var loyaltyFromTradeRoutes: String

    @Published
    var loyaltyFromOthersEffects: String

    @Published
    var loyaltyPerTurn: String

    // governor
    @Published
    var hasGovernor: Bool

    @Published
    var governorName: String

    @Published
    var governorSummary: String

    private var city: AbstractCity?

    init(city: AbstractCity? = nil) {

        self.loyaltyValue = 0
        self.loyaltyState = "Loyal"
        self.loyaltyEffect = "Effect1\nEffect2"

        self.loyaltyPressure = "0.0"
        self.loyaltyFromGovernors = "0.0"
        self.loyaltyFromHappiness = "0"
        self.loyaltyFromTradeRoutes = "0"
        self.loyaltyFromOthersEffects = "0"
        self.loyaltyPerTurn = "0.0"

        self.hasGovernor = true
        self.governorName = "Liang"
        self.governorSummary = "The Financier"

        if city != nil {
            self.update(for: city)
        }
    }

    func update(for city: AbstractCity?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        self.city = city

        // populate values
        if let city = city {

            self.loyaltyValue = CGFloat(city.loyalty())
            self.loyaltyState = city.loyaltyState().name()

            switch city.loyaltyState() {

            case .loyal:
                self.loyaltyEffect = "This city is loyal to you and there are no adverse effects."
            case .wavering:
                self.loyaltyEffect = "City growth is at 50%\nCity Yields are reduced -25%"
            case .disloyal:
                self.loyaltyEffect = "City growth is at 25%\nCity Yields are reduced -50%"
            case .unrest:
                self.loyaltyEffect = "City growth is at 0%\nCity Yields are reduced -100%"
            }

            self.loyaltyPressure = String(format: "%.1f", city.loyaltyPressureFromNearbyCitizen(in: gameModel))
            self.loyaltyFromGovernors = String(format: "%.1f", city.loyaltyFromGovernors(in: gameModel))
            self.loyaltyFromHappiness = String(format: "%.1f", city.loyaltyFromHappiness(in: gameModel))
            self.loyaltyFromTradeRoutes = String(format: "%.1f", city.loyaltyFromTradeRoutes(in: gameModel))
            self.loyaltyFromOthersEffects = String(format: "%.1f", city.loyaltyFromOthersEffects(in: gameModel))
            self.loyaltyPerTurn = String(format: "%.1f", city.loyalty())

            if let governor = city.governor() {
                self.hasGovernor = true
                self.governorName = governor.name()
                self.governorSummary = governor.title()
            } else {
                self.hasGovernor = false
                self.governorName = ""
                self.governorSummary = ""
            }
        }
    }
}
