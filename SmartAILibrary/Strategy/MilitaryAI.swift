//
//  MilitaryAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum CityAttackApproachType {
    
    case none // ATTACK_APPROACH_NONE
    
    case unrestricted // ATTACK_APPROACH_UNRESTRICTED
    case open // ATTACK_APPROACH_OPEN
    case neutral // ATTACK_APPROACH_NEUTRAL
    case limited // ATTACK_APPROACH_LIMITED
    case restricted // ATTACK_APPROACH_RESTRICTED
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  STRUCT:     CvMilitaryTarget
//!  \brief        A possible operation target (and muster city) for evaluation
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class MilitaryTarget: Codable, Equatable {

    var targetCity: AbstractCity?
    var musterCity: AbstractCity?
    var targetNearbyUnitPower: Int
    var musterNearbyUnitPower: Int
    var pathLength: Int
    var attackBySea: Bool
    
    init() {
        
        self.targetCity = nil
        self.musterCity = nil
        self.attackBySea = false
        self.musterNearbyUnitPower = 0
        self.targetNearbyUnitPower = 0
        self.pathLength = 0
    }
    
    required init(from decoder: Decoder) throws {
        
        self.targetCity = nil
        self.musterCity = nil
        self.attackBySea = false
        self.musterNearbyUnitPower = 0
        self.targetNearbyUnitPower = 0
        self.pathLength = 0
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    static func == (lhs: MilitaryTarget, rhs: MilitaryTarget) -> Bool {
        
        guard let lhsTargetCity = lhs.targetCity else {
            return false
        }
        
        guard let lhsMusterCity = lhs.musterCity else {
            return false
        }
        
        guard let rhsTargetCity = rhs.targetCity else {
            return false
        }
        
        guard let rhsMusterCity = rhs.musterCity else {
            return false
        }
        
        return lhsTargetCity.location == rhsTargetCity.location && lhsMusterCity.location == rhsMusterCity.location
    }
}

public class MilitaryAI: Codable {

    enum CodingKeys: String, CodingKey {
        
        case militaryStrategyAdoption
        case flavors
        
        case baseData
        case barbarianData
        case landDefenseState
        case navalDefenseState
        case totalThreatWeight
    }
    
    var player: Player?
    let militaryStrategyAdoption: MilitaryStrategyAdoption
    var flavors: Flavors

    private var baseData: MilitaryBaseData
    private var barbarianDataVal: BarbarianData
    private var totalThreatWeight: Int = 0
    private var landDefenseStateVal: DefenseStateType
    private var navalDefenseStateVal: DefenseStateType

    // MARK: internal classes

    // Data recomputed each turn (no need to serialize)
    class MilitaryBaseData: Codable {

        var numLandUnits: Int = 0
        var numRangedLandUnits: Int = 0
        var numMobileLandUnits: Int = 0
        //var numAirUnits: Int = 0
        //var numAntiAirUnits: Int = 0
        var numMeleeLandUnits: Int = 0
        var numNavalUnits: Int = 0
        var numLandUnitsInArmies: Int = 0
        var numNavalUnitsInArmies: Int = 0
        var recommendedMilitarySize: Int = 0
        var mandatoryReserveSize: Int = 0

        init() {

        }

        func reset() {

            self.numLandUnits = 0
            self.numRangedLandUnits = 0
            self.numMobileLandUnits = 0
            // self.numAirUnits = 0
            // self.numAntiAirUnits = 0
            self.numMeleeLandUnits = 0
            self.numNavalUnits = 0
            self.numLandUnitsInArmies = 0
            self.numNavalUnitsInArmies = 0
            self.recommendedMilitarySize = 0
            self.mandatoryReserveSize = 0
        }
    }

    class BarbarianData: Codable {

        var barbarianCampCount = 0
        var visibleBarbarianCount = 0

        init() {

        }

        func reset() {

            self.barbarianCampCount = 0
            self.visibleBarbarianCount = 0
        }
    }

    class MilitaryStrategyAdoptionItem: Codable {

        enum CodingKeys: String, CodingKey {
            
            case militaryStrategy
            case adopted
            case turnOfAdoption
        }
        
        let militaryStrategy: MilitaryStrategyType
        var adopted: Bool
        var turnOfAdoption: Int

        init(militaryStrategy: MilitaryStrategyType, adopted: Bool, turnOfAdoption: Int) {

            self.militaryStrategy = militaryStrategy
            self.adopted = adopted
            self.turnOfAdoption = turnOfAdoption
        }
        
        required init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.militaryStrategy = try container.decode(MilitaryStrategyType.self, forKey: .militaryStrategy)
            self.adopted = try container.decode(Bool.self, forKey: .adopted)
            self.turnOfAdoption = try container.decode(Int.self, forKey: .turnOfAdoption)
        }
        
        func encode(to encoder: Encoder) throws {
        
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.militaryStrategy, forKey: .militaryStrategy)
            try container.encode(self.adopted, forKey: .adopted)
            try container.encode(self.turnOfAdoption, forKey: .turnOfAdoption)
        }
    }

    class MilitaryStrategyAdoption: Codable {

        var adoptions: [MilitaryStrategyAdoptionItem]

        init() {

            self.adoptions = []

            for militaryStrategyType in MilitaryStrategyType.all {

                adoptions.append(MilitaryStrategyAdoptionItem(militaryStrategy: militaryStrategyType, adopted: false, turnOfAdoption: -1))
            }
        }

        func adopted(militaryStrategy: MilitaryStrategyType) -> Bool {

            if let item = self.adoptions.first(where: { $0.militaryStrategy == militaryStrategy }) {

                return item.adopted
            }

            return false
        }

        func turnOfAdoption(of militaryStrategy: MilitaryStrategyType) -> Int {

            if let item = self.adoptions.first(where: { $0.militaryStrategy == militaryStrategy }) {

                return item.turnOfAdoption
            }

            fatalError("cant get turn of adoption - not set")
        }

        func adopt(militaryStrategy: MilitaryStrategyType, turnOfAdoption: Int) {

            if let item = self.adoptions.first(where: { $0.militaryStrategy == militaryStrategy }) {

                item.adopted = true
                item.turnOfAdoption = turnOfAdoption
            }
        }

        func abandon(militaryStrategy: MilitaryStrategyType) {

            if let item = self.adoptions.first(where: { $0.militaryStrategy == militaryStrategy }) {

                item.adopted = false
                item.turnOfAdoption = -1
            }
        }
    }

    // MARK: constructors

    init(player: Player?) {

        self.player = player
        self.militaryStrategyAdoption = MilitaryStrategyAdoption()
        self.flavors = Flavors()

        self.baseData = MilitaryBaseData()
        self.barbarianDataVal = BarbarianData()
        self.landDefenseStateVal = .none
        self.navalDefenseStateVal = .none
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.player = nil
        
        self.militaryStrategyAdoption = try container.decode(MilitaryStrategyAdoption.self, forKey: .militaryStrategyAdoption)
        self.flavors = try container.decode(Flavors.self, forKey: .flavors)
        
        self.baseData = try container.decode(MilitaryBaseData.self, forKey: .baseData)
        self.barbarianDataVal = try container.decode(BarbarianData.self, forKey: .barbarianData)
        self.landDefenseStateVal = try container.decode(DefenseStateType.self, forKey: .landDefenseState)
        self.navalDefenseStateVal = try container.decode(DefenseStateType.self, forKey: .navalDefenseState)
        self.totalThreatWeight = try container.decode(Int.self, forKey: .totalThreatWeight)
    }

    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.militaryStrategyAdoption, forKey: .militaryStrategyAdoption)
        try container.encode(self.flavors, forKey: .flavors)
        
        try container.encode(self.baseData, forKey: .baseData)
        try container.encode(self.barbarianDataVal, forKey: .barbarianData)
        try container.encode(self.landDefenseStateVal, forKey: .landDefenseState)
        try container.encode(self.navalDefenseStateVal, forKey: .navalDefenseState)
        try container.encode(self.totalThreatWeight, forKey: .totalThreatWeight)
    }
    
    func updateMilitaryStrategies(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        for militaryStrategyType in MilitaryStrategyType.all {

            // Minor Civs can't run some Strategies
            // FIXME

            // check tech
            let requiredTech = militaryStrategyType.required()
            let isTechGiven = requiredTech == nil ? true : player.has(tech: requiredTech!)
            let obsoleteTech = militaryStrategyType.obsolete()
            let isTechObsolete = obsoleteTech == nil ? false : player.has(tech: obsoleteTech!)

            // Do we already have this EconomicStrategy adopted?
            var shouldCityStrategyStart = true
            if self.militaryStrategyAdoption.adopted(militaryStrategy: militaryStrategyType) {

                shouldCityStrategyStart = false

            } else if !isTechGiven {

                shouldCityStrategyStart = false

            } else if gameModel.currentTurn < militaryStrategyType.notBeforeTurnElapsed() { // Not time to check this yet?

                shouldCityStrategyStart = false
            }

            var shouldCityStrategyEnd = false
            if self.militaryStrategyAdoption.adopted(militaryStrategy: militaryStrategyType) {

                if militaryStrategyType.checkEachTurns() > 0 {

                    // Is it a turn where we want to check to see if this Strategy is maintained?
                    if gameModel.currentTurn - self.militaryStrategyAdoption.turnOfAdoption(of: militaryStrategyType) % militaryStrategyType.checkEachTurns() == 0 {
                        shouldCityStrategyEnd = true
                    }
                }

                if shouldCityStrategyEnd && militaryStrategyType.minimumAdoptionTurns() > 0 {

                    // Has the minimum # of turns passed for this Strategy?
                    if gameModel.currentTurn < self.militaryStrategyAdoption.turnOfAdoption(of: militaryStrategyType) + militaryStrategyType.minimumAdoptionTurns() {
                        shouldCityStrategyEnd = false
                    }
                }
            }

            // Check EconomicStrategy Triggers
            // Functionality and existence of specific CityStrategies is hardcoded here, but data is stored in XML so it's easier to modify
            if shouldCityStrategyStart || shouldCityStrategyEnd {

                // Has the Tech which obsoletes this Strategy? If so, Strategy should be deactivated regardless of other factors
                var strategyShouldBeActive = false

                // Strategy isn't obsolete, so test triggers as normal
                if !isTechObsolete {
                    strategyShouldBeActive = militaryStrategyType.shouldBeActive(for: self.player, in: gameModel)
                }

                // This variable keeps track of whether or not we should be doing something (i.e. Strategy is active now but should be turned off, OR Strategy is inactive and should be enabled)
                var bAdoptOrEndStrategy = false

                // Strategy should be on, and if it's not, turn it on
                if strategyShouldBeActive {
                    if shouldCityStrategyStart {

                        bAdoptOrEndStrategy = true
                    } else if shouldCityStrategyEnd {

                        bAdoptOrEndStrategy = false
                    }
                } else {
                    // Strategy should be off, and if it's not, turn it off
                    if shouldCityStrategyStart {

                        bAdoptOrEndStrategy = false
                    } else if shouldCityStrategyEnd {

                        bAdoptOrEndStrategy = true
                    }
                }

                if bAdoptOrEndStrategy {

                    if shouldCityStrategyStart {

                        self.militaryStrategyAdoption.adopt(militaryStrategy: militaryStrategyType, turnOfAdoption: gameModel.currentTurn)
                    } else if shouldCityStrategyEnd {

                        self.militaryStrategyAdoption.abandon(militaryStrategy: militaryStrategyType)
                    }
                }
            }
        }

        self.updateFlavors()

        //print("military strategy flavors")
        //print(self.flavors)
    }

    func turn(in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("no player given")
        }

        self.updateBaseData(in: gameModel)
        self.updateBarbarianData(in: gameModel)
        self.updateDefenseState(in: gameModel)
        self.updateMilitaryStrategies(in: gameModel)
        self.updateThreats(in: gameModel)

        if !player.isHuman() {

            self.updateOperations(in: gameModel)
            //self.makeEmergencyPurchases()
            //self.requestImprovements()
            //self.disbandObsoleteUnits()
        }
    }

    func updateThreats(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("no diplomacyAI given")
        }

        self.totalThreatWeight = 0

        for otherPlayer in gameModel.players {

            // Is this a player we have relations with?
            if player.leader != otherPlayer.leader && player.hasMet(with: otherPlayer) {

                let threat = diplomacyAI.militaryThreat(of: otherPlayer)
                self.totalThreatWeight += threat.weight()
            }
        }
    }

    func barbarianThreatTotal() -> Int {

        return 20 // FIXME
    }
    
    /// Get a pointer to the sneak attack operation against a target
    func sneakAttackOperation(against enemy: AbstractPlayer?) -> Operation? {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if let sneakCityAttackOperation = player.operationsOf(type: .sneakCityAttack).first {
            return sneakCityAttackOperation
        }
        
        if let navalSneakAttackOperation = player.operationsOf(type: .navalSneakAttack).first {
            return navalSneakAttackOperation
        }
        
        return nil
    }

    /// Get a pointer to the show of force operation against a target
    func showOfForceOperation(against enemy: AbstractPlayer?) -> Operation? {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if let sneakCityAttackOperation = player.operationsOf(type: .smallCityAttack).first {
            return sneakCityAttackOperation
        }
        
        return nil
    }

    /// Get a pointer to the basic attack against a target
    func basicAttackOperation(against enemy: AbstractPlayer?) -> Operation? {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if let basicCityAttackOperation = player.operationsOf(type: .basicCityAttack).first {
            return basicCityAttackOperation
        }
        
        if let navalAttackOperation = player.operationsOf(type: .navalAttack).first {
            return navalAttackOperation
        }
        
        return nil
    }
    
    /// Get a pointer to the pure naval operation against a target
    func pureNavalAttackOperation(against enemy: AbstractPlayer?) -> Operation? {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if let basicCityAttackOperation = player.operationsOf(type: .pureNavalCityAttack).first {
            return basicCityAttackOperation
        }
        
        return nil
    }

    func updateOperations(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("no diplomacyAI given")
        }

        // SEE IF THERE ARE OPERATIONS THAT NEED TO BE ABORTED

        // Are we willing to risk pressing forward vs. barbarians?
        let willingToAcceptRisk = (self.totalThreatWeight / 2) < self.barbarianThreatTotal()
        /*if player.leader.ability() == .convertLandBarbarians {
            willingToAcceptRisk = true
        }*/

        //
        // Operations vs. Barbarians
        //
        // If have aborted the eradicate barbarian strategy or if the threat level from civs is significantly higher than from barbs, we better abort all of them
        if self.adopted(militaryStrategy: .eradicateBarbarians) || self.adopted(militaryStrategy: .atWar) || !willingToAcceptRisk {

            for operation in player.operationsOf(type: .destroyBarbarianCamp) {
                operation.kill(with: .warStateChange)
            }
        }

        //
        // Operation vs. Other Civs
        //
        // Are our wars over?
        if !self.adopted(militaryStrategy: .atWar) {

            for operation in player.operationsOf(type: .basicCityAttack) {
                operation.kill(with: .warStateChange)
            }

            for operation in player.operationsOf(type: .pillageEnemy) {
                operation.kill(with: .warStateChange)
            }

            for operation in player.operationsOf(type: .rapidResponse) {
                operation.kill(with: .warStateChange)
            }

            for operation in player.operationsOf(type: .cityCloseDefense) {
                operation.kill(with: .warStateChange)
            }

            for operation in player.operationsOf(type: .navalAttack) {
                operation.kill(with: .warStateChange)
            }
        } else {

            // Are any of our strategies inappropriate given the type of war we are fighting
            for otherPlayer in gameModel.players {

                // Is this a player we have relations with?
                if player.leader != otherPlayer.leader && player.hasMet(with: otherPlayer) {

                    // If we've made peace with this player, abort all operations related to him
                    // added the check for STATE_ALL_WARS_LOSING so that if the player is losing all wars, that they will cancel scheduled attacks
                    if player.isForcePeace(with: otherPlayer) || diplomacyAI.stateOfAllWars == .losing {

                        if let operation = self.sneakAttackOperation(against: otherPlayer) {
                            operation.kill(with: .warStateChange)
                        }
                        
                        if let operation = self.basicAttackOperation(against: otherPlayer) {
                            operation.kill(with: .warStateChange)
                        }
                        
                        if let operation = self.showOfForceOperation(against: otherPlayer) {
                            operation.kill(with: .warStateChange)
                        }
                        
                        if let operation = self.pureNavalAttackOperation(against: otherPlayer) {
                            operation.kill(with: .warStateChange)
                        }
                    }

                    let warState = diplomacyAI.warState(towards: otherPlayer)
                    switch warState {

                    case .nearlyDefeated: // If nearly defeated, call off all operations in enemy territory
                        for operation in player.operationsOf(type: .basicCityAttack) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.kill(with: .warStateChange)
                            }
                        }

                        for operation in player.operationsOf(type: .pillageEnemy) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.kill(with: .warStateChange)
                            }
                        }

                        for operation in player.operationsOf(type: .navalAttack) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.kill(with: .warStateChange)
                            }
                        }
                    case .defensive: // If we are losing, make sure attacks are not running
                        for operation in player.operationsOf(type: .basicCityAttack) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.kill(with: .warStateChange)
                            }
                        }

                        for operation in player.operationsOf(type: .pillageEnemy) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.kill(with: .warStateChange)
                            }
                        }

                        for operation in player.operationsOf(type: .navalAttack) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.kill(with: .warStateChange)
                            }
                        }

                    case .offensive, .nearlyWon: // If we are dominant, shouldn't be running a defensive strategy
                        for operation in player.operationsOf(type: .rapidResponse) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.kill(with: .warStateChange)
                            }
                        }

                        for operation in player.operationsOf(type: .cityCloseDefense) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.kill(with: .warStateChange)
                            }
                        }

                    case .stalemate, .calm, .none:
                        // NOOP
                        break
                    }
                }
            }
            
            // Are there city defense operations for cities that no longer need defending?
            for cityRef in gameModel.cities(of: player) {
                
                if let city = cityRef {
                    
                    if city.threatValue() == 0 {
                        
                        for operation in player.operationsOf(type: .cityCloseDefense) {
                            
                            if operation.targetPosition == city.location {
                                operation.kill(with: .warStateChange)
                            }
                        }
                    }
                }
            }
            
            // Are we running a rapid response tactic and the overall threat level is very low?
            if totalThreatWeight <= 3 {
                
                for operation in player.operationsOf(type: .rapidResponse) {
                    operation.kill(with: .warStateChange)
                }
            }
        }
        
        // SEE WHAT OPERATIONS WE SHOULD ADD
        //
        // Operation vs. Barbarians
        //
        // If running the eradicate barbarian strategy, the threat is low (no higher than 1 major threat), we're not at war, /*and we have enough units*/, then launch a new operation.
        // Which one is based on whether or not we saw any barbarian camps
        if self.adopted(militaryStrategy: .eradicateBarbarians) && !self.adopted(militaryStrategy: .atWar) && !self.adopted(militaryStrategy: .empireDefenseCritical) && player.operationsOf(type: .destroyBarbarianCamp).count == 0 && willingToAcceptRisk {
            
            // We should have AI build for this
            player.addOperation(of: .destroyBarbarianCamp, towards: gameModel.barbarianPlayer(), target: nil, in: nil, in: gameModel)
        }
        
        //
        // Operation vs. Other Civs
        //
        // If at war, consider launching an operation
        if self.adopted(militaryStrategy: .atWar) {
            
            for otherPlayer in gameModel.players {

                // Is this a player we have relations with?
                if player.leader != otherPlayer.leader && player.hasMet(with: otherPlayer) {
                
                    let warState = diplomacyAI.warState(towards: otherPlayer)
                    
                    // always consider nuking them
                    // FIXME
                    
                    switch warState {
                    
                    case .none:
                        // NOOP
                        break
                        
                    case .nearlyDefeated, .defensive:
                        // NOOP
                        /*if let threatenedCity = self.mostThreatenedCity(in: gameModel) {
                            
                        }*/
                        break
                        
                    case .stalemate: // If roughly equal in number, let's try to annoy him with raids

                        let units = gameModel.units(of: player)
                        let (numRequiredSlots, _, filledSlots) = UnitFormationHelper.numberOfFillableSlots(of: units, for: .fastPillagers)
                        
                        // Not willing to build units to get this off the ground
                        if filledSlots >= numRequiredSlots /* && landReservesUsed <= self.andReservesAvailable() */ {
                            self.requestPillageEnemy(towards: otherPlayer, in: gameModel)
                        }
                        
                    case .calm:
                        var requestAttack = false
                        let militaryStrength = diplomacyAI.militaryStrength(of: otherPlayer)
                        let targetValue = diplomacyAI.targetValue(of: otherPlayer)
                        
                        if militaryStrength <= .average && targetValue > .impossible {
                            requestAttack = true
                        }
                        
                        if requestAttack {
                            self.requestBasicAttack(towards: otherPlayer, in: gameModel)
                        } else {
                            let units = gameModel.units(of: player)
                            let (numRequiredSlots, _, filledSlots) = UnitFormationHelper.numberOfFillableSlots(of: units, for: .fastPillagers)
                            
                            // Not willing to build units to get this off the ground
                            if filledSlots >= numRequiredSlots /* && landReservesUsed <= self.andReservesAvailable() */ {
                                self.requestPillageEnemy(towards: otherPlayer, in: gameModel)
                            }   
                        }
                        
                    case .offensive, .nearlyWon: // If we are dominant, time to take down one of his cities
                        self.requestBasicAttack(towards: otherPlayer, in: gameModel)
                    }
                }
            }
        }
        
        //
        // Naval operations (vs. opportunity targets)
        //
        let units = gameModel.units(of: player)
        let (numRequiredSlots, _, filledSlots) = UnitFormationHelper.numberOfFillableSlots(of: units, for: .navalSquadron)
        
        // Not willing to build units to get this off the ground
        if filledSlots >= numRequiredSlots  {
            
            // Total number of these operations can't exceed (FLAVOR_NAVAL / 2)
            let flavorNaval = player.valueOfPersonalityFlavor(of: .naval)
            let numSuperiority = player.numberOfOperationsOf(type: .navalSuperiority)
            let numBombard = player.numberOfOperationsOf(type: .navalBombard)
            
            if (numSuperiority + numBombard) <= (flavorNaval / 2) {
                
                if player.hasOperationsOf(type: .colonize) {
                    // If I have a colonization operation underway, start up naval superiority as extra escorts
                    player.addOperation(of: .navalSuperiority, towards: nil, target: nil, in: nil, in: gameModel)
                } else if self.adopted(militaryStrategy: .eradicateBarbarians) {
                    // If fighting off barbarians, start naval bombardment
                    player.addOperation(of: .navalBombard, towards: nil, target: nil, in: nil, in: gameModel)
                } else if numSuperiority > numBombard {
                    // Otherwise choose based on which operation we have more of
                    player.addOperation(of: .navalBombard, towards: nil, target: nil, in: nil, in: gameModel)
                } else {
                    player.addOperation(of: .navalSuperiority, towards: nil, target: nil, in: nil, in: gameModel)
                }
            }
        }
    }
    
    /// Send an army to take a city
    @discardableResult func requestBasicAttack(towards otherPlayer: AbstractPlayer?, numUnitsWillingBuild: Int = 1, in gameModel: GameModel?) -> Bool {
        
        var winningScore: Int = 0
        let target: MilitaryTarget = self.findBestAttackTarget(for: .basicCityAttack, against: otherPlayer, winningScore: &winningScore, in: gameModel)
        return self.requestSpecificAttack(against: target, numUnitsWillingToBuild: numUnitsWillingBuild, in: gameModel)
    }
    
    func requestSpecificAttack(against target: MilitaryTarget, numUnitsWillingToBuild: Int, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }
        
        guard let player = self.player else {
            fatalError("no player given")
        }

        var operationRef: Operation? = nil
        var numRequiredSlots = 0
        var landReservesUsed = 0
        var filledSlots = 0

        if target.targetCity != nil {
            
            if target.attackBySea {
                filledSlots = MilitaryAIHelpers.numberOfFillableSlots(for: self.player, formation: .navalInvasion, requiresNavalMoves: true, numberSlotsRequired: &numRequiredSlots, numberLandReservesUsed: &landReservesUsed, in: gameModel)
                if (numRequiredSlots - filledSlots) <= numUnitsWillingToBuild && landReservesUsed <= self.landReservesAvailable() {
                    operationRef = player.addOperation(of: .navalAttack, towards: target.targetCity!.player, target: target.musterCity, in: gameModel.area(of: target.targetCity!.location), in: gameModel)
                }
            } else {
                let formation: UnitFormationType = gameModel.handicap > HandicapType.prince ? .biggerCityAttackForce : .basicCityAttackForce
                filledSlots = MilitaryAIHelpers.numberOfFillableSlots(for: self.player, formation: formation, requiresNavalMoves: false, numberSlotsRequired: &numRequiredSlots, numberLandReservesUsed: &landReservesUsed, in: gameModel)
                
                if (numRequiredSlots - filledSlots) <= numUnitsWillingToBuild && landReservesUsed <= self.landReservesAvailable() {
                    
                    operationRef = player.addOperation(of: .basicCityAttack, towards: target.targetCity!.player, target: target.targetCity, in: gameModel.area(of: target.targetCity!.location), muster: target.musterCity, in: gameModel)
                    
                    if let operation = operationRef {
                        
                        if !operation.shouldAbort(in: gameModel) && target.targetCity!.isCoastal(in: gameModel) {
                        
                            let flavorNaval = player.valueOfStrategyAndPersonalityFlavor(of: .naval)
                            let numSuperiority = player.numberOfOperationsOf(type: .navalSuperiority)
                            let numBombard = player.numberOfOperationsOf(type: .navalBombard)
                            let maxOperations = flavorNaval / 2
                            // major naval map => maxOperations *= 2
                            
                            if numSuperiority + numBombard <= maxOperations {
                                player.addOperation(of: .navalSuperiority, towards: nil, target: nil, in: nil, in: gameModel)
                            }
                        }
                    }
                }
            }

            if let operation = operationRef {
                if !operation.shouldAbort(in: gameModel) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func landReservesAvailable() -> Int {
        
        // error: result negativ
        return self.baseData.numLandUnits - self.baseData.numLandUnitsInArmies - self.baseData.mandatoryReserveSize
    }
    
    /// Best target by land OR sea
    func findBestAttackTarget(for operationType: UnitOperationType, against enemy: AbstractPlayer?, winningScore: inout Int, in gameModel: GameModel?) -> MilitaryTarget {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let enemy = enemy else {
            fatalError("cant get enemy")
        }
        
        var chosenTarget = MilitaryTarget()
        var weightedTargetList: WeightedList<MilitaryTarget> = WeightedList<MilitaryTarget>()

        // Estimate the relative strength of units near our cities and near their cities (can't use TacticalAnalysisMap because we may not be at war - and that it isn't current if we are calling this from the DiploAI)
        for friendlyCityRef in gameModel.cities(of: player) {
            
            guard let friendlyCity = friendlyCityRef else {
                fatalError("cant get friendlyCity")
            }
            
            guard let plot = gameModel.tile(at: friendlyCity.location) else {
                fatalError("cant get plot")
            }
            
            var generalInTheVicinity = false
            var power = 0
            
            for loopUnitRef in gameModel.units(of: player) {
                
                guard let loopUnit = loopUnitRef else {
                    fatalError("cant get loopUnit")
                }
                
                if loopUnit.isCombatUnit() {
                    let distance = loopUnit.location.distance(to: plot.point)
                    if distance <= 5 {
                        power += loopUnit.power()
                    }
                }
                
                if !generalInTheVicinity && loopUnit.isGreatGeneral() {
                    let distance = loopUnit.location.distance(to: plot.point)
                    if distance <= 5 {
                        generalInTheVicinity = true
                    }
                }
            }
            
            if generalInTheVicinity {
                power *= 11
                power /= 10
            }
            
            friendlyCity.set(scratch: power)
        }
        
        for enemyCityRef in gameModel.cities(of: enemy) {
            
            guard let enemyCity = enemyCityRef else {
                fatalError("cant get enemyCity")
            }
            
            guard let plot = gameModel.tile(at: enemyCity.location) else {
                fatalError("cant get plot")
            }
            
            if plot.isDiscovered(by: player) {

                var generalInTheVicinity = false
                var power = 0
                
                for loopUnitRef in gameModel.units(of: enemy) {
                    
                    guard let loopUnit = loopUnitRef else {
                        fatalError("cant get loopUnit")
                    }
                    
                    if loopUnit.isCombatUnit() {
                        let distance = loopUnit.location.distance(to: plot.point)
                        if distance <= 5 {
                            power += loopUnit.power()
                        }
                    }
                    
                    if !generalInTheVicinity && loopUnit.isGreatGeneral() {
                        let distance = loopUnit.location.distance(to: plot.point)
                        if distance <= 5 {
                            generalInTheVicinity = true
                        }
                    }
                }
                if generalInTheVicinity {
                    power *= 11
                    power /= 10
                }
                
                enemyCity.set(scratch: power)
            }
        }

        // Build a list of all the possible start city/target city pairs
        //static CvWeightedVector<CvMilitaryTarget, SAFE_ESTIMATE_NUM_CITIES* 10, true> prelimWeightedTargetList;
        //prelimWeightedTargetList.clear();
        let prelimWeightedTargetList: WeightedList<MilitaryTarget> = WeightedList<MilitaryTarget>()
        
        for friendlyCityRef in gameModel.cities(of: player) {
            
            guard let friendlyCity = friendlyCityRef else {
                fatalError("cant get friendlyCity")
            }
            
            guard let friendlyPlot = gameModel.tile(at: friendlyCity.location) else {
                fatalError("cant get plot")
            }
            
            for enemyCityRef in gameModel.cities(of: enemy) {
            
                guard let enemyCity = enemyCityRef else {
                    fatalError("cant get enemyCity")
                }
                
                guard let enemyPlot = gameModel.tile(at: enemyCity.location) else {
                    fatalError("cant get plot")
                }
                
                if enemyPlot.isDiscovered(by: player) {
                    
                    let target = MilitaryTarget()
                    //int iWeight;
                    target.musterCity = friendlyCityRef
                    target.targetCity = enemyCityRef
                    target.musterNearbyUnitPower = friendlyCity.scratch()
                    target.targetNearbyUnitPower = enemyCity.scratch()

                    if operationType == .pureNavalCityAttack {
                        target.attackBySea = true
                        if gameModel.isCoastal(at: friendlyPlot.point) && gameModel.isCoastal(at: enemyPlot.point) {
                            target.pathLength = enemyPlot.point.distance(to: friendlyPlot.point)
                        }
                    } else {
                        self.shouldAttackBySea(enemy: enemy, target: target, in: gameModel)

                        if !gameModel.isCoastal(at: friendlyPlot.point) && target.attackBySea {
                            continue
                        }
                    }

                    if target.pathLength > 0 {
                        // Start by using the path length as the weight, shorter paths have higher weight
                        let weight = (10000 - target.pathLength)
                        prelimWeightedTargetList.add(weight: weight, for: target)
                    }
                }
            }
        }

        // Let's score the 25 shortest paths ... anything more than that means there are too many interior cities from one (or both) sides being considered
        prelimWeightedTargetList.sort()
        var targetsConsidered = 0
        var iI = 0
        
        while iI < prelimWeightedTargetList.count && targetsConsidered < 25 {
            
            var target: MilitaryTarget = prelimWeightedTargetList.items[iI].itemType
            var weight = 0

            // If a sea target, we haven't checked the path yet.  Do that now
            if target.attackBySea {
                
                if !gameModel.isCoastal(at: target.musterCity!.location) {
                    continue
                }
                
                if !gameModel.isCoastal(at: target.targetCity!.location) {
                    continue
                }
                
                guard let seaPlotNearMuster = gameModel.coastalPlotAdjacent(to: target.musterCity!.location) else {
                    fatalError("cant get sea plot near muster")
                }
                
                guard let seaPlotNearTarget = gameModel.coastalPlotAdjacent(to: target.targetCity!.location) else {
                    fatalError("cant get sea plot near muster")
                }
                
                let pathFinder = AStarPathfinder()
                pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .swim, for: player)
                if !pathFinder.doesPathExist(fromTileCoord: seaPlotNearMuster.point, toTileCoord: seaPlotNearTarget.point) {
                    continue
                }
            }

            weight = self.scoreTarget(target: target, operationType: operationType, in: gameModel)
            weightedTargetList.add(weight: weight, for: target)
            targetsConsidered += 1
            
            iI += 1
        }

        // Didn't find anything, abort
        if weightedTargetList.count == 0 {
            chosenTarget.targetCity = nil   // Call off the attack
            winningScore = -1
            return chosenTarget
        }

        weightedTargetList.sort()
        // LogAttackTargets(eAIOperationType, eEnemy, weightedTargetList);

        if weightedTargetList.totalWeights() > 0 {
            //RandomNumberDelegate fcn;
            //fcn = MakeDelegate(&GC.getGame(), &CvGame::getJonRandNum);
            //let numChoices = max(1, (weightedTargetList.count * 25 / 100))
            chosenTarget = weightedTargetList.chooseFromTopChoices()!
            // if we need the winning score
            winningScore = self.scoreTarget(target: chosenTarget, operationType: operationType, in: gameModel)
            //LogChosenTarget(eAIOperationType, eEnemy, chosenTarget);
        } else {
            chosenTarget.targetCity = nil   // Call off the attack
            winningScore = -1
        }

        return chosenTarget
    }
    
    /// Is it better to attack this target by sea?
    func shouldAttackBySea(enemy: AbstractPlayer?, target targetRef: MilitaryTarget?, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let target = targetRef else {
            fatalError("cant get target")
        }

        let plotDistance = target.musterCity!.location.distance(to: target.targetCity!.location)
        var pathLength = 0
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .swim, for: player)

        // Can embark
        if player.canEmbark() {
            
            let musterArea = gameModel.area(of: target.musterCity!.location)
            let targetArea = gameModel.area(of: target.targetCity!.location)
            
            // On different landmasses?
            if musterArea != targetArea {
                targetRef?.attackBySea = true
                targetRef?.pathLength = plotDistance
                return
            }

            // No step path between muster point and target?
            if !pathFinder.doesPathExist(fromTileCoord: target.musterCity!.location, toTileCoord: target.targetCity!.location) {
                targetRef?.attackBySea = true
                targetRef?.pathLength = plotDistance
                return
            }

            // Land path is over twice as long as direct path
            /*pPathfinderNode = GC.getStepFinder().GetLastNode();
            if (pPathfinderNode != NULL)
            {
                iPathLength = pPathfinderNode->m_iData1;
                if (iPathLength > (2 * iPlotDistance))
                {
                    target.m_bAttackBySea = true;
                    target.m_iPathLength = iPlotDistance;
                    return;
                }
            }*/
        } else {
            
            pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .walk, for: player)
            
            // Can't embark yet
            if !pathFinder.doesPathExist(fromTileCoord: target.musterCity!.location, toTileCoord: target.targetCity!.location) {
                targetRef?.pathLength = -1  // Call off attack, no path
                return
            } else {
                if let path = pathFinder.shortestPath(fromTileCoord: target.musterCity!.location, toTileCoord: target.targetCity!.location) {
                    pathLength = path.count
                }
            }
        }

        targetRef?.attackBySea = false
        targetRef?.pathLength = pathLength
    }
    
    /// Come up with a target priority looking at distance, strength, approaches (high score = more desirable target)
    func scoreTarget(target: MilitaryTarget, operationType: UnitOperationType, in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        var rtnValue = 1;  // Start with a high base number since divide into it later

        // Take into account distance to target (and use higher multipliers for land paths)
        if !target.attackBySea {
            
            if target.pathLength < 10 {
                rtnValue *= 16
            } else if target.pathLength < 15 {
                rtnValue *= 8
            } else if target.pathLength < 20 {
                rtnValue *= 4
            } else {
                rtnValue *= 2
            }

            // Double if we can assemble troops in muster city with airlifts
            /*if target.musterCity.canAirlift() {
                rtnValue *= 2
            }*/
        } else {
            if target.pathLength < 12 {
                rtnValue *= 5
            } else if target.pathLength < 20 {
                rtnValue *= 3
            } else if target.pathLength < 30 {
                rtnValue *= 2
            }

            // If coming over sea, inland cities are trickier
            if !gameModel.isCoastal(at: target.targetCity!.location) {
                rtnValue /= 2
            }
        }

        // Is this a sneak attack?  If so distance is REALLY important (want to target spaces on edge of empire)
        // So let's cube what we have so far
        if operationType == .sneakCityAttack || operationType == .navalSneakAttack {
            rtnValue = rtnValue * rtnValue * rtnValue
        }

        var approachMultiplier = 0
        // Assume units coming by sea can disembark
        let approaches: CityAttackApproachType = self.evaluateMilitaryApproaches(city: target.targetCity, attackByLand: true, attackBySea: target.attackBySea, in: gameModel)
        
        switch approaches {
            
        case .unrestricted:
            approachMultiplier = 10

        case .open:
            approachMultiplier = 8

        case .neutral:
            approachMultiplier = 4

        case .limited:
            approachMultiplier = 2

        case .restricted:
            approachMultiplier = 1

        case .none:
            approachMultiplier = 0
        }

        rtnValue *= approachMultiplier

        // should probably give a bonus if these cities are adjacent

        // Don't want to start at a city that isn't connected to our capital
        if !target.musterCity!.isRouteToCapitalConnected() && !target.musterCity!.isCapital() {
            rtnValue /= 4
        }

        // this won't work if we are "just checking" as the zone are only built for actual war war opponents
        // TODO come up with a better way to do this that is always correct

        let friendlyStrength = max(1, target.musterNearbyUnitPower)
        let enemyStrength = max(1, target.targetNearbyUnitPower + (target.targetCity!.strengthValue() / 50))

        var ratio = 1;
        ratio = (friendlyStrength * 100) / enemyStrength
        ratio = min(1000, ratio)
        rtnValue *= ratio

        if target.targetCity!.isOriginalCapital(in: gameModel) {
            rtnValue *= 150 /* AI_MILITARY_CAPTURING_ORIGINAL_CAPITAL */
            rtnValue /= 100
        }

        if target.targetCity!.originalLeader() == player.leader {
            rtnValue *= 150 /* AI_MILITARY_RECAPTURING_OWN_CITY */
            rtnValue /= 100
        }

        // Don't want it to already be targeted by an operation that's not well on its way
        if player.isCityAlreadyTargeted(city: target.targetCity, via: .none, percentToTarget: 50, in: gameModel) {
            rtnValue /= 10
        }

        rtnValue /= 1000

        // Economic value of target
        var economicValue = 1 + (target.targetCity!.population() / 3)
        // TODO: unhardcode this
        
        guard let targetPlot = gameModel.tile(at: target.targetCity!.location) else {
            fatalError("cant get target plot")
        }
        
        let yields = targetPlot.yields(for: self.player, ignoreFeature: false)
        
        // filter out all but the most productive
        economicValue += Int(yields.food) * 10
        economicValue += Int(yields.production) * 10
        economicValue += Int(yields.science) * 10
        economicValue += Int(yields.gold) * 10
        economicValue += Int(yields.culture) * 10
        economicValue += Int(yields.faith) * 10
        rtnValue *= economicValue

        rtnValue /= 10

        return min(10000000, rtnValue & 0x7fffffff)
    }
    
    /// How open an approach do we have to this city if we want to attack it?
    func evaluateMilitaryApproaches(city: AbstractCity?, attackByLand: Bool, attackBySea: Bool, in gameModel: GameModel?) -> CityAttackApproachType {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let city = city else {
            fatalError("cant get city")
        }
        
        var rtnValue: CityAttackApproachType = .unrestricted
        var numBlocked = 0

        // Look at each of the six plots around the city
        for neighbor in city.location.neighbors() {

            if let loopPlot = gameModel.tile(at: neighbor) {
                
                // For now, assume no one coming in over a lake
                if loopPlot.has(feature: .lake) {
                    numBlocked += 1
                } else if loopPlot.isWater() && !attackBySea {
                    // Coast but attack is not by sea?
                    numBlocked += 1
                } else if !loopPlot.isWater() {
                    // Land
                    if !attackByLand {
                        numBlocked += 1
                    } else {
                        if loopPlot.isImpassable() {
                            numBlocked += 1
                        }
                    }
                }
            } else {
                // Blocked if edge of map
                numBlocked += 1
            }
        }

        switch numBlocked {
            
        case 0:
            rtnValue = .unrestricted
        case 1, 2:
            rtnValue = .open
        case 3:
            rtnValue = .neutral
        case 4:
            rtnValue = .limited
        case 5:
            rtnValue = .restricted
        case 6:
            rtnValue = .none
        default:
            fatalError("cant happen")
        }

        return rtnValue
    }
    
    /// Send an army to force concessions
    func requestPillageEnemy(towards otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Bool {
        
        var numRequiredSlots = 0
        var landReservesUsed = 0
        let filledSlots = MilitaryAIHelpers.numberOfFillableSlots(for: self.player, formation: .fastPillagers, requiresNavalMoves: false, numberSlotsRequired: &numRequiredSlots, numberLandReservesUsed: &landReservesUsed, in: gameModel)
            
        if filledSlots >= numRequiredSlots && landReservesUsed <= self.landReservesAvailable() {
            
            if let operation = self.player?.addOperation(of: .pillageEnemy, towards: otherPlayer, target: nil, in: nil, in: gameModel) {
                
                if !operation.shouldAbort(in: gameModel) {
                    return true
                }
            }
        }

        return false
    }

    func landDefenseState() -> DefenseStateType {

        return self.landDefenseStateVal
    }

    func navalDefenseState() -> DefenseStateType {

        return self.navalDefenseStateVal
    }
    
    /// How strong is the best unit we can train for this domain?
    func powerOfStrongestBuildableUnit(in domain: UnitDomainType) -> Int {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        var rtnValue = 0
        for unitType in UnitType.all {

            if unitType.domain() == domain {
                
                let thisPower = unitType.power()        // Test the power first, it is much less costly than testing canTrain
                if thisPower > rtnValue {
                    if player.canTrain(unitType: unitType, continueFlag: false, testVisible: false, ignoreCost: true, ignoreUniqueUnitStatus: false) {
                        rtnValue = thisPower
                    }
                }
            }
        }

        return rtnValue
    }

    func barbarianData() -> BarbarianData {

        return self.barbarianDataVal
    }

    func updateBaseData(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        self.baseData.reset()

        for unitRef in gameModel.units(of: player) {

            guard let unit = unitRef else {
                fatalError("cant get unit")
            }

            // Don't count exploration units
            if unit.task() == .explore || unit.task() == .exploreSea {
                continue
            }

            // Don't count civilians
            if !unit.has(task: .attack) {
                continue
            }

            switch unit.domain() {

            case .none:
                // NOOP
                break
                
            case .land:
                self.baseData.numLandUnits += 1

                if unit.has(task: .ranged) {
                    self.baseData.numRangedLandUnits += 1
                }

                if unit.moves() > 2 {
                    self.baseData.numMobileLandUnits += 1
                }

            case .sea:
                self.baseData.numNavalUnits += 1

            case .air, .immobile:
                // NOOP
                break
            }
        }

        let flavorOffense: Double = Double(player.valueOfStrategyAndPersonalityFlavor(of: .offense))
        let flavorDefense: Double = Double(player.valueOfStrategyAndPersonalityFlavor(of: .defense))

        // Scale up or down based on true threat level and a bit by flavors (multiplier should range from about 0.5 to about 1.5)
        let multiplier = (0.40 + Double(self.highestThreat(in: gameModel).rawValue) + flavorOffense + flavorDefense) / 100.0

        // first get the number of defenders that we think we need

        // Start with 3, to protect the capital
        var iNumUnitsWanted = 3.0

        // 1 Unit per City & 1 per Settler
        iNumUnitsWanted += Double(gameModel.cities(of: player).count) * 1.0
        iNumUnitsWanted += Double(gameModel.units(of: player).count(where: { $0!.task() == .settle })) * 1.0

        self.baseData.mandatoryReserveSize = Int(Double(iNumUnitsWanted) * multiplier)

        // add in a few for the difficulty level (all above Chieftain are boosted)
        //int iDifficulty = max(0,GC.getGame().getHandicapInfo().GetID() - 1);
        //m_iMandatoryReserveSize += (iDifficulty * 3 / 2);

        self.baseData.mandatoryReserveSize = max(1, self.baseData.mandatoryReserveSize)

        // now we add in the strike forces we think we will need
        iNumUnitsWanted = 7 // size of a basic attack

        // if we are going for conquest we want at least one more task force
        if player.grandStrategyAI?.activeStrategy == .conquest {
            iNumUnitsWanted *= 2
        }

        // add in a few more if the player is bold
        iNumUnitsWanted += Double(player.leader.trait(for: .boldness))

        // add in more if we are playing on a high difficulty
        //iNumUnitsWanted += iDifficulty * 3

        iNumUnitsWanted = iNumUnitsWanted * multiplier

        iNumUnitsWanted = max(1, iNumUnitsWanted)

        self.baseData.recommendedMilitarySize = self.baseData.mandatoryReserveSize + Int(iNumUnitsWanted)
    }

    func updateBarbarianData(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        self.barbarianDataVal.reset()

        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {

            for y in 0..<mapSize.height() {

                let pt = HexPoint(x: x, y: y)

                if let tile = gameModel.tile(at: pt) {

                    if tile.isDiscovered(by: self.player) {

                        if tile.has(improvement: .barbarianCamp) {
                            self.barbarianDataVal.barbarianCampCount += 1

                            // Count it as 5 camps if sitting inside our territory, that is annoying!
                            if tile.owner()?.leader == self.player?.leader {
                                self.barbarianDataVal.barbarianCampCount += 4
                            }
                        }
                    }

                    if tile.isVisible(to: self.player) {
                        if let unit = gameModel.unit(at: pt, of: .combat) {
                            if unit.isOf(unitType: .barbarianWarrior) {
                                self.barbarianDataVal.visibleBarbarianCount += 1
                            }
                        }
                    }
                }
            }
        }
    }

    func updateDefenseState(in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("no player given")
        }

        guard let economicAI = player.economicAI else {
            fatalError("no economicAI given")
        }

        // Derive data we'll need
        let iLandUnitsNotInArmies = self.baseData.numLandUnits/* - m_iNumLandUnitsInArmies*/
        let iNavalUnitsNotInArmies = self.baseData.numNavalUnits/* - m_iNumNavalUnitsInArmies*/

        if iLandUnitsNotInArmies < self.baseData.mandatoryReserveSize {
            self.landDefenseStateVal = .critical
        } else if iLandUnitsNotInArmies < self.baseData.recommendedMilitarySize {
            self.landDefenseStateVal = .needed
        } else if iLandUnitsNotInArmies < self.baseData.recommendedMilitarySize * 5 / 4 {
            self.landDefenseStateVal = .neutral
        } else {
            self.landDefenseStateVal = .enough
        }

        let iNavySize = 4 // FIXME: MilitaryAIHelpers::ComputeRecommendedNavySize(m_pPlayer)

        if economicAI.adopted(economicStrategy: .expandToOtherContinents) {

            if iNavalUnitsNotInArmies <= (iNavySize / 2) {
                self.navalDefenseStateVal = .critical
            } else if iNavalUnitsNotInArmies <= iNavySize {
                self.navalDefenseStateVal = .needed
            } else if iNavalUnitsNotInArmies <= iNavySize * 5 / 4 {
                self.navalDefenseStateVal = .neutral
            } else {
                self.navalDefenseStateVal = .enough
            }
        } else {

            if iNavalUnitsNotInArmies <= (iNavySize / 3) {
                self.navalDefenseStateVal = .critical
            } else if iNavalUnitsNotInArmies <= (iNavySize * 2 / 3) {
                self.navalDefenseStateVal = .needed
            } else if iNavalUnitsNotInArmies <= iNavySize {
                self.navalDefenseStateVal = .neutral
            } else {
                self.navalDefenseStateVal = .enough
            }
        }
    }

    // See if the threats we are facing have changed
    func highestThreat(in gameModel: GameModel?) -> MilitaryThreatType {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        var highestThreatByPlayer: MilitaryThreatType = .none

        for otherPlayer in gameModel.players {

            if otherPlayer.leader != player.leader {

                if !player.hasMet(with: otherPlayer) {
                    continue
                }

                if let threat = player.diplomacyAI?.militaryThreat(of: otherPlayer) {

                    if highestThreatByPlayer < threat {
                        highestThreatByPlayer = threat
                    }
                }
            }
        }

        return highestThreatByPlayer
    }

    func updateFlavors() {

        self.flavors.reset()

        for militaryStrategyType in MilitaryStrategyType.all {

            if self.militaryStrategyAdoption.adopted(militaryStrategy: militaryStrategyType) {

                for militaryStrategyTypeFlavor in militaryStrategyType.flavorModifiers() {

                    self.flavors += militaryStrategyTypeFlavor
                }
            }
        }

        // FIXME: inform
    }

    func adopted(militaryStrategy: MilitaryStrategyType) -> Bool {

        return self.militaryStrategyAdoption.adopted(militaryStrategy: militaryStrategy)
    }

    func numberOfPlayersAtWarWith(in gameModel: GameModel?) -> Int {

        guard let players = gameModel?.players else {
            fatalError("cant get players")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        var number = 0

        for otherPlayer in players {

            if self.player?.leader != otherPlayer.leader {

                if !player.hasMet(with: otherPlayer) {
                    continue
                }

                if let warState = player.diplomacyAI?.warState(towards: otherPlayer) {
                    if warState != .none {
                        number += 1
                    }
                }
            }
        }

        return number
    }

    func percentOfRecommendedMilitarySize() -> Int {

        if self.baseData.recommendedMilitarySize <= 0 {
            return 0
        }

        return self.baseData.numLandUnits * 100 / self.baseData.recommendedMilitarySize
    }

    func advisorMessages() -> [AdvisorMessage] {

        var messages: [AdvisorMessage] = []

        for militaryStrategyType in MilitaryStrategyType.all {

            if self.militaryStrategyAdoption.adopted(militaryStrategy: militaryStrategyType) {

                if let message = militaryStrategyType.advisorMessage() {
                    messages.append(message)
                }
            }
        }

        return messages
    }

    func mostThreatenedCity(in gameModel: GameModel?) -> AbstractCity? {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        var highestThreatValue = 0
        var highestThreatendCity: AbstractCity? = nil

        for cityRef in gameModel.cities(of: player) {

            if let city = cityRef {

                var threadValue = city.threatValue() * city.population()

                if city.isCapital() {
                    threadValue *= 125
                    threadValue /= 100
                }

                if threadValue > highestThreatValue {
                    highestThreatValue = threadValue
                    highestThreatendCity = cityRef
                }
            }
        }

        return highestThreatendCity
    }
    
    /// Find the port operation operations against this enemy should leave from
    func nearestCoastalCity(towards otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> AbstractCity? {
        
        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }
        
        guard let player = self.player else {
            fatalError("no player given")
        }
        
        guard let otherPlayer = otherPlayer else {
            fatalError("no otherPlayer given")
        }
        
        var bestCoastalCity: AbstractCity? = nil
        var bestDistance: Int = Int.max
        
        for loopCityRef in gameModel.cities(of: player) {
            
            guard let loopCity = loopCityRef else {
                continue
            }
            
            if gameModel.isCoastal(at: loopCity.location) {
                
                for enemyCityRef in gameModel.cities(of: otherPlayer) {
                    
                    guard let enemyCity = enemyCityRef,
                          let enemyCityTile = gameModel.tile(at: enemyCity.location) else {
                        continue
                    }
                    
                    // Check all revealed enemy cities
                    if gameModel.isCoastal(at: enemyCity.location) && enemyCityTile.isDiscovered(by: player) {
                        
                        // On same body of water?
                        // if(OnSameBodyOfWater(pLoopCity, pEnemyCity)) {
                        let distance = enemyCity.location.distance(to: loopCity.location)
                        
                        if distance < bestDistance {
                            bestDistance = distance
                            bestCoastalCity = loopCity
                        }
                        // }
                    }
                }
            }
        }
        
        return bestCoastalCity
    }
    
    func waterTileAdjacent(to target: HexPoint, for unit: AbstractUnit?, in gameModel: GameModel?) -> AbstractTile? {
        
        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }
        
        var bestDistance = Int.max
        var coastalPlot: AbstractTile? = nil
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .swim, for: self.player)
        
        // Find a coastal water tile adjacent to enemy city
        for adjacentPoint in target.neighbors() {
            
            guard let adjacentPlot = gameModel.tile(at: adjacentPoint) else {
                continue
            }
            
            if adjacentPlot.terrain() == .shore {
                
                if let unit = unit {
                    if pathFinder.turnsToReachTarget(for: unit, to: adjacentPoint) < Int.max {
                     
                        let distance = unit.location.distance(to: adjacentPoint)
                    
                        if distance < bestDistance {
                        
                            bestDistance = distance
                            coastalPlot = adjacentPlot
                        }
                    }
                } else {
                    return adjacentPlot
                }
            }
        }
        
        return coastalPlot
    }
    
    @discardableResult
    func buyEmergencyBuilding(in city: AbstractCity?) -> BuildingType? {
        
        fatalError("not implemented")
    }

    @discardableResult
    func buyEmergencyUnit(task: UnitTaskType, in city: AbstractCity?) -> AbstractUnit? {
        
        fatalError("not implemented")
    }
    
    func coastalPlotAdjacent(to target: HexPoint, army: Army?, in gameModel: GameModel?) -> HexPoint? {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var coastalPlot: HexPoint? = nil
        var bestDistance = Int.max
        var initialUnit: AbstractUnit? = nil
        
        if army != nil {
            initialUnit = army?.unit(at: 0)
        }

        // Find a coastal water tile adjacent to enemy city
        for adjacentPoint in target.neighbors() {
            
            guard let adjacentPlot = gameModel.tile(at: adjacentPoint) else {
                continue
            }

            if adjacentPlot.isWater() && adjacentPlot.terrain() == .shore {
                
                // Check for path if we have a unit, otherwise don't worry about it
                if let initialUnit = initialUnit {
                    
                    if initialUnit.turnsToReach(at: adjacentPoint, in: gameModel) < Int.max  {

                        let distance = initialUnit.location.distance(to: target)
                        
                        if distance < bestDistance {
                            bestDistance = distance
                            coastalPlot = adjacentPoint
                        }
                    }
                } else {
                    return adjacentPoint
                }
            }
        }

        return coastalPlot
    }
}

class MilitaryAIHelpers {
    
    /// How many slots in this army can we fill right now with available units?
    static func numberOfFillableSlots(for player: AbstractPlayer?, formation: UnitFormationType, requiresNavalMoves: Bool, numberSlotsRequired: inout Int, numberLandReservesUsed: inout Int, in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = player else {
            fatalError("cant get player")
        }

        var willBeFilled = 0
        var landReservesUsed = 0
        let slotsToFill = formation.slots()
        var slotsNotFilled: [UnitFormationSlot] = []

        let mustBeDeepWaterNaval = player.canEmbarkAllWaterPassage() && formation.isRequiresNavalUnitConsistency()

        for loopUnitRef in gameModel.units(of: player) {

            guard let loopUnit = loopUnitRef else {
                continue
            }
            
            // Don't count scouts
            if loopUnit.task() != .explore && loopUnit.task() != .exploreSea {
                
                // Don't count units that are damaged too heavily
                if loopUnit.healthPoints() < loopUnit.maxHealthPoints() * 80 /* AI_OPERATIONAL_PERCENT_HEALTH_FOR_OPERATION */ / 100 {
                    
                    if loopUnit.army() == nil && loopUnit.canRecruitFromTacticalAI() {
                        
                        if loopUnit.deployFromOperationTurn() + 4 /* AI_TACTICAL_MAP_TEMP_ZONE_TURNS */ < gameModel.currentTurn {
                            
                            if !requiresNavalMoves || loopUnit.domain() == .sea || loopUnit.canEverEmbark() {
                                
                                if !mustBeDeepWaterNaval || loopUnit.domain() != .sea || !loopUnit.isImpassable(terrain: .ocean) {
                                    
                                    for slotEntry in slotsToFill {
                                        
                                        //CvUnitEntry& kUnitInfo = pLoopUnit->getUnitInfo();
                                        if loopUnit.has(task: slotEntry.primaryUnitTask) || loopUnit.has(task: slotEntry.secondaryUnitTask) {
                                            
                                            willBeFilled += 1

                                            if loopUnit.domain() == .land {
                                                landReservesUsed += 1
                                            }
                                            
                                            break
                                        } else {
                                            slotsNotFilled.append(slotEntry)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Now go back through remaining slots and see how many were required, we'll need that many more units
        numberSlotsRequired = willBeFilled
        for slotNotFilled in slotsNotFilled {
            if slotNotFilled.required {
                numberSlotsRequired += 1
            }
        }
        numberLandReservesUsed = landReservesUsed
        return willBeFilled
    }
}
