//
//  Unit.swift
//  Colony
//
//  Created by Michael Rommel on 15.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class Unit: Decodable {
    
    // MARK: properties
    
    var position: HexPoint
    let civilization: Civilization
    let unitType: UnitType
    
    var sight: Int
    var strength: Int
    var suppression: Int
    var experience: Int
    var entrenchment: Int
    
    // MARK: ai stuff
    
    var tacticalAI: TacticalAIProtocol? = nil
    var group: UnitGroup? = nil
    
    // MARK: UI connection
    
    var gameObject: GameObject? = nil
    
    // MARK: coding keys
    
    enum CodingKeys: String, CodingKey {

        case position
        case civilization
        case unitType
        
        case sight
        case strength
        case suppression
        case experience
        case entrenchment
        
        case state
    }
    
    // MARK: constructor
    
    init(position: HexPoint, civilization: Civilization, unitType: UnitType) {
        
        self.position = position
        self.civilization = civilization
        self.unitType = unitType
        
        // init from unit type properties
        guard let unitProperties = unitType.properties else {
            fatalError("trying to create unit without properties")
        }
        
        self.sight = unitProperties.sight
        self.strength = unitProperties.strength
        self.suppression = 0
        self.experience = 0
        self.entrenchment = 0
        
        self.tacticalAI = TacticalAI(unit: self)
        self.group = nil
    }
    
    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.position = try values.decode(HexPoint.self, forKey: .position)
        self.civilization = try values.decode(Civilization.self, forKey: .civilization)
        self.unitType = try values.decode(UnitType.self, forKey: .unitType)
        
        self.sight = try values.decode(Int.self, forKey: .sight)
        self.strength = try values.decode(Int.self, forKey: .strength)
        self.suppression = try values.decode(Int.self, forKey: .suppression)
        self.experience = try values.decode(Int.self, forKey: .experience)
        self.entrenchment = try values.decode(Int.self, forKey: .entrenchment)
        
        self.tacticalAI = TacticalAI(unit: self)
        self.group = nil
    }
    
    // MARK: unit methods
    
    func createGameObject() -> GameObject? {
        
        fatalError("must be overwritten by sub class")
    }
    
    func copy(from unit: Unit) {
        
        self.sight = unit.sight
        self.strength = unit.strength
        self.experience = unit.experience
        self.suppression = unit.suppression
        self.entrenchment = unit.entrenchment
    }
    
    func destroyed() -> Bool {
        
        return self.strength == 0
    }
    
    var properties: UnitProperties? {
        return self.unitType.properties
    }
    
    var supportDistance: Int {
        return self.unitType.properties?.supportDistance ?? 0
    }
    
    func tilesInSight() -> HexArea {

        return HexArea(center: self.position, radius: self.sight)
    }
    
    func isAttacked() -> Bool {
        
        if let tacticalAI = self.tacticalAI {
            return tacticalAI.isAttacked()
        }
        
        return false
    }
    
    func isEnemySpotted() -> Bool {
    
        if let tacticalAI = self.tacticalAI {
            return tacticalAI.isEnemySpotted()
        }
        
        return false
    }
    
    /*func follow(path: HexPath) {
        
        self.movementAI?.follow(path: path)
    }*/
    
    func canEmbark(onto point: HexPoint) -> Bool {
        return false
    }
    
    func canDisembark(onto point: HexPoint) -> Bool {
        return false
    }
    
    func canFound() -> Bool {
        return false // self.properties.
    }
    
    //
    
    var currentStrength: Int {
        
        return self.strength - self.suppression
    }
        
    func apply(damage: Int, suppression: Int) {

        self.strength -= damage
        self.suppression += suppression
            
        if self.strength <= 0 {
            self.strength = 0
            
            fatalError("FIXME")
            //self.delegate?.killed(unit: self)
        }
    }
    
    // MARK: AI methods
    
    func update(in game: Game?) {

        self.tacticalAI?.update(for: game)
    }
}

extension Unit: Encodable {
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.position, forKey: .position)
        try container.encode(self.civilization, forKey: .civilization)
        try container.encode(self.unitType, forKey: .unitType)
        
        try container.encode(self.sight, forKey: .sight)
        try container.encode(self.strength, forKey: .strength)
        try container.encode(self.suppression, forKey: .suppression)
        try container.encode(self.experience, forKey: .experience)
        try container.encode(self.entrenchment, forKey: .entrenchment)
    }
}

extension Unit: Equatable {
    
    static func == (lhs: Unit, rhs: Unit) -> Bool {
        
        return lhs.position == rhs.position
            && lhs.civilization == rhs.civilization
            && lhs.unitType == rhs.unitType
    }
}

extension Unit: Hashable {
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.position)
        hasher.combine(self.civilization)
        hasher.combine(self.unitType)
    }
}
