//
//  TacticalAnalysisMap.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 24.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum TacticalDominanceTerritoryType {

    case tempZone
    case enemy
    case friendly
    case neutral
    case noOwner
}

enum TacticalDominanceType {

    case noUnitsPresent
    case notVisible
    case friendly
    case enemy
    case even
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      TacticalAnalysisMap
//!  \brief        Shared spatial map used by all AI players to analyze moves when at war
//
//!  Key Attributes:
//!  - Created by CvGame class
//!  - Shared by all players; data is refreshed at start of each AI turn if player at war
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class TacticalAnalysisMap {
    
    let dominancePercentage = 25 // AI_TACTICAL_MAP_DOMINANCE_PERCENTAGE
    let tacticalRange = 10 // AI_TACTICAL_RECRUIT_RANGE
    let unitStrengthMultiplier: Int // 10 AI_TACTICAL_MAP_UNIT_STRENGTH_MULTIPLIER * tacticalRange
    let tempZoneRadius = 5 // AI_TACTICAL_MAP_TEMP_ZONE_RADIUS
    var bestFriendlyRangeValue = 0

    var turnBuild: Int
    var playerBuild: AbstractPlayer?
    var isBuild: Bool
    var plots: Array2D<TacticalAnalysisCell>
    var enemyUnits: [AbstractUnit?]
    var dominanceZones: [TacticalDominanceZone]
    var ignoreLineOfSight: Bool

    // MARK: internal class

    class TacticalAnalysisCell: Codable, Equatable {

        var bits: BitArray

        var enemyMilitaryUnit: AbstractUnit?
        var enemyCivilianUnit: AbstractUnit?
        var neutralMilitaryUnit: AbstractUnit?
        var neutralCivilianUnit: AbstractUnit?
        var friendlyMilitaryUnit: AbstractUnit?
        var friendlyCivilianUnit: AbstractUnit?

        var defenseModifier: Int
        var deploymentScore: Int
        var targetType: TacticalTargetType

        var dominanceZone: TacticalDominanceZone?

        enum CodingKeys: String, CodingKey {
            case bits
        }

        init() {
            self.bits = BitArray(count: 24)
            
            self.enemyMilitaryUnit = nil
            self.enemyCivilianUnit = nil
            self.neutralMilitaryUnit = nil
            self.neutralCivilianUnit = nil
            self.friendlyMilitaryUnit = nil
            self.friendlyCivilianUnit = nil
            
            self.defenseModifier = 0
            self.deploymentScore = 0
            self.targetType = .none
            
            self.dominanceZone = nil
        }

        required init(from decoder: Decoder) throws {

            let values = try decoder.container(keyedBy: CodingKeys.self)

            self.bits = try values.decode(BitArray.self, forKey: .bits)
            
            self.enemyMilitaryUnit = nil
            self.enemyCivilianUnit = nil
            self.neutralMilitaryUnit = nil
            self.neutralCivilianUnit = nil
            self.friendlyMilitaryUnit = nil
            self.friendlyCivilianUnit = nil
            
            self.defenseModifier = 0
            self.deploymentScore = 0
            self.targetType = .none
            
            self.dominanceZone = nil
        }

        func reset() {

            self.bits.reset()

            self.enemyMilitaryUnit = nil
            self.enemyCivilianUnit = nil
            self.neutralMilitaryUnit = nil
            self.neutralCivilianUnit = nil
            self.friendlyMilitaryUnit = nil
            self.friendlyCivilianUnit = nil

            self.defenseModifier = 0
            self.deploymentScore = 0
            self.targetType = .none
            
            self.dominanceZone = nil
        }
        
        // TACTICAL_FLAG_REVEALED

        // Is this plot revealed to this player?
        // TACTICAL_FLAG_VISIBLE
        var revealed: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 0) }
            get { return self.bits.valueOfBit(at: 0) }
        }
        
        func isRevealed() -> Bool {
            return self.bits.valueOfBit(at: 0)
        }

        // Is this plot visible to this player?
        var visible: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 1) }
            get { return self.bits.valueOfBit(at: 1) }
        }
        
        func isVisivle() -> Bool {
            return self.bits.valueOfBit(at: 1)
        }

        // Is this terrain impassable to this player?
        // TACTICAL_FLAG_IMPASSABLE_TERRAIN
        var impassableTerrain: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 2) }
            get { return self.bits.valueOfBit(at: 2) }
        }

        // Is this neutral territory impassable to this player?
        // TACTICAL_FLAG_IMPASSABLE_TERRITORY
        var impassableTerritory: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 3) }
            get { return self.bits.valueOfBit(at: 3) }
        }

        // A tile no enemy unit can see?
        // TACTICAL_FLAG_NOT_VISIBLE_TO_ENEMY
        var notVisibleToEnemy: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 4) }
            get { return self.bits.valueOfBit(at: 4) }
        }

        // Enemy can strike at a unit here
        // TACTICAL_FLAG_SUBJECT_TO_ENEMY_ATTACK
        var subjectToAttack: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 5) }
            get { return self.bits.valueOfBit(at: 5) }
        }
        
        func isSubjectToAttack() -> Bool {
            
            return self.bits.valueOfBit(at: 5)
        }

        // Enemy can move to this tile and still have movement left this turn
        // TACTICAL_FLAG_FRIENDLY_TURN_END_TILE
        var enemyCanMovePast: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 6) }
            get { return self.bits.valueOfBit(at: 6) }
        }
        
        func isEnemyCanMovePast() -> Bool {
            
            return self.bits.valueOfBit(at: 6)
        }

        // Is one of our friendly units ending its move here?
        var friendlyTurnEndTile: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 7) }
            get { return self.bits.valueOfBit(at: 7) }
        }
        
        func isFriendlyTurnEndTile() -> Bool {
                
            return self.bits.valueOfBit(at: 7)
        }

        // Friendly city here?
        // TACTICAL_FLAG_FRIENDLY_CITY
        var friendlyCity: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 8) }
            get { return self.bits.valueOfBit(at: 8) }
        }

        // Enemy city here?
        // TACTICAL_FLAG_ENEMY_CITY
        var enemyCity: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 9) }
            get { return self.bits.valueOfBit(at: 9) }
        }

        // Neutral city here?
        // TACTICAL_FLAG_NEUTRAL_CITY
        var neutralCity: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 10) }
            get { return self.bits.valueOfBit(at: 10) }
        }

        var city: Bool {
            get { return self.friendlyCity || self.enemyCity || self.neutralCity }
        }

        // Water?
        // TACTICAL_FLAG_WATER
        var water: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 11) }
            get { return self.bits.valueOfBit(at: 11) }
        }
        
        func isWater() -> Bool {
            
            return self.water
        }

        // Ocean?
        // TACTICAL_FLAG_OCEAN
        var ocean: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 12) }
            get { return self.bits.valueOfBit(at: 12) }
        }
        
        func isOcean() -> Bool {
            
            return self.ocean
        }

        // Territory owned by the active player
        // TACTICAL_FLAG_OWN_TERRITORY
        var ownTerritory: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 13) }
            get { return self.bits.valueOfBit(at: 13) }
        }

        // Territory owned by allies
        // TACTICAL_FLAG_FRIENDLY_TERRITORY
        var friendlyTerritory: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 14) }
            get { return self.bits.valueOfBit(at: 14) }
        }

        // Territory owned by enemies
        // TACTICAL_FLAG_ENEMY_TERRITORY
        var enemyTerritory: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 15) }
            get { return self.bits.valueOfBit(at: 15) }
        }

        // Territory that is unclaimed
        // TACTICAL_FLAG_UNCLAIMED_TERRITORY
        var unclaimedTerritory: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 16) }
            get { return self.bits.valueOfBit(at: 16) }
        }
        
        // Is this a plot we can use to bombard the target?
        // TACTICAL_FLAG_WITHIN_RANGE_OF_TARGET
        var withinRangeOfTarget: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 17) }
            get { return self.bits.valueOfBit(at: 17) }
        }
        
        func isWithinRangeOfTarget() -> Bool {
            
            return self.bits.valueOfBit(at: 17)
        }

        // Does this plot help provide a flanking bonus on target?
        // TACTICAL_FLAG_CAN_USE_TO_FLANK
        var canUseToFlank: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 18) }
            get { return self.bits.valueOfBit(at: 18) }
        }
           
        // Should be a safe spot to deploy ranged units
        // TACTICAL_FLAG_SAFE_DEPLOYMENT
        var safeDeployment: Bool {
            set { self.bits.setValueOfBit(value: newValue, at: 19) }
            get { return self.bits.valueOfBit(at: 19) }
        }

        static func == (lhs: TacticalAnalysisMap.TacticalAnalysisCell, rhs: TacticalAnalysisMap.TacticalAnalysisCell) -> Bool {
            fatalError("not implemented yet")
        }

        func canUseForOperationGathering() -> Bool {

            if self.impassableTerrain || self.impassableTerritory || self.enemyMilitaryUnit != nil || self.neutralMilitaryUnit != nil || self.neutralCivilianUnit != nil || self.friendlyTurnEndTile || self.enemyCity || self.neutralCity {
                return false
            }

            return true
        }

        func canUseForOperationGatheringCheckWater(isWater: Bool) -> Bool {

            if isWater != self.water || self.impassableTerrain || self.impassableTerritory || self.enemyMilitaryUnit != nil || self.neutralMilitaryUnit != nil || self.neutralCivilianUnit != nil || self.friendlyTurnEndTile || self.enemyCity || self.neutralCity {
                return false
            }

            return true
        }
    }

    struct TacticalDominanceZone: Equatable {
        
        var territoryType: TacticalDominanceTerritoryType
        var dominanceFlag: TacticalDominanceType
        var owner: AbstractPlayer?
        var area: HexArea?
        var isWater: Bool
        var closestCity: AbstractCity?
        var center: AbstractTile?
        var navalInvasion: Bool

        var friendlyStrength: Int
        var friendlyRangedStrength: Int
        var friendlyUnitCount: Int
        var friendlyRangedUnitCount: Int
        
        var enemyStrength: Int
        var enemyRangedStrength: Int
        var enemyUnitCount: Int
        var enemyRangedUnitCount: Int
        var enemyNavalUnitCount: Int

        var rangeClosestEnemyUnit: Int
        
        var dominanceValue: Int
        
        static func == (lhs: TacticalAnalysisMap.TacticalDominanceZone, rhs: TacticalAnalysisMap.TacticalDominanceZone) -> Bool {
            return lhs.center?.point == rhs.center?.point
        }
    }

    // MARK: constructor

    init(with mapSize: MapSize) {

        self.unitStrengthMultiplier = 10 * self.tacticalRange

        self.plots = Array2D<TacticalAnalysisCell>(width: mapSize.width(), height: mapSize.height())
        self.turnBuild = -1
        self.isBuild = false
        self.enemyUnits = []
        self.dominanceZones = []
        self.ignoreLineOfSight = false
    }

    /// Fill the map with data for this AI player's turn
    func refresh(for player: AbstractPlayer?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = player else {
            fatalError("cant get player")
        }

        if self.turnBuild < gameModel.currentTurn || player.leader != self.playerBuild?.leader {

            self.isBuild = false
            self.playerBuild = player
            self.turnBuild = gameModel.currentTurn

            // AI civs build this map every turn
            if true /*player.leader.civilization() != .barbarian*/ {

                self.dominanceZones.removeAll()
                self.addTemporaryZones(in: gameModel)

                for x in 0..<self.plots.width {
                    for y in 0..<self.plots.height {

                        let pt = HexPoint(x: x, y: y)
                        if let tile = gameModel.tile(at: pt) {

                            if self.populateCell(at: pt, with: tile, in: gameModel) {

                                if let zone = self.dominanceZone(for: self.plots[pt], with: tile, in: gameModel) {

                                    // Set zone for this cell
                                    self.dominanceZones.append(zone)
                                    self.plots[pt]?.dominanceZone = zone
                                }
                            }
                        } else {
                            // Erase this cell
                            self.plots[pt]?.reset()
                        }
                    }
                }

                self.calculateMilitaryStrengths(in: gameModel)
                self.prioritizeZones(in: gameModel)
                self.buildEnemyUnitList(in: gameModel)
                self.markCellsNearEnemy(in: gameModel)

                self.isBuild = true
            }
        }
    }
    
    func bestFriendlyRange() -> Int {
        
        return self.bestFriendlyRangeValue
    }
    
    func canIgnoreLightOfSight() -> Bool {
        
        return self.ignoreLineOfSight
    }
    
    func set(bestFriendlyRange value: Int) {
        
        self.bestFriendlyRangeValue = value
    }
    
    // Clear all dynamic data flags from the map
    func clearDynamicFlags() {
        
        for x in 0..<self.plots.width {
            for y in 0..<self.plots.height {
                
                self.plots[x, y]?.withinRangeOfTarget = false
                self.plots[x, y]?.canUseToFlank = false
                self.plots[x, y]?.safeDeployment = false
                self.plots[x, y]?.deploymentScore = 0
            }
        }
    }
    
    /// Mark cells we can use to bomb a specific target
    func setTargetBombardCells(target: HexPoint, bestFriendlyRange range: Int, canIgnoreLightOfSight: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let targetPlot = gameModel.tile(at: target) else {
            fatalError("cant get targetPlot")
        }

        for dx in -range...range {
            for dy in -range...range {
                
                let loopPoint = HexPoint(x: target.x + dx, y: target.y + dy)
                
                guard let loopPlot = gameModel.tile(at: loopPoint) else {
                    continue
                }
                
                let distance = loopPoint.distance(to: target)
                
                if distance > 0 && distance <= range {
                    
                    guard let plot = self.plots[loopPoint] else {
                        continue
                    }
                     
                    if plot.revealed && !plot.impassableTerrain && !plot.impassableTerritory {
                        
                        if !plot.enemyCity && !plot.neutralCity {
                            if ignoreLineOfSight || loopPlot.canSee(tile: targetPlot, for: self.playerBuild, range: range, in: gameModel) {
                                plot.withinRangeOfTarget = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Mark cells we can use to bomb a specific target
    func setTargetFlankBonusCells(target: AbstractTile?, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        //CvPlot* pLoopPlot;
        //int iPlotIndex;

        // No flank attacks on units at sea (where all combat is bombards)
        if target.isWater() {
            return
        }

        for loopPoint in target.point.neighbors() {
            
            guard let plot = self.plots[loopPoint] else {
                continue
            }
            
            if plot.isRevealed() && !plot.impassableTerrain && !plot.impassableTerritory {
                if !plot.friendlyCity && !plot.enemyCity && !plot.neutralCity {
                    if !plot.isFriendlyTurnEndTile() && plot.enemyMilitaryUnit == nil {
                        plot.canUseToFlank = true
                    }
                }
            }
        }
    }
    
    // Is this plot in dangerous territory?
    func isInEnemyDominatedZone(at point: HexPoint) -> Bool {

        let cell = self.plots[point]
        
        for dominanceZone in self.dominanceZones {
            
            if cell?.dominanceZone == dominanceZone {
                
                return dominanceZone.dominanceFlag == .enemy || dominanceZone.dominanceFlag == .notVisible
            }
        }

        return false
    }

    // PRIVATE FUNCTIONS

    /// Add data for this cell into dominance zone information
    private func dominanceZone(for cell: TacticalAnalysisCell?, with tile: AbstractTile?, in gameModel: GameModel?) -> TacticalDominanceZone? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let player = self.playerBuild else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        // Compute zone data for this cell
        var territoryType: TacticalDominanceTerritoryType = .tempZone

        let owner = tile.owner()
        if owner == nil {
            territoryType = .noOwner
        } else if owner?.leader == player.leader {
            territoryType = .friendly
        } else if diplomacyAI.isAtWar(with: owner) {
            territoryType = .enemy
        } else {
            territoryType = .neutral
        }

        var bestCity: AbstractCity? = nil
        var bestDistance = Int.max
        if territoryType == .enemy || territoryType == .neutral || territoryType == .friendly {

            if let owner = owner {
                for cityRef in gameModel.cities(of: owner) {

                    if let city = cityRef {
                        let distance = city.location.distance(to: tile.point)

                        if distance < bestDistance {
                            bestDistance = distance
                            bestCity = cityRef
                        }
                    }
                }
            }
        }

        var tempZoneRef: TacticalDominanceZone?

        // Now see if we already have a matching zone
        if let zone = self.findExistingZone(for: tile, territoryType: territoryType, owner: owner, city: bestCity, area: tile.area) {

            tempZoneRef = zone
        } else {
            tempZoneRef = TacticalDominanceZone(territoryType: territoryType, dominanceFlag: .noUnitsPresent, owner: owner, area: tile.area, isWater: tile.terrain().isWater(), closestCity: bestCity, center: tile, navalInvasion: false, friendlyStrength: 0, friendlyRangedStrength: 0, friendlyUnitCount: 0, friendlyRangedUnitCount: 0, enemyStrength: 0, enemyRangedStrength: 0, enemyUnitCount: 0, enemyRangedUnitCount: 0, enemyNavalUnitCount: 0, rangeClosestEnemyUnit: 0, dominanceValue: 0)
        }

        // If this isn't owned territory, update zone with military strength info
        if tempZoneRef?.territoryType == TacticalDominanceTerritoryType.noOwner || tempZoneRef?.territoryType == TacticalDominanceTerritoryType.tempZone {

            if var tempZone = tempZoneRef {

                if let friendlyUnit = cell?.friendlyMilitaryUnit {

                    if friendlyUnit.domain() == .air ||
                        (friendlyUnit.domain() == .land && !tempZone.isWater) ||
                        (friendlyUnit.domain() == .sea && tempZone.isWater) {
                        
                        var strength = friendlyUnit.attackStrength(against: nil, or: nil, on: nil, in: gameModel)
                        if strength == 0 && friendlyUnit.isEmbarked() && !tempZone.isWater {
                            strength = friendlyUnit.baseCombatStrength(ignoreEmbarked: true)
                        }
                        
                        tempZone.friendlyStrength += strength * self.unitStrengthMultiplier
                        tempZone.friendlyRangedStrength += friendlyUnit.rangedCombatStrength(against: nil, or: nil, on: nil, attacking: true, in: gameModel)
                        
                        if friendlyUnit.range() > self.bestFriendlyRangeValue {
                            self.bestFriendlyRangeValue = friendlyUnit.range()
                        }
                        
                        tempZone.friendlyUnitCount += 1
                    
                        if friendlyUnit.range() > 0 {
                            tempZone.friendlyRangedUnitCount += 1
                        }
                    }
                }
                
                if let enemyUnit = cell?.enemyMilitaryUnit {
                    
                    if enemyUnit.domain() == .air ||
                        (enemyUnit.domain() == .land && !tempZone.isWater) ||
                        (enemyUnit.domain() == .sea && tempZone.isWater) {
                        
                        var strength = enemyUnit.attackStrength(against: nil, or: nil, on: nil, in: gameModel)
                        if strength == 0 && enemyUnit.isEmbarked() && !tempZone.isWater {
                            strength = enemyUnit.baseCombatStrength(ignoreEmbarked: true)
                        }
                        
                        tempZone.enemyStrength += strength * self.unitStrengthMultiplier
                        tempZone.enemyRangedStrength += enemyUnit.rangedCombatStrength(against: nil, or: nil, on: nil, attacking: true, in: gameModel)
                        tempZone.enemyUnitCount += 1
                        
                        if enemyUnit.range() > 0 {
                            tempZone.enemyRangedUnitCount += 1
                        }
                        
                        if enemyUnit.domain() == .sea {
                            tempZone.enemyNavalUnitCount += 1
                        }
                    }
                }
            }
        }
        
        // Set zone for this cell
        cell?.dominanceZone = tempZoneRef
        
        return tempZoneRef
    }

    private func findExistingZone(for tile: AbstractTile?, territoryType: TacticalDominanceTerritoryType, owner: AbstractPlayer?, city: AbstractCity?, area: HexArea?) -> TacticalDominanceZone? {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        for dominanceZone in self.dominanceZones {

            // If this is a temporary zone, matches if unowned and close enough
            if dominanceZone.territoryType == .tempZone &&
                (territoryType == .noOwner || territoryType == .neutral) &&
                tile.point.distance(to: dominanceZone.center!.point) <= self.tempZoneRadius {

                return dominanceZone
            }

            // If not friendly or enemy, just 1 zone per area
            if (dominanceZone.territoryType == .noOwner || dominanceZone.territoryType == .neutral) &&
                (territoryType == .noOwner || territoryType == .neutral) &&
                dominanceZone.area == area {

                return dominanceZone
            }

            // Otherwise everything needs to match
            if dominanceZone.territoryType == territoryType &&
                dominanceZone.owner?.leader == owner?.leader &&
                dominanceZone.area == area &&
                dominanceZone.closestCity?.location == city?.location {

                return dominanceZone
            }
        }

        return nil
    }

    /// Calculate military presences in each owned dominance zone
    private func calculateMilitaryStrengths(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.playerBuild else {
            fatalError("cant get player")
        }

        // Loop through the dominance zones
        for var dominanceZone in self.dominanceZones {

            if dominanceZone.territoryType == .noOwner {

                if let closestCity = dominanceZone.closestCity {

                    // Start with strength of the city itself
                    let strength = closestCity.rangedCombatStrength(against: nil, on: nil, attacking: true) * self.tacticalRange

                    if dominanceZone.territoryType == .friendly {

                        dominanceZone.friendlyStrength += strength
                        dominanceZone.friendlyRangedStrength += closestCity.rangedCombatStrength(against: nil, on: nil, attacking: true)
                    } else {

                        dominanceZone.enemyStrength += strength
                        dominanceZone.enemyRangedStrength += closestCity.rangedCombatStrength(against: nil, on: nil, attacking: true)
                    }

                    // Loop through all of OUR units first
                    for unitRef in gameModel.units(of: player) {

                        if let unit = unitRef {

                            if unit.isCombatUnit() {

                                if unit.domain() == .air || unit.domain() == .land && !dominanceZone.isWater || unit.domain() == .sea && dominanceZone.isWater {

                                    let distance = closestCity.location.distance(to: unit.location)
                                    let multiplier = self.tacticalRange + 1 - distance

                                    if multiplier > 0 {

                                        var unitStrength = unit.attackStrength(against: nil, or: nil, on: nil, in: gameModel)
                                        if unitStrength == 0 && unit.isEmbarked() && !dominanceZone.isWater {
                                            unitStrength = unit.baseCombatStrength(ignoreEmbarked: true)
                                        }

                                        dominanceZone.friendlyStrength += unitStrength * multiplier * self.unitStrengthMultiplier
                                        dominanceZone.friendlyRangedStrength += unit.rangedCombatStrength(against: nil, or: nil, on: nil, attacking: true, in: gameModel)

                                        if unit.range() > self.bestFriendlyRangeValue {
                                            self.bestFriendlyRangeValue = unit.range()
                                        }

                                        dominanceZone.friendlyUnitCount += 1
                                    }
                                }
                            }
                        }
                    }
                    
                    // Repeat for all visible enemy units (or adjacent to visible)
                    for otherPlayer in gameModel.players {
                        
                        if player.isAtWar(with: otherPlayer) {
                            
                            for loopUnitRef in gameModel.units(of: otherPlayer) {
                                
                                guard let loopUnit = loopUnitRef else {
                                    continue
                                }
                                
                                if loopUnit.isCombatUnit() {
                                    
                                    if loopUnit.domain() == .air ||
                                        (loopUnit.domain() == .land && !dominanceZone.isWater) ||
                                        (loopUnit.domain() == .sea && dominanceZone.isWater) {
    
                                        if let plot = gameModel.tile(at: loopUnit.location) {
                                            
                                            var visible = true
                                            let distance = loopUnit.location.distance(to: closestCity.location)
                                            
                                            if distance <= self.tacticalRange {
                                                
                                                let multiplier = (self.tacticalRange + 4 - distance)  // "4" so unit strength isn't totally dominated by proximity to city
                                                if !plot.isVisible(to: player) && !gameModel.isAdjacentDiscovered(of: loopUnit.location, for: player) {
                                                    visible = false
                                                }
                                                
                                                if multiplier > 0 {
                                                    
                                                    var unitStrength = loopUnit.attackStrength(against: nil, or: nil, on: nil, in: gameModel)
                                                    if unitStrength == 0 && loopUnit.isEmbarked() && !dominanceZone.isWater {
                                                        unitStrength = loopUnit.baseCombatStrength(ignoreEmbarked: true)
                                                    }

                                                    if !visible {
                                                        unitStrength /= 2
                                                    }

                                                    dominanceZone.enemyStrength += unitStrength * multiplier * unitStrengthMultiplier

                                                    var rangedStrength = loopUnit.rangedCombatStrength(against: nil, or: nil, on: nil, attacking: true, in: gameModel)
                                                    if !visible {
                                                        rangedStrength /= 2
                                                    }

                                                    dominanceZone.enemyRangedStrength = rangedStrength

                                                    if visible {
                                                        dominanceZone.enemyUnitCount += 1
                                                        if distance < dominanceZone.rangeClosestEnemyUnit {
                                                            dominanceZone.rangeClosestEnemyUnit = distance
                                                        }
                                                        
                                                        if loopUnit.isRanged() {
                                                            dominanceZone.enemyRangedUnitCount += 1
                                                        }
                                                        if loopUnit.domain() == .sea {
                                                            dominanceZone.enemyNavalUnitCount += 1
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }
    }

    /// Establish order of zone processing for the turn
    private func prioritizeZones(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.playerBuild else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        // Loop through the dominance zones
        for var dominanceZone in self.dominanceZones {

            // Find the zone and compute dominance here
            let dominance = self.calculateDominance(of: dominanceZone, in: gameModel)
            dominanceZone.dominanceFlag = dominance

            // Establish a base value for the region
            var baseValue = 1
            var multiplier = 1

            // Temporary zone?
            if dominanceZone.territoryType == .tempZone {

                multiplier = 200
            } else {

                if let closestCity = dominanceZone.closestCity {

                    baseValue += closestCity.population()

                    if closestCity.isCapital() {
                        baseValue *= 2
                    }

                    // How damaged is this city?
                    let damage = closestCity.damage()
                    if damage > 0 {
                        baseValue *= (damage + 2) / 2
                    }

                    if player.tacticalAI?.isTemporaryZone(a: closestCity) ?? false {

                        baseValue *= 3
                    }
                }

                if !dominanceZone.isWater {

                    baseValue *= 8
                }

                // Now compute a multiplier based on current conditions here
                switch dominance {

                case .noUnitsPresent, .notVisible:
                    // NOOP
                    break
                case .friendly:
                    if dominanceZone.territoryType == .enemy {
                        multiplier = 4
                    } else if dominanceZone.territoryType == .friendly {
                        multiplier = 1
                    }
                case .even:
                    if dominanceZone.territoryType == .enemy {
                        multiplier = 3
                    } else if dominanceZone.territoryType == .friendly {
                        multiplier = 3
                    }
                case .enemy:
                    if dominanceZone.territoryType == .enemy {
                        multiplier = 2
                    } else if dominanceZone.territoryType == .friendly {
                        multiplier = 4
                    }
                }

                if diplomacyAI.stateOfAllWars == .winning {
                    if dominanceZone.territoryType == .enemy {
                        multiplier *= 2
                    }
                } else if diplomacyAI.stateOfAllWars == .losing {
                    if dominanceZone.territoryType == .friendly {
                        multiplier *= 2
                    }
                }
            }

            if baseValue * multiplier <= 0 {
                fatalError("Invalid Dominance Zone Value")
            }

            dominanceZone.dominanceValue = baseValue * multiplier
        }

        self.dominanceZones.sort(by: { $0.dominanceValue < $1.dominanceValue })
    }

    private func calculateDominance(of dominanceZone: TacticalDominanceZone, in gameModel: GameModel?) -> TacticalDominanceType {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.playerBuild else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        guard let tacticalAI = player.tacticalAI else {
            fatalError("cant get tacticalAI")
        }

        var tempZone = false
        var tile: AbstractTile?
        var dominanceValue: TacticalDominanceType = .notVisible

        if let closestCity = dominanceZone.closestCity {

            tempZone = tacticalAI.isTemporaryZone(a: closestCity)
            tile = gameModel.tile(at: closestCity.location)
        }

        // Look at ratio of friendly to enemy strength
        if dominanceZone.friendlyStrength + dominanceZone.enemyStrength <= 0 {

            dominanceValue = .noUnitsPresent
        } else if dominanceZone.territoryType == .enemy && !(tile?.isVisible(to: player) ?? true) && !tempZone {
            // Enemy zone that we can't see (that isn't one of our temporary targets?
            dominanceValue = .notVisible
        } else {

            var enemyCanSeeOurCity = false
            if dominanceZone.territoryType == .friendly {

                for otherPlayer in gameModel.players {

                    if otherPlayer.isAlive() && player.leader != otherPlayer.leader {

                        if diplomacyAI.isAtWar(with: otherPlayer) {

                            if tile?.isVisible(to: player) ?? false {

                                enemyCanSeeOurCity = true
                                break
                            }
                        }
                    }
                }
            }

            if dominanceZone.territoryType == .friendly && !enemyCanSeeOurCity {

                dominanceValue = .notVisible
            } else if dominanceZone.enemyStrength <= 0 {
                // Otherwise compute it by strength
                dominanceValue = .friendly
            } else {

                let ratio = dominanceZone.friendlyStrength * 100 / dominanceZone.enemyStrength

                if ratio > 100 + self.dominancePercentage {

                    dominanceValue = .friendly

                } else if ratio < 100 - self.dominancePercentage {

                    dominanceValue = .enemy

                } else {

                    dominanceValue = .even
                }
            }
        }

        return dominanceValue
    }

    /// Update data for a cell: returns whether or not to add to dominance zones
    private func populateCell(at location: HexPoint, with tile: AbstractTile?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.playerBuild else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        if let cell = self.plots[location], let tile = tile {

            cell.reset()

            cell.revealed = tile.isDiscovered(by: self.playerBuild)
            cell.visible = tile.isVisible(to: self.playerBuild)
            cell.impassableTerrain = tile.isImpassable(for: .walk) || tile.isImpassable(for: .swim)
            cell.water = tile.terrain().isWater()
            cell.ocean = tile.terrain() == .ocean

            var impassableTerritory = false
            if tile.hasOwner() {

                if tile.owner()?.leader != player.leader && diplomacyAI.isAtWar(with: tile.owner()) && !diplomacyAI.isOpenBorderAgreementActive(by: tile.owner()) {
                    impassableTerritory = true

                } else if let city = gameModel.city(at: location) {

                    if city.player?.leader == player.leader {
                        cell.friendlyCity = true
                    } else if diplomacyAI.isAtWar(with: city.player) || player.isBarbarian() {
                        cell.enemyCity = true
                    } else {
                        cell.neutralCity = true
                    }
                }

                if tile.owner()?.leader != player.leader {
                    cell.ownTerritory = true
                }

                if tile.isFriendlyTerritory(for: player, in: gameModel) {
                    cell.friendlyTerritory = true
                }

                if diplomacyAI.isAtWar(with: tile.owner()) {
                    cell.enemyTerritory = true
                }
                
                if player.isBarbarian() {
                    cell.enemyTerritory = true
                }
                
            } else {
                cell.unclaimedTerritory = true
            }

            cell.impassableTerritory = impassableTerritory
            cell.defenseModifier = tile.defenseModifier(for: player)

            if let unit = gameModel.unit(at: location, of: .combat) {

                if unit.player?.leader == player.leader {

                    if unit.isCombatUnit() {
                        cell.friendlyMilitaryUnit = unit
                    } else {
                        cell.friendlyCivilianUnit = unit
                    }
                } else if diplomacyAI.isAtWar(with: unit.player) || player.isBarbarian() {
                    if unit.isCombatUnit() {
                        cell.enemyMilitaryUnit = unit
                    } else {
                        cell.enemyCivilianUnit = unit
                    }

                } else {
                    if unit.isCombatUnit() {
                        cell.neutralMilitaryUnit = unit
                    } else {
                        cell.neutralCivilianUnit = unit
                    }
                }
            }

            // Figure out whether or not to add this to a dominance zone
            if cell.impassableTerrain || cell.impassableTerritory || (!cell.revealed && !player.isBarbarian()) {
                return false
            }
        }
        
        return true
    }

    /// Add in any temporary dominance zones from tactical AI
    private func addTemporaryZones(in gameModel: GameModel?) {

        guard let tacticalAI = self.playerBuild?.tacticalAI else {
            fatalError("cant get tacticalAI")
        }

        tacticalAI.dropObsoleteZones(in: gameModel)

        for temporaryZone in tacticalAI.temporaryZones {

            // Can't be a city zone (which is just used to boost priority but not establish a new zone)
            if temporaryZone.targetType != .city {

                if let tile = gameModel?.tile(at: temporaryZone.location) {

                    let newZone = TacticalDominanceZone(
                        territoryType: .tempZone,
                        dominanceFlag: .noUnitsPresent,
                        owner: nil,
                        area: tile.area,
                        isWater: tile.terrain().isWater(),
                        center: tile,
                        navalInvasion: temporaryZone.navalMission,
                        friendlyStrength: 0,
                        friendlyRangedStrength: 0,
                        friendlyUnitCount: 0,
                        friendlyRangedUnitCount: 0,
                        enemyStrength: 0,
                        enemyRangedStrength: 0,
                        enemyUnitCount: 0,
                        enemyRangedUnitCount: 0,
                        enemyNavalUnitCount: 0,
                        rangeClosestEnemyUnit: 0,
                        dominanceValue: 0)

                    self.dominanceZones.append(newZone)
                }
            }
        }
    }

    // Find all our enemies (combat units)
    func buildEnemyUnitList(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.playerBuild else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        self.enemyUnits.removeAll()

        for otherPlayer in gameModel.players {

            // for each opposing civ
            if player.isAlive() && diplomacyAI.isAtWar(with: otherPlayer) {

                for unitRef in gameModel.units(of: otherPlayer) {

                    if unitRef?.canAttack() ?? false {
                        self.enemyUnits.append(unitRef)
                    }
                }
            }
        }
    }

    // Indicate the plots we might want to move to that the enemy can attack
    func markCellsNearEnemy(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.playerBuild else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        let pathFinder = AStarPathfinder()

        // Look at every cell on the map
        for x in 0..<self.plots.width {
            for y in 0..<self.plots.height {

                var marked = false

                let pt = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: pt), let plot = self.plots[x, y] {

                    if tile.isDiscovered(by: self.playerBuild) && !tile.isImpassable(for: .walk) {

                        if !tile.isVisibleToEnemy(of: player, in: gameModel) {

                            plot.notVisibleToEnemy = true

                        } else {

                            // loop all enemy units
                            for enemyUnitRef in self.enemyUnits {

                                if marked {
                                    break
                                }

                                if let enemyUnit = enemyUnitRef {

                                    pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: enemyUnit.movementType(), for: enemyUnit.player, unitMapType: .combat, canEmbark: enemyUnit.player!.canEmbark())

                                    let unitArea = gameModel.area(of: enemyUnit.location)
                                    if tile.area == unitArea {

                                        // Distance check before hitting pathfinder
                                        let distance = enemyUnit.location.distance(to: tile.point)

                                        if distance == 0 {

                                            plot.subjectToAttack = true
                                            plot.enemyCanMovePast = true
                                            marked = true
                                        }

                                        // TEMPORARY OPTIMIZATION: Assumes can't use roads or RR
                                            else if distance <= enemyUnit.baseMoves(into: .none, in: gameModel) {

                                                if let path = pathFinder.shortestPath(fromTileCoord: enemyUnit.location, toTileCoord: tile.point) {
                                                    let turnsToReach = path.count / enemyUnit.moves()

                                                    if turnsToReach <= 1 {
                                                        plot.subjectToAttack = true
                                                    }

                                                    if turnsToReach == 0 {
                                                        plot.enemyCanMovePast = true
                                                        marked = true
                                                    }
                                                }
                                        }
                                    }
                                }
                            }

                            // Check adjacent plots for enemy citadels
                            if !plot.subjectToAttack {

                                for dir in HexDirection.all {

                                    let adjacent = tile.point.neighbor(in: dir)
                                    if let adjacentTile = gameModel.tile(at: adjacent) {

                                        if adjacentTile.hasOwner() {

                                            if diplomacyAI.isAtWar(with: adjacentTile.owner()) {

                                                if adjacentTile.has(improvement: .citadelle) {
                                                    plot.subjectToAttack = true
                                                    break
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
