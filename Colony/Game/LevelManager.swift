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

        levels.append(LevelInfo(number: 1, difficulty: .easy, position: CGPoint(x: 0.1, y: 0.1), resource: R.file.level0001Lvl()))
        levels.append(LevelInfo(number: 2, difficulty: .medium, position: CGPoint(x: 0.2, y: 0.3), resource: R.file.level0002Lvl()))
    }

    static func store(level: Level?, to fileName: String) {

        guard let level = level else {
            fatalError("Can't store nil levels")
        }

        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)

        do {
            let mapPayload: Data = try JSONEncoder().encode(level)
            try mapPayload.write(to: filename!)
            //let jsonString = String(data: mapPayload, encoding: .utf8)
            //print(jsonString!)
        } catch {
            fatalError("Can't store level: \(error)")
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
