//
//  Player.swift
//  Colony
//
//  Created by Michael Rommel on 23.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

/*enum TacticalDominanceType {
    
    case none
    case invisible
    case friendly
    case neutral
    case hostil
}

class TacticalDominanceZone: HexArea {
    
    var type: TacticalDominanceType = .none
    var owner: Civilization
}*/

/*
 My Influence
   All Influence coming from my units,buildings etc
 Opponent Influence
   All influence coming from opposing units,buildings etc
 Influence map
   Calculated as My Influence-Opponent Influence
 Tension map
   Calculated as My Influence+OpponentInfluence
 Vulnerability Map
   Calculated as Tension map -Abs(Influence map)
 */


// http://gameschoolgems.blogspot.com/2009/12/influence-maps-i.html
class InfluenceMap: HexagonMap<Float> {

    // MARK: constants

    static let kCityCenterWeight: Float = 8.0
    static let kCityNeighborWeight: Float = 3.0
    static let kCityRearWeight: Float = 1.0

    static let kUnitCenterWeight: Float = 5.0
    static let kUnitNeighborWeight: Float = 2.0
    static let kUnitRearWeight: Float = 1.0

    // MARK: properties

    let civilization: Civilization

    // MARK: constructors

    init(with size: CGSize, civilization: Civilization) {

        self.civilization = civilization

        super.init(with: size)
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    // MARK: methods

    // fill with own influence
    func update(with game: Game) {

        // reset
        self.fill(with: 0.0)

        if let cities = self.cities(in: game) {
            for cityRef in cities {
                if let city = cityRef {
                    self.applyCityMask(at: city.position)
                }
            }
        }

        if let units = self.units(in: game) {
            for unitRef in units {
                if let unit = unitRef {
                    self.applyUnitMask(at: unit.position)
                }
            }
        }
    }

    func applyCityMask(at position: HexPoint) {

        if let oldValue = self.tile(at: position) {
            self.set(tile: max(oldValue, InfluenceMap.kCityCenterWeight), at: position)
        }

        for neighbor in position.neighbors() {
            if let oldValue = self.tile(at: neighbor) {
                self.set(tile: max(oldValue, InfluenceMap.kCityNeighborWeight), at: neighbor)
            }
        }

        for ring in position.ringWith(radius: 2) {
            if let oldValue = self.tile(at: ring) {
                self.set(tile: max(oldValue, InfluenceMap.kCityRearWeight), at: ring)
            }
        }
    }

    func applyUnitMask(at position: HexPoint) {

        if let oldValue = self.tile(at: position) {
            self.set(tile: max(oldValue, InfluenceMap.kUnitCenterWeight), at: position)
        }

        for neighbor in position.neighbors() {
            if let oldValue = self.tile(at: neighbor) {
                self.set(tile: max(oldValue, InfluenceMap.kUnitNeighborWeight), at: neighbor)
            }
        }

        for ring in position.ringWith(radius: 2) {
            if let oldValue = self.tile(at: ring) {
                self.set(tile: max(oldValue, InfluenceMap.kUnitRearWeight), at: ring)
            }
        }
    }

    func units(in game: Game) -> [Unit?]? {

        return game.getUnitsOf(civilization: self.civilization)
    }

    func cities(in game: Game) -> [City?]? {

        return game.getCitiesOf(civilization: self.civilization)
    }
}

class PlayerData {

    var hasMet: Bool = false
    var isAlly: Bool = false
}

/**
 
 */
class Player: Codable {

    // MARK: properties

    let leader: Leader
    var zoneOfControl: HexArea? = nil
    let isUser: Bool

    // MARK: AI

    private var _relations: [Leader: PlayerData] = [:]
    private var _aiInitialized: Bool = false
    private weak var game: Game? = nil
    private var _influenceMap: InfluenceMap? = nil

    // MARK: coding keys

    enum CodingKeys: String, CodingKey {

        case leader
        case isUser
    }

    // MARK: constructors

    init(leader: Leader, isUser: Bool) {

        self.leader = leader
        self.isUser = isUser
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.leader = try values.decode(Leader.self, forKey: .leader)
        self.isUser = try values.decode(Bool.self, forKey: .isUser)
    }

    // MARK: AI methods

    func updateAI(in game: Game?) {

        self.game = game

        // no AI for player
        // TODO: rethink for advisers
        if self.isUser {
            return
        }

        guard let game = self.game else {
            fatalError("Can't get game")
        }

        if !self._aiInitialized {

            // gather units and cities
            // build map of influence
            self._influenceMap = InfluenceMap(with: game.mapSize(), civilization: self.leader.civilization)

            // define strategies
            self.log("AI inited")
            self._aiInitialized = true
        }

        // map of influence
        self._influenceMap?.update(with: game)
        self.log("AI turned")
    }

    // MARK: other methods

    func getAllies() -> [Leader] {
        
        var allies: [Leader] = []
        
        for (leader, data) in self._relations {
            if data.isAlly {
                allies.append(leader)
            }
        }
        
        return allies
    }

    func addZoneOfControl(at point: HexPoint) {

        if self.zoneOfControl == nil {
            self.zoneOfControl = HexArea(points: [point])
        } else {
            self.zoneOfControl?.add(point: point)
        }
    }

    // MARK: logging

    func log(_ text: String) {
        Log.ai.write("[\(self.leader.name)]: \(text)")
    }
}

extension Player: Equatable {

    static func == (lhs: Player, rhs: Player) -> Bool {

        return lhs.leader == rhs.leader
    }
}

extension Player: Hashable {

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.leader)
    }
}
