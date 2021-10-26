//
//  NavalEscortedOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

/// Base class for operations that require a naval escort for land units
class NavalEscortedOperation: Operation {

    var civilianType: UnitTaskType

    convenience init() {

        self.init(type: .colonize) // ???
    }

    override init(type: UnitOperationType) {

        self.civilianType = .settle

        super.init(type: type)
    }

    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    /// Kick off this operation
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {

        super.initialize(for: player, enemy: enemy, area: area, in: gameModel)

        // Find the free civilian (that triggered this operation)
        guard let civilian = self.findBestCivilian(in: gameModel) else {

            fatalError("cant get the civilian for this operation")
        }

        self.area = gameModel?.area(of: civilian.location)

        self.moveType = .navalEscort
        self.player = player

        guard let startCity = self.operationStartCity(in: gameModel) else {

            fatalError("cant get the city of the civilian")
        }

        // Find a destination (not worrying about safe paths)
        if let targetSite = self.findBestTarget(for: civilian, in: gameModel) {

            self.targetPosition = targetSite.point

            // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
            self.army = Army(of: self.player, for: nil, with: self.formation(in: gameModel))
            self.army?.state = .waitingForUnitsToReinforce
            self.army?.goal = targetSite.point

            self.musterPosition = startCity.location
            self.army?.position = startCity.location

            // Add the settler to our army
            self.army?.add(unit: civilian, to: 0)

            // try to get the escort from existing units that are waiting around
            self.buildListOfUnitsWeStillNeedToBuild()

            // Try to get as many units as possible from existing units that are waiting around
            if self.grabUnitsFromTheReserves(at: self.musterPosition, for: nil, in: gameModel) {
                self.army?.state = .waitingForUnitsToCatchUp  // ARMYAISTATE_WAITING_FOR_UNITS_TO_CATCH_UP
                self.state = .gatheringForces
            } else {
                self.state = .recruitingUnits
            }

            //LogOperationStart();

        } else {
            // Lost our target, abort
            self.state = .aborted(reason: .lostTarget)
        }
    }

    override func formation(in gameModel: GameModel?) -> UnitFormationType {

        return .colonizationParty
    }

    /// Find the port our operation will leave from
    override func operationStartCity(in gameModel: GameModel?) -> AbstractCity? {

        guard let gameModel = gameModel,
            let player = self.player else {
            fatalError("cant get gameModel")
        }

        if let position = self.startPosition {
            return gameModel.city(at: position)
        }

        // Find first coastal city in same area as settler
        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            if gameModel.isCoastal(at: city.location) {
                if let cityArea = gameModel.area(of: city.location) {
                    if cityArea == self.area {
                        return cityRef
                    }
                }
            }
        }

        return nil
    }

    /// Always abort if settler is removed
    func unitWasRemoved(from army: Army?, slotID: Int) {

        // Assumes civilian is in the first slot of the formation
        if slotID == 0 {
            self.state = .aborted(reason: .lostCivilian)
        }
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

                if unit.task() == self.civilianType {

                    if unit.army() == nil {

                        return unitRef
                    }
                }
            }
        }

        return nil
    }

    func targetPlot(in gameModel: GameModel?) -> AbstractTile? {

        if let targetPosition = self.targetPosition {
            return gameModel?.tile(at: targetPosition)
        }

        return nil
    }

    /// If at target, found city; if at muster point, merge settler and escort and move out
    @discardableResult
    override func armyInPosition(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel,
            let player = self.player else {
            fatalError("cant get gameModel")
        }

        var stateChanged: Bool = false

        switch state {

        case .movingToTarget, .atTarget:

            // Call base class version and see if it thinks we're done
            stateChanged = super.armyInPosition(in: gameModel)

            // Now get the settler
            if let settler = self.army?.unit(at: 0) {

                let targetPlot = self.targetPlot(in: gameModel)
                let targetPlotOwner = targetPlot?.owner()

                if (targetPlotOwner != nil && !player.isEqual(to: targetPlotOwner)) ||
                    gameModel.isAdjacentOwned(of: self.targetPosition!, otherThan: settler.player) {

                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        print("Not at target, but can no longer settle here. Target was \(self.targetPosition!)")
                    }

                    self.retarget(civilian: settler, army: self.army, in: gameModel)
                    settler.finishMoves()

                    if let escort = self.army?.unit(at: 1) {
                        escort.finishMoves()
                    }
                }
                // If the settler made it, we don't care about the entire army
                else if settler.location == self.targetPosition! && settler.canMove() && settler.canFound(at: settler.location, in: gameModel) {

                    settler.push(mission: UnitMission(type: .found), in: gameModel)

                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        print("City founded, at \(settler.location)")
                    }

                    self.state = .successful
                }

                // If we're at our target, but can no longer found a city, might be someone else beat us to this area
                // So move back out, picking a new target
                else if settler.location == self.targetPosition! && !settler.canFound(at: settler.location, in: gameModel) {

                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        print("At target but can no longer settle here. Target was \(settler.location)")
                    }

                    self.retarget(civilian: settler, army: self.army, in: gameModel)
                    settler.finishMoves()

                    if let escort = self.army?.unit(at: 1) {
                        escort.finishMoves()
                    }
                }
            }
            break

            // In all other cases use base class version
        case .gatheringForces, .aborted(reason: _), .recruitingUnits:
            return super.armyInPosition(in: gameModel)

        default:
            // NOOP
            break
        }

        return stateChanged
    }

    /// Find the plot where we want to settle
    func findBestTarget(for unit: AbstractUnit?, onlySafePaths: Bool = true, in gameModel: GameModel?) -> AbstractTile? {

        return self.player?.bestSettlePlot(for: unit, in: gameModel, escorted: true, area: nil)
    }

    /// Start the civilian off to a new target plot
    @discardableResult
    func retarget(civilian: AbstractUnit?, army: Army?, in gameModel: GameModel?) -> Bool {

        // Find best city site (taking into account whether or not we are escorted)
        let betterTargetRef: AbstractTile? = self.findBestTarget(for: civilian, in: gameModel)

        guard let betterTarget = betterTargetRef else {
            // No targets at all!  Abort
            self.state = .aborted(reason: .noTarget)
            return false
        }

        if betterTarget.point != self.targetPosition {
            // If this is a new target, switch to it
            self.targetPosition = betterTarget.point
            self.army?.goal = betterTarget.point
        }

        self.army?.state = .movingToDestination
        self.state = .movingToTarget

        return true
    }

    override func isCivilianRequired() -> Bool {

        return true
    }
}
