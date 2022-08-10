//
//  GenericGenerator.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.08.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public class GenericGenerator {

    init() {}

    internal func freeCityStateStartingUnitTypes() -> [UnitType] {

        return [.settler, .warrior, .builder]
    }

    func allocate(units: inout [AbstractUnit], at startLocation: HexPoint, of unitTypes: [UnitType], for player: AbstractPlayer?) {

        for unitType in unitTypes {
            let unit = Unit(at: startLocation, type: unitType, owner: player)
            units.append(unit)
        }
    }

    func add(units: [AbstractUnit], to gameModel: GameModel) {

        var lastLeader: LeaderType? = LeaderType.none
        for unit in units {

            gameModel.add(unit: unit)
            gameModel.sight(at: unit.location, sight: unit.sight(), for: unit.player)

            if lastLeader == unit.player?.leader {
                if gameModel.units(at: unit.location).count > 1 {
                    let jumped = unit.jumpToNearestValidPlotWithin(range: 2, in: gameModel)
                    if !jumped {
                        print("--- could not jump unit to nearest valid plot ---")
                    }
                }
            }

            lastLeader = unit.player?.leader
        }
    }
}
