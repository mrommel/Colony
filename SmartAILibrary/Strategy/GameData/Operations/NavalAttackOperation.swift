//
//  NavalAttackOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationNavalAttack
//!  \brief        Attack a city from the sea
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class NavalAttackOperation: NavalEscortedOperation {
    
    init() {
        
        super.init(type: .navalAttack)
        
        self.civilianType = .none
    }
    
    override init(type: UnitOperationType) {
        
        super.init(type: type)
        
        self.civilianType = .none
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func formation(in gameModel: GameModel?) -> UnitFormationType {
        
        return .navalInvasion // MUFORMATION_NAVAL_INVASION
    }
    
    override func isCivilianRequired() -> Bool {
        
        return false
    }
    
    /// Kick off this operation
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {

        super.initialize(for: player, enemy: enemy, area: area, in: gameModel)
        
        self.moveType = .navalEscort
        self.startPosition = muster?.location ?? HexPoint.invalid

        if let target = target {
            
            self.targetPosition = target.location

            // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
            self.army = Army(of: self.player, for: self, with: self.formation(in: gameModel))
            self.army?.state = .waitingForUnitsToReinforce

            self.army?.goal = target.location

            self.musterPosition = muster?.location ?? HexPoint.invalid
            self.army?.position = muster?.location ?? HexPoint.invalid

            self.buildListOfUnitsWeStillNeedToBuild()

            // Try to get as many units as possible from existing units that are waiting around
            if self.grabUnitsFromTheReserves(at: muster?.location ?? HexPoint.invalid, for: nil, in: gameModel) {
                self.army?.state = .waitingForUnitsToCatchUp
                self.state = .gatheringForces
            } else {
                self.state = .recruitingUnits
            }
            // LogOperationStart();
            
        } else {
            // Lost our target, abort
            self.state = .aborted(reason: .lostTarget)
        }
    }

    /// Always abort if settler is removed
    override func unitWasRemoved(from army: Army?, slotID: Int) {
        
        // Call root class version
        return super.unitWasRemoved(from: army, slotID: slotID)
    }

    /// If at target, found city; if at muster point, merge settler and escort and move out
    override func armyInPosition(in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        switch self.state {
            // See if reached our target, if so give control of these units to the tactical AI
        case .movingToTarget:
        
            if let centerOfMass = self.army?.centerOfMass(in: gameModel) {
                
                // Are we within tactical range of our target? (larger than usual range for a naval attack)
                if centerOfMass.distance(to: self.targetPosition!) <= 4 /* AI_OPERATIONAL_CITY_ATTACK_DEPLOY_RANGE */ * 2 {
                    
                    // Notify Diplo AI we're in place for attack
                    self.player?.diplomacyAI?.updateMusteringForAttack(against: self.enemy, to: true)

                    // Notify tactical AI to focus on this area
                    let zone = TacticalAI.TemporaryZone(location: self.targetPosition!, lastTurn: gameModel.currentTurn + 5 /* AI_TACTICAL_MAP_TEMP_ZONE_TURNS */, targetType: .city, navalMission: true)
                    self.player?.tacticalAI?.add(temporaryZone: zone)

                    self.state = .successful
                    return true
                }
            }

        // In all other cases use base class version
        case .gatheringForces, .aborted(reason: _), .recruitingUnits, .atTarget:
            return super.armyInPosition(in: gameModel)
            
        default:
            // NOOP
        break
        }

        return false
    }

    /// Find the port our operation will leave from
    override func operationStartCity(in gameModel: GameModel?) -> AbstractCity? {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        if let startPosition = self.startPosition {
            return gameModel.city(at: startPosition)
        }

        return self.player?.militaryAI?.nearestCoastalCity(towards: self.enemy, in: gameModel)
    }

    /// Find the city we want to attack
    override func findBestTarget(for unit: AbstractUnit?, in gameModel: GameModel?) -> AbstractTile? {
        
        fatalError("Obsolete function called CvAIOperationNavalAttack::FindBestTarget()")
    }
}
