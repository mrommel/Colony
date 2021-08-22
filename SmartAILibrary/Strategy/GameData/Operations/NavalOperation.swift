//
//  NavalOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAINavalOperation
//!  \brief        Send out a squadron of naval units to bomb enemy forces on the coast
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class NavalOperation: EnemyTerritoryOperation {

    /// Kick off this operation
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        super.initialize(for: player, enemy: enemy, area: area, target: target, muster: muster, in: gameModel)

        self.moveType = .enemyTerritory

        // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
        self.army = Army(of: self.player, for: self, with: self.formation(in: gameModel))
        self.army?.state = .waitingForUnitsToReinforce

        if let target = target {

            self.targetPosition = target.location
            self.army?.goal = target.location

            // Muster just off the coast

            if let coastalMuster = gameModel.coastalPlotAdjacent(to: muster!.location) {

                self.area = coastalMuster.area
                self.startPosition = coastalMuster.point
                self.musterPosition = coastalMuster.point
                self.army?.position = coastalMuster.point

                // Find the list of units we need to build before starting this operation in earnest
                self.buildListOfUnitsWeStillNeedToBuild()

                // try to get as many units as possible from existing units that are waiting around
                if self.grabUnitsFromTheReserves(at: coastalMuster.point, for: coastalMuster.point, in: gameModel) {
                    self.army?.state = .waitingForUnitsToCatchUp
                    self.state = .gatheringForces
                } else {
                    self.state = .recruitingUnits
                }

                // LogOperationStart();
            } else {
                // No muster point, abort
                self.state = .aborted(reason: .noMuster)
            }
        } else {
            // Lost our target, abort
            self.state = .aborted(reason: .lostTarget)
        }
    }

    override func formation(in gameModel: GameModel?) -> UnitFormationType {

        return .navalSquadron // MUFORMATION_NAVAL_SQUADRON
    }

    override func isAllNavalOperation() -> Bool {

        return true
    }

    // Let naval units come from afar
    override func maximumRecruitTurns() -> Int {

        return Int.max
    }

    /// How far out from the target city do we want to gather?
    override func deployRange() -> Int {

        return 4 // AI_OPERATIONAL_CITY_ATTACK_DEPLOY_RANGE
    }

    /// Same as default version except if just gathered forces and this operation never reaches a final target (just keeps attacking until dead or the operation is ended)
    @discardableResult
    override func armyInPosition(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel,
            let enemy = self.enemy,
            let army = self.army else {
                fatalError("cant get gameModel")
        }

        var stateChanged = false

        switch self.state {

            // If we were gathering forces, let's make sure a better target hasn't presented itself
        case .gatheringForces:

            // First do base case processing
            stateChanged = super.armyInPosition(in: gameModel)

            // Is target still under enemy control?
            if let target = self.targetPosition,
                let targetTile = gameModel.tile(at: target) {

                if !enemy.isEqual(to: targetTile.owner()) {
                    self.state = .aborted(reason: .targetAlreadyCaptured)
                }
            }

        case .movingToTarget:

            // See if within 2 spaces of our target, if so give control of these units to the tactical AI
            if army.position.distance(to: self.targetPosition!) < 2 {

                // Notify tactical AI to focus on this area
                let zone = TemporaryZone(location: self.targetPosition!, lastTurn: gameModel.currentTurn + 5 /* AI_TACTICAL_MAP_TEMP_ZONE_TURNS */, targetType: .city)
                self.player?.tacticalAI?.add(temporaryZone: zone)

                self.state = .successful
            }

            // In all other cases use base class version
        case .aborted(reason: _), .recruitingUnits, .atTarget:
            return super.armyInPosition(in: gameModel)

        default:
            // NOOP
        break
        }

        return stateChanged
    }

    /// Returns true when we should abort the operation totally (besides when we have lost all units in it)
    override func shouldAbort(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // If parent says we're done, don't even check anything else
        let rtnValue = super.shouldAbort(in: gameModel)

        if !rtnValue {

            if self.targetPosition == nil {
                return true
            }

            guard let target = self.targetPosition,
                  let targetPlot = gameModel.tile(at: target),
                  let enemy = self.enemy else {

                return false
            }

            // See if our target city is still owned by our enemy
            if !enemy.isEqual(to: targetPlot.owner()) {
                // Success!  The city has been captured/destroyed
                return true
            }
        }

        return rtnValue
    }

    /// Find a plot next to the city we want to attack
    override func findBestTarget(in gameModel: GameModel?) -> HexPoint? {
        fatalError("Obsolete function called CvAIOperationPureNavalCityAttack::FindBestTarget()")
    }

    /// Which unit would we like to use to kick off this operation?
    func findInitialUnit(in gameModel: GameModel?) -> AbstractUnit? {

        guard let gameModel = gameModel,
              let player = self.player else {
                fatalError("cant get gameModel")
        }

        for loopUnitRef in gameModel.units(of: player) {

            guard let loopUnit = loopUnitRef else {
                continue
            }

            // skip explorer
            guard loopUnit.task() != .exploreSea else {
                continue
            }

            if loopUnit.has(task: .attackSea) && loopUnit.army() == nil {
                return loopUnitRef
            }
        }

        return nil
    }

    /// Find the port our operation will leave from
    override func operationStartCity(in gameModel: GameModel?) -> AbstractCity? {

        guard let gameModel = gameModel,
              let player = self.player else {
            fatalError("cant get gameModel")
        }

        if let startPosition = self.startPosition {
            return gameModel.city(at: startPosition)
        }

        // Just find first coastal city
        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            if gameModel.isCoastal(at: city.location) {
                return cityRef
            }
        }

        return nil
    }
}
