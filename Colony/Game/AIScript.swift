//
//  AIScript.swift
//  Colony
//
//  Created by Michael Rommel on 14.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class AIScript {

    let game: Game?

    required init(game: Game?) {

        self.game = game
    }

    func update(for game: Game?) {

        fatalError("must be implemented by subclass")
    }
}

class AIScriptLevel0001: AIScript {

    let positionOfLondon = HexPoint(x: 20, y: 13)
    let positionNearLondon = HexPoint(x: 19, y: 13)

    //var needsInitialize: Bool = true

    override func update(for game: Game?) {

        guard let unitsOfPlayer = game?.getAllUnitsOfUser() else {
            fatalError("can't get units of user")
        }

        guard let caravelOfPlayer = unitsOfPlayer.first else {
            // can't get caravel of user
            return
        }

        guard let unitsOfAI = game?.getAllUnitsOfAI() else {
            fatalError("can't get units of ai")
        }

        for unitRef in unitsOfAI {
            if let unit = unitRef {
                if unit.isWaitingForOrders() {
                    print("-- add mission")
                    let followMission = FollowAndAttackUnitMission(unit: unitRef, target: caravelOfPlayer)
                    unit.order(mission: followMission)
                }
            }
        }
    }
}
