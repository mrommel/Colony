//
//  GameObjectAtlas.swift
//  SmartColony
//
//  Created by Michael Rommel on 06.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class GameObjectAtlas: Codable {
    
    let atlasName: String
    let textures: [String]
    
    init(atlasName: String, textures: [String]) {
        self.atlasName = atlasName
        self.textures = textures
    }
}
