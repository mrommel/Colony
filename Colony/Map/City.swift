//
//  City.swift
//  Colony
//
//  Created by Michael Rommel on 14.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class City {
    
    let name: String
    let position: HexPoint
    
    init(named name: String, at position: HexPoint) {
        
        self.name = name
        self.position = position
    }
}
