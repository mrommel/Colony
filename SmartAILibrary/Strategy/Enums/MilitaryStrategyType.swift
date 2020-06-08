//
//  MilitaryStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum MilitaryStrategyType: Int, Codable {

    case needRanged
    case enoughRanged
    case needMilitaryUnits
    case enoughMilitaryUnits
    case needNavalUnits
    case needNavalUnitsCritical
    case enoughNavalUnits

    case empireDefense
    case empireDefenseCritical
    case atWar
    case warMobilization
    case eradicateBarbarians

    case winningWars
    case losingWars

    static var all: [MilitaryStrategyType] {
        return [
                .needRanged, .enoughRanged,
                .needMilitaryUnits, .enoughMilitaryUnits,
                .needNavalUnits, .needNavalUnitsCritical, .enoughNavalUnits,
                .empireDefense, .empireDefenseCritical, .atWar, .warMobilization, .eradicateBarbarians,
                .winningWars, .losingWars
        ]
    }

    func required() -> TechType? {

        switch self {

        case .needRanged: return nil
        case .enoughRanged: return nil
        case .needMilitaryUnits: return nil
        case .enoughMilitaryUnits: return nil
        case .needNavalUnits: return nil
        case .needNavalUnitsCritical: return nil
        case .enoughNavalUnits: return nil

        case .empireDefense: return nil
        case .empireDefenseCritical: return nil
        case .atWar: return nil
        case .warMobilization: return nil
        case .eradicateBarbarians: return nil

        case .winningWars: return nil
        case .losingWars: return nil
        }
    }

    func obsolete() -> TechType? {

        switch self {

        case .needRanged: return nil
        case .enoughRanged: return nil
        case .needMilitaryUnits: return nil
        case .enoughMilitaryUnits: return nil
        case .needNavalUnits: return nil
        case .needNavalUnitsCritical: return nil
        case .enoughNavalUnits: return nil

        case .empireDefense: return nil
            case .empireDefenseCritical: return nil
        case .atWar: return nil
        case .warMobilization: return nil
        case .eradicateBarbarians: return nil

        case .winningWars: return nil
        case .losingWars: return nil
        }
    }

    func flavorModifiers() -> [Flavor] {

        switch self {

        case .needRanged: return [
                Flavor(type: .offense, value: -5),
                Flavor(type: .defense, value: -5),
                Flavor(type: .ranged, value: 20)
            ]
        case .enoughRanged: return [
                Flavor(type: .offense, value: 5),
                Flavor(type: .defense, value: 5),
                Flavor(type: .ranged, value: -20)
            ]
        case .needMilitaryUnits: return [
            ]
        case .enoughMilitaryUnits: return [
                Flavor(type: .offense, value: -50),
                Flavor(type: .defense, value: -50),
                Flavor(type: .ranged, value: -50)
            ]
        case .needNavalUnits: return [
            ]
        case .needNavalUnitsCritical: return [
            ]
        case .enoughNavalUnits: return [
                Flavor(type: .naval, value: -30)
            ]

        case .empireDefense: return [
            ]
        case .empireDefenseCritical: return [
            ]
        case .atWar: return [
                Flavor(type: .offense, value: 15),
                Flavor(type: .defense, value: 15),
                Flavor(type: .ranged, value: 15),
                Flavor(type: .cityDefense, value: 10),
                Flavor(type: .wonder, value: -10)
            ]
        case .warMobilization: return [
                Flavor(type: .offense, value: 10),
                Flavor(type: .defense, value: 10),
                Flavor(type: .ranged, value: 10),
                Flavor(type: .militaryTraining, value: 10)
            ]
        case .eradicateBarbarians: return [
                Flavor(type: .offense, value: 5)
            ]

        case .winningWars: return [
                Flavor(type: .offense, value: 5),
                Flavor(type: .defense, value: -5)
            ]
        case .losingWars: return [
                Flavor(type: .offense, value: -5),
                Flavor(type: .defense, value: 5),
                Flavor(type: .cityDefense, value: 25),
                Flavor(type: .expansion, value: -15),
                Flavor(type: .tileImprovement, value: -10),
                Flavor(type: .recon, value: -15),
                Flavor(type: .wonder, value: -15)
            ]
        }
    }

    func notBeforeTurnElapsed() -> Int {

        switch self {

        case .needRanged: return 25
        case .enoughRanged: return 25
        case .needMilitaryUnits: return 25
        case .enoughMilitaryUnits: return 25
        case .needNavalUnits: return 50
        case .needNavalUnitsCritical: return 50
        case .enoughNavalUnits: return 50

        case .empireDefense: return 25
        case .empireDefenseCritical: return 25
        case .atWar: return -1
        case .warMobilization: return -1
        case .eradicateBarbarians: return 25

        case .winningWars: return -1
        case .losingWars: return -1
        }
    }

    func checkEachTurns() -> Int {

        switch self {

        case .needRanged: return 2
        case .enoughRanged: return 2
        case .needMilitaryUnits: return 2
        case .enoughMilitaryUnits: return 2
        case .needNavalUnits: return 2
        case .needNavalUnitsCritical: return 2
        case .enoughNavalUnits: return 2

        case .empireDefense: return 2
        case .empireDefenseCritical: return 2
        case .atWar: return 1
        case .warMobilization: return 5
        case .eradicateBarbarians: return 5

        case .winningWars: return 2
        case .losingWars: return 2
        }
    }

    func minimumAdoptionTurns() -> Int {

        switch self {

        case .needRanged: return 2
        case .enoughRanged: return 2
        case .needMilitaryUnits: return 2
        case .enoughMilitaryUnits: return 2
        case .needNavalUnits: return 2
        case .needNavalUnitsCritical: return 2
        case .enoughNavalUnits: return 2

        case .empireDefense: return 2
        case .empireDefenseCritical: return 2
        case .atWar: return 5
        case .warMobilization: return 15
        case .eradicateBarbarians: return 5

        case .winningWars: return 2
        case .losingWars: return 2
        }
    }

    func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        switch self {

        case .needRanged: return self.shouldBeActiveNeedRanged(for: player, in: gameModel)
        case .enoughRanged: return self.shouldBeActiveEnoughRanged(for: player, in: gameModel)
        case .needMilitaryUnits: return self.shouldBeActiveNeedMilitaryUnits(for: player, in: gameModel)
        case .enoughMilitaryUnits: return self.shouldBeActiveEnoughMilitaryUnits(for: player, in: gameModel)
        case .needNavalUnits: return false // FIXME
        case .needNavalUnitsCritical: return false // FIXME
        case .enoughNavalUnits: return false // FIXME

        case .empireDefense: return self.shouldBeActiveEmpireDefense(for: player, in: gameModel)
        case .empireDefenseCritical: return self.shouldBeActiveEmpireDefenseCritical(for: player, in: gameModel)
        case .atWar: return self.shouldBeActiveAtWar(for: player, in: gameModel)
        case .warMobilization: return self.shouldBeActiveWarMobilization(for: player, in: gameModel)
        case .eradicateBarbarians: return self.shouldBeActiveEradicateBarbarians(for: player, in: gameModel)

        case .winningWars: return self.shouldBeActiveWinningWars(for: player)
        case .losingWars: return self.shouldBeActiveLosingWars(for: player)
        }
    }

    // "Need Ranged" Player Strategy: If a player has too many melee units
    private func shouldBeActiveNeedRanged(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let playerUnits = gameModel?.units(of: player) else {
            fatalError("cant get units")
        }

        let rangedFlavor = player.valueOfStrategyAndPersonalityFlavor(of: .ranged)
        let numRanged = playerUnits.count(where: { $0!.isOf(unitClass: .ranged) })
        let numMelee = playerUnits.count(where: { $0!.isOf(unitClass: .melee) })

        let ratio = numRanged * 10 / max(1, numRanged + numMelee)

        return ratio <= rangedFlavor / 2
    }

    // "Enough Ranged" Player Strategy: If a player has too many ranged units
    private func shouldBeActiveEnoughRanged(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let playerUnits = gameModel?.units(of: player) else {
            fatalError("cant get units")
        }

        let rangedFlavor = player.valueOfStrategyAndPersonalityFlavor(of: .ranged)
        let numRanged = playerUnits.count(where: { $0!.isOf(unitClass: .ranged) })
        let numMelee = playerUnits.count(where: { $0!.isOf(unitClass: .melee) })

        let ratio = numRanged * 10 / max(1, numMelee + numRanged)
        return ratio >= rangedFlavor
    }

    private func shouldBeActiveNeedMilitaryUnits(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        return false // FIXME
    }

    // "Enough Military Units" Player Strategy: Does this player have too many military units?  If so, adjust flavors
    private func shouldBeActiveEnoughMilitaryUnits(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let militaryAI = player.militaryAI else {
            fatalError("cant get militaryAI")
        }

        guard let economicAI = player.economicAI else {
            fatalError("cant get economicAI")
        }

        guard let grandStrategyAI = player.grandStrategyAI else {
            fatalError("cant get grandStrategyAI")
        }

        // If we're at war don't bother with this Strategy
        if militaryAI.militaryStrategyAdoption.adopted(militaryStrategy: .atWar) {

            return false
        }

        // Are we running at a deficit?
        let inDeficit = economicAI.adopted(economicStrategy: .losingMoney)

        // Are we running anything other than the Conquest Grand Strategy?
        if inDeficit || grandStrategyAI.activeStrategy != .conquest || militaryAI.percentOfRecommendedMilitarySize() > 125 {

            if militaryAI.landDefenseState() == .enough {
                return true
            }
        }

        return false
    }

    // "Empire Defense" Player Strategy: Adjusts military flavors if the player doesn't have the recommended number of units
    private func shouldBeActiveEmpireDefense(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let militaryAI = player.militaryAI else {
            fatalError("cant get militaryAI")
        }

        return militaryAI.landDefenseState() == .needed
    }
    
    // "Empire Defense" Player Strategy: If we have less than 1 unit per city (tweaked a bit by threat level), we NEED some units
    private func shouldBeActiveEmpireDefenseCritical(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {
        
        guard let player = player else {
            fatalError("cant get player")
        }

        guard let militaryAI = player.militaryAI else {
            fatalError("cant get militaryAI")
        }

        return militaryAI.landDefenseState() == .critical
    }

    // "At War" Player Strategy: If the player is at war, increase OFFENSE, DEFENSE and MILITARY_TRAINING.  Then look into which operation(s) to run
    private func shouldBeActiveAtWar(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let numberOfPlayersAtWarWith = player.militaryAI?.numberOfPlayersAtWarWith(in: gameModel) else {
            fatalError("cant get numberOfPlayersAtWarWith")
        }

        return numberOfPlayersAtWarWith > 0
    }

    // "War Mobilization" Player Strategy: Does this player want to mobilize for war?  If so, adjust flavors
    private func shouldBeActiveWarMobilization(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let militaryAI = player.militaryAI else {
            fatalError("cant get militaryAI")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get militaryAI")
        }

        guard let grandStrategyAI = player.grandStrategyAI else {
            fatalError("cant get grandStrategyAI")
        }

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        // If we're at war don't bother with this Strategy
        if militaryAI.militaryStrategyAdoption.adopted(militaryStrategy: .atWar) {

            return false
        }

        var iCurrentWeight = 0

        // Are we running the Conquest Grand Strategy?
        if grandStrategyAI.activeStrategy == .conquest {
            iCurrentWeight += 25
        }

        for otherPlayer in gameModel.players {

            if otherPlayer.leader != player.leader {

                if !player.hasMet(with: otherPlayer) {
                    continue
                }
                
                if diplomacyAI.warGoal(towards: otherPlayer) == .prepare {
                    iCurrentWeight += 100
                }

                let approach = player.diplomacyAI?.approach(towards: otherPlayer)

                // Add in weight for each civ we're on really bad terms with
                if approach == .war || approach == .hostile || approach == .afraid {
                    iCurrentWeight += 50
                }

                // And some if on fairly bad terms
                // Add in weight for each civ we're on really bad terms with
                if approach == .guarded || approach == .deceptive {
                    iCurrentWeight += 25
                }
            }
        }

        return iCurrentWeight >= 100
    }

    func shouldBeActiveEradicateBarbarians(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let militaryAI = player.militaryAI else {
            fatalError("cant get militaryAI")
        }
        
        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get militaryAI")
        }

        // If we're at war don't bother with this Strategy
        if militaryAI.militaryStrategyAdoption.adopted(militaryStrategy: .atWar) {

            return false
        }

        // Also don't bother, if we're building up for a sneak attack
        for loopPlayer in gameModel.players {

            if !player.isEqual(to: loopPlayer) && loopPlayer.isAlive() && player.hasMet(with: loopPlayer) {

                if diplomacyAI.warGoal(towards: loopPlayer) == .prepare {
                    return false
                }
            }
        }
        
        // If we have an operation of this type running, we don't want to turn this strategy off
        // FIXME
        /*if (pPlayer->haveAIOperationOfType(AI_OPERATION_DESTROY_BARBARIAN_CAMP)) {
            return true;
        }*/
        
        // Two visible camps or 4 Barbarians will trigger this
        let strategyWeight = militaryAI.barbarianData().barbarianCampCount * 50 + militaryAI.barbarianData().visibleBarbarianCount * 25
        
        if strategyWeight > 100 {
            return true
        }
        
        return false
    }
    
    func shouldBeActiveWinningWars(for player: AbstractPlayer?) -> Bool {
        
        guard let player = player else {
            fatalError("cant get player")
        }
        
        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get militaryAI")
        }
        
        return diplomacyAI.stateOfAllWars == .winning
    }
    
    func shouldBeActiveLosingWars(for player: AbstractPlayer?) -> Bool {
        
        guard let player = player else {
            fatalError("cant get player")
        }
        
        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get militaryAI")
        }
        
        return diplomacyAI.stateOfAllWars == .losing
    }

    func advisorMessage() -> AdvisorMessage? {

        switch self {

        case .needRanged: return nil
        case .enoughRanged: return nil
        case .needMilitaryUnits: return nil
        case .enoughMilitaryUnits: return AdvisorMessage(advisor: .military, message: "TXT_KEY_MILITARYAISTRATEGY_ENOUGH_MILITARY_UNITS")
        case .needNavalUnits: return nil
        case .needNavalUnitsCritical: return nil
        case .enoughNavalUnits: return nil

        case .empireDefense: return AdvisorMessage(advisor: .military, message: "TXT_KEY_MILITARYAISTRATEGY_EMPIRE_DEFENSE")
        case .empireDefenseCritical: return AdvisorMessage(advisor: .military, message: "TXT_KEY_MILITARYAISTRATEGY_EMPIRE_DEFENSE")
        case .atWar: return AdvisorMessage(advisor: .military, message: "TXT_KEY_MILITARYAISTRATEGY_AT_WAR")
        case .warMobilization: return nil
        case .eradicateBarbarians: return AdvisorMessage(advisor: .military, message: "TXT_KEY_MILITARYAISTRATEGY_ERADICATE_BARBARIANS")

        case .winningWars: return AdvisorMessage(advisor: .military, message: "TXT_KEY_MILITARYAISTRATEGY_WINNING_WARS")
        case .losingWars: return AdvisorMessage(advisor: .foreign, message: "TXT_KEY_MILITARYAISTRATEGY_LOSING_WARS")
        }
    }
}
