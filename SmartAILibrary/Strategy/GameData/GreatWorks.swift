//
//  GreatWorks.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 25.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class GreatWorkPlaces: Codable {
    
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

public class GreatWorks: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case places
    }
    
    internal var city: AbstractCity?
    
    private var places: [GreatWorkPlaces] = []
    
    // MARK: constructor
    
    init(city: AbstractCity?) {
        
        self.city = city
    }
    
    required public init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.places = try container.decode([GreatWorkPlaces].self, forKey: .places)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.places, forKey: .places)
    }
    
    func addPlaces(for building: BuildingType) {
        
        for slot in building.slotsForGreatWork() {
            self.places.append(GreatWorkPlaces(building: building, slot: slot))
        }
    }
    
    //func add
    
    func slotsAvailable(for slotType: GreatWorkSlotType) -> Int {
        
        var available: Int = 0
        
        for place in self.places {
            if place.slot == slotType && place.used == false {
                available += 1
            }
        }
        
        return available
    }
}
