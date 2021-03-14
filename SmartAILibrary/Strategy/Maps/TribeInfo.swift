//
//  TribeInfo.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.03.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation


public class TribeInfo: Codable {
    
    enum CodingKeys: CodingKey {
        
        case type
        case capital
        case area
        case emigrants
        
        case foodHarvestingType
        case sailingInvented
        case agricultureInvented
        case domesticationInvented
    }
    
    public let type: CivilizationType
    public var capital: HexPoint
    public var area: HexArea
    var emigrants: Int
    
    var foodHarvestingType: FoodHarvestingType
    var sailingInvented: Bool
    var agricultureInvented: Bool
    var domesticationInvented: Bool
    
    public init(type: CivilizationType) {
        
        self.type = type
        self.capital = HexPoint.invalid
        self.area = HexArea(points: [])
        self.emigrants = 0
        self.foodHarvestingType = .hunterGatherer
        self.sailingInvented = false
        self.agricultureInvented = false
        self.domesticationInvented = false
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try container.decode(CivilizationType.self, forKey: .type)
        self.capital = try container.decode(HexPoint.self, forKey: .capital)
        self.area = try container.decode(HexArea.self, forKey: .area)
        self.emigrants = try container.decode(Int.self, forKey: .emigrants)
        
        self.foodHarvestingType = try container.decode(FoodHarvestingType.self, forKey: .foodHarvestingType)
        self.sailingInvented = try container.decode(Bool.self, forKey: .sailingInvented)
        self.agricultureInvented = try container.decode(Bool.self, forKey: .agricultureInvented)
        self.domesticationInvented = try container.decode(Bool.self, forKey: .domesticationInvented)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.type, forKey: .type)
        try container.encode(self.capital, forKey: .capital)
        try container.encode(self.area, forKey: .area)
        try container.encode(self.emigrants, forKey: .emigrants)
        
        try container.encode(self.foodHarvestingType, forKey: .foodHarvestingType)
        try container.encode(self.sailingInvented, forKey: .sailingInvented)
        try container.encode(self.agricultureInvented, forKey: .agricultureInvented)
        try container.encode(self.domesticationInvented, forKey: .domesticationInvented)
    }
}
