//
//  FoundCityEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

/// "Found City" Player Strategy: If there is a settler who isn't in an operation?  If so, find him a city site
/// Very dependent on the fact that the player probably won't have more than 2 settlers available at a time; needs an
///   upgrade if that assumption is no longer true
class FoundCityEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            noMinorCivs: true,
            checkTriggerTurnCount: 1,
            minimumNumTurnsExecuted: 1,
            weightThreshold: 10,
            advisor: .economic,
            advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_FOUND_CITY",
            advisorCounselImportance: 2,
            flavors: [
            ],
            flavorThresholdModifiers: [
            ]
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let economicAI = player.economicAI else {
            fatalError("cant get economicAI")
        }

        // Never run this strategy for a human player or barbarian
        if player.isHuman() || player.isBarbarian() {
            return false
        }

        var firstLooseSettler: AbstractUnit?
        var looseSettlers = 0

        for unitRef in gameModel.units(of: player) {

            if let unit = unitRef {
                if unit.has(task: .settle) {
                    if unit.army() == nil {

                        looseSettlers += 1
                        if looseSettlers == 1 {
                            firstLooseSettler = unitRef
                        }
                    }
                }
            }
        }

        let strategyWeight = looseSettlers * 10 // Just one settler will trigger this
        let weightThresholdModifier = self.weightThresholdModifier(for: player)
        let weightThreshold = self.weightThreshold + weightThresholdModifier

        // Don't run this strategy if have 0 cities, in that case we just want to drop down a city wherever we happen to be
        if strategyWeight >= weightThreshold && gameModel.cities(of: player).count >= 1 {

            let (numAreas, bestArea, _) = player.bestSettleAreasWith(minimumSettleFertility: economicAI.minimumSettleFertility(), in: gameModel)

            if numAreas == 0 {
                return false
            }

            guard let bestSettlePlot = player.bestSettlePlot(for: firstLooseSettler, in: gameModel, escorted: true, area: nil) else {
                return false
            }

            let area = bestSettlePlot.area

            let canEmbark = player.canEmbark()
            let isAtWarWithSomeone = player.atWarCount() > 0

            // CASE 1: Need a city on this area
            if bestArea == area {
                player.addOperation(of: .foundCity, towards: nil, target: nil, in: bestArea, muster: nil, in: gameModel)
                return true
            } else if canEmbark && self.isSafeForQuickColony(in: area, in: gameModel, for: player) {
                // CASE 2: Need a city on a safe distant area
                // Have an overseas we can get to safely
                player.addOperation(of: .colonize, towards: nil, target: nil, in: bestArea, muster: nil, in: gameModel)
                return true
            }

            // CASE 3: My embarked units can fight, I always do quick colonization overseas
            /*else if canEmbark && pPlayer->GetPlayerTraits()->IsEmbarkedNotCivilian() {
                player.addOperation(of: .notSoQuickColonize, towards: nil, target: nil, area: iArea)
                return true
            }*/
            else if canEmbark && !isAtWarWithSomeone {
                // CASE 3a: Need a city on a not so safe distant area
                // not at war with anyone
                player.addOperation(of: .notSoQuickColonize, towards: nil, target: nil, in: area, muster: nil, in: gameModel)
                return true

            } else if canEmbark {
                // CASE 4: Need a city on distant area
                player.addOperation(of: .colonize, towards: nil, target: nil, in: area, muster: nil, in: gameModel)
                return true
            }
        }

        return false
    }

    /// Do we have an island clear of hostile units to settle on?
    private func isSafeForQuickColony(in area: HexArea?, in gameModel: GameModel?, for player: AbstractPlayer?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if let boundingBox = area?.boundingBox {

            for x in boundingBox.minX..<boundingBox.maxX {
                for y in boundingBox.minY..<boundingBox.maxY {

                    if gameModel.isEnemyVisible(at: HexPoint(x: x, y: y), for: player) {
                        return false
                    }
                }
            }
        }

        return true
    }

    private func weightThresholdModifier(for player: AbstractPlayer) -> Int {

        var value = 0

        for flavor in FlavorType.all {

            value += player.valueOfPersonalityFlavor(of: flavor) * self.flavorThresholdModifier(for: flavor)
        }

        return value
    }

    func flavorThresholdModifier(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavorThresholdModifiers.first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return 0
    }
}
