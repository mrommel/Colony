//
//  Operation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import Darwin

struct OperationSlot {

    let operation: Operation?
    let army: Army?
    let slot: UnitFormationSlot
    let slotIndex: Int
}

struct OperationSearchUnit {

    let unit: AbstractUnit?
    let distance: Int
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperation
//!  \brief        Operational maneuvers performed by the AI
//
//!  Key Attributes:
//!  - Based class: behavior is inherited from this class for each individual maneuver
//!  - AI operations are launched by some player strategies
//!  - Each operations manages one or more armies (multiple armies in an operation not yet tested)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
public class Operation: Codable, Equatable {

    enum CodingKeys: CodingKey {

        case identifier
        case type
        case state
        // player / enemy
        case area
        case moveType

        case army

        case listOfUnitsCitiesHaveCommittedToBuild
        case listOfUnitsWeStillNeedToBuild
        case shouldReplaceLossesWithReinforcements

        case startPosition
        case musterPosition
        case targetPosition
    }

    let identifier: String
    let type: UnitOperationType
    var state: OperationStateType = .none
    var player: AbstractPlayer? = nil
    var enemy: AbstractPlayer? = nil
    var area: HexArea? = nil
    var moveType: OperationMoveType = .none

    var army: Army? = nil

    var listOfUnitsCitiesHaveCommittedToBuild: [OperationSlot] = []
    var listOfUnitsWeStillNeedToBuild: [OperationSlot] = []
    var shouldReplaceLossesWithReinforcements: Bool = false

    var startPosition: HexPoint? = nil // Coordinates of start city
    var musterPosition: HexPoint? = nil // Coordinates of muster plot
    var targetPosition: HexPoint? = nil // Coordinates of target plot

    init(type: UnitOperationType) {

        self.identifier = UUID().uuidString
        self.type = type
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.type = try container.decode(UnitOperationType.self, forKey: .type)
        self.state = try container.decode(OperationStateType.self, forKey: .state)
        self.area = try container.decodeIfPresent(HexArea.self, forKey: .area)
        self.moveType = try container.decode(OperationMoveType.self, forKey: .moveType)

        self.army = nil // try container.decodeIfPresent(Army.self, forKey: .army)

        self.listOfUnitsCitiesHaveCommittedToBuild = [] // try container.decode([OperationSlot].self, forKey: .army)
        self.listOfUnitsWeStillNeedToBuild = [] // try container.decode([OperationSlot].self, forKey: .army)
        self.shouldReplaceLossesWithReinforcements = try container.decode(Bool.self, forKey: .shouldReplaceLossesWithReinforcements)

        self.startPosition = try container.decodeIfPresent(HexPoint.self, forKey: .startPosition)
        self.musterPosition = try container.decodeIfPresent(HexPoint.self, forKey: .musterPosition)
        self.targetPosition = try container.decodeIfPresent(HexPoint.self, forKey: .targetPosition)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.identifier, forKey: .identifier)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.state, forKey: .state)
        try container.encode(self.area, forKey: .area)
        try container.encode(self.moveType, forKey: .moveType)
        
        //self.army = nil // try container.decodeIfPresent(Army.self, forKey: .army)

        //self.listOfUnitsCitiesHaveCommittedToBuild = [] // try container.decode([OperationSlot].self, forKey: .army)
        //self.listOfUnitsWeStillNeedToBuild = [] // try container.decode([OperationSlot].self, forKey: .army)
        try container.encode(self.shouldReplaceLossesWithReinforcements, forKey: .shouldReplaceLossesWithReinforcements)

        try container.encodeIfPresent(self.startPosition, forKey: .startPosition)
        try container.encodeIfPresent(self.musterPosition, forKey: .musterPosition)
        try container.encodeIfPresent(self.targetPosition, forKey: .targetPosition)
    }

    func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {

        self.player = player
        self.enemy = enemy
        self.area = area
        self.shouldReplaceLossesWithReinforcements = false

        self.updateTarget(to: target)

        // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
        self.buildListOfUnitsWeStillNeedToBuild()
        let _ = self.grabUnitsFromTheReserves(at: nil, for: nil, in: gameModel)
    }
    
    /// Delete allocated objects
    private func uninit() {
        
        // hopefully if this has been init'ed this should not happen
        if let owner = self.player {

            // remove the army (which should, in turn, free up its units for other tasks)
            if let army = self.army {
                
                army.kill()
                owner.armies?.remove(army: army)
            }
        }

        // clear out the lists
        self.army = nil
        self.listOfUnitsWeStillNeedToBuild.removeAll()
        self.listOfUnitsCitiesHaveCommittedToBuild.removeAll()

        // Reset();
    }

    func isAllNavalOperation() -> Bool {

        return false
    }

    func isMixedLandNavalOperation() -> Bool {

        return false
    }

    func updateTarget(to point: HexPoint) {

        self.targetPosition = point
    }

    func updateTarget(to tile: AbstractTile?) {

        if let tile = tile {
            self.targetPosition = tile.point
        }
    }

    func updateTarget(to city: AbstractCity?) {

        if let city = city {
            self.targetPosition = city.location
        }
    }

    @discardableResult
    func armyInPosition(in gameModel: GameModel?) -> Bool {

        fatalError("not implemented yet")
    }

    func buildListOfUnitsWeStillNeedToBuild() {

        self.listOfUnitsCitiesHaveCommittedToBuild.removeAll()
        self.listOfUnitsWeStillNeedToBuild.removeAll()

        if let army = self.army {

            // if it is still waiting on initial units
            if army.state == .waitingForUnitsToReinforce {

                var index = 0
                for slot in army.formation.slots() {

                    let operationSlot = OperationSlot(operation: self, army: army, slot: slot, slotIndex: index)
                    self.listOfUnitsWeStillNeedToBuild.append(operationSlot)
                    index += 1
                }
            }
        }
    }

    /// Assigns available units to our operation. Returns true if all needed units assigned.
    func grabUnitsFromTheReserves(at musterPosition: HexPoint?, for targetPosition: HexPoint?, in gameModel: GameModel?) -> Bool {

        var returnVal = true

        // Copy over the list
        var secondList: [OperationSlot] = []
        for item in self.listOfUnitsWeStillNeedToBuild {
            secondList.append(item)
        }

        // Clear main list
        self.listOfUnitsWeStillNeedToBuild.removeAll()

        //
        for item in secondList {

            let (success, required) = self.findBestFitReserveUnit(for: item, in: gameModel)

            // If any fail, check to see if they were required
            if !success {

                if required {

                    // Return false to say that operation is not ready to roll yet
                    returnVal = false

                    // And add them back to the list of units needed
                    self.listOfUnitsWeStillNeedToBuild.append(item)

                } else {

                    // this slot will not be filled (but is not required)
                    self.army?.disable(slot: item.slot)
                }
            }
        }

        return returnVal
    }

    func closestUnit(in searchList: [OperationSearchUnit], needToCheckTarget: Bool, in gameModel: GameModel?) -> AbstractUnit? {

        var bestUnit: AbstractUnit? = nil
        var bestDistance: Double = UnitMovementType.max

        let sortetSearchList = searchList.sorted(by: { $0.distance < $1.distance })

        let pathFinder = AStarPathfinder()

        for searchUnit in sortetSearchList {

            guard let unit = searchUnit.unit else {
                fatalError("cant get iterator")
            }

            pathFinder.dataSource = gameModel?.ignoreUnitsPathfinderDataSource(for: unit.movementType(), for: searchUnit.unit?.player)

            if let searchUnitLocation = searchUnit.unit?.location {
                var pathDistance = Double.greatestFiniteMagnitude

                // Now loop through the units, using the pathfinder to do the final evaluation
                if let musterLocation = self.musterPosition {

                    if let path = pathFinder.shortestPath(fromTileCoord: searchUnitLocation, toTileCoord: musterLocation) {
                        pathDistance = Double(path.count)
                    } else {
                        continue
                    }
                }

                if needToCheckTarget {
                    if let targetLocation = self.targetPosition {

                        if let path = pathFinder.shortestPath(fromTileCoord: searchUnitLocation, toTileCoord: targetLocation) {
                            pathDistance = Double(path.count)
                        } else {
                            continue
                        }
                    }
                }

                // Reasonably close?
                if pathDistance <= Double(searchUnit.distance) && pathDistance <= bestDistance {
                    bestUnit = searchUnit.unit
                }

                if pathDistance < bestDistance {
                    bestUnit = searchUnit.unit
                    bestDistance = pathDistance
                }

                // Were we far away?  If so, this is probably the best we are going to do
                if searchUnit.distance >= 8 /* AI_HOMELAND_ESTIMATE_TURNS_DISTANCE */ {
                    break
                }
            }
        }

        return bestUnit
    }

    func findBestFitReserveUnit(for slot: OperationSlot, in gameModel: GameModel?) -> (Bool, Bool) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        /*guard let formation = self.army?.formation else {
            fatalError("cant get formation")
        }*/

        var searchList: [OperationSearchUnit] = []

        for unitRef in gameModel.units(of: player) {

            if let unit = unitRef {

                // Make sure he's not needed by the tactical AI or already in an army or scouting
                if unit.army() == nil && unit.has(task: .explore) && unit.has(task: .exploreSea) {

                    // Is this unit one of the requested types?
                    if unit.has(task: slot.slot.primaryUnitTask) || unit.has(task: slot.slot.secondaryUnitTask) {

                        // Is his health okay?
                        if !unit.isCombatUnit() || unit.healthPoints() >= 75 /* AI_OPERATIONAL_PERCENT_HEALTH_FOR_OPERATION */ {

                            // FIXME if ((!IsAllNavalOperation() && !IsMixedLandNavalOperation()) || pLoopUnit->getDomainType() == DOMAIN_SEA || pLoopUnit->CanEverEmbark())

                            var distance = 0

                            if let musterLocation = self.musterPosition {

                                distance = musterLocation.distance(to: unit.location)
                                if unit.domain() == .land && gameModel.area(of: unit.location) != gameModel.area(of: musterLocation) {
                                    distance *= 2
                                }
                            } else if let targetLocation = self.targetPosition {

                                distance = targetLocation.distance(to: unit.location)
                            } else {

                                distance = Int.max
                            }

                            searchList.append(OperationSearchUnit(unit: unit, distance: distance))
                        }
                    }
                }
            }
        }

        let bestUnit = closestUnit(in: searchList, needToCheckTarget: true, in: gameModel)

        // Did we find one?
        if let bestUnit = bestUnit {

            self.army?.add(unit: bestUnit, to: slot.slotIndex)
            return (true, true)

        }

        // If not required, let our calling routine know that
        return (true, slot.slot.required)
    }

    func selectInitialMusterPoint(for army: Army, in gameModel: GameModel?) -> AbstractTile? {
        return nil
    }

    /// See if armies are ready to hand off units to the tactical AI (and do so if ready)
    func checkOnTarget(in gameModel: GameModel?) -> Bool {

        if self.army == nil {
            return false
        }

        switch self.moveType {

        case .none:
            // NOOP
            break
        case .singleHex:

            if let army = self.army {
                if army.numOfSlotsFilled() >= 1 {

                    let civilian = army.unit(at: 0)

                    switch self.state {

                    case .none:
                        // NOOP
                        break

                    case .aborted(_):
                        // NOOP
                        break

                    case .gatheringForces:
                        if army.numOfSlotsFilled() == 1 {

                            self.armyInPosition(in: gameModel)
                            return true
                        } else {

                            let escort = army.unit(at: 1)
                            if escort?.location == civilian?.location {

                                self.armyInPosition(in: gameModel)
                                return true
                            }
                        }

                    case .movingToTarget:
                        self.armyInPosition(in: gameModel)
                        return true

                    case .recruitingUnits, .atTarget, .successful:
                        // NOOP
                        break
                    }

                } else {
                    fatalError("Found an escort operation with no units in it.")
                }
            }

        case .enemyTerritory:
            // Let each army perform its own check
            let gatheredTolerance = self.gatherTolerance(of: army, position: self.musterPosition, in: gameModel)

            if let army = self.army {
                if army.numOfSlotsFilled() >= 1 {

                    switch self.state {

                    case .none:
                        // NOOP
                        break

                    case .aborted(_):
                        // NOOP
                        break

                    case .gatheringForces:
                        if let centerOfMass = army.centerOfMass(in: gameModel), let musterPosition = self.musterPosition {

                            if centerOfMass.distance(to: musterPosition) <= gatheredTolerance && army.furthestUnitDistance(towards: musterPosition) <= gatheredTolerance * 3 / 2 {

                                self.armyInPosition(in: gameModel)
                                return true
                            }
                        }

                    case .movingToTarget:

                        if let centerOfMass = army.centerOfMass(in: gameModel), let targetPosition = self.targetPosition {

                            if centerOfMass.distance(to: targetPosition) <= gatheredTolerance && army.furthestUnitDistance(towards: targetPosition) <= gatheredTolerance * 3 / 2 {

                                self.armyInPosition(in: gameModel)
                                return true
                            }
                        }

                    case .recruitingUnits, .atTarget, .successful:
                        // NOOP
                        break
                    }

                } else {
                    fatalError("Found an army operation with no units in it.")
                }
            }

        case .navalEscort:
            // Let each army perform its own check
            let gatheredTolerance = self.gatherTolerance(of: army, position: self.musterPosition, in: gameModel)

            if let army = self.army {
                if army.numOfSlotsFilled() >= 1 {

                    switch self.state {

                    case .none:
                        // NOOP
                        break

                    case .aborted(_):
                        // NOOP
                        break

                    case .gatheringForces:
                        if let centerOfMass = army.centerOfMass(in: gameModel), let musterPosition = self.musterPosition {

                            if centerOfMass.distance(to: musterPosition) <= gatheredTolerance && army.furthestUnitDistance(towards: musterPosition) <= gatheredTolerance * 3 {

                                self.armyInPosition(in: gameModel)
                                return true
                            }
                        }

                    case .movingToTarget:

                        if let centerOfMass = army.centerOfMass(in: gameModel), let targetPosition = self.targetPosition {

                            if centerOfMass.distance(to: targetPosition) <= gatheredTolerance && army.furthestUnitDistance(towards: targetPosition) <= gatheredTolerance * 3 {

                                self.armyInPosition(in: gameModel)
                                return true
                            }
                        }

                    case .recruitingUnits, .atTarget, .successful:
                        // NOOP
                        break
                    }
                } else {
                    fatalError("Found an army operation with no units in it.")
                }
            }

        case .freeformNaval:
            // Let each army perform its own check
            let gatheredTolerance = self.gatherTolerance(of: army, position: self.musterPosition, in: gameModel)

            if let army = self.army {
                if army.numOfSlotsFilled() >= 1 {

                    switch self.state {

                    case .none:
                        // NOOP
                        break

                    case .aborted(_):
                        // NOOP
                        break

                    case .gatheringForces:
                        if let centerOfMass = army.centerOfMass(in: gameModel), let musterPosition = self.musterPosition {

                            if centerOfMass.distance(to: musterPosition) <= gatheredTolerance && army.furthestUnitDistance(towards: musterPosition) <= gatheredTolerance * 3 / 2 {

                                self.armyInPosition(in: gameModel)
                                return true
                            }
                        }

                    case .movingToTarget:
                        // Never in a final position
                        break

                    case .recruitingUnits, .atTarget, .successful:
                        // NOOP
                        break

                    }
                }
            }

        case .rebase:
            // NOOP
            break
        }

        return false
    }

    func gatherTolerance(of army: Army?, position: HexPoint?, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let army = army else {
            fatalError("cant get army")
        }

        guard let position = position else {
            fatalError("cat get position")
        }

        var validPlotsNearby: Int = 0
        let tacticalMap = gameModel.tacticalAnalysisMap()

        // Find out how many units are trying to gather
        let numUnits = army.numOfSlotsFilled()

        // If not more than 1, zero tolerance is fine (we should get the unit to the gather point)
        if numUnits < 1 {
            return 0
        }

        let range = numUnits <= 2 ? 1 : (numUnits <= 6 ? 2 : 3)
        for pt in position.areaWith(radius: range) {

            if let cell = tacticalMap.plots[pt] {

                if (self.isMixedLandNavalOperation() && cell.canUseForOperationGathering()) || cell.canUseForOperationGatheringCheckWater(isWater: self.isAllNavalOperation()) {

                    if (self.isMixedLandNavalOperation() || self.isAllNavalOperation()) && !army.isAllOceanGoing(in: gameModel) && cell.ocean {

                        continue
                    }

                    validPlotsNearby += 1
                }
            }
        }

        // Find more valid plots than units?
        if validPlotsNearby > numUnits {

            // If so, just use normal range for this many units
            return range

        } else {

            // Something constrained here, give ourselves a lot of leeway
            return 3
        }
    }
    
    /// Perform the deletion of this operation
    func kill(with reason: OperationAbortReasonType) {

        if state == .aborted(reason: .none) {
            self.state = .aborted(reason: reason)
        }
        
        // LogOperationEnd();
        self.uninit()
        self.player?.delete(operation: self)
    }

    func numUnitsNeededToBeBuilt() -> Int {

        return self.listOfUnitsWeStillNeedToBuild.count
    }

    /// Delete the operation if marked to go away
    func doDelayedDeath() -> Bool {
        
        if self.shouldAbort() {
            
            if self.state == .successful {
                self.kill(with: .success)
            } else {
                self.kill(with: .killed)
            }
            return true
        }

        return false
    }
    
    /// Returns true when we should abort the operation totally (besides when we have lost all units in it)
    func shouldAbort() -> Bool {
        
        // Mark units in successful operation
        if self.state == .successful {
            
            /*for (unsigned int uiI = 0; uiI < m_viArmyIDs.size(); uiI++)
            {
                CvArmyAI* pArmy = GET_PLAYER(m_eOwner).getArmyAI(m_viArmyIDs[uiI]);

                pUnit = pArmy->GetFirstUnit();
                while (pUnit)
                {
                    pUnit->SetDeployFromOperationTurn(GC.getGame().getGameTurn());
                    pUnit = pArmy->GetNextUnit();
                }
            }*/
        }

        return self.state == .aborted(reason: .none) || self.state == .successful
    }
    
    /// Report percentage distance traveled from muster point to target (using army that is furthest along)
    func percentFromMusterPointToTarget(in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var rtnValue = 0

        switch self.state {
            
        case .gatheringForces, .aborted(reason: _), .recruitingUnits, .none:
            
            return 0

        case .atTarget, .successful:
            return 100

        case .movingToTarget:
            
                // Let each army perform its own update
            if let army = self.army {

                let armyMoveType: UnitMovementType = self.moveType == .navalEscort || self.moveType == .freeformNaval ? .swim : .walk
                
                let pathFinder = AStarPathfinder()
                pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: armyMoveType, for: self.player)
                
                guard let musterPosition = self.musterPosition else {
                    fatalError("muster position not available")
                }
                
                guard let targetPosition = self.targetPosition else {
                    fatalError("target position not available")
                }
                
                // Use the step path finder to compute distance
                let distanceMusterToTarget = (pathFinder.shortestPath(fromTileCoord: musterPosition, toTileCoord: targetPosition) ?? HexPath()).count
                let distanceCurrentToTarget = (pathFinder.shortestPath(fromTileCoord: army.centerOfMass(in: gameModel) ?? musterPosition, toTileCoord: targetPosition) ?? HexPath()).count

                if distanceMusterToTarget <= 0 {
                    return 0
                } else {
                    let tempValue = 100 - (100 * distanceCurrentToTarget / distanceMusterToTarget)
                    if tempValue > rtnValue {
                        rtnValue = tempValue
                    }
                }
            }
        }

        return rtnValue
    }

    public static func == (lhs: Operation, rhs: Operation) -> Bool {

        return lhs.type == rhs.type && lhs.area == rhs.area && lhs.enemy?.leader == rhs.enemy?.leader && lhs.moveType == rhs.moveType && lhs.targetPosition == rhs.targetPosition
    }
}


