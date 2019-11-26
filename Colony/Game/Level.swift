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
    
    // meta data
    var meta: LevelMeta? = nil
    
    let turns: Int
    
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
        case turns
        
        case map
        case startPositions
        case gameObjectManager
        case player
        
        case scoreThresold
        
        case gameConditionCheckIdentifiers
    }
    
    init(turns: Int, map: HexagonTileMap, startPositions: StartPositions) {
        
        self.turns = turns
        self.scoreThresold = ScoreThresold(silver: 4, gold: 5)
        
        self.map = map
        self.startPositions = startPositions
        self.gameObjectManager = GameObjectManager(on: self.map)
        
        self.userUsecase = UserUsecase()
        
        self.setupPlayers()
        
        let currentUserCivilization = self.userUsecase?.currentUser()?.civilization ?? .english
        let caravel = Caravel(position: startPositions.playerPosition, civilization: currentUserCivilization)
        self.map.add(unit: caravel)
        
        for (index, startPosition) in startPositions.cityPositions.enumerated() {
            print("- city \(index): \(startPosition)")
            let city = City(named: City.kDefaultName, at: startPosition, civilization: .english)
            self.map.set(city: city)
        }
        
        // create game objects on map
        self.gameObjectManager.setupUnits()
        self.gameObjectManager.setupCities()
        
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
        tradeShip.idle()
        
        //let playerForCityStates = self.playerForCityStates()
        //var ununsedCityNames = playerForCityStates.civilization.cityNames
        
        for (index, startPosition) in startPositions.cityPositions.enumerated() {

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
        }
        
        let oceanTiles = map.oceanTiles
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
        */
        
        // set the selected unit
        self.gameObjectManager.selected = self.map.unitsOf(civilization: currentUserCivilization).first!
        
        //self.gameObjectManager.map = self.map
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.turns = try values.decode(Int.self, forKey: .turns)
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
        }*/
        
        // set the selected unit
        self.gameObjectManager.selected = self.map.unitsOf(civilization: currentUserCivilization).first!
    }
    
    func setupPlayers() {
        
        guard let currentUser = self.userUsecase?.currentUser() else {
            fatalError("Can't get current users")
        }
        
        for civilization in Civilization.all {
            
            if civilization == currentUser.civilization {
                let customLeader = Leader(name: currentUser.name, civilization: civilization)
                let player = Player(leader: customLeader, isUser: true)
                self.players.append(player)
            } else {
                let player = Player(leader: civilization.leader, isUser: false)
                self.players.append(player)
            }
        }
    }
    
    func playerForUser() -> Player {
        
        return self.players.first(where: { $0.isUser })!
    }
    
    func playerFor(civilization: Civilization) -> Player? {
        
        return self.players.first(where: { $0.leader.civilization == civilization })
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
        
        try container.encode(self.turns, forKey: .turns)
        try container.encode(self.scoreThresold, forKey: .scoreThresold)
        
        try container.encode(self.map, forKey: .map)
        try container.encode(self.startPositions, forKey: .startPositions)
        try container.encode(self.players, forKey: .player)
        
        try container.encode(self.gameConditionCheckIdentifiers, forKey: .gameConditionCheckIdentifiers)
    }
}
