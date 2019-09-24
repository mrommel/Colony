//
//  Hut.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class Hut: MapItem {
    
    override init(at position: HexPoint) {
        
        super.init(at: position)
    }
    
    required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
    }
}
