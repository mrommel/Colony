//
//  FoundCityOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationFoundCity
//!  \brief        Find a place to utilize a new settler
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class FoundCityOperation: EscortedOperation {

    init() {

        super.init(type: .foundCity, escorted: true, civilianType: .settle)
    }
    
    init(type: UnitOperationType) {

        super.init(type: type, escorted: true, civilianType: .settle)
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {

        guard let gameModel = gameModel,
            let player = self.player else {
                
            fatalError("cant get values")
        }
        
        super.initialize(for: player, enemy: enemy, area: area, target: target, muster: muster, in: gameModel)
        
        self.moveType = .singleHex
        
        // Find the free civilian (that triggered this operation)
        if let ourCivilian = self.findBestCivilian(in: gameModel) {
            
            // Find a destination (not worrying about safe paths)
            if let targetSite = self.findBestTarget(for: ourCivilian, onlySafePaths: false, in: gameModel) {
                
                self.targetPosition = targetSite.point
                self.musterPosition = ourCivilian.location
                self.area = gameModel.area(of: ourCivilian.location)

                // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
                self.army = Army(of: self.player, for: nil, with: self.formation(in: gameModel))
                self.army?.state = .waitingForUnitsToReinforce
                
                // Figure out the initial rally point - for this operation it is wherever our civilian is standing
                self.army?.goal = targetSite.point
                self.army?.muster = ourCivilian.location

                // Add the settler to our army
                self.army?.add(unit: ourCivilian, to: 0)

                // Add the escort as a unit we need to build
                self.listOfUnitsWeStillNeedToBuild.removeAll()
                    
                let slot = self.army!.formation.slots()[1]
                let thisOperationSlot = OperationSlot(operation: self, army: self.army, slot: slot, slotIndex: 1)
                self.listOfUnitsWeStillNeedToBuild.append(thisOperationSlot)

                // try to get the escort from existing units that are waiting around
                self.grabUnitsFromTheReserves(at: self.musterPosition, for: self.targetPosition, in: gameModel)
                    
                if self.army!.numOfSlotsFilled() > 1 {
                    self.army?.state = .waitingForUnitsToCatchUp
                    self.state = .gatheringForces
                } else {
                    
                    var newTarget: AbstractTile? = nil
                    
                    // There was no escort immediately available.  Let's look for a "safe" city site instead
                    if self.player == nil || gameModel.cities(of: player).count > 1 || player.leader.trait(for: .boldness) > 5 {
                        // unless we'd rather play it safe
                        newTarget = self.findBestTarget(for: ourCivilian, onlySafePaths: true, in: gameModel)
                    }

                    // If no better target, we'll wait it out for an escort
                    if newTarget == nil {
                        // Need to add it back in to list of what to build (was cleared before since marked optional)
                        self.listOfUnitsWeStillNeedToBuild.removeAll()
                        
                        let slot2 = self.army!.formation.slots()[1]
                        let thisOperationSlot2 = OperationSlot(operation: self, army: self.army, slot: slot2, slotIndex: 1)
                        self.listOfUnitsWeStillNeedToBuild.append(thisOperationSlot2)
                        self.state = .recruitingUnits
                    } else {
                        // Send the settler by himself to this safe location
                        self.escorted = false

                        // Clear the list of units we need
                        self.listOfUnitsWeStillNeedToBuild.removeAll()

                        // Change the muster point
                        self.army?.goal = newTarget!.point
                        self.musterPosition = ourCivilian.location
                        
                        self.army?.position = musterPosition!

                        // Send the settler directly to the target
                        self.army?.state = .movingToDestination
                        self.state = .movingToTarget
                    }
                }
                
                //LogOperationStart();
                
            } else {
                // Lost our target, abort
                self.state = .aborted(reason: .lostTarget)
            }
        }
    }
    
    override func formation(in gameModel: GameModel?) -> UnitFormationType {
        
        return .settlerEscort // MUFORMATION_SETTLER_ESCORT
    }

    /// If at target, found city; if at muster point, merge settler and escort and move out
    override func armyInPosition(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("can get gameModel")
        }

        switch self.state {

        case .none:
            // NOOP
            break
        case .aborted(_):

            // In all other cases use base class version
            return super.armyInPosition(in: gameModel)

        case .recruitingUnits:

            // In all other cases use base class version
            return super.armyInPosition(in: gameModel)

        case .gatheringForces:
            // If we were gathering forces, we have to insist that any escort is in the same plot as the settler.
            // If not we'll fall through and just stay in this state.

            // No escort, can just let base class handle it
            if !self.escorted {
                return super.armyInPosition(in: gameModel)
            }

            let settler = self.army?.unit(at: 0)
            let escort = self.army?.unit(at: 1)

            if escort == nil {
                // Escort died while gathering forces.  Abort (and return TRUE since state changed)
                self.state = .aborted(reason: .escortDied)
                return true
            }

            if escort != nil && settler != nil && escort!.location == settler!.location {

                // let's see if the target still makes sense (this is modified from RetargetCivilian)
                let betterTarget = self.findBestTarget(for: settler, in: gameModel)

                // No targets at all!  Abort
                if betterTarget == nil {
                    self.state = .aborted(reason: .noTarget)
                    return false
                }

                // If we have a target
                self.updateTarget(to: betterTarget)
                self.army?.goal = betterTarget!.point

                return super.armyInPosition(in: gameModel)
            }

        case .movingToTarget, .atTarget:

            // Call base class version and see, if it thinks we're done
            let stateChanged = super.armyInPosition(in: gameModel)

            // Now get the settler
            if let settler = self.army?.unit(at: 0) {

                guard let targetPosition = self.targetPosition else {
                    fatalError("cant get targetPosition")
                }

                let targetOwner = gameModel.tile(at: targetPosition)?.owner()

                // FIXME: || GetTargetPlot()->IsAdjacentOwnedByOtherTeam(pSettler->getTeam())
                if targetOwner != nil && targetOwner?.leader != self.player?.leader {

                    self.retarget(civilian: settler, within: self.army, in: gameModel)
                    settler.finishMoves()

                    if let escort = self.army?.unit(at: 1) {
                        escort.finishMoves()
                    }
                } else if settler.location == targetPosition && settler.canMove() && settler.canFound(at: settler.location, in: gameModel) {

                    // If the settler made it, we don't care about the entire army
                    settler.push(mission: UnitMission(type: .found), in: gameModel)
                    self.state = .successful
                } else if settler.location == targetPosition && !settler.canFound(at: settler.location, in: gameModel) {

                    // If we're at our target, but can no longer found a city, might be someone else beat us to this area
                    // So move back out, picking a new target
                    self.retarget(civilian: settler, within: self.army, in: gameModel)
                    settler.finishMoves()

                    if let escort = self.army?.unit(at: 1) {
                        escort.finishMoves()
                    }
                }
            }

            return stateChanged

        case .successful:
            // NOOP
            break
        }

        return false
    }

    /// Find the plot where we want to settle
    func findBestTarget(for unit: AbstractUnit?, onlySafePaths: Bool, in gameModel: GameModel?) -> AbstractTile? {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        let area = gameModel?.area(of: unit.location)
        if let tile = self.player?.bestSettlePlot(for: unit, in: gameModel, escorted: onlySafePaths, area: area) {
            return tile
        }
        
        self.area = nil
        return self.player?.bestSettlePlot(for: unit, in: gameModel, escorted: onlySafePaths, area: nil)
    }
}
