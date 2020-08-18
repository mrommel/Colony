//
//  Unit.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 06.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class CombatModifier {
    
    public let modifierValue: Int
    public let modifierTitle: String
    
    init(modifierValue: Int, modifierTitle: String) {
        
        self.modifierValue = modifierValue
        self.modifierTitle = modifierTitle
    }
}

public struct MoveOptions : OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    static public let none        = MoveOptions([])
    static public let declareWar  = MoveOptions(rawValue: 1 << 0)
    static public let attack      = MoveOptions(rawValue: 1 << 1)
    /*static let secondOption = MyOptions(rawValue: 1 << 2)
    static let thirdOption  = MyOptions(rawValue: 1 << 3)*/
}

public enum UnitActivityType: Int, Codable {

    case none
    case awake // ACTIVITY_AWAKE,
    case hold // ACTIVITY_HOLD,
    case sleep // ACTIVITY_SLEEP,
    case heal // ACTIVITY_HEAL,
    case sentry // ACTIVITY_SENTRY,
    case intercept // ACTIVITY_INTERCEPT,
    case mission // ACTIVITY_MISSION
}

public protocol AbstractUnit: class, Codable {

    var location: HexPoint { get }
    var type: UnitType { get }
    var player: AbstractPlayer? { get set }
    var leader: LeaderType { get } // for restore from file only
    var origin: HexPoint { get } // to get the city the unit was created in
    var task: UnitTaskType { get }

    func name() -> String
    func isBarbarian() -> Bool
    func isHuman() -> Bool
    func unitClassType() -> UnitClassType

    func civilianAttackPriority() -> CivilianAttackPriorityType
    func captureUnitType() -> UnitType
    func canCapture() -> Bool

    func isOf(unitType: UnitType) -> Bool
    func hasSameType(as otherUnit: AbstractUnit?) -> Bool
    func isOf(unitClass: UnitClassType) -> Bool
    func has(task: UnitTaskType) -> Bool
    func domain() -> UnitDomainType

    func canMove() -> Bool
    func canMove(into point: HexPoint, options: MoveOptions, in gameModel: GameModel?) -> Bool
    func moves() -> Int
    func movesLeft() -> Int
    func maxMoves(in gameModel: GameModel?) -> Int
    func movementType() -> UnitMovementType
    func baseMoves(into domain: UnitDomainType, in gameModel: GameModel?) -> Int
    func path(towards target: HexPoint, in gameModel: GameModel?) -> HexPath?
    @discardableResult func doMoveOnPath(towards target: HexPoint, previousETA: Int, buildingRoute: Bool, in gameModel: GameModel?) -> Int
    @discardableResult func doMove(on target: HexPoint, in gameModel: GameModel?) -> Bool
    func readyToMove() -> Bool
    func queueMoveForVisualization(at point: HexPoint, in gameModel: GameModel?)
    func publishQueuedVisualizationMoves(in gameModel: GameModel?)
    @discardableResult func jumpToNearestValidPlotWithin(range: Int, in gameModel: GameModel?) -> Bool

    func isImpassable(tile: AbstractTile?) -> Bool
    func canEnterTerrain(of tile: AbstractTile?) -> Bool
    func isImpassable(terrain: TerrainType) -> Bool
    func canMoveAllTerrain() -> Bool
    func validTarget(at target: HexPoint, in gameModel: GameModel?) -> Bool
    func canHold(at point: HexPoint, in gameModel: GameModel?) -> Bool
    func canEnterTerritory(of otherPlayer: AbstractPlayer?, ignoreRightOfPassage: Bool, isDeclareWarMove: Bool) -> Bool

    func healthPoints() -> Int
    func maxHealthPoints() -> Int
    func set(healthPoints: Int)
    func canHeal(in gameModel: GameModel?) -> Bool
    func damage() -> Int
    func add(damage: Int)
    func isHurt() -> Bool
    func doHeal(in gameModel: GameModel?)

    func isOutOfAttacks() -> Bool
    func setMadeAttack(to newValue: Bool)
    func baseCombatStrength(ignoreEmbarked: Bool) -> Int
    func attackStrength(against defender: AbstractUnit?, or city: AbstractCity?, on toTile: AbstractTile?, in gameModel: GameModel?) -> Int
    func attackStrengthModifier(against defender: AbstractUnit?, or city: AbstractCity?, on toTile: AbstractTile?, in gameModel: GameModel?) -> [CombatModifier]
    func rangedCombatStrength(against defender: AbstractUnit?, or city: AbstractCity?, on toTile: AbstractTile?, attacking: Bool, in gameModel: GameModel?) -> Int
    func attackModifier(against defender: AbstractUnit?, or city: AbstractCity?, on toTile: AbstractTile?, in gameModel: GameModel?) -> Int
    func defensiveStrength(against attacker: AbstractUnit?, on toTile: AbstractTile?, ranged: Bool, in gameModel: GameModel?) -> Int
    func defensiveStrengthModifier(against attacker: AbstractUnit?, on toTile: AbstractTile?, ranged: Bool, in gameModel: GameModel?) -> [CombatModifier]
    func defenseModifier(against attacker: AbstractUnit?, on toTile: AbstractTile?, ranged: Bool,in gameModel: GameModel?) -> Int
    
    func sight() -> Int
    func range() -> Int
    func search(range: Int, in gameModel: GameModel?) -> Int

    func experience() -> Int
    func changeExperience(by delta: Int, in gameModel: GameModel?)
    func isPromotionReady() -> Bool
    func possiblePromotions() -> [UnitPromotionType]
    func doPromote(with promotionType: UnitPromotionType)

    func power() -> Int
    func isCombatUnit() -> Bool
    func isRanged() -> Bool

    func turn(in gameModel: GameModel?)
    func set(turnProcessed: Bool)
    func processedInTurn() -> Bool

    func canMoveOrAttack(into point: HexPoint) -> Bool
    func canAttack() -> Bool
    func canAttackRanged() -> Bool
    func canMoveAfterAttacking() -> Bool
    func doAttack(into destination: HexPoint, /* flags */ steps: Int, in gameModel: GameModel?) -> Bool
    func canRangeStrike(at point: HexPoint, needWar: Bool, noncombatAllowed: Bool) -> Bool
    func doRangeAttack(at target: HexPoint, in gameModel: GameModel?) -> Bool
    func canDefend() -> Bool
    func canSentry(in gameModel: GameModel?) -> Bool

    func canDo(command: CommandType, in gameModel: GameModel?) -> Bool

    func can(automate: UnitAutomationType) -> Bool
    func isAutomated() -> Bool
    func automateType() -> UnitAutomationType
    func automate(with type: UnitAutomationType)

    func canFound(at location: HexPoint, in gameModel: GameModel?) -> Bool
    func isFound() -> Bool
    @discardableResult
    func doFound(with name: String?, in gameModel: GameModel?) -> Bool

    func canBuild(build: BuildType, at point: HexPoint, testVisible: Bool, testGold: Bool, in gameModel: GameModel?) -> Bool
    func canContinueBuild(build buildType: BuildType, in gameModel: GameModel?) -> Bool
    func doBuild(build: BuildType, in gameModel: GameModel?) -> Bool
    func buildType() -> BuildType
    func continueBuilding(build buildType: BuildType, in gameModel: GameModel?) -> Bool
    
    func changeBuildCharges(change: Int)
    func buildCharges() -> Int

    @discardableResult func doPillage(in gameModel: GameModel?) -> Bool
    func canPillage(at point: HexPoint, in gameModel: GameModel?) -> Bool
    func doRebase(to point: HexPoint) -> Bool

    func canReach(at point: HexPoint, in turns: Int, in gameModel: GameModel?) -> Bool
    func turnsToReach(at point: HexPoint, in gameModel: GameModel?) -> Int

    func canGarrison(at point: HexPoint, in gameModel: GameModel?) -> Bool
    func isGarrisoned() -> Bool
    @discardableResult func doGarrison(in gameModel: GameModel?) -> Bool
    func unGarrison(in gameModel: GameModel?)

    func canEverEmbark() -> Bool
    func canEmbark(into point: HexPoint?, in gameModel: GameModel?) -> Bool
    func doEmbark(into point: HexPoint?, in gameModel: GameModel?) -> Bool
    func canDisembark(into point: HexPoint?, in gameModel: GameModel?) -> Bool
    func doDisembark(into point: HexPoint?, in gameModel: GameModel?) -> Bool
    func isEmbarked() -> Bool

    func canFortify(at point: HexPoint, in gameModel: GameModel?) -> Bool
    func doFortify(in gameModel: GameModel?)
    func doMobilize(in gameModel: GameModel?)
    func set(fortifiedThisTurn: Bool, in gameModel: GameModel?)

    func finishMoves()
    func resetMoves(in gameModel: GameModel?)
    func hasMoved(in gameModel: GameModel?) -> Bool

    // mission / tactical move
    func activityType() -> UnitActivityType
    func set(activityType: UnitActivityType, in gameModel: GameModel?)
    func isWaiting() -> Bool

    func canStart(mission: UnitMission, in gameModel: GameModel?) -> Bool
    func push(mission: UnitMission, in gameModel: GameModel?)
    func updateMission(in gameModel: GameModel?)
    func popMission()
    func setMissionTimer(to timer: Int)
    func missionTimer() -> Int
    func peekMission() -> UnitMission?
    func autoMission(in gameModel: GameModel?)
    func hasCompletedMoveMission(in gameModel: GameModel?) -> Bool
    func clearMissions()

    func set(tacticalMove: TacticalMoveType)
    func tacticalMove() -> TacticalMoveType?
    func resetTacticalMove()
    
    func set(tacticalTarget: HexPoint)
    func tacticalTarget() -> HexPoint?
    func resetTacticalTarget()
    
    func isUnderTacticalControl() -> Bool
    func canRecruitFromTacticalAI() -> Bool

    // army
    func army() -> Army?
    func assign(to army: Army?)
    func deployFromOperationTurn() -> Int
    func setDeployFromOperationTurn(to turn: Int)

    func isEqual(to other: AbstractUnit?) -> Bool

    // so sad
    func doKill(delayed: Bool, by other: AbstractPlayer?, in gameModel: GameModel?)

    @discardableResult
    func doDelayedDeath(in gameModel: GameModel?) -> Bool
    func isDelayedDeath() -> Bool
    func startDelayedDeath()

    func commands(in gameModel: GameModel?) -> [Command]

    func isBusy() -> Bool
    
    func isGreatGeneral() -> Bool
}

public class Unit: AbstractUnit {
    
    static let maxHealth: Double = 100.0

    enum CodingKeys: CodingKey {

        case type
        case location
        case player
        case leader
        case origin
        case promotions
        case task
        case deathDelay

        case tacticalMove
        case tacticalTarget
        case garrisoned

        case moves
        case experience
        case fortify
        case isEmbarked
        case healthPoints
        case numberOfAttacksMade
        case numberOfAttacks

        case processedInTurn
        case deployFromOperationTurn

        case activityType
        case buildType
        case buildCharges
        case automation
    }

    public let type: UnitType
    private(set) public var location: HexPoint
    private var facingDirection: HexDirection = .south
    public var player: AbstractPlayer?
    private(set) public var leader: LeaderType // for restoring from file
    private(set) public var origin: HexPoint
    internal var promotions: AbstractPromotions?
    public var task: UnitTaskType
    private var deathDelay: Bool = false

    private var armyRef: Army?
    private var tacticalMoveValue: TacticalMoveType? = nil
    private var tacticalTargetValue: HexPoint? = nil
    private var garrisonedValue: Bool = false

    //
    var movesValue: Int
    var experienceValue: Int // 0..400
    var fortifyValue: Int
    var isEmbarkedValue: Bool = false
    private var healthPointsValue: Int // 0..100 - https://civilization.fandom.com/wiki/Hit_Points
    var processedInTurnValue: Bool = false
    var fortifiedThisTurnValue: Bool = false
    var fortifyTurnsValue: Int = 0
    var deployFromOperationTurnValue: Int = -1
    var numberOfAttacksMade: Int
    var numberOfAttacks: Int

    // missions
    internal var missions: Stack<UnitMission>
    internal var missionTimerValue: Int
    internal var activityTypeValue: UnitActivityType
    internal var buildTypeValue: BuildType = .none
    internal var buildChargesValue: Int = 0

    // automations
    internal var automation: UnitAutomationType = .none
    private var moveLocations: [HexPoint] = []

    public init(at location: HexPoint, type: UnitType, owner: AbstractPlayer?) {

        self.type = type
        self.location = location
        self.player = owner
        self.leader = owner!.leader
        self.task = type.defaultTask()
        self.origin = location

        self.healthPointsValue = Int(Unit.maxHealth)
        self.experienceValue = 0
        self.movesValue = type.moves()
        self.fortifyValue = 0
        self.numberOfAttacksMade = 0
        self.numberOfAttacks = 1

        self.missions = Stack<UnitMission>()
        self.missionTimerValue = 0
        self.activityTypeValue = .none

        self.promotions = Promotions(unit: self)
        
        self.buildChargesValue = type.buildCharges()
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(UnitType.self, forKey: .type)
        self.location = try container.decode(HexPoint.self, forKey: .location)
        self.leader = try container.decode(LeaderType.self, forKey: .leader)
        self.promotions = try container.decode(Promotions.self, forKey: .promotions)
        self.task = try container.decode(UnitTaskType.self, forKey: .task)
        self.deathDelay = try container.decode(Bool.self, forKey: .deathDelay)
        self.origin = try container.decode(HexPoint.self, forKey: .origin)

        self.tacticalMoveValue = try container.decodeIfPresent(TacticalMoveType.self, forKey: .tacticalMove)
        self.tacticalTargetValue = try container.decodeIfPresent(HexPoint.self, forKey: .tacticalTarget)
        self.garrisonedValue = try container.decode(Bool.self, forKey: .garrisoned)

        self.movesValue = try container.decode(Int.self, forKey: .moves)
        self.experienceValue = try container.decode(Int.self, forKey: .experience)
        self.isEmbarkedValue = try container.decode(Bool.self, forKey: .isEmbarked)
        self.healthPointsValue = try container.decode(Int.self, forKey: .healthPoints)
        self.fortifyValue = try container.decode(Int.self, forKey: .fortify)
        self.numberOfAttacksMade = try container.decode(Int.self, forKey: .numberOfAttacksMade)
        self.numberOfAttacks = try container.decode(Int.self, forKey: .numberOfAttacks)

        self.processedInTurnValue = try container.decode(Bool.self, forKey: .processedInTurn)
        self.deployFromOperationTurnValue = try container.decode(Int.self, forKey: .deployFromOperationTurn)

        self.missions = Stack<UnitMission>()
        self.missionTimerValue = 0

        self.activityTypeValue = try container.decode(UnitActivityType.self, forKey: .activityType)
        self.buildTypeValue = try container.decode(BuildType.self, forKey: .buildType)
        self.buildChargesValue = try container.decode(Int.self, forKey: .buildCharges)
        self.automation = try container.decode(UnitAutomationType.self, forKey: .automation)

        // post process
        self.promotions?.postProcess(by: self)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.player!.leader, forKey: .leader)
        let promotionsWrapper = self.promotions as? Promotions
        try container.encode(promotionsWrapper, forKey: .promotions)
        try container.encode(self.task, forKey: .task)
        try container.encode(self.deathDelay, forKey: .deathDelay)
        try container.encode(self.origin, forKey: .origin)

        try container.encodeIfPresent(self.tacticalMoveValue, forKey: .tacticalMove)
        try container.encodeIfPresent(self.tacticalTargetValue, forKey: .tacticalTarget)
        try container.encode(self.garrisonedValue, forKey: .garrisoned)

        try container.encode(self.movesValue, forKey: .moves)
        try container.encode(self.experienceValue, forKey: .experience)
        try container.encode(self.fortifyValue, forKey: .fortify)
        try container.encode(self.isEmbarkedValue, forKey: .isEmbarked)
        try container.encode(self.healthPointsValue, forKey: .healthPoints)
        try container.encode(self.numberOfAttacksMade, forKey: .numberOfAttacksMade)
        try container.encode(self.numberOfAttacks, forKey: .numberOfAttacks)

        try container.encode(self.processedInTurnValue, forKey: .processedInTurn)
        try container.encode(self.deployFromOperationTurnValue, forKey: .deployFromOperationTurn)

        try container.encode(self.activityTypeValue, forKey: .activityType)
        try container.encode(self.buildTypeValue, forKey: .buildType)
        try container.encode(self.buildChargesValue, forKey: .buildCharges)
        try container.encode(self.automation, forKey: .automation)
    }

    // MARK: public methods

    public func name() -> String {

        return self.type.name()
    }
    
    public func isBarbarian() -> Bool {
       
        guard let player  = self.player else {
            fatalError("cant get player")
        }
        
        return player.isBarbarian()
    }
    
    public func isHuman() -> Bool {
       
        guard let player  = self.player else {
            fatalError("cant get player")
        }
        
        return player.isHuman()
    }

    public func unitClassType() -> UnitClassType {

        return self.type.unitClass()
    }

    public func civilianAttackPriority() -> CivilianAttackPriorityType {

        return self.type.civilianAttackPriority()
    }

    // MARK: health related methods

    public func healthPoints() -> Int {

        return self.healthPointsValue
    }

    public func maxHealthPoints() -> Int {

        return Int(Unit.maxHealth)
    }

    public func set(healthPoints: Int) {

        self.healthPointsValue = healthPoints
    }
    
    public func add(damage: Int) {
        
        self.healthPointsValue -= damage
    }

    private func healRate(at point: HexPoint, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            return 0
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        if player.isBarbarian() {
            return 0
        }

        var totalHeal = 0

        if gameModel.city(at: point) != nil {
            totalHeal += 10 // CITY_HEAL_RATE
        }
        
        // Heal from religion
        // next to a city or in the city - check for beliefs
        
        // Heal from units - medic / supply convoi
        var extraHealFromUnits: Int = 0
        for neightbor in point.neighbors() {
            
            if let unit = gameModel.unit(at: neightbor) {
                
                // friends or us
                if player.isEqual(to: unit.player) || diplomacyAI.isAllianceActive(with: unit.player) {
                    extraHealFromUnits += unit.type.healingAdjacentUnits()
                }
            }
        }

        // Heal from territory ownership (friendly, enemy, etc.)
        if let tile = gameModel.tile(at: point) {
            
            if tile.isFriendlyTerritory(for: self.player, in: gameModel) {
                totalHeal += 20
            } else if tile.isEnemyTerritory(for: self.player, in: gameModel) {
                totalHeal += 5
            } else {
                totalHeal += 10
            }
        }

        return totalHeal + extraHealFromUnits
    }

    public func canHeal(in gameModel: GameModel?) -> Bool {

        // No barb healing
        if self.isBarbarian() {
            return false
        }

        if self.damage() == 0 {
            return false
        }

        // Embarked Units can't heal
        if isEmbarked() {
            return false
        }

        if self.healRate(at: self.location, in: gameModel) == 0 {
            return false
        }

        return true
    }

    public func damage() -> Int {

        return max(0, Int(Unit.maxHealth) - self.healthPointsValue)
    }

    public func isHurt() -> Bool {

        return self.damage() > 0
    }

    public func doHeal(in gameModel: GameModel?) {

        // no heal for barbarians
        if self.isBarbarian() {
            return
        }

        self.healthPointsValue += self.healRate(at: self.location, in: gameModel)

        if self.healthPointsValue > Int(Unit.maxHealth) {
            self.healthPointsValue = Int(Unit.maxHealth)
        }
    }

    /// Current power of unit (raw unit type power adjusted for health)
    public func power() -> Int {

        var powerVal: Double = Double(self.type.power())

        // Take promotions into account: unit with 4 promotions worth ~50% more
        powerVal = powerVal * pow(Double(self.experienceLevel()), 0.3)

        let ratio = Double(self.healthPointsValue) / (2.0 * Unit.maxHealth) /* => 0..0.5 */ + 0.5 /* => 0.5..1.0 */
        return Int(powerVal * ratio)
    }

    public func isOutOfAttacks() -> Bool {

        // Units with blitz don't run out of attacks!
        /*if self.isBlitz() {
            return false
        }*/

        return self.numberOfAttacksMade >= self.numberOfAttacks
    }
    
    public func setMadeAttack(to newValue: Bool) {
        
        if newValue {
            self.numberOfAttacksMade += 1
        } else {
            self.numberOfAttacksMade = 0
        }
    }

    public func baseCombatStrength(ignoreEmbarked: Bool = true) -> Int {

        // FIXME
        if self.isEmbarked() && !ignoreEmbarked {
            if self.unitClassType() == .civilian {
                return 0
            } else {
                return 500 // FIXME
            }
        }

        return self.type.meleeStrength()
    }

    public func rangedCombatStrength(against defender: AbstractUnit?, or city: AbstractCity?, on toTile: AbstractTile?, attacking: Bool, in gameModel: GameModel?) -> Int {

        if self.baseRangedCombatStrength() == 0 {
            return 0
        }

        if self.range() == 0 {
            return 0
        }
        
        if self.isEmbarked() {
            return 0
        }

        var modifierValue = 0

        for modifier in self.attackStrengthModifier(against: defender, or: city, on: toTile, in: gameModel) {
            modifierValue += modifier.modifierValue
        }

        return self.baseRangedCombatStrength() + modifierValue
    }

    /// What is the max strength of this Unit when attacking?
    public func attackStrength(against defender: AbstractUnit?, or city: AbstractCity?, on toTile: AbstractTile? = nil, in gameModel: GameModel?) -> Int {

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }
        
        let isEmbarkedAttackingLand = isEmbarked() && (toTile != nil && toTile!.terrain().isLand())

        if self.isEmbarked() && !isEmbarkedAttackingLand {
            return 0
        }

        if self.baseCombatStrength(ignoreEmbarked: isEmbarkedAttackingLand) == 0 {
            return 0
        }

        var modifierValue = 0
        for modifier in self.attackStrengthModifier(against: defender, or: city, on: toTile, in: gameModel) {
            modifierValue += modifier.modifierValue
        }

        return self.baseCombatStrength(ignoreEmbarked: isEmbarkedAttackingLand)
    }
    
    public func attackStrengthModifier(against defender: AbstractUnit?, or city: AbstractCity?, on toTile: AbstractTile? = nil, in gameModel: GameModel?) -> [CombatModifier] {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let government = self.player?.government else {
            fatalError("cant get government")
        }
        
        guard let promotions = self.promotions else {
            fatalError("cant get promotions")
        }
        
        var result: [CombatModifier] = []
        
        // Healty
        let healthPenalty = -10 * (100 - self.healthPoints()) / 100
        if healthPenalty != 0 {
            result.append(CombatModifier(modifierValue: healthPenalty, modifierTitle: "Health penalty"))
        }
        
        ////////////////////////
        // GOVERNMENT
        ////////////////////////
        
        if government.currentGovernment() == .oligarchy {
        
            // All land melee, anti-cavalry, and naval melee class units gain +4 Civ6StrengthIcon Combat Strength.
            if self.unitClassType() == .melee || self.unitClassType() == .antiCavalry || self.unitClassType() == .navalMelee {
                result.append(CombatModifier(modifierValue: 4, modifierTitle: "Government Bonus"))
            }
        }
        
        if government.currentGovernment() == .fascism {
            
            // All units gain +5 Civ6StrengthIcon Combat Strength.
            result.append(CombatModifier(modifierValue: 5, modifierTitle: "Government Bonus"))
        }
        
        ////////////////////////
        // KNOWN DEFENDER UNIT
        ////////////////////////

        if let defender = defender {

            // +5 Civ6StrengthIcon Combat Strength when fighting Barbarians.
            if government.has(card: .discipline) && defender.isBarbarian() {
                result.append(CombatModifier(modifierValue: 5, modifierTitle: "Bonus for fighting Barbarians"))
            }
            
            if self.unitClassType() == .melee && defender.unitClassType() == .antiCavalry {
                result.append(CombatModifier(modifierValue: 10, modifierTitle: "Bonus against Anti-Cavalry"))
            }
            
            if self.unitClassType() == .antiCavalry && (defender.unitClassType() == .lightCavalry || defender.unitClassType() == .heavyCavalry) {
                result.append(CombatModifier(modifierValue: 10, modifierTitle: "Bonus against Cavalry"))
            }
            
            if self.unitClassType() == .ranged && (defender.unitClassType() == .navalMelee || defender.unitClassType() == .navalRaider || defender.unitClassType() == .navalRanged || defender.unitClassType() == .navalCarrier) {
                result.append(CombatModifier(modifierValue: -17, modifierTitle: "Penalty against Naval"))
            }
            
            // Siege units versus land units incur a -17 CS modifier.
            if self.unitClassType() == .siege && defender.domain() == .land {
                result.append(CombatModifier(modifierValue: -17, modifierTitle: "Penalty against Land units"))
            }
            
            // //////////
            // promotions
            // //////////

            if promotions.has(promotion: .battleCry) {
                // +7 Civ6StrengthIcon Combat Strength vs. melee and ranged units.
                if defender.unitClassType() == .melee || defender.unitClassType() == .ranged {
                    result.append(CombatModifier(modifierValue: 7, modifierTitle: "Battle Cry"))
                }
            }
        }

        ////////////////////////
        // KNOWN DEFENDER CITY
        ////////////////////////
        if let _ = city {
            
            if self.unitClassType() == .ranged {
                result.append(CombatModifier(modifierValue: -17, modifierTitle: "Penalty against City"))
            }
        }
        
        ////////////////////////
        // difficulty / handicap bonus
        ////////////////////////
        if self.isHuman() {
            let handicapBonus = gameModel.handicap.freeHumanCombatBonus()
            if handicapBonus != 0 {
                result.append(CombatModifier(modifierValue: handicapBonus, modifierTitle: "Bonus due to difficulty"))
            }
        } else if !self.isBarbarian() {
            let handicapBonus = gameModel.handicap.freeAICombatBonus()
            if handicapBonus != 0 {
                result.append(CombatModifier(modifierValue: handicapBonus, modifierTitle: "Bonus due to difficulty"))
            }
        }
        
        return result
    }
    
    public func attackModifier(against defender: AbstractUnit?, or city: AbstractCity?, on toTile: AbstractTile? = nil, in gameModel: GameModel?) -> Int {
        
        var modifierValue = 0
        for modifier in self.attackStrengthModifier(against: defender, or: city, on: toTile, in: gameModel) {
            modifierValue += modifier.modifierValue
        }

        return modifierValue
    }

    public func defensiveStrength(against attacker: AbstractUnit?, on toTile: AbstractTile?, ranged: Bool, in gameModel: GameModel?) -> Int {

        if self.isEmbarked() {
            if self.unitClassType() == .civilian {
                return 0
            } else {
                return 500 // FIXME
            }
        }

        if self.baseCombatStrength(ignoreEmbarked: true) == 0 {
            return 0
        }

        var modifierValue = 0
        for modifier in self.defensiveStrengthModifier(against: attacker, on: toTile, ranged: ranged, in: gameModel) {
            modifierValue += modifier.modifierValue
        }

        return self.baseCombatStrength(ignoreEmbarked: true) + modifierValue
    }
    
    public func defensiveStrengthModifier(against attacker: AbstractUnit?, on toTile: AbstractTile?, ranged: Bool, in gameModel: GameModel?) -> [CombatModifier] {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let promotions = self.promotions else {
            fatalError("cant get promotions")
        }
        
        var result: [CombatModifier] = []
        
        if self.isBarbarian() {
            return result
        }
        
        ////////////////////////
        // tile bonus
        ////////////////////////
        if let tile = toTile {
            if tile.hasHills() {
                if tile.has(feature: .forest) || tile.has(feature: .rainforest) {
                    result.append(CombatModifier(modifierValue: 6, modifierTitle: "Ideal terrain"))
                } else {
                    result.append(CombatModifier(modifierValue: 3, modifierTitle: "Ideal terrain"))
                }
            }
        }
        
        ////////////////////////
        // difficulty / handicap bonus
        ////////////////////////
        if self.isHuman() {
            let handicapBonus = gameModel.handicap.freeHumanCombatBonus()
            if handicapBonus != 0 {
                result.append(CombatModifier(modifierValue: handicapBonus, modifierTitle: "Bonus due to difficulty"))
            }
        } else if !self.isBarbarian() {
            let handicapBonus = gameModel.handicap.freeAICombatBonus()
            if handicapBonus != 0 {
                result.append(CombatModifier(modifierValue: handicapBonus, modifierTitle: "Bonus due to difficulty"))
            }
        }
        
        if let attacker = attacker {
            
            // //////////
            // promotions
            // //////////

            if promotions.has(promotion: .tortoise) {
                if attacker.isRanged() && ranged {
                    // +10 Combat Strength when defending against ranged attacks.
                    result.append(CombatModifier(modifierValue: 10, modifierTitle: "Tortoise promotion"))
                }
            }
        }
        
        return result
    }

    public func defenseModifier(against attacker: AbstractUnit?, on toTile: AbstractTile?, ranged: Bool,in gameModel: GameModel?) -> Int {
        
        var modifierValue = 0
        for modifier in self.defensiveStrengthModifier(against: attacker, on: toTile, ranged: ranged, in: gameModel) {
            modifierValue += modifier.modifierValue
        }

        return modifierValue
    }

    // Combat eligibility routines
    public func isCombatUnit() -> Bool {

        return self.type.meleeStrength() > 0
    }

    public func isRanged() -> Bool {

        return self.type.range() > 0
    }

    public func canMoveOrAttack(into point: HexPoint) -> Bool {

        fatalError("not implemented")
    }

    func canAttackWithMove() -> Bool {

        if self.isCombatUnit() {
            return true
        }

        return false
    }

    public func canAttack() -> Bool {

        return self.canAttackWithMove() || canAttackRanged()
    }

    // Returns true if attack was made...
    // UnitAttack in civ5
    public func doAttack(into destination: HexPoint, /* flags */ steps: Int, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let destPlot = gameModel.tile(at: destination) else {
            return false
        }

        guard let unitPlayer = self.player else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        if unitPlayer.isHuman() {

            if let defenderUnit = gameModel.unit(at: destination) {

                if !diplomacyAI.isAtWar(with: defenderUnit.player) && !defenderUnit.isBarbarian() {

                    gameModel.userInterface?.showPopup(popupType: .declareWarQuestion, with: PopupData(player: defenderUnit.player))
                    return false
                }
            }
        }

        guard let path = self.pathIgnoreUnits(towards: destination, in: gameModel) else {
            return false
        }

        var attack = false
        let adjacent = path.count == 2

        if adjacent {

            if self.isOutOfAttacks() {
                return false
            }
            // don't allow an attack if we already have one
            /*if (isFighting() || pDestPlot->isFighting())
                {
                    return true;
                }*/

            // Air mission
            if self.domain() == .air && self.baseCombatStrength() == 0 {

                if self.canRangeStrike(at: destination, needWar: false, noncombatAllowed: true) {
                    //CvUnitCombat::AttackAir(*this, *pDestPlot, (iFlags &  MISSION_MODIFIER_NO_DEFENSIVE_SUPPORT)?CvUnitCombat::ATTACK_OPTION_NO_DEFENSIVE_SUPPORT:CvUnitCombat::ATTACK_OPTION_NONE);
                    fatalError("niy")
                    attack = true
                }
            } else if destPlot.isCity() { // City combat
                if let city = gameModel.city(at: destination) {
                    if diplomacyAI.isAtWar(with: city.player) {
                        if self.domain() == .land {
                            
                            // Ranged units that are embarked can't do a move-attack
                            if self.isRanged() && self.isEmbarked() {
                                return false
                            }

                            //CvUnitCombat::AttackCity(*this, *pDestPlot, (iFlags &  MISSION_MODIFIER_NO_DEFENSIVE_SUPPORT)?CvUnitCombat::ATTACK_OPTION_NO_DEFENSIVE_SUPPORT:CvUnitCombat::ATTACK_OPTION_NONE);
                            
                            attack = true
                            
                            let result = Combat.predictMeleeAttack(between: self, and: city, in: gameModel)
                            print("result: \(result)")
                            
                            // fatalError("niy")
                        }
                    }
                }
            } else { // Normal unit combat
                // if there are no defenders, do not attack
                guard let defenderUnit = gameModel.unit(at: destination) else {
                    return false
                }

                // Ranged units that are embarked can't do a move-attack
                if self.isRanged() && self.isEmbarked() {
                    return false
                }

                attack = true

                Combat.doMeleeAttack(between: self, and: defenderUnit, in: gameModel)
            }

            // Barb camp here that was attacked?
            if destPlot.improvement() == .barbarianCamp {
                gameModel.doCampAttacked(at: destPlot.point)
            }
        }

        return attack
    }

    func baseRangedCombatStrength() -> Int {

        return self.type.rangedStrength()
    }

    /// Does this unit have a ranged attack?
    public func canAttackRanged() -> Bool {

        return self.range() > 0 && self.baseRangedCombatStrength() > 0
    }
    
    public func canMoveAfterAttacking() -> Bool {
        
        return false
    }

    public func doRangeAttack(at target: HexPoint, in gameModel: GameModel?) -> Bool {

        fatalError("niy")
    }

    public func canRangeStrike(at point: HexPoint, needWar: Bool, noncombatAllowed: Bool) -> Bool {

        if !self.canAttackRanged() {
            return false
        }

        // @FIXME
        /*if !self.canEverRangeStrike(at: point) {
            return false
        }*/

        /*CvPlot* pTargetPlot = GC.getMap().plot(iX, iY);

        // If it's NOT a city, see if there are any units to aim for
        if (!pTargetPlot->isCity())
        {
            if (bNeedWar)
            {
                const CvUnit* pDefender = airStrikeTarget(*pTargetPlot, bNoncombatAllowed);
                if (NULL == pDefender)
                {
                    return false;
                }
            }
            // We don't need to be at war (yet) with a Unit here, so let's try to find one
            else
            {
                const IDInfo* pUnitNode = pTargetPlot->headUnitNode();
                const CvUnit* pLoopUnit;
                bool bFoundUnit = false;

                CvTeam& myTeam = GET_TEAM(getTeam());

                while (pUnitNode != NULL)
                {
                    pLoopUnit = ::getUnit(*pUnitNode);
                    pUnitNode = pTargetPlot->nextUnitNode(pUnitNode);

                    if(!pLoopUnit) continue;

                    TeamTypes loopTeam = pLoopUnit->getTeam();

                    // Make sure it's a valid Team
                    if ( myTeam.isAtWar(loopTeam) || myTeam.canDeclareWar(loopTeam) )
                    {
                        bFoundUnit = true;
                        break;
                    }
                }

                if (!bFoundUnit)
                {
                    return false;
                }
            }
        }
        // If it is a City, only consider those we're at war with
        else
        {
            CvAssert(pTargetPlot->getPlotCity() != NULL);

            // If you're already at war don't need to check
            if (!atWar(getTeam(), pTargetPlot->getPlotCity()->getTeam()))
            {
                if (bNeedWar)
                {
                    return false;
                }
                // Don't need to be at war with this City's owner (yet)
                else
                {
                    if (!GET_TEAM(getTeam()).canDeclareWar(pTargetPlot->getPlotCity()->getTeam()))
                    {
                        return false;
                    }
                }
            }
        }*/

        return true
    }

    /// Unit able to fight back when attacked?
    public func canDefend() -> Bool {

        // This will catch both embarked units and noncombatants
        if self.baseCombatStrength() == 0 {
            return false
        }

        return true
    }

    public func canSentry(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("Cant get gameModel")
        }

        guard let tile = gameModel.tile(at: self.location) else {
            fatalError("Cant get tile")
        }

        // you're not allowed to sentry in a city
        if tile.isCity() {
            return false
        }

        if !self.canDefend() {
            return false
        }

        if self.isWaiting() {
            return false
        }

        return true
    }

    public func isWaiting() -> Bool {

        return self.activityTypeValue == .hold || self.activityTypeValue == .sleep || self.activityTypeValue == .heal || self.activityTypeValue == .sentry || self.activityTypeValue == .intercept
    }

    //    ---------------------------------------------------------------------------
    // Get the base movement points for the unit.
    // Parameters:
    //        eIntoDomain    - If NO_DOMAIN, this will use the units current domain.
    //                      This can give different results based on whether the unit is currently embarked or not.
    //                      Passing in DOMAIN_SEA will return the units baseMoves as if it were already embarked.
    //                      Passing in DOMAIN_LAND will return the units baseMoves as if it were on land, even if it is currently embarked.
    public func baseMoves(into domain: UnitDomainType = .none, in gameModel: GameModel?) -> Int {

        guard let ability = self.player?.leader.ability() else {
            fatalError("cant get ability")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        if (domain == .sea && self.canEmbark(in: gameModel)) || (domain == .none && self.isEmbarked()) {

            return 2 /* EMBARKED_UNIT_MOVEMENT */
        }

        var extraNavalMoves = 0
        if domain == .sea {

            extraNavalMoves = self.extraNavalMoves(in: gameModel)
        }

        let extraGoldenAgeMoves = 0

        let extraUnitCombatTypeMoves = 0 // ???
        return self.type.moves() /*+ self.extraMoves()*/ + extraNavalMoves + extraGoldenAgeMoves + extraUnitCombatTypeMoves
    }

    public func path(towards target: HexPoint, in gameModel: GameModel?) -> HexPath? {

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel?.unitAwarePathfinderDataSource(for: self.movementType(), for: self.player)

        if let path = pathFinder.shortestPath(fromTileCoord: self.location, toTileCoord: target) {

            // add current location
            path.prepend(point: self.location, cost: 0.0)

            return path
        }

        return nil
    }
    
    public func pathIgnoreUnits(towards target: HexPoint, in gameModel: GameModel?) -> HexPath? {

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel?.ignoreUnitsPathfinderDataSource(for: self.movementType(), for: self.player)

        if let path = pathFinder.shortestPath(fromTileCoord: self.location, toTileCoord: target) {

            // add current location
            path.prepend(point: self.location, cost: 0.0)

            return path
        }

        return nil
    }

    // UnitPathTo
    // Returns the number of turns it will take to reach the target.
    // If no move was made it will return 0.
    // If it can reach the target in one turn or less than one turn (i.e. not use up all its movement points) it will return 1
    public func doMoveOnPath(towards target: HexPoint, previousETA: Int, buildingRoute: Bool, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        /*guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get humanPlayer")
        }*/

        if self.location == target {
            print("Already at location")
            return 0
        }

        var pathPlot: AbstractTile? = nil

        guard let targetPlot = gameModel.tile(at: target) else {
            print("Destination is not a valid plot location")
            return 0
        }

        guard let path = self.path(towards: target, in: gameModel) else {
            print("Unable to generate path with BuildRouteFinder")
            return 0
        }

        if self.domain() == .air {

            if !self.canMove(into: target, options: MoveOptions.none, in: gameModel) {
                return 0
            }

            pathPlot = targetPlot
        } else {

            if buildingRoute {

                if let (secondPlot, _) = path.second {
                    pathPlot = gameModel.tile(at: secondPlot)
                }

                if pathPlot == nil || !self.canMove(into: target, options: MoveOptions.none, in: gameModel) {
                    // add route interrupted
                    gameModel.humanPlayer()?.notifications()?.addNotification(of: .generic, for: self.player, message: "Your worker that was ordered to build a route to a destination is blocked and cancelled his order.", summary: "Route to cancelled!", at: self.location)

                    return 0
                }
            } else {

                if let (secondPlot, _) = path.second {
                    pathPlot = gameModel.tile(at: secondPlot)
                }
            }
        }

        var rejectMove = false

        // handle empty path
        if path.count != 0 {

            guard let (_, firstCost) = path.first else {
                fatalError("bla")
            }

            if previousETA >= 0 && Int(firstCost) > previousETA + 2 {
                //LOG_UNIT_MOVES_MESSAGE_OSTR(std::string("Rejecting move iPrevETA=") << iPrevETA << std::string(", m_iData2=") << kNode.m_iData2);
                rejectMove = true
            }

            // if we should end our turn there this turn, but can't move into that tile
            if Int(firstCost) == 1 && !self.canMove(into: target, options: MoveOptions.none, in: gameModel) {
                // this is a bit tricky
                // we want to see if this move would be a capture move
                // Since we can't move into the tile, there may be an enemy unit there
                // We can't move into tiles with enemy combat units, so getBestDefender should return null on the tile
                // If there is no defender but we can attack move into the tile, then we know that it is a civilian unit and we should be able to move into it
                /*const UnitHandle pDefender = pDestPlot->getBestDefender(NO_PLAYER, getOwner(), this, true);
                if (!pDefender && !pDestPlot->isEnemyCity(*this) && canMoveInto(*pDestPlot, MOVEFLAG_ATTACK | MOVEFLAG_PRETEND_CORRECT_EMBARK_STATE))
                {
                    // Turn on ability to move into enemy units in this case so we can capture civilians
                    iFlags |= MOVE_UNITS_THROUGH_ENEMY;
                }*/

                if let mission = self.peekMission() {
                    if mission.startedInTurn != gameModel.currentTurn {
                        //LOG_UNIT_MOVES_MESSAGE_OSTR(std::string("Rejecting move pkMissionData->iPushTurn=") << pkMissionData->iPushTurn << std::string(", GC.getGame().getGameTurn()=") << GC.getGame().getGameTurn());
                        rejectMove = true
                    }
                }
            }

            if rejectMove {
                //m_kLastPath.clear();
                // slewis - perform its queued moves?
                self.publishQueuedVisualizationMoves(in: gameModel)
                return 0
            }
        }

        var usedPathCost = 0.0
        
        for (index, point) in path.enumerated() {
            
            // skip first point
            if index == 0 {
                continue
            }

            if self.doMove(on: point, in: gameModel) {
                
                usedPathCost += path[index].1
            }
        }

        self.publishQueuedVisualizationMoves(in: gameModel)

        if path.count > 0 {
            return (Int(path.cost - usedPathCost)) / self.maxMoves(in: gameModel)
        }

        return 1
    }

    public func doMove(on target: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let targetPlot = gameModel.tile(at: target) else {
            fatalError("cant get targetPlot")
        }

        guard let oldPlot = gameModel.tile(at: self.location) else {
            fatalError("cant get oldPlot")
        }

        let costDataSource = gameModel.unitAwarePathfinderDataSource(for: self.movementType(), for: self.player)

        if !self.canMove() {
            return false
        }

        var shouldDeductCost: Bool = true
        let moveCost = costDataSource.costToMove(fromTileCoord: self.location, toAdjacentTileCoord: target)

        // we need to get our dis/embarking on
        if self.canEverEmbark() && targetPlot.terrain().isWater() != oldPlot.terrain().isWater() {

            if oldPlot.terrain().isWater() {

                if self.isEmbarked() {

                    // moving from water to the land
                    /*if self.moveLocations.count > 0 {
                        // If we have some queued moves, execute them now, so that the disembark is done at the proper location visually
                        self.publishQueuedVisualizationMoves(in: gameModel)
                    }*/

                    self.doDisembark(in: gameModel)
                }
            } else {
                if !self.isEmbarked() && self.canEmbark(into: target, in: gameModel) {

                    // moving from land to the water
                    /*if self.moveLocations.count > 0 {
                        // If we have some queued moves, execute them now, so that the disembark is done at the proper location visually
                        self.publishQueuedVisualizationMoves(in: gameModel)
                    }*/

                    self.doEmbark(in: gameModel)
                    self.finishMoves()
                    shouldDeductCost = false
                }
            }
        }

        if shouldDeductCost {
            self.movesValue -= Int(moveCost)

            if self.movesValue < 0 {
                self.movesValue = 0
            }
        }

        self.set(location: target, in: gameModel)

        return true
    }
    
    // TODO: move to UnitType
    public func captureUnitType() -> UnitType {
        
        // cant capture settlers
        if self.type == .settler {
            return .builder
        }
        
        return self.type
    }
    
    // TODO: move to UnitType
    public func canCapture() -> Bool {
        
        return self.type.has(ability: .canCapture)
        /*switch self.type.unitClass() {
            
        case .civilian, .ranged, .siege, .navalRanged, .navalCarrier, .airFighter, .airBomber, .support, .city:
            return false
        case .melee, .recon, .antiCavalry, .lightCavalry, .heavyCavalry, .navalMelee, .navalRaider:
            return true
        }*/
    }

    private func captureDefinition(by capturePlayer: AbstractPlayer?) -> UnitCaptureDefinition? {

        var captureDef = UnitCaptureDefinition(oldPlayer: self.player,
                                               originalOwner: self.player,
                                               oldType: self.type,
                                               capturingPlayer: capturePlayer,
                                               embarked: self.isEmbarkedValue,
                                               captureUnitType: nil,
                                               location: self.location)

        // Barbs captured this unit, or a player capturing this unit from the barbs
        if self.isBarbarian() || captureDef.capturingPlayer != nil && captureDef.capturingPlayer!.isBarbarian() {

            // Must be able to capture this unit normally... don't want the barbs picking up Workboats, Generals, etc.
            if captureDef.capturingPlayer != nil && captureUnitType().baseType() != nil {

                // Unit type is the same as what it was
                captureDef.captureUnitType = self.type
            }
        } else {
            // Barbs not involved
            if captureDef.capturingPlayer != nil {
                // captureDef.captureUnitType = getCaptureUnitType(GET_PLAYER(kCaptureDef.eCapturingPlayer).getCivilizationType());
                fatalError("special unit captured - not supported yet")
            }
        }

        return captureDef.capturingPlayer == nil || captureDef.captureUnitType == nil ? nil : captureDef
    }

    private func set(location newLocation: HexPoint, group: Bool = false, update: Bool = false, show showValue: Bool = false, checkPlotVisible: Bool = false, noMove: Bool = false, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        var unitCaptureDefinition: UnitCaptureDefinition? = nil

        var show = showValue

        let ownerIsActivePlayer = player.isEqual(to: gameModel.activePlayer())

        // Delay any popups that might be caused by our movement (goody huts, natural wonders, etc.) so the unit movement event gets sent before the popup event.
        if ownerIsActivePlayer {
            //DLLUI->SetDontShowPopups(true);
        }

        let oldActivityType = self.activityType()

        /*if self.isSetUpForRangedAttack() {
            self.setUpForRangedAttack(false)
        }*/

        /*if !group || self.isCargo() {
            show = false
        }*/

        guard let oldPlot = gameModel.tile(at: self.location) else {
            fatalError("cant get old tile")
        }

        guard let newPlot = gameModel.tile(at: newLocation) else {
            fatalError("cant get new tile")
        }

        if !noMove {

            /*if let transportUnit = self.transportUnit() {
                if (!(pTransportUnit->atPlot(*pNewPlot)))
                {
                    setTransportUnit(NULL);
                }
            }*/

            if self.isCombatUnit() {

                if let loopUnit = gameModel.unit(at: newLocation) {

                    guard let loopPlayer = loopUnit.player else {
                        fatalError("cant get loop player")
                    }

                    if !loopUnit.isDelayedDeath() {

                        if diplomacyAI.isAtWar(with: loopUnit.player) {

                            if loopUnit.type.captureType() == nil && loopUnit.canDefend() { // Unit somehow ended up on top of an enemy combat unit

                                fatalError("should not happen - this is a combat scenario")

                            } else { // Ran into a noncombat unit

                                var doCapture = false
                                var strMessage = ""
                                var strSummary = ""

                                // Some units can't capture civilians. Embarked units are also not captured, they're simply killed. And some aren't a type that gets captured.
                                if self.type.has(ability: .canCapture) && !loopUnit.isEmbarked() && loopUnit.type.captureType() != nil {

                                    doCapture = true
                                    
                                    if isBarbarian() {
                                        strMessage = "TXT_KEY_UNIT_CAPTURED_BARBS_DETAILED"
                                        // strMessage << pLoopUnit->getUnitInfo().GetTextKey();
                                        strSummary = "TXT_KEY_UNIT_CAPTURED_BARBS"
                                    } else {
                                        strMessage = "TXT_KEY_UNIT_CAPTURED_DETAILED"
                                        // strMessage << pLoopUnit->getUnitInfo().GetTextKey() << GET_PLAYER(getOwner()).getNameKey();
                                        strSummary = "TXT_KEY_UNIT_CAPTURED"
                                    }
                                    
                                } else { // Unit was killed instead

                                    if loopUnit.isEmbarked() {
                                        self.changeExperience(by: 1, in: gameModel)
                                    }
                                    
                                    gameModel.userInterface?.showTooltip(at: self.location, text: "TXT_KEY_MISC_YOU_UNIT_DESTROYED_ENEMY", delay: 3)

                                    strMessage = "TXT_KEY_UNIT_LOST"
                                    strSummary = strMessage;

                                    player.reportCultureFromKills(at: newLocation, culture: loopUnit.baseCombatStrength(ignoreEmbarked: true), wasBarbarian: loopPlayer.isBarbarian(), in: gameModel)
                                    player.reportGoldFromKills(at: newLocation, gold: loopUnit.baseCombatStrength(ignoreEmbarked: true), in: gameModel)
                                }
                                
                                if let notifications = loopUnit.player?.notifications() {
                                    notifications.addNotification(of: .unitDied, for: loopPlayer, message: strMessage, summary: strSummary, at: loopUnit.location, other: self.player)
                                }

                                if loopUnit.isEmbarked() {
                                    self.setMadeAttack(to: true)
                                }

                                // If we're capturing the unit, we want to delay the capture, else as the unit is converted to our side, it will be the first unit on our
                                // side in the plot and can end up taking over a city, rather than the advancing unit
                                if doCapture {
                                    unitCaptureDefinition = self.captureDefinition(by: self.player)
                                }

                                loopUnit.doKill(delayed: false, by: self.player, in: gameModel)
                            }

                        }
                    }
                }
            }
        }

        // if leaving a city, reveal the unit
        if oldPlot.isCity() {
            // if pNewPlot is a valid pointer, we are leaving the city and need to visible
            // if pNewPlot is NULL than we are "dead" (e.g. a settler) and need to blend out
            if newPlot.isVisible(to: gameModel.humanPlayer()) {

                gameModel.userInterface?.show(unit: self)
            }
        }

        if self.isGarrisoned() {
            self.unGarrison(in: gameModel)
        }

        gameModel.conceal(at: oldPlot.point, sight: self.sight(), for: player)
        //oldPlot->area()->changeUnitsPerPlayer(getOwner(), -1);
        //self.set(lastMoveTurn: gameModel.turnSlice())
        let oldCity = gameModel.city(at: oldPlot.point)

        self.location = newLocation

        // update facing direction
        if let newDirection = oldPlot.point.direction(towards: newLocation) {
            self.facingDirection = newDirection
        }

        // update cargo mission animations
        /*if self.isCargo() {
            if oldActivityType != ACTIVITY_MISSION {
                self.setActivityType(eOldActivityType);
            }
        }*/

        // if entering a city, hide the unit
        if newPlot.isCity() {
            gameModel.userInterface?.hide(unit: self)
        }

        self.doMobilize(in: gameModel) // unfortify

        // needs to be here so that the square is considered visible when we move into it...
        gameModel.sight(at: newLocation, sight: self.sight(), for: player, in: gameModel)
        //newPlot->area()->changeUnitsPerPlayer(getOwner(), 1);
        var newCityRef = gameModel.city(at: newPlot.point)

        // Moving into a City (friend or foe)
        if let newCity = newCityRef {

            newCity.updateStrengthValue(in: gameModel)

            if diplomacyAI.isAtWar(with: newCity.player) {

                player.acquire(city: newCity, conquest: true, gift: false)
                newCityRef = nil

                // TODO liberation city for ally
            }
        }

        if oldCity != nil {
            oldCity?.updateStrengthValue(in: gameModel)
        }

        // carrier ?
        /*if shouldLoadOnMove(pNewPlot) {
            load();
        }*/

        // Can someone can see the plot we moved our Unit into?
        for loopPlayer in gameModel.players {

            if player.isEqual(to: loopPlayer) {
                continue
            }

            if loopPlayer.isAlive() {

                // Human can't be met by an AI spotting him.
                if !player.isHuman() || loopPlayer.isHuman() {
                    
                    if newPlot.isVisible(to: loopPlayer) {
                        
                        // check if we have met this guy already
                        if !player.hasMet(with: loopPlayer) {
                            
                            // do the hello, if not
                            loopPlayer.doFirstContact(with: player, in: gameModel)
                            player.doFirstContact(with: loopPlayer, in: gameModel)
                        }
                    }
                }
            }
        }

        // If a Unit is adjacent to someone's borders, meet them
        for adjacentPoint in newLocation.neighbors() {

            if let adjacentPlot = gameModel.tile(at: adjacentPoint) {

                // Owned by someone
                if let adjacentOwner = adjacentPlot.owner() {
                    
                    if !player.isEqual(to: adjacentOwner) && !player.hasMet(with: adjacentOwner) && adjacentOwner.isAlive() {
                        diplomacyAI.doFirstContact(with: adjacentOwner, in: gameModel)
                        adjacentOwner.doFirstContact(with: player, in: gameModel)
                    }
                }

                // Have a naval unit here?
                if self.isBarbarian() && self.domain() == .sea && adjacentPlot.terrain().isWater() {

                    /*UnitHandle pAdjacentUnit = pAdjacentPlot->getBestDefender(NO_PLAYER, BARBARIAN_PLAYER, NULL, true);
                    if (pAdjacentUnit)
                    {
                        GET_PLAYER(pAdjacentUnit->getOwner()).GetPlayerTraits()->CheckForBarbarianConversion(pAdjacentPlot);
                    }*/
                }

                // Natural wonder that provides free promotions?
                let feature = adjacentPlot.feature()
                if feature.isWonder() {

                    /*PromotionTypes ePromotion = (PromotionTypes)GC.getFeatureInfo(eFeature)->getAdjacentUnitFreePromotion();
                    if (ePromotion != NO_PROMOTION)
                    {
                        // Is this a valid Promotion for the UnitCombatType?
                        if (m_pUnitInfo->GetUnitCombatType() != NO_UNITCOMBAT && ::IsPromotionValidForUnitCombatType(ePromotion, getUnitType()))
                        {
                            setHasPromotion(ePromotion, true);
                        }
                    }*/
                }
            }
        }

        if self.domain() == .sea {
            // player.GetPlayerTraits()->CheckForBarbarianConversion(pNewPlot);
        }

        // override show, if check plot visible
        if checkPlotVisible && newPlot.isVisible(to: gameModel.humanPlayer()) || oldPlot.isVisible(to: gameModel.humanPlayer()) {
            show = true
        }

        if show {
            //self.queueMoveForVisualization(at: oldPlot.point, in: gameModel)
            self.queueMoveForVisualization(at: newPlot.point, in: gameModel)
        } else {
            // teleport
            // SetPosition(pNewPlot);
        }

        /*if self.hasCargo() {
            pUnitNode = pOldPlot->headUnitNode();

            while (pUnitNode != NULL)
            {
                pLoopUnit = ::getUnit(*pUnitNode);
                pUnitNode = pOldPlot->nextUnitNode(pUnitNode);

                if (pLoopUnit && pLoopUnit->getTransportUnit() == this)
                {
                    pLoopUnit->setXY(iX, iY, bGroup, bUpdate);

                    // Reset to head node since we just moved some cargo around, and the unit storage in the plot is going to be different now
                    pUnitNode = pOldPlot->headUnitNode();
                }
            }
        }*/

        if !noMove {

            if newPlot.has(improvement: .goodyHut) {
                self.player?.doGoodyHut(at: newPlot, by: self, in: gameModel)
            }

            if !self.isBarbarian() {

                if newPlot.improvement() == .barbarianCamp {

                    // See if we need to remove a temporary dominance zone
                    player.tacticalAI?.deleteTemporaryZone(at: newPlot.point)

                    let numGold = gameModel.handicap.barbarianCampGold()

                    // Normal way to handle it
                    if player.isEqual(to: gameModel.humanPlayer()) {
                        gameModel.userInterface?.showTooltip(at: newPlot.point, text: "TXT_KEY_MISC_DESTROYED_BARBARIAN_CAMP", delay: 3.0)
                    }

                    newPlot.set(improvement: .none)

                    gameModel.doBarbCampCleared(at: newPlot.point)

                    player.treasury?.changeGold(by: Double(numGold))

                    // Set who last cleared the camp here
                    //newPlot->SetPlayerThatClearedBarbCampHere(getOwner());

                    // If it's the active player then show the popup
                    if player.isEqual(to: gameModel.humanPlayer()) {

                        gameModel.userInterface?.showPopup(popupType: .barbarianCampCleared, with: PopupData(money: numGold))

                        // We are adding a popup that the player must make a choice in, make sure they are not in the end-turn phase.
                        // FIXME self.cancelActivePlayerEndTurn();
                    }
                }
            }
        }

        // New plot location is owned by someone
        if let plotOwner = newPlot.owner() {

            // If we're in friendly territory and we can embark, give the promotion for free
            if newPlot.isFriendlyTerritory(for: self.player, in: gameModel) {

                if player.canEmbark() {

                    guard let promotions = self.promotions else {
                        fatalError("cant get promotions")
                    }
                    
                    if !promotions.has(promotion: .embarkation) {
                    
                        var givePromotion = false
                        
                        // Civilians get it for free
                        if self.domain() == .land {
                            if !self.isCombatUnit() {
                                givePromotion = true
                            }
                        }
                        
                        // Can the unit get this? (handles water units and such)
                        if !givePromotion && self.domain() == .land {
                            givePromotion = true
                        }
                        
                        // Some case that gives us the promotion?
                        if givePromotion {
                            try! self.promotions?.earn(promotion: .embarkation)
                        }
                    }
                }
            }

            // Are we in enemy territory? If so, give notification to owner
            if diplomacyAI.isAtWar(with: plotOwner) {

                if plotOwner.isEqual(to: gameModel.humanPlayer()) {
                    self.player?.notifications()?.addNotification(of: .enemyInTerritory, for: self.player, message: "An enemy unit has been spotted in our territory!", summary: "An Enemy is Near!", at: newLocation)
                }
            }
        }

        // Create any units we captured, now that we own the destination
        if let unitCaptureDefinition = unitCaptureDefinition {
            self.createCaptureUnit(from: unitCaptureDefinition)
        }

        /*if self.isSelected() {
            gDLL->GameplayMinimapUnitSelect(iX, iY);
        }*/

        // setInfoBarDirty(true)

        // if there is an enemy city nearby, alert any scripts to this
        /*int iAttackRange = GC.getCITY_ATTACK_RANGE();
        for (int iDX = -iAttackRange; iDX <= iAttackRange; iDX++)
        {
            for (int iDY = -iAttackRange; iDY <= iAttackRange; iDY++)
            {
                CvPlot* pTargetPlot = plotXYWithRangeCheck(getX(), getY(), iDX, iDY, iAttackRange);
                if (pTargetPlot && pTargetPlot->isCity())
                {
                    if (isEnemy(pTargetPlot->getTeam()))
                    {
                        // do it
                        CvCity* pkPlotCity = pTargetPlot->getPlotCity();
                        auto_ptr<ICvCity1> pPlotCity = GC.WrapCityPointer(pkPlotCity);
                        DLLUI->SetSpecificCityInfoDirty(pPlotCity.get(), CITY_UPDATE_TYPE_ENEMY_IN_RANGE);
                    }
                }
            }
        }*/

        if ownerIsActivePlayer {
            // DLLUI->SetDontShowPopups(false);
        }
    }

    @discardableResult public func jumpToNearestValidPlotWithin(range: Int, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("Cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("Cant get player")
        }

        guard let currentTile = gameModel.tile(at: self.location) else {
            fatalError("Cant get current tile")
        }

        var bestValue = Int.max
        var bestPlot: AbstractTile? = nil

        for pt in self.location.areaWith(radius: range) {

            guard let loopPlot = gameModel.tile(at: pt) else {
                continue
            }

            if loopPlot.isValidDomainFor(unit: self) {

                if self.canMove(into: loopPlot.point, options: MoveOptions.none, in: gameModel) {

                    if gameModel.unit(at: loopPlot.point) == nil {
                        if !loopPlot.hasOwner() || player.isEqual(to: loopPlot.owner()) {

                            if loopPlot.isDiscovered(by: player) {

                                var value = loopPlot.point.distance(to: self.location)

                                if loopPlot.continentIdentifier() != currentTile.continentIdentifier() {
                                    value = value * 3
                                }

                                if value < bestValue {
                                    bestValue = value
                                    bestPlot = loopPlot
                                }
                            }
                        }
                    }
                }
            }
        }

        if let bestPlot = bestPlot {
            print("Jump to nearest valid plot within range by \(self.type) , X: \(bestPlot.point.x), Y: \(bestPlot.point.y), From X: \(self.location.x), Y: \(self.location.y)")
            self.set(location: bestPlot.point, in: gameModel)
        } else {
            print("Can't find a valid plot within range. for \(self.type), at X: \(self.location.x), Y: \(self.location.y)")
            return false
        }

        return true
    }

    //    ---------------------------------------------------------------------------
    //    Create a new unit using a capture definition.
    //    Returns the unit if create or NULL is the definition is not valid, or something else
    //    goes awry.
    //
    //    Please note this method is static because it is often called AFTER the original unit
    //    has been deleted.
    func createCaptureUnit(from definition: UnitCaptureDefinition) {

        fatalError("niy")
    }

    public func publishQueuedVisualizationMoves(in gameModel: GameModel?) {

        if self.moveLocations.count > 0 {
            
            // check moveLocations for duplicates
            self.moveLocations = self.moveLocations.unique(map: { $0 })
            
            gameModel?.userInterface?.move(unit: self, on: self.moveLocations)

            self.moveLocations = []
        }
    }

    public func queueMoveForVisualization(at point: HexPoint, in gameModel: GameModel?) {

        self.moveLocations.append(point)

        if self.moveLocations.count == 20 /*|| self.isHuman()*/ {
            self.publishQueuedVisualizationMoves(in: gameModel)
        }
    }

    public func isImpassable(tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        let terrain = tile.terrain()

        return self.isImpassable(terrain: terrain)
    }

    func extraNavalMoves(in gameModel: GameModel?) -> Int {

        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        var extraNavalMoves: Int = 0
        
        if player.has(wonder: .greatLighthouse, in: gameModel) {
            // +1 Civ6Movement Movement for all naval units.
            extraNavalMoves += 1
        }
        
        // check promotions here?

        // FIXME
        //self.promotions?.has(promotion: <#T##UnitPromotionType#>)
        return extraNavalMoves
    }

    public func canMove() -> Bool {

        return self.moves() > 0
    }

    public func canMove(into point: HexPoint, options: MoveOptions, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }

        if self.location == point {
            return true
        }

        guard let tile = gameModel.tile(at: point) else {
            return false
        }
        
        // Barbarians have special restrictions early in the game
        if self.isBarbarian() && gameModel.areBarbariansReleased() && tile.hasOwner() {
            return false
        }
        
        if options.contains(.attack) {
            
            if self.isOutOfAttacks() {
                return false
            }
        }

        if self.isImpassable(tile: tile) {
            return false
        }

        if gameModel.isEnemyVisible(at: point, for: self.player) {
            return false
        }

        if gameModel.unit(at: point) != nil {
            return false
        }
        
        let owner = tile.owner()
        if !self.canEnterTerritory(of: owner, ignoreRightOfPassage: false, isDeclareWarMove: options.contains(.declareWar)) {
            
            if !player.canDeclareWar(to: owner) {
                return false;
            }

            if player.isHuman() {
                if !options.contains(.declareWar) {
                    return false
                }
            } else {
                return false
            }
        }

        return true
    }
    
    public func canEnterTerritory(of otherPlayer: AbstractPlayer?, ignoreRightOfPassage: Bool = false, isDeclareWarMove: Bool = false) -> Bool {

        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        if otherPlayer == nil {
            return true
        }

        /*if self.player.isFriendlyTerritory(eTeam))
        {
            return true;
        }*/

        if diplomacyAI.isAtWar(with: otherPlayer) {
            return true
        }

        /*if(isRivalTerritory()) {
            return true;
        }*/

        if !ignoreRightOfPassage {
            if diplomacyAI.isOpenBorderAgreementActive(by: otherPlayer) {
                return true
            }
        }

        return false
    }

    public func canGarrison(at point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // garrison only in cities
        guard gameModel.city(at: point) != nil else {
            return false
        }

        // only one unit per tile or we are the 
        guard gameModel.unit(at: point) == nil || self.location == point else {
            return false
        }

        return true
    }

    public func isGarrisoned() -> Bool {

        return self.garrisonedValue
    }

    @discardableResult
    public func doGarrison(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // garrison only in cities
        guard let city = gameModel.city(at: self.location) else {
            return false
        }

        if !self.canGarrison(at: self.location, in: gameModel) {
            return false
        }

        city.setGarrison(unit: self)
        self.garrisonedValue = true

        return true
    }

    public func unGarrison(in gameModel: GameModel?) {
        self.garrisonedValue = false
    }

    public func readyToMove() -> Bool {

        if !self.canMove() {
            return false
        }

        if self.isGarrisoned() {
            return false
        }

        if self.missions.count != 0 {
            return false
        }

        if self.activityTypeValue != .none && self.activityTypeValue != .awake {
            return false
        }

        if self.automation != .none {
            return false
        }

        /*if self.isbusy() {
            return false
        }*/

        return true
    }

    public func moves() -> Int {

        return self.movesValue
    }

    public func finishMoves() {

        self.movesValue = 0
    }

    public func resetMoves(in gameModel: GameModel?) {

        self.movesValue = self.maxMoves(in: gameModel)
    }

    public func maxMoves(in gameModel: GameModel?) -> Int {

        return self.baseMoves(in: gameModel) //self.type.moves()
    }

    public func hasMoved(in gameModel: GameModel?) -> Bool {

        return self.moves() < self.maxMoves(in: gameModel)
    }

    public func movesLeft() -> Int {

        return max(0, self.moves())
    }

    public func movementType() -> UnitMovementType {

        return self.type.movementType()
    }

    public func sight() -> Int {

        var sightValue = self.type.sight()

        if let promotions = self.promotions {

            // +1 sight range.
            if promotions.has(promotion: .spyglass) {
                sightValue += 1
            }
        }

        return sightValue
    }

    public func range() -> Int {

        return self.type.range()
    }

    public func search(range: Int, in gameModel: GameModel?) -> Int {

        if range == 0 {
            return 0
        }

        if self.domain() == .sea {
            return range * self.baseMoves(in: gameModel)
        } else {
            return ((range + 1) * (self.baseMoves(in: gameModel) + 1))
        }
    }

    // MARK: fortification

    public func canFortify(at point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        if player.isHuman() && self.fortifyValue == 0 {
            // num firendly units
        }

        // a unit can either fortify or garrison. Never both.
        if self.canGarrison(at: point, in: gameModel) {
            return false
        }

        if !self.isFortifyable(canWaitForNextTurn: true, in: gameModel) {
            return false
        }

        if self.isWaiting() {
            return false
        }

        return true
    }

    func isFortifyable(canWaitForNextTurn: Bool, in gameModel: GameModel?) -> Bool {

        // Can't fortify if you've already used any moves this turn
        if !canWaitForNextTurn {
            if self.hasMoved(in: gameModel) {
                return false
            }
        }

        if !self.isEverFortifyable() {
            return false
        }

        return true
    }

    // Can this Unit EVER fortify? (may be redundant with some other stuff)
    func isEverFortifyable() -> Bool {

        /*|| noDefensiveBonus()*/
        if !self.isCombatUnit() || (self.domain() != .land && self.domain() != .immobile) {
            return false
        }

        return true
    }

    public func doFortify(in gameModel: GameModel?) {

        self.push(mission: .init(type: .fortify), in: gameModel)
    }

    public func doMobilize(in gameModel: GameModel?) {
        // opposite of fortify
        // self.fortifyValue = 0

        // todo: notify UI
        self.set(fortifiedThisTurn: false, in: gameModel)
    }

    // MARK: experience

    public func experience() -> Int {
        
        return self.experienceValue
    }

    public func changeExperience(by delta: Int, in gameModel: GameModel?) {

        guard let promotions = self.promotions else {
            fatalError("cant get promotions")
        }

        guard let player = self.player else {
            fatalError("cant get promotions")
        }
        
        guard let government = self.player?.government else {
            fatalError("cant get government")
        }
        
        var experienceDelta: Double = Double(delta)
        
        // Doubles experience for recon units.
        if government.has(card: .survey) {
            experienceDelta *= 1.2
        }
        
        // +20% Unit Experience.
        if government.currentGovernment() == .oligarchy {
            experienceDelta *= 1.2
        }

        self.experienceValue += Int(experienceDelta)

        let level = self.experienceLevel()

        // promotion message
        if promotions.count() < (level - 1) {

            if player.isHuman() {
                self.player?.notifications()?.addNotification(of: .unitPromotion, for: self.player, message: "\(self.name()) has gained a promotion.", summary: "promotion", at: self.location)
            } else {
                let promotion = self.choosePromotion()

                do {
                    try promotions.earn(promotion: promotion)
                } catch PromotionError.alreadyEarned {
                    fatalError("try to add an already earned promotion")
                } catch {
                    fatalError("unexpected error: \(error)")
                }
            }
        }
    }

    private func experienceLevel() -> Int {

        if self.experienceValue < 15 {
            return 1
        } else if self.experienceValue < 45 {
            return 2
        } else if self.experienceValue < 90 {
            return 3
        } else if self.experienceValue < 150 {
            return 4
        } else if self.experienceValue < 225 {
            return 5
        } else if self.experienceValue < 315 {
            return 6
        } else if self.experienceValue < 420 {
            return 7
        } else {
            return 8
        }
    }
    
    public func isPromotionReady() -> Bool {
        
        guard let promotions = self.promotions else {
            fatalError("cant get promotions")
        }
        
        let level = self.experienceLevel()

        return promotions.count() < (level - 1)
    }
    
    public func possiblePromotions() -> [UnitPromotionType] {
        
        guard let promotions = self.promotions else {
            fatalError("cant get promotions")
        }

        return promotions.possiblePromotions()
    }
    
    public func doPromote(with promotionType: UnitPromotionType) {
        
        guard let promotions = self.promotions else {
            fatalError("cant get promotions")
        }
        
        do {
            try promotions.earn(promotion: promotionType)
        } catch PromotionError.alreadyEarned {
            fatalError("try to add an already earned promotion")
        } catch {
            fatalError("unexpected error: \(error)")
        }
    }

    private func choosePromotion() -> UnitPromotionType {

        guard let promotions = self.promotions else {
            fatalError("cant get promotions")
        }

        let possiblePromotions = promotions.possiblePromotions()

        // only one promotion possible - take this
        if possiblePromotions.count == 1 {
            return possiblePromotions[0]
        }

        // get best promotion
        let weightedPromotion = WeightedList<UnitPromotionType>()
        for promotion in possiblePromotions {
            weightedPromotion.add(weight: Double(self.valueOf(promotion: promotion)), for: promotion)
        }

        if let bestPromotion = weightedPromotion.chooseBest() {

            return bestPromotion
        }

        fatalError("cant get promotion - not gonna happen")
    }

    private func valueOf(promotion: UnitPromotionType) -> Int {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var val = 0

        for flavorType in FlavorType.all {
            val += player.personalAndGrandStrategyFlavor(for: flavorType) * promotion.flavor(for: flavorType)
        }

        return val
    }

    // MARK: types

    public func isOf(unitType: UnitType) -> Bool {

        return self.type == unitType
    }

    public func hasSameType(as otherUnit: AbstractUnit?) -> Bool {

        return otherUnit?.isOf(unitType: self.type) ?? false
    }

    public func isOf(unitClass: UnitClassType) -> Bool {

        return self.type.unitClass() == unitClass
    }

    public func has(task: UnitTaskType) -> Bool {

        return self.type.unitTasks().contains(task)
    }

    public func domain() -> UnitDomainType {

        return self.type.domain()
    }

    public func canDo(command: CommandType, in gameModel: GameModel?) -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        /*guard let techs = player.techs else {
            fatalError("cant get techs")
        }*/
        
        switch command {
            
        case .found:
            return self.type.canFound()
            
        case .buildFarm:
            return self.canBuild(build: .farm, at: self.location, testVisible: true, testGold: true, in: gameModel)
            
        case .buildMine:
            return self.canBuild(build: .mine, at: self.location, testVisible: true, testGold: true, in: gameModel)
            
        case .buildCamp:
            return self.canBuild(build: .camp, at: self.location, testVisible: true, testGold: true, in: gameModel)
            
        case .buildPasture:
            return self.canBuild(build: .pasture, at: self.location, testVisible: true, testGold: true, in: gameModel)
            
        case .buildQuarry:
            return self.canBuild(build: .quarry, at: self.location, testVisible: true, testGold: true, in: gameModel)
            
        case .fortify:
            return self.canFortify(at: self.location, in: gameModel)
            
        case .hold:
            return self.canHold(at: self.location, in: gameModel)
            
        case .garrison:
            return self.canGarrison(at: self.location, in: gameModel)
            
        case .pillage:
            return self.canPillage(at: self.location, in: gameModel)

        case .attack:
            return self.canAttack(at: self.location, in: gameModel)
            
        case .rangedAttack:
            return self.canRangeAttack(at: self.location, in: gameModel)
            
        case .cancelAttack:
            return false
        }
    }

    public func can(automate: UnitAutomationType) -> Bool {

        switch automate {

        case .none:
            return false
        case .build:
            if !self.type.abilities().contains(.canImprove) && !self.type.abilities().contains(.canImproveSea) {
                return false
            }

            return true
        case .explore:
            if self.baseCombatStrength(ignoreEmbarked: true) == 0 {
                return false
            }

            if self.type.domain() == .air {
                return false
            }

            if self.type.domain() == .immobile {
                return false
            }

            return true
        }
    }

    public func isAutomated() -> Bool {

        return self.automation != .none
    }

    public func automateType() -> UnitAutomationType {

        return self.automation
    }

    public func automate(with type: UnitAutomationType) {

        self.automation = type
    }

    public func isFound() -> Bool {

        return self.type.canFound()
    }

    public func canFound(at location: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        if !self.type.canFound() {
            return false
        }

        if !player.canFound(at: location, in: gameModel) {
            return false
        }

        return true
    }

    public func doFound(with name: String? = nil, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        if !self.canFound(at: self.location, in: gameModel) {
            return false
        }

        player.found(at: self.location, named: name, in: gameModel)
        self.doKill(delayed: false, by: nil, in: gameModel)

        return true
    }
    
    func canEstablishTradeRoute(to targetCity: AbstractCity?, in gameModel: GameModel?) -> Bool {
        
        /*guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }*/
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        // can reach the target?
        guard let originCity = gameModel?.city(at: self.origin) else {
            // origin city does not exist anymore ?
            return false
        }
        
        if !player.canEstablishTradeRoute(from: originCity, to: targetCity, in: gameModel) {
            return false
        }
        
        return true
    }
    
    func doEstablishTradeRoute(to targetCity: AbstractCity?, in gameModel: GameModel?) -> Bool {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        // can reach the target?
        guard let originCity = gameModel?.city(at: self.origin) else {
            // origin city does not exist anymore ?
            return false
        }
        
        if !self.canEstablishTradeRoute(to: targetCity, in: gameModel) {
            return false
        }
        
        return player.doEstablishTradeRoute(from: originCity, to: targetCity, with: self, in: gameModel)
    }

    public func doKill(delayed: Bool, by other: AbstractPlayer?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if delayed {
            self.startDelayedDeath()
            return
        }

        if other != nil {
            // FIXME - add die visualization
        }

        gameModel.userInterface?.hide(unit: self)
        gameModel.remove(unit: self)
    }

    public func isDelayedDeath() -> Bool {

        return self.deathDelay
    }

    public func startDelayedDeath() {

        self.deathDelay = true
    }

    // Returns true if killed...
    @discardableResult
    public func doDelayedDeath(in gameModel: GameModel?) -> Bool {

        if self.deathDelay /*&& !self.isFighting() && !IsBusy())*/ {
            self.doKill(delayed: false, by: nil, in: gameModel)
            return true
        }

        return false
    }

    // MARK build

    public func canBuild(build: BuildType, at point: HexPoint, testVisible: Bool = false, testGold: Bool = true, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }
        
        // dont build twice
        if let improvement = build.improvement() {
            if tile.has(improvement: improvement) {
                return false
            }
        }

        if !self.type.canBuild(build: build) {
            return false
        }

        if !player.canBuild(build: build, at: point, testGold: testGold, in: gameModel) {
            return false
        }

        if self.isEmbarked() && tile.terrain().isWater() {
            return false
        }

        if !testVisible {

            // check for any other units working in this plot
            /*gameModel.unit(at: <#T##HexPoint#>)
            pPlot = plot();
            const IDInfo* pUnitNode = pPlot->headUnitNode();
            const CvUnit* pLoopUnit = NULL;

            while (pUnitNode != NULL)
            {
                pLoopUnit = ::getUnit(*pUnitNode);
                pUnitNode = pPlot->nextUnitNode(pUnitNode);

                if (pLoopUnit && pLoopUnit != this)
                {
                    if (pLoopUnit->IsWork() && pLoopUnit->getBuildType() != NO_BUILD)
                    {
                        return false
                    }
                }
            }*/
        }

        return true
    }

    public func canContinueBuild(build buildType: BuildType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        /*guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let tile = gameModel.tile(at: self.location) else {
            fatalError("cant get tile")
        }*/

        var continueToBuild = false

        /*if let improvement = buildType.improvement() {
            
            if self.isAutomated() {
                
                if tile.improvement() != .ruins {
                    
                    let resource = tile.resource(for: player)
                    if resource == .none || !improvement.enables(resource: resource) {
                        if improvement.re
                        if (GC.getImprovementInfo(eImprovement)->GetImprovementPillage() != NO_IMPROVEMENT)
                        {
                            return false
                        }
                    }
                }
            }
        }*/

        // Don't check for Gold cost here (2nd false) because this function is called from continueMission... we spend the Gold then check to see if we can Build
        if self.canBuild(build: buildType, at: self.location, testVisible: false, testGold: false, in: gameModel) {
            continueToBuild = true

            // fixme: need to call tile changeBuildProgress
            if self.continueBuilding(build: buildType, in: gameModel) {
                continueToBuild = false
            }
        }

        return continueToBuild
    }

    public func changeBuildCharges(change: Int) {
        
        guard self.buildChargesValue + change >= 0 else {
            fatalError("buildCharges cant be negative")
        }
        
        self.buildChargesValue += change
    }
    
    public func buildCharges() -> Int {
        
        return self.buildChargesValue
    }
    
    func hasBuildCharges() -> Bool {
        
        return self.buildChargesValue > 0
    }
    
    // Returns true if build finished...
    // bool CvUnit::build(BuildTypes eBuild)
    public func doBuild(build buildType: BuildType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let tile = gameModel.tile(at: self.location) else {
            fatalError("Cant get tile")
        }

        self.buildTypeValue = buildType

        if let tile = gameModel.tile(at: self.location) {
            if tile.resource(for: self.player) != .none {
                if let player = tile.owner() {
                    let resourceQuantity = tile.resourceQuantity()
                    player.changeNumAvailable(resource: tile.resource(for: self.player), change: resourceQuantity)
                }
            }
        }

        var finished: Bool = false

        // Don't test Gold
        if !self.canBuild(build: buildType, at: self.location, testVisible: false, testGold: false, in: gameModel) {
            return false
        }

        let startedYet = tile.buildProgress(of: buildType)

        // if we are starting something new, wipe out the old thing immediately
        if startedYet == 0 {

            if buildType.improvement() != nil {

                if tile.improvement() != .none {
                    tile.set(improvement: .none)
                }
            }

            // wipe out all build progress also
        }

        let rate = self.type.workRate()
        finished = tile.changeBuildProgress(of: buildType, change: rate, for: player, in: gameModel)

        // needs to be at bottom because movesLeft() can affect workRate()...
        self.finishMoves()

        if finished {

            if buildType.isKill() {

                if self.isGreatPerson() {
                    fatalError("niy")
                    //player.doGreatPersonExpended(of: self.type)
                }

                self.doKill(delayed: true, by: nil, in: gameModel)
            }

            // handle builder expended
            if self.type == .builder {
                self.changeBuildCharges(change: -1)
                
                if !self.hasBuildCharges() {
                    self.doKill(delayed: true, by: nil, in: gameModel)
                }
            }

            // Add to player's Improvement count, which will increase cost of future Improvements
            if buildType.improvement() != nil || buildType.route() != nil {
                // Prevents chopping Forest or Jungle from counting
                player.changeTotalImprovementsBuilt(change: 1)
            }
            
            gameModel.userInterface?.refresh(tile: tile)
            
        } else {
            // we are not done doing this
            if startedYet == 0 {

                if tile.isVisible(to: player) {
                    if buildType.improvement() != nil {
                        gameModel.userInterface?.refresh(tile: tile)
                    } else if buildType.route() != nil {
                        gameModel.userInterface?.refresh(tile: tile)
                    }
                }
            }
        }

        return finished
    }

    func isGreatPerson() -> Bool {

        return self.type == .general || self.type == .artist || self.type == .admiral || self.type == .engineer || self.type == .general || self.type == .merchant || self.type == .prophet || self.type == .scientist
    }

    public func buildType() -> BuildType {

        return self.buildTypeValue
    }

    // Returns true if build should continue...
    public func continueBuilding(build buildType: BuildType, in gameModel: GameModel?) -> Bool {

        var canContinue = false

        guard let plot = gameModel?.tile(at: self.location) else {
            return false
        }

        if self.isAutomated() {

            if plot.improvement() != .none && plot.improvement() != .ruins {
                    
                let resource = plot.resource(for: self.player)
                //ResourceTypes eResource = (ResourceTypes)pPlot->getNonObsoleteResourceType(GET_PLAYER(getOwner()).getTeam());
                /*if resource == .none || resource.techCityTrade() {
                        if (GC.getImprovementInfo(eImprovement)->GetImprovementPillage() != NO_IMPROVEMENT)
                        {
                            return false;
                        }
                    }*/
            }
        }

        // Don't check for Gold cost here (2nd false) because this function is called from continueMission... we spend the Gold then check to see if we can Build
        if self.canBuild(build: buildType, at: self.location, testVisible: false, testGold: false, in: gameModel) {
            
            canContinue = true

            if self.doBuild(build: buildType, in: gameModel) {
                canContinue = false
            }
        }

        return canContinue
    }

    public func canPillage(at point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        if self.isEmbarked() {
            return false
        }

        if !self.type.canPillage() {
            return false
        }

        // Barbarian boats not allowed to pillage, as they're too annoying :)
        if self.isBarbarian() && self.domain() == .sea {
            return false
        }

        if tile.isCity() {
            return false
        }

        let improvementType = tile.improvement()
        if improvementType == .none {
            if tile.has(route: .none) {
                return false
            }
        } else if improvementType == .ruins {
            return false
        } else if improvementType == .goodyHut {
            return false
        }

        // Either nothing to pillage or everything is pillaged to its max
        if (improvementType == .none || tile.isImprovementPillaged()) &&
            (tile.has(route: .none) || tile.isRoutePillaged()) {
            return false
        }

        /*if tile.hasOwner() {
            if (!potentialWarAction(pPlot))
            {
                if ((eImprovementType == NO_IMPROVEMENT && !pPlot->isRoute()) || (pPlot->getOwner() != getOwner()))
                {
                    return false;
                }
            }
        }*/

        // can no longer pillage our tiles
        if player.isEqual(to: tile.owner()) {
            return false
        }

        return true
    }

    func canAttack(at point: HexPoint, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        if self.isOutOfAttacks() {
            return false
        }
        
        // must be melee
        if !self.isCombatUnit() {
            return false
        }
        
        // check neighbors for enemy units
        for dir in HexDirection.all {
            
            let neighor = self.location.neighbor(in: dir)
            
            if let neighborUnit = gameModel.unit(at: neighor) {
                
                // other unit
                if !player.isEqual(to: neighborUnit.player) {
                    
                    // barbarian ?
                    if neighborUnit.isBarbarian() {
                        return true
                    }
                    
                    // at war?
                    if diplomacyAI.isAtWar(with: neighborUnit.player) {
                        return true
                    }
                }
            }
            
            if let neighborCity = gameModel.city(at: neighor) {
                
                // other city
                if !player.isEqual(to: neighborCity.player) {
                    
                    // barbarian?
                    if neighborCity.isBarbarian() {
                        return true
                    }
                    
                    // at war?
                    if diplomacyAI.isAtWar(with: neighborCity.player) {
                        return true
                    }
                }
            }
        }
        
        // no enemy unit or city around
        return false
    }
    
    func canRangeAttack(at point: HexPoint, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        // must be ranged
        if !self.isRanged() {
            return false
        }
        
        // check neighbors for enemy units
        for neighor in self.location.areaWith(radius: self.range()) {

            if let neighborUnit = gameModel.unit(at: neighor) {
                
                // other unit
                if !player.isEqual(to: neighborUnit.player) {
                    
                    // at war?
                    if diplomacyAI.isAtWar(with: neighborUnit.player) {
                        return true
                    }
                }
            }
            
            if let neighborCity = gameModel.city(at: neighor) {
                
                // other city
                if !player.isEqual(to: neighborCity.player) {
                    
                    // at war?
                    if diplomacyAI.isAtWar(with: neighborCity.player) {
                        return true
                    }
                }
            }
        }
        
        // no enemy unit or city in range
        return false
    }
    
    @discardableResult public func doPillage(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if !self.canPillage(at: self.location, in: gameModel) {
            return false
        }

        if let tile = gameModel.tile(at: self.location) {

            let improvement = tile.improvement()
            if !improvement.canBePillaged() {
                return false
            } else {
                tile.removeImprovement()

                if tile.resource(for: player) != .none {
                    if let player = tile.owner() {
                        let resourceQuantity = tile.resourceQuantity()
                        player.changeNumAvailable(resource: tile.resource(for: player), change: -resourceQuantity)
                    }
                }

                return true
            }
        }

        return false
    }

    public func doRebase(to point: HexPoint) -> Bool {

        self.origin = point
        
        return true
    }

    public func canReach(at point: HexPoint, in turns: Int, in gameModel: GameModel?) -> Bool {

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel?.unitAwarePathfinderDataSource(for: self.movementType(), for: self.player)

        if let path = pathFinder.shortestPath(fromTileCoord: self.location, toTileCoord: point) {

            let turnsNeeded = path.count / self.moves()
            return turnsNeeded <= turns
        }

        return false
    }

    public func turnsToReach(at point: HexPoint, in gameModel: GameModel?) -> Int {

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel?.unitAwarePathfinderDataSource(for: self.movementType(), for: self.player)

        if let path = pathFinder.shortestPath(fromTileCoord: self.location, toTileCoord: point) {

            path.prepend(point: self.location, cost: 0.0)

            let turnsNeeded = path.cost / Double(self.moves())
            return Int(turnsNeeded)
        }

        return Int.max
    }

    func isAmphibious() -> Bool {

        if let promotions = self.promotions {
            if promotions.has(promotion: .amphibious) {
                return true
            }
        }

        return false
    }

    public func canEverEmbark() -> Bool {

        if self.domain() == .land && self.type.has(ability: .canEmbark) {
            return true
        } else {
            return false
        }
    }

    public func canEmbark(into point: HexPoint? = nil, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if self.domain() != .land {

            return false
        }

        if self.isEmbarked() {

            return false
        }

        if self.movesLeft() <= 0 {

            return false
        }

        if !gameModel.isCoastal(at: self.location) {
            return false
        }

        // check target
        if let point = point {

            if !gameModel.valid(point: point) {
                return false
            }

            if let targetTile = gameModel.tile(at: point) {
                if targetTile.terrain().isLand() {
                    return false
                }
            }
        }

        return true
    }

    @discardableResult
    public func doEmbark(into point: HexPoint? = nil, in gameModel: GameModel?) -> Bool {

        if !self.canEmbark(into: point, in: gameModel) {
            fatalError("throw")
        }

        self.isEmbarkedValue = true

        return true
    }

    public func canDisembark(into point: HexPoint? = nil, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if self.domain() != .land {

            return false
        }

        if !self.isEmbarked() {

            return false
        }

        if self.movesLeft() <= 0 {

            return false
        }

        /*if !gameModel.isCoastal(at: self.location) {
            return false
        }*/

        // check target
        if let point = point {

            if !gameModel.valid(point: point) {
                return false
            }

            if let targetTile = gameModel.tile(at: point) {
                if targetTile.terrain().isWater() {
                    return false
                }
            }
        }

        return true
    }

    @discardableResult
    public func doDisembark(into point: HexPoint? = nil, in gameModel: GameModel?) -> Bool {

        if !self.canDisembark(into: point, in: gameModel) {
            fatalError("throw")
        }

        self.isEmbarkedValue = false

        return true
    }

    public func isEmbarked() -> Bool {

        return self.isEmbarkedValue
    }

    public func turn(in gameModel: GameModel?) {

        // Wake unit if skipped last turn
        let currentActivityType = self.activityType()
        let holdCheck = (currentActivityType == .hold) && (self.isHuman() || self.fortifyTurns() > 0)
        let healCheck = (currentActivityType == .heal) && (!self.isHuman() || self.isAutomated() || !self.isHurt())
        let sentryCheck = (currentActivityType == .sentry) /*&& sentryAlert()*/
        let interceptCheck = currentActivityType == .intercept && !isHuman()

        if holdCheck || healCheck || sentryCheck || interceptCheck {
            self.set(activityType: .awake, in: gameModel)
        }

        /*testPromotionReady();

         // damage from features?
         FeatureTypes eFeature = plot()->getFeatureType();
         if(NO_FEATURE != eFeature) {
            if(0 != GC.getFeatureInfo(eFeature)->getTurnDamage())
            {
                changeDamage(GC.getFeatureInfo(eFeature)->getTurnDamage(), NO_PLAYER);
            }
        }*/

        // Only increase our Fortification level if we've actually been told to Fortify
        if self.isFortifiedThisTurn() {
            self.changeFortifyTurns(by: 1, in: gameModel)
        }

        // Recon unit? If so, he sees what's around him
        /*if(IsRecon())
        {
            setReconPlot(plot());
        }

        // If we're not busy doing anything with the turn cycle, make the Unit's Flag bright again
        if(GetActivityType() == ACTIVITY_AWAKE)
        {
            auto_ptr<ICvUnit1> pDllUnit(new CvDllUnit(this));
            gDLL->GameplayUnitShouldDimFlag(pDllUnit.get(), /*bDim*/ false);
        }*/

        // If we told our Unit to sleep last turn and it can now Fortify switch states
        if self.activityType() == .sleep {
            
            if self.canFortify(at: self.location, in: gameModel) {
                self.push(mission: UnitMission(type: .fortify), in: gameModel)
                self.set(fortifiedThisTurn: true, in: gameModel)
            }
        }

        self.doDelayedDeath(in: gameModel)
    }
    
    public func set(fortifiedThisTurn: Bool, in gameModel: GameModel?) {
        
        if !self.isEverFortifyable() && fortifiedThisTurn {
            return
        }
        
        if self.isFortifiedThisTurn() != fortifiedThisTurn {
            self.fortifiedThisTurnValue = fortifiedThisTurn

            if fortifiedThisTurn {
                var turnsToFortify = 1
                if !self.isFortifyable(canWaitForNextTurn: false, in: gameModel) {
                    turnsToFortify = 0
                }

                // Manually set us to being fortified for the first turn (so we get the Fort bonus immediately)
                self.set(fortifyTurns: turnsToFortify, in: gameModel)

                if turnsToFortify > 0 {
                    //auto_ptr<ICvUnit1> pDllUnit(new CvDllUnit(this));
                    //gDLL->GameplayUnitFortify(pDllUnit.get(), true);
                    gameModel?.userInterface?.animate(unit: self, animation: .fortify)
                }
            }
        }
    }
    
    func isFortifiedThisTurn() -> Bool {
        
        return self.fortifiedThisTurnValue
    }
    
    func fortifyTurns() -> Int {
         
        return self.fortifyTurnsValue
    }
    
    func set(fortifyTurns: Int, in gameModel: GameModel?) {

        let newValue = fortifyTurns // range(iNewValue, 0, GC.getMAX_FORTIFY_TURNS());

        if newValue != self.fortifyTurns() {
            
            // Unit subtly slipped into Fortification state by remaining stationary for a turn
            if self.fortifyTurns() == 0 && fortifyTurns > 0 {
                //auto_ptr<ICvUnit1> pDllUnit(new CvDllUnit(this));
                //gDLL->GameplayUnitFortify(pDllUnit.get(), true);
                gameModel?.userInterface?.animate(unit: self, animation: .fortify)
            }

            self.fortifyTurnsValue = newValue
            //setInfoBarDirty(true);

            // Fortification turned off, send an event noting this
            if newValue == 0 {
                self.set(fortifiedThisTurn: false, in: gameModel)

                // auto_ptr<ICvUnit1> pDllUnit(new CvDllUnit(this));
                // gDLL->GameplayUnitFortify(pDllUnit.get(), false);
                gameModel?.userInterface?.animate(unit: self, animation: .unfortify)
            }
        }
    }


    //    --------------------------------------------------------------------------------
    func changeFortifyTurns(by change: Int, in gameModel: GameModel?) {

        self.set(fortifyTurns: self.fortifyTurns() + change, in: gameModel)
    }

    public func set(turnProcessed: Bool) {

        self.processedInTurnValue = turnProcessed
    }

    public func processedInTurn() -> Bool {

        return self.processedInTurnValue
    }

    public func set(tacticalMove: TacticalMoveType) {

        self.tacticalMoveValue = tacticalMove
    }

    public func tacticalMove() -> TacticalMoveType? {

        return self.tacticalMoveValue
    }

    public func isUnderTacticalControl() -> Bool {

        return self.tacticalMoveValue != TacticalMoveType.none
    }

    public func set(tacticalTarget: HexPoint) {

        self.tacticalTargetValue = tacticalTarget
    }

    public func tacticalTarget() -> HexPoint? {

        return self.tacticalTargetValue
    }
    
    public func resetTacticalTarget() {
        
        self.tacticalTargetValue = nil
    }

    public func resetTacticalMove() {

        self.tacticalMoveValue = nil
        self.tacticalTargetValue = nil
    }

    public func army() -> Army? {

        return self.armyRef
    }

    public func assign(to army: Army?) {

        self.armyRef = army
    }
    
    public func deployFromOperationTurn() -> Int {
        
        return self.deployFromOperationTurnValue
    }
    
    public func setDeployFromOperationTurn(to turn: Int) {
        
        self.deployFromOperationTurnValue = turn
    }

    public func isEqual(to other: AbstractUnit?) -> Bool {

        guard let other = other else {
            fatalError("cant get other")
        }

        return self.location == other.location && other.isOf(unitType: self.type)
    }

    public func canEnterTerrain(of tile: AbstractTile?) -> Bool {

        return !self.isImpassable(tile: tile)
    }
    
    public func isImpassable(terrain: TerrainType) -> Bool {
        
        if terrain == .ocean && self.type.abilities().contains(.oceanImpassable) {
            return true
        }
        
        if self.domain() == .land && terrain.isWater() {
            return true
        }
        
        if self.domain() == .sea && terrain.isLand() {
            return true
        }
        
        return false
    }

    public func canMoveAllTerrain() -> Bool {

        // FIXME
        return false
    }

    // Can the unit skip their turn at the specified plot
    public func canHold(at point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // no hold / skip in cities (need to fortify) for land attack units
        if gameModel.city(at: point) != nil && self.baseCombatStrength() > 0 && self.domain() != .sea {
            return false
        }

        return true
    }

    public func validTarget(at target: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = gameModel.tile(at: self.location) else {
            fatalError("cant get tile")
        }

        guard let targetTile = gameModel.tile(at: target) else {
            fatalError("cant get targetTile")
        }

        if !self.canEnterTerrain(of: targetTile) {
            return false
        }

        switch self.domain() {
        case .sea:
            if targetTile.terrain().isWater() || self.canMoveAllTerrain() {
                return true
            } else if targetTile.isFriendlyCity(for: self.player, in: gameModel) && gameModel.isCoastal(at: self.location) {
                return true
            }
            break

        case .air:
            return true

        case .land:
            if tile.sameContinent(as: targetTile) || self.canMoveAllTerrain() {
                return true
            }
            break

        case .immobile:
            // NOOP
            break
        case .none:
            // NOOP
            break
        }

        return false
    }

    func willRevealByMove(tile: AbstractTile?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        let visRange = self.sight()
        let range = visRange + 1

        for point in tile.point.areaWith(radius: range) {

            if let neighborTile = gameModel.tile(at: point) {

                if !neighborTile.isDiscovered(by: self.player) && tile.canSee(tile: neighborTile, for: self.player, range: visRange, in: gameModel) {
                    return true
                }
            }
        }

        return false
    }

    public func isBusy() -> Bool {

        if self.missionTimer() > 0 {
            return true
        }

        /*if (isInCombat())
        {
            return true;
        }*/

        return false
    }
}

// MARK: mission methods
extension Unit {

    public func activityType() -> UnitActivityType {

        return self.activityTypeValue
    }

    public func set(activityType newValue: UnitActivityType, in gameModel: GameModel?) {

        let oldActivity = self.activityTypeValue

        if oldActivity != newValue {

            self.activityTypeValue = newValue

            // If we're waking up a Unit then remove it's fortification bonus
            if newValue == .awake {
                self.set(fortifyTurns: 0, in: gameModel)
            }

            gameModel?.userInterface?.refresh(unit: self)
        }
    }

    /// Eligible to start a new mission?
    public func canStart(mission: UnitMission, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        switch mission.type {

        case .found:
            if let target = mission.unit?.location {
                if self.canFound(at: target, in: gameModel) {
                    return true
                }
            }
        case .moveTo:
            if let target = mission.target {
                if gameModel.valid(point: target) {
                    return true
                }
            }
        case .garrison:
            if let target = mission.target {
                if self.canGarrison(at: target, in: gameModel) {
                    return true
                }
            } else {
                if self.canGarrison(at: self.location, in: gameModel) {
                    return true
                }
            }
        case .pillage:
            if self.canPillage(at: self.location, in: gameModel) {
                return true
            }
        case .skip:
            if let target = mission.unit?.location {
                if self.canHold(at: target, in: gameModel) {
                    return true
                }
            }
        case .rangedAttack:
            if let target = mission.target {
                if self.canRangeStrike(at: target, needWar: false, noncombatAllowed: false) {
                    return true
                }
            }
        case .sleep:
            break
            // FIXME
            /*if self.canSleep() {
                return true
            }*/
        case .fortify:
            if self.canFortify(at: self.location, in: gameModel) {
                return true
            }
        case .alert:
            if self.canSentry(in: gameModel) {
                return true
            }
        case .airPatrol:
            break
            // FIXME
        case .heal:
            if self.canHeal(in: gameModel) {
                return true
            }
        case .embark:
            if let target = mission.target {
                if self.canEmbark(into: target, in: gameModel) {
                    return true
                }
            }
        case .disembark:
            if let target = mission.target {
                if self.canDisembark(into: target, in: gameModel) {
                    return true
                }
            }
        case .rebase:
            if let target = mission.target {
                // FIXME
                fatalError("not implemented")
            }
        case .build:
            if let target = mission.unit?.location, let buildType = mission.buildType {
                if self.canBuild(build: buildType, at: target, in: gameModel) {
                    return true
                }
            }
            /*case .routeTo:
            <#code#>
        case .swapUnits:
            <#code#>
        case .moveToUnit:
            <#code#>*/
        default:
            // NOOP
            break
        }

        return false
    }

    public func push(mission: UnitMission, in gameModel: GameModel?) {

        self.missions.push(mission)
        print(">>> pushed mission: \(mission.type) \(mission.type.needsTarget() ? "\(mission.target!)" : "") for \(self.type)")

        mission.unit = self

        mission.start(in: gameModel)
    }

    public func popMission() {

        self.missions.pop()

        if self.missions.count == 0 {
            self.activityTypeValue = .none
        }
    }

    public func peekMission() -> UnitMission? {

        return self.missions.peek()
    }

    public func setMissionTimer(to timer: Int) {

        self.missionTimerValue = timer
    }

    public func missionTimer() -> Int {

        return self.missionTimerValue
    }

    /// Perform automated mission
    public func autoMission(in gameModel: GameModel?) {

        guard let dangerPlotAI = self.player?.dangerPlotsAI else {
            fatalError("cant get dangerPlotAI")
        }

        if let missionNode = self.peekMission() {

            if !self.isBusy() && !self.isDelayedDeath() {

                // Builders which are being escorted shouldn't wake up every turn... this is annoying!
                let escortedBuilder = false
                if missionNode.type == .build {

                    /*if (hUnit->plot()->getNumDefenders(hUnit->getOwner()) > 0) {
                        escortedBuilder = true
                    }*/
                }

                if !escortedBuilder /*&& !hUnit->IsIgnoringDangerWakeup()*/ && !self.isCombatUnit() && dangerPlotAI.danger(at: self.location) > 0.0 {
                    //self.mission.clearMissionQueue()
                    fatalError("boing")
                    //hUnit->SetIgnoreDangerWakeup(true);
                } else {
                    if self.activityType() == .mission {
                        missionNode.continueMission(steps: 0, in: gameModel)
                    } else {
                        missionNode.start(in: gameModel)
                    }
                }
            }
        }

        //self.ignoreDestruction(true);
        self.doDelayedDeath(in: gameModel)
    }

    //    Returns true if the is a move mission at the head of the unit queue and it is complete
    public func hasCompletedMoveMission(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if let missionNode = self.peekMission() {

            if missionNode.type == .moveTo || missionNode.type == .routeTo || missionNode.type == .moveToUnit {

                var targetPlot: AbstractTile? = nil

                if missionNode.type == .moveToUnit {

                    if let targetPoint = missionNode.target {
                        targetPlot = gameModel.tile(at: targetPoint)
                    } else {
                        return true // Our unit is gone, assume we are done.
                    }
                } else {
                    if let targetPoint = missionNode.target {
                        targetPlot = gameModel.tile(at: targetPoint)
                    }
                }

                if targetPlot != nil && self.location == targetPlot?.point {
                    return true
                }
            }
        }

        return false
    }

    public func updateMission(in gameModel: GameModel?) {

        /*if self.missionTimerValue > 0 {

            self.missionTimerValue -= 1

            if self.missionTimerValue == 0 {*/

                if self.activityTypeValue == .mission {

                    if let headMission = self.missions.peek() {
                        headMission.continueMission(steps: 0, in: gameModel)
                    }
                }
            /*}
        }*/
        /*if let headMission = self.missions.peek() {
            headMission.update()
        }*/
    }

    public func clearMissions() {

        self.missions.clear()
    }

    public func commands(in gameModel: GameModel?) -> [Command] {

        var commandArray: [Command] = []

        for commandType in CommandType.all {
            
            if self.canDo(command: commandType, in: gameModel) {
                commandArray.append(Command(type: commandType, location: self.location))
            }
        }

        return commandArray
    }
    
    public func isGreatGeneral() -> Bool {
        
        return self.type == .general
    }
    
    //    --------------------------------------------------------------------------------
    public func canRecruitFromTacticalAI() -> Bool {
        
        if let tacticalMoveValue = self.tacticalMoveValue {
            return tacticalMoveValue.canRecruitForOperations()
        }
        return true
    }
}
