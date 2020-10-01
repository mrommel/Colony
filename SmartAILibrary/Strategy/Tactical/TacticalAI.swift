//
//  TacticalAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvTacticalAI
//!  \brief        A player's AI to control units as they fight out battles
//
//!  Key Attributes:
//!  - Handed units to control by the operational AI
//!  - Handles moves for these units until dead or objective completed
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
public class TacticalAI: Codable {

    enum CodingKeys: String, CodingKey {
        
        case temporaryZones
        case allTargets
        
        case movePriotityTurn
    }
    
    var player: Player?

    var temporaryZones: [TemporaryZone]
    var allTargets: [TacticalTarget]
    var queuedAttacks: [QueuedAttack]
    var movePriorityList: [TacticalMove]
    var postures: [TacticalPosture]
    var zoneTargets: [TacticalTarget]
    var tempTargets: [TacticalTarget]
    
    var currentTurnUnits: [AbstractUnit?]
    var currentMoveCities: [TacticalCity?]
    var currentMoveUnits: [TacticalUnit?]
    var currentMoveHighPriorityUnits: [TacticalUnit?]
    var currentDominanceZone: TacticalAnalysisMap.TacticalDominanceZone? = nil
    
    // Blocking (and flanking) position data
    var potentialBlocks: [BlockingUnit?]
    var temporaryBlocks: [BlockingUnit?]
    var chosenBlocks: [BlockingUnit?]
    var newlyChosen: [BlockingUnit?]
    
    // Operational AI support data
    var operationUnits: [OperationUnit]
    var generalsToMove: [OperationUnit]
    var paratroopersToMove: [OperationUnit]
    
    var movePriotityTurn: Int = 0
    var currentSeriesId: Int = -1
    
    static let recruitRange = 10 // AI_TACTICAL_RECRUIT_RANGE
    static let repositionRange = 10 // AI_TACTICAL_REPOSITION_RANGE
    static let deployRadius = 4 // AI_OPERATIONAL_CITY_ATTACK_DEPLOY_RANGE


    // MARK: constructors

    init(player: Player?) {

        self.player = player

        self.temporaryZones = []
        self.allTargets = []
        
        self.queuedAttacks = []
        self.movePriorityList = []
        self.postures = []
        self.zoneTargets = []
        self.tempTargets = []
        
        self.currentTurnUnits = []
        self.currentMoveCities = []
        self.currentMoveUnits = []
        self.currentMoveHighPriorityUnits = []
        
        self.potentialBlocks = []
        self.temporaryBlocks = []
        self.chosenBlocks = []
        self.newlyChosen = []
        
        self.operationUnits = []
        self.generalsToMove = []
        self.paratroopersToMove = []
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.temporaryZones = try container.decode([TemporaryZone].self, forKey: .temporaryZones)
        self.allTargets = try container.decode([TacticalTarget].self, forKey: .allTargets)
        
        self.queuedAttacks = []
        self.movePriorityList = []
        self.postures = []
        self.zoneTargets = []
        self.tempTargets = []
        
        self.currentTurnUnits = []
        self.currentMoveCities = []
        self.currentMoveUnits = []
        self.currentMoveHighPriorityUnits = []
        
        self.potentialBlocks = []
        self.temporaryBlocks = []
        self.chosenBlocks = []
        self.newlyChosen = []

        self.operationUnits = []
        self.generalsToMove = []
        self.paratroopersToMove = []
        
        self.movePriotityTurn = try container.decode(Int.self, forKey: .movePriotityTurn)
    }
    
    public func encode(to encoder: Encoder) throws {
      
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.temporaryZones, forKey: .temporaryZones)
        try container.encode(self.allTargets, forKey: .allTargets)
        
        try container.encode(self.movePriotityTurn, forKey: .movePriotityTurn)
    }
    
    /// Update the AI for units
    func turn(in gameModel: GameModel?) {

        self.findTacticalTargets(in: gameModel)

        // Loop through each dominance zone assigning moves
        self.processDominanceZones(in: gameModel)
    }
    
    func commandeerUnits(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let dangerPlotsAI = player.dangerPlotsAI else {
            fatalError("cant get dangerPlotsAI")
        }
        
        self.currentTurnUnits.removeAll()
        
        for unitRef in gameModel.units(of: player) {
            
            if let unit = unitRef {
                
                // Never want immobile/dead units, explorers, ones that have already moved
                if unit.task() == .explore || !unit.canMove() {
                    continue
                } else if player.leader == .barbar {
                    
                    // We want ALL the barbarians that are not guarding a camp
                    unit.set(tacticalMove: .unassigned)
                    self.currentTurnUnits.append(unit)
                } else if unit.domain() == .air {
                    // and air units
                    unit.set(tacticalMove: .unassigned)
                    self.currentTurnUnits.append(unit)
                } else if !unit.isCombatUnit() /*&& !unit.isGreatGeneral()*/ {
                    // Now down to land and sea units ... in these groups our unit must have a base combat strength ... or be a great general
                    continue
                } else {
                    // Is this one in an operation we can't interrupt?
                    if let army = unit.army() {
                        if army.canTacticalAIInterrupt() {
                            unit.set(tacticalMove: .none)
                        }
                    } else {
                        // Non-zero danger value, near enemy, or deploying out of an operation?
                        let danger = dangerPlotsAI.danger(at: unit.location)
                        if danger > 0 || self.isNearVisibleEnemy(unit: unit, range: 10 /*  */, gameModel: gameModel) /* ||
                        pLoopUnit->GetDeployFromOperationTurn() + GC.getAI_TACTICAL_MAP_TEMP_ZONE_TURNS() >= GC.getGame().getGameTurn() */ {
                            unit.set(tacticalMove: .unassigned)
                            self.currentTurnUnits.append(unit)
                        } /* else if (pLoopUnit->canParadrop(pLoopUnit->plot(),false))
                        {
                            pLoopUnit->setTacticalMove((TacticalAIMoveTypes)m_CachedInfoTypes[eTACTICAL_UNASSIGNED]);
                            m_CurrentTurnUnits.push_back(pLoopUnit->GetID());
                        } */
                    }
                }
            }
        }
    }
    
    /// Am I within range of an enemy?
    private func isNearVisibleEnemy(unit unitToTest: AbstractUnit?, range: Int, gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
         
        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        guard let unitToTest = unitToTest else {
            fatalError("cant get unitToTest")
        }
        
        // Loop through enemies
        for otherPlayer in gameModel.players {
            
            if otherPlayer.isAlive() && otherPlayer.leader != player.leader && diplomacyAI.isAtWar(with: otherPlayer) {
                
                // Loop through their units
                for unitRef in gameModel.units(of: otherPlayer) {
                    
                    if let unit = unitRef {
                        
                        // Make sure this tile is visible to us
                        if let tile = gameModel.tile(at: unit.location) {
                            
                            if tile.isVisible(to: player) && unitToTest.location.distance(to: unit.location) < range {
                                return true
                            }
                        }
                    }
                }
                
                // Loop through their cities
                for cityRef in gameModel.cities(of: otherPlayer) {
                    
                    if let city = cityRef {
                        
                        // Make sure this tile is visible to us
                        if let tile = gameModel.tile(at: city.location) {
                            
                            if tile.isVisible(to: player) && unitToTest.location.distance(to: city.location) < range {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }

    /// Process units that we recruited out of operational moves.  Haven't used them, so let them go ahead with those moves
    func updateOperationalArmyMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let operations = self.player?.operations else {
            fatalError("cant get operations")
        }

        // Update all operations (moved down - previously was in the PlayerAI object)
        for operation in operations {
            
            if operation.lastTurnMoved() < gameModel.currentTurn {
                
                switch operation.moveType {
                
                case .none:
                    // NOOP
                break
                case .singleHex:
                    self.plotSingleHexOperationMoves(for: operation as? EscortedOperation, in: gameModel)
                case .enemyTerritory:
                    self.plotEnemyTerritoryOperationMoves(for: operation as? EnemyTerritoryOperation, in: gameModel)
                case .navalEscort:
                    self.plotNavalEscortOperationMoves(for: operation as? NavalEscortedOperation, in: gameModel)
                case .freeformNaval:
                    self.plotFreeformNavalOperationMoves(for: operation as? NavalOperation, in: gameModel)
                case .rebase:
                    // NOOP
                break
                }
                
                operation.set(lastTurnMoved: gameModel.currentTurn)
                operation.checkOnTarget(in: gameModel)
            }
        }

        for operation in operations {
            
            operation.doDelayedDeath(in: gameModel)
        }
    }
    
    /// Move a naval force that is roaming for targets
    func plotFreeformNavalOperationMoves(for operation: NavalOperation?, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let operation = operation else {
            fatalError("cant get operation")
        }
        
        // Simplification - assume only 1 army per operation now
        guard let thisArmy = operation.army else {
            return
        }

        self.operationUnits.removeAll()
        thisArmy.updateCheckpointTurns(in: gameModel)

        // RECRUITING
        if thisArmy.state == .waitingForUnitsToReinforce {
            
            // If no estimate for when recruiting will end, let the rest of the AI use these units
            if thisArmy.turnAtNextCheckpoint() == ArmyFormationSlot.unknownTurnAtCheckpoint {
                return
            } else {
                
                for iI in 0..<thisArmy.numFormationEntries() {
                    
                    // See if we are just able to get to muster point in time.  If so, time for us to head over there
                    if let slot = thisArmy.slot(at: iI), let unit = slot.unit {
                    
                        if !unit.processedInTurn() {
                            
                            let thisSlotEntry = thisArmy.formation.slots()[iI]
                                    
                            // Continue moving to target
                            if slot.hasStartedOnOperation() {
                                self.moveWithFormation(unit: unit, at: thisSlotEntry.position)
                            } else {
                                // See if we are just able to get to muster point in time.  If so, time for us to head over there
                                let turns = unit.turnsToReach(at: operation.musterPosition!, in: gameModel)
                                if turns + gameModel.currentTurn >= thisArmy.turnAtNextCheckpoint() {
                                    slot.startedOnOperation = true
                                    self.moveWithFormation(unit: unit, at: thisSlotEntry.position)
                                }
                            }
                            
                        }
                    }
                }
                
                self.executeNavalFormationMoves(of: thisArmy, towards: operation.musterPosition!, in: gameModel)
            }
        } else if thisArmy.state == .waitingForUnitsToCatchUp {
            
            // GATHERING FORCES
            
            // Get them moving to target without delay
            operation.armyInPosition(in: gameModel)
            self.executeFleetMoveToTarget(thisArmy: thisArmy, target: operation.targetPosition!, in: gameModel)
            
        } else if thisArmy.state == .movingToDestination  {
            
            // MOVING TO TARGET
            
            // Get them moving to target without delay
            operation.armyInPosition(in: gameModel)
            self.executeFleetMoveToTarget(thisArmy: thisArmy, target: operation.targetPosition!, in: gameModel)
        }
    }
    
    /// Move a squadron of naval units to a target
    func executeFleetMoveToTarget(thisArmy: Army?, target: HexPoint, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let thisArmy = thisArmy else {
            fatalError("cant get thisArmy")
        }
        
        // Request moves for all units
        for iI in 0..<thisArmy.numFormationEntries() {
            
            // See if we are just able to get to muster point in time.  If so, time for us to head over there
            if let slot = thisArmy.slot(at: iI), let unit = slot.unit {

                if !unit.processedInTurn() {
                    slot.startedOnOperation = true
                    
                    let thisSlotEntry = thisArmy.formation.slots()[iI]
                    self.moveWithFormation(unit: unit, at: thisSlotEntry.position)
                }
            }
        }
        
        self.executeNavalFormationMoves(of: thisArmy, towards: target, in: gameModel)
    }
    
    // MARK: OPERATIONAL AI SUPPORT FUNCTIONS

    /// Move a single stack (civilian plus escort) to its destination
    func plotSingleHexOperationMoves(for operation: EscortedOperation?, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let operation = operation else {
            return
        }

        // Simplification - assume only 1 army per operation now
        guard let army = operation.army else {
            return
        }
        
        guard let civilian = army.unit(at: 0) else {
            return
        }

        // ESCORT AND CIVILIAN MEETING UP
        if army.state == .waitingForUnitsToReinforce || army.state == .waitingForUnitsToCatchUp {
            
            guard let escort = army.unit(at: 1) else {
                // Escort died or was poached for other tactical action, operation will clean itself up when call CheckOnTarget()
                return
            }
            
            if escort.processedInTurn() {
                return
            }

            // Check to make sure escort can get to civilian
            if escort.path(towards: civilian.location, options: .none, in: gameModel) != nil {
                
                // He can, so have civilian remain in place
                self.executeMoveToPlot(of: civilian, to: civilian.location, in: gameModel)

                if army.numSlotsFilled() > 1 {
                    
                    // Move escort over
                    self.executeMoveToPlot(of: escort, to: civilian.location, in: gameModel)
                    
                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        
                        print("Moving escorting \(escort.type) to civilian for operation, Civilian at \(civilian.location), \(escort.location)")
                        // LogTacticalMessage(strLogString);
                    }
                }
            } else {
                // Find a new place to meet up, look at all hexes adjacent to civilian
                for neighbor in civilian.location.neighbors() {
                    
                    guard let neighborTile = gameModel.tile(at: neighbor) else {
                        continue
                    }
                    
                    if escort.canEnterTerrain(of: neighborTile) && escort.canEnterTerritory(of: self.player, ignoreRightOfPassage: false, isDeclareWarMove: false) {
                        
                        if gameModel.unit(at: neighbor) == nil {
                            
                            if escort.path(towards: neighbor, options: .none, in: gameModel) != nil && civilian.path(towards: neighbor, options: .none, in: gameModel) != nil {
                                
                                self.executeMoveToPlot(of: escort, to: neighbor, in: gameModel)
                                self.executeMoveToPlot(of: civilian, to: neighbor, in: gameModel)
                                
                                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                    
                                    print("Moving escorting \(escort.type) to open hex, Open \(neighbor), \(escort.location)")
                                    // LogTacticalMessage(strLogString);
                                    
                                    print("Moving \(civilian.type) to open hex, Open \(neighbor), \(civilian.location)")
                                    // LogTacticalMessage(strLogString);
                                }
                                
                                return
                            }
                        }
                    }
                }
 
                // Didn't find an alternative, must abort operation
                operation.retarget(civilian: civilian, within: army, in: gameModel)
                civilian.finishMoves()
                escort.finishMoves()
                
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                    
                    print("Retargeting civilian escort operation. No empty tile adjacent to civilian to meet.")
                    // LogTacticalMessage(strLogString);
                }
            }
        } else {
            // MOVING TO TARGET
            // If we're not there yet, we have work to do (otherwise CheckOnTarget() will finish operation for us)
            if civilian.location != operation.targetPosition {
                
                // Look at where we'd move this turn taking units into consideration
                // int iFlags = 0;
                //if army.numOfSlotsFilled() > 1 {
                    // iFlags = MOVE_UNITS_IGNORE_DANGER;
                //}

                // Handle case of no path found at all for civilian
                if let path = civilian.path(towards: operation.targetPosition!, options: .none, in: gameModel) {
                    
                    let civilianMove = path.last!.0
                    let saveMoves = civilianMove == operation.targetPosition
                    
                    if army.numSlotsFilled() == 1 {
                        
                        self.executeMoveToPlot(of: civilian, to: civilianMove, saveMoves: saveMoves, in: gameModel)
                        
                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                            
                            print("Moving \(civilian.type) without escort to target, \(civilian.location)")
                            // LogTacticalMessage(strLogString);
                        }
                    } else {
                        guard let escort = army.unit(at: 1) else {
                            return
                        }

                        // See if escort can move to the same location in one turn
                        if escort.turnsToReach(at: civilianMove, in: gameModel) <= 1 {
                            
                            self.executeMoveToPlot(of: civilian, to: civilianMove, saveMoves: saveMoves, in: gameModel)
                            self.executeMoveToPlot(of: escort, to: civilianMove, in: gameModel);
                            
                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                
                                print("Moving \(civilian.type) to target, \(civilian.location)")
                                // LogTacticalMessage(strLogString);
                                
                                print("Moving escorting \(escort.type) to target, \(escort.location)")
                                // LogTacticalMessage(strLogString);
                            }
                        } else {
                            let tacticalMap = gameModel.tacticalAnalysisMap()
                            let cell = tacticalMap.plots[civilianMove]!
                            
                            let blockingUnit = gameModel.unit(at: civilianMove)

                            // See if friendly blocking unit is ending the turn there, or if no blocking unit (which indicates this is somewhere civilian
                            // can move that escort can't -- like minor civ territory), then find a new path based on moving the escort
                            if cell.friendlyTurnEndTile || blockingUnit == nil {
                                
                                if let path = escort.path(towards: operation.targetPosition!, options: .none, in: gameModel) {
                                    
                                    let escortMove = path.last!.0
                                    let saveMoves = escortMove == operation.targetPosition

                                    // See if civilian can move to the same location in one turn
                                    if civilian.turnsToReach(at: escortMove, in: gameModel) <= 1 {
                                        
                                        self.executeMoveToPlot(of: escort, to: escortMove, in: gameModel)
                                        self.executeMoveToPlot(of: civilian, to: escortMove, saveMoves: saveMoves, in: gameModel)
                                        
                                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                            
                                            print("Moving escorting \(escort.type) to target, \(escort.location)")
                                            //LogTacticalMessage(strLogString);
                                            
                                            print("Moving \(civilian.type) to target, \(civilian.location)")
                                            //LogTacticalMessage(strLogString);
                                        }
                                    } else {
                                        // Didn't find an alternative, retarget operation
                                        operation.retarget(civilian: civilian, within: army, in: gameModel)
                                        civilian.finishMoves()
                                        escort.finishMoves()
                                        
                                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                            
                                            print("Retargeting civilian escort operation. Too many blocking units.");
                                            // LogTacticalMessage(strLogString);
                                        }
                                    }
                                } else {
                                    operation.retarget(civilian: civilian, within: army, in: gameModel)
                                    civilian.finishMoves()
                                    escort.finishMoves()
                                    
                                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                        
                                        print("Retargeting civilian escort operation (path lost to target), \(operation.targetPosition!)")
                                        // LogTacticalMessage(strLogString);
                                    }
                                }
                            } else {
                                // Looks like we should be able to move the blocking unit out of the way
                                if self.executeMoveOfBlockingUnit(of: blockingUnit, in: gameModel) {
                                    
                                    self.executeMoveToPlot(of: escort, to: civilianMove, in: gameModel)
                                    self.executeMoveToPlot(of: civilian, to: civilianMove, saveMoves: saveMoves, in: gameModel)
                                    
                                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                        
                                        print("Moving escorting \(escort.type) to target, \(escort.location)")
                                        // LogTacticalMessage(strLogString);
                                        
                                        print("Moving \(civilian.type) to target, \(civilian.location)")
                                        // LogTacticalMessage(strLogString);
                                    }
                                } else {

                                    // Didn't find an alternative, try retargeting operation
                                    operation.retarget(civilian: civilian, within: army, in: gameModel)
                                    civilian.finishMoves()
                                    escort.finishMoves()
                                    
                                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                        print("Retargeting civilian escort operation. Could not move blocking unit.");
                                        // LogTacticalMessage(strLogString);
                                    }
                                }
                            }
                        }
                    }
                } else {
                    operation.retarget(civilian: civilian, within: army, in: gameModel)
                    civilian.finishMoves()
                    
                    if let escort = army.unit(at: 1) {
                        escort.finishMoves()
                    }
                    
                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        print("Retargeting civilian escort operation (path lost to target), \(operation.targetPosition!)")
                        // LogTacticalMessage(strLogString);
                    }
                }
            }
        }
    }
    
    /// Move a large army to its destination against an enemy target
    func plotEnemyTerritoryOperationMoves(for operation: EnemyTerritoryOperation?, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // Simplification - assume only 1 army per operation now
        guard let thisArmy = operation?.army else {
            return
        }

        self.operationUnits.removeAll()
        self.generalsToMove.removeAll()
        self.paratroopersToMove.removeAll()
        thisArmy.updateCheckpointTurns(in: gameModel)

        // RECRUITING
        if thisArmy.state == .waitingForUnitsToReinforce {
            
            // If no estimate for when recruiting will end, let the rest of the AI use these units
            if thisArmy.turnAtNextCheckpoint() == ArmyFormationSlot.unknownTurnAtCheckpoint {
                return
            } else {
                
                for (index, slot) in thisArmy.formation.slots().enumerated() {
                    
                    // See if we are just able to get to muster point in time.  If so, time for us to head over there
                    if let unit = thisArmy.unit(at: index), let slotEntry = thisArmy.slot(at: index) {
                        
                        if !unit.processedInTurn() {
                            
                            // Great general?
                            if unit.isGreatGeneral() || unit.isGreatAdmiral() {
                                
                                if unit.moves() > 0 {

                                    self.generalsToMove.append(OperationUnit(unit: unit, at: .civilianSupport))
                                }
                            } else {

                                let formationSlotEntry = thisArmy.formation.slots()[index]
                                
                                // Continue moving to target
                                if slotEntry.hasStartedOnOperation() {
                                    self.moveWithFormation(unit: unit, at: formationSlotEntry.position)
                                } else {
                                    // See if we are just able to get to muster point in time.  If so, time for us to head over there
                                    let turns = unit.turnsToReach(at: operation!.musterPosition!, in: gameModel)
                                    if turns + gameModel.currentTurn >= thisArmy.turnAtNextCheckpoint() {
                                        slotEntry.set(startedOnOperation: true)
                                        self.moveWithFormation(unit: unit, at: formationSlotEntry.position)
                                    }
                                }
                            }
                        }
                    }
                }
                
                self.executeGatherMoves(of: thisArmy, in: gameModel)
            }
        } else if thisArmy.state == .waitingForUnitsToCatchUp { // GATHERING FORCES
            
            self.clearEnemiesNearArmy(army: thisArmy, in: gameModel)

            // Request moves for all units
            for (index, slot) in thisArmy.formation.slots().enumerated() {
                
                if let unit = thisArmy.unit(at: index), let slotEntry = thisArmy.slot(at: index) {
                    
                    if !unit.processedInTurn() {
                        // Great general or admiral?
                        if unit.isGreatGeneral() || unit.isGreatAdmiral() {
                
                            if unit.moves() > 0 {

                                self.generalsToMove.append(OperationUnit(unit: unit, at: .civilianSupport))
                            }
                        } else {
                            slotEntry.set(startedOnOperation: true)
                            
                            let formationSlotEntry = thisArmy.formation.slots()[index]
                            self.moveWithFormation(unit: unit, at: formationSlotEntry.position)
                        }
                    }
                }
            }
                
            self.executeGatherMoves(of: thisArmy, in: gameModel)
            
        } else if thisArmy.state == .movingToDestination { // MOVING TO TARGET
             
            // Update army's current location
            var closestCurrentCenterOfMassOnPath: HexPoint = HexPoint.invalid
            guard let thisTurnTarget = operation?.computeCenterOfMassForTurn(closestCurrentCenterOfMassOnPath: &closestCurrentCenterOfMassOnPath, in: gameModel) else {
                operation?.state = .aborted(reason: .lostPath)
                return
            }

            thisArmy.position = thisTurnTarget
            self.clearEnemiesNearArmy(army: thisArmy, in: gameModel)

            // Request moves for all units
            for (index, _) in thisArmy.formation.slots().enumerated() {
                
                if let unit = thisArmy.unit(at: index) {
                    
                    if !unit.processedInTurn() {
                        
                        // Great general or admiral?
                        if unit.isGreatGeneral() || unit.isGreatAdmiral() {
                
                            if unit.moves() > 0 {

                                self.generalsToMove.append(OperationUnit(unit: unit, at: .civilianSupport))
                            }
                        } else {

                            let formationSlotEntry = thisArmy.formation.slots()[index]
                            self.moveWithFormation(unit: unit, at: formationSlotEntry.position)
                        }
                    }
                }
            }
            
            self.executeFormationMoves(for: thisArmy, closestCurrentCenterOfMassOnPath: closestCurrentCenterOfMassOnPath, in: gameModel)
        }

        if self.paratroopersToMove.count > 0 {
            //MoveParatroopers(pThisArmy);
        }

        if self.generalsToMove.count > 0 {
            self.moveGreatGeneral(army: thisArmy, in: gameModel)
        }
    }
    
    /// Move a large army to its destination against an enemy target
    func plotNavalEscortOperationMoves(for operation: NavalEscortedOperation?, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel, let operation = operation else {
            fatalError("cant get gameModel")
        }

        // Simplification - assume only 1 army per operation now
        guard let thisArmy = operation.army else {
            return
        }
        
        let civilian: AbstractUnit? = thisArmy.unit(at: 0)
        var escort: AbstractUnit? = nil

        if civilian != nil {

            escort = thisArmy.unit(at: 1)
            
            if escort != nil && escort?.domain() != .land {
                escort = nil   // Second unit wasn't the escort
            }
        }

        if civilian == nil && operation.isCivilianRequired() {
            return
        }

        self.operationUnits.removeAll()
        thisArmy.updateCheckpointTurns(in: gameModel)

        // RECRUITING
        if thisArmy.state == .waitingForUnitsToReinforce {
            
            // If no estimate for when recruiting will end, let the rest of the AI use these units
            if thisArmy.turnAtNextCheckpoint() == ArmyFormationSlot.unknownTurnAtCheckpoint {
                return
            } else {
                
                for iI in 0..<thisArmy.numFormationEntries() {
                    
                    if let slot = thisArmy.slot(at: iI), let unit = slot.unit {
                        // See if we are just able to get to muster point in time.  If so, time for us to head over there
                        if !unit.processedInTurn() {
                            
                            let thisSlotEntry = thisArmy.formation.slots()[iI]
                                
                            // Continue moving to target
                            if slot.hasStartedOnOperation() {
                                self.moveWithFormation(unit: unit, at: thisSlotEntry.position)
                            } else {
                                // See if we are just able to get to muster point in time.  If so, time for us to head over there
                                let turns = unit.turnsToReach(at: operation.musterPosition!, in: gameModel)
                                    
                                if turns + gameModel.currentTurn >= thisArmy.turnAtNextCheckpoint() {
                                    slot.startedOnOperation = true
                                    self.moveWithFormation(unit: unit, at: thisSlotEntry.position)
                                }
                            }
                        }
                    }
                }
                
                self.executeNavalFormationMoves(of: thisArmy, towards: operation.musterPosition!, in: gameModel)
            }
        } else if thisArmy.state == .waitingForUnitsToCatchUp {
            // GATHERING FORCES
            self.executeFleetMoveToTarget(thisArmy: thisArmy, target: operation.musterPosition!, in: gameModel)
            
        } else if thisArmy.state == .movingToDestination && operation.isCivilianRequired() {
            // MOVING TO TARGET with a civilian
            
            // Update army's current location
            if let thisTurnTarget = thisArmy.centerOfMass(domain: .sea, in: gameModel) {
                thisArmy.position = thisTurnTarget
            }

            // Settler at the target?
            let civilianTile: AbstractTile? = civilian != nil ? gameModel.tile(at: civilian!.location) : nil
            
            if civilian != nil && !civilianTile!.isWater() && civilian!.location == thisArmy.goal {
                if civilian!.canFound(at: civilian!.location, in: gameModel) {
                    civilian?.push(mission: UnitMission(type: .found), in: gameModel)
                    
                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        
                        print("City founded, At \(civilian!.location)")
                        //pOperation->LogOperationSpecialMessage(strMsg);
                    }
                    operation.state = .aborted(reason: .success)
                }
            } else if civilian!.turnsToReach(at: operation.targetPosition!, in: gameModel) <= 1 &&
                        (escort == nil || escort!.turnsToReach(at: operation.targetPosition!, in: gameModel) <= 1) {
                
                // Is our settler and his escort both one move from the destination?  If so, targeted moves to finish up
                self.executeMoveToPlot(of: civilian, to: operation.targetPosition!, saveMoves: true, in: gameModel)
                
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {

                    print("Moving \(civilian!.name()) to target, \(civilian!.location)")
                    // LogTacticalMessage(strLogString);
                }

                if escort != nil {
                    self.executeMoveToPlot(of: escort!, to: operation.targetPosition!, saveMoves: false, in: gameModel)
                    
                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        
                        print("Moving \(escort!.name()) to target, \(escort!.location)")
                        // LogTacticalMessage(strLogString);
                    }
                }

                // Move naval escorts in close
                for iI in 2..<thisArmy.numFormationEntries() {

                    if let slot = thisArmy.slot(at: iI), let unit = slot.unit {

                        if !unit.processedInTurn() {
                            
                            self.moveToEmptySpaceNearTarget(unit: unit, target: operation.targetPosition!, land: false, in: gameModel)
                            
                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
 
                                print("Moving \(unit.name()) near target, Now at \(civilian!.location)")
                                // LogTacticalMessage(strLogString);
                            }
                        }
                    }
                }
            } else {
                // Still further away, move as formation

                // Request moves for all units
                for iI in 0..<thisArmy.numFormationEntries() {
                    
                    if let slot = thisArmy.slot(at: iI), let unit = slot.unit {
                        
                        if !unit.processedInTurn() {
                            let formationSlotEntry = thisArmy.formation.slots()[iI]
                            self.moveWithFormation(unit: unit, at: formationSlotEntry.position)
                        }
                    }
                }

                // Plot one turn of movement for the first unit in the army we find out in the water
                if let unitAtSea = thisArmy.units().first(where: { $0?.domain() == .sea})! {
                    
                    var moveOptions: MoveOptions = .none
                    if thisArmy.numUnits(at: .navalEscort) > 0 {
                        moveOptions.insert(.ignoreDanger)
                    }
                    
                    var bestDistance: Int = Int.max
                    var bestPlot: HexPoint? = nil

                    // Goal should be a water tile one hex shy of our target
                    for adjacentPoint in thisArmy.goal.neighbors() {
                        
                        guard let adjacentPlot = gameModel.tile(at: adjacentPoint) else {
                            continue
                        }
                        
                        if adjacentPlot.isWater() {
                            
                            if unitAtSea.location == adjacentPoint {
                                bestPlot = adjacentPoint
                                break
                            } else {
                                // Using step finder could get tripped up by ocean hexes (since they are in the area but not valid movement targets for coastal vessels.  Watch this!
                                let pathFinder = AStarPathfinder()
                                pathFinder.dataSource = gameModel.unitAwarePathfinderDataSource(for: .swim, for: self.player)
                                
                                let path = pathFinder.shortestPath(fromTileCoord: unitAtSea.location, toTileCoord: adjacentPoint)
                                let distance: Int = path == nil ? 0 : Int(path!.cost)
                                
                                if distance > 0 && distance < bestDistance {
                                    
                                    bestDistance = distance
                                    let distanceToMove = min(4, distance)

                                    bestPlot = path?.path(without: (distance - distanceToMove))?.last?.0
                                }
                            }
                        }
                    }

                    if let bestPlot = bestPlot {
                        self.executeNavalFormationMoves(of: thisArmy, towards: bestPlot, in: gameModel)
                    } else {
                        
                        operation.retarget(civilian: civilian, army: thisArmy, in: gameModel)
                        
                        for iI in 0..<thisArmy.numFormationEntries() {
                            
                            if let slot = thisArmy.slot(at: iI), let unit = slot.unit {
                                unit.finishMoves()
                            }
                        }
                        
                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                            
                            print("Retargeting naval escort operation (path lost to target), \(operation.targetPosition!)")
                            // LogTacticalMessage(strLogString);
                        }
                    }
                } else {
                    operation.retarget(civilian: civilian, army: thisArmy, in: gameModel)
                    
                    for iI in 0..<thisArmy.numFormationEntries() {
                        
                        if let slot = thisArmy.slot(at: iI), let unit = slot.unit {
                            
                            unit.finishMoves()
                        }
                    }
                    
                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        
                        print("Retargeting naval escort operation (no unit in water!), \(operation.targetPosition!)")
                        // LogTacticalMessage(strLogString);
                    }
                }
            }
        } else if thisArmy.state == .movingToDestination && !operation.isCivilianRequired() {
            
            // MOVING TO TARGET as an army
            var bestDistance: Int = Int.max
            var slowestMovementRate: Int = Int.max
            var closestUnitAtSea: AbstractUnit? = nil
            var bestPlotTmp: HexPoint? = nil

            // Error handling: couldn't find path to plot next to target
            if let bestPlot = self.player?.militaryAI?.coastalPlotAdjacent(to: thisArmy.goal, army: thisArmy, in: gameModel) {
                
                // Request moves for all units, getting the slowest movement rate and the closest unit
                for iI in 0..<thisArmy.numFormationEntries() {
                    
                    if let slot = thisArmy.slot(at: iI), let unit = slot.unit {

                        if !unit.processedInTurn() {
                            
                            let slotEntry = thisArmy.formation.slots()[iI]
                            self.moveWithFormation(unit: unit, at: slotEntry.position)

                            let moves = unit.moves() // / 1 GC.getMOVE_DENOMINATOR();
                            if moves < slowestMovementRate {
                                slowestMovementRate = moves
                            }

                            // At sea?
                            let pathFinder = AStarPathfinder()
                            pathFinder.dataSource = gameModel.unitAwarePathfinderDataSource(for: .swim, for: self.player)
                            
                            let path = pathFinder.shortestPath(fromTileCoord: unit.location, toTileCoord: bestPlot)
                            let distance: Int = path == nil ? 0 : Int(path!.cost)
                            
                            if distance > 0 && distance < bestDistance {
                                bestDistance = distance
                                closestUnitAtSea = unit
                                bestPlotTmp = path?.path(without: (bestDistance - slowestMovementRate))?.last?.0
                            }
                        }
                    }
                }

                // Error handling: no one at sea, retarget
                if let closestUnitAtSea = closestUnitAtSea {
                    
                    // If not close yet, find best plot for this turn's movement along path to ultimate best plot
                    if let plot = bestDistance > slowestMovementRate ? bestPlotTmp : bestPlot {
                        thisArmy.position = bestPlot
                        
                        self.executeNavalFormationMoves(of: thisArmy, towards: plot, in: gameModel)
                    } else {
                        fatalError("Naval operation logic error.");
                    }
                } else {
                    operation.retarget(civilian: civilian, army: thisArmy, in: gameModel)
                    
                    for iI in 0..<thisArmy.numFormationEntries() {
                        
                        if let slot = thisArmy.slot(at: iI), let unit = slot.unit {
                            unit.finishMoves()
                        }
                    }
                    
                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        
                        print("Retargeting naval escort operation (no unit in water!), \(operation.targetPosition!)")
                        // LogTacticalMessage(strLogString);
                    }
                }
            } else {
                operation.retarget(civilian: civilian, army: thisArmy, in: gameModel)

                for iI in 0..<thisArmy.numFormationEntries() {
                    
                    if let slot = thisArmy.slot(at: iI), let unit = slot.unit {
                        
                        unit.finishMoves()
                    }
                }
                
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                    
                    print("Retargeting naval escort operation (path lost to target), \(operation.targetPosition!)")
                    // LogTacticalMessage(strLogString);
                }
            }
        }
    }
    
    /// Complete moves for all units requested through calls to MoveWithFormation()
    func executeNavalFormationMoves(of army: Army?, towards turnTarget: HexPoint, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let army = army else {
            fatalError("cant get army")
        }

        if self.operationUnits.count == 0 {
            return
        }

        var moreEscorted = true
        var navalUnits = 0
        var escortedUnits = 0

        for operationUnit in operationUnits {
            
            if let opUnit = operationUnit.unit {
                
                if opUnit.domain() == .land {
                    escortedUnits += 1
                } else {
                    if opUnit.isGreatAdmiral() {
                        escortedUnits += 1
                    } else {
                        navalUnits += 1
                    }
                }
            }
        }

        let mostUnits = max(navalUnits, escortedUnits)
        let leastUnits = min(navalUnits, escortedUnits)
        
        if navalUnits > escortedUnits {
            moreEscorted = false
        }

        // Range around turn target based on number of units we need to place
        let range = OperationHelpers.gatherRangeFor(numOfUnits: mostUnits)

        // See if we have enough places to put everyone
        if !self.scoreDeploymentPlots(point: turnTarget, army: army, numMeleeUnits: mostUnits, numRangedUnits: 0, range: range, in: gameModel) &&
            !self.scoreDeploymentPlots(point: turnTarget, army: army, numMeleeUnits: mostUnits, numRangedUnits: 0, range: 3, in: gameModel) {
            
            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
               
                print("Operation aborting. Army ID: \(army.identifier). Not enough spaces to deploy near turn target")
                // LogTacticalMessage(strLogString);
            }
            
            army.operation?.state = .aborted(reason: .noRoomDeploy)
        } else {
            // Compute moves for whomever has more units first
            self.tempTargets.sort()
            self.potentialBlocks.removeAll()
            var done = false
            var mostUnitsToPlace = mostUnits

            for tempTarget in self.tempTargets {
                
                if done {
                    continue
                }
                
                //pLoopPlot = GC.getMap().plot(m_TempTargets[iI].GetTargetX(), m_TempTargets[iI].GetTargetY());
                if self.findClosestNavalOperationUnit(target: tempTarget.target, escortedUnits: moreEscorted, in: gameModel) {
                    
                    for currentMoveUnit in self.currentMoveUnits {
 
                        self.potentialBlocks.append(BlockingUnit(unit: currentMoveUnit?.unit, at: tempTarget.target, numChoices: self.currentMoveUnits.count, distanceToTarget: currentMoveUnit!.movesToTarget))
                    }
                    
                    mostUnitsToPlace -= 1
                    if mostUnitsToPlace == 0 {
                        done = true
                    }
                }
            }

            // Now ready to make the assignments
            self.assignDeployingUnits(numUnitsRequiredToDeploy: mostUnits - mostUnitsToPlace, in: gameModel)
            self.performChosenMoves(fallbackMoveRange: 2, in: gameModel)

            // Log if someone in army didn't get a move assigned (how do we address this in the future?)
            if self.chosenBlocks.count < mostUnits {
                
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                    
                    print("No naval deployment move for \(mostUnits - self.chosenBlocks.count) units in first pass")
                    // LogTacticalMessage(strMsg);
                }
            }
            
            if leastUnits > 0 {
                // Now repeat for the other type of units, using the same target plots
                self.tempTargets.removeAll()

                for chosenBlock in self.chosenBlocks {

                    self.tempTargets.append(TacticalTarget(targetType: .none, target: chosenBlock!.point))
                }

                self.potentialBlocks.removeAll()
                done = false
                var leastUnitsToPlace = leastUnits

                for tempTarget in self.tempTargets {
                    
                    if done {
                        continue
                    }
                    
                    if self.findClosestNavalOperationUnit(target: tempTarget.target, escortedUnits: !moreEscorted, in: gameModel) {
                        
                        for currentMoveUnit in self.currentMoveUnits {
                            
                            self.potentialBlocks.append(BlockingUnit(unit: currentMoveUnit?.unit, at: tempTarget.target, numChoices: self.currentMoveUnits.count, distanceToTarget: currentMoveUnit!.movesToTarget))
                        }
                        
                        leastUnitsToPlace -= 1
                        
                        if leastUnitsToPlace == 0 {
                            done = true
                        }
                    }
                }

                // Now ready to make the assignments
                self.assignDeployingUnits(numUnitsRequiredToDeploy: leastUnits - leastUnitsToPlace, in: gameModel)
                self.performChosenMoves(fallbackMoveRange: 2, in: gameModel)

                if self.chosenBlocks.count < leastUnits {
                    
                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        
                        print("No naval deployment move for \(leastUnits - self.chosenBlocks.count) units in second pass")
                        // LogTacticalMessage(strMsg);
                    }
                }
            }
        }
    }
    
    /// Fills m_CurrentMoveUnits with all units in naval operation that can get to target (returns TRUE if 1 or more found)
    func findClosestNavalOperationUnit(target: HexPoint, escortedUnits: Bool, in gameModel: GameModel?) -> Bool {
        
        //FStaticVector<CvOperationUnit, SAFE_ESTIMATE_NUM_MULTIUNITFORMATION_ENTRIES, true, c_eCiv5GameplayDLL, 0>::iterator it;
        //UnitHandle pLoopUnit;

        var rtnValue = false;
        self.currentMoveUnits.removeAll()

        // Loop through all units available to operation
        for operationUnit in self.operationUnits {
            
            if let loopUnit = operationUnit.unit {
                
                var validUnit = true

                if escortedUnits && (!loopUnit.isGreatAdmiral() && loopUnit.domain() != .land) {
                    validUnit = false
                }

                if !escortedUnits && (loopUnit.domain() != .sea || loopUnit.isGreatAdmiral()) {
                    validUnit = false
                }

                if validUnit {
                    
                    let turns = loopUnit.turnsToReach(at: target, in: gameModel)

                    if turns != Int.max {
                        
                        let tacticalUnit = TacticalUnit(unit: loopUnit, attackStrength: 1000 - turns, healthPercent: 100)
                        tacticalUnit.movesToTarget = loopUnit.location.distance(to: target)
                        self.currentMoveUnits.append(tacticalUnit)
                        rtnValue = true;
                    }
                }
            }
        }

        // Now sort them by turns to reach
        self.currentMoveUnits.sort(by: { $0!.movesToTarget < $1!.movesToTarget })

        return rtnValue
    }
    
    /// Move a great general with an operation
    func moveGreatGeneral(army: Army?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        for generalsToMove in self.generalsToMove {
            
            var bestPlot: AbstractTile? = nil
            var bestScore = -1

            if let general = generalsToMove.unit {
                
                let range = (general.maxMoves(in: gameModel) * 3) /* / MOVE_DENOMINATOR */  // Enough to make a decent road move
                
                for evalPoint in general.location.areaWith(radius: range) {
                    
                    guard let evalPlot = gameModel.tile(at: evalPoint) else {
                        continue
                    }
                    
                    if general.canReach(at: evalPoint, in: 1, in: gameModel) {
                        
                        let score = self.scoreGreatGeneralPlot(for: general, at: evalPlot, with: army, in: gameModel)

                        if score > bestScore && score > 0 {
                            bestScore = score;
                            bestPlot = evalPlot
                        }
                    }
                }

                if let bestPlot = bestPlot {
                    
                    self.executeMoveToPlot(of: general, to: bestPlot.point, in: gameModel)

                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        
                        var distToOperationCenter = -1

                        if let army = army {
                            
                            if let centerOfMass = army.centerOfMass(domain: .none, in: gameModel) {
                                distToOperationCenter = centerOfMass.distance(to: bestPlot.point)
                            }
                        }

                        print("Deploying \(general.name()), To \(bestPlot.point), At \(general.location), Plot Score: \(bestScore), Dist from COM: \(distToOperationCenter)")
                        // LogTacticalMessage(strMsg);
                    }
                }
            }
        }

        return
    }
    
    // Support function to pick best hex for a great general to move to
    func scoreGreatGeneralPlot(for general: AbstractUnit?, at target: AbstractTile?, with army: Army?, in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let target = target, let general = general, let player = self.player else {
            fatalError("cant get target")
        }
        
        // Returned value
        var score = 0

        // Variables going into score
        var friendlyCity = false;
        var nearbyQueuedAttacks = 0
        var dangerDivisor = 1
        var distToOperationCenter = Int.max
        var friendlyUnitBasePower = 0
        var friendlyUnitFinalPower = 0
        var friendlyCityStrength = 0

        // GATHER DATA

        // Non-friendly city here?
        if gameModel.city(at: target.point) != nil && !player.isEqual(to: target.owner()) {
            return 0
        }

        // Another player's unit here?
        if let unit = gameModel.unit(at: target.point) {
            if !player.isEqual(to: unit.player) {
                return 0
            } else if !general.isEqual(to: unit) && !unit.canAttack() && unit.hasMoved(in: gameModel) {
                // Another civilian of mine that has finished its moves?
                return 0
            }
        }

        // Danger value
        let dangerValue = player.dangerPlotsAI!.danger(at: target.point)
        var bestDefender = gameModel.unit(at: target.point)

        // Friendly city here?
        if let city = gameModel.city(at: target.point) {
            
            friendlyCity = true

            friendlyCityStrength = city.strengthValue() * 100
            friendlyCityStrength *= (20 /*MAX_CITY_HIT_POINTS*/ - city.damage())
            friendlyCityStrength /= 20 /*MAX_CITY_HIT_POINTS*/

            if Int(dangerValue) > (friendlyCityStrength * 2) {
                dangerDivisor = 5
            } else if Int(dangerValue) > friendlyCityStrength {
                dangerDivisor = 3
            } else if Int(dangerValue) > (friendlyCityStrength / 2) {
                dangerDivisor = 2
            }
        } else if bestDefender != nil && !general.isEqual(to: bestDefender) { // Friendly unit here?
            
            friendlyUnitBasePower = bestDefender!.baseCombatStrength(ignoreEmbarked: true) * 250

            if Int(dangerValue) > (friendlyUnitBasePower * 2) {
                dangerDivisor = 5
            } else if Int(dangerValue) > friendlyUnitBasePower {
                dangerDivisor = 3
            } else if Int(dangerValue) > (friendlyUnitBasePower / 2) {
                dangerDivisor = 2
            }

            friendlyUnitFinalPower = friendlyUnitBasePower

            // Deemphasize if hasn't finished moves yet
            if self.isInQueuedAttack(unit: bestDefender) && !bestDefender!.isRanged() {
                // Melee unit: might take losses attacking, so reduce the desirability
                friendlyUnitFinalPower /= 3
            } else if bestDefender!.moves() > 0 {
                // Could move anywhere, not a good place to go
                friendlyUnitFinalPower /= 25
            }

            // Emphasize member of this operation
            if army != nil && bestDefender?.army() != nil && bestDefender!.army()?.identifier == army!.identifier {
                friendlyUnitFinalPower *= 5
            }
        } else {
            // No friendly city or unit
            dangerDivisor = 1000
        }

        // Distance to center of army (if still under operational AI)
        if army != nil {
            
            if let centerOfMass = army!.centerOfMass(domain: .none, in: gameModel) {
                distToOperationCenter = target.point.distance(to: centerOfMass)
            }
        }

        // Near an attack we already have planned?
        nearbyQueuedAttacks = self.nearXQueuedAttacks(plot: target.point, range: 2)

        // COMPUTE SCORE
        //  Entering a city
        if friendlyCity {
            score = friendlyCityStrength

            // If part of an army moving to target, don't hide in a city
            if army != nil {
                score = 1000
            }
        } else if friendlyUnitFinalPower > 0 { // Stacking with a unit
            score = friendlyUnitFinalPower
        } else { // Moving to an empty tile
            score = 10
        }

        if nearbyQueuedAttacks > 0 {
            score *= (5 * nearbyQueuedAttacks)
        }

        if distToOperationCenter < 20 && (friendlyUnitFinalPower > 0 || friendlyCity || dangerValue == 0) {
            // Anywhere near center is really good
            if distToOperationCenter <= 3 {
                score += 5000000
            } else {  // Sliding scale further off
                score += (250000 * (20 - distToOperationCenter))
            }
        }

        if dangerValue > 0 {
            score /= dangerDivisor
        }

        return score
    }
    
    /// Is this unit waiting to get its turn to attack?
    func nearXQueuedAttacks(plot: HexPoint, range: Int) -> Int {
        
        var nearbyAttacks = 0

        if self.queuedAttacks.count > 0 {
            
            for queuedAttack in self.queuedAttacks {
                
                let distance = plot.distance(to: queuedAttack.target!.target)
                if distance <= range {
                    nearbyAttacks += 1
                }
            }
        }
        return nearbyAttacks
    }
    
    /// Complete moves for all units requested through calls to MoveWithFormation()
    func executeFormationMoves(for army: Army, closestCurrentCenterOfMassOnPath: HexPoint, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
 
        if self.operationUnits.count == 0 {
            return
        }

        let target = army.position

        var meleeUnits: Int = 0
        var rangedUnits: Int = 0
        
        for operationUnit in self.operationUnits {
            
            guard let unit = operationUnit.unit else {
                continue
            }
            
            if unit.canAttackRanged() {
                rangedUnits += 1
            } else {
                meleeUnits += 1
            }
        }

        // See if we have enough places to put everyone
        if !self.scoreFormationPlots(army: army, forwardTarget: target, currentCenterOfMass: closestCurrentCenterOfMassOnPath, numUnits: meleeUnits + rangedUnits, in: gameModel) {
            
            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                
                print("Operation aborting. Army ID: \(army.identifier). Not enough spaces to deploy along formation's path")
                // LogTacticalMessage(strLogString);
            }
            
            army.operation?.state = .aborted(reason: .noRoomDeploy)
            
        } else {
            // Compute the moves to get the best deployment
            self.tempTargets.sort()

            // First loop for melee units who should be out front
            var meleeUnitsToPlace = meleeUnits
            var done = false
            
            for tempTarget in self.tempTargets {
                
                if done {
                    continue
                }
                
                let targetType = tempTarget.targetType

                guard let loopPlot = gameModel.tile(at: tempTarget.target) else {
                    fatalError("can get loopPlot")
                }

                // Don't use if there's already someone here
                if gameModel.unit(at: tempTarget.target) == nil {
                    
                    if self.findClosestOperationUnit(target: loopPlot, safeForRanged: false, mustBeRangedUnit: false, in: gameModel) {
                        
                        if let innerUnit = self.currentMoveUnits.first??.unit {
                            
                            var moveWasSafe = false
                            self.moveToUsingSafeEmbark(unit: innerUnit, target: loopPlot.point, moveWasSafe: &moveWasSafe, in: gameModel)
                            innerUnit.finishMoves()
                            
                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                
                                print("Deploying melee unit, \(innerUnit.name()), To \(tempTarget.target), At \(innerUnit.location)")
                                // LogTacticalMessage(strMsg);
                            }
                            
                            meleeUnitsToPlace -= 1
                        }
                    }
                }
                
                if meleeUnitsToPlace == 0 {
                    done = true
                }
            }

            // Log if someone in army didn't get a move assigned
            if meleeUnitsToPlace > 0 {
                
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                    
                    print("No army deployment move for \(meleeUnitsToPlace) melee units")
                    // LogTacticalMessage(strMsg);
                }
            }

            // Second loop for ranged units
            var rangedUnitsToPlace = rangedUnits
            done = false
            
            for tempTarget in self.tempTargets {
                
                let targetType = tempTarget.targetType

                guard let loopPlot = gameModel.tile(at: tempTarget.target) else {
                    continue
                }
                
                if targetType == .highPriorityUnit {
                    // Don't use if there's already someone here
                    if gameModel.unit(at: tempTarget.target) == nil {
                        
                        if self.findClosestOperationUnit(target: loopPlot, safeForRanged: true, mustBeRangedUnit: true, in: gameModel) {
                            
                            if let innerUnit = self.currentMoveUnits.first??.unit {
                                var moveWasSafe = false
                                self.moveToUsingSafeEmbark(unit: innerUnit, target: loopPlot.point, moveWasSafe: &moveWasSafe, in: gameModel)
                                innerUnit.finishMoves()
                                
                                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                    
                                    print("Deploying ranged unit, \(innerUnit.name()), To \(loopPlot.point), At \(innerUnit.location)")
                                    // LogTacticalMessage(strMsg);
                                }
                                
                                rangedUnitsToPlace -= 1
                            }
                        }
                    }
                }
                
                if rangedUnitsToPlace == 0 {
                    done = true
                }
            }

            // Third loop for ranged units we couldn't put in an ideal spot
            for tempTarget in self.tempTargets {
                
                let targetType = tempTarget.targetType

                guard let loopPlot = gameModel.tile(at: tempTarget.target) else {
                    continue
                }
                
                if targetType == .highPriorityUnit {
                    // Don't use if there's already someone here
                    if gameModel.unit(at: tempTarget.target) == nil {
                        
                        if self.findClosestOperationUnit(target: loopPlot, safeForRanged: true, mustBeRangedUnit: true, in: gameModel) {
                            
                            if let innerUnit = self.currentMoveUnits.first??.unit {
                                
                                var moveWasSafe = false
                                self.moveToUsingSafeEmbark(unit: innerUnit, target: loopPlot.point, moveWasSafe: &moveWasSafe, in: gameModel)
                                innerUnit.finishMoves()
                                
                                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                    
                                    print("Deploying ranged unit (Pass 2), \(innerUnit.name()), To \(loopPlot.point), At \(innerUnit.location)")
                                    // LogTacticalMessage(strMsg);
                                }
                                
                                rangedUnitsToPlace -= 1
                            }
                        }
                    }
                        
                    if rangedUnitsToPlace == 0 {
                        done = true
                    }
                }
            }

            // Log if someone in army didn't get a move assigned
            if rangedUnitsToPlace > 0 {
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                    print("No army deployment move for %d ranged units", rangedUnitsToPlace);
                    // LogTacticalMessage(strMsg);
                }
            }
        }
    }
    
    /// Pick best hexes for deploying our army (mostly based on keeping a tight formation that is moving toward the target). Returns false if insufficient free plots.
    func scoreFormationPlots(army: Army, forwardTarget: HexPoint, currentCenterOfMass: HexPoint, numUnits: Int, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel, let player = self.player else {
            fatalError("cant get gameModel")
        }
        
        var numDeployPlotsFound = 0

        // We'll store the hexes we've found here
        self.tempTargets.removeAll()

        let range = 3
        
        for plotPoint in forwardTarget.areaWith(radius: range) {
            
            if let plot = gameModel.tile(at: plotPoint) {
                
                var forcedToUseWater = false

                let plotDistance = forwardTarget.distance(to: plotPoint)
                
                if plotDistance <= range {

                    guard let cell = gameModel.tacticalAnalysisMap().plots[plotPoint],
                          let operation = army.operation else {
                        continue
                    }

                    var valid = false
                    
                    if operation.isMixedLandNavalOperation() && cell.canUseForOperationGatheringCheckWater(isWater: true) {
                        valid = true
                    } else if operation.isAllNavalOperation() && cell.canUseForOperationGatheringCheckWater(isWater: true) {
                        valid = true
                    } else if (!operation.isAllNavalOperation() && !operation.isMixedLandNavalOperation()) && (cell.canUseForOperationGatheringCheckWater(isWater: false) || false /* GC.getMap().GetAIMapHint() & 1*/) {
                        
                        valid = true
                        if cell.isWater() {
                            forcedToUseWater = true
                        }
                    }

                    if operation.isMixedLandNavalOperation() || operation.isAllNavalOperation() {
                        if !army.isAllOceanGoing(in: gameModel) && cell.isOcean() {
                            valid = false
                        }
                    }

                    if valid {
                        // Skip this plot if friendly unit that isn't in this army
                        // CvUnit* pFriendlyUnit;
                        
                        if let friendlyUnit = cell.friendlyMilitaryUnit
                        {
                            if friendlyUnit.army()?.identifier != army.identifier {
                                continue
                            }
                        }

                        numDeployPlotsFound += 1

                        // Score plots close to COM and turn target highest
                        var plotDistanceFromCOM = 0
                        if forwardTarget == currentCenterOfMass {
                         
                            plotDistanceFromCOM = plotDistance
                        } else {
                            plotDistanceFromCOM = currentCenterOfMass.distance(to: plotPoint)
                        }

                        var score = 800 - (plotDistance * 100) - (plotDistanceFromCOM * 100)

                        if plot.isCity() && player.isEqual(to: plot.owner()) {
                            score += 100
                        } else {
                            score += cell.defenseModifier * 2
                        }
                        
                        if forcedToUseWater {
                            score = 10
                        }

                        // Safe if closer to rear, or if forward target and COM are the same
                        let safeForDeployment = plotDistanceFromCOM < plotDistance || forwardTarget == currentCenterOfMass
                        cell.safeDeployment = safeForDeployment

                        // Reduce score if safe for ranged (so these don't get picked first)
                        if safeForDeployment {
                            score -= 200
                        }

                        cell.deploymentScore = score

                        // Save this in our list of potential targets
                        let target = TacticalTarget(targetType: .none, target: plotPoint)
                        target.threatValue = score // FIXME: damage ??
                        // A bit of a hack -- use high priority targets to indicate safe plots for ranged units
                        if safeForDeployment {
                            target.targetType = .highPriorityUnit
                        } else {
                            target.targetType = .lowPriorityUnit
                        }
                        
                        self.tempTargets.append(target)
                    }
                }
            }
            
        }

        // Make sure we found enough
        if numDeployPlotsFound < numUnits {
            return false
        }

        return true
    }
    
    /// Low-level wrapper on CvUnit::PushMission() for move to missions that avoids embarking if dangerous. Returns true if any move made
    @discardableResult
    func moveToUsingSafeEmbark(unit: AbstractUnit?, target: HexPoint, moveWasSafe: inout Bool, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        moveWasSafe = true

        // Move right away, if not a land unit
        if unit.domain() != .land {
            unit.push(mission: UnitMission(type: .moveTo, at: target), in: gameModel)
            return true
        }

        // If a land unit, get path to target
        if let path = unit.path(towards: target, options: .none, in: gameModel) {
            
            guard let movePoint = path.endTurnPlot(for: unit),
                  let movePlot = gameModel.tile(at: movePoint) else {
                fatalError("cant get movePlot")
            }
            
            // On land?  If so go ahead and move there
            if !movePlot.isWater() {
                unit.push(mission: UnitMission(type: .moveTo, at: target), in: gameModel)
                return true
            } else { // How dangerous is this plot?
                var dangerous = false

                let cell = gameModel.tacticalAnalysisMap().plots[target]
                if cell!.isSubjectToAttack() {
                    // Enemy naval unit can definitely attack this plot
                    dangerous = true
                } else {
                    if gameModel.tacticalAnalysisMap().isInEnemyDominatedZone(at: target) {
                        // Also dangerous in an enemy dominated naval zone
                        dangerous = true
                    }
                }

                // Not dangerous, proceed
                if !dangerous {
                    unit.push(mission: UnitMission(type: .moveTo, at: target), in: gameModel)
                    return true
                } else {
                    // Dangerous - try to move just on land
                    if unit.path(towards: target, options: .stayOnLand, in: gameModel) == nil {
                        
                        // No land path so just risk move to sea
                        unit.push(mission: UnitMission(type: .moveTo, at: target), in: gameModel)

                        // Hopefully the calling routine might be able to pull escort over to stack with this unit
                        moveWasSafe = false
                        return true;
                    } else {
                        unit.push(mission: UnitMission(type: .moveTo, at: target, options: .stayOnLand), in: gameModel)
                        return true
                    }
                }
            }
        } else {
            // No path this may happen if a unit has moved up and blocked our path to our target plot
            // If calling routine is moving a bunch of units like this it should retry these units
            moveWasSafe = false
            return false
        }
    }

    
    /// Fills m_CurrentMoveUnits with all units in operation that can get to target (returns TRUE if 1 or more found)
    func findClosestOperationUnit(target: AbstractTile?, safeForRanged: Bool, mustBeRangedUnit: Bool, in gameModel: GameModel?) -> Bool {
        
        guard let targetTile = target else {
            fatalError("cant get target")
        }
        
        /*FStaticVector<CvOperationUnit, SAFE_ESTIMATE_NUM_MULTIUNITFORMATION_ENTRIES, true, c_eCiv5GameplayDLL, 0>::iterator it;
        UnitHandle pLoopUnit;*/

        var rtnValue = false
        self.currentMoveUnits.removeAll()

        // Loop through all units available to operation
        for operationUnit in self.operationUnits {
            
            if let loopUnit = operationUnit.unit {
                var validUnit = true

                if loopUnit.hasMoved(in: gameModel) {
                    validUnit = false
                } else if !safeForRanged && loopUnit.canAttackRanged() {
                    validUnit = false
                } else if mustBeRangedUnit && !loopUnit.canAttackRanged() {
                    validUnit = false
                }

                if validUnit {
                    
                    let turns = loopUnit.turnsToReach(at: targetTile.point, in: gameModel)

                    if turns != Int.max {
                        
                        let tacticalUnit = TacticalUnit(unit: loopUnit, attackStrength: 1000 - turns, healthPercent: 100)
                        tacticalUnit.movesToTarget = targetTile.point.distance(to: loopUnit.location)
                        currentMoveUnits.append(tacticalUnit)
                        rtnValue = true
                    }
                }
            }
        }

        // Now sort them by turns to reach
        self.currentMoveUnits.sort(by: { $0!.movesToTarget < $1!.movesToTarget })

        return rtnValue
    }
    
    /// Queues up attacks on enemy units on or adjacent to army's desired center
    func clearEnemiesNearArmy(army: Army, in gameModel: GameModel?) {
        
        let range = 1
        var enemyNear = false
        
        guard let tacticalAnalysisMap = gameModel?.tacticalAnalysisMap() else {
            fatalError("cant get tacticalAnalysisMap")
        }

        // Loop through all appropriate targets to see if any is of concern
        for target in self.allTargets {
            
            // Is the target of an appropriate type?
            if target.targetType == .highPriorityUnit ||
                target.targetType == .mediumPriorityUnit ||
                target.targetType ==  .lowPriorityUnit {
                
                // Is this unit near enough?
                if army.position.distance(to: target.target) <= range {
                    enemyNear = true
                    break
                }
            }
        }

        if enemyNear {
            
            // Add units from army to tactical AI for this turn
            for unitRef in army.units() {
                
                guard let unit = unitRef else {
                    continue
                }

                if !unit.processedInTurn() && !unit.isDelayedDeath() && unit.canMove() {
                    
                    if !self.currentTurnUnits.contains(where: { $0?.location == unit.location && $0?.type == unit.type }) {
                        
                        self.currentTurnUnits.append(unitRef)
                    }
                }
            }

            // Now attack these targets
            for allTarget in self.allTargets {
                
                // Is the target of an appropriate type?
                if allTarget.targetType == .highPriorityUnit ||
                    allTarget.targetType == .mediumPriorityUnit ||
                    allTarget.targetType == .lowPriorityUnit {
                    
                    if allTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                        
                        // Is this unit near enough?
                        if allTarget.target.distance(to: army.position) <= range {
                            
                            guard let plot = gameModel?.tile(at: allTarget.target) else {
                                fatalError("cant get plot")
                            }

                            tacticalAnalysisMap.clearDynamicFlags();
                            
                            let bestFriendlyRange = tacticalAnalysisMap.bestFriendlyRange()
                            let ignoreLineOfSight = tacticalAnalysisMap.ignoreLineOfSight
                            tacticalAnalysisMap.setTargetBombardCells(target: allTarget.target, bestFriendlyRange: bestFriendlyRange, canIgnoreLightOfSight: ignoreLineOfSight, in: gameModel)

                            var attackUnderway = self.executeSafeBombards(on: allTarget, in: gameModel)
                            var attackMade = false
                            if allTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                                attackMade = self.executeProtectedBombards(on: allTarget, attackUnderway: &attackUnderway, in: gameModel)
                            }
                            
                            if attackMade {
                                attackUnderway = true
                            }
                            
                            if allTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                                
                                if let defender = gameModel?.visibleEnemy(at: allTarget.target, for: self.player) {
                                    
                                    allTarget.damage = defender.attackStrength(against: nil, or: nil, on: nil, in: gameModel)
                                    self.currentMoveCities.removeAll()
                                    
                                    if self.findUnitsWithinStrikingDistance(towards: allTarget.target, numTurnsAway: 1, in: gameModel) {
                                        self.computeTotalExpectedDamage(target: allTarget, and: plot, in: gameModel)
                                        self.executeAttack(target: allTarget, targetPlot: plot, inflictWhatWeTake: true, mustSurviveAttack: true, in: gameModel)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Store off a new unit that needs to move as part of an operational AI formation
    func moveWithFormation(unit: AbstractUnit?, at position: UnitFormationPosition) {
        
        if unit?.moves() ?? 0 > 0 {
            self.operationUnits.append(OperationUnit(unit: unit, at: position))
        }
    }
    
    /// Gather all units requested through calls to MoveWithFormation() to army's location
    func executeGatherMoves(of army: Army?, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let army = army else {
            return
        }

        if self.operationUnits.count == 0 {
            return
        }

        let target = army.position

        // Gathering - treat everyone as a melee unit; don't need ranged in the rear yet
        let numUnits = self.operationUnits.count

        // Range around target based on number of units we need to place
        var range = OperationHelpers.gatherRangeFor(numOfUnits: numUnits)

        // Try one time with computed range
        var foundEnoughDeploymentPlots = false
        if self.scoreDeploymentPlots(point: target, army: army, numMeleeUnits: numUnits, numRangedUnits: 0, range: range, in: gameModel) {
            // Did we get twice as many possible plots as units?
            if self.tempTargets.count >= (numUnits * 2) {
                foundEnoughDeploymentPlots = true;
            } else {
                self.tempTargets.removeAll()
                range = 3
            }
        }

        if !foundEnoughDeploymentPlots {
            
            if !self.scoreDeploymentPlots(point: target, army: army, numMeleeUnits: numUnits, numRangedUnits: 0, range: range, in: gameModel) {
                
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                    
                    print("Operation aborting. Army ID: \(army.identifier). Not enough spaces to deploy near target")
                    //LogTacticalMessage(strLogString);
                }
                
                army.operation?.state = .aborted(reason: .noRoomDeploy)
                return
            }
        }

        // Compute the moves to get the best deployment
        self.tempTargets.sort()
        self.potentialBlocks.removeAll()
        var done = false

        var unitsToPlace = numUnits

        for tempTarget in self.tempTargets {
            
            let targetType = tempTarget.targetType

            guard let loopPlot = gameModel.tile(at: tempTarget.target) else {
                continue
            }
            
            // Don't use if there's already a unit not in the army here
            if let unitAlreadyThere = gameModel.unit(at: tempTarget.target) {
                
                if unitAlreadyThere.army()?.identifier == army.identifier {
                
                    if self.findClosestOperationUnit(target: loopPlot, safeForRanged: true, mustBeRangedUnit: false, in: gameModel) {
                        
                        for currentMoveUnitRef in self.currentMoveUnits {
                            
                            guard let currentMoveUnit = currentMoveUnitRef else {
                                continue
                            }
                            
                            self.potentialBlocks.append(BlockingUnit(unit: currentMoveUnit.unit, at: tempTarget.target, numChoices: self.currentMoveUnits.count, distanceToTarget: currentMoveUnit.movesToTarget))
                        }
                        
                        unitsToPlace -= 1
                        if unitsToPlace == 0 {
                            done = true
                        }
                    }
                }
            }
        }

        // Now ready to make the assignments
        self.assignDeployingUnits(numUnitsRequiredToDeploy: numUnits - unitsToPlace, in: gameModel)

        self.performChosenMoves(in: gameModel)

        // Log if someone in army didn't get a move assigned (how do we address this in the future?)
        if self.chosenBlocks.count < numUnits {
            
            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                
                print("No gather move for \(numUnits - self.chosenBlocks.count) units")
                // LogTacticalMessage(strMsg);
            }
        }
    }
    
    /// Pick best hexes for deploying our army (based on safety, terrain, and keeping a tight formation). Returns false if insufficient free plots.
    func scoreDeploymentPlots(point target: HexPoint, army: Army, numMeleeUnits: Int, numRangedUnits: Int, range: Int, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        let tacticalAnalysisMap = gameModel.tacticalAnalysisMap()
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        /*int iDX, iDY;
        int iScore;
        CvPlot* pPlot;
        CvTacticalAnalysisCell* pCell;*/
        var safeForDeployment: Bool
        var forcedToUseWater: Bool
        var numSafePlotsFound = 0;
        var numDeployPlotsFound = 0;
        //CvTacticalTarget target;*/

        // We'll store the hexes we've found here
        self.tempTargets.removeAll()

        for dx in -range...range {
            
            for dy in -range...range {
                
                let plotPoint = HexPoint(x: target.x + dx, y: target.y + dy)
                
                if let plot = gameModel.tile(at: plotPoint) {
                    
                    safeForDeployment = true
                    forcedToUseWater = false

                    let plotDistance = plotPoint.distance(to: target)
                    if plotDistance <= range {
                        
                        //int iPlotIndex = GC.getMap().plotNum(pPlot->getX(), pPlot->getY());
                        guard let cell = tacticalAnalysisMap.plots[plotPoint], let operation = army.operation else {
                            continue
                        }
                        
                        var valid = false
                        if operation.isMixedLandNavalOperation() && cell.canUseForOperationGatheringCheckWater(isWater: true) {
                            valid = true
                        } else if operation.isAllNavalOperation() && cell.canUseForOperationGatheringCheckWater(isWater: true) {
                            valid = true
                        } else if !operation.isAllNavalOperation() && !operation.isMixedLandNavalOperation() && (cell.canUseForOperationGatheringCheckWater(isWater: false) || gameModel.isPrimarilyNaval()) {
                            valid = true
                            if cell.isWater() {
                                forcedToUseWater = true
                            }
                        }

                        if operation.isMixedLandNavalOperation() || operation.isAllNavalOperation() {
                            
                            if !army.isAllOceanGoing(in: gameModel) && cell.isOcean() {
                                valid = false
                            }
                        }

                        if valid {
                            // Skip this plot if friendly unit that isn't in this army
                            if let friendlyUnit = cell.friendlyMilitaryUnit {
                                if friendlyUnit.army()?.identifier != army.identifier {
                                    continue
                                }
                            }

                            numDeployPlotsFound += 1
                            var score = 600 - (plotDistance * 100)
                            if cell.isSubjectToAttack() {
                                score -= 100
                                safeForDeployment = false
                            } else {
                                numSafePlotsFound += 1
                            }
                            
                            if cell.isEnemyCanMovePast() {
                                score -= 100
                            }
                            
                            if gameModel.city(at: plotPoint) != nil && player.isEqual(to: gameModel.tile(at: plotPoint)?.owner()) {
                                score += 100
                            } else {
                                score += cell.defenseModifier * 2
                            }
                            
                            if forcedToUseWater {
                                score = 10
                            }

                            cell.safeDeployment = safeForDeployment
                            cell.deploymentScore = score

                            // Save this in our list of potential targets
                            let tacticalTarget = TacticalTarget(targetType: .none, target: plotPoint)
                            
                            tacticalTarget.threatValue = score // or damage ?

                            // A bit of a hack -- use high priority targets to indicate safe plots for ranged units
                            if safeForDeployment {
                                tacticalTarget.targetType = .highPriorityUnit
                            } else {
                                tacticalTarget.targetType = .lowPriorityUnit
                            }

                            self.tempTargets.append(tacticalTarget)
                        }
                    }
                }
            }
        }

        // Make sure we found enough
        if numSafePlotsFound < numRangedUnits || numDeployPlotsFound < (numMeleeUnits + numRangedUnits) {
            return false
        }

        return true
    }
    
    /// Make and log selected movements
    func performChosenMoves(fallbackMoveRange: Int = 1, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // Make moves up into hexes, starting with units already close to their final destination
        self.chosenBlocks.sort { (aRef, bRef) -> Bool in
            return aRef!.distanceToTarget < bRef!.distanceToTarget
        }

        // First loop through is for units that have a unit moving into their hex.  They need to leave first!
        for chosenBlockRef in self.chosenBlocks {
            
            guard let chosenBlock = chosenBlockRef else {
                continue
            }
            
            if let unit = chosenBlock.unit {
                
                if unit.location != chosenBlock.point && self.isInChosenMoves(at: unit.location) && gameModel.numFriendlyUnits(at: chosenBlock.point, player: self.player, of: unit.type) == 0 {
                    
                    var moveWasSafe = false
                    self.moveToUsingSafeEmbark(unit: unit, target: chosenBlock.point, moveWasSafe: &moveWasSafe, in: gameModel)

                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        
                        print("Deploying \(unit.name()) (to get out of way), To \(chosenBlock.point), At \(unit.location), Distance Before Move: \(chosenBlock.distanceToTarget)")
                        //LogTacticalMessage(strMsg);
                    }

                    // Use number of choices field to indicate already moved
                    chosenBlockRef?.numChoices = -1
                }
            }
        }

        // Second loop is for units moving into their chosen spot normally
        for chosenBlockRef in self.chosenBlocks {
            
            guard let chosenBlock = chosenBlockRef else {
                continue
            }
            
            if let unit = chosenBlock.unit {
                
                if unit.location == chosenBlock.point {
                    chosenBlockRef?.numChoices = -1
                } else {
                    // Someone we didn't move above?
                    if chosenBlock.numChoices != -1 {
                        
                        let plotBeforeMove = unit.location
                        var moveWasSafe = false
                        self.moveToUsingSafeEmbark(unit: unit, target: chosenBlock.point, moveWasSafe: &moveWasSafe, in: gameModel)

                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                            
                            print("Deploying \(unit.name()), To \(chosenBlock.point), At \(unit.location), Distance Before Move: \(chosenBlock.distanceToTarget)")
                            // LogTacticalMessage(strMsg);
                        }

                        // Use number of choices field to indicate already moved
                        if plotBeforeMove != unit.location {
                            chosenBlockRef?.numChoices = -1
                        }
                    }
                }
            }
        }

        // Third loop is for units we still haven't been able to move (other units must be blocking their target for this turn)
        if fallbackMoveRange > 0 {
            
            for chosenBlockRef in self.chosenBlocks {
                
                guard let chosenBlock = chosenBlockRef else {
                    continue
                }
                
                if let unit = chosenBlock.unit {
                    
                    // Someone we didn't move above?
                    if chosenBlock.numChoices != -1 {
                        
                        let plotBeforeMove = unit.location

                        if self.moveToEmptySpaceNearTarget(unit: unit, target: chosenBlock.point, land: unit.domain() == .land, in: gameModel) {
                            
                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                
                                print("Deploying \(unit.name()) to space near target, Target \(chosenBlock.point): %d, At \(unit.location), Distance Before Move: \(chosenBlock.distanceToTarget)")
                                // LogTacticalMessage(strMsg);
                            }

                            if plotBeforeMove != unit.location {
                                chosenBlockRef?.numChoices = -1
                            }
                        }
                    }
                }
            }
        }

        // Fourth loop let's unit end within 2 of target
        if fallbackMoveRange > 1 {
            
            for chosenBlockRef in self.chosenBlocks {
                
                guard let chosenBlock = chosenBlockRef else {
                    continue
                }
                
                if let unit = chosenBlock.unit {
                    
                    // Someone we didn't move above?
                    if chosenBlock.numChoices != -1 {
                        
                        if self.moveToEmptySpaceTwoFromTarget(unit: unit, target: chosenBlock.point, land: unit.domain() == .land, in: gameModel)
                        {
                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                
                                print("Deploying \(unit.name()) to space within 2 of target, Target \(chosenBlock.point), At \(unit.location), Distance Before Move: \(chosenBlock.distanceToTarget)")
                                // LogTacticalMessage(strMsg);
                            }
                        }
                    }
                }
            }
        }

        // Finish moves for all units
        for chosenBlockRef in self.chosenBlocks {
            
            guard let chosenBlock = chosenBlockRef else {
                continue
            }
            
            if let unit = chosenBlock.unit {
                
                if !unit.isDelayedDeath() {
                    if unit.moves() > 0 {
                        if unit.canPillage(at: unit.location, in: gameModel) && unit.damage() > 0 {
                            unit.push(mission: UnitMission(type: .pillage), in: gameModel)
                            
                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                
                                print("Already in position, will pillage with \(unit.name()), \(chosenBlock.point)")
                                // LogTacticalMessage(strMsg);
                            }

                        } else if unit.canFortify(at: unit.location, in: gameModel) {
                            unit.push(mission: UnitMission(type: .fortify), in: gameModel)
                            
                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                
                                print("Already in position, will fortify with \(unit.name()), \(chosenBlock.point)")
                                // LogTacticalMessage(strMsg);
                            }
                        } else {
                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                
                                print("Already in position, no move for \(unit.name()), \(chosenBlock.point)")
                                // LogTacticalMessage(strMsg);
                            }
                        }
                        
                        unit.finishMoves()
                    }
                    
                    self.unitProcessed(unit: unit, in: gameModel)
                }
            }
        }
    }
    
    /// Move up to our target (this time within 2 spaces) avoiding our own units if possible
    // unit, chosenBlock.point, unit.domain() == .land, in: gameModel
    func moveToEmptySpaceTwoFromTarget(unit: AbstractUnit?, target: HexPoint, land: Bool, in gameModel: GameModel?) -> Bool {
     
        guard let gameModel = gameModel, let unit = unit, let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get gameModel")
        }

        // Look at spaces adjacent to target
        for loopPoint in target.areaWith(radius: 3) {
            
            guard let loopPlot = gameModel.tile(at: loopPoint) else {
                continue
            }
            
            if loopPlot.isWater() != land && loopPoint.distance(to: target) == 2 {
                
                // Must be currently empty of friendly combat units
                // Enemies too
                if gameModel.unit(at: loopPoint) == nil {

                    let loopCity = gameModel.city(at: loopPoint)
                    
                    // And if it is a city, make sure we are friends with them, else we will automatically attack
                    if loopCity == nil || !diplomacyAI.isAtWar(with: loopCity!.player) {
                        // Find a path to this space
                        if unit.path(towards: loopPoint, options: .none, in: gameModel) != nil {
                            // Go ahead with mission
                            var moveWasSafe = false
                            self.moveToUsingSafeEmbark(unit: unit, target: loopPoint, moveWasSafe: &moveWasSafe, in: gameModel)
                            return true
                        }
                    }
                    
                }
            }
        }
        return false
    }
    
    // Is one of the chosen moves to this plot?
    func isInChosenMoves(at point: HexPoint) -> Bool {
        
        for chosenBlock in self.chosenBlocks {
            
            if chosenBlock?.point == point {
                return true
            }
        }

        return false
    }
    
    func processDominanceZones(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        let tacticalAnalysisMap = gameModel.tacticalAnalysisMap()
        
        // Barbarian processing is straightforward -- just one big list of priorites and everything is considered at once
        if player?.leader == .barbar {
            self.establishBarbarianPriorities(in: gameModel.currentTurn)
            self.extractTargets()
            self.assignBarbarianMoves(in: gameModel)
            
        } else {
            self.establishTacticalPriorities()
            self.updatePostures(in: gameModel)

            // Proceed in priority order
            for move in self.movePriorityList {
                
                if move.priority >= 0 {
                    
                    if move.moveType.dominanceZoneMove() {
                        
                        for dominanceZone in tacticalAnalysisMap.dominanceZones {

                            self.currentDominanceZone = dominanceZone
                            
                            let postureType = self.findPostureType(for: dominanceZone)
                            
                            // Is this move of the right type for this zone?
                            var match = false
                            if move.moveType == .closeOnTarget {   // This one okay for all zones
                                match = true
                            } else if postureType == .withdraw && move.moveType == .postureWithdraw {
                                match = true
                            } else if postureType == .sitAndBombard && move.moveType == .postureSitAndBombard {
                                match = true;
                            } else if postureType == .attritFromRange && move.moveType == .postureAttritFromRange {
                                match = true
                            } else if postureType == .exploitFlanks && move.moveType == .postureExploitFlanks {
                                match = true
                            } else if postureType == .steamRoll && move.moveType == .postureSteamroll {
                                match = true
                            } else if postureType == .surgicalCityStrike && move.moveType == .postureSurgicalCityStrike {
                                match = true
                            } else if postureType == .hedgehog && move.moveType == .postureHedgehog {
                                match = true
                            } else if postureType == .counterAttack && move.moveType == .postureCounterAttack {
                                match = true
                            } else if postureType == .shoreBombardment && move.moveType == .postureShoreBombardment {
                                match = true
                            } else if dominanceZone.dominanceFlag == .enemy && dominanceZone.territoryType == .friendly && move.moveType == .emergencyPurchases {
                                match = true
                            }

                            if match {
                                if !self.useThis(dominanceZone: dominanceZone) {
                                    continue
                                }

                                self.extractTargets(for: dominanceZone)

                                // Must have some moves to continue or it must be land around an enemy city (which we always want to process because
                                // we might have an operation targeting it)
                                if self.zoneTargets.count <= 0 && dominanceZone.territoryType != .tempZone && (dominanceZone.territoryType != .enemy || dominanceZone.isWater) {
                                    continue
                                }

                                self.assign(tacticalMove: move, in: gameModel)
                            }
                        }
                    } else {
                        self.extractTargets()
                        self.assign(tacticalMove: move, in: gameModel)
                    }
                }
            }
        }
    }
    
    /// Sift through the target list and find just those that apply to the dominance zone we are currently looking at
    private func extractTarget(for dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?) {
        
        fatalError("not implemented yet")
    }
    
    /// Choose which tactics to run and assign units to it
    private func assign(tacticalMove: TacticalMove, in gameModel: GameModel?) {
        
        switch tacticalMove.moveType {
            
        case .moveNoncombatantsToSafety:
            // TACTICAL_MOVE_NONCOMBATANTS_TO_SAFETY
            self.plotMovesToSafety(combatUnits: false, in: gameModel)
        case .reposition:
            // TACTICAL_REPOSITION
            self.plotRepositionMoves(in: gameModel)
        case .garrisonAlreadyThere:
            // TACTICAL_GARRISON_ALREADY_THERE
            self.plotGarrisonMoves(numTurnsAway: 0, in: gameModel)
        case .garrisonToAllowBombards:
            // TACTICAL_GARRISON_TO_ALLOW_BOMBARD
            self.plotGarrisonMoves(numTurnsAway: 1, mustAllowRangedAttack: true, in: gameModel)
        case .captureCity:
            // TACTICAL_CAPTURE_CITY
            self.plotCaptureCityMoves(in: gameModel)
        case .damageCity:
            // TACTICAL_DAMAGE_CITY
            self.plotDamageCityMoves(in: gameModel)
        case .destroyHighUnit:
            // TACTICAL_DESTROY_HIGH_UNIT
            self.plotDestroyUnitMoves(targetType: .highPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
        case .destroyMediumUnit:
            // TACTICAL_DESTROY_MEDIUM_UNIT
            self.plotDestroyUnitMoves(targetType: .mediumPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
        case .destroyLowUnit:
            // TACTICAL_DESTROY_LOW_UNIT
            self.plotDestroyUnitMoves(targetType: .lowPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
        case .toSafety:
            // TACTICAL_TO_SAFETY
            self.plotMovesToSafety(combatUnits: true, in: gameModel)
        case .attritHighUnit:
            // TACTICAL_ATTRIT_HIGH_UNIT
            self.plotDestroyUnitMoves(targetType: .highPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
        case .attritMediumUnit:
            // TACTICAL_ATTRIT_MEDIUM_UNIT
            self.plotDestroyUnitMoves(targetType: .mediumPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
        case .attritLowUnit:
            // TACTICAL_ATTRIT_LOW_UNIT
            self.plotDestroyUnitMoves(targetType: .lowPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
        case .barbarianCamp:
            // TACTICAL_BARBARIAN_CAMP
            self.plotBarbarianCampMoves(in: gameModel)
        case .pillage:
            // TACTICAL_PILLAGE
            self.plotPillageMoves(targetType: .improvement, firstPass: true, in: gameModel)
        case .civilianAttack:
            // fatalError("not implemented yet")
            // NOOP
            break
        case .safeBombards:
            // TACTICAL_SAFE_BOMBARDS
            self.plotSafeBombardMoves(in: gameModel)
        case .heal:
            // TACTICAL_HEAL
            self.plotHealMoves(in: gameModel)
        case .ancientRuins:
            // TACTICAL_ANCIENT_RUINS
            self.plotAncientRuinMoves(turnsAway: 1, in: gameModel)
        case .bastionAlreadyThere:
            // TACTICAL_BASTION_ALREADY_THERE
            self.plotBastionMoves(numTurnsAway: 0, in: gameModel)
        case .guardImprovementAlreadyThere:
            // TACTICAL_GUARD_IMPROVEMENT_ALREADY_THERE
            self.plotGuardImprovementMoves(numTurnsAway: 0, in: gameModel)
        case .bastionOneTurn:
            // TACTICAL_BASTION_1_TURN
            self.plotBastionMoves(numTurnsAway: 1, in: gameModel)
        case .garrisonOneTurn:
            // TACTICAL_GARRISON_1_TURN
            self.plotGarrisonMoves(numTurnsAway: 1, in: gameModel)
        case .guardImprovementOneTurn:
            // TACTICAL_GUARD_IMPROVEMENT_1_TURN
            self.plotGuardImprovementMoves(numTurnsAway: 1, in: gameModel)
        case .airSweep:
            // TACTICAL_AIR_SWEEP
            self.plotAirSweepMoves(in: gameModel)
        case .airIntercept:
            // TACTICAL_AIR_INTERCEPT
            self.plotAirInterceptMoves(in: gameModel)
        case .airRebase:
            //fatalError("not implemented yet")
            // NOOP
            break
        case .closeOnTarget:
            // TACTICAL_CLOSE_ON_TARGET
            self.plotCloseOnTarget(checkDominance: true, in: gameModel)
        case .moveOperation:
            // TACTICAL_MOVE_OPERATIONS
            self.plotOperationalArmyMoves(in: gameModel)
        case .emergencyPurchases:
            // TACTICAL_EMERGENCY_PURCHASES
            self.plotEmergencyPurchases(in: gameModel)
        case .postureWithdraw:
            // TACTICAL_POSTURE_WITHDRAW
            self.plotWithdrawMoves(in: gameModel)
        case .postureSitAndBombard:
            // TACTICAL_POSTURE_SIT_AND_BOMBARD
            self.plotSitAndBombardMoves(in: gameModel)
        case .postureAttritFromRange:
            // TACTICAL_POSTURE_ATTRIT_FROM_RANGE
            self.plotAttritFromRangeMoves(in: gameModel)
        case .postureExploitFlanks:
            // TACTICAL_POSTURE_EXPLOIT_FLANKS
            self.plotExploitFlanksMoves(in: gameModel)
        case .postureSteamroll:
            // TACTICAL_POSTURE_STEAMROLL
            self.plotSteamrollMoves(in: gameModel)
        case .postureSurgicalCityStrike:
            // TACTICAL_POSTURE_SURGICAL_CITY_STRIKE
            self.plotSurgicalCityStrikeMoves(in: gameModel)
        case .postureHedgehog:
            // TACTICAL_POSTURE_HEDGEHOG
            self.plotHedgehogMoves(in: gameModel)
        case .postureCounterAttack:
            // TACTICAL_POSTURE_COUNTERATTACK
            self.plotCounterAttackMoves(in: gameModel)
        case .postureShoreBombardment:
            // TACTICAL_POSTURE_SHORE_BOMBARDMENT
            self.plotShoreBombardmentMoves(in: gameModel)
        default:
            // NOOP
            print("not implemented: TacticalAI - \(tacticalMove.moveType)")
            break
        }
    }
    
    /// Pop goody huts nearby
    private func plotAncientRuinMoves(turnsAway: Int, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        for zoneTargetRef in self.zoneTargets(for: .ancientRuins) {
            
            guard let zoneTarget = zoneTargetRef else {
                continue
            }
            
            // Grab units that make sense for this move type
            guard let plot = gameModel.tile(at: zoneTarget.target) else {
                continue
            }
            
            self.findUnitsFor(move: .ancientRuins, target: plot, rangedOnly: false, in: gameModel)

            if self.currentMoveHighPriorityUnits.count + self.currentMoveUnits.count > 0 {
                
                self.executeMoveToTarget(target: plot.point, garrisonIfPossible: false, in: gameModel)

                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                    
                    print("Moving to goody hut, \(zoneTarget.target), Turns Away: \(turnsAway)")
                    // LogTacticalMessage(strLogString);
                }
            }
        }
    }
    
    /// Establish a defensive bastion adjacent to a city
    private func plotBastionMoves(numTurnsAway: Int, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        for zoneTargetRef in self.zoneTargets(for: .defensiveBastion) {
            
            guard let zoneTarget = zoneTargetRef else {
                continue
            }
            
            // Grab units that make sense for this move type
            guard let plot = gameModel.tile(at: zoneTarget.target) else {
                continue
            }
            
            self.findUnitsFor(move: .bastionAlreadyThere, target: plot, turnsAway: numTurnsAway, rangedOnly: false, in: gameModel)

            if self.currentMoveHighPriorityUnits.count + self.currentMoveUnits.count > 0 {
                
                self.executeMoveToTarget(target: zoneTarget.target, garrisonIfPossible: false, in: gameModel)
                
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                    
                    print("Bastion, \(zoneTarget.target), Priority: \(zoneTarget.threatValue), Turns Away: \(numTurnsAway)")
                    // LogTacticalMessage(strLogString);
                }
            }
        }
        
        /*CvTacticalTarget* pTarget;
        pTarget = GetFirstZoneTarget(AI_TACTICAL_TARGET_DEFENSIVE_BASTION);
        while(pTarget != NULL)
        {
            // Grab units that make sense for this move type
            CvPlot* pPlot = GC.getMap().plot(pTarget->GetTargetX(), pTarget->GetTargetY());
            FindUnitsForThisMove((TacticalAIMoveTypes)m_CachedInfoTypes[eTACTICAL_BASTION_ALREADY_THERE], pPlot, iNumTurnsAway);

            if(m_CurrentMoveHighPriorityUnits.size() + m_CurrentMoveUnits.size() > 0)
            {
                ExecuteMoveToTarget(pPlot);
                
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                    
                    print("Bastion, X: %d, Y: %d, Priority: %d, Turns Away: %d", pTarget->GetTargetX(), pTarget->GetTargetY(), pTarget->GetAuxIntData(), iNumTurnsAway);
                    // LogTacticalMessage(strLogString);
                }
            }
            pTarget = GetNextZoneTarget();
        }*/
    }
    
    /// Move units to a better location
    private func plotRepositionMoves(in gameModel: GameModel?) {
        
        self.currentMoveUnits.removeAll()

        // Loop through all recruited units
        for currentTurnUnitRef in self.currentTurnUnits {
            
            if let currentTurnUnit = currentTurnUnitRef {
                
                self.currentMoveUnits.append(TacticalUnit(unit: currentTurnUnit))
            }
        }

        if self.currentMoveUnits.count > 0 {
            self.executeRepositionMoves(in: gameModel)
        }
    }
    
    /// Find all targets that we can bombard easily
    func plotSafeBombardMoves(in gameModel: GameModel?) {
        
        guard let tacticalAnalysisMap = gameModel?.tacticalAnalysisMap() else {
            fatalError("cant get tacticalAnalysisMap")
        }
        
        for targetRef in self.zoneTargets(for: .highPriorityUnit) {
            
            guard let target = targetRef else {
                continue
            }
            
            if target.isTargetStillAlive(for: self.player, in: gameModel) {
                
                let bestFriendlyRange = tacticalAnalysisMap.bestFriendlyRange()
                let canIgnoreLightOfSight = tacticalAnalysisMap.canIgnoreLightOfSight()
                
                tacticalAnalysisMap.clearDynamicFlags()
                tacticalAnalysisMap.setTargetBombardCells(target: target.target, bestFriendlyRange: bestFriendlyRange, canIgnoreLightOfSight: canIgnoreLightOfSight, in: gameModel)

                self.executeSafeBombards(on: target, in: gameModel)
            }
        }
        
        for targetRef in self.zoneTargets(for: .mediumPriorityUnit) {
            
            guard let target = targetRef else {
                continue
            }
            
            if target.isTargetStillAlive(for: self.player, in: gameModel) {
                
                // m_pMap->ClearDynamicFlags();
                // m_pMap->SetTargetBombardCells(pTargetPlot, m_pMap->GetBestFriendlyRange(), m_pMap->CanIgnoreLOS());
                self.executeSafeBombards(on: target, in: gameModel)
            }
        }
        
        for targetRef in self.zoneTargets(for: .lowPriorityUnit) {
            
            guard let target = targetRef else {
                continue
            }
            
            if target.isTargetStillAlive(for: self.player, in: gameModel) {
                
                // m_pMap->ClearDynamicFlags();
                // m_pMap->SetTargetBombardCells(pTargetPlot, m_pMap->GetBestFriendlyRange(), m_pMap->CanIgnoreLOS());
                self.executeSafeBombards(on: target, in: gameModel)
            }
        }

        for targetRef in self.zoneTargets(for: .embarkedMilitaryUnit) {
            
            guard let target = targetRef else {
                continue
            }
            
            if target.isTargetStillAlive(for: self.player, in: gameModel) {
                
                
                // m_pMap->ClearDynamicFlags();
                // m_pMap->SetTargetBombardCells(pTargetPlot, m_pMap->GetBestFriendlyRange(), m_pMap->CanIgnoreLOS());
                self.executeSafeBombards(on: target, in: gameModel)
            }
        }
    }
    
    /// Do we already have a queued attack running on this plot? Return series ID if yes, -1 if no.
    func plotAlreadyTargeted(point: HexPoint) -> Int {
        
        if self.queuedAttacks.count > 0 {
            
            for queuedAttack in self.queuedAttacks {
                
                if point == queuedAttack.target?.target {
                    return queuedAttack.seriesId
                }
            }
        }
        
        return -1
    }
    
    /// Bombard enemy units from plots they can't reach (return true if some attack made)
    @discardableResult
    func executeSafeBombards(on target: TacticalTarget, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        /* bool bCityCanAttack = false;*/
        var firstAttackerCity: AbstractCity? = nil
        var firstAttackerUnit: AbstractUnit? = nil
        var firstAttackCity: Bool = false
        var requiredDamage: Int = 0
        
        guard let targetPlot = gameModel.tile(at: target.target) else {
            fatalError("can get targetPlot")
        }

        if self.plotAlreadyTargeted(point: target.target) != -1 {
            return false
        }

        // Get required damage on unit target
        if let defender = gameModel.visibleEnemy(at: target.target, for: self.player) {
            
            requiredDamage = defender.healthPoints()

            // If this is a unit target we might also be able to hit it with a city
            let cityCanAttack = self.findCitiesWithinStrikingDistance(of: target.target, in: gameModel)
            if cityCanAttack {
                
                self.computeTotalExpectedBombardDamage(against: defender, in: gameModel)

                // Start by applying damage from city bombards
                for currentMoveCity in self.currentMoveCities {
                    
                    if let city = currentMoveCity?.city {
                        
                        if self.queueAttack(attacker: city, target: target, ranged: true) {
                            firstAttackerCity = city
                            firstAttackCity = true
                        }

                        // Subtract off expected damage
                        requiredDamage -= currentMoveCity?.expectedTargetDamage ?? 0
                    }
                }
            }
        } else {
            // Get required damage on city target
            
            if let city = gameModel.city(at: target.target) {
                
                requiredDamage = city.maxHealthPoints() - city.healthPoints()

                // Can't eliminate a city with ranged fire, so don't target one if that is low on health
                if requiredDamage <= 1 {
                    return false
                }
            }
        }

        // Need to keep hitting target?
        if requiredDamage <= 0 {
            return false
        }

        // For each of our ranged units, see if they are already in a plot that can bombard that can't be attacked.
        // If so, bombs away!
        self.currentMoveUnits.removeAll()
        
        for currentTurnUnit in currentTurnUnits {
            
            guard let unit = currentTurnUnit else {
                continue
            }
            
            if unit.canAttackRanged() && !unit.isOutOfAttacks() {
                
                guard let cell = gameModel.tacticalAnalysisMap().plots[unit.location] else {
                    continue
                }
                
                if cell.withinRangeOfTarget && !cell.subjectToAttack && self.isExpectedToDamageWithRangedAttack(by: unit, towards: target.target, in: gameModel) {
                    
                    if unit.canSetUpForRangedAttack() {
                        
                        unit.set(setUpForRangedAttack: true)
                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                            
                            print("Set up \(unit.type) for ranged attack")
                            // LogTacticalMessage(strMsg, false);
                        }
                    }

                    if unit.canMove() && unit.canRangeStrike(at: target.target, needWar: true, noncombatAllowed: true) {
                        
                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                            
                            print("Making a safe bombard (no move) with \(unit.name()), Target \(target.target), At \(unit.location)")
                            // LogTacticalMessage(strMsg, false);
                        }

                        if self.queueAttack(attacker: unit, target: target, ranged: true) {
                            firstAttackerUnit = unit
                        }

                        // Save off ID so can be cleared from list to process for turn
                        self.currentMoveUnits.append(TacticalUnit(unit: unit))
                    }
                }
            }
        }

        // Clear out the units we just processed from the list for this turn
        for currentMoveUnit in self.currentMoveUnits {
            self.unitProcessed(unit: currentMoveUnit?.unit, in: gameModel)
        }

        // For each plot that we can bombard from that the enemy can't attack, try and move a ranged unit there.
        // If so, make that move and mark that tile as blocked with our unit.  If unit has movement left, queue up an attack
        /*int iDX, iDY;
        CvPlot* pLoopPlot;
        int iPlotIndex;
        CvTacticalAnalysisCell* pCell;*/

        for turnsToReach in 0...2 {
            
            let range = gameModel.tacticalAnalysisMap().bestFriendlyRange()

            for dx in -range...range {
                for dy in -range...range {
                    
                    let loopPoint = HexPoint(x: target.target.x + dx, y: target.target.y + dy)
                    guard let loopPlot = gameModel.tile(at: loopPoint) else {
                        continue
                    }
                    
                    let distance = target.target.distance(to: loopPoint)
                    
                    if distance > 0 && distance <= range {
                        
                        guard let cell = gameModel.tacticalAnalysisMap().plots[loopPoint] else {
                            continue
                        }
                        
                        if cell.isRevealed() && cell.canUseForOperationGathering() {
                            
                            if cell.isWithinRangeOfTarget() && !cell.isSubjectToAttack() {
                                
                                let haveLightOfSight = loopPlot.canSee(tile: targetPlot, for: self.player, range: range, in: gameModel)
                                
                                if self.findClosestUnit(towards: loopPlot, numTurnsAway: turnsToReach, mustHaveHalfHP: false, mustBeRangedUnit: true, rangeRequired: distance, needsIgnoreLineOfSight: !haveLightOfSight, mustBeMeleeUnit: false, ignoreUnits: true, rangedAttackTarget: targetPlot, in: gameModel) {
                                    
                                    if let unit = self.currentMoveUnits.first??.unit {
                                        
                                        // Check for presence of unmovable friendly units
                                        let blockingUnit = gameModel.unit(at: loopPoint)
                                        if blockingUnit == nil || self.executeMoveOfBlockingUnit(of: blockingUnit, in: gameModel) {
                                            
                                            unit.push(mission: UnitMission(type: .moveTo, at: loopPoint), in: gameModel)

                                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                                
                                                print("Moving closer for safe bombard with \(unit.name()), Target \(target.target), Bombard From \(loopPoint), Now At \(unit.location)")
                                                // LogTacticalMessage(strMsg, false);
                                            }

                                            self.unitProcessed(unit: unit, in: gameModel)

                                            if unit.canSetUpForRangedAttack() {
                                                unit.set(setUpForRangedAttack: true)
                                                
                                                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                                    
                                                    print("Set up \(unit.name()) for ranged attack")
                                                    // LogTacticalMessage(strMsg, false);
                                                }
                                            }

                                            if unit.canMove() && !unit.isOutOfAttacks() && unit.canRangeStrike(at: target.target, needWar: false, noncombatAllowed: true) {
                                                
                                                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                                    
                                                    print("Making a safe bombard (half move) with \(unit.name()), Target \(target.target), At \(unit.location)")
                                                    // LogTacticalMessage(strMsg, false);
                                                }

                                                if self.queueAttack(attacker: unit, target: target, ranged: true) {
                                                    firstAttackerUnit = unit
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

        // Launch the initial attack plotted
        if let city = firstAttackerCity {
            self.launchAttack(for: city, target: target, firstAttack: true, ranged: true, in: gameModel)
            return true
        } else if let unit = firstAttackerUnit {
            self.launchAttack(for: unit, target: target, firstAttack: true, ranged: true, in: gameModel)
            return true
        }
        
        return false
    }
    
    /// Assigns units to heal
    func plotHealMoves(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        self.currentMoveUnits.removeAll()

        // Loop through all recruited units
        for currentTurnUnit in self.currentTurnUnits {
            
            guard let unit = currentTurnUnit else {
                continue
            }
            
            // Am I under 100% health and not embarked or already in a city?
            if unit.healthPoints() < unit.maxHealthPoints() && !unit.isEmbarked() && gameModel.city(at: unit.location) == nil {
                
                // If I'm a naval unit I need to be in friendly territory
                if unit.domain() != .sea || gameModel.tile(at: unit.location)!.isFriendlyTerritory(for: self.player, in: gameModel) {
                    
                    if !unit.isUnderEnemyRangedAttack() {
                        
                        self.currentMoveUnits.append(TacticalUnit(unit: unit))

                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                            
                            print("Healing at, \(unit.location)")
                            // LogTacticalMessage(strLogString);
                        }
                    }
                }
            }
        }
        
        if self.currentMoveUnits.count > 0 {
            
            self.executeHeals(in: gameModel)
        }
    }
    
    /// Heal chosen units
    private func executeHeals(in gameModel: GameModel?) {
        
        for currentMoveUnit in self.currentMoveUnits {
            
            guard let unit = currentMoveUnit?.unit else {
                continue
            }
            
            if unit.canFortify(at: unit.location, in: gameModel) {
                unit.push(mission: UnitMission(type: .fortify), in: gameModel)
                unit.set(fortifiedThisTurn: true, in: gameModel)
            } else {
                unit.push(mission: UnitMission(type: .skip), in: gameModel)
            }
            
            self.unitProcessed(unit: unit, in: gameModel)
        }
    }
    
    /// Execute moving units to a better location
    private func executeRepositionMoves(in gameModel: GameModel?)
    {
        //CvPlot* pBestPlot = NULL;
        //CvString strTemp;
        
        for currentMoveUnitRef in self.currentMoveUnits {
            
            if let currentMoveUnit = currentMoveUnitRef, let unit = currentMoveUnit.unit {
                
                // LAND MOVES
                if unit.domain() == .land {
            
                    if let bestPlot = self.findNearbyTarget(for: unit, in: TacticalAI.repositionRange, in: gameModel) {
                        
                        if self.moveToEmptySpaceNearTarget(unit: unit, target: bestPlot, land: unit.domain() == .land, in: gameModel) {
                            
                            unit.finishMoves()
                            self.unitProcessed(unit: unit, markTacticalMap: unit.isCombatUnit(), in: gameModel)
                            
                            print("\(unit.name()) moved to empty space near target, \(bestPlot), Current \(unit.location)")
                        }
                    }
                }
            }
        }
    }
    
    /// Move up to our target avoiding our own units if possible
    @discardableResult
    private func moveToEmptySpaceNearTarget(unit: AbstractUnit?, target: HexPoint, land: Bool, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }

        // Look at spaces adjacent to target
        for neighbor in target.neighbors() {
            
            if let neighborTile = gameModel.tile(at: neighbor) {
                
                if neighborTile.terrain().isLand() && land {
                    
                    // Must be currently empty of friendly combat units
                    // Enemies too
                    let occupant = gameModel.unit(at: neighbor)
                    
                    if occupant == nil {
                        
                        // And if it is a city, make sure we are friends with them, else we will automatically attack
                        let city = gameModel.city(at: neighbor)
                        if city == nil || city?.player?.leader == unit.player?.leader {
                            
                            // Find a path to this space
                            if unit.canReach(at: neighbor, in: 1, in: gameModel) {
                                // Go ahead with mission
                                unit.push(mission: UnitMission(type: .moveTo, at: neighbor), in: gameModel)
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    private func findNearbyTarget(for unit: AbstractUnit?, in range: Int, of type: TacticalTargetType = .none, noLikeUnit: AbstractUnit? = nil, in gameModel: GameModel?) -> HexPoint? {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        var bestMovePlot: HexPoint? = nil
        var bestValue: Int = Int.max

        // Loop through all appropriate targets to find the closest
        for zoneTarget in self.zoneTargets {
            
            // Is the target of an appropriate type?
            var typeMatch = false
            
            if type == .none {
                
                if zoneTarget.targetType == .highPriorityUnit || zoneTarget.targetType == .mediumPriorityUnit || zoneTarget.targetType == .lowPriorityUnit || zoneTarget.targetType == .city || zoneTarget.targetType == .improvement {
                    
                    typeMatch = true
                }
            }
            else if zoneTarget.targetType == type {
                
                typeMatch = true
            }

            // Is this unit near enough?
            if typeMatch {
                
                if let tile = gameModel.tile(at: zoneTarget.target), let unitTile = gameModel.tile(at: unit.location) {
                    
                    let distance = tile.point.distance(to: unit.location)
                    
                    if distance == 0 {
                        return tile.point
                    } else if distance < range {
                        
                        if unitTile.area == tile.area {
                            
                            let unitAtTile = gameModel.unit(at: tile.point)
                            if noLikeUnit != nil || (unitAtTile != nil && unitAtTile!.hasSameType(as: noLikeUnit)) {
                                
                                let value = unit.turnsToReach(at: tile.point, in: gameModel)

                                if value < bestValue {
                                    bestMovePlot = tile.point
                                    bestValue = value
                                }
                            }
                        }
                    }
                }
            }
        }

        return bestMovePlot
    }
    
    /// Fills m_CurrentMoveUnits with all units within X turns of a target (returns TRUE if 1 or more found)
    func findClosestUnit(towards target: AbstractTile?, numTurnsAway: Int, mustHaveHalfHP: Bool, mustBeRangedUnit: Bool, rangeRequired: Int, needsIgnoreLineOfSight: Bool, mustBeMeleeUnit: Bool, ignoreUnits: Bool, rangedAttackTarget: AbstractTile?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        var rtnValue = false;
        self.currentMoveUnits.removeAll()

        // Loop through all units available to tactical AI this turn
        for currentTurnUnit in self.currentTurnUnits {
            
            guard let loopUnit = currentTurnUnit else {
                continue
            }

            var validUnit = true

            // don't use non-combat units (but consider embarked for now)
            if !loopUnit.isCombatUnit() {
                validUnit = false
            } else if mustHaveHalfHP && loopUnit.damage() * 2 > 100 {
                validUnit = false
            } else if mustBeRangedUnit && ((target.isWater() && loopUnit.domain() == .land) ||
                                            (!target.isWater() && gameModel.city(at: target.point) == nil && loopUnit.domain() == .sea)) {
                validUnit = false
            } else if mustBeRangedUnit && !loopUnit.canAttackRanged() {
                validUnit = false
            } else if mustBeRangedUnit && loopUnit.range() < rangeRequired {
                validUnit = false
            } else if mustBeRangedUnit && !loopUnit.canAttackRanged()  {
                validUnit = false
            } else if mustBeRangedUnit && loopUnit.isOutOfAttacks() {
                validUnit = false
            } else if rangedAttackTarget != nil && mustBeRangedUnit && !self.isExpectedToDamageWithRangedAttack(by: loopUnit, towards: rangedAttackTarget!.point, in: gameModel) {
                validUnit = false
            } else if needsIgnoreLineOfSight && !loopUnit.isRangeAttackIgnoreLineOfSight() {
                validUnit = false
            } else if mustBeMeleeUnit && loopUnit.canAttackRanged() {
                validUnit = false
            }

            let distance = loopUnit.location.distance(to: target.point)
            
            if numTurnsAway == 0 && distance > (TacticalAI.recruitRange / 2) || numTurnsAway == 1 && distance > TacticalAI.recruitRange {
                validUnit = false
            }

            if validUnit {
                
                let turns = loopUnit.turnsToReach(at: target.point /*, ignoreUnits, (iNumTurnsAway==0)*/, in: gameModel)
                
                if turns <= numTurnsAway {
                    let tacticalUnit = TacticalUnit(unit: loopUnit, attackStrength: 1000 - turns, healthPercent: 100)
                    tacticalUnit.movesToTarget = distance
                    self.currentMoveUnits.append(tacticalUnit)
                    
                    rtnValue = true
                }
            }
        }

        // Now sort them by turns to reach
        self.currentMoveUnits.sort(by: { $0!.movesToTarget < $1!.movesToTarget })

        return rtnValue
    }
    
    /// Moved endangered units to safe hexes
    private func plotMovesToSafety(combatUnits: Bool, in gameModel: GameModel?) {
    
        guard let dangerPlotsAI = self.player?.dangerPlotsAI else {
            fatalError("cant get dangerPlotsAI")
        }
        
        self.currentMoveUnits.removeAll()

        // Loop through all recruited units
        for currentUnitRef in self.currentTurnUnits {
            
            if let currentUnit = currentUnitRef {
            
                let dangerLevel = dangerPlotsAI.danger(at: currentUnit.location)
                
                // Danger value of plot must be greater than 0
                if dangerLevel > 0 {
                
                    var addUnit = false
                    if combatUnits {
                        
                        // If under 100% health, might flee to safety
                        if currentUnit.damage() > 0 {
                            
                            if currentUnit.player?.leader == .barbar {
                                
                                // Barbarian combat units - only naval units flee (but they flee if have taken ANY damage)
                                if currentUnit.domain() == .sea {
                                    addUnit = true
                                }
                            }

                            // Everyone else flees at less than or equal to 50% combat strength
                            else if currentUnit.damage() > 50 {
                                addUnit = true
                            }
                        }

                        // Also flee if danger is really high in current plot (but not if we're barbarian)
                        else if currentUnit.player?.leader != .barbar {
                            
                            let acceptableDanger = currentUnit.baseCombatStrength(ignoreEmbarked: true) * 100
                            if Int(dangerLevel) > acceptableDanger {
                                addUnit = true
                            }
                        }
                        
                    } else {
                        
                        // Civilian (or embarked) units always flee from danger
                        if !currentUnit.canFortify(at: currentUnit.location, in: gameModel) {
                            addUnit = true
                        }
                    }

                    if addUnit {
                        // Just one unit involved in this move to execute
                        let tacticalUnit: TacticalUnit = TacticalUnit()
                        tacticalUnit.unit = currentUnitRef
                        self.currentMoveUnits.append(tacticalUnit)
                    }
                }
            }
        }

        if self.currentMoveUnits.count > 0 {
            self.executeMovesToSafestPlot(in: gameModel)
        }
    }
    
    /// Moves units to the hex with the lowest danger
    func executeMovesToSafestPlot(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let dangerPlotsAI = player?.dangerPlotsAI else {
            fatalError("cant get gameModel")
        }
        
        for currentUnitRef in self.currentTurnUnits {
            
            if let currentUnit = currentUnitRef {
                
                let range = currentUnit.moves()
                
                var lowestDanger = Double.greatestFiniteMagnitude
                var bestPlot: HexPoint? = nil

                var resultHasZeroDangerMove = false
                var resultInTerritory = false
                var resultInCity = false
                var resultInCover = false
                
                // For each plot within movement range of the fleeing unit
                for neighbor in currentUnit.location.areaWith(radius: range) {
                    
                    if !gameModel.valid(point: neighbor) {
                        continue
                    }
                    
                    // Can't be a plot with another player's unit in it or another of our unit of same type
                    if let otherUnit = gameModel.unit(at: neighbor) {
                        
                        if otherUnit.player?.leader == currentUnit.player?.leader {
                            continue
                        } else if currentUnit.hasSameType(as: otherUnit) {
                            continue
                        }
                    }
                    
                    if !currentUnit.canReach(at: neighbor, in: 1, in: gameModel) {
                        continue
                    }
                    
                    //   prefer being in a city with the lowest danger value
                    //   prefer being in a plot with no danger value
                    //   prefer being under a unit with the lowest danger value
                    //   prefer being in your own territory with the lowest danger value
                    //   prefer the lowest danger value
                    
                    let danger = dangerPlotsAI.danger(at: neighbor)
                    let isZeroDanger = danger <= 0.0
                    let city = gameModel.city(at: neighbor)
                    let isInCity = city != nil ? city!.player?.leader == self.player?.leader : false
                    let unit = gameModel.unit(at: neighbor)
                    let isInCover = unit != nil
                    let tile = gameModel.tile(at: neighbor)
                    let isInTerritory = tile != nil ? tile?.owner()?.leader == self.player?.leader : false

                    var updateBestValue = false
                    
                    if isInCity {
                        if !resultInCity || danger < lowestDanger {
                            updateBestValue = true
                        }
                    } else if isZeroDanger {
                        if !resultInCity {
                            if resultHasZeroDangerMove {
                                if isInTerritory && !resultInTerritory {
                                    updateBestValue = true
                                }
                            } else {
                                updateBestValue = true
                            }
                        }
                    } else if isInCover {
                        if !resultInCity && !resultHasZeroDangerMove {
                            if !resultInCover || danger < lowestDanger {
                                updateBestValue = true
                            }
                        }
                    } else if isInTerritory {
                        if !resultInCity && !resultInCover && !resultHasZeroDangerMove {
                            if !resultInTerritory || danger < lowestDanger {
                                updateBestValue = true
                            }
                        }
                    } else if !resultInCity && !resultInCover && !resultInTerritory && !resultHasZeroDangerMove {
                        
                        // if we have no good home, head to the lowest danger value
                        if danger < lowestDanger {
                            updateBestValue = true
                        }
                    }

                    if updateBestValue {
                        bestPlot = neighbor
                        lowestDanger = danger;

                        resultInTerritory = isInTerritory
                        resultInCity      = isInCity
                        resultInCover     = isInCover
                        resultHasZeroDangerMove = isZeroDanger
                    }
                }
                
                if let bestPlot = bestPlot {
                    
                    // Move to the lowest danger value found
                    currentUnit.push(mission: UnitMission(type: .moveTo, at: bestPlot), in: gameModel) // FIXME: , .ignoreDanger
                    currentUnit.finishMoves()
                    self.unitProcessed(unit: currentUnit, in: gameModel)
                    
                    print("Moving \(currentUnit) to safety, \(bestPlot)")
                }
            }
        }
    }
    
    /// Make a defensive move to garrison a city
    func plotGarrisonMoves(numTurnsAway: Int, mustAllowRangedAttack: Bool = false, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for targetRef in self.zoneTargets(for: .cityToDefend) {
            
            guard let target = targetRef else {
                continue
            }
            
            guard let tile = gameModel.tile(at: target.target) else {
                continue
            }
            
            guard let city = gameModel.city(at: target.target) else {
                continue
            }

            if city.lastTurnGarrisonAssigned() < gameModel.currentTurn {
                
                // Grab units that make sense for this move type
                self.findUnitsFor(move: .garrisonAlreadyThere, target: tile, turnsAway: numTurnsAway, rangedOnly: mustAllowRangedAttack, in: gameModel)

                if self.currentMoveHighPriorityUnits.count + self.currentMoveUnits.count > 0 {
                    
                    self.executeMoveToTarget(target: target.target, garrisonIfPossible: true, in: gameModel)
                    city.setLastTurnGarrisonAssigned(turn: gameModel.currentTurn)
                }
            }
            
        }
    }
    
    /// Make a defensive move to guard an improvement
    func plotGuardImprovementMoves(numTurnsAway: Int, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        for targetRef in self.zoneTargets(for: .improvementToDefend) {
            
            // Grab units that make sense for this move type
            guard let target = targetRef else {
                continue
            }
            
            guard let tile = gameModel.tile(at: target.target) else {
                continue
            }
            
            self.findUnitsFor(move: .bastionAlreadyThere, target: tile, turnsAway: numTurnsAway, rangedOnly: false, in: gameModel)
            
            if self.currentMoveHighPriorityUnits.count + self.currentMoveUnits.count > 0 {
                
                self.executeMoveToTarget(target: target.target, garrisonIfPossible: false, in: gameModel)
                
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                    
                    print("Guard Improvement, \(target.target), Turns Away: \(numTurnsAway)")
                    //LogTacticalMessage(strLogString);
                }
            }
        }
    }
    
    // FIXME
    /// Set fighters to air sweep
    func plotAirSweepMoves(in gameModel: GameModel?) {
        
        //list<int>::iterator it;
        self.currentMoveUnits.removeAll()
        //CvTacticalUnit unit;
        //CvTacticalDominanceZone *pZone;

        // Loop through all recruited units
        for currentTurnUnit in self.currentTurnUnits {
            
            if let unit = currentTurnUnit {
            
                if unit.damage() * 2 < 100 { /* MAX_HIT_POINTS */

                    // Am I eligible to air sweep and have a target?
                    /*if unit.canAirSweep() && !m_pPlayer->GetMilitaryAI()->WillAirUnitRebase(pUnit.pointer()) && m_pPlayer->GetMilitaryAI()->GetBestAirSweepTarget(pUnit.pointer()) != NULL)
                    {
                        CvPlot* pUnitPlot = pUnit->plot();
                        CvCity* pCity = pUnitPlot->getPlotCity();
                        pZone = NULL;

                        // On a carrier or in a city where we are dominant?
                        if (pCity)
                        {
                            pZone = m_pMap->GetZoneByCity(pCity, false);
                        }
                        if (!pCity || !pZone || pZone->GetDominanceFlag() == TACTICAL_DOMINANCE_FRIENDLY)
                        {
                            unit.SetID(pUnit->GetID());
                            m_CurrentMoveUnits.push_back(unit);

                            if(GC.getLogging() && GC.getAILogging())
                            {
                                CvString strLogString;
                                strLogString.Format("Ready to air sweep enemy air units at, X: %d, Y: %d", pUnit->getX(), pUnit->getY());
                                LogTacticalMessage(strLogString);
                            }
                        }
                    }*/
                }
            }
        }

        if self.currentMoveUnits.count > 0 {
            // self.executeAirSweepMoves(in: gameModel)
        }
    }
    
    /// Set fighters to intercept
    func plotAirInterceptMoves(in gameModel: GameModel?) {
        
        /*list<int>::iterator it;
        m_CurrentMoveUnits.clear();
        CvTacticalUnit unit;
        CvTacticalDominanceZone *pZone;

        // Loop through all recruited units
        for(it = m_CurrentTurnUnits.begin(); it != m_CurrentTurnUnits.end(); it++)
        {
            UnitHandle pUnit = m_pPlayer->getUnit(*it);
            if(pUnit)
            {
                // Am I eligible to intercept?
                if(pUnit->canAirPatrol(NULL) && !m_pPlayer->GetMilitaryAI()->WillAirUnitRebase(pUnit.pointer()))
                {
                    CvPlot* pUnitPlot = pUnit->plot();
                    CvCity* pCity = pUnitPlot->getPlotCity();
                    pZone = NULL;

                    if (pCity)
                    {
                        pZone = m_pMap->GetZoneByCity(pCity, false);
                    }
                    int iNumNearbyBombers = m_pPlayer->GetMilitaryAI()->GetNumEnemyAirUnitsInRange(pUnitPlot, m_iRecruitRange, false/*bCountFighters*/, true/*bCountBombers*/);

                    // On a carrier or in a city where we are not dominant and near some enemy bombers?
                    if (!pCity || !pZone || pZone->GetDominanceFlag() != TACTICAL_DOMINANCE_FRIENDLY)
                    {
                        if (iNumNearbyBombers > 0)
                        {
                            unit.SetID(pUnit->GetID());
                            m_CurrentMoveUnits.push_back(unit);

                            if(GC.getLogging() && GC.getAILogging())
                            {
                                CvString strLogString;
                                strLogString.Format("Ready to intercept enemy air units at, X: %d, Y: %d", pUnit->getX(), pUnit->getY());
                                LogTacticalMessage(strLogString);
                            }
                        }
                    }
                }
            }
        }

        if(m_CurrentMoveUnits.size() > 0)
        {
            ExecuteAirInterceptMoves();
        }
         */
    }
    
    /// Close units in on primary target of this dominance zone
    func plotCloseOnTarget(checkDominance: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let zone = self.currentDominanceZone else {
            return
        }
        
        if checkDominance {
            if zone.dominanceFlag == .enemy {
                return
            }
        }
        
        // Flank attacks done; if in an enemy zone, close in on target
        if zone.territoryType == .tempZone {

            self.executeCloseOnTarget(target: TacticalTarget(targetType: .barbarianCamp, target: zone.center!.point, targetLeader: .barbar, dominanceZone: zone), zone: zone, in: gameModel)
            
        } else if zone.territoryType == .enemy && zone.closestCity != nil {
            
            let canSeeCity = gameModel.tile(at: zone.closestCity!.location)!.isVisible(to: self.player)

            // If we can't see the city, be careful advancing on it.  We want to be sure we're not heavily outnumbered
            if !canSeeCity || zone.friendlyStrength > (zone.enemyStrength / 2) {
 
                self.executeCloseOnTarget(target: TacticalTarget(targetType: .city, target: zone.closestCity!.location, targetLeader: zone.closestCity!.leader, dominanceZone: zone), zone: zone, in: gameModel)
            }
        }
    }
    
    /// Process units that we recruited out of operational moves.  Haven't used them, so let them go ahead with those moves
    func plotOperationalArmyMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let operations = self.player?.operations else {
            fatalError("cant get operations")
        }
        
        // Update all operations (moved down - previously was in the PlayerAI object)
        for operation in operations {
            
            if operation.lastTurnMoved() < gameModel.currentTurn {
                
                switch operation.moveType {
                
                case .none:
                    // NOOP
                break
                case .singleHex:
                    self.plotSingleHexOperationMoves(for: operation as? EscortedOperation, in: gameModel)
                case .enemyTerritory:
                    self.plotEnemyTerritoryOperationMoves(for: operation as? EnemyTerritoryOperation, in: gameModel)
                case .navalEscort:
                    self.plotNavalEscortOperationMoves(for: operation as? NavalEscortedOperation, in: gameModel)
                case .freeformNaval:
                    self.plotFreeformNavalOperationMoves(for: operation as? NavalOperation, in: gameModel)
                case .rebase:
                    // NOOP
                break
                }
                
                operation.set(lastTurnMoved: gameModel.currentTurn)
                operation.checkOnTarget(in: gameModel)
            }
        }

        var killedSomething: Bool = false
        
        repeat {
            killedSomething = false
            
            for operation in operations {
                
                if operation.doDelayedDeath(in: gameModel) {
                    killedSomething = true
                    break
                }
            }
            // hack
        } while killedSomething
    }
    
    /// Spend money to buy defenses
    func plotEmergencyPurchases(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        /*CvCity* pCity;
        UnitHandle pCityDefender;
        CvUnit* pUnit;*/

        // Is this a dominance zone where we're defending a city?
        if let zone = self.currentDominanceZone, let city = zone.closestCity {
            
            if player.isEqual(to: city.player) && zone.territoryType == .friendly && zone.enemyUnitCount > 0 {
                
                // this check is not valid for our capital
                if !city.isCapital() {
                    
                    // Make sure the city isn't about to fall.  Test by seeing if there are high priority unit targets
                    for zoneTarget in self.zoneTargets {
                         
                        if zoneTarget.targetType == .highPriorityUnit {
                            // Abandon hope for this city; save our money to use elsewhere
                            return
                        }
                    }
                }

                player.militaryAI?.buyEmergencyBuilding(in: city)

                // If two defenders, assume already have land and sea and skip this city
                // FIXME
                if gameModel.unit(at: city.location) == nil {
                    
                    var buyNavalUnit = false
                    var buyLandUnit = false

                    if let cityDefender = gameModel.unit(at: city.location) { // FIXME
                    
                        if cityDefender.domain() == .land {
                            if gameModel.isCoastal(at: city.location) {
                                buyNavalUnit = true
                            }
                        } else {
                            buyLandUnit = true
                        }
                    } else {
                        buyLandUnit = true
                        if gameModel.isCoastal(at: city.location) {
                            buyNavalUnit = true
                        }
                    }

                    if buyLandUnit {
                        
                        let unit = player.militaryAI?.buyEmergencyUnit(task: .cityBombard, in: city)
                        if unit == nil {
                            player.militaryAI?.buyEmergencyUnit(task: .ranged, in: city)
                        }
                    }

                    if buyNavalUnit {
                        
                        let unit = player.militaryAI?.buyEmergencyUnit(task: .attackSea, in: city)
                    
                        if unit == nil {
                            // Bought one, don't need to buy melee naval later
                            buyNavalUnit = false
                        }
                    }

                    // Always can try to buy air units
                    let unit = player.militaryAI?.buyEmergencyUnit(task: .attackAir, in: city)
                    
                    if unit == nil {
                        player.militaryAI?.buyEmergencyUnit(task: .defenseAir, in: city)
                    }
                }
            }
        }
    }
    
    /// Withdraw out of current dominance zone
    func plotWithdrawMoves(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let dangerPlotsAI = self.player?.dangerPlotsAI else {
            fatalError("cant get dangerPlotsAI")
        }
        
        self.currentMoveUnits.removeAll()
        //CvTacticalUnit unit;

        if let zone = self.currentDominanceZone {
            
            // Loop through all recruited units
            for currentTurnUnit in self.currentTurnUnits {
                
                if let unit = currentTurnUnit {
                    
                    // Proper domain of unit?
                    if zone.isWater && unit.domain() == .sea || !zone.isWater && unit.domain() == .land {
                        
                        guard let plot = gameModel.tacticalAnalysisMap().plots[unit.location] else {
                            continue
                        }
                        
                        // Am I in the current dominance zone?
                        if plot.dominanceZone == zone {
                            
                            self.currentMoveUnits.append(TacticalUnit(unit: unit))
                            
                        } else if let closestCity = zone.closestCity {
                            
                            // Or am I within tactical recruit range of center of zone and in danger and not in friendly territory?
                            if closestCity.location.distance(to: unit.location) <= TacticalAI.recruitRange {

                                guard let unitPlot = gameModel.tile(at: unit.location) else {
                                    continue
                                }
                                
                                if dangerPlotsAI.danger(at: unit.location) > 0 {
                                    if !unit.player!.isEqual(to: unitPlot.owner()) {
                                        self.currentMoveUnits.append(TacticalUnit(unit: unit))
                                    }
                                }
                            }
                        } else if zone.territoryType == .noOwner {
                            
                            // Or we are withdrawing from unowned lands zone and this is a plot in danger
                            guard let unitPlot = gameModel.tile(at: unit.location) else {
                                continue
                            }
                            
                            if dangerPlotsAI.danger(at: unit.location) > 0 {
                                if !unit.player!.isEqual(to: unitPlot.owner()) {
                                    self.currentMoveUnits.append(TacticalUnit(unit: unit))
                                }
                            }
                        }
                    }
                }
            }
        }

        if self.currentMoveUnits.count > 0 {
            self.executeWithdrawMoves(in: gameModel)
        }
    }
    
    /// Win an attrition campaign with bombardments
    func plotSitAndBombardMoves(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // Find primary target for zone (i.e. enemy city)
        let bestFriendlyRange = gameModel.tacticalAnalysisMap().bestFriendlyRange()
        let canIgnoreLightOfSight = gameModel.tacticalAnalysisMap().canIgnoreLightOfSight()

        if let zone = self.currentDominanceZone {
        
            if let closestCity = zone.closestCity {
                
                // Turn off moves we don't want to mix with this posture
                self.turnOffMove(type: .damageCity)

                let target = TacticalTarget(targetType: .city, target: closestCity.location, targetLeader: closestCity.leader, dominanceZone: zone)

                gameModel.tacticalAnalysisMap().clearDynamicFlags()
                gameModel.tacticalAnalysisMap().setTargetBombardCells(target: closestCity.location, bestFriendlyRange: bestFriendlyRange, canIgnoreLightOfSight: canIgnoreLightOfSight, in: gameModel)

                // Attack primary target (city)
                var attackUnderway = self.executeSafeBombards(on: target, in: gameModel)
                
                if target.isTargetStillAlive(for: self.player, in: gameModel) {
                    
                    var attackMade = self.plotCaptureCityMoves(in: gameModel)
                    if attackMade {
                        attackUnderway = true
                    }
                    
                    if target.isTargetStillAlive(for: self.player, in: gameModel) {
                        
                        attackMade = self.executeProtectedBombards(on: target, attackUnderway: &attackUnderway, in: gameModel)
                        
                        if attackMade {
                            attackUnderway = true
                        }
                        
                        if target.isTargetStillAlive(for: self.player, in: gameModel) {
                            self.plotCaptureCityMoves(in: gameModel)
                        }
                    }
                }

                // Attack ancillary target (nearby units)
                for zoneTarget in self.zoneTargets {
                    
                    // Is the target of an appropriate type?
                    if zoneTarget.targetType == .highPriorityUnit ||
                        zoneTarget.targetType == .mediumPriorityUnit ||
                        zoneTarget.targetType == .lowPriorityUnit {
                        
                        if zoneTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                            
                            gameModel.tacticalAnalysisMap().clearDynamicFlags()
                            gameModel.tacticalAnalysisMap().setTargetBombardCells(target: closestCity.location, bestFriendlyRange: bestFriendlyRange, canIgnoreLightOfSight: canIgnoreLightOfSight, in: gameModel)

                            attackUnderway = self.executeSafeBombards(on: zoneTarget, in: gameModel)
                            if zoneTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                                self.executeProtectedBombards(on: zoneTarget, attackUnderway: &attackUnderway, in: gameModel)
                            }
                        }
                    }
                }

                self.plotCloseOnTarget(checkDominance: true, in: gameModel)
            }
        }
    }
    
    /// Disable a move (probably because it is incompatible with a posture chosen)
    func turnOffMove(type: TacticalMoveType) {

        for movePriorityItem in self.movePriorityList {
            
            if movePriorityItem.moveType == type {
                movePriorityItem.priority = -1
                return
            }
        }
    }
    
    /// Win an attrition campaign with bombardments
    func plotAttritFromRangeMoves(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var attackUnderway: Bool = false
        let bestFriendlyRange = gameModel.tacticalAnalysisMap().bestFriendlyRange()
        let canIgnoreLightOfSight = gameModel.tacticalAnalysisMap().canIgnoreLightOfSight()

        // Find unit targets
        for zoneTarget in self.zoneTargets {
            
            // Is the target of an appropriate type?
            if zoneTarget.targetType == .highPriorityUnit || zoneTarget.targetType == .mediumPriorityUnit || zoneTarget.targetType == .lowPriorityUnit {
                
                if zoneTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                    
                    gameModel.tacticalAnalysisMap().clearDynamicFlags()
                    gameModel.tacticalAnalysisMap().setTargetBombardCells(target:zoneTarget.target, bestFriendlyRange: bestFriendlyRange, canIgnoreLightOfSight: canIgnoreLightOfSight, in: gameModel)

                    attackUnderway = self.executeSafeBombards(on: zoneTarget, in: gameModel)
                    if zoneTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                        self.executeProtectedBombards(on: zoneTarget, attackUnderway: &attackUnderway, in: gameModel)
                    }
                }
            }
        }
    }
    
    /// Defeat enemy units by using our advantage in numbers
    func plotExploitFlanksMoves(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        //CvPlot* pTarget;
        var attackUnderway = false

        self.tempTargets.removeAll()

        // Loop through unit targets finding attack for this turn
        for var zoneTarget in self.zoneTargets {
            
            if zoneTarget.targetType == .highPriorityUnit || zoneTarget.targetType == .mediumPriorityUnit || zoneTarget.targetType == .lowPriorityUnit {
                
                gameModel.tacticalAnalysisMap().clearDynamicFlags()
                
                gameModel.tacticalAnalysisMap().setTargetFlankBonusCells(target: zoneTarget.tile, in: gameModel)

                let attackMade = self.executeFlankAttack(target: &zoneTarget, in: gameModel)
                if attackMade {
                    attackUnderway = true
                } else {
                    // No attack, see if we can set one up on this target later
                    self.tempTargets.append(zoneTarget)
                }
            }
        }
    }
    
    // We have more overall strength than enemy, defeat his army first
    func plotSteamrollMoves(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        self.tempTargets.removeAll()

        // Loop through unit targets finding advantageous attacks for this turn
        for var zoneTarget in self.zoneTargets {
            
            if zoneTarget.targetType == .highPriorityUnit || zoneTarget.targetType == .mediumPriorityUnit || zoneTarget.targetType == .lowPriorityUnit {
                
                if zoneTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                    self.executePriorityAttacks(on: &zoneTarget, in: gameModel)
                }
            }
        }

        // See if there are any other anti-unit attacks we can make.
        self.plotDestroyUnitMoves(for: .highPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
        self.plotDestroyUnitMoves(for: .mediumPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
        self.plotDestroyUnitMoves(for: .lowPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)

        // See if it is time to go after the city
        let attackMade = self.plotCaptureCityMoves(in: gameModel)

        self.plotDestroyUnitMoves(for: .highPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
        self.plotDestroyUnitMoves(for: .mediumPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
        self.plotDestroyUnitMoves(for: .lowPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: true, in: gameModel)

        if !attackMade {
            self.plotDamageCityMoves(in: gameModel)
        }

        self.plotCloseOnTarget(checkDominance: false, in: gameModel)
    }
    
    /// We should be strong enough to take out the city before the enemy can whittle us down with ranged attacks
    func plotSurgicalCityStrikeMoves(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var attackUnderway = false

        if let zone = self.currentDominanceZone, let closestCity = zone.closestCity {

            let target = TacticalTarget(targetType: .city,
                                        target: closestCity.location,
                                        targetLeader: closestCity.leader, dominanceZone: zone)
            
            attackUnderway = self.plotCaptureCityMoves(in: gameModel)

            // Any unit targets adjacent to city?
            for var zoneTarget in self.zoneTargets {
                
                if zoneTarget.targetType == .highPriorityUnit ||
                    zoneTarget.targetType == .mediumPriorityUnit ||
                    zoneTarget.targetType == .lowPriorityUnit {
                    
                    if zoneTarget.target.distance(to: target.target) == 1 {
                        
                        if zoneTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                            self.executePriorityAttacks(on: &zoneTarget, in: gameModel)
                        }
                    }
                }
            }

            if target.isTargetStillAlive(for: self.player, in: gameModel) {
                self.plotDamageCityMoves(in: gameModel)
            }

            // Take any other really good attacks we've set up
            self.plotDestroyUnitMoves(for: .highPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
            self.plotDestroyUnitMoves(for: .mediumPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
            self.plotDestroyUnitMoves(for: .lowPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)

            self.plotCloseOnTarget(checkDominance: false, in: gameModel)
        }
    }
    
    /// Build a defensive shell around this city
    func plotHedgehogMoves(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // Attack priority unit targets
        for var zoneTarget in self.zoneTargets {
            
            if zoneTarget.targetType == .highPriorityUnit ||
                zoneTarget.targetType == .mediumPriorityUnit {
                
                if zoneTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                    self.executePriorityAttacks(on: &zoneTarget, in: gameModel)
                }
            }
        }

        self.plotDestroyUnitMoves(for: .highPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
        self.plotDestroyUnitMoves(for: .mediumPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)

        // But after best attacks are exhausted, go right to playing defense
        let zone = self.currentDominanceZone
        if let closestCity = zone?.closestCity {
            
            let target = TacticalTarget(targetType: .city, target: closestCity.location, targetLeader: closestCity.leader, dominanceZone: zone)
            self.executeHedgehogDefense(target: target, zone: zone!, in: gameModel)
        }
    }
    
    /// Try to push back the invader
    func plotCounterAttackMoves(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // Attack priority unit targets
        for var zoneTarget in self.zoneTargets {
            
            if zoneTarget.targetType == .highPriorityUnit || zoneTarget.targetType == .mediumPriorityUnit {
                
                if zoneTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                    self.executePriorityAttacks(on: &zoneTarget, in: gameModel)
                }
            }
        }
        
        self.plotDestroyUnitMoves(for: .highPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
        self.plotDestroyUnitMoves(for: .mediumPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)

        // Now low priority targets
        for var zoneTarget in self.zoneTargets {
            
            if zoneTarget.targetType == .lowPriorityUnit {
                if zoneTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                    self.executePriorityAttacks(on: &zoneTarget, in: gameModel)
                }
            }
        }
        
        self.plotDestroyUnitMoves(for: .lowPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)

        // Now targets we can't destroy
        self.plotDestroyUnitMoves(for: .highPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
        self.plotDestroyUnitMoves(for: .mediumPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
        self.plotDestroyUnitMoves(for: .lowPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
    }
    
    /// Bombard any enemy targets we can get to on shore
    func plotShoreBombardmentMoves(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        let bestFriendlyRange = gameModel.tacticalAnalysisMap().bestFriendlyRange()
        let canIgnoreLightOfSight = gameModel.tacticalAnalysisMap().canIgnoreLightOfSight()

        for zoneTarget in self.zoneTargets {
            
            // Is the target of an appropriate type?
            if zoneTarget.targetType == .highPriorityUnit ||
                zoneTarget.targetType == .mediumPriorityUnit ||
                zoneTarget.targetType == .lowPriorityUnit {
                
                if zoneTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                    
                    gameModel.tacticalAnalysisMap().clearDynamicFlags()
                    gameModel.tacticalAnalysisMap().setTargetBombardCells(target: zoneTarget.target, bestFriendlyRange: bestFriendlyRange, canIgnoreLightOfSight: canIgnoreLightOfSight, in: gameModel)

                    self.executeSafeBombards(on: zoneTarget, in: gameModel)
                }
            }
        }
    
        for zoneTarget in self.zoneTargets {
            
            if zoneTarget.targetType == .city {
                if zoneTarget.isTargetStillAlive(for: self.player, in: gameModel) {
                    
                    gameModel.tacticalAnalysisMap().clearDynamicFlags()
                    
                    gameModel.tacticalAnalysisMap().setTargetBombardCells(target: zoneTarget.target, bestFriendlyRange: bestFriendlyRange, canIgnoreLightOfSight: canIgnoreLightOfSight, in: gameModel)

                    self.executeSafeBombards(on: zoneTarget, in: gameModel)
                }
            }
        }
    }
    
    /// Deploy defensive forces around a friendly city
    func executeHedgehogDefense(target: TacticalTarget, zone: TacticalAnalysisMap.TacticalDominanceZone, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var rangedUnits = 0
        var meleeUnits = 0
        let tacticalRadius = gameModel.tacticalAnalysisMap().tacticalRange

        //pTargetPlot = GC.getMap().plot(kTarget.GetTargetX(), kTarget.GetTargetY());
        self.operationUnits.removeAll()
        self.generalsToMove.removeAll()

        for currentTurnUnit in self.currentTurnUnits {
            
            if let unit = currentTurnUnit {
                
                // Proper domain of unit?
                if zone.isWater && unit.domain() == .sea || !zone.isWater && unit.domain() == .land {
                    // Find units really close to target or somewhat close that just came out of an operation
                    let distance = unit.location.distance(to: target.target)
                    if distance <= tacticalRadius {

                        if unit.isGreatGeneral() {
                            if unit.moves() > 0 {
                                let operationUnit = OperationUnit(unit: unit)
                                operationUnit.position = .civilianSupport
                                self.generalsToMove.append(operationUnit)
                            }
                        } else if unit.canAttackRanged() {
                            let operationUnit = OperationUnit(unit: unit)
                            operationUnit.position = .bombard
                            self.operationUnits.append(operationUnit)
                            
                            rangedUnits += 1
                        } else {
                            let operationUnit = OperationUnit(unit: unit)
                            operationUnit.position = .frontline
                            meleeUnits += 1
                            self.operationUnits.append(operationUnit)
                        }
                    }
                }
            }
        }

        // If have any units to move...
        if self.operationUnits.count > 0 {
            
            self.scoreHedgehogPlots(of: target.tile, in: gameModel)

            // Compute the moves to get the best deployment
            self.tempTargets.sort()
            self.potentialBlocks.removeAll()

            var rangedUnitsToPlace = rangedUnits
            var meleeUnitsToPlace = meleeUnits

            // First loop for ranged unit spots
            var done = false
            for tempTarget in self.tempTargets {
                
                if done {
                    continue
                }
                
                if tempTarget.targetType == .highPriorityUnit {
                    
                    guard let loopPlot = gameModel.tile(at: tempTarget.target) else {
                        continue
                    }

                    if self.findClosestOperationUnit(target: loopPlot, safeForRanged: true, mustBeRangedUnit: true, in: gameModel) {
                        
                        for currentMoveUnit in self.currentMoveUnits {
                            let blockingUnit = BlockingUnit(unit: currentMoveUnit?.unit, at: tempTarget.target, numChoices: self.currentMoveUnits.count, distanceToTarget: currentMoveUnit!.movesToTarget)
                            self.potentialBlocks.append(blockingUnit)
                        }

                        rangedUnitsToPlace -= 1
                        if rangedUnitsToPlace == 0 {
                            done = true
                        }
                    }
                }
            }
            
            self.assignDeployingUnits(numUnitsRequiredToDeploy: rangedUnits - rangedUnitsToPlace, in: gameModel)
            self.performChosenMoves(in: gameModel)

            // Second loop for everyone else (including remaining ranged units)
            self.potentialBlocks.removeAll()
            meleeUnits += rangedUnitsToPlace
            meleeUnitsToPlace += rangedUnitsToPlace
            done = false
            
            for tempTarget in self.tempTargets {
                
                if done {
                    continue
                }
                
                if tempTarget.targetType == .highPriorityUnit {
                    
                    guard let loopPlot = gameModel.tile(at: tempTarget.target) else {
                        continue
                    }
                    
                    if self.findClosestOperationUnit(target: loopPlot, safeForRanged: true, mustBeRangedUnit: false, in: gameModel) {

                        for currentMoveUnit in self.currentMoveUnits {
                            let blockingUnit = BlockingUnit(unit: currentMoveUnit?.unit, at: tempTarget.target, numChoices: self.currentMoveUnits.count, distanceToTarget: currentMoveUnit!.movesToTarget)
                            self.potentialBlocks.append(blockingUnit)
                        }

                        meleeUnitsToPlace -= 1
                        if meleeUnitsToPlace == 0 {
                            done = true
                        }
                    }
                }
            }
            self.assignDeployingUnits(numUnitsRequiredToDeploy: meleeUnits - meleeUnitsToPlace, in: gameModel)
            self.performChosenMoves(in: gameModel)
        }

        if self.generalsToMove.count > 0 {
            self.moveGreatGeneral(army: nil, in: gameModel)
        }
    }
    
    /// Pick best hexes for defending a friendly city. Returns false if insufficient free plots.
    func scoreHedgehogPlots(of targetTile: AbstractTile?, in gameModel: GameModel?) {
        
        guard let targetTile = targetTile, let gameModel = gameModel, let player = self.player else {
            fatalError("cant get gameModel")
        }

        // We'll store the hexes we've found here
        self.tempTargets.removeAll()

        for cityPoint in targetTile.point.areaWith(radius: 3) {
            
            if cityPoint == targetTile.point {
                continue
            }
            
            guard let cityPlot = gameModel.tile(at: cityPoint) else {
                continue
            }

            var choiceBombardSpot = false
            var safeFromAttack = true

            let plotDistance = cityPoint.distance(to: targetTile.point)
            guard let cell = gameModel.tacticalAnalysisMap().plots[cityPoint] else {
                continue
            }

            if cell.canUseForOperationGatheringCheckWater(isWater: false) {
                
                var score = 600 - (plotDistance * 150)

                if cell.isSubjectToAttack() {
                    score += 100
                    safeFromAttack = false
                }
                
                if cell.isEnemyCanMovePast() {
                    score += 50
                }

                if cityPlot.isCity() && player.isEqual(to: cityPlot.owner()) {
                    score += 100
                } else {
                    score += cell.defenseModifier * 4
                }

                cell.safeDeployment = safeFromAttack
                cell.deploymentScore = score

                // Save this in our list of potential targets
                let target = TacticalTarget(targetType: .none, target: cityPoint)
                target.threatValue = score // or damage ?

                // A bit of a hack -- use high priority targets to indicate good plots for ranged units
                if safeFromAttack {
                    target.targetType = .highPriorityUnit
                } else {
                    target.targetType = .lowPriorityUnit
                }

                self.tempTargets.append(target)
            }
        }
    }
    
    /// Bombard and flank attacks (whatever is applicable) against a unit target
    func executePriorityAttacks(on target: inout TacticalTarget, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var attackUnderway = false
        var attackMade = false
        
        // Try to find a bombard first
        let bestFriendlyRange = gameModel.tacticalAnalysisMap().bestFriendlyRange()
        let canIgnoreLightOfSight = gameModel.tacticalAnalysisMap().canIgnoreLightOfSight()
        gameModel.tacticalAnalysisMap().clearDynamicFlags()
        gameModel.tacticalAnalysisMap().setTargetBombardCells(target: target.target, bestFriendlyRange: bestFriendlyRange, canIgnoreLightOfSight: canIgnoreLightOfSight, in: gameModel)

        if target.isTargetStillAlive(for: self.player, in: gameModel) {
            attackUnderway = self.executeSafeBombards(on: target, in: gameModel)
        }

        if target.isTargetStillAlive(for: self.player, in: gameModel) {
            self.executeProtectedBombards(on: target, attackUnderway: &attackUnderway, in: gameModel)
        }

        // Then try for a flank attack
        if target.isTargetStillAlive(for: self.player, in: gameModel) {
            
            gameModel.tacticalAnalysisMap().clearDynamicFlags()
            gameModel.tacticalAnalysisMap().setTargetFlankBonusCells(target: target.tile, in: gameModel)

            attackMade = self.executeFlankAttack(target: &target, in: gameModel)
            if attackMade {
                attackUnderway = true
            }
        }
    }
    
    /// Take a multi-hex attack on an enemy unit this turn
    func executeFlankAttack(target: inout TacticalTarget, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var possibleFlankHexes: Int = 0

        // Count number of possible flank attack spaces around target
        for loopPoint in target.target.neighbors() {

            if let cell = gameModel.tacticalAnalysisMap().plots[loopPoint] {

                if cell.canUseToFlank {
                    possibleFlankHexes += 1
                }
            }
        }

        // If more than 1, find how many we can fill with units
        if possibleFlankHexes > 1 {
            
            var fillableHexes = 0
            var numAttackers = 0
            self.tempTargets.removeAll()
            
            for loopPoint in target.target.neighbors() {
  
                if let loopPlot = gameModel.tile(at: loopPoint) {
                    
                    guard let cell = gameModel.tacticalAnalysisMap().plots[loopPoint] else {
                        continue
                    }
                    
                    if cell.canUseToFlank {
                        
                        if self.findClosestUnit(towards: loopPlot, numTurnsAway: 0, mustHaveHalfHP: true, mustBeRangedUnit: false, rangeRequired: 0, needsIgnoreLineOfSight: false, mustBeMeleeUnit: true, ignoreUnits: false, rangedAttackTarget: nil, in: gameModel) {
                            
                            fillableHexes += 1
                            numAttackers += 1
                            target.target = loopPoint
                            self.tempTargets.append(target)
                        } else if self.findClosestUnit(towards: loopPlot, numTurnsAway: 1, mustHaveHalfHP: false, mustBeRangedUnit: false, rangeRequired: 0, needsIgnoreLineOfSight: false, mustBeMeleeUnit: true, ignoreUnits: false, rangedAttackTarget: nil, in: gameModel) {
                            
                            // What about next turn?
                            fillableHexes += 1
                            target.target = loopPoint
                            self.tempTargets.append(target)
                        }
                    }
                }
            }

            // As long as we either get three hexes filled with one attacker, or two we can attack from, then this multi-hex attack is worth considering
            if (numAttackers >= 1 && fillableHexes >= 3) || numAttackers >= 2 {
                
                // Compute best way to fill the hexes
                self.potentialBlocks.removeAll()
                for tempTarget in self.tempTargets {
                    
                    guard let loopPlot = gameModel.tile(at: tempTarget.target) else {
                        continue
                    }
                    
                    if !self.findClosestUnit(towards: loopPlot, numTurnsAway: 1, mustHaveHalfHP: false, mustBeRangedUnit: false, rangeRequired: 0, needsIgnoreLineOfSight: false, mustBeMeleeUnit: true, ignoreUnits: false, rangedAttackTarget: nil, in: gameModel) {
                        
                        fillableHexes -= 1
                        if fillableHexes < 2 {
                            return false
                        }
                    } else {
                        // Save off the units that could get here
                        for currentMoveUnit in self.currentMoveUnits {

                            self.potentialBlocks.append(BlockingUnit(unit: currentMoveUnit?.unit, at: tempTarget.target, numChoices: self.currentMoveUnits.count, distanceToTarget: currentMoveUnit!.movesToTarget))
                        }
                    }
                }

                if self.assignFlankingUnits(numUnitsRequiredToFlank: fillableHexes) {
                    
                    // Make moves up into hexes
                    for chosenBlock in self.chosenBlocks {
                        
                        if let unit = chosenBlock?.unit {
                            
                            if unit.location == chosenBlock?.point {
                                
                                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                    
                                    print("Already in a flanking position with \(unit.name()), at: \(chosenBlock!.point)")
                                    // LogTacticalMessage(strMsg, false);
                                }
                            } else {
                                unit.push(mission: UnitMission(type: .moveTo, at: chosenBlock!.point), in: gameModel)
                                
                                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                    
                                    print("Moving into a flanking position with \(unit.name()), at: \(chosenBlock!.point)")
                                    // LogTacticalMessage(strMsg, false);
                                }

                                if unit.moves() <= 0 {
                                    self.unitProcessed(unit: unit, in: gameModel)
                                }
                            }
                        }
                    }

                    // Make attacks
                    if let defender = gameModel.visibleEnemy(at: target.target, for: self.player) {
                        
                        target.damage = defender.attackStrength(against: nil, or: nil, on: nil, in: gameModel)
                        self.currentMoveCities.removeAll()
                        
                        if self.findUnitsWithinStrikingDistance(towards: target.target, numTurnsAway: 1, noRangedUnits: false, in: gameModel) {
                            
                            guard let targetPlot = gameModel.tile(at: target.target) else {
                                fatalError("cant get targetPlot")
                            }
                            self.computeTotalExpectedDamage(target: target, and: targetPlot, in: gameModel)
                            self.executeAttack(target: target, targetPlot: targetPlot, inflictWhatWeTake: false, mustSurviveAttack: true, in: gameModel)
                        }
                    }
                }
            }
        }

        return false
    }
    
    /// Uses information from m_PotentialBlocks to make final assignments to put flanking unit around a target
    func assignFlankingUnits(numUnitsRequiredToFlank: Int) -> Bool {
        
        self.temporaryBlocks.removeAll()
        self.chosenBlocks.removeAll()

        return self.chooseRemainingAssignments(numUnitsDesired: numUnitsRequiredToFlank, numUnitsAcceptable: 2)
    }
    
    /// Bombard an enemy target from plots we can protect from enemy attack (return true if some attack made)
    @discardableResult
    func executeProtectedBombards(on target: TacticalTarget, attackUnderway: inout Bool, in gameModel: GameModel?) -> Bool {
        
        var attackMade = true
        var atLeastOneAttackInitiated = false

        while attackMade && target.isTargetStillAlive(for: self.player, in: gameModel) {
            
            attackMade = self.executeOneProtectedBombard(on: target, in: gameModel)
            if attackMade {
                attackUnderway = true
                atLeastOneAttackInitiated = true
            }
        }
        
        return atLeastOneAttackInitiated
    }
    
    /// Bombard an enemy target from a single plot we can protect from enemy attack (return true if some attack made)
    func executeOneProtectedBombard(on target: TacticalTarget, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var firstAttacker: AbstractUnit? = nil
        var numUnitsRequiredToCover: Int = 0

        guard let targetPlot = gameModel.tile(at:  target.target) else {
            fatalError("cant get targetPlot")
        }
        
        if self.plotAlreadyTargeted(point: target.target) != -1 {
            return false
        }

        
        if let city = gameModel.city(at: target.target) {
            
            let requiredDamage = city.maxHealthPoints() - city.damage()

            // Can't eliminate a city with ranged fire, so don't target one if that low on health
            if requiredDamage <= 1 {
                return false
            }
        }

        let range = gameModel.tacticalAnalysisMap().bestFriendlyRange()
        self.tempTargets.removeAll()

        // Build a list of all plots that have LOS to target where no enemy unit is adjacent
        for point in target.target.areaWith(radius: range) {
            
            if let attackPlot = gameModel.tile(at: point) {
                
                let plotDistance = point.distance(to: target.target)
                if plotDistance > 0 && plotDistance <= range {
                    
                    //iPlotIndex = GC.getMap().plotNum(pAttackPlot->getX(), pAttackPlot->getY());
                    guard let cell = gameModel.tacticalAnalysisMap().plots[point] else {
                        continue
                    }
                    
                    if cell.isRevealed() && cell.canUseForOperationGathering() {
                        
                        if cell.isWithinRangeOfTarget() {
                            
                            // Check for adjacent enemy unit
                            var noEnemyAdjacent = true
                            
                            for neighbor in point.neighbors() {
                                
                                if !noEnemyAdjacent {
                                    continue
                                }
                                
                                if gameModel.tacticalAnalysisMap().plots[neighbor]?.enemyMilitaryUnit != nil {
                                    noEnemyAdjacent = false
                                }
                            }

                            if noEnemyAdjacent {
                                // Do we have a unit that can get off a bombard from here THIS turn
                                var numTurns = -1
                                var haveLineOfSight = attackPlot.canSee(tile: targetPlot, for: self.player, range: range, in: gameModel)
                                
                                if self.findClosestUnit(towards: attackPlot, numTurnsAway: 0, mustHaveHalfHP: false, mustBeRangedUnit: true, rangeRequired: plotDistance, needsIgnoreLineOfSight: !haveLineOfSight, mustBeMeleeUnit: false, ignoreUnits: false, rangedAttackTarget: targetPlot, in: gameModel) {
                                    
                                    numTurns = 0
                                }
                                // What about next turn?
                                else if self.findClosestUnit(towards: attackPlot, numTurnsAway: 1, mustHaveHalfHP: false, mustBeRangedUnit: true, rangeRequired: plotDistance, needsIgnoreLineOfSight: !haveLineOfSight, mustBeMeleeUnit: false, ignoreUnits: false,  rangedAttackTarget: targetPlot, in: gameModel) {
                                    
                                    numTurns = 1
                                }

                                // If found a unit that could get here, see if we can cover the hex from enemy attack
                                if numTurns >= 0 {
                                    
                                    if self.canCoverFromEnemy(plot: attackPlot, numUnitsRequiredToCover: &numUnitsRequiredToCover, attackingUnit: self.currentMoveUnits.first??.unit, in: gameModel) {
                                        
                                        let tacticalTarget = TacticalTarget(targetType: .none, target: point)

                                        // How desirable is this move?
                                        // Set up math so having to allocate 3 extra units to defend is worse than waiting a turn to attack
                                        var priority = 300 - (numTurns * 100)
                                        priority -= 40 * numUnitsRequiredToCover;
                                        tacticalTarget.threatValue = priority
                                        self.tempTargets.append(tacticalTarget);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }

        // No plots to shoot from?
        if self.tempTargets.count == 0 {
            return false
        }

        // Sort potential spots
        self.tempTargets.sort()

        // Have to rebuild blocking position info for this specific spot
        guard let attackPlot = gameModel.tile(at: self.tempTargets.first!.target) else {
            return false
        }
        
        let plotDistance = self.tempTargets.first!.target.distance(to: target.target)
        var haveLineOfSight = attackPlot.canSee(tile: targetPlot, for: self.player, range: range, in: gameModel)
        
        if self.findClosestUnit(towards: attackPlot, numTurnsAway: 0, mustHaveHalfHP: false, mustBeRangedUnit: true , rangeRequired: plotDistance, needsIgnoreLineOfSight: !haveLineOfSight, mustBeMeleeUnit: false,  ignoreUnits: false, rangedAttackTarget: targetPlot, in: gameModel) ||
            self.findClosestUnit(towards: attackPlot, numTurnsAway: 1, mustHaveHalfHP: false, mustBeRangedUnit: true, rangeRequired: plotDistance, needsIgnoreLineOfSight: !haveLineOfSight, mustBeMeleeUnit: false, ignoreUnits: false, rangedAttackTarget: targetPlot, in: gameModel) {
            
            let attackingUnit = self.currentMoveUnits.first??.unit
            
            if self.canCoverFromEnemy(plot: attackPlot, numUnitsRequiredToCover: &numUnitsRequiredToCover,attackingUnit:  attackingUnit, in: gameModel) {
                
                // Make each blocking move
                for chosenBlockRef in self.chosenBlocks {
                    
                    guard let chosenBlock = chosenBlockRef else {
                        continue
                    }
                    
                    if let chosenUnit = chosenBlock.unit {
                        
                        if chosenUnit.location != chosenBlock.point {
                            
                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                
                                print("Moving to cover a protected bombard with \(chosenUnit.name()), at: \(chosenBlock.point)")
                                // LogTacticalMessage(strMsg, false);
                            }
                            
                            chosenUnit.push(mission: UnitMission(type: .moveTo, at: chosenBlock.point), in: gameModel)
                            
                        } else if chosenUnit.canPillage(at: chosenUnit.location, in: gameModel) && chosenUnit.damage() > 0 {
                            
                            chosenUnit.push(mission: UnitMission(type: .pillage), in: gameModel)
                            
                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                
                                print("Pillaging during a protected bombard with \(chosenUnit.name()), at \(chosenBlock.point)")
                                // LogTacticalMessage(strMsg, false);
                            }
                            
                        } else if chosenUnit.canFortify(at: chosenUnit.location, in: gameModel) {
                            
                            chosenUnit.push(mission: UnitMission(type: .fortify), in: gameModel)
                            
                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                
                                print("Fortifying during a protected bombard with \(chosenUnit.name()), at \(chosenBlock.point)")
                                // LogTacticalMessage(strMsg, false);
                            }
                        } else {
                            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                                
                                print("Sitting during a protected bombard with \(chosenUnit.name()), at \(chosenBlock.point)")
                                // LogTacticalMessage(strMsg, false);
                            }
                        }
                        chosenUnit.finishMoves()
                        self.unitProcessed(unit: chosenUnit, in: gameModel)
                    }
                }

                // Then move the attacking unit
                
                if let unit = attackingUnit {
                    
                    if attackPlot.point != unit.location {
                        
                        unit.push(mission: UnitMission(type: .moveTo, at: attackPlot.point), in: gameModel)

                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                            
                            print("Moving closer for protected bombard with \(unit.name()), Target \(attackPlot.point), At \(unit.location)")
                            // LogTacticalMessage(strMsg, false);
                        }
                    }

                    self.unitProcessed(unit: attackingUnit, in: gameModel)

                    if unit.canSetUpForRangedAttack() {
                        
                        unit.set(setUpForRangedAttack: true)
                        
                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
  
                            print("Set up \(unit.name()) for ranged attack")
                            // LogTacticalMessage(strMsg, false);
                        }
                    }

                    if unit.canMove() && !unit.isOutOfAttacks() && unit.canRangeStrike(at: target.target, needWar: true, noncombatAllowed: true) {
                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                            
                            print("Making a protected bombard with \(unit.name()), Target \(target.target), At \(unit.location)")
                            // LogTacticalMessage(strMsg, false);
                        }

                        if self.queueAttack(attacker: unit, target: target, ranged: true) {
                            firstAttacker = unit
                        }
                    }
                }
            }

            if let firstAttacker = firstAttacker {
                self.launchAttack(for: firstAttacker, target: target, firstAttack: true, ranged: true, in: gameModel)
                return true
            }
        }

        return false
    }
    
    /// Do I have available friendly units that can stop this hex from being attacked?
    func canCoverFromEnemy(plot: AbstractTile?, numUnitsRequiredToCover: inout Int, attackingUnit: AbstractUnit?, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let plot = plot else {
            fatalError("cant get plot")
        }

        numUnitsRequiredToCover = 0

        // Can't melee attack at sea so those hexes are always covered
        if plot.isWater() {
            return true
        }

        // Find all the hexes we need to cover
        for neighbor in plot.point.neighbors() {
            
            guard let loopPlot = gameModel.tile(at: neighbor) else {
                continue
            }

            // Don't need to cover a water hex
            if !loopPlot.isWater() {
                //iPlotIndex = GC.getMap().plotNum(pLoopPlot->getX(), pLoopPlot->getY());
                
                guard let cell = gameModel.tacticalAnalysisMap().plots[neighbor] else {
                    continue
                }
                
                if cell.isEnemyCanMovePast() && !cell.isFriendlyTurnEndTile() {
                    numUnitsRequiredToCover += 1
                }
            }
        }

        if numUnitsRequiredToCover == 0 {
            self.chosenBlocks.removeAll()
            return true
        } else {
            if numUnitsRequiredToCover > self.currentTurnUnits.count {
                return false
            }

            // Have some unit that can cover each hex this turn?
            self.potentialBlocks.removeAll()
            
            for neighbor in plot.point.neighbors() {

                guard let loopPlot = gameModel.tile(at: neighbor) else {
                    continue
                }
                
                if !loopPlot.isWater() {
                    
                    guard let cell = gameModel.tacticalAnalysisMap().plots[neighbor] else {
                        continue
                    }
                    
                    if cell.isEnemyCanMovePast() && !cell.isFriendlyTurnEndTile() {
                        
                        if !self.findClosestUnit(towards: loopPlot, numTurnsAway: 1, mustHaveHalfHP: false, mustBeRangedUnit: false, rangeRequired: 2, needsIgnoreLineOfSight: false, mustBeMeleeUnit: true, ignoreUnits: false, rangedAttackTarget: nil, in: gameModel) {
                            
                            return false
                        } else {
                            // Save off the units that could get here
                            for currentMoveUnitRef in self.currentMoveUnits {
                                
                                guard let currentMoveUnit = currentMoveUnitRef?.unit else {
                                    continue
                                }
                                
                                if !currentMoveUnit.isEqual(to: attackingUnit) {

                                    self.potentialBlocks.append(BlockingUnit(unit: currentMoveUnit, at: neighbor, numChoices: self.currentMoveUnits.count, distanceToTarget: currentMoveUnitRef!.movesToTarget))
                                }
                            }
                        }
                    }
                }
            }
        }

        // Now select exact covering units, making sure we didn't over commit a unit to covering more than one hex
        return self.assignCoveringUnits(numUnitsRequiredToCover: numUnitsRequiredToCover)
    }
    
    /// Uses information from m_PotentialBlocks to make final assignments to block a hex (returns false if not possible)
    func assignCoveringUnits(numUnitsRequiredToCover: Int) -> Bool {
        
        var choseOne = true;

        self.temporaryBlocks.removeAll()
        self.chosenBlocks.removeAll()

        while choseOne {
            choseOne = false
            self.newlyChosen.removeAll()

            // Loop through potential blocks looking for assignments we MUST make (only one possibility)
            for potentialBlock in self.potentialBlocks {
                
                guard let temp = potentialBlock else {
                    continue
                }

                if temp.numChoices == 1 {
                    self.newlyChosen.append(temp)
                    choseOne = true
                }
            }

            if choseOne {
                // Do we have the same unit in m_NewlyChosen twice?
                if self.haveDuplicateUnit() {
                    return false   // Not going to work
                } else {
                    // Copy to final list
                    for newlyChosenitem in self.newlyChosen {
                        self.chosenBlocks.append(newlyChosenitem)
                    }

                    self.removeChosenUnits(startIndex: 0)

                    // Do we have enough units left to cover everything?
                    if self.numUniqueUnitsLeft() < (numUnitsRequiredToCover - self.chosenBlocks.count) {
                        return false
                    }
                }
            }
        }

        return self.chooseRemainingAssignments(numUnitsDesired: numUnitsRequiredToCover, numUnitsAcceptable: numUnitsRequiredToCover)
    }
    
    /// No clear cut blocking assignments left, have to make search possibilities and score most preferred
    func chooseRemainingAssignments(numUnitsDesired: Int, numUnitsAcceptable: Int) -> Bool {
        
        var bestScore = 0;
        var score = 0
        var current = [Int](repeating: 0, count: 6)
        var first = [Int](repeating: 0, count: 6)
        var last = [Int](repeating: 0, count: 6)

        let blocksToCreate = numUnitsDesired - self.chosenBlocks.count

        if blocksToCreate == 0  {
            return true
        }

        assert(blocksToCreate <= 6, "More than NUM_DIRECTION_TYPES hexes to block. Will cause array overflows and performance issues!");

        if blocksToCreate > 0 && blocksToCreate < 6 {
            
            self.newlyChosen.removeAll()

            // Set up indexes pointing to the possible choices
            var level = 0;
            var curIndex = 0
            
            while level < blocksToCreate {
                
                first[level] = curIndex;
                let numChoices = self.potentialBlocks[curIndex]!.numChoices

                assert(numChoices > 0, "Invalid number of tactical AI move choices. Will cause array overflows and performance issues!");
                assert(numChoices + curIndex <= self.potentialBlocks.count, "Invalid number of tactical AI move choices. Will cause array overflows and performance issues!");

                last[level] = curIndex + numChoices - 1
                curIndex = last[level] + 1
                level += 1
            }

            for iI in 0..<blocksToCreate {
                current[iI] = first[iI]
            }

            // Loop through each possibility
            var done = false
            while !done {
                
                self.temporaryBlocks.removeAll()

                // Create this choice
                for iI in 0..<blocksToCreate {
                    
                    if iI >= self.potentialBlocks.count {
                        fatalError("Invalid fast vector index - show Ed")
                    }
                    self.temporaryBlocks.append(self.potentialBlocks[current[iI]])
                }

                score = self.scoreAssignments(canLeaveOpenings: numUnitsDesired != numUnitsAcceptable)

                // If best so far, save it off
                if score > bestScore {
                    self.newlyChosen.removeAll()
                    for iI in 0..<self.temporaryBlocks.count {
                        if self.temporaryBlocks[iI]?.distanceToTarget != Int.max {
                            self.newlyChosen.append(self.temporaryBlocks[iI])
                        }
                    }
                    bestScore = score
                }

                // Increment proper index
                var incrementDone = false
                
                for levelIndex in (blocksToCreate - 1)...0 {
                    
                    // See if at end of line for this index
                    if current[levelIndex] + 1 > last[levelIndex] {
                        // Reset to first one and keep iterating
                        current[levelIndex] = first[levelIndex]
                    } else {
                        current[levelIndex] += 1
                        incrementDone = true
                    }
                }

                if !incrementDone {
                    done = true
                }
            }

            // Copy final choices into output
            for iI in 0..<self.newlyChosen.count {
                self.chosenBlocks.append(self.newlyChosen[iI])
            }

            return self.chosenBlocks.count >= numUnitsAcceptable
        }

        return false
    }
    
    /// Score for this set of chosen blocks in m_TemporaryBlocks (-1 if illegal)
    func scoreAssignments(canLeaveOpenings: Bool) -> Int {
        
        var score = 0

        // Any assignment appear twice?
        for iI in 0..<self.temporaryBlocks.count {
            
            for jJ in (iI + 1)..<self.temporaryBlocks.count {
                
                guard let unit1 = self.temporaryBlocks[iI]?.unit else {
                    continue
                }
                
                if unit1.isEqual(to: self.temporaryBlocks[jJ]?.unit) {
                    
                    if !canLeaveOpenings {
                        return -1
                    } else {
                        // "Clear" the move with greater distance by setting it to MAX_INT distance
                        if self.temporaryBlocks[iI]!.distanceToTarget < self.temporaryBlocks[jJ]!.distanceToTarget {
                            self.temporaryBlocks[jJ]?.distanceToTarget = Int.max
                        } else {
                            self.temporaryBlocks[iI]?.distanceToTarget = Int.max
                        }
                    }
                }
            }
        }

        // Legal, so let's score it
        for iI in 0..<self.temporaryBlocks.count {
            
            if self.temporaryBlocks[iI]!.distanceToTarget != Int.max {
                score += (10000 - (self.temporaryBlocks[iI]!.distanceToTarget * 1000))
                score += self.temporaryBlocks[iI]!.unit!.power()
            }
        }

        return score
    }
    
    /// Move units out of current dominance zone
    func executeWithdrawMoves(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }

        for currentMoveUnit in self.currentMoveUnits {
            
            if let unit = currentMoveUnit?.unit {
                
                // Compute moves to nearest city and use as sort criteria
                if let nearestCity = gameModel.findCity(of: player, closestTo: unit.location) {
                    
                    let turnsToReachTarget = unit.turnsToReach(at: nearestCity.location, in: gameModel)
                    currentMoveUnit?.movesToTarget = turnsToReachTarget
                    currentMoveUnit?.attackStrength = 1000 - turnsToReachTarget
                    currentMoveUnit?.healthPercent = 100
                }
            }
        }

        // Sort units by distance to city so closest ones move first
        self.currentMoveUnits.sort(by: { $0!.movesToTarget < $1!.movesToTarget })

        // Execute the moves
        for currentMoveUnit in self.currentMoveUnits {
            
            if let unit = currentMoveUnit?.unit {
                
                // Compute moves to nearest city and use as sort criteria
                if let nearestCity = gameModel.findCity(of: player, closestTo: unit.location) {
                    
                    self.moveToEmptySpaceNearTarget(unit: unit, target: nearestCity.location, land: (unit.domain() == .land), in: gameModel)

                    unit.finishMoves()
                    self.unitProcessed(unit: unit, markTacticalMap: unit.isCombatUnit(), in: gameModel)

                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        
                        print("\(unit.name()) withdrew toward \(nearestCity.name), Current \(unit.location)")
                        // LogTacticalMessage(strLogString, false);
                    }
                }
            }
        }
    }
    
    /// Move forces in toward our target
    func executeCloseOnTarget(target: TacticalTarget, zone: TacticalAnalysisMap.TacticalDominanceZone, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var rangedUnits = 0
        var meleeUnits = 0
        var generals = 0
        
        let tacticalRadius = gameModel.tacticalAnalysisMap().tacticalRange
        
        self.operationUnits.removeAll()
        self.generalsToMove.removeAll()

        for currentTurnUnit in self.currentTurnUnits {
            
            if let unit = currentTurnUnit {
                
                // If not naval invasion, proper domain of unit?
                if zone.navalInvasion ||
                    (zone.isWater && unit.domain() == .sea || !zone.isWater && unit.domain() == .land) {
                    
                    // Find units really close to target or somewhat close that just came out of an operation
                    let distance = unit.location.distance(to: target.target)
                    if distance <= tacticalRadius || (distance <= (4 /* AI_OPERATIONAL_CITY_ATTACK_DEPLOY_RANGE */ * 3) && unit.deployFromOperationTurn() + 5 /* AI_TACTICAL_MAP_TEMP_ZONE_TURNS */ >= gameModel.currentTurn) {
                        
                        let operationUnit = OperationUnit(unit: unit)

                        if unit.canAttackRanged() {
                            operationUnit.position = .bombard
                            rangedUnits += 1
                            self.operationUnits.append(operationUnit)

                        } else if unit.isGreatGeneral() || unit.isGreatAdmiral() {
                            
                            operationUnit.position = .civilianSupport
                            generals += 1
                            self.generalsToMove.append(operationUnit)
                        } else {
                            
                            operationUnit.position = .frontline
                            meleeUnits += 1
                            self.operationUnits.append(operationUnit)
                        }
                    }
                }
            }
        }

        // If have any units to move...
        if self.operationUnits.count > 0 {
            
            /* Land only unless invasion or no enemy naval presence */
            var landOnly = true
            if zone.navalInvasion || zone.enemyNavalUnitCount == 0 {
                landOnly = false
            }
            
            self.scoreCloseOnPlots(target: target.target, landOnly: landOnly, in: gameModel)

            // Compute the moves to get the best deployment
            self.tempTargets.sort()
            self.potentialBlocks.removeAll()

            var rangedUnitsToPlace = rangedUnits
            var meleeUnitsToPlace = meleeUnits

            // First loop for ranged unit spots
            var done = false
            for tempTarget in self.tempTargets {
                
                if done {
                    continue
                }

                if tempTarget.targetType == .highPriorityUnit {
                    
                    guard let loopPlot = gameModel.tile(at: tempTarget.target) else {
                        continue
                    }
                    
                    if self.findClosestOperationUnit(target: loopPlot, safeForRanged: true, mustBeRangedUnit: true, in: gameModel) {
                        
                        for currentMoveUnit in self.currentMoveUnits {

                            self.potentialBlocks.append(BlockingUnit(unit: currentMoveUnit?.unit, at: loopPlot.point, numChoices: self.currentMoveUnits.count, distanceToTarget: currentMoveUnit!.movesToTarget))
                        }

                        rangedUnitsToPlace -= 1
                        if rangedUnitsToPlace == 0 {
                            done = true
                        }
                    }
                }
            }
            
            self.assignDeployingUnits(numUnitsRequiredToDeploy: rangedUnits - rangedUnitsToPlace, in: gameModel)
            self.performChosenMoves(in: gameModel)

            // Second loop for everyone else (including remaining ranged units)
            self.potentialBlocks.removeAll()
            meleeUnits += rangedUnitsToPlace
            meleeUnitsToPlace += rangedUnitsToPlace
            done = false
            
            for tempTarget in self.tempTargets {
                
                if done {
                    continue
                }
                
                if tempTarget.targetType == .highPriorityUnit {
                    
                    guard let loopPlot = gameModel.tile(at: tempTarget.target) else {
                        continue
                    }
                    
                    if self.findClosestOperationUnit(target: loopPlot, safeForRanged: true, mustBeRangedUnit: false, in: gameModel) {
                        
                        for currentMoveUnit in self.currentMoveUnits {

                            self.potentialBlocks.append(BlockingUnit(unit: currentMoveUnit?.unit, at: loopPlot.point, numChoices: self.currentMoveUnits.count, distanceToTarget: currentMoveUnit!.movesToTarget))
                        }

                        meleeUnitsToPlace -= 1
                        if meleeUnitsToPlace == 0 {
                            done = true
                        }
                    }
                }
            }
            
            self.assignDeployingUnits(numUnitsRequiredToDeploy: meleeUnits - meleeUnitsToPlace, in: gameModel)
            self.performChosenMoves(in: gameModel)
        }

        if self.generalsToMove.count > 0 {
            self.moveGreatGeneral(army: nil, in: gameModel)
        }
    }
    
    /// Pick best hexes for closing in on an enemy city. Returns number of ranged unit plots found
    @discardableResult
    func scoreCloseOnPlots(target: HexPoint, landOnly: Bool, in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        var score = 0
        var choiceBombardSpot: Bool = false
        var safeFromAttack: Bool = false
        /*CvPlot* pPlot;
        CvTacticalAnalysisCell* pCell;
        CvTacticalTarget target;*/
        var rtnValue = 0

        // We'll store the hexes we've found here
        self.tempTargets.removeAll()

        for plotPoint in target.areaWith(radius: 3) {
            
            choiceBombardSpot = false
            safeFromAttack = true

            let plotDistance = plotPoint.distance(to: target)
            
            guard let cell = gameModel.tacticalAnalysisMap().plots[plotPoint] else {
                continue
            }

            if (landOnly && cell.canUseForOperationGatheringCheckWater(isWater: false)) || (!landOnly && cell.canUseForOperationGathering()) {
                
                var closeEnough = false
                
                for operationUnit in self.operationUnits {
                    
                    if closeEnough {
                        continue
                    }
                    
                    if let unit = operationUnit.unit {
                        if unit.location.distance(to: plotPoint) <= TacticalAI.deployRadius {
                            closeEnough = true
                        }
                    }
                }

                if closeEnough {
                    
                    score = 600 - (plotDistance * 100)

                    // Top priority is hexes to bombard from (within range but not adjacent)
                    if cell.isWithinRangeOfTarget() && plotDistance > 1 {
                        choiceBombardSpot = true
                        rtnValue += 1
                    }

                    if cell.isSubjectToAttack() {
                        score -= 30
                        safeFromAttack = false
                    }

                    if cell.isEnemyCanMovePast() {
                        score -= 30
                    }
                    
                    guard let plot = gameModel.tile(at: plotPoint) else {
                        continue
                    }
                    
                    if gameModel.city(at: plotPoint) != nil && player.isEqual(to: plot.owner()) {
                        score += 100;
                    } else {
                        score += cell.defenseModifier
                    }

                    cell.safeDeployment = choiceBombardSpot || safeFromAttack
                    cell.deploymentScore = score

                    // Save this in our list of potential targets
                    let target = TacticalTarget(targetType: .none, target: plotPoint)
                    target.threatValue = score

                    // A bit of a hack -- use high priority targets to indicate good plots for ranged units
                    if choiceBombardSpot {
                        target.targetType = .highPriorityUnit
                    } else {
                        target.targetType = .lowPriorityUnit
                    }

                    self.tempTargets.append(target)
                }
            }
        }
        
        return rtnValue
    }
    
    /// Uses information from m_PotentialBlocks to make final assignments to put deploying unit on target
    @discardableResult
    func assignDeployingUnits(numUnitsRequiredToDeploy: Int, in gameModel: GameModel?) -> Bool {
        
        var choseOne = true
        var rtnValue = true

        self.temporaryBlocks.removeAll()
        self.chosenBlocks.removeAll()

        // Loop through potential blocks looking for assignments we MUST make (only one possibility)
        while choseOne {
            
            choseOne = false
            self.newlyChosen.removeAll()

            for potentialBlock in self.potentialBlocks {
                
                if potentialBlock?.numChoices == 1 {
                    
                    self.newlyChosen.append(potentialBlock)
                    choseOne = true
                }
            }

            if choseOne {
                // Do we have the same unit in m_NewlyChosen twice?
                if self.haveDuplicateUnit() {
                    return false   // Not going to work
                } else {
                    // Copy to final list
                    for newlyChosenItem in self.newlyChosen {
                        self.chosenBlocks.append(newlyChosenItem)
                    }

                    self.removeChosenUnits(startIndex: 0)

                    // Do we have enough units left to cover everything?
                    if self.numUniqueUnitsLeft() < (numUnitsRequiredToDeploy - self.chosenBlocks.count) {
                        return false
                    }
                }
            }
        }

        // Pick closest unit for highest priority assignment until all processed
        while let potentialBlock = self.potentialBlocks.first {
            
            choseOne = false
            self.newlyChosen.removeAll()

            self.newlyChosen.append(potentialBlock)
            self.chosenBlocks.append(potentialBlock)

            // Don't copy the other entries for this hex so pass in the number of choices here
            self.removeChosenUnits(startIndex: potentialBlock!.numChoices)

            // Do we have enough units left to cover everything?
            if self.numUniqueUnitsLeft() < (numUnitsRequiredToDeploy - self.chosenBlocks.count) {
                // Used to abort here, but better if we get the moves in we can
                rtnValue = false
            }
        }

        return rtnValue
    }
    
    /// How many units are left unassigned for a blocking position?
    func numUniqueUnitsLeft() -> Int {
        
        var rtnValue = 1

        if self.potentialBlocks.count < 2 {
            return self.potentialBlocks.count
        }

        // Copy data over and sort it so in unit ID order
        self.temporaryBlocks.removeAll()
        self.temporaryBlocks = self.potentialBlocks
        self.temporaryBlocks.sort { (aRef, bRef) -> Bool in
            return aRef!.distanceToTarget < bRef!.distanceToTarget
        }

        var current: AbstractUnit? = self.temporaryBlocks[0]?.unit
        
        for iI in 1..<self.temporaryBlocks.count {
            
            if !self.temporaryBlocks[iI]!.unit!.isEqual(to: current) {
                rtnValue += 1
                current = self.temporaryBlocks[iI]?.unit
            }
        }

        return rtnValue
    }
    
    /// Were we forced to select the same unit to block twice?
    func haveDuplicateUnit() -> Bool {
        
        for iI in 0..<(self.newlyChosen.count - 1) {
            
            for jJ in (iI + 1)..<self.newlyChosen.count {
            
                if self.newlyChosen[iI]!.unit!.isEqual(to: self.newlyChosen[jJ]!.unit) {
                    return true
                }
            }
        }
        
        return false
    }
    
    /// Pull the units we just assigned out of the list of potential assignments
    func removeChosenUnits(startIndex: Int) {
        
        self.temporaryBlocks.removeAll()
        self.temporaryBlocks = self.potentialBlocks
        self.potentialBlocks.removeAll()

        for iI in startIndex..<self.temporaryBlocks.count {
            
            var copyIt = true

            guard let blockingUnit = self.temporaryBlocks[iI] else {
                continue
            }

            // Loop through chosen array looking for occurrences of this unit
            for jJ in 0..<self.newlyChosen.count {
                
                if !copyIt {
                    continue
                }
                
                if blockingUnit.unit!.isEqual(to: self.newlyChosen[jJ]?.unit) {
                    copyIt = false
                }
            }

            if copyIt {
                self.potentialBlocks.append(blockingUnit)
            }
        }

        // Rebuild number of choices
        for iI in 0..<self.potentialBlocks.count {
            
            var numFound = 0
            
            guard let plot = self.potentialBlocks[iI]?.point else {
                continue
            }

            for jJ in 0..<self.potentialBlocks.count {
                
                if plot == self.potentialBlocks[jJ]?.point {
                    numFound += 1
                }
            }
            
            self.potentialBlocks[iI]?.numChoices = numFound
        }
    }
    
    /// Find one unit to move to target, starting with high priority list
    func executeMoveToTarget(target point: HexPoint, garrisonIfPossible: Bool, in gameModel: GameModel?) {
        
        // Start with high priority list
        for currentMoveHighPriorityUnit in self.currentMoveHighPriorityUnits {
            
            guard let currentMoveHighPriorityUnit = currentMoveHighPriorityUnit else {
                continue
            }
            
            guard let unit = currentMoveHighPriorityUnit.unit else {
                continue
            }
            
            // Don't move high priority unit, if regular priority unit is closer
            if let firstCurrentUnit = self.currentMoveUnits.first {
                if firstCurrentUnit!.movesToTarget < currentMoveHighPriorityUnit.movesToTarget {
                    break
                }
            }

            if unit.location == point && unit.canFortify(at: point, in: gameModel) {
                
                unit.push(mission: UnitMission(type: .fortify), in: gameModel)
                unit.doFortify(in: gameModel)
                self.unitProcessed(unit: unit, in: gameModel)
                return
                
            } else if garrisonIfPossible && unit.location == point && unit.canGarrison(at: point, in: gameModel) {
                
                unit.push(mission: UnitMission(type: .garrison), in: gameModel)
                unit.finishMoves()
                self.unitProcessed(unit: unit, in: gameModel)
                return
                
            } else if currentMoveHighPriorityUnit.movesToTarget < Int.max {
                
                unit.push(mission: UnitMission(type: .moveTo, at: point), in: gameModel)
                unit.finishMoves()
                self.unitProcessed(unit: unit, in: gameModel)
                return
            }
        }

        // Then regular priority
        for currentMoveUnit in self.currentMoveUnits {
            
            guard let currentMoveUnit = currentMoveUnit else {
                continue
            }
            
            guard let unit = currentMoveUnit.unit else {
                continue
            }

            if unit.location == point && unit.canFortify(at: unit.location, in: gameModel) {

                unit.push(mission: UnitMission(type: .fortify), in: gameModel)
                unit.doFortify(in: gameModel)
                self.unitProcessed(unit: unit, in: gameModel)
                return
                
            } else if currentMoveUnit.movesToTarget < Int.max {
                
                unit.push(mission: UnitMission(type: .moveTo, at: point), in: gameModel)
                unit.finishMoves()
                self.unitProcessed(unit: unit, in: gameModel)
                return
            }
        }
    }
    
    /// Finds both high and normal priority units we can use for this move (returns true if at least 1 unit found)
    @discardableResult
    private func findUnitsFor(move: TacticalMoveType, target: AbstractTile?, turnsAway: Int = -1, rangedOnly: Bool, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        //UnitHandle pLoopUnit;
        var rtnValue = false

        //list<int>::iterator it;
        self.currentMoveUnits.removeAll()
        self.currentMoveHighPriorityUnits.removeAll()
        
        let astar = AStarPathfinder()

        // Loop through all units available to tactical AI this turn
        for currentTurnUnit in self.currentTurnUnits {
            
            guard let loopUnit = currentTurnUnit else {
                continue
            }
            
            if loopUnit.domain() != .air && loopUnit.isCombatUnit() {
                
                // Make sure domain matches
                if loopUnit.domain() == .sea && !target.terrain().isWater() ||
                    loopUnit.domain() == .land && target.terrain().isWater() {
                    continue
                }

                var suitableUnit = false
                var highPriority = false

                if move == .garrisonAlreadyThere || move == .garrisonOneTurn {
                    
                    // Want to put ranged units in cities to give them a ranged attack
                    if loopUnit.isRanged() {
                        suitableUnit = true
                        highPriority = true
                    } else if rangedOnly {
                        continue
                    }

                    // Don't put units with a combat strength boosted from promotions in cities, these boosts are ignored
                    if loopUnit.defenseModifier(against: nil, on: nil, ranged: false, in: gameModel) == 0 && loopUnit.attackModifier(against: nil, or: nil, on: nil, in: gameModel) == 0 {
                        suitableUnit = true
                    }
                } else if move == .guardImprovementAlreadyThere || move == .guardImprovementOneTurn || move == .bastionAlreadyThere || move == .bastionOneTurn {
                    
                    // No ranged units or units without defensive bonuses as plot defenders
                    if !loopUnit.isRanged() /*&& !loopUnit->noDefensiveBonus()*/ {
                        suitableUnit = true

                        // Units with defensive promotions are especially valuable
                        if loopUnit.defenseModifier(against: nil, on: nil, ranged: false, in: gameModel) > 0 /* || pLoopUnit->getExtraCombatPercent() > 0*/ {
                            highPriority = true
                        }
                    }
                } else if move == .ancientRuins {
                    
                    // Fast movers are top priority
                    if loopUnit.has(task: .fastAttack) {
                        suitableUnit = true
                        highPriority = true
                    } else if loopUnit.canAttack() {
                        suitableUnit = true
                    }
                }

                if suitableUnit {
                    // Is it even possible for the unit to reach in the number of requested turns (ignoring roads and RR)
                    let distance = target.point.distance(to: loopUnit.location)
                    if loopUnit.maxMoves(in: gameModel) > 0 {
                        
                        let movesPerTurn = loopUnit.maxMoves(in: gameModel) // / GC.getMOVE_DENOMINATOR();
                        let leastTurns = (distance + movesPerTurn - 1) / movesPerTurn
                        
                        if turnsAway == -1 || leastTurns <= turnsAway {
                            
                            // If unit was suitable, and close enough, add it to the proper list
                            astar.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: loopUnit.movementType(), for: loopUnit.player)
                            let moves = astar.turnsToReachTarget(for: loopUnit, to: target.point)
                            
                            if moves != Int.max && (turnsAway == -1 || (turnsAway == 0 && loopUnit.location == target.point) || moves <= turnsAway) {
                                
                                let unit = TacticalUnit(unit: loopUnit)
                                unit.healthPercent = loopUnit.healthPoints() * 100 / loopUnit.maxHealthPoints()
                                unit.movesToTarget = moves

                                if highPriority {
                                    self.currentMoveHighPriorityUnits.append(unit)
                                } else {
                                    self.currentMoveUnits.append(unit)
                                }
                                rtnValue = true
                            }
                        }
                    }
                }
            }
        }

        return rtnValue
    }
    
    /// Choose which tactics to run and assign units to it (barbarian version)
    private func assignBarbarianMoves(in gameModel: GameModel?) {
     
        for move in self.movePriorityList {
            
            switch move.moveType {
                
            case .barbarianCaptureCity: // AI_TACTICAL_BARBARIAN_CAPTURE_CITY
                self.plotCaptureCityMoves(in: gameModel)
                
            case .barbarianDamageCity: // AI_TACTICAL_BARBARIAN_DAMAGE_CITY
                self.plotDamageCityMoves(in: gameModel)
                
            case .barbarianDestroyHighPriorityUnit: // AI_TACTICAL_BARBARIAN_DESTROY_HIGH_PRIORITY_UNIT
                self.plotDestroyUnitMoves(targetType: .highPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
                
            case .barbarianDestroyMediumPriorityUnit: // AI_TACTICAL_BARBARIAN_DESTROY_MEDIUM_PRIORITY_UNIT
                self.plotDestroyUnitMoves(targetType: .mediumPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
                
            case .barbarianDestroyLowPriorityUnit: // AI_TACTICAL_BARBARIAN_DESTROY_LOW_PRIORITY_UNIT
                self.plotDestroyUnitMoves(targetType: .lowPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
                
            case .barbarianMoveToSafety: // AI_TACTICAL_BARBARIAN_MOVE_TO_SAFETY
                self.plotMovesToSafety(combatUnits: true, in: gameModel)
                
            case .barbarianAttritHighPriorityUnit: // AI_TACTICAL_BARBARIAN_ATTRIT_HIGH_PRIORITY_UNIT
                self.plotDestroyUnitMoves(targetType: .highPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
                
            case .barbarianAttritMediumPriorityUnit: // AI_TACTICAL_BARBARIAN_ATTRIT_MEDIUM_PRIORITY_UNIT
                self.plotDestroyUnitMoves(targetType: .mediumPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
                
            case .barbarianAttritLowPriorityUnit: // AI_TACTICAL_BARBARIAN_ATTRIT_LOW_PRIORITY_UNIT
                self.plotDestroyUnitMoves(targetType: .lowPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
                
            case .barbarianPillage: // AI_TACTICAL_BARBARIAN_PILLAGE
                self.plotPillageMoves(targetType: .improvementResource, firstPass: true, in: gameModel)
                
            case .barbarianPillageCitadel: // AI_TACTICAL_BARBARIAN_PILLAGE_CITADEL
                self.plotPillageMoves(targetType: .citadel, firstPass: true, in: gameModel)
                
            case .barbarianPillageNextTurn: // AI_TACTICAL_BARBARIAN_PILLAGE_NEXT_TURN
                self.plotPillageMoves(targetType: .citadel, firstPass: false, in: gameModel)
                self.plotPillageMoves(targetType: .improvementResource, firstPass: false, in: gameModel)
                
            case .barbarianBlockadeResource: // AI_TACTICAL_BARBARIAN_PRIORITY_BLOCKADE_RESOURCE
                //            PlotBlockadeImprovementMoves();
                break
                
            case .barbarianCivilianAttack: // AI_TACTICAL_BARBARIAN_CIVILIAN_ATTACK
                self.plotCivilianAttackMoves(targetType: .veryHighPriorityCivilian, in: gameModel)
                self.plotCivilianAttackMoves(targetType: .highPriorityCivilian, in: gameModel)
                self.plotCivilianAttackMoves(targetType: .mediumPriorityCivilian, in: gameModel)
                self.plotCivilianAttackMoves(targetType: .lowPriorityCivilian, in: gameModel)
            
            case .barbarianCampDefense: // AI_TACTICAL_BARBARIAN_CAMP_DEFENSE
                self.plotCampDefenseMoves(in: gameModel)
                        
            case .barbarianAggressiveMove: // AI_TACTICAL_BARBARIAN_AGGRESSIVE_MOVE
                self.plotBarbarianMove(aggressive: true, in: gameModel)
                        
            case .barbarianPassiveMove: // AI_TACTICAL_BARBARIAN_PASSIVE_MOVE
                self.plotBarbarianMove(aggressive: false, in: gameModel)
                        
            case .barbarianDesperateAttack: // AI_TACTICAL_BARBARIAN_DESPERATE_ATTACK
                self.plotDestroyUnitMoves(targetType: .lowPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: true, in: gameModel)
                        
            case .barbarianEscortCivilian: // AI_TACTICAL_BARBARIAN_ESCORT_CIVILIAN
                self.plotBarbarianCivilianEscortMove(in: gameModel)
                        
            case .barbarianPlunderTradeUnit: // AI_TACTICAL_BARBARIAN_PLUNDER_TRADE_UNIT
                self.plotBarbarianPlunderTradeUnitMove(in: .land, in: gameModel)
                self.plotBarbarianPlunderTradeUnitMove(in: .sea, in: gameModel)

            case .barbarianGuardCamp:
                self.plotGuardBarbarianCamp(in: gameModel)
                
            default:
                // NOOP
                print("not implemented: TacticalAI - \(move.moveType)")
                break
            }
        }
        
        self.reviewUnassignedBarbarianUnits(in: gameModel)
    }
    
    /// Log that we couldn't find assignments for some units
    func reviewUnassignedBarbarianUnits(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // Loop through all remaining units
        for currentTurnUnitRef in self.currentTurnUnits {
            
            if let currentTurnUnit = currentTurnUnitRef {
                
                // Barbarians and air units aren't handled by the operational or homeland AIs
                if currentTurnUnit.player?.leader == .barbar || currentTurnUnit.domain() == .air {
                    
                    currentTurnUnit.push(mission: UnitMission(type: .skip), in: gameModel)
                    currentTurnUnit.set(turnProcessed: true)
                    
                    print("<< TacticalAI - barbarian ### Unassigned \(currentTurnUnit.name()) at \(currentTurnUnit.location)")
                }
            }
        }
    }
    
    /// Move barbarians across the map
    func plotBarbarianMove(aggressive: Bool, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if player.isBarbarian() {
            
            self.currentMoveUnits.removeAll()

            // Loop through all recruited units
            for currentTurnUnitRef in self.currentTurnUnits {
                
                guard let currentTurnUnit = currentTurnUnitRef else {
                    continue
                }
                
                let unit = TacticalUnit(unit: currentTurnUnit)

                self.currentMoveUnits.append(unit);
            }

            if self.currentMoveUnits.count > 0 {
                self.executeBarbarianMoves(aggressive: aggressive, in: gameModel)
            }
        }
    }
    
    /// Plunder trade routes
    func plotBarbarianPlunderTradeUnitMove(in domain: UnitDomainType, in gameModel: GameModel?) {
        
        var targetType: TacticalTargetType = TacticalTargetType.none
        var navalOnly = false
        
        if domain == .land {
            targetType = TacticalTargetType.tradeUnitLand
        } else if domain == .sea {
            targetType = TacticalTargetType.tradeUnitSea
            navalOnly = true
        }

        if targetType == TacticalTargetType.none {
            return
        }

        for target in self.zoneTargets(for: targetType) {
            
            // See what units we have who can reach target this turn
            if self.findUnitsWithinStrikingDistance(towards: target!.target, numTurnsAway: 0, noRangedUnits: false, navalOnly: navalOnly, in: gameModel) {
                
                // Queue best one up to capture it
                self.executePlunderTradeUnit(at: target!.target, in: gameModel)
            }
        }
    }
    
    /// Escort captured civilians back to barbarian camps
    func plotBarbarianCivilianEscortMove(in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }
               
        if player.isBarbarian() {
            
            self.currentMoveUnits.removeAll()

            for currentTurnUnitRef in self.currentTurnUnits {
                
                guard let currentTurnUnit = currentTurnUnitRef else {
                    continue
                }
                
                // Find any civilians we may have "acquired" from the civs
                if !currentTurnUnit.canAttack() {
                    
                    let unit = TacticalUnit(unit: currentTurnUnit)
                    self.currentMoveUnits.append(unit)
                }
            }

            if self.currentMoveUnits.count > 0 {
                self.executeBarbarianCivilianEscortMove(in: gameModel)
            }
        }
    }
    
    /// Move Barbarian civilian to a camp (with escort if possible)
    func executeBarbarianCivilianEscortMove(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for civilianMoveUnitRef in self.currentMoveUnits {
            
            guard let civilian = civilianMoveUnitRef?.unit else {
                continue
            }

            if let target = self.findNearbyTarget(for: civilian, in: Int.max, of: .barbarianCamp, noLikeUnit: civilian, in: gameModel) {

                // If we're not there yet, we have work to do
                var current = civilian.location
                if current == target {
                    civilian.finishMoves()
                    self.unitProcessed(unit: civilian, in: gameModel)
                } else {
                    
                    var escortRef: AbstractUnit? = nil
                    
                    if let loopUnit = gameModel.unit(at: current) {
                        
                        if civilian.player!.isEqual(to: loopUnit.player) {
                            escortRef = loopUnit
                        }
                    }

                    // Handle case of no path found at all for civilian
                    if let path = civilian.path(towards: target, options: .none, in: gameModel) {
                        
                        let civilianMove = path.last!.0 // pCivilian->GetPathEndTurnPlot();

                        // Can we reach our target this turn?
                        if civilianMove == target {
                            
                            // See which defender is stronger
                            //UnitHandle pCampDefender = pCivilianMove->getBestDefender(m_pPlayer->GetID());
                            if let escort = escortRef {
                                self.executeMoveToPlot(of: escort, to: civilianMove, in: gameModel)
                                self.executeMoveToPlot(of: civilian, to: civilianMove, in: gameModel)

                            } else {
                                self.executeMoveToPlot(of: civilian, to: civilianMove, in: gameModel)
                            }
                        } else if escortRef == nil {
                            // Can't reach target and don't have escort...
                            self.executeMoveToPlot(of: civilian, to: civilianMove, in: gameModel)
                        } else { // Can't reach target and DO have escort...
                            // See if escort can move to the same location in one turn
                            
                            if let escort = escortRef {
                                if escort.turnsToReach(at: civilianMove, in: gameModel) <= 1 {
                                    self.executeMoveToPlot(of: escort, to: civilianMove, in: gameModel)
                                    self.executeMoveToPlot(of: civilian, to: civilianMove, in: gameModel)
                                } else {
                                    
                                    // See if friendly blocking unit is ending the turn there, or if no blocking unit (which indicates this is somewhere civilian
                                    // can move that escort can't), then find a new path based on moving the escort
                                    if let blockingUnit = gameModel.unit(at: civilianMove) {
                                        
                                        // Looks like we should be able to move the blocking unit out of the way
                                        if self.executeMoveOfBlockingUnit(of: blockingUnit, in: gameModel) {
                                            self.executeMoveToPlot(of: escort, to: civilianMove, in: gameModel)
                                            self.executeMoveToPlot(of: civilian, to: civilianMove, in: gameModel)
                                        } else {
                                            civilian.finishMoves()
                                            escort.finishMoves()
                                        }
                                    } else {
                                        
                                        if let path = civilian.path(towards: target, options: .none, in: gameModel) {
                                            
                                            let escortMove = path.last!.0

                                            // See if civilian can move to the same location in one turn
                                            if civilian.turnsToReach(at: escortMove, in: gameModel) <= 1 {
                                                self.executeMoveToPlot(of: escort, to: escortMove, in: gameModel)
                                                self.executeMoveToPlot(of: civilian, to: escortMove, in: gameModel)
                                            } else {
                                                civilian.finishMoves()
                                                escort.finishMoves()
                                            }
                                        } else  {
                                            civilian.finishMoves()
                                            escort.finishMoves()
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        
                        civilian.finishMoves()
                        if let escort = escortRef {
                            escort.finishMoves()
                        }
                    }
                }
            }
            
        }
    }
    
    /// Find an adjacent hex to move a blocking unit to
    func executeMoveOfBlockingUnit(of blockingUnit: AbstractUnit?, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let blockingUnit = blockingUnit else {
            fatalError("cant get blockingUnit")
        }
        
        if !blockingUnit.canMove() || self.isInQueuedAttack(unit: blockingUnit) {
            return false
        }

        guard let oldPlot = gameModel.tile(at: blockingUnit.location) else {
            fatalError("cant get old plot")
        }

        for neighbor in blockingUnit.location.neighbors() {
            
            if let plot = gameModel.tile(at: neighbor) {
                
                // Don't embark for one of these moves
                if !oldPlot.isWater() && plot.isWater() && blockingUnit.domain() == .land {
                    continue
                }

                // Has to be somewhere we can move and be empty of other units/enemy cities
                if gameModel.visibleEnemy(at: neighbor, for: self.player) == nil && gameModel.visibleEnemyCity(at: blockingUnit.location, for: self.player) == nil /*&& pBlockingUnit->GeneratePath(pPlot))*/ {
                    
                    self.executeMoveToPlot(of: blockingUnit, to: neighbor, in: gameModel)

                    return true
                }
            }
        }
        
        return false
    }
    
    /// Is this unit waiting to get its turn to attack?
    func isInQueuedAttack(unit: AbstractUnit?) -> Bool {
        
        if self.queuedAttacks.count > 0 {
            
            for queuedAttacksRef in self.queuedAttacks {
                
                if let attacker = queuedAttacksRef.attackerUnit {
                    if attacker.isEqual(to: unit) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    /// Move barbarian to a new location
    func executeBarbarianMoves(aggressive: Bool, in gameModel: GameModel?) {

        for currentMoveUnitRef in self.currentMoveUnits {
            
            if let unit = currentMoveUnitRef?.unit {
                
                if unit.isBarbarian() {
                    
                    // LAND MOVES
                    if unit.domain() == .land {
                        
                        var bestPlot: HexPoint?
                        if aggressive {
                            bestPlot = self.findBestBarbarianLandMove(for: unit, in: gameModel)
                        } else {
                            bestPlot = self.findPassiveBarbarianLandMove(for: unit, in: gameModel)
                        }

                        if let bestPlot = bestPlot {
                            self.moveToEmptySpaceNearTarget(unit: unit, target: bestPlot, land: true, in: gameModel)
                            unit.finishMoves();
                            self.unitProcessed(unit: unit, in: gameModel)
                        } else {
                            unit.finishMoves();
                            self.unitProcessed(unit: unit, in: gameModel)
                        }
                    } else { // NAVAL MOVES
                        
                        var bestPlot: HexPoint?
                        
                        // Do I still have a destination from a previous turn?
                        let currentDestination = unit.tacticalTarget()

                        // Compute a new destination if I don't have one or am already there
                        if currentDestination == nil || currentDestination == unit.location {
                            bestPlot = self.findBestBarbarianSeaMove(for: unit, in: gameModel)
                        } else { // Otherwise just keep moving there (assuming a path is available)
                            if unit.turnsToReach(at: currentDestination!, in: gameModel) != Int.max {
                                bestPlot = currentDestination
                            } else {
                                bestPlot = self.findBestBarbarianSeaMove(for: unit, in: gameModel)
                            }
                        }

                        if let bestPlot = bestPlot {
                            
                            unit.set(tacticalTarget: bestPlot)
                            unit.push(mission: UnitMission(type: .moveTo, at: bestPlot), in: gameModel)
                            unit.finishMoves();
                            self.unitProcessed(unit: unit, in: gameModel)
                        } else {
                            unit.resetTacticalTarget()
                            unit.finishMoves()
                            self.unitProcessed(unit: unit, in: gameModel)
                        }
                    }
                }
            }
        }
    }
    
    /// Find a multi-turn target for a sea barbarian to wander towards
    func findBestBarbarianSeaMove(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPoint? {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let economicAI = self.player?.economicAI else {
            fatalError("cant get economicAI")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        let barbarianSeaTargetRange = gameModel.handicap.barbarbianSeaTargetRange()
        
        var bestValue = Int.max
        var bestMovePlot: HexPoint? = nil

        // Loop through all unit targets to find the closest
        for targetRef in self.unitTargets() {
            
            guard let target = targetRef else {
                continue
            }
            
            // Is this unit nearby enough?
            if unit.location.distance(to: target.target) < barbarianSeaTargetRange {
                
                if gameModel.area(of: unit.location) ==  gameModel.area(of: target.target) {
                    
                    let value = unit.turnsToReach(at: target.target, in: gameModel)
                    if value < bestValue {
                        bestValue = value
                        bestMovePlot = target.target
                    }
                }
            }
        }

        // move toward trade routes
        if bestMovePlot == nil {
            bestMovePlot = self.findBarbarianGankTradeRouteTarget(for: unit, in: gameModel)
        }

        // No units to pick on, so sail to a tile adjacent to the second closest barbarian camp
        if bestMovePlot == nil {
        
            var nearestCamp: HexPoint? = nil
            var bestCampDistance = Int.max
            var bestValue = Int.max

            // Start by finding the very nearest camp
            for targetRef in self.zoneTargets(for: .barbarianCamp) {
                
                guard let target = targetRef else {
                    continue
                }
                
                let distance = unit.location.distance(to: target.target)
                
                if distance < bestCampDistance {
                    
                    nearestCamp = target.target
                    bestCampDistance = distance
                }
            }

            // The obvious way to do this next part is to plot moves to each naval tile adjacent to each camp ...
            // starting with the first camp and then proceeding to the final one.  But our optimization (to drop out
            // targets that are further from the closest we've found so far) might in worst case not help at all if we
            // check the closest camp last.  So instead we'll loop by DIRECTIONS first which should mean we pick up some plot
            // from a close camp early (and the optimization will help)
            for dir in HexDirection.all {
                
                for targetRef in self.zoneTargets(for: .barbarianCamp) {
                
                    guard let target = targetRef else {
                        continue
                    }
                    
                    if nearestCamp != target.target {
                        
                        if let tile = gameModel.tile(at: target.target) {
                            
                            if tile.isWater() {
                                
                                let distance = unit.location.distance(to: target.target)
                                
                                if distance < bestValue {
                                    
                                    bestMovePlot = target.target
                                    bestValue = distance
                                }
                            }
                        }
                    }
                }
            }
        }

        // No obvious target, let's scan nearby tiles for the best choice, borrowing some of the code from the explore AI
        if bestMovePlot == nil {
            
            // Now looking for BEST score
            var bestValue = 0
            let movementRange = unit.movesLeft()
            
            for considerLocation in unit.location.areaWith(radius: movementRange) {
                
                if gameModel.unit(at: considerLocation) != nil {
                    continue
                }
                
                guard let considerPlot = gameModel.tile(at: considerLocation) else {
                    continue
                }
                    
                if !considerPlot.isDiscovered(by: unit.player) {
                    continue
                }
                
                
                if !unit.canReach(at: considerLocation, in: movementRange, in: gameModel) {
                    continue
                }
                
                // Value them based on their explore value
                var value: Int = economicAI.scoreExplore(plot: considerLocation, for: self.player, range: unit.sight(), domain: unit.domain(), in: gameModel)
                
                // Add special value for being near enemy lands
                /*if considerPlot.isAdjacentOwned() {
                    value += 100
                } else*/ if considerPlot.hasOwner() {
                    value += 200
                }
                
                // If still have no value, score equal to distance from my current plot
                if value == 0 {
                    value = unit.location.distance(to: considerLocation)
                }

                if value > bestValue {
                    bestMovePlot = considerLocation
                    bestValue = value
                }
            }
        }

        return bestMovePlot
    }
    
    /// Find a multi-turn target for a land barbarian to wander towards
    func findBestBarbarianLandMove(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPoint? {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        let landBarbarianRange = gameModel.handicap.barbarbianLandTargetRange()
        
        var bestMovePlot = self.findNearbyTarget(for: unit, in: landBarbarianRange, in: gameModel)
        
        // move toward trade routes
        if bestMovePlot == nil {
            bestMovePlot = self.findBarbarianGankTradeRouteTarget(for: unit, in: gameModel)
        }

        // explore wander
        if bestMovePlot == nil {
            bestMovePlot = self.findBarbarianExploreTarget(for: unit, in: gameModel)
        }

        return bestMovePlot
    }
    
    /// Scan nearby tiles for a trade route to sit and gank from
    func findBarbarianGankTradeRouteTarget(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPoint? {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        var bestMovePlot: HexPoint? = nil

        // Now looking for BEST score
        var bestValue = 0;
        let movementRange = unit.movesLeft()
        
        for plot in unit.location.areaWith(radius: movementRange) {
            
            if plot == unit.location {
                continue
            }
            
            guard let tile = gameModel.tile(at: plot) else {
                continue
            }
            
            if !tile.isDiscovered(by: self.player) {
                continue
            }
            
            if !unit.canReach(at: plot, in: movementRange, in: gameModel) {
                continue
            }
            
            let value = gameModel.numTradeRoutes(at: plot)
            
            if value > bestValue {
                bestMovePlot = plot
                bestValue = value
            }
        }
        
        return bestMovePlot
    }
    
    /// Find a multi-turn target for a land barbarian to wander towards
    func findPassiveBarbarianLandMove(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPoint? {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
    
        guard let unit = unit else {
            fatalError("cant get unit")
        }

        var bestValue = Int.max
        var bestMovePlot: HexPoint? = nil

        for allTarget in self.allTargets {
            
            // Is this target a camp?
            if allTarget.targetType == .barbarianCamp {
                
                let value = unit.location.distance(to: allTarget.target)
                
                if value < bestValue {
                    
                    bestValue = value
                    bestMovePlot = allTarget.target
                }
            }
        }

        if bestMovePlot == nil {
            bestMovePlot = self.findBarbarianExploreTarget(for: unit, in: gameModel)
        }

        return bestMovePlot
    }
    
    /// Scan nearby tiles for the best choice, borrowing code from the explore AI
    func findBarbarianExploreTarget(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPoint? {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let economicAI = self.player?.economicAI else {
            fatalError("cant get economicAI")
        }
    
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        var bestValue = 0
        var bestMovePlot: HexPoint? = nil
        let movementRange = unit.movesLeft()

        // Now looking for BEST score
        for plot in unit.location.areaWith(radius: movementRange) {
        
            if plot == unit.location {
                continue
            }
        
            guard let tile = gameModel.tile(at: plot) else {
                continue
            }
        
            if !tile.isDiscovered(by: self.player) {
                continue
            }
            
            if !unit.canReach(at: plot, in: movementRange, in: gameModel) {
                continue
            }
            
            // Value them based on their explore value
            var value = economicAI.scoreExplore(plot: plot, for: self.player, range: unit.sight(), domain: unit.domain(), in: gameModel)

            // Add special value for popping up on hills or near enemy lands
            /*if(pPlot->isAdjacentOwned())
            {
                iValue += 100;
            }
             else*/ if tile.hasOwner() {
                value += 200
            }

            // If still have no value, score equal to distance from my current plot
            if value == 0 {
                value = unit.location.distance(to: plot)
            }
            
            if value > bestValue {
                bestMovePlot = plot
                bestValue = value
            }
        }
        
        return bestMovePlot
    }
    
    /// Pillage an undefended improvement
    func executePlunderTradeUnit(at point: HexPoint, in gameModel: GameModel?) {
        
        // Move first one to target
        if let currentMoveUnit = self.currentMoveUnits.first {
            
            if let unit = currentMoveUnit?.unit {
                unit.push(mission: UnitMission(type: .moveTo, buildType: nil, at: point), in: gameModel)
                unit.push(mission: UnitMission(type: .plunderTradeRoute), in: gameModel)
                unit.finishMoves()
                
                // Delete this unit from those we have to move
                self.unitProcessed(unit: unit, in: gameModel)
            }
        }
    }
    
    /// Assign a group of units to attack each unit we think we can destroy
    func plotDestroyUnitMoves(targetType: TacticalTargetType, mustBeAbleToKill: Bool, attackAtPoorOdds: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var requiredDamage: Int = 0
        var expectedDamage: Int = 0

        // See how many moves of this type we can execute
        for target in self.zoneTargets(for: targetType) {
            
            var unitCanAttack = false
            var cityCanAttack = false
            
            // See what units we have who can reach targets this turn
            if let targetLocation = target?.target {
                
                guard let tile = gameModel.tile(at: targetLocation) else {
                    continue
                }
                
                if let defender = gameModel.unit(at: targetLocation) {
                
                    unitCanAttack = self.findUnitsWithinStrikingDistance(towards: targetLocation, numTurnsAway: 1, noRangedUnits: false, navalOnly: false, in: gameModel)
                    cityCanAttack = self.findCitiesWithinStrikingDistance(of: targetLocation, in: gameModel)
                    
                    if unitCanAttack || cityCanAttack {
                        
                        expectedDamage = self.computeTotalExpectedDamage(target: target, and: tile, in: gameModel)
                        expectedDamage += self.computeTotalExpectedBombardDamage(against: defender, in: gameModel)
                        requiredDamage = defender.healthPoints()
                        target?.damage = requiredDamage

                        if !mustBeAbleToKill {
                            // Attack no matter what
                            if attackAtPoorOdds {
                                self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: false, mustSurviveAttack: false, in: gameModel)
                            } else {
                                // If we can at least knock the defender to 40% strength with our combined efforts, go ahead even if each individual attack isn't favorable
                                var mustInflictWhatWeTake = true
                                if expectedDamage >= (requiredDamage * 40) / 100 {
                                    mustInflictWhatWeTake = false
                                }
                                self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: mustInflictWhatWeTake, mustSurviveAttack: true, in: gameModel)
                            }
                        } else {
                            // Do we have enough firepower to destroy it?
                            if expectedDamage > requiredDamage {
                                
                                self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: false, mustSurviveAttack: (targetType != .highPriorityUnit), in: gameModel)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Assign a unit to capture an undefended barbarian camp
    func plotBarbarianCampMoves(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        for target in self.zoneTargets(for: .barbarianCamp) {
            
            guard let targetPoint = target?.target else {
                continue
            }
            
            // See what units we have who can reach target this turn
            /*guard let plot = gameModel.tile(at: targetPoint) else {
                continue
            }*/
            
            if self.findUnitsWithinStrikingDistance(towards: targetPoint, numTurnsAway: 1, noRangedUnits: false, navalOnly: false, mustMoveThrough: false, includeBlockedUnits: false, willPillage: false, targetUndefended: true, in: gameModel) {
                
                // Queue best one up to capture it
                self.executeBarbarianCampMove(at: targetPoint, in: gameModel)
                
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                    
                    print("Removing barbarian camp, \(targetPoint)")
                    // LogTacticalMessage(strLogString);
                }
                
                self.deleteTemporaryZone(at: targetPoint)
            }
        }
    }
    
    /// Capture the gold from a barbarian camp
    func executeBarbarianCampMove(at point: HexPoint, in gameModel: GameModel?) {
        
        if let currentMoveUnit = self.currentMoveUnits.first {
            // Move first one to target
            if let unit = currentMoveUnit?.unit {
                
                unit.push(mission: UnitMission(type: .moveTo, at: point), in: gameModel)
                unit.finishMoves()

                // Delete this unit from those we have to move
                self.unitProcessed(unit: unit, in: gameModel)
            }
        }
    }
    
    /// Assigns units to capture undefended civilians
    func plotCivilianAttackMoves(targetType: TacticalTargetType, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        for targetRef in self.zoneTargets(for: targetType) {
        
            guard let target = targetRef else {
                continue
            }
            
            // See what units we have who can reach target this turn
            if self.findUnitsWithinStrikingDistance(towards: target.target, numTurnsAway: 1, noRangedUnits: false, navalOnly: false, mustMoveThrough: false, includeBlockedUnits: false, willPillage: false, targetUndefended: true, in: gameModel) {
                
                // Queue best one up to capture it
                self.executeCivilianCapture(at: target.target, in: gameModel)
            }
        }
    }
    
    /// Assigns a barbarian to go protect an undefended camp
    func plotCampDefenseMoves(in gameModel: GameModel?) {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        for targetRef in self.zoneTargets(for: .barbarianCamp) {
        
            guard let target = targetRef else {
                continue
            }
            
            if self.findUnitsWithinStrikingDistance(towards: target.target, numTurnsAway: 1, noRangedUnits: true, navalOnly: false, mustMoveThrough: false, includeBlockedUnits: false, willPillage: false, targetUndefended: true, in: gameModel) {
                
                self.executeMoveToPlot(to: target.target, saveMoves: false, in: gameModel)
            }
        }
    }
    
    func plotGuardBarbarianCamp(in gameModel: GameModel?) {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if player.isBarbarian() {
        
            self.currentMoveUnits.removeAll()
                
            for loopUnitRef in self.currentTurnUnits {
            
                guard let loopUnit = loopUnitRef else {
                    continue
                }
                
                // is unit already at a camp?
                if let tile = gameModel?.tile(at: loopUnit.location) {
                    if tile.has(improvement: .barbarianCamp) {
                        let unit = TacticalUnit(unit: loopUnit)
                        self.currentMoveUnits.append(unit)
                    }
                }
            }
            
            if self.currentMoveUnits.count > 0 {
                self.executeGuardBarbarianCamp(in: gameModel)
            }
        }
    }
    
    func executeGuardBarbarianCamp(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // unit should stay
        for currentMoveUnitRef in self.currentMoveUnits {
            
            guard let currentMoveUnit = currentMoveUnitRef?.unit else {
                continue
            }
            
            currentMoveUnit.finishMoves()
            self.unitProcessed(unit: currentMoveUnit, markTacticalMap: currentMoveUnit.isCombatUnit(), in: gameModel)
        }
    }
    
    /// Move unit to protect a specific tile (retrieve unit from first entry in m_CurrentMoveUnits)
    func executeMoveToPlot(to point: HexPoint, saveMoves: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // Move first one to target
        if let firstCurrentModeUnit = self.currentMoveUnits.first {
            
            if let unit = firstCurrentModeUnit?.unit {
                
                self.executeMoveToPlot(of: unit, to: point, saveMoves: saveMoves, in: gameModel)
            }
        }
    }
    
    /// Move unit to protect a specific tile (retrieve unit from first entry in m_CurrentMoveUnits)
    func executeMoveToPlot(of unit: AbstractUnit?, to point: HexPoint, saveMoves: Bool = false, in gameModel: GameModel?) {
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        // Unit already at target plot?
        if point == unit.location {
            
            // Fortify if possible
            if unit.canFortify(at: point, in: gameModel) {
                 unit.push(mission: UnitMission(type: .fortify), in: gameModel)
                //unit.fort ->SetFortifiedThisTurn(true);
            } else {
                unit.push(mission: UnitMission(type: .skip), in: gameModel)
                if !saveMoves {
                    unit.finishMoves()
                }
            }
        } else {
            unit.push(mission: UnitMission(type: .moveTo, at: point) , in: gameModel)
            if !saveMoves {
                unit.finishMoves()
            }
        }

        self.unitProcessed(unit: unit, markTacticalMap: unit.isCombatUnit(), in: gameModel)
    }
    
    /// Capture an undefended civilian
    func executeCivilianCapture(at point: HexPoint, in gameModel: GameModel?) {
        
        // Move first one to target
        if let currentMoveUnit = self.currentMoveUnits.first {
            
            if let unit = currentMoveUnit?.unit {
                unit.push(mission: UnitMission(type: .moveTo, buildType: nil, at: point), in: gameModel)
                unit.finishMoves()
                
                // Delete this unit from those we have to move
                self.unitProcessed(unit: unit, in: gameModel)
                
                unit.resetTacticalTarget()
            }
        }
    }
    
    /// Assigns units to pillage enemy improvements
    func plotPillageMoves(targetType: TacticalTargetType, firstPass: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        //let pillageHeal = 25 /* PILLAGE_HEAL_AMOUNT */

        for targetRef in self.zoneTargets(for: targetType) {
            
            guard let target = targetRef else {
                continue
            }
            
            // try paratroopers first, not because they are more effective, just because it looks cooler...
            /*if (bFirstPass && FindParatroopersWithinStrikingDistance(pPlot))
            {
                // Queue best one up to capture it
                ExecuteParadropPillage(pPlot);
            } else */
            
            if firstPass && self.findUnitsWithinStrikingDistance(towards: target.target, numTurnsAway: 0, noRangedUnits: false , navalOnly: false, mustMoveThrough: true, includeBlockedUnits: false, willPillage: true, in: gameModel) {
                
                // Queue best one up to capture it
                self.executePillage(at: target.target, in: gameModel)
            }

            // No one can reach it this turn, what about next turn?
            else if !firstPass && self.findUnitsWithinStrikingDistance(towards: target.target, numTurnsAway: 2, noRangedUnits: false, navalOnly: false, mustMoveThrough: false, includeBlockedUnits: false, willPillage: true, in: gameModel) {
                
                self.executeMoveToTarget(target: target.target, garrisonIfPossible: false, in: gameModel)
            }
        }
    }
    
    /// Pillage an undefended improvement
    private func executePillage(at point: HexPoint, in gameModel: GameModel?) {
        
        // Move first one to target
        if let currentMoveUnit = self.currentMoveUnits.first {
            
            if let unit = currentMoveUnit?.unit {
                unit.push(mission: UnitMission(type: .moveTo, buildType: nil, at: point), in: gameModel)
                unit.push(mission: UnitMission(type: .pillage), in: gameModel)
                unit.finishMoves()
                
                // Delete this unit from those we have to move
                self.unitProcessed(unit: unit, in: gameModel)
            }
        }
    }
    
    /// Assign a group of units to take down each city we can capture
    @discardableResult
    private func plotCaptureCityMoves(in gameModel: GameModel?) -> Bool {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var attackMade = false
        
        // See how many moves of this type we can execute
        for target in self.zoneTargets(for: .city) {
            
            // See what units we have who can reach target this turn
            if let tile = target?.tile {
                
                if self.findUnitsWithinStrikingDistance(towards: tile.point, numTurnsAway: 1, in: gameModel) {
                    
                    // Do we have enough firepower to destroy it?
                    if let city = gameModel.city(at: tile.point) {
                        
                        let requiredDamage = 200 - city.damage()
                        target?.damage = requiredDamage
                        
                        if self.computeTotalExpectedDamage(target: target, and: tile, in: gameModel) >= requiredDamage {
                            
                            print("### Attacking city of \(city.name) to capture \(city.location.x), \(city.location.y) by \(String(describing: self.player?.leader))")
                            
                            // If so, execute enough moves to take it
                            self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: false, mustSurviveAttack: false, in: gameModel)
                            attackMade = true
                            
                            // Did it work?  If so, don't need a temporary dominance zone if had one here
                            if tile.owner()?.leader == self.player?.leader {
                                self.deleteTemporaryZone(at: tile.point)
                            }
                        }
                    }
                }
            }
        }
        
        return attackMade
    }
    
    /// Assign a group of units to take down each city we can capture
    @discardableResult
    func plotDamageCityMoves(in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var attackMade = false

        // See how many moves of this type we can execute
        for target in self.zoneTargets(for: .city) {
    
            // See what units we have who can reach target this turn
            if let tile = target?.tile {
                
                self.currentMoveCities.removeAll()
                
                if self.findUnitsWithinStrikingDistance(towards: tile.point, numTurnsAway: 1, noRangedUnits: false, navalOnly: false, mustMoveThrough: false, includeBlockedUnits: true, in: gameModel) {

                    if let city = gameModel.city(at: tile.point) {

                        let requiredDamage = city.maxHealthPoints() - city.damage()
                        target?.damage = requiredDamage

                        // Don't want to hammer away to try and take down a city for more than 8 turns
                        if self.computeTotalExpectedDamage(target: target, and: tile, in: gameModel) > (requiredDamage / 8) {
                            
                            // If so, execute enough moves to take it
                            self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: false, mustSurviveAttack: true, in: gameModel)
                            attackMade = true
                        }
                    }
                }
            }
        }
        
        return attackMade
    }
    
    /// Assign a group of units to attack each unit we think we can destroy
    func plotDestroyUnitMoves(for targetType: TacticalTargetType, mustBeAbleToKill: Bool, attackAtPoorOdds: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var requiredDamage: Int = 0
        var expectedDamage: Int = 0

        // See how many moves of this type we can execute
        for target in self.zoneTargets(for: targetType) {
            
            var unitCanAttack = false
            var cityCanAttack = false
            
            if let targetLocation = target?.target {
            
                guard let tile = gameModel.tile(at: targetLocation) else {
                    continue
                }
            
                if let defender = gameModel.unit(at: targetLocation) {
                    
                    unitCanAttack = self.findUnitsWithinStrikingDistance(towards: tile.point, numTurnsAway: 1, noRangedUnits: false, in: gameModel)
                    cityCanAttack = self.findCitiesWithinStrikingDistance(of: targetLocation, in: gameModel)
                    
                    if unitCanAttack || cityCanAttack {
                        
                        expectedDamage = self.computeTotalExpectedDamage(target: target, and: tile, in: gameModel)
                        expectedDamage += self.computeTotalExpectedBombardDamage(against: defender, in: gameModel)
                        requiredDamage = defender.healthPoints()
                        
                        target?.damage = requiredDamage

                        if !mustBeAbleToKill {

                            // Attack no matter what
                            if attackAtPoorOdds {
                                self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: false, mustSurviveAttack: false, in: gameModel)
                            } else {
                                // If we can at least knock the defender to 40% strength with our combined efforts, go ahead even if each individual attack isn't favorable
                                var mustInflictWhatWeTake = true
                                if expectedDamage >= (requiredDamage * 40) / 100 {
                                    mustInflictWhatWeTake = false
                                }
                                self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: mustInflictWhatWeTake, mustSurviveAttack: true, in: gameModel)
                            }
                        } else { // Do we have enough firepower to destroy it?
                            if expectedDamage > requiredDamage {
                                self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: false, mustSurviveAttack: (targetType != .highPriorityUnit), in: gameModel)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Estimates the damage we can apply to a target
    @discardableResult
    func computeTotalExpectedDamage(target: TacticalTarget?, and targetPlot: AbstractTile?, in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let targetPlot = targetPlot else {
            fatalError("cant get targetPlot")
        }
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        var rtnValue = 0
        var expectedDamage = 0
        var expectedSelfDamage = 0

        // Loop through all units who can reach the target
        for attackerRef in self.currentMoveUnits {
            
            guard let attacker = attackerRef?.unit else {
                continue
            }

            // Is target a unit?
            switch target.targetType {
                
            case .highPriorityUnit, .mediumPriorityUnit, .lowPriorityUnit:
                if let defender = gameModel.unit(at: targetPlot.point) {

                    if attacker.canAttackRanged() {
                        let result = Combat.predictRangedAttack(between: attacker, and: defender, in: gameModel)
                        
                        expectedDamage = result.defenderDamage
                        expectedSelfDamage = 0
                    } else {
                        
                        let result = Combat.predictMeleeAttack(between: attacker, and: defender, in: gameModel)
                        
                        expectedDamage = result.defenderDamage
                        expectedSelfDamage = result.attackerDamage
                    }
                    
                    attackerRef?.expectedTargetDamage = expectedDamage
                    attackerRef?.expectedSelfDamage = expectedSelfDamage
                    
                    rtnValue += expectedDamage
                }

            case .city:
                
                if let city = gameModel.city(at: targetPlot.point) {
                    
                    if attacker.canAttackRanged() {
                        let result = Combat.predictRangedAttack(between: attacker, and: city, in: gameModel)
                        
                        expectedDamage = result.defenderDamage
                        expectedSelfDamage = 0
                    } else {
                        
                        let result = Combat.predictMeleeAttack(between: attacker, and: city, in: gameModel)
                        
                        expectedDamage = result.defenderDamage
                        expectedSelfDamage = result.attackerDamage
                    }
                    
                    attackerRef?.expectedTargetDamage = expectedDamage
                    attackerRef?.expectedSelfDamage = expectedSelfDamage
                    
                    rtnValue += expectedDamage
                }
                
            default:
                // NOOP
                break
            }
        }

        return rtnValue
    }
    
    /// Estimates the bombard damage we can apply to a target
    @discardableResult
    func computeTotalExpectedBombardDamage(against defender: AbstractUnit?, in gameModel: GameModel?) -> Int {
        
        var rtnValue = 0
        var expectedDamage = 0

        // Now loop through all the cities that can bombard it
        for attackingCityRef in self.currentMoveCities {
            
            guard let attackingCity = attackingCityRef?.city else {
                continue
            }
            
            let result = Combat.predictRangedAttack(between: attackingCity, and: defender, in: gameModel)
            
            expectedDamage = result.defenderDamage
            attackingCityRef?.expectedTargetDamage = expectedDamage
            rtnValue += expectedDamage
        }

        return rtnValue
    }
    
    /// Reset all data on queued attacks for a new turn
    func initializeQueuedAttacks() {
        
        self.queuedAttacks.removeAll()
        self.currentSeriesId = 0
    }
    
    /// Fills m_CurrentMoveUnits with all units within X turns of a target (returns TRUE if 1 or more found)
    // FIXME: method needs update
    func findUnitsWithinStrikingDistance(towards targetLocation: HexPoint, numTurnsAway: Int, noRangedUnits: Bool = false, navalOnly: Bool = false, mustMoveThrough: Bool = false, includeBlockedUnits: Bool = false, willPillage: Bool = false, targetUndefended: Bool = false, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var rtnValue = false
        self.currentMoveUnits.removeAll()
        
        let isCityTarget = gameModel.city(at: targetLocation) != nil

         // Loop through all units available to tactical AI this turn
        for loopUnitRef in self.currentTurnUnits {
            
            guard let loopUnit = loopUnitRef else {
                continue
            }
            
            if !navalOnly || loopUnit.domain() == .sea {
                
                     // don't use non-combat units
                if !loopUnit.canAttack() {
                    continue
                }

                if loopUnit.isOutOfAttacks() {
                    continue
                }
                
                /*if !isCityTarget && loopUnit.cityAttackOnly() {
                    continue;
                }*/

                if willPillage && !loopUnit.canPillage(at: targetLocation, in: gameModel) {
                    continue
                }

                // *** Need to make this smarter and account for units that can move up on their targets and then make a ranged attack,
                //     all in the same turn. ***
                if !noRangedUnits && !mustMoveThrough && loopUnit.canAttackRanged() {
                    
                    // Are we in range?
                    if loopUnit.location.distance(to: targetLocation) <= loopUnit.range() {
                        
                        // Do we have LOS to the target?
                        //if loopUnit.canEverRangeStrikeAt(pTarget->getX(), pTarget->getY())) {
                        // Will we do any damage
                        if self.isExpectedToDamageWithRangedAttack(by: loopUnit, towards: targetLocation, in: gameModel) {
                                     
                            // Want ranged units to attack first, so inflate this
                            // Don't take damage from bombarding, so show as fully healthy
                            let unit = TacticalUnit(unit: loopUnit, attackStrength: 100 * loopUnit.rangedCombatStrength(against: nil, or: nil, on: nil, attacking: true, in: gameModel), healthPercent: 100)
                            self.currentMoveUnits.append(unit)
                            rtnValue = true
                         }
                    }
                    // {
                 } else {
                    if loopUnit.canReach(at: targetLocation, in: numTurnsAway, in: gameModel) {
                        let unit = TacticalUnit(unit: loopUnit, attackStrength: 100 * loopUnit.rangedCombatStrength(against: nil, or: nil, on: nil, attacking: true, in: gameModel), healthPercent: loopUnit.healthPoints())
                         self.currentMoveUnits.append(unit)
                         rtnValue = true
                     }
                 }
             }
        }

        // Now sort them in the order we'd like them to attack
        self.currentMoveUnits.sort(by: { $0!.movesToTarget < $1!.movesToTarget })

        return rtnValue
    }
    
    func isExpectedToDamageWithRangedAttack(by attacker: AbstractUnit?, towards targetLocation: HexPoint, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var expectedDamage = 0

        if let city = gameModel.city(at: targetLocation) {
            
            let result = Combat.predictRangedAttack(between: attacker, and: city, in: gameModel)
            expectedDamage = result.defenderDamage
        } else if let defender = gameModel.unit(at: targetLocation) {
            
            let result = Combat.predictRangedAttack(between: attacker, and: defender, in: gameModel)
            expectedDamage = result.defenderDamage
        }

        return expectedDamage > 0
    }
    
    /// Fills m_CurrentMoveCities with all cities within bombard range of a target (returns TRUE if 1 or more found)
    func findCitiesWithinStrikingDistance(of point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        var rtnValue = false
        self.currentMoveCities.removeAll()

        // Loop through all of our cities
        for loopCityRef in gameModel.cities(of: player) {
            
            guard let loopCity = loopCityRef else {
                continue
            }
            
            if loopCity.canRangeStrike(towards: point) && !self.isCityInQueuedAttack(city: loopCity) {
                let cityTarget = TacticalCity(city: loopCity)
                self.currentMoveCities.append(cityTarget)
                rtnValue = true
            }
        }

        // Now sort them in the order we'd like them to attack
        self.currentMoveCities.sort(by: { $0! < $1! })

        return rtnValue
    }
    
    /// Is this unit waiting to get its turn to attack?
    func isCityInQueuedAttack(city attackCity: AbstractCity?) -> Bool {
        
        if self.queuedAttacks.count > 0 {
             
            for queuedAttack in self.queuedAttacks {
                if queuedAttack.cityAttack && queuedAttack.attackerCity?.location == attackCity?.location {
                    return true
                }
            }
        }
        return false
    }
       
    /// Queue up the attack - return TRUE if first attack on this target
    func queueAttack(attacker: AbstractUnit?, target: TacticalTarget?, ranged: Bool) -> Bool {
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        var rtnValue = true
        var seriesId = -1

        // Can we find this target in the queue, if so what is its series ID
        if let queuedAttack = self.isAlreadyTargeted(at: target.target) {
            seriesId = queuedAttack.seriesId
            rtnValue = false
        } else {
            self.currentSeriesId += 1
            seriesId = self.currentSeriesId
        }

        let attack = QueuedAttack()
        attack.attackerUnit = attacker
        attack.target = target
        attack.ranged = ranged
        attack.cityAttack = false
        attack.seriesId = seriesId
        self.queuedAttacks.append(attack)

        print("Queued attack with \(attacker?.name() ?? "--"), To \(target.target), From \(attacker?.location ?? HexPoint(x: -1, y: -1))")

        return rtnValue
    }
    
    /// Queue up the attack - return TRUE if first attack on this target
    func queueAttack(attacker: AbstractCity?, target: TacticalTarget?, ranged: Bool) -> Bool {
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        var rtnValue = true
        var seriesId = -1

        // Can we find this target in the queue, if so what is its series ID
        if let queuedAttack = self.isAlreadyTargeted(at: target.target) {
            seriesId = queuedAttack.seriesId
            rtnValue = false
        } else {
            self.currentSeriesId += 1
            seriesId = self.currentSeriesId
        }

        let attack = QueuedAttack()
        attack.attackerCity = attacker
        attack.target = target
        attack.ranged = ranged
        attack.cityAttack = false
        attack.seriesId = seriesId
        self.queuedAttacks.append(attack)

        print("Queued attack with \(attacker?.name ?? "--"), To \(target.target), From \(attacker?.location ?? HexPoint(x: -1, y: -1))")

        return rtnValue
    }
    
    /// Attack a defended space
    private func executeAttack(target: TacticalTarget?, targetPlot: AbstractTile?, inflictWhatWeTake: Bool, mustSurviveAttack: Bool, in gameModel: GameModel?) {
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        var firstAttacker: AbstractUnit? = nil
        var firstCity: AbstractCity? = nil
        var firstAttackRanged = false
        var firstAttackCity = false

        if self.isAlreadyTargeted(at: target.target) != nil {
            return
        }

        // How much damage do we still need to inflict?
        var damageRemaining = (target.damage * 150) / 100

        // Start by applying damage from city bombards
        for currentMoveCityRef in self.currentMoveCities {
            
            if let currentMoveCity = currentMoveCityRef {
                
                if damageRemaining <= 0 {
                    break
                }
            
                if currentMoveCity.city != nil {
                 
                    if self.queueAttack(attacker: currentMoveCity.city, target: target, ranged: true) {
                        
                        firstCity = currentMoveCity.city
                        firstAttackRanged = true
                        firstAttackCity = true
                    }
                    
                    // Subtract off expected damage
                    damageRemaining -= currentMoveCity.expectedTargetDamage
                }
            }
        }        

        // First loop is ranged units only
        for currentMoveUnitRef in self.currentMoveUnits {
        
            if damageRemaining <= 0 {
                break
            }
            
            if let currentMoveUnit = currentMoveUnitRef {
             
                if !inflictWhatWeTake || currentMoveUnit.expectedTargetDamage >= currentMoveUnit.expectedSelfDamage {
                    
                    if let unit = currentMoveUnit.unit {

                        if unit.moves() > 0 {
                            
                            if !mustSurviveAttack || ((currentMoveUnit.expectedSelfDamage + unit.damage()) < Int(Unit.maxHealth)) {
                                
                                // Are we a ranged unit
                                if unit.canAttackRanged() {
                                    
                                    // Are we in range?
                                    let dist = unit.location.distance(to: target.target)
                                    if dist <= unit.range() {
                                        
                                        // Do we have LOS line of sight to the target?
                                        if unit.canReach(at: target.target, in: dist, in: gameModel) {
                                            
                                            // Do we need to set up to make a ranged attack?
                                            /*if unit.canSetUpForRangedAttack(NULL) {
                                                unit.setSetUpForRangedAttack(true);
                                                print("Set up \(unit.name()) for ranged attack")

                                                if !unit.canMove() {
                                                    unit->SetTacticalAIPlot(NULL);
                                                    self.unitProcessed(pUnit->GetID());
                                                }
                                            }*/

                                            // Can we hit it with a ranged attack?  If so, that gets first priority
                                            if unit.canMove() && unit.canRangeStrike(at: target.target, needWar: true, noncombatAllowed: false) {
                                                
                                                // Queue up this attack
                                                if self.queueAttack(attacker: unit, target: target, ranged: true) {
                                                    
                                                    firstAttacker = unit
                                                    firstAttackRanged = true
                                                }
                                                
                                                unit.resetTacticalMove()
                                                self.unitProcessed(unit: currentMoveUnit.unit, in: gameModel)

                                                // Subtract off expected damage
                                                damageRemaining -= currentMoveUnit.expectedTargetDamage
                                            }
                                        }
                                    }
                                }
                            } else {
                                
                                print("Not attacking with unit. We'll destroy ourself.")
                            }
                        }
                    }
                    
                } else {
                    
                    print("Not attacking with unit. Can't generate a good damage ratio.")
                }
            }
        }

        // If target is city, want to get in one melee attack, so set damage remaining to 1
        if target.targetType == .city && damageRemaining < 1 {
            damageRemaining = 1
        }

        // Second loop are only melee units
        for currentMoveUnitRef in self.currentMoveUnits {
            
            if damageRemaining <= 0 {
                break
            }
            
            if let currentMoveUnit = currentMoveUnitRef {
            
                if !inflictWhatWeTake || currentMoveUnit.expectedTargetDamage >= currentMoveUnit.expectedSelfDamage {
                   
                    if let unit = currentMoveUnit.unit {
                    
                        if unit.moves() > 0 && (!mustSurviveAttack || ((currentMoveUnit.expectedSelfDamage + unit.damage()) < Int(Unit.maxHealth))) {
                            
                            // Are we a melee unit
                            if !unit.canAttackRanged() {
                                
                                // Queue up this attack
                                if self.queueAttack(attacker: unit, target: target, ranged: false) {
                                    firstAttacker = unit
                                }
                                unit.resetTacticalMove()
                                self.unitProcessed(unit: currentMoveUnit.unit, markTacticalMap: false, in: gameModel)

                                // Subtract off expected damage
                                damageRemaining -= currentMoveUnit.expectedTargetDamage
                            }
                        } else {
                            print("Not attacking with unit. We'll destroy ourself.")
                        }
                    
                    }
                }
            } else {
                print("Not attacking with unit. Can't generate a good damage ratio.")
            }
        }

        // Start up first attack
        if firstAttackCity && firstCity  != nil {
            self.launchAttack(for: firstCity, target: target, firstAttack: true, ranged: firstAttackRanged, in: gameModel)
        } else if !firstAttackCity && firstAttacker != nil {
            self.launchAttack(for: firstAttacker, target: target, firstAttack: true, ranged: firstAttackRanged, in: gameModel)
        } else {
            fatalError("no gonna happen")
        }
    }
    
    /// Remove a unit that we've allocated from list of units to move this turn
    private func unitProcessed(unit: AbstractUnit?, markTacticalMap: Bool = true, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }

        self.currentTurnUnits.removeAll(where: { unit.isEqual(to: $0) })

        unit.set(turnProcessed: true)

        if markTacticalMap {
            
            let map = gameModel.tacticalAnalysisMap()
            
            if map.isBuild {
                
                let cell = map.plots[unit.location]
                cell?.friendlyTurnEndTile = true
            }
        }
    }
    
    /// Pushes the mission to launch an attack and logs this activity
    private func launchAttack(for attacker: AbstractUnit?, target: TacticalTarget?, firstAttack: Bool, ranged: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = attacker else {
            fatalError("cant get attacker")
        }
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        let rangedStr = ranged ? "ranged " : ""
        if firstAttack {
            print("Made initial \(rangedStr) attack with \(unit.name()) towards \(target.target)")
        } else {
            print("Made follow-on \(rangedStr) attack with \(unit.name()) towards \(target.target)")
        }
        
        let sendAttack = unit.moves() > 0 && !unit.isOutOfAttacks()
        if sendAttack {
            
            if ranged && unit.domain() != .air  {
                // Air attack is ranged, but it goes through the 'move to' mission.
                unit.push(mission: UnitMission(type: .rangedAttack, at: target.target), in: gameModel)
            }
            //else if (pUnit->canNuke(NULL)) // NUKE tactical attack (ouch)
            //{
            //    pUnit->PushMission(CvTypes::getMISSION_NUKE(), pTarget->GetTargetX(), pTarget->GetTargetY());
            //}
            else {
                unit.push(mission: UnitMission(type: .moveTo, at: target.target), in: gameModel)
            }
        }

        // Make sure we did make an attack, if not we should take out this unit from the queue
        if !sendAttack || !unit.canMove() /*&& !pUnit->isFighting()*/ {
            unit.set(turnProcessed: false)
            self.combatResolved(for: attacker, victorious: false, in: gameModel)
        }
    }
    
    private func launchAttack(for attacker: AbstractCity?, target: TacticalTarget?, firstAttack: Bool, ranged: Bool, in gameModel: GameModel?) {
        
        guard let city = attacker else {
            fatalError("cant get city")
        }
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        let rangedStr = ranged ? "ranged " : ""
        let firstAttackStr = firstAttack ? "initial" : "follow-on"
        print("Made \(firstAttackStr) \(rangedStr) attack with \(city.name) towards \(target.target)")
        
        city.doTask(taskType: .rangedAttack, target: target.target, in: gameModel)
    }
    
    private func combatResolved(for attacker: AbstractUnit?, victorious: Bool, in gameModel: GameModel?) {
        
        var seriesId = 0
        var foundIt = false

        guard let unit = attacker else {
            fatalError("cant get attacker")
        }

        if self.queuedAttacks.count > 0 {
            
            //std::list<CvQueuedAttack>::iterator nextToErase, nextInList;
            //nextToErase = m_QueuedAttacks.begin();

            // Find first attack with this unit/city
            var index = 0
            for nextToErase in self.queuedAttacks {
                
                if unit.isEqual(to: nextToErase.attackerUnit) {
                    
                    seriesId = nextToErase.seriesId
                    foundIt = true
                    break
                }
                
                index += 1
            }

            // Couldn't find it ... could have been an accidental attack moving to deploy near a target
            // So safe to ignore these
            if !foundIt {
                return
            }

            // If this attacker gets multiple attacks, release him to be processed again
            /*if unit.canMoveAfterAttacking() && unit.moves() > 0 {
                
                unit.set(turnProcessed: false)
            }*/

            // If victorious, dump follow-up attacks
            if victorious {
                
                var first = true
                var queuedAttacksIterator = self.queuedAttacks.makeIterator()
                queuedAttacksIterator.skip(index)
                
                for nextToErase in queuedAttacksIterator {

                    if nextToErase.seriesId != seriesId {
                        break
                    }
                    
                    // Only the first unit being erased is done for the turn
                    if !first && !nextToErase.cityAttack {
                        
                        nextToErase.attackerUnit?.set(turnProcessed: false)
                    }
                    
                    first = false
                }
                
                self.queuedAttacks.removeAll(where: { $0.seriesId == seriesId })
                
            } else {
                // Otherwise look for a follow-up attack
                if index + 1 < self.queuedAttacks.count {
                    
                    let nextInList = self.queuedAttacks[index + 1]
                    if nextInList.seriesId == seriesId {
                        
                        // Calling LaunchAttack can be recursive if the launched combat is resolved immediately.
                        // We'll make a copy of the iterator's contents before erasing.  This is not technically needed because
                        // the current queue is a std::list and iterators don't invalidate on erase, but we'll be safe, in case
                        // the container type changes.
                        if nextInList.cityAttack {
                            self.launchAttack(for: nextInList.attackerCity, target: nextInList.target, firstAttack: false, ranged: nextInList.ranged, in: gameModel)
                        } else {
                            self.launchAttack(for: nextInList.attackerUnit, target: nextInList.target, firstAttack: false, ranged: nextInList.ranged, in: gameModel)
                        }
                    }
                    
                    self.queuedAttacks.remove(at: index + 1)
                }

            }
        }
    }
    
    /// Find the first target of a requested type in current dominance zone (call after ExtractTargetsForZone())
    private func zoneTargets(for targetType: TacticalTargetType) -> [TacticalTarget?] {
        
        var tempTargets: [TacticalTarget?] = []
        for zoneTarget in self.zoneTargets {
            
            if targetType == .none || zoneTarget.targetType == targetType {
                tempTargets.append(zoneTarget)
            }
        }
        
        return tempTargets
    }
    
    /// Choose which tactics the barbarians should emphasize this turn
    private func establishBarbarianPriorities(in turn: Int) {
        
        // Only establish priorities once per turn
        if turn <= self.movePriotityTurn {
            return
        }
        
        self.movePriorityList.removeAll()
        self.movePriotityTurn = turn
        
        // Loop through each possible tactical move (other than "none" or "unassigned")
        for barbarianTacticalMove in TacticalMoveType.allBarbarianMoves {
            
            var priority = barbarianTacticalMove.priority()
            
            // Make sure base priority is not negative
            if priority >= 0 {
                
                // Finally, add a random die roll to each priority
                priority += Int.random(in: -2...2) /* AI_TACTICAL_MOVE_PRIORITY_RANDOMNESS */

                // Store off this move and priority
                let move = TacticalMove()
                move.moveType = barbarianTacticalMove
                move.priority = priority
                self.movePriorityList.append(move)
            }
        }
        
        self.movePriorityList.sort()
    }
    
    /// Choose which tactics to emphasize this turn
    private func establishTacticalPriorities() {
        
        self.movePriorityList.removeAll()
        
        for tacticalMove in TacticalMoveType.allPlayerMoves {
            
            var priority = tacticalMove.priority()
            
            // Make sure base priority is not negative
            if priority >= 0 {
                
                // Finally, add a random die roll to each priority
                priority += Int.random(in: -2...2) /* AI_TACTICAL_MOVE_PRIORITY_RANDOMNESS */

                // Store off this move and priority
                let move = TacticalMove()
                move.moveType = tacticalMove
                move.priority = priority
                self.movePriorityList.append(move)
            }
        }
        
        // Loop through each possible tactical move
        self.movePriorityList.sort()
    }
    
    /// Establish postures for each dominance zone (taking into account last posture)
    private func updatePostures(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        let tacticalAnalysisMap = gameModel.tacticalAnalysisMap()
        
        var newPostures: [TacticalPosture] = []
        
        for dominanceZone in tacticalAnalysisMap.dominanceZones {
            
            // Check to make sure we want to use this zone
            if self.useThis(dominanceZone: dominanceZone) {
                
                let lastPostureType = self.findPostureType(for: dominanceZone)
                let newPostureType = self.selectPostureType(for: dominanceZone, old: lastPostureType, dominancePercentage: tacticalAnalysisMap.dominancePercentage)
                
                let posture = TacticalPosture(of: newPostureType, for: dominanceZone.owner, in: dominanceZone.closestCity, isWater: dominanceZone.isWater)
                newPostures.append(posture)
            }
        }
        
        self.postures = newPostures
    }
    
    /// Do we want to process moves for this dominance zone?
    private func useThis(dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?) -> Bool {
        
        guard let dominanceZone = dominanceZone else {
            fatalError("cant get dominanceZone")
        }
        
        var isOurCapital = false
        //int iCityID = -1;
        
        if let city = dominanceZone.closestCity {
            isOurCapital = self.player?.leader == city.player?.leader && city.isCapital()
        }

        return (isOurCapital || dominanceZone.rangeClosestEnemyUnit <= (TacticalAI.recruitRange / 2) ||
            (dominanceZone.dominanceFlag != .noUnitsPresent && dominanceZone.dominanceFlag != .notVisible))
    }
    
    /// Sift through the target list and find just those that apply to the dominance zone we are currently looking at
    private func extractTargets(for dominanceZone: TacticalAnalysisMap.TacticalDominanceZone? = nil) {
        
        self.zoneTargets.removeAll()
        
        for target in self.allTargets {
            
            var valid = false
            
            if let dominanceZone = dominanceZone {
            
                let domain: UnitDomainType = dominanceZone.isWater ? .sea : .land
                valid = target.isTargetValidIn(domain: domain)
                
            } else {
                valid = true
            }
            
            if valid {
             
                if dominanceZone == nil || dominanceZone == target.dominanceZone {
                 
                    self.zoneTargets.append(target)
                    
                } else {
                    // Not obviously in this zone, but if within 2 of city we want them anyway
                    if let city = dominanceZone?.closestCity {
                    
                        if target.target.distance(to: city.location) <= 2 {
                            self.zoneTargets.append(target)
                        }
                    }
                }
            }
        }
        
        // print("targets extracted: \(self.zoneTargets.count)")
    }
    
    /// Find last posture for a specific zone
    private func findPostureType(for dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?) -> TacticalPostureType {
        
        guard let player = self.player else {
            fatalError("cant get leader")
        }
        
        guard let dominanceZone = dominanceZone else {
            return TacticalPostureType.none
        }
        
        guard let closestCity = dominanceZone.closestCity else {
            return TacticalPostureType.none
        }
        
        if let posture = self.postures.first(where: { player.isEqual(to: $0.player) && $0.isWater == dominanceZone.isWater && $0.city?.location == closestCity.location }) {
                
            return posture.type
        }
        
        return TacticalPostureType.none
    }
    
    /// Select a posture for a specific zone
    private func selectPostureType(for dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?, old lastPosture: TacticalPostureType, dominancePercentage: Int) -> TacticalPostureType {
        
        guard let dominanceZone = dominanceZone else {
            fatalError("cant get dominanceZone")
        }
        
        var chosenPosture: TacticalPostureType = .none
        var rangedDominance: TacticalDominanceType = .even
        var unitCountDominance: TacticalDominanceType = .even
        
        // Compute who is dominant in various areas
        //   Ranged strength
        if dominanceZone.enemyRangedStrength <= 0 {
            rangedDominance = .friendly
        } else {
            
            let ratio = dominanceZone.friendlyRangedStrength * 100 / dominanceZone.enemyRangedStrength
            if ratio > 100 + dominancePercentage {
                rangedDominance = .friendly
            } else if ratio < 100 - dominancePercentage {
                rangedDominance = .enemy
            }
        }
        
        //   Number of units
        if dominanceZone.enemyUnitCount <= 0 {
            unitCountDominance = .friendly
        } else {
            
            let ratio = dominanceZone.friendlyUnitCount * 100 / dominanceZone.enemyUnitCount
            if ratio > 100 + dominancePercentage {
                unitCountDominance = .friendly
            } else if ratio < 100 - dominancePercentage {
                unitCountDominance = .enemy
            }
        }
        
        // Choice based on whose territory this is
        switch dominanceZone.territoryType {
            
        
        case .enemy:
            
            if dominanceZone.dominanceFlag == .enemy || dominanceZone.friendlyRangedUnitCount == dominanceZone.friendlyUnitCount {
                // Always withdraw if enemy dominant overall
                chosenPosture = .withdraw
            } else if dominanceZone.enemyUnitCount > 0 && dominanceZone.dominanceFlag == .friendly &&
                (rangedDominance != .enemy || dominanceZone.friendlyStrength > dominanceZone.enemyStrength * 2) {
                // Destroy units then assault - for first time need dominance in total strength but not enemy dominance in ranged units OR just double total strength
                chosenPosture = .steamRoll
            } else if lastPosture == .steamRoll && dominanceZone.dominanceFlag == .friendly && dominanceZone.enemyUnitCount > 0 {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .steamRoll
            } else if rangedDominance == .friendly && unitCountDominance != .enemy {
                // Sit and bombard - for first time need dominance in ranged strength and total unit count
                chosenPosture = .sitAndBombard
            } else if lastPosture == .sitAndBombard && rangedDominance != .enemy && unitCountDominance != .enemy {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .sitAndBombard
            } else if dominanceZone.dominanceFlag == .friendly {
                // Go right after the city - need tactical dominance
                chosenPosture = .surgicalCityStrike
            } else if unitCountDominance == .friendly && dominanceZone.enemyUnitCount > 1 {
                // Exploit flanks - for first time need dominance in unit count
                chosenPosture = .exploitFlanks
            } else if lastPosture == .exploitFlanks && unitCountDominance != .enemy && dominanceZone.enemyUnitCount > 1 {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .exploitFlanks
            } else {
                // Default for this zone
                chosenPosture = .surgicalCityStrike
            }
        
        case .neutral, .noOwner:
            if rangedDominance == .friendly && unitCountDominance != .enemy {
                chosenPosture = .attritFromRange
            } else if lastPosture == .attritFromRange && rangedDominance != .enemy {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .attritFromRange
            } else if unitCountDominance == .friendly && dominanceZone.enemyUnitCount > 0 {
                // Exploit flanks - for first time need dominance in unit count
                chosenPosture = .exploitFlanks
            } else if lastPosture == .exploitFlanks && unitCountDominance != .enemy && dominanceZone.enemyUnitCount > 0 {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .exploitFlanks
            } else {
                // Default for this zone
                chosenPosture = .exploitFlanks
            }
            
        case .friendly:
            if rangedDominance == .friendly && dominanceZone.friendlyRangedUnitCount > 1 {
                chosenPosture = .attritFromRange
            } else if lastPosture == .attritFromRange && dominanceZone.friendlyRangedUnitCount > 1 && rangedDominance != .enemy {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .attritFromRange
            } else if unitCountDominance == .friendly && dominanceZone.enemyUnitCount > 0 {
                // Exploit flanks - for first time need dominance in unit count
                chosenPosture = .exploitFlanks
            } else if lastPosture == .exploitFlanks && unitCountDominance != .enemy && dominanceZone.enemyUnitCount > 0 {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .exploitFlanks
            } else if dominanceZone.dominanceFlag == .friendly || dominanceZone.dominanceFlag == .even && rangedDominance == .enemy {
                // Counterattack - for first time must be stronger or even with enemy having a ranged advantage
                chosenPosture = .counterAttack
            } else if lastPosture == .counterAttack && dominanceZone.dominanceFlag != .enemy {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .counterAttack
            } else {
                // Default for this zone
                chosenPosture = .hedgehog
            }
            
            
        case .tempZone:
            // Land or water?
            if dominanceZone.isWater {
                chosenPosture = .shoreBombardment
            } else {
                // Should be a barbarian camp
                chosenPosture = .exploitFlanks
            }
        }
        
        return chosenPosture
    }

    /// Make lists of everything we might want to target with the tactical AI this turn
    private func findTacticalTargets(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        guard let dangerPlotsAI = player.dangerPlotsAI else {
            fatalError("cant get dangerPlotsAI")
        }

        // Clear out target list since we rebuild it each turn
        self.allTargets.removeAll()

        let barbsAllowedYet = gameModel.currentTurn >= 20
        let mapSize = gameModel.mapSize()

        // Look at every tile on map
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let point = HexPoint(x: x, y: y)
                var validPlot = false
                if let tile = gameModel.tile(at: point) {

                    if tile.isVisible(to: player) {

                        // Make sure I am not a barbarian who can not move into owned territory this early in the game
                        if self.player?.leader != .barbar || barbsAllowedYet {

                            validPlot = true
                        } else {
                            if !tile.hasOwner() {
                                validPlot = true
                            }
                        }

                        if validPlot {
                            if self.isAlreadyTargeted(at: point) != nil {
                                validPlot = false
                            }
                        }
                    }

                    if validPlot {

                        let newTarget = TacticalTarget(
                            targetType: .none,
                            target: point,
                            targetLeader: .none,
                            dominanceZone: gameModel.tacticalAnalysisMap().plots[point]?.dominanceZone)

                        let enemyDominatedPlot = gameModel.tacticalAnalysisMap().isInEnemyDominatedZone(at: point)

                        // Have a ...
                        
                        let cityRef = gameModel.city(at: tile.point)

                        if let city = cityRef {

                            if self.player?.leader == city.player?.leader {

                                // ... friendly city?
                                newTarget.targetType = .cityToDefend
                                newTarget.city = cityRef
                                newTarget.threatValue = city.threatValue()
                                self.allTargets.append(newTarget)

                                
                            } else if diplomacyAI.isAtWar(with: city.player) {

                                // ... enemy city
                                newTarget.targetType = .city
                                newTarget.city = cityRef
                                newTarget.threatValue = city.threatValue()
                                self.allTargets.append(newTarget)
                            }
                        } else {
                            
                            let unitRef = gameModel.unit(at: tile.point)
                            if let unit = unitRef {
                                if diplomacyAI.isAtWar(with: unit.player) {
                                    
                                    // ... enemy unit?
                                    newTarget.targetType = .lowPriorityUnit
                                    newTarget.targetLeader = unit.player!.leader
                                    newTarget.unit = unitRef
                                    newTarget.damage = unit.damage()
                                    self.allTargets.append(newTarget)
                                }

                            } else if tile.has(improvement: .barbarianCamp) {

                                // ... undefended camp?
                                newTarget.targetType = .barbarianCamp
                                newTarget.targetLeader = .barbar
                                newTarget.tile = tile
                                self.allTargets.append(newTarget)

                            } else if tile.has(improvement: .goodyHut) {

                                // ... goody hut?
                                newTarget.targetType = .ancientRuins
                                newTarget.tile = tile
                                self.allTargets.append(newTarget)

                            } else if diplomacyAI.isAtWar(with: tile.owner()) && !tile.has(improvement: .none) && !tile.canBePillaged() &&
                                !tile.has(resource: .none, for: player) && !enemyDominatedPlot {
                                
                                // ... enemy resource improvement?

                                // On land, civs only target improvements built on resources
                                if tile.has(resourceType: .strategic, for: player) || tile.has(resourceType: .luxury, for: player) || tile.terrain().isWater() || player.leader == .barbar {

                                    if tile.terrain().isWater() && player.leader == .barbar {

                                        continue
                                    } else {

                                        newTarget.targetType = .improvement
                                        newTarget.targetLeader = tile.owner()!.leader
                                        newTarget.tile = tile
                                        self.allTargets.append(newTarget)
                                    }
                                }

                                // Or forts / citadels!
                            } else if diplomacyAI.isAtWar(with: tile.owner()) && (tile.has(improvement: .fort) && tile.has(improvement: .citadelle)) {
                                newTarget.targetType = .improvement
                                newTarget.targetLeader = tile.owner()!.leader
                                newTarget.tile = tile
                                self.allTargets.append(newTarget)


                                // ... enemy civilian (or embarked) unit?
                            } else if unitRef?.player?.leader != player.leader {

                                if let unit = unitRef {

                                    if diplomacyAI.isAtWar(with: unit.player) && !unit.canDefend() {

                                        newTarget.targetType = .lowPriorityUnit
                                        newTarget.targetLeader = unit.player!.leader
                                        newTarget.unit = unit

                                        if unit.isEmbarked() {

                                            if unit.isCombatUnit() {
                                                newTarget.targetType = .embarkedMilitaryUnit
                                            } else {
                                                newTarget.targetType = .embarkedCivilian
                                            }
                                        } else {

                                            if self.isVeryHighPriorityCivilian(target: newTarget) {

                                                newTarget.targetType = .veryHighPriorityCivilian //(AI_TACTICAL_TARGET_VERY_HIGH_PRIORITY_CIVILIAN);
                                            } else if self.isHighPriorityCivilian(target: newTarget, in: gameModel.currentTurn, numCities: gameModel.cities(of: player).count) {

                                                newTarget.targetType = .highPriorityCivilian
                                            } else if self.isMediumPriorityCivilian(target: newTarget, in: gameModel.currentTurn) {
                                                newTarget.targetType = .mediumPriorityCivilian
                                            }
                                        }

                                        self.allTargets.append(newTarget)
                                    }

                                    
                                } else if player.leader == tile.owner()?.leader && tile.defenseModifier(for: player) > 0 &&
                                    dangerPlotsAI.danger(at: point) > 0.0 {
                                    
                                    // ... defensive bastion?
                                    if let defenseCity = gameModel.friendlyCityAdjacent(to: point, for: player) {
                                        
                                        newTarget.targetType = .defensiveBastion
                                        newTarget.tile = tile
                                        newTarget.threatValue = defenseCity.threatValue() + Int(dangerPlotsAI.danger(at: point))
                                        self.allTargets.append(newTarget)
                                    }
                                    
                                    
                                } else if player.leader == tile.owner()?.leader && !tile.has(improvement: .none) && !tile.has(improvement: .goodyHut) && tile.canBePillaged() {
                                    // ... friendly improvement?
                                
                                    newTarget.targetType = .improvementToDefend
                                    newTarget.tile = tile
                                    self.allTargets.append(newTarget)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // POST-PROCESSING ON TARGETS

        // Mark enemy units threatening our cities (or camps) as priority targets
        if player.leader == .barbar {
            self.identifyPriorityBarbarianTargets(in: gameModel)
        } else {
            self.identifyPriorityTargets(in: gameModel)
        }

        // Also add some priority targets that we'd like to hit just because of their unit type (e.g. catapults)
        self.identifyPriorityTargetsByType(in: gameModel)

        // Remove extra targets
        self.eliminateNearbyBlockadePoints()

        // Sort remaining targets by aux data (if used for that target type)
        self.allTargets.sort(by: { $0.threatValue > $1.threatValue })
    }
    
    /// Mark units that we'd like to make opportunity attacks on because of their unit type (e.g. catapults)
    private func identifyPriorityTargetsByType(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // Look through all the enemies we can see
        for target in self.allTargets {
            
            // Don't consider units that are already medium priority
            if target.targetType == .highPriorityUnit || target.targetType == .lowPriorityUnit {
                
                // Ranged units will always be medium priority targets
                if let unit = target.unit {
                    
                    if unit.canAttackRanged() {
                        target.targetType = .mediumPriorityUnit
                    }
                }
            }
            
            // Don't consider units that are already high priority
            if target.targetType == .mediumPriorityUnit || target.targetType == .lowPriorityUnit {
                
                if let unit = target.unit, let tile = gameModel.tile(at: unit.location) {
                    
                    // Units defending citadels will always be high priority targets
                    if tile.has(improvement: .fort) || tile.has(improvement: .citadelle) {
                        target.targetType = .highPriorityUnit
                    }
                }
            }
        }
    }
    
    /// Don't allow tiles within 2 to both be blockade points
    private func eliminateNearbyBlockadePoints() {
        
        //fatalError("not implemented yet")
        
        /*// First, sort the sentry points by priority
        self.naval
        std::stable_sort(m_NavalResourceBlockadePoints.begin(), m_NavalResourceBlockadePoints.end());

        // Create temporary copy of list
        TacticalList tempPoints;
        tempPoints = m_NavalResourceBlockadePoints;

        // Clear out main list
        m_NavalResourceBlockadePoints.clear();

        // Loop through all points in copy
        TacticalList::iterator it, it2;
        for (it = tempPoints.begin(); it != tempPoints.end(); ++it)
        {
            bool bFoundAdjacent = false;

            // Is it adjacent to a point in the main list?
            for (it2 = m_NavalResourceBlockadePoints.begin(); it2 != m_NavalResourceBlockadePoints.end(); ++it2)
            {
                if (plotDistance(it->GetTargetX(), it->GetTargetY(), it2->GetTargetX(), it2->GetTargetY()) <= 2)
                {
                    bFoundAdjacent = true;
                    break;
                }
            }

            if (!bFoundAdjacent)
            {
                m_NavalResourceBlockadePoints.push_back(*it);
            }
        }

        // Now copy all points into main target list
        for (it = m_NavalResourceBlockadePoints.begin(); it != m_NavalResourceBlockadePoints.end(); ++it)
        {
            m_AllTargets.push_back(*it);
        } */
    }
    
    /// Mark units that can damage key items as priority targets
    private func identifyPriorityTargets(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        // Loop through each of our cities
        for cityRef in gameModel.cities(of: player) {
            
            if let city = cityRef {
                
                var possibleAttackers: [TacticalTarget] = []
                var expectedTotalDamage = 0
                
                for unitTargetRef in self.unitTargets() {
                    
                    if let unitTarget = unitTargetRef, let tile = unitTargetRef?.tile {
                        if let enemyUnit = gameModel.visibleEnemy(at: unitTarget.target, for: self.player) {
                    
                            var expectedDamage = 0
                            
                            if enemyUnit.canAttackRanged() && enemyUnit.rangedCombatStrength(against: nil, or: city, on: tile, attacking: true, in: gameModel) > enemyUnit.attackStrength(against: nil, or: city, on: tile, in: gameModel) {
                            
                                if enemyUnit.location.distance(to: city.location) <= enemyUnit.range() {
                                    
                                    let combatResult = Combat.predictRangedAttack(between: enemyUnit, and: cityRef, in: gameModel)
                                    expectedDamage = combatResult.defenderDamage
                                }
                                
                            } else if enemyUnit.canReach(at: city.location, in: 1, in: gameModel) {
                                
                                let combatResult = Combat.predictMeleeAttack(between: enemyUnit, and: cityRef, in: gameModel)
                                
                                // FIXME: add fire support
                                
                                expectedDamage = combatResult.defenderDamage
                            }
                            
                            if expectedDamage > 0 {
                                expectedTotalDamage += expectedDamage
                                possibleAttackers.append(unitTarget)
                            }
                        }
                    }
                }
                
                // If they can take the city down and they are a melee unit, then they are a high priority target
                if expectedTotalDamage > (city.maxHealthPoints() - city.damage()) {
                    
                    var attackerIndex = 0

                    // Loop until we've found all the attackers in the unit target list
                    for unitTargetRef in self.unitTargets() {
                        
                        if attackerIndex >= possibleAttackers.count {
                            break
                        }
                        
                        if let unitTarget = unitTargetRef {
                            
                            // Match based on X, Y
                            if unitTarget.target == possibleAttackers[attackerIndex].target {
                                
                                if let enemyUnit = gameModel.visibleEnemy(at: unitTarget.target, for: self.player) {
                                    
                                    if enemyUnit.canAttackRanged() {
                                        unitTargetRef?.targetType = .mediumPriorityUnit
                                    } else {
                                        unitTargetRef?.targetType = .highPriorityUnit
                                    }
                                }
                                
                                attackerIndex += 1
                            }
                        }
                    }
                }

                // If they can damage a city they are a medium priority target
                else if possibleAttackers.count > 0 {
                    
                    var attackerIndex = 0

                    // Loop until we've found all the attackers in the unit target list
                    for unitTargetRef in self.unitTargets() {
                    
                        if attackerIndex >= possibleAttackers.count {
                            break
                        }
                    
                        if let unitTarget = unitTargetRef {
                        
                            // Match based on X, Y
                            if unitTarget.target == possibleAttackers[attackerIndex].target {
                                
                                if unitTarget.targetType != .highPriorityUnit {
                                
                                    unitTargetRef?.targetType = .mediumPriorityUnit
                                }
                                
                                attackerIndex += 1
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Mark units that can damage our barbarian camps as priority targets
    private func identifyPriorityBarbarianTargets(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        let mapSize = gameModel.mapSize()
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                
                let point = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: point) {
                    
                    if tile.has(improvement: .barbarianCamp) {
                        
                        for unitTargetRef in self.unitTargets() {
                            
                            if let unitTarget = unitTargetRef {
                                var priorityTarget = false
                                if unitTarget.targetType != .highPriorityUnit {
                                    
                                    if let enemyUnit = gameModel.visibleEnemy(at: unitTarget.target, for: self.player) {
                                        
                                        if enemyUnit.canAttackRanged() && enemyUnit.rangedCombatStrength(against: nil, or: nil, on: tile, attacking: true, in: gameModel) > enemyUnit.attackStrength(against: nil, or: nil, on: tile, in: gameModel) {
                                            
                                            if enemyUnit.location.distance(to: point) <= enemyUnit.range() {
                                                priorityTarget = true
                                            }
                                        } else if enemyUnit.canReach(at: point, in: 1, in: gameModel) {
                                            priorityTarget = true
                                        }
                                        
                                        if priorityTarget {
                                            unitTarget.targetType = .highPriorityUnit
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
    
    private func unitTargets() -> [TacticalTarget?] {
        
        var list: [TacticalTarget?] = []
        
        for target in self.allTargets {
            if target.targetType == .lowPriorityUnit || target.targetType == .mediumPriorityUnit || target.targetType == .highPriorityUnit {
                list.append(target)
            }
        }
        
        return list
    }
    
    /// Do we already have a queued attack running on this plot? Return series ID if yes, -1 if no.
    func isAlreadyTargeted(at point: HexPoint) -> QueuedAttack? {
        
        if self.queuedAttacks.count > 0 {
            
            for queuedAttack in self.queuedAttacks {
                
                if let target = queuedAttack.target {
                    if target.target == point {
                        return queuedAttack
                    }
                }
            }
        }
        
        return nil
    }

    /// Is this civilian target of the highest priority?
    func isVeryHighPriorityCivilian(target: TacticalTarget) -> Bool {

        if let unit = target.unit {
            if unit.has(task: .general) {
                return true
            }
        }

        return false
    }

    /// Is this civilian target of high priority?
    func isHighPriorityCivilian(target: TacticalTarget, in turn: Int, numCities: Int) -> Bool {

        var returnValue = false

        if let unit = target.unit {

            if unit.civilianAttackPriority() == .high {
                returnValue = true
            } else if unit.civilianAttackPriority() == .highEarlyGameOnly {
                if turn < 50 {
                    returnValue = true
                }
            }

            if returnValue == false && unit.task() == .settle {

                if numCities < 5 {
                    returnValue = true
                } else if turn < 50 {
                    returnValue = true
                }
            }

            if returnValue == false && player?.leader == .barbar {
                //always high priority for barbs
                returnValue = true
            }
        }

        return returnValue
    }
    
    /// Is this civilian target of medium priority?
    func isMediumPriorityCivilian(target: TacticalTarget, in turn: Int) -> Bool {
        
        if let unit = target.unit {
        
            //embarked civilians
            if unit.isEmbarked() && !unit.isCombatUnit() {
                return true
            } else if unit.task() == .settle && turn >= 50 {
                return true
            } else if unit.task() == .work && turn < 50 { //early game?
                return true
            }
        }
        
        return false
    }
        
    /// Add a temporary dominance zone around a short-term target
    func add(temporaryZone: TemporaryZone) {

        self.temporaryZones.append(temporaryZone)
    }

    /// Remove temporary zones that have expired
    /// FIXME: rename to update
    func dropObsoleteZones(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        self.temporaryZones = self.temporaryZones.filter({ $0.lastTurn < gameModel.currentTurn })
    }

/// Remove a temporary dominance zone we no longer need to track
    func deleteTemporaryZone(at location: HexPoint) {

        self.temporaryZones = self.temporaryZones.filter({ $0.location != location })
    }

/// Is this a city that an operation just deployed in front of?
    func isTemporaryZone(a city: AbstractCity?) -> Bool {

        guard let city = city else {
            fatalError("cant get city")
        }

        for temporaryZone in self.temporaryZones {

            if temporaryZone.location == city.location && temporaryZone.targetType == .city {
                return true
            }
        }

        return false
    }
}
