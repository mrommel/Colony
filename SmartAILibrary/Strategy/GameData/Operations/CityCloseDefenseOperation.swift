//
//  CityCloseDefenseOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 17.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationCityCloseDefense
//!  \brief        Defend a specific city
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class CityCloseDefenseOperation: Operation {

    init() {

        super.init(type: .cityCloseDefense)
    }

    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    /// Kick off this operation
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {

        super.initialize(for: player, enemy: enemy, area: area, target: target, muster: muster, in: gameModel)

        // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
        self.army = Army(of: self.player, for: self, with: self.formation(in: gameModel))
        self.army?.state = .waitingForUnitsToReinforce

        if let targetPlot = self.findBestTarget(in: gameModel) {

            self.targetPosition = targetPlot
            self.army?.goal = targetPlot

            self.musterPosition = targetPlot // Gather directly at the point we're trying to defend

            self.army?.position = targetPlot

            self.area = gameModel?.area(of: targetPlot)

            // Find the list of units we need to build before starting this operation in earnest
            self.buildListOfUnitsWeStillNeedToBuild()

            // Try to get as many units as possible from existing units that are waiting around
            if self.grabUnitsFromTheReserves(at: targetPlot, for: nil, in: gameModel) {
                self.army?.state = .waitingForUnitsToCatchUp
                self.state = .gatheringForces
            } else {
                self.state = .recruitingUnits
            }

            //LogOperationStart();
        }
    }

    override func formation(in gameModel: GameModel?) -> UnitFormationType {

        return .closeCityDefense // MUFORMATION_CLOSE_CITY_DEFENSE
    }

    /// Find the best blocking position against the current threats
    func findBestTarget(in gameModel: GameModel?) -> HexPoint? {

        guard let gameModel = gameModel,
              let player = self.player,
              let enemy = self.enemy else {

            fatalError("cant get gameModel")
        }

        // Defend the city most under threat
        if let city = self.player?.militaryAI?.mostThreatenedCity(in: gameModel) {

            return city.location
        }

        // If no city is threatened just defend whichever of our cities is closest to the enemy capital
        if let enemyCapital = gameModel.capital(of: enemy) {

            if let nextPlayerCity: AbstractCity = gameModel.findCity(of: player, closestTo: enemyCapital.location) {

                return nextPlayerCity.location
            }
        } else {

            if let enemyCity = gameModel.cities(of: enemy).first {

                if let nextPlayerCity: AbstractCity = gameModel.findCity(of: player, closestTo: enemyCity!.location) {

                    return nextPlayerCity.location
                }
            }
        }

        return nil
    }
}
