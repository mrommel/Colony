//
//  LevelManager.swift
//  Colony
//
//  Created by Michael Rommel on 12.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

struct LevelInfo {
    
    let number: Int
    let position: CGPoint
    let levelName: String
}

class LevelManager {
    
    var levels: [LevelInfo] = []
    
    init() {
        
        levels.append(LevelInfo(number: 1, position: CGPoint(x: 0.1, y: 0.1), levelName: "level0001"))
        levels.append(LevelInfo(number: 2, position: CGPoint(x: 0.2, y: 0.3), levelName: "level0002"))
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func store(level: Level?, to fileName: String) {

        guard let level = level else {
            fatalError("Can't store nil level")
        }

        let filename = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            let mapPayload: Data = try JSONEncoder().encode(level)
            try mapPayload.write(to: filename)
            //let jsonString = String(data: mapPayload, encoding: .utf8)
            //print(jsonString!)
        } catch {
            fatalError("Can't store level: \(error)")
        }
    }

    func loadLevel(named levelName: String) -> Level? {

        if let url = Bundle.main.url(forResource: levelName, withExtension: "lvl") {

            do {
                let jsonData = try Data(contentsOf: url, options: .mappedIfSafe)

                return try JSONDecoder().decode(Level.self, from: jsonData)
            } catch {
                print("Error reading \(error)")
            }
        }

        return nil
    }
}
