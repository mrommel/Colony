//
//  Level.swift
//  Colony
//
//  Created by Michael Rommel on 13.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class Level: Decodable  {
    
    let title: String
    let summary: String
    
    let map: HexagonTileMap
    let startPositions: StartPositions
    let gameObjectManager: GameObjectManager
    
    enum CodingKeys: String, CodingKey {
        case title
        case summary
        
        case map
        case startPositions
        case gameObjectManager
        
        case gameConditionCheckIdentifiers
    }
    
    init(title: String, summary: String, map: HexagonTileMap, startPositions: StartPositions, gameObjectManager: GameObjectManager) {
        
        self.title = title
        self.summary = summary
        
        self.map = map
        self.startPositions = startPositions
        self.gameObjectManager = gameObjectManager
        
        self.gameObjectManager.map = self.map
        self.gameObjectManager.add(conditionCheck: MonsterCheck())
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try values.decode(String.self, forKey: .title)
        self.summary = try values.decode(String.self, forKey: .summary)
        
        self.map = try values.decode(HexagonTileMap.self, forKey: .map)
        self.startPositions = try values.decode(StartPositions.self, forKey: .startPositions)
        self.gameObjectManager = try values.decode(GameObjectManager.self, forKey: .gameObjectManager)
        
        let gameConditionCheckIdentifiers = try values.decode([String].self, forKey: .gameConditionCheckIdentifiers)
        
        // connect classes
        self.map.fogManager?.map = self.map
        self.gameObjectManager.map = self.map
        
        for object in self.gameObjectManager.objects {
            if let unitObject = object {
                unitObject.delegate = self.gameObjectManager
                self.map.fogManager?.add(unit: unitObject)
            }
        }

        for identifier in gameConditionCheckIdentifiers {
            if let gameConditionCheck = GameConditionCheckManager.shared.gameConditionCheckFor(identifier: identifier) {
                self.gameObjectManager.add(conditionCheck: gameConditionCheck)
            }
        }
    }
}

extension Level: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.summary, forKey: .summary)
        
        try container.encode(self.map, forKey: .map)
        try container.encode(self.startPositions, forKey: .startPositions)
        try container.encode(self.gameObjectManager, forKey: .gameObjectManager)
        
        let gameConditionCheckIdentifiers = self.gameObjectManager.conditionCheckIdentifiers
        try container.encode(gameConditionCheckIdentifiers, forKey: .gameConditionCheckIdentifiers)
    }
}
