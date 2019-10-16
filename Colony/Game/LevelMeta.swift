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
    let resource: String //URL? // of level file
    
    let rating: String // class name of rating function
    let aiscript: String // class name of ai script function
    
    func resourceUrl() -> URL? {
        
        return Bundle.main.url(forResource: self.resource, withExtension: "lvl")
    }
    
    func getGameRating(for game: Game?) -> GameRating? {

        if self.rating.isEmpty {
            return nil
        }
        
        if let classType = Bundle.main.classNamed("Colony.\(self.rating)") as? GameRating.Type {
            return classType.init(game: game)
        }
        
        return nil
    }
    
    func getAIScript(for game: Game?) -> AIScript? {

        if self.aiscript.isEmpty {
            return nil
        }
        
        if let classType = Bundle.main.classNamed("Colony.\(self.aiscript)") as? AIScript.Type {
            return classType.init(game: game)
        }
        
        return nil
    }
}
