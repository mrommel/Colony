//
//  QuickSneakCityAttackOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class QuickSneakCityAttackOperation: SneakCityAttackOperation {
    
    override init() {

        super.init(type: .sneakCityAttack)
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func formation(in gameModel: GameModel?) -> UnitFormationType {
        
        return .earlyRush // MUFORMATION_EARLY_RUSH
    }
}
