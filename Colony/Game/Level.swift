//
//  Level.swift
//  Colony
//
//  Created by Michael Rommel on 13.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

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
    let duration: Int // in seconds
    
    // data holder
    let map: HexagonTileMap
    let startPositions: StartPositions
    let gameObjectManager: GameObjectManager
    var players: [Player] = []
    
    let scoreThresold: ScoreThresold
    
    var gameConditionCheckIdentifiers: [String] = []
    
    var userUsecase: UserUsecase?
    
    enum CodingKeys: String, CodingKey {
        
        case number
        case title
        case summary
        case difficulty
        case duration
        
        case map
        case startPositions
        case gameObjectManager
        case player
        
        case scoreThresold
        
        case gameConditionCheckIdentifiers
    }
    
    init(number: Int, title: String, summary: String, difficulty: LevelDifficulty, duration: Int, map: HexagonTileMap, startPositions: StartPositions) {
        
        self.number = number
        self.title = title
        self.summary = summary
        self.difficulty = difficulty
        self.duration = duration
        self.scoreThresold = ScoreThresold(silver: 4, gold: 5)
        
        self.map = map
        self.startPositions = startPositions
        self.gameObjectManager = GameObjectManager(on: self.map)
        
        self.userUsecase = UserUsecase()
        
        self.setupPlayers()
        
        /*let ship = ShipObject(with: "ship", at: startPositions.playerPosition, civilization: .english)
        self.gameObjectManager.add(object: ship)
        ship.idle()
        
        let boosterLocation = startPositions.playerPosition.neighbors().filter({ self.map.isWater(at: $0) })
        let booster = Booster(at: boosterLocation.randomItem(), boosterType: .telescope)
        self.gameObjectManager.add(object: booster)
        booster.idle()
        
        let monster = Monster(with: "monster", at: startPositions.monsterPosition)
        self.gameObjectManager.add(object: monster)
        monster.idle()
        
        let pirates = Pirates(with: "pirates", at: startPositions.monsterPosition)
        self.gameObjectManager.add(object: pirates)
        pirates.idle()
        
        let tradeShip = TradeShip(with: "tradeShip", at: startPositions.monsterPosition)
        self.gameObjectManager.add(object: tradeShip)
        tradeShip.idle()*/
        
        let playerForCityStates = self.playerForCityStates()
        var ununsedCityNames = playerForCityStates.civilization.cityNames
        
        /*for (index, startPosition) in startPositions.cityPositions.enumerated() {

            if index == 0 {
                let player = self.playerForUser()
                let cityName = player.civilization.cityNames.first!
                self.found(city: City(named: cityName, at: startPosition, civilization: player.civilization))

                // start axeman next to city (or on city)
                var axemanPositions = startPosition.neighbors().filter({ self.map.isGround(at: $0) })
                if axemanPositions.count == 0 {
                    axemanPositions = [startPosition]
                }
                let axeman = Axeman(with: "axeman", at: axemanPositions.randomItem(), civilization: player.civilization)
                self.gameObjectManager.add(object: axeman)
                axeman.idle()
            } else {
                
                let cityName = ununsedCityNames.randomItem()
                ununsedCityNames = ununsedCityNames.filter { $0 != cityName }
                self.found(city: City(named: cityName, at: startPosition, civilization: .cityStates))
            }
        }*/
        
        /*let oceanTiles = map.oceanTiles
        let forestTiles = map.forestTiles
        
        // special decorations / obstacles
        let shipWreckTile = oceanTiles.randomItem()
        if let point = shipWreckTile?.point {
            let shipWreck = ShipWreck(at: point)
            self.gameObjectManager.add(object: shipWreck)
            shipWreck.idle()
        }
        
        // reefs
        let reefTile = oceanTiles.randomItem()
        if let point = reefTile?.point {
            let reef = Reef(at: point)
            self.gameObjectManager.add(object: reef)
            reef.idle()
        }
        
        // animals
        for _ in 0..<5 {
            let oceanTile = oceanTiles.randomItem()
            
            if let point = oceanTile?.point {
                let shark = Shark(at: point)
                self.gameObjectManager.add(object: shark)
                shark.idle()
            }
        }

        for _ in 0..<15 {
            let forestTile = forestTiles.randomItem()
            
            if let point = forestTile?.point {
                let wulf = Wulf(at: point)
                self.gameObjectManager.add(object: wulf)
                wulf.idle()
            }
        }
        
        // coins
        for _ in 0..<64 {
            let oceanTile = oceanTiles.randomItem()
            
            if let point = oceanTile?.point {
                let coin = Coin(at: point)
                self.gameObjectManager.add(object: coin)
                coin.idle()
            }
        }
        
        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }
        
        // set the selected unit
        self.gameObjectManager.selected = self.gameObjectManager.unitsOf(civilization: currentUserCivilization).first!
        */
        self.gameObjectManager.map = self.map
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.number = try values.decode(Int.self, forKey: .number)
        self.title = try values.decode(String.self, forKey: .title)
        self.summary = try values.decode(String.self, forKey: .summary)
        self.difficulty = try values.decode(LevelDifficulty.self, forKey: .difficulty)
        self.duration = try values.decode(Int.self, forKey: .duration)
        self.scoreThresold = try values.decodeIfPresent(ScoreThresold.self, forKey: .scoreThresold) ?? ScoreThresold(silver: 4, gold: 5)
        
        self.map = try values.decode(HexagonTileMap.self, forKey: .map)
        self.map.fogManager?.map = self.map
        self.startPositions = try values.decode(StartPositions.self, forKey: .startPositions)
        self.gameObjectManager = GameObjectManager(on: self.map) //try values.decode(GameObjectManager.self, forKey: .gameObjectManager)
        self.players = try values.decode([Player].self, forKey: .player)
        
        self.userUsecase = UserUsecase()
        
        self.gameConditionCheckIdentifiers = try values.decode([String].self, forKey: .gameConditionCheckIdentifiers)

        // connect classes
        
        self.gameObjectManager.map = self.map
        
        let currentUserCivilization = self.userUsecase?.currentUser()?.civilization ?? .english

        /*for object in self.gameObjectManager.objects {
            if let unitObject = object {
                unitObject.delegate = self.gameObjectManager
                
                if let civilization = unitObject.civilization {
                    if civilization == currentUserCivilization {
                        self.map.fogManager?.add(unit: unitObject)
                    }
                }
            }
        }
        
        // set the selected unit
        self.gameObjectManager.selected = self.map.unitsOf(civilization: currentUserCivilization).first!*/
    }
    
    func setupPlayers() {
        
        guard let currentUser = self.userUsecase?.currentUser() else {
            fatalError("Can't get current users")
        }
        
        for civilization in Civilization.all {
            
            if civilization == currentUser.civilization {
                let player = Player(name: currentUser.name, civilization: civilization, isUser: true)
                self.players.append(player)
            } else {
                let player = Player(name: civilization.defaultUserName, civilization: civilization, isUser: false)
                self.players.append(player)
            }
        }
    }
    
    func playerForUser() -> Player {
        
        return self.players.first(where: { $0.isUser })!
    }
    
    func playerForCityStates() -> Player {
        
        return self.players.first(where: { $0.civilization == .cityStates })!
    }
    
    func playerFor(civilization: Civilization) -> Player {
        
        return self.players.first(where: { $0.civilization == civilization })!
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
    
    func found(city: City) {

        let cityObj = CityObject(for: city)
        //self.gameObjectManager.add(object: cityObj)
        cityObj.showIdle()
        
        self.map.set(city: city, at: city.position)
        self.map.cities.append(city)
        
        let player = self.playerFor(civilization: city.civilization)
        
        player.addZoneOfControl(at: city.position)
        
        for neighbor in city.position.neighbors() {

            player.addZoneOfControl(at: neighbor)
        }
    }
}

extension Level: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.number, forKey: .number)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.summary, forKey: .summary)
        try container.encode(self.difficulty, forKey: .difficulty)
        try container.encode(self.duration, forKey: .duration)
        try container.encode(self.scoreThresold, forKey: .scoreThresold)
        
        try container.encode(self.map, forKey: .map)
        try container.encode(self.startPositions, forKey: .startPositions)
        try container.encode(self.players, forKey: .player)
        
        try container.encode(self.gameConditionCheckIdentifiers, forKey: .gameConditionCheckIdentifiers)
    }
}
