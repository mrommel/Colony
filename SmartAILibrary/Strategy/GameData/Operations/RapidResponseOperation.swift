//
//  RapidResponseOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 19.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationRapidResponse
// !  \brief        Mobile force that can defend where threatened
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class RapidResponseOperation: Operation {

    init() {

        super.init(type: .rapidResponse)
    }

    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    /// Kick off this operation
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        super.initialize(for: player, enemy: enemy, area: area, target: target, muster: muster, in: gameModel)

        // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
        self.army = Army(of: self.player, for: self, with: self.formation(in: gameModel))
        self.army?.state = .waitingForUnitsToReinforce

        if let targetPlot = self.findBestTarget(in: gameModel) {

            self.targetPosition = targetPlot
            self.army?.goal = targetPlot
            self.musterPosition = targetPlot // Gather directly at the point we're trying to defend

            self.army?.position = targetPlot
            self.area = gameModel.area(of: targetPlot)

            // Find the list of units we need to build before starting this operation in earnest
            self.buildListOfUnitsWeStillNeedToBuild()

            // Try to get as many units as possible from existing units that are waiting around
            if self.grabUnitsFromTheReserves(at: self.musterPosition!, for: nil, in: gameModel) {
                self.army?.state = .waitingForUnitsToCatchUp
                self.state = .gatheringForces
            } else {
                self.state = .recruitingUnits
            }

            // LogOperationStart();
        }
    }

    override func formation(in gameModel: GameModel?) -> UnitFormationType {

        return .rapidResponseForce // MUFORMATION_RAPID_RESPONSE_FORCE
    }

    /// If have gathered forces, check to see what the best blocking position is.
    override func armyInPosition(in gameModel: GameModel?) -> Bool {

        var stateChanged = false

        switch self.state {

            // See if reached our target
        case .movingToTarget:

            // For now never end, even at target
            stateChanged = false

            // ... but we might want to move to a greater threat
            self.retargetDefensiveArmy(in: gameModel)

        // In all other cases use base class version
        case .gatheringForces, .aborted(reason: _), .recruitingUnits, .atTarget:
            stateChanged = super.armyInPosition(in: gameModel)

        default:
            // NOOP
        break
        }

        return stateChanged
    }

    /// Every time the army moves on its way to the destination lets double-check that we don't have a better target
    override func armyMoved(in gameModel: GameModel?) -> Bool {

        let stateChanged = false

        switch self.state {

        case .movingToTarget:
            self.retargetDefensiveArmy(in: gameModel)

        // In all other cases use base class version
        case .atTarget, .recruitingUnits, .gatheringForces, .aborted(reason: _):
            return super.armyMoved(in: gameModel)

        default:
            // NOOP
        break
        }

        return stateChanged
    }

    /// Start the settler off to a new target plot
    @discardableResult
    func retargetDefensiveArmy(in gameModel: GameModel?) -> Bool {

        // Find most threatened city
        let betterTarget = self.findBestTarget(in: gameModel)

        if betterTarget == nil {
            // No targets at all!  Abort
            self.state = .aborted(reason: .noTarget)
            return false
        } else if betterTarget != self.targetPosition {

            // If this is a new target, switch to it
            self.targetPosition = betterTarget!
            self.army?.goal = betterTarget!
        }

        self.army?.state = .movingToDestination
        self.state = .movingToTarget

        return true
    }

    /// Find the best blocking position against the current threats
    func findBestTarget(in gameModel: GameModel?) -> HexPoint? {

        guard let militaryAI = self.player?.militaryAI,
              let enemy = self.enemy,
              let player = self.player else {
            fatalError("cant get militaryAI")
        }

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // Defend the city most under threat
        var city = militaryAI.mostThreatenedCity(in: gameModel)

        // If no city is threatened just defend whichever of our cities is closest to the enemy capital
        if city == nil {

            var enemyCapital = gameModel.capital(of: enemy)
            if enemyCapital == nil {
                enemyCapital = gameModel.cities(of: enemy).first!
            }

            if let enemyCapital = enemyCapital {
                city = gameModel.findCity(of: player, closestTo: enemyCapital.location)
            }
        }

        if let city = city {
            return city.location
        }

        return nil
    }
}
