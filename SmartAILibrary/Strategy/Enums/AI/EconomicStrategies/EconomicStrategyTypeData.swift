//
//  EconomicStrategyTypeData.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

class EconomicStrategyTypeData {

    let dontUpdateCityFlavors: Bool
    let noMinorCivs: Bool
    let checkTriggerTurnCount: Int
    let minimumNumTurnsExecuted: Int
    let weightThreshold: Int
    let firstTurnExecuted: Int
    let techPrereq: TechType?
    let techObsolete: TechType?
    let advisor: AdvisorType
    let advisorCounsel: String?
    let advisorCounselImportance: Int
    let flavors: [Flavor]
    let flavorThresholdModifiers: [Flavor]

    init(dontUpdateCityFlavors: Bool = false,
         noMinorCivs: Bool = false,
         checkTriggerTurnCount: Int = 0,
         minimumNumTurnsExecuted: Int = 0,
         weightThreshold: Int = 0,
         firstTurnExecuted: Int = 0,
         techPrereq: TechType? = nil,
         techObsolete: TechType? = nil,
         advisor: AdvisorType = .none,
         advisorCounsel: String? = nil,
         advisorCounselImportance: Int = 1,
         flavors: [Flavor],
         flavorThresholdModifiers: [Flavor]) {

        self.dontUpdateCityFlavors = dontUpdateCityFlavors
        self.noMinorCivs = noMinorCivs
        self.checkTriggerTurnCount = checkTriggerTurnCount
        self.minimumNumTurnsExecuted = minimumNumTurnsExecuted
        self.weightThreshold = weightThreshold
        self.firstTurnExecuted = firstTurnExecuted
        self.techPrereq = techPrereq
        self.techObsolete = techObsolete
        self.advisor = advisor
        self.advisorCounsel = advisorCounsel
        self.advisorCounselImportance = advisorCounselImportance
        self.flavors = flavors
        self.flavorThresholdModifiers = flavorThresholdModifiers
    }

    func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        fatalError("implement")
    }

    // Figure out what the WeightThreshold Mod should be by looking at the Flavors for this player & the Strategy
    func weightThresholdModifier(for player: AbstractPlayer?) -> Int {

        guard let player = player else {
            fatalError("cant get player")
        }

       var weightThresholdModifier = 0

        // Look at all Flavors for the Player & this Strategy
        for flavorType in FlavorType.all {

            let personalityFlavor = player.valueOfPersonalityIndividualFlavor(of: flavorType)
            let strategyFlavorMod = Flavors(items: self.flavorThresholdModifiers).value(of: flavorType)

            weightThresholdModifier += (personalityFlavor * strategyFlavorMod)
        }

        return weightThresholdModifier
    }
}
