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
}
