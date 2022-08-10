//
//  OneOrFewerCoastalCitiesEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 04.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

// ECONOMICAISTRATEGY_ONE_OR_FEWER_COASTAL_CITIES
// "One or Fewer Coastal Cities" Player Strategy: If we don't have 2 coastal cities, this runs nullifying the WATER_CONNECTION Flavor
// swiftlint:disable type_name
class OneOrFewerCoastalCitiesEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            checkTriggerTurnCount: 1,
            minimumNumTurnsExecuted: 10,
            weightThreshold: 10,
            advisor: .none,
            flavors: [
                // Flavor(type: .waterConnection, value: -10),
            ],
            flavorThresholdModifiers: []
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError()
        }

        guard let player = player else {
            fatalError()
        }

        var numberOfCoastalCities = 0
        for cityRef in gameModel.cities(of: player) {

            guard let cityLocation = cityRef?.location else {
                continue
            }

            if gameModel.isCoastal(at: cityLocation) {
                numberOfCoastalCities += 1
            }
        }

        return numberOfCoastalCities <= 1
    }
}
