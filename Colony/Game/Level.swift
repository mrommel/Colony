//
//  Level.swift
//  Colony
//
//  Created by Michael Rommel on 13.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum LevelDifficulty: String, Codable {
    
    case easy
    case medium
    case hard
    
    var buttonName: String {
        
        switch self {
        
        case .easy:
            return "level_cyan"
        case .medium:
            return "level_yellow"
        case .hard:
            return "level_red"
        }
    }
}

enum LevelScore: String {
    
    case none = "none"
    case bronze = "bronze"
    case silver = "silver"
    case gold = "gold"
    
    var buttonName: String {
        
        switch self {
            
        case .none:
            return "star_none"
        case .bronze:
            return "star_bronze"
        case .silver:
            return "star_silver"
        case .gold:
            return "star_gold"
        }
    }
}

struct ScoreThresold: Codable {
    let silver: Int
    let gold: Int
}

class Level: Decodable  {
    
    let number: Int
    let title: String
    let summary: String
    let difficulty: LevelDifficulty
    
    let map: HexagonTileMap
    let startPositions: StartPositions
    let gameObjectManager: GameObjectManager
    
    let scoreThresold: ScoreThresold
    
    var gameConditionCheckIdentifiers: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case number
        case title
        case summary
        case difficulty
        
        case map
        case startPositions
        case gameObjectManager
        
        case scoreThresold
        
        case gameConditionCheckIdentifiers
    }
    
    init(number: Int, title: String, summary: String, difficulty: LevelDifficulty ,map: HexagonTileMap, startPositions: StartPositions, gameObjectManager: GameObjectManager) {
        
        self.number = number
        self.title = title
        self.summary = summary
        self.difficulty = difficulty
        self.scoreThresold = ScoreThresold(silver: 4, gold: 5)
        
        self.map = map
        self.startPositions = startPositions
        self.gameObjectManager = gameObjectManager
        
        let ship = ShipObject(with: "ship", at: startPositions.playerPosition, tribe: .player)
        self.gameObjectManager.add(object: ship)
        ship.idle()
        
        let monster = Monster(with: "monster", at: startPositions.monsterPosition)
        self.gameObjectManager.add(object: monster)
        monster.idle()
        
        let pirates = Pirates(with: "pirates", at: startPositions.monsterPosition)
        self.gameObjectManager.add(object: pirates)
        pirates.idle()
        
        for (index, startPosition) in startPositions.cityPositions.enumerated() {
        
            if index == 0 {
                let city = CityObject(with: "city", at: startPosition, tribe: .player)
                self.gameObjectManager.add(object: city)
                city.idle()
            
                let axeman = Axeman(with: "axeman", at: startPosition.neighbors().randomItem(), tribe: .player)
                self.gameObjectManager.add(object: axeman)
                axeman.idle()
            } else {
                let city = CityObject(with: "city-\(index)", at: startPosition, tribe: .neutral)
                self.gameObjectManager.add(object: city)
                city.idle()
            }
        }
        
        let oceanTiles = map.oceanTiles
        
        // special decorations / obstacles
        let shipWreckTile = oceanTiles.randomItem()
        if let point = shipWreckTile?.point {
            let shipWreck = ShipWreck(at: point)
            self.gameObjectManager.add(object: shipWreck)
            shipWreck.idle()
        }
        
        // riffs
        
        // animals
        for _ in 0..<5 {
            let oceanTile = oceanTiles.randomItem()
            
            if let point = oceanTile?.point {
                let shark = Shark(at: point)
                self.gameObjectManager.add(object: shark)
                shark.idle()
            }
        }

        for _ in 0..<64 {
            let oceanTile = oceanTiles.randomItem()
            
            if let point = oceanTile?.point {
                let coin = Coin(at: point)
                self.gameObjectManager.add(object: coin)
                coin.idle()
            }
        }
        
        // set the selected unit - FIXME
        self.gameObjectManager.selected = self.gameObjectManager.unitsOf(tribe: .player).first!
        
        self.gameObjectManager.map = self.map
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.number = try values.decode(Int.self, forKey: .number)
        self.title = try values.decode(String.self, forKey: .title)
        self.summary = try values.decode(String.self, forKey: .summary)
        self.difficulty = try values.decode(LevelDifficulty.self, forKey: .difficulty)
        self.scoreThresold = try values.decodeIfPresent(ScoreThresold.self, forKey: .scoreThresold) ?? ScoreThresold(silver: 4, gold: 5)
        
        self.map = try values.decode(HexagonTileMap.self, forKey: .map)
        self.startPositions = try values.decode(StartPositions.self, forKey: .startPositions)
        self.gameObjectManager = try values.decode(GameObjectManager.self, forKey: .gameObjectManager)
        
        self.gameConditionCheckIdentifiers = try values.decode([String].self, forKey: .gameConditionCheckIdentifiers)
        
        // connect classes
        self.map.fogManager?.map = self.map
        self.gameObjectManager.map = self.map
        
        for object in self.gameObjectManager.objects {
            if let unitObject = object {
                unitObject.delegate = self.gameObjectManager
                
                if unitObject.tribe == .player {
                    self.map.fogManager?.add(unit: unitObject)
                }
            }
        }
        
        // set the selected unit - FIXME
        self.gameObjectManager.selected = self.gameObjectManager.unitsOf(tribe: .player).first!
    }
    
    func score(for coins: Int) -> LevelScore {
        
        if coins >= self.scoreThresold.gold {
            return .gold
        }
        
        if coins >= self.scoreThresold.silver {
            return .silver
        }
        
        return .bronze
    }
}

extension Level: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.number, forKey: .number)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.summary, forKey: .summary)
        try container.encode(self.difficulty, forKey: .difficulty)
        try container.encode(self.scoreThresold, forKey: .scoreThresold)
        
        try container.encode(self.map, forKey: .map)
        try container.encode(self.startPositions, forKey: .startPositions)
        try container.encode(self.gameObjectManager, forKey: .gameObjectManager)
        
        try container.encode(self.gameConditionCheckIdentifiers, forKey: .gameConditionCheckIdentifiers)
    }
}
