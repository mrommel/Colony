//
//  SmallCityAttackOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationSmallCityAttack
// !  \brief        Same as Basic City attack except allowed when not at war
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class SmallCityAttackOperation: BasicCityAttackOperation {

    override init() {

        super.init(type: .smallCityAttack)
    }

    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    override func formation(in gameModel: GameModel?) -> UnitFormationType {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        let handicap = gameModel.handicap

        return handicap > .prince ? .basicCityAttackForce : .smallCityAttackForce // MUFORMATION_BASIC_CITY_ATTACK_FORCE : MUFORMATION_SMALL_CITY_ATTACK_FORCE;
    }
}
