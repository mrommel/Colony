//
//  GreatWorks.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 25.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class GreatWorkPlaceInBuilding: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case building
        case slot
        case used
    }
    
    let building: BuildingType
    let slot: GreatWorkSlotType
    var used: Bool
    
    init(building: BuildingType, slot: GreatWorkSlotType, used: Bool = false) {
        
        self.building = building
        self.slot = slot
        self.used = used
    }
    
    required public init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.building = try container.decode(BuildingType.self, forKey: .building)
        self.slot = try container.decode(GreatWorkSlotType.self, forKey: .slot)
        self.used = try container.decode(Bool.self, forKey: .used)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.building, forKey: .building)
        try container.encode(self.slot, forKey: .slot)
        try container.encode(self.used, forKey: .used)
    }
}

class GreatWorkPlaceInWonder: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case wonder
        case slot
        case used
    }
    
    let wonder: WonderType
    let slot: GreatWorkSlotType
    var used: Bool
    
    init(wonder: WonderType, slot: GreatWorkSlotType, used: Bool = false) {
        
        self.wonder = wonder
        self.slot = slot
        self.used = used
    }
    
    required public init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.wonder = try container.decode(WonderType.self, forKey: .wonder)
        self.slot = try container.decode(GreatWorkSlotType.self, forKey: .slot)
        self.used = try container.decode(Bool.self, forKey: .used)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.wonder, forKey: .wonder)
        try container.encode(self.slot, forKey: .slot)
        try container.encode(self.used, forKey: .used)
    }
}

public class GreatWorks: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case placesInBuildings
        case placesInWonders
    }
    
    internal var city: AbstractCity?
    
    private var placesInBuildings: [GreatWorkPlaceInBuilding] = []
    private var placesInWonders: [GreatWorkPlaceInWonder] = []
    
    // MARK: constructor
    
    init(city: AbstractCity?) {
        
        self.city = city
    }
    
    required public init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.placesInBuildings = try container.decode([GreatWorkPlaceInBuilding].self, forKey: .placesInBuildings)
        self.placesInWonders = try container.decode([GreatWorkPlaceInWonder].self, forKey: .placesInWonders)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.placesInBuildings, forKey: .placesInBuildings)
        try container.encode(self.placesInWonders, forKey: .placesInWonders)
    }
    
    func addPlaces(for building: BuildingType) {
        
        for slot in building.slotsForGreatWork() {
            self.placesInBuildings.append(GreatWorkPlaceInBuilding(building: building, slot: slot))
        }
    }
    
    func addPlaces(for wonder: WonderType) {
        
        for slot in wonder.slotsForGreatWork() {
            self.placesInWonders.append(GreatWorkPlaceInWonder(wonder: wonder, slot: slot))
        }
    }
    
    func slotsAvailable(for slotType: GreatWorkSlotType) -> Int {
        
        var available: Int = 0
        
        for place in self.placesInBuildings {
            if place.slot == slotType && place.used == false {
                available += 1
            }
        }
        
        for place in self.placesInWonders {
            if place.slot == slotType && place.used == false {
                available += 1
            }
        }
        
        return available
    }
}
