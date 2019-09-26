//
//  Field.swift
//  Colony
//
//  Created by Michael Rommel on 26.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum FieldType: String, Codable {
    
    case wheat
}

class Field: MapItem {
    
    // MARK: constants
    
    static let kCivilization = "civilization"
    static let kFieldType = "fieldType"
    
    // MARK: properties
    
    var civilization: Civilization
    var fieldType: FieldType
    
    // MARK: constructors
    
    init(at position: HexPoint, civilization: Civilization, fieldType: FieldType) {

        self.civilization = civilization
        self.fieldType = fieldType
        
        super.init(at: position, type: .field)
    }
    
    init(at position: HexPoint) {

        self.civilization = .english
        self.fieldType = .wheat
        
        super.init(at: position, type: .field)
    }
    
    required init(from decoder: Decoder) throws {

        self.civilization = .english
        self.fieldType = .wheat
        
        try super.init(from: decoder)
    }
    
    // MARK: methods
    
    func createGameObject() -> GameObject? {

        let gameObject = FieldObject(for: self)
        self.gameObject = gameObject
        return gameObject
    }
    
    func copy(from item: MapItem) {
        
        self.dict[Field.kCivilization] = item.dict[Field.kCivilization]
        self.dict[Field.kFieldType] = item.dict[Field.kFieldType]
    }
    
    override func saveToDict() {
        
        self.dict[Field.kCivilization] = self.civilization
        self.dict[Field.kFieldType] = self.fieldType
    }
    
    override func loadFromDict() {
        
        self.civilization = Civilization(rawValue: self.dict[Field.kCivilization] as! String) ?? .english
        self.fieldType = FieldType(rawValue: self.dict[Field.kFieldType] as! String) ?? .wheat
    }
}
