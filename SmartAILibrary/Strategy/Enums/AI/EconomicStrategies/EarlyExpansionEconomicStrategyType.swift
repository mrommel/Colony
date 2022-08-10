//
//  EarlyExpansionEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

/// "Early Expansion" Player Strategy: An early Strategy simply designed to get player up to 3 Cities quickly.
class EarlyExpansionEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            noMinorCivs: true,
            checkTriggerTurnCount: 5,
            minimumNumTurnsExecuted: 10,
            weightThreshold: 3,
            advisor: .economic,
            advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_EARLY_EXPANSION",
            advisorCounselImportance: 2,
            flavors: [
                Flavor(type: .navalGrowth, value: -5),
                Flavor(type: .expansion, value: 75),
                Flavor(type: .production, value: -4),
                Flavor(type: .gold, value: -4),
                Flavor(type: .science, value: -4),
                Flavor(type: .culture, value: -4)
            ],
            flavorThresholdModifiers: [
            ]
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let economicAI = player.economicAI else {
            fatalError("cant get economicAI")
        }

        let flavorExpansion = player.valueOfStrategyAndPersonalityFlavor(of: .expansion)
        let flavorGrowth = player.valueOfStrategyAndPersonalityFlavor(of: .growth)
        let maxCultureCities = 6 // AI_GS_CULTURE_MAX_CITIES

        var desiredCities = (3 * flavorExpansion) / max(flavorGrowth, 1)
        let difficulty = max(0, gameModel.handicap.rawValue - 3)
        desiredCities += difficulty

        if player.grandStrategyAI?.activeStrategy == .culture {
            desiredCities = min(desiredCities, maxCultureCities)
        }

        desiredCities = max(desiredCities, maxCultureCities)

        // scale this based on world size
        let standardMapSize: MapSize = .standard
        desiredCities = desiredCities * gameModel.mapSize().numberOfTiles() / standardMapSize.numberOfTiles()

        // See how many unowned Tiles there are on this player's landmass
        if let capital = gameModel.capital(of: player) {

            // Make sure city specialization has gotten one chance to specialize the capital before we adopt this
            if gameModel.currentTurn > 25 { // AI_CITY_SPECIALIZATION_EARLIEST_TURN

                if let capitalArea = gameModel.area(of: capital.location) {

                    // Is this area still the best to settle?
                    let (_, bestArea, _) = player.bestSettleAreasWith(minimumSettleFertility: economicAI.minimumSettleFertility(), in: gameModel)

                    if bestArea == capitalArea {

                        let tilesInCapitalArea = gameModel.tiles(in: capitalArea)
                        let numberOfOwnedTiles = tilesInCapitalArea.filter({ $0?.hasOwner() ?? false }).count
                        let numberOfUnownedTiles = tilesInCapitalArea.filter({ !($0?.hasOwner() ?? true) }).count
                        let numberOfTiles = max(1, numberOfOwnedTiles + numberOfUnownedTiles)
                        let ownageRatio = numberOfOwnedTiles * 100 / numberOfTiles
                        let numberOfCities = gameModel.cities(of: player).count

                        let numberOfSettlersOnMap = gameModel.units(of: player).count(where: { $0!.task() == .settle })

                        if ownageRatio < 75 /* AI_STRATEGY_AREA_IS_FULL_PERCENT */
                            && (numberOfCities + numberOfSettlersOnMap) < desiredCities
                            && numberOfUnownedTiles >= 25 /* AI_STRATEGY_EARLY_EXPANSION_NUM_UNOWNED_TILES_REQUIRED */ {

                            return true
                        }
                    }
                }
            }
        }

        return false
    }
}
