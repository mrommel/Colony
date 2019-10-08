//
//  LevelMeta.swift
//  Colony
//
//  Created by Michael Rommel on 08.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

struct LevelMeta: Codable {
    
    // meta data
    let number: Int
    let title: String
    let summary: String
    let difficulty:  LevelDifficulty

    let position: CGPoint
    let resource: String//URL? // of level file
    
    func resourceUrl() -> URL? {
        
        return Bundle.main.url(forResource: self.resource, withExtension: "lvl")
    }
}
