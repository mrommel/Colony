//
//  ExpandToOtherContinentsEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable type_name
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

        fatalError("implement")
    }
}
