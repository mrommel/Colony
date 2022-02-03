//
//  ReallyNeedReconSeaEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

/// "Really Need Recon Sea" Player Strategy: If we could theoretically start exploring other continents but we don't have any appropriate ship...
class ReallyNeedReconSeaEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            noMinorCivs: true,
            checkTriggerTurnCount: 1,
            minimumNumTurnsExecuted: 1,
            firstTurnExecuted: 50,
            flavors: [
                Flavor(type: .navalRecon, value: 500),
                Flavor(type: .naval, value: 100)
            ],
            flavorThresholdModifiers: [
            ]
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("Cant get gameModel")
        }

        guard let player = player else {
            fatalError("Cant get player")
        }

        guard let economicAI = player.economicAI else {
            fatalError("Cant get economicAI")
        }

        if economicAI.navalReconState() == .needed {

            if player.canEnterOcean() { // get a caravel out there NOW!

                // check current units - if we chave already an ocean recon unit - we dont need to hurry
                for unitRef in gameModel.units(of: player) {

                    guard let unit = unitRef else {
                        continue
                    }

                    if unit.task() == .escortSea && !unit.isImpassable(terrain: .ocean) {
                        return false
                    }
                }

                // check cities, if a ocean recon units is already training
                for cityRef in gameModel.cities(of: player) {

                    guard let city = cityRef else {
                        continue
                    }

                    if city.buildQueue.isCurrentlyTrainingUnit() {
                        for unitType in city.buildQueue.unitTypesTraining() {
                            if unitType.domain() == .sea && unitType.defaultTask() == .exploreSea {
                                if !unitType.abilities().contains(.oceanImpassable) {
                                    return false
                                }
                            }
                        }
                    }
                }

                return true

            } else if player.canEmbark() { // get a trireme out there NOW!

                // check current units - if we chave already an ocean recon unit - we dont need to hurry
                for unitRef in gameModel.units(of: player) {

                    guard let unit = unitRef else {
                        continue
                    }

                    if unit.task() == .escortSea {
                        return false
                    }
                }

                // check cities, if a ocean recon units is already training
                for cityRef in gameModel.cities(of: player) {

                    guard let city = cityRef else {
                        continue
                    }

                    if city.buildQueue.isCurrentlyTrainingUnit() {
                        for unitType in city.buildQueue.unitTypesTraining() {
                            if unitType.domain() == .sea && unitType.defaultTask() == .exploreSea {
                                return false
                            }
                        }
                    }
                }

                return true
            }
        }

        return false
    }
}
