//
//  NavalSneakAttackOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationNavalSneakAttack
// !  \brief        Same as basic naval attack except allowed when not at war
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class NavalSneakAttackOperation: NavalAttackOperation {

    override init() {

        super.init(type: .navalSneakAttack)
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    override func formation(in gameModel: GameModel?) -> UnitFormationType {

        return .navalInvasion // MUFORMATION_NAVAL_INVASION
    }
}
