//
//  LevelManager.swift
//  Colony
//
//  Created by Michael Rommel on 12.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import Rswift

struct LevelInfo {
    
    let number: Int
    let difficulty: LevelDifficulty
    let position: CGPoint
    let resource: URL?
}

class LevelManager {
    
    var levels: [LevelInfo] = []
    
    init() {

        self.addLevelFrom(url: R.file.level0001Lvl(), at: CGPoint(x: 0.1, y: 0.1))
        //self.addLevelFrom(url: R.file.level0002Lvl(), at: CGPoint(x: 0.3, y: 0.15))
    }
    
    private func addLevelFrom(url: URL?, at position: CGPoint) {

        if let level = LevelManager.loadLevelFrom(url: url) {
            levels.append(LevelInfo(number: level.number, difficulty: level.difficulty, position: position, resource: url))
        }
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
