//
//  EscortedOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class EscortedOperation: Operation {

    var escorted: Bool
    let civilianType: UnitTaskType

    init(type: UnitOperationType, escorted: Bool, civilianType: UnitTaskType) {

        self.escorted = escorted
        self.civilianType = civilianType

        super.init(type: type)
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    /// Kick off this operation
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {

        super.initialize(for: player, enemy: enemy, area: area, in: gameModel)

        self.moveType = .singleHex
        self.player = player

        if let civilian = self.findBestCivilian(in: gameModel) {

            // Find a destination (not worrying about safe paths)
            if let targetSite = findBestTarget(for: civilian, in: gameModel) {

                self.updateTarget(to: targetSite)

                // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
                let army = Army(of: player, for: self, with: .settlerEscort)
                army.state = .waitingForUnitsToReinforce

                // Figure out the initial rally point - for this operation it is wherever our civilian is standing
                army.goal = targetSite.point
                army.muster = civilian.location
                army.position = civilian.location
                army.area = gameModel?.area(of: civilian.location)

                // Add the settler to our army
                army.add(unit: civilian, to: 0)

                self.army = army

                // Add the escort as a unit we need to build
                self.listOfUnitsWeStillNeedToBuild.removeAll()
                let escortSlotIndex = 1
                let escortFormationSlot = army.formation.slots()[escortSlotIndex]
                self.listOfUnitsWeStillNeedToBuild.append(OperationSlot(operation: self, army: army, slot: escortFormationSlot, slotIndex: escortSlotIndex))
            }
        }
    }

    func findBestTarget(for unit: AbstractUnit?, in gameModel: GameModel?) -> AbstractTile? {

        fatalError("need to be overriden")
    }

    /// Find the civilian we want to use
    func findBestCivilian(in gameModel: GameModel?) -> AbstractUnit? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let units = gameModel.units(of: player)

        for unitRef in units {

            if let unit = unitRef {

                if unit.has(task: self.civilianType) {

                    if unit.army() == nil {

                        if let capital = gameModel.capital(of: player) {

                            if let capitalArea = gameModel.area(of: capital.location),
                                let unitArea = gameModel.area(of: unit.location) {

                                if capitalArea == unitArea {
                                    return unitRef
                                }
                            }
                        } else {
                            // FIXME:
                            return unitRef
                        }
                    }
                }
            }
        }

        return nil
    }

    @discardableResult
    func retarget(civilian unit: AbstractUnit?, within army: Army?, in gameModel: GameModel?) -> Bool {

        // Find best city site (taking into account whether or not we are escorted)
        let betterTarget = self.findBestTarget(for: unit, in: gameModel)

        // No targets at all!  Abort
        if betterTarget == nil {

            self.state = .aborted(reason: .noTarget)
            return false

            // If this is a new target, switch to it
        } else if betterTarget?.point != self.targetPosition {

            self.updateTarget(to: betterTarget)
            self.army?.goal = betterTarget!.point

        } else {

            self.state = .aborted(reason: .repeatTarget)
            return false
        }

        self.army?.state = .movingToDestination
        self.state = .movingToTarget

        return true
    }
}
