//
//  Animal.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class Animal: Decodable, AIHandable {
    
    // MARK: properties
    
    var position: HexPoint
    let animalType: AnimalType
    
    var state: AIUnitState
    
    // MARK: UI connection
    
    var gameObject: GameObject? = nil
    
    // MARK: coding keys
    
    enum CodingKeys: String, CodingKey {

        case position
        case animalType
        
        case state
    }
    
    // MARK: constructor
    
    init(position: HexPoint, animalType: AnimalType) {
        
        self.position = position
        self.animalType = animalType
        
        self.state = AIUnitState.idleState()
    }
    
    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.position = try values.decode(HexPoint.self, forKey: .position)
        self.animalType = try values.decode(AnimalType.self, forKey: .animalType)
        
        self.state = try values.decode(AIUnitState.self, forKey: .state)
    }
    
    // MARK: unit methods
    
    func createGameObject() -> GameObject? {
        
        fatalError("must be overwritten by sub class")
    }
    
    func update(in game: Game?) {

        switch self.state.transitioning {

        case .began:
            self.handleBeganState(in: game)
        case .running:
            break
        case .ended:
            self.handleEndedState(in: game)
        }
    }

    func handleBeganState(in game: Game?) { }
    func handleEndedState(in game: Game?) { }
}

extension Animal: Encodable {
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.position, forKey: .position)
        try container.encode(self.animalType, forKey: .animalType)
        
        try container.encode(self.state, forKey: .state)
    }
}
