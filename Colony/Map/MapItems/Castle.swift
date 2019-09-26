//
//  Castle.swift
//  Colony
//
//  Created by Michael Rommel on 26.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum CastleType: String, Codable {
    
    case normal
}

class Castle: MapItem {
    
    // MARK: constants
    
    static let kName = "name"
    static let kCivilization = "civilization"
    static let kCastleType = "castleType"
    
    // MARK: properties
    
    var name: String
    var civilization: Civilization
    var castleType: CastleType
    
    // MARK: constructors
    
    init(named name: String, at position: HexPoint, civilization: Civilization, castleType: CastleType) {
        
        self.name = name
        self.civilization = civilization
        self.castleType = castleType
        
        super.init(at: position, type: .castle)
    }
    
    init(at position: HexPoint) {
        
        self.name = ""
        self.civilization = .english
        self.castleType = .normal
        
        super.init(at: position, type: .castle)
    }
    
    required init(from decoder: Decoder) throws {

        self.name = ""
        self.civilization = .english
        self.castleType = .normal
        
        try super.init(from: decoder)
    }
    
    // MARK: methods
    
    func createGameObject() -> GameObject? {

        let gameObject = CastleObject(for: self)
        self.gameObject = gameObject
        return gameObject
    }
    
    func copy(from item: MapItem) {
        
        self.dict[Castle.kName] = item.dict[Castle.kName]
        self.dict[Castle.kCivilization] = item.dict[Castle.kCivilization]
        self.dict[Castle.kCastleType] = item.dict[Castle.kCastleType]
    }
    
    override func saveToDict() {
        
        self.dict[Castle.kName] = self.name
        self.dict[Castle.kCivilization] = self.civilization
        self.dict[Castle.kCastleType] = self.castleType
    }
    
    override func loadFromDict() {
        
        self.name = self.dict[Castle.kName] as! String
        self.civilization = Civilization(rawValue: self.dict[Castle.kCivilization] as! String) ?? .english
        self.castleType = CastleType(rawValue: self.dict[Castle.kCastleType] as! String) ?? .normal
    }
}
