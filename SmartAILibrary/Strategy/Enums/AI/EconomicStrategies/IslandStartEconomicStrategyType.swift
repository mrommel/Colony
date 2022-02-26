//
//  IslandStartEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 04.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

// ECONOMICAISTRATEGY_ISLAND_START
/// Did we start the game on a small continent (50 tiles or less)?
class IslandStartEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            checkTriggerTurnCount: 1,
            minimumNumTurnsExecuted: 50,
            weightThreshold: 200,
            advisor: .science,
            advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_ISLAND_START",
            advisorCounselImportance: 50,
            flavors: [
                Flavor(type: .naval, value: 100),
                Flavor(type: .navalTileImprovement, value: 10),
                Flavor(type: .navalGrowth, value: 5),
                // Flavor(type: .waterConnection, value: 5),
                Flavor(type: .offense, value: -5),
                Flavor(type: .defense, value: -5),
                Flavor(type: .cityDefense, value: -5),
                Flavor(type: .recon, value: -20)
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

        var coastalTiles = 0
        var revealedCoastalTiles = 0

        let startLocation = gameModel.findStartPlot(of: player)

        // Only kick off this strategy in the first 25 turns of the game (though it will last 50 turns once selected)
        if gameModel.currentTurn < 25 {

            if !player.canEmbark() {

                guard let startArea = gameModel.area(of: startLocation) else {
                    fatalError("cant get start location")
                }

                let startAreatiles = startArea.points.count

                // Have we revealed a high enough percentage of the coast of our landmass?
                for loopPoint in gameModel.points() {

                    guard let loopPlot = gameModel.tile(at: loopPoint) else {
                        continue
                    }

                    if loopPlot.area?.identifier == startArea.identifier {

                        if gameModel.isCoastal(at: loopPoint) {
                            coastalTiles += 1
                        }

                        if loopPlot.isDiscovered(by: player) {
                            revealedCoastalTiles += 1
                        }
                    }
                }

                /* 80 = AI_STRATEGY_ISLAND_START_COAST_REVEAL_PERCENT */
                if (revealedCoastalTiles * 100 / (coastalTiles + 1)) > 80 && startAreatiles < self.weightThreshold {
                    return true
                }
            }
        }

        return false
    }
}
