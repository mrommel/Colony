//
//  GameObjectAtlas.swift
//  Colony
//
//  Created by Michael Rommel on 30.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class GameObjectAtlas {
    
    let atlasName: String
    let textures: [String]
    
    init(atlasName: String, textures: [String]) {
        self.atlasName = atlasName
        self.textures = textures
    }
}
