//
//  BasicCityAttackOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class BasicCityAttackOperation: Operation {

    init() {

        super.init(type: .basicCityAttack)
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
