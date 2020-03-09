//
//  Unit.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 06.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum UnitActivityType {
    
    case none
    case awake // ACTIVITY_AWAKE,
    case hold // ACTIVITY_HOLD,
    case sleep // ACTIVITY_SLEEP,
    case heal // ACTIVITY_HEAL,
    case sentry // ACTIVITY_SENTRY,
    case intercept // ACTIVITY_INTERCEPT,
    case mission // ACTIVITY_MISSION
}

protocol AbstractUnit: class {

    var location: HexPoint { get }
    var player: AbstractPlayer? { get }
    var task: UnitTaskType { get }
    
    func name() -> String
    func classClass() -> UnitClassType
    
    func civilianAttackPriority() -> CivilianAttackPriorityType
    
    func isOf(unitType: UnitType) -> Bool
    func hasSameType(as otherUnit: AbstractUnit?) -> Bool
    func isOf(unitClass: UnitClassType) -> Bool
    func has(task: UnitTaskType) -> Bool
    func domain() -> UnitDomainType
    
    func canMove() -> Bool
    func moves() -> Int
    func maxMoves(in gameModel: GameModel?) -> Int
    func movementType() -> UnitMovementType
    func baseMoves(into domain: UnitDomainType, in gameModel: GameModel?) -> Int
    func isImpassable(terrain: TerrainType) -> Bool
    
    func healthPoints() -> Int
    func set(healthPoints: Int)
    func canHeal(in gameModel: GameModel?) -> Bool
    func damage() -> Int

    func isOutOfAttacks() -> Bool
    func baseCombatStrength(ignoreEmbarked: Bool) -> Int
    func attackStrength(against defender: AbstractUnit?, or city: AbstractCity?, on toTile: AbstractTile?) -> Int
    func rangedCombatStrength(against defender: AbstractUnit?, or city: AbstractCity?, on toTile: AbstractTile?, attacking: Bool) -> Int
    func defensiveStrength(against attacker: AbstractUnit?, on toTile: AbstractTile?, ranged: Bool) -> Int

    func sight() -> Int
    func range() -> Int
    
    func experience() -> Int
    func gain(experience delta: Int, in gameModel: GameModel?)
    
    func power() -> Int
    func combatStrength() -> Int
    func rangedStrength() -> Int
    func isCombatUnit() -> Bool
 
    func preTurn(in gameModel: GameModel?)
    func turn(in gameModel: GameModel?)
    func set(turnProcessed: Bool)
    func processedInTurn() -> Bool
    
    func canMoveOrAttack(into point: HexPoint) -> Bool
    func canAttack() -> Bool
    func canAttackRanged() -> Bool
    func canRangeStrike(at point: HexPoint, needWar: Bool, noncombatAllowed: Bool) -> Bool
    func canDefend() -> Bool
    func canSentry(in gameModel: GameModel?) -> Bool
    
    func canDo(command: UnitCommandTypes) -> Bool
    
    func can(automate: UnitAutomationType) -> Bool
    func isAutomated() -> Bool
    func automateType() -> UnitAutomationType
    
    func canFound(at location: HexPoint, in gameModel: GameModel?) -> Bool
    func isFound() -> Bool
    func doFound(with name: String?,in gameModel: GameModel?) -> Bool
    
    func doPillage(in gameModel: GameModel?) -> Bool
    func doRebase(to point: HexPoint) -> Bool
    
    func canReach(at point: HexPoint, in turns: Int, in gameModel: GameModel?) -> Bool
    func turnsToReach(at point: HexPoint, in gameModel: GameModel?) -> Int
    
    func canEmbark(into point: HexPoint?, in gameModel: GameModel?) -> Bool
    func doEmbark(into point: HexPoint?, in gameModel: GameModel?) -> Bool
    func canDisembark(into point: HexPoint?, in gameModel: GameModel?) -> Bool
    func doDisembark(into point: HexPoint?, in gameModel: GameModel?) -> Bool
    func isEmbarked() -> Bool
    
    func suppression() -> Int
    func isSuppressed() -> Bool
    func set(suppression: Int)
    
    func canEntrench() -> Bool
    func doEntrench()
    func isEntrenched() -> Bool
    func entrenchment() -> Int
    func decreaseEntrenchment(by amount: Int)
    
    func finishMoves()
    
    // mission / tactical move
    func activityType() -> UnitActivityType
    func set(activityType: UnitActivityType)
    
    func canStart(mission: UnitMission, in gameModel: GameModel?) -> Bool
    func push(mission: UnitMission, in gameModel: GameModel?)
    func updateMission()
    func popMission()
    
    func set(tacticalMove: TacticalMoveType)
    func tacticalMove() -> TacticalMoveType?
    func set(tacticalTarget: HexPoint)
    func tacticalTarget() -> HexPoint?
    func isUnderTacticalControl() -> Bool
    func resetTacticalMove()
    
    // army
    func army() -> Army?
    func assign(to army: Army?)
    
    func isEqual(to other: AbstractUnit?) -> Bool
}

class Unit: AbstractUnit {

    static let maxHealth: Double = 100.0
    
    private let type: UnitType
    var location: HexPoint
    private(set) var player: AbstractPlayer?
    internal var promotions: AbstractPromotions?
    var task: UnitTaskType

    private var armyRef: Army?
    private var tacticalMoveValue: TacticalMoveType? = nil
    private var tacticalTargetValue: HexPoint? = nil
    
    //
    var movesValue: Int
    var experienceValue: Int // 0..400
    var isEmbarkedValue: Bool = false
    var healthPointsValue: Int // 0..100 - https://civilization.fandom.com/wiki/Hit_Points
    var suppressionValue: Int
    var entrenchmentValue: Int
    var processedInTurnValue: Bool = false
    
    // missions
    internal var missions: Stack<UnitMission>
    internal var missionTimer: Int
    internal var activityTypeValue: UnitActivityType
    
    // automations
    internal var automation: UnitAutomationType = .none
    
    init(at location: HexPoint, type: UnitType, owner: AbstractPlayer?) {

        self.type = type
        self.location = location
        self.player = owner
        self.task = type.defaultTask()

        self.healthPointsValue = Int(Unit.maxHealth)
        self.experienceValue = 0
        self.suppressionValue = 0
        self.entrenchmentValue = 0
        self.movesValue = type.moves()
        
        self.missions = Stack<UnitMission>()
        self.missionTimer = 0
        self.activityTypeValue = .none
        
        self.promotions = Promotions(unit: self)
    }
    
    // MARK: public methods
    
    func name() -> String {
        
        return self.type.name()
    }
    
    func classClass() -> UnitClassType {
        
        return self.type.unitClass()
    }
    
    func civilianAttackPriority() -> CivilianAttackPriorityType {
        
        return self.type.civilianAttackPriority()
    }
    
    // MARK: health related methods
    
    func healthPoints() -> Int {
        
        return self.healthPointsValue
    }
    
    func set(healthPoints: Int) {
        
        self.healthPointsValue = healthPoints
    }
    
    private func healRate(at point: HexPoint, in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            return 0
        }
        
        var totalHeal = 0
        
        if gameModel.city(at: point) != nil {
            totalHeal += 6 // CITY_HEAL_RATE
        }
        
        return totalHeal
    }
    
    func canHeal(in gameModel: GameModel?) -> Bool {
        
        // No barb healing
        if self.player?.leader == .barbar {
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
    
    func damage() -> Int {
        
        return max(0, Int(Unit.maxHealth) - self.healthPointsValue)
    }
    
    /// Current power of unit (raw unit type power adjusted for health)
    func power() -> Int {
        
        var powerVal: Double = Double(self.type.power())
        
        // Take promotions into account: unit with 4 promotions worth ~50% more
        powerVal = powerVal * pow(Double(self.experienceLevel()), 0.3)
        
        let ratio = Double(self.healthPointsValue) / (2.0 * Unit.maxHealth) /* => 0..0.5 */ + 0.5 /* => 0.5..1.0 */
        return Int(powerVal * ratio)
    }
    
    func effectiveStrength() -> Int {
        
        return self.healthPointsValue - self.suppressionValue
    }
    
    func isOutOfAttacks() -> Bool {
        
        return false
    }
    
    func baseCombatStrength(ignoreEmbarked: Bool = true) -> Int {
         
        // FIXME
        if self.isEmbarked() && !ignoreEmbarked {
            if self.classClass() == .civilian {
                return 0
            } else {
                return 500 // FIXME
            }
        }
        
        return self.type.meleeStrength()
    }
    
    func rangedCombatStrength(against defender: AbstractUnit?, or city: AbstractCity?, on toTile: AbstractTile?, attacking: Bool) -> Int {
                
        if self.baseRangedCombatStrength() == 0 {
            return 0
        }
        
        if self.range() == 0 {
            return 0
        }

        var modifier = 0
        
        ////////////////////////
        // KNOWN DESTINATION PLOT
        ////////////////////////
        
        if let tile = toTile {

            modifier -= tile.defenseModifier(for: self.player)
        }
        
        ////////////////////////
        // KNOWN CITY
        ////////////////////////
        
        // FIXME
        
        ////////////////////////
        // KNOWN DEFENDER
        ////////////////////////
        
        if let defender = defender {
            
            return self.combatStrength(against: defender) + modifier
        }
        
        return self.combatStrength(towards: toTile) + modifier
    }
    
    /// What is the max strength of this Unit when attacking?
    func attackStrength(against defender: AbstractUnit?, or city: AbstractCity?, on toTile: AbstractTile? = nil) -> Int {
        
        let isEmbarkedAttackingLand = isEmbarked() && (toTile != nil && toTile!.terrain().isLand())
        
        if self.isEmbarked() && !isEmbarkedAttackingLand {
            return 0
        }
        
        if self.baseCombatStrength(ignoreEmbarked: isEmbarkedAttackingLand) == 0 {
            return 0
        }

        var modifier = 0
        
        ////////////////////////
        // KNOWN DESTINATION PLOT
        ////////////////////////
        
        if let tile = toTile {

            modifier -= tile.defenseModifier(for: self.player)
        }
        
        ////////////////////////
        // KNOWN CITY
        ////////////////////////
        
        // FIXME
        
        ////////////////////////
        // KNOWN DEFENDER
        ////////////////////////
        
        if let defender = defender {
            
            return self.combatStrength(against: defender) + modifier
        }
        
        return self.combatStrength(towards: toTile) + modifier
    }
    
    func defensiveStrength(against attacker: AbstractUnit?, on toTile: AbstractTile?, ranged: Bool) -> Int {
        
        if self.isEmbarked() {
            if self.classClass() == .civilian {
                return 0
            } else {
                return 500 // FIXME
            }
        }
        
        if self.combatStrength() == 0 {
            return 0
        }
        
        var modifier = 0
        
        ////////////////////////
        // KNOWN DEFENSE PLOT
        ////////////////////////
        
        if let tile = toTile {

            modifier -= tile.defenseModifier(for: self.player)
        }
        
        ////////////////////////
        // KNOWN ATTACKER
        ////////////////////////
        
        if let attacker = attacker {
            
            return self.combatStrength(against: attacker) + modifier
        }
        
        return self.combatStrength(towards: toTile) + modifier
    }
    
    // https://civilization.fandom.com/wiki/Combat_(Civ6)
    func combatStrength() -> Int {
        // Damage of wounded units is diminished up to a half of the original strength (formula is 1/2 + 1/2 * HP Portion), which means that units with 1/2 HP deal 3/4 of normal damage and units with 1% HP deal just above 1/2 of normal damage).
        
        let ratio = Double(self.healthPointsValue) / (2.0 * Unit.maxHealth) /* => 0..0.5 */ + 0.5 /* => 0.5..1.0 */
        return Int(Double(self.type.meleeStrength()) * ratio)
    }
    
    func combatStrength(towards tile: AbstractTile?) -> Int {
        
        if tile == nil {
            return self.combatStrength()
        }
        
        //fatalError("not implemented yet")
        return self.combatStrength()
    }
    
    func combatStrength(against unit: AbstractUnit?) -> Int {
        
        if unit == nil {
            return self.combatStrength()
        }
        
        if let unit = unit {
            
            let distance = unit.location.distance(to: self.location)
            
            if self.range() > 0 && distance <= self.range() {
                
                // ranged attack
                var strength = self.type.rangedStrength()
                
                strength += self.type.unitClassModifier(for: unit.classClass())
                
                let healthRatio = Double(self.healthPointsValue) / (2.0 * Unit.maxHealth) /* => 0..0.5 */ + 0.5 /* => 0.5..1.0 */
                
                return Int(Double(strength) * healthRatio)
                
            } else if self.range() == 0 && distance == 1 {
                
                // normal attack
                var strength = self.type.meleeStrength()
                
                strength += self.type.unitClassModifier(for: unit.classClass())
                
                let healthRatio = Double(self.healthPointsValue) / (2.0 * Unit.maxHealth) /* => 0..0.5 */ + 0.5 /* => 0.5..1.0 */
                
                return Int(Double(strength) * healthRatio)
            }
            
            return 0
        }
        
        fatalError("not gonna happen")
    }
    
    // Combat eligibility routines
    func isCombatUnit() -> Bool {
        
        return self.type.meleeStrength() > 0
    }
    
    func rangedStrength() -> Int {
        
        let ratio = Double(self.healthPointsValue) / (2.0 * Unit.maxHealth) /* => 0..0.5 */ + 0.5 /* => 0.5..1.0 */
        return Int(Double(self.type.rangedStrength()) * ratio)
    }
    
    func canMoveOrAttack(into point: HexPoint) -> Bool {
        
        fatalError("not implemented")
    }
    
    func canAttackWithMove() -> Bool {
        
        if self.isCombatUnit() {
            return false
        }
        
        return true
    }
    
    func canAttack() -> Bool {
        
        return self.canAttackWithMove() || canAttackRanged()
    }
    
    func baseRangedCombatStrength() -> Int {
        
        return self.type.rangedStrength()
    }
    
    /// Does this unit have a ranged attack?
    func canAttackRanged() -> Bool {
        
        return self.range() > 0 &&  self.baseRangedCombatStrength() > 0
    }
    
    func canRangeStrike(at point: HexPoint, needWar: Bool, noncombatAllowed: Bool) -> Bool {
        
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
    func canDefend() -> Bool {
        
        // This will catch both embarked units and noncombatants
        if self.baseCombatStrength() == 0 {
            return false
        }
        
        return true
    }
    
    func canSentry(in gameModel: GameModel?) -> Bool {
        
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
    
    func isWaiting() -> Bool {
        
        return self.activityTypeValue == .hold || self.activityTypeValue == .sleep || self.activityTypeValue == .heal || self.activityTypeValue == .sentry || self.activityTypeValue == .intercept
    }
    
    //    ---------------------------------------------------------------------------
    // Get the base movement points for the unit.
    // Parameters:
    //        eIntoDomain    - If NO_DOMAIN, this will use the units current domain.
    //                      This can give different results based on whether the unit is currently embarked or not.
    //                      Passing in DOMAIN_SEA will return the units baseMoves as if it were already embarked.
    //                      Passing in DOMAIN_LAND will return the units baseMoves as if it were on land, even if it is currently embarked.
    func baseMoves(into domain: UnitDomainType = .none, in gameModel: GameModel?) -> Int {
        
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
         
            extraNavalMoves = self.extraNavalMoves()
            
            if self.baseCombatStrength() == 0 {
                extraNavalMoves = ability.extraEmbarkMoves()
            }
        }
        
        var extraGoldenAgeMoves = 0
        if player.hasGoldenAge() {
            extraGoldenAgeMoves += ability.goldenAgeMovesChange()
        }
        
        let extraUnitCombatTypeMoves = 0 // ???
        return self.type.moves() /*+ self.extraMoves()*/ + extraNavalMoves + extraGoldenAgeMoves + extraUnitCombatTypeMoves
    }
    
    func isImpassable(terrain: TerrainType) -> Bool {
        
        if terrain == .ocean && self.type.abilities().contains(.oceanImpassable) {
            
            return false
        }
        
        return true
    }
    
    func extraNavalMoves() -> Int {
        
        // check promotions here?
        
        // FIXME
        //self.promotions?.has(promotion: <#T##UnitPromotionType#>)
        return 0
    }
    
    func canMove() -> Bool {
        
        return self.moves() > 0
    }
    
    func moves() -> Int {
        
        return self.movesValue
    }
    
    func finishMoves() {
        
        self.movesValue = 0
    }
    
    func maxMoves(in gameModel: GameModel?) -> Int {
        
        return self.baseMoves(in: gameModel) //self.type.moves()
    }
    
    func hasMoved(in gameModel: GameModel?) -> Bool {
        
        return self.moves() < self.maxMoves(in: gameModel)
    }
    
    func movesLeft() -> Int {
        
        return max(0, self.moves())
    }
    
    func movementType() -> UnitMovementType {
        
        return self.type.movementType()
    }
    
    func sight() -> Int {
        
        var sightValue = self.type.sight()
        
        if let promotions = self.promotions {
            
            // +1 sight range.
            if promotions.has(promotion: .spyglass) {
                sightValue += 1
            }
        }
        
        return sightValue
    }
    
    func range() -> Int {
        
        return self.type.range()
    }
    
    // MARK: suppression
    
    func suppression() -> Int {
        
        return self.suppressionValue
    }
    
    func isSuppressed() -> Bool {
        
        return self.suppressionValue > 0
    }
    
    func set(suppression: Int) {
        
        self.suppressionValue = suppression
    }
    
    // MARK: entrechment / fortification
    
    func canEntrench() -> Bool {
        
        return false // FIXME
    }
    
    func doEntrench() {
        
        //self.fortifyTurns += 1
        fatalError("not implemented")
    }
    
    func isEntrenched() -> Bool {
        
        return false
    }
    
    func entrenchment() -> Int {
        
        return 0
    }
    
    func decreaseEntrenchment(by amount: Int = 1) {
        fatalError("not implemented")
    }
    
    // MARK: experience
    
    func experience() -> Int {
        
        return self.experienceValue
    }
    
    func gain(experience delta: Int, in gameModel: GameModel?) {
        
        guard let promotions = self.promotions else {
            fatalError("cant get promotions")
        }
        
        guard let player = self.player else {
            fatalError("cant get promotions")
        }
        
        self.experienceValue += delta
        
        let level = self.experienceLevel()
        
        // promotion message
        if promotions.count() < (level - 1) {
            
            if player.isHuman() {
                gameModel?.add(message: PromotionGainedMessage(unit: self))
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
            weightedPromotion.add(weight: self.valueOf(promotion: promotion), for: promotion)
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
    
    func isOf(unitType: UnitType) -> Bool {
        
        return self.type == unitType
    }
    
    func hasSameType(as otherUnit: AbstractUnit?) -> Bool {
        
        return otherUnit?.isOf(unitType: self.type) ?? false
    }
    
    func isOf(unitClass: UnitClassType) -> Bool {
        
        return self.type.unitClass() == unitClass
    }
    
    func has(task: UnitTaskType) -> Bool {
        
        return self.type.unitTasks().contains(task)
    }
    
    func domain() -> UnitDomainType {
        
        return self.type.domain()
    }

    func canDo(command: UnitCommandTypes) -> Bool {
        
        return false
    }
    
    func can(automate: UnitAutomationType) -> Bool {
        
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
    
    func isAutomated() -> Bool {
        
        return self.automation != .none
    }
    
    func automateType() -> UnitAutomationType {
        
        return self.automation
    }
   
    func isFound() -> Bool {
        
        return self.type.canFound()
    }
    
    func canFound(at location: HexPoint, in gameModel: GameModel?) -> Bool {
        
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
    
    func doFound(with name: String? = nil, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if !self.canFound(at: self.location, in: gameModel) {
            return false
        }
        
        let cityName = name ?? "no name" // FIXME
        let isCapital = gameModel.cities(of: player).count == 0
        
        let city = City(name: cityName, at: self.location, capital: isCapital, owner: player)
        city.initialize()
        
        gameModel.add(city: city)
        
        self.doKill(in: gameModel)
        
        return true
    }
    
    func doKill(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // FIXME - add die visualization
        
        gameModel.remove(unit: self)
    }
    
    func doPillage(in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // FIXME
        /*if !self.canPillage(at: self.location, in: gameModel) {
            return false
        }*/
        
        if let tile = gameModel.tile(at: self.location) {
            if let improvement = tile.improvement() {
                if !improvement.canBePillaged() {
                    return false
                } else {
                    tile.removeImprovement()
                    return true
                }
            }
        }
        
        return false
    }
    
    func doRebase(to point: HexPoint) -> Bool {
        
        // FIXME
        return false
    }
    
    func canReach(at point: HexPoint, in turns: Int, in gameModel: GameModel?) -> Bool {
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel?.ignoreUnitsPathfinderDataSource(for: self.movementType(), for: self.player)
        
        if let path = pathFinder.shortestPath(fromTileCoord: self.location, toTileCoord: point) {
        
            let turnsNeeded = path.count / self.moves()
            return turnsNeeded <= turns
        }
        
        return false
    }
    
    func turnsToReach(at point: HexPoint, in gameModel: GameModel?) -> Int {
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel?.ignoreUnitsPathfinderDataSource(for: self.movementType(), for: self.player)
        
        if let path = pathFinder.shortestPath(fromTileCoord: self.location, toTileCoord: point) {
            
            let turnsNeeded = path.count / self.moves()
            return turnsNeeded
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

    func isBarbarian() -> Bool {
        
        if let civ = self.player?.leader.civilization() {
            return civ == .barbarian
        }
        
        return false
    }
    
    func canEmbark(into point: HexPoint? = nil, in gameModel: GameModel?) -> Bool {
        
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
    
    func doEmbark(into point: HexPoint? = nil, in gameModel: GameModel?) -> Bool {
        
        if !self.canEmbark(into: point, in: gameModel) {
            fatalError("throw")
        }
        
        self.isEmbarkedValue = true
        
        return true
    }
    
    func canDisembark(into point: HexPoint? = nil, in gameModel: GameModel?) -> Bool {
        
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
    
    func doDisembark(into point: HexPoint? = nil, in gameModel: GameModel?) -> Bool {
        
        if !self.canDisembark(into: point, in: gameModel) {
            fatalError("throw")
        }
        
        self.isEmbarkedValue = false
        
        return true
    }
    
    func isEmbarked() -> Bool {
        
        return self.isEmbarkedValue
    }
    
    func preTurn(in gameModel: GameModel?) {
        
        // reset moves
        self.movesValue = self.maxMoves(in: gameModel)
    }
    
    func turn(in gameModel: GameModel?) {
        
        // damage from features?
        
        // FIXME

    }
    
    func set(turnProcessed: Bool) {
        
        self.processedInTurnValue = turnProcessed
    }
    
    func processedInTurn() -> Bool {
        
        return self.processedInTurnValue
    }
    
    func set(tacticalMove: TacticalMoveType) {
        
        self.tacticalMoveValue = tacticalMove
    }
    
    func tacticalMove() -> TacticalMoveType? {
        
        return self.tacticalMoveValue
    }
    
    func isUnderTacticalControl() -> Bool {
        
        return self.tacticalMoveValue != TacticalMoveType.none
    }
    
    func set(tacticalTarget: HexPoint) {
        
        self.tacticalTargetValue = tacticalTarget
    }
    
    func tacticalTarget() -> HexPoint? {
        
        return self.tacticalTargetValue
    }
    
    func resetTacticalMove() {
        
        self.tacticalMoveValue = nil
        self.tacticalTargetValue = nil
    }
    
    func army() -> Army? {
        
        return self.armyRef
    }
    
    func assign(to army: Army?) {
        
        self.armyRef = army
    }
    
    func isEqual(to other: AbstractUnit?) -> Bool {
        
        guard let other = other else {
            fatalError("cant get other")
        }
        
        return self.location == other.location && other.isOf(unitType: self.type)
    }
}

// MARK: mission methods
extension Unit {
    
    func activityType() -> UnitActivityType {
        
        return self.activityTypeValue
    }
    
    func set(activityType: UnitActivityType) {
        
        self.activityTypeValue = activityType
    }
    
    /// Eligible to start a new mission?
    func canStart(mission: UnitMission, in gameModel: GameModel?) -> Bool {
         
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
            break
            // FIXME
            /*if let target = mission.target {
                if self.canGarrison(at: target) {
                    return true
                }
            } else {
                if self.canGarrison(at: self.location) {
                    return true
                }
            }*/
        case .pillage:
            break
            // FIXME
            /*if self.canPillage() {
                return true
            }*/
        case .skip:
            break
            // FIXME
            /*if self.canHold() {
                return true
            }*/
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
            if self.canEntrench() {
                return true
            }
        case .alert:
            break
            // FIXME
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
            }
        }
        
        return false
    }
    
    func push(mission: UnitMission, in gameModel: GameModel?) {
        
        self.missions.push(mission)
        
        mission.unit = self
        
        mission.start(in: gameModel)
    }
    
    func popMission() {
        
        self.missions.pop()
    }
    
    func updateMission() {
        
        if self.missionTimer > 0 {
            
            self.missionTimer -= 1
            
            if self.missionTimer == 0 {
                
                if self.activityTypeValue == .mission {
                    
                    if let headMission = self.missions.peek() {
                        headMission.continueMission()
                    }
                }
            }
        }
        /*if let headMission = self.missions.peek() {
            headMission.update()
        }*/
    }
}
