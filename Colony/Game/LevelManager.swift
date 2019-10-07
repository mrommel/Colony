//
//  LevelManager.swift
//  Colony
//
//  Created by Michael Rommel on 12.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import Rswift

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

class LevelManager {
    
    var levelMetas: [LevelMeta] = []
    
    init() {

        if let meta = LevelManager.loadLevelMetaFrom(url: R.file.level0001Meta()) {
            self.levelMetas.append(meta)
        }
    }
    
    static func loadLevelMetaFrom(url: URL?) -> LevelMeta? {

        if let levelUrl = url {

            do {
                let jsonData = try Data(contentsOf: levelUrl, options: .mappedIfSafe)

                return try JSONDecoder().decode(LevelMeta.self, from: jsonData)
            } catch {
                print("Error reading \(error)")
            }
        }

        return nil
    }

    static func loadLevelFrom(url: URL?) -> Level? {

        if let levelUrl = url {

            do {
                let jsonData = try Data(contentsOf: levelUrl, options: .mappedIfSafe)

                return try JSONDecoder().decode(Level.self, from: jsonData)
            } catch {
                print("Error reading \(error)")
            }
        }

        return nil
    }
}
