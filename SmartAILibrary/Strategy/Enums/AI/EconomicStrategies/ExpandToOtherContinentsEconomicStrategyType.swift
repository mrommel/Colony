//
//  ExpandToOtherContinentsEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable type_name
/// Are we running out of room on our current landmass?
class ExpandToOtherContinentsEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            noMinorCivs: true,
            minimumNumTurnsExecuted: 25,
            weightThreshold: 50,
            techPrereq: .celestialNavigation, // ???
            flavors: [
                Flavor(type: .naval, value: 15),
                Flavor(type: .navalRecon, value: 5),
                Flavor(type: .navalTileImprovement, value: 10),
                Flavor(type: .navalGrowth, value: 5),
                //Flavor(type: .waterConnection, value: 5)
                Flavor(type: .expansion, value: 50),
                Flavor(type: .recon, value: -10)
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

        guard let economicAI = player.economicAI else {
            fatalError()
        }

        guard let militaryAI = player.militaryAI else {
            fatalError()
        }

        if player.isHuman() {
            return false
        }

        // Never run this at the same time as island start
        /*if economicAI.adopted(economicStrategy: .islandStart) {
            return false
        }*/

        // we should settle our island first
        if economicAI.adopted(economicStrategy: .earlyExpansion) {
            return false
        }

        // Never desperate to settle distant lands if we are at war (unless we are doing okay at the war)
        if militaryAI.adopted(militaryStrategy: .losingWars) {
            return false
        }

        if let capital = player.capitalCity(in: gameModel) {

            guard let area = gameModel.area(of: capital.location) else {
                fatalError("cant get capital area")
            }

            // Do we have another area to settle (either first or second choice)?
            let minimumSettleFertility: Int = economicAI.minimumSettleFertility()
            let (_, bestAreaRef, secondBestAreaRef) = player.bestSettleAreasWith(minimumSettleFertility: minimumSettleFertility, in: gameModel)

            var hasAreaOutside: Bool = false
            if let bestArea = bestAreaRef {
                if area.identifier != bestArea.identifier {
                    hasAreaOutside = true
                }
            }

            if let secondBestArea = secondBestAreaRef {
                if area.identifier != secondBestArea.identifier {
                    hasAreaOutside = true
                }
            }

            return hasAreaOutside
        }

        return false
    }
}
