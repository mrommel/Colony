//
//  MapSize.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum MapSize {

    case duel
    case tiny
    case small
    case standard
    case large
    case huge
    case custom(width: Int, height: Int)
    
    func numberOfTiles() -> Int {
        
        switch self {

        case .duel, .tiny, .small, .standard, .large, .huge:
            return self.width() * self.height()

        case .custom(let width, let height):
            return width * height
        }
    }
    
    public func width() -> Int {
        
        switch self {

        case .duel:
            return 32
        case .tiny:
            return 42
        case .small:
            return 52
        case .standard:
            return 62
        case .large:
            return 72
        case .huge:
            return 82
        case .custom(let width, _):
            return width
        }
    }
    
    public func height() -> Int {
        
        switch self {

        case .duel:
            return 22
        case .tiny:
            return 32
        case .small:
            return 42
        case .standard:
            return 52
        case .large:
            return 62
        case .huge:
            return 72
        case .custom( _, let height):
            return height
        }
    }
    
    func fogTilesPerBarbarianCamp() -> Int {
        
        switch self {

        case .duel:
            return 13
        case .tiny:
            return 18
        case .small:
            return 23
        case .standard:
            return 27
        case .large:
            return 30
        case .huge:
            return 35
        case .custom(let width, let height):
            return (width * height * 27) / (80 * 52)
        }
    }
    
    func maxActiveReligions() -> Int {
        
        switch self {
        
        case .duel: return 2
        case .tiny: return 4
        case .small: return 5
        case .standard: return 7
        case .large: return 9
        case .huge: return 11
        case .custom(width: _, height: _):
            return 22 // no limit
        }
    }
    
    func targetNumCities() -> Int {
        
        switch self {
        
        case .duel: return 8
        case .tiny: return 10
        case .small: return 15
        case .standard: return 20
        case .large: return 30
        case .huge: return 45
        case .custom(width: _, height: _):
            return 22 // no limit
        }
    }
}

extension MapSize: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0: self = .duel
        case 1: self = .tiny
        case 2: self = .small
        case 3: self = .standard
        case 4: self = .large
        case 5: self = .huge
        default:
            let width = rawValue - ((rawValue / 1000) * 1000)
            let height = rawValue / 1000
            
            self = .custom(width: width, height: height)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .duel:
            try container.encode(0, forKey: .rawValue)
        case .tiny:
            try container.encode(1, forKey: .rawValue)
        case .small:
            try container.encode(2, forKey: .rawValue)
        case .standard:
            try container.encode(3, forKey: .rawValue)
        case .large:
            try container.encode(4, forKey: .rawValue)
        case .huge:
            try container.encode(5, forKey: .rawValue)
        case .custom(width: let width, height: let height):
            try container.encode(width + height * 1000, forKey: .rawValue)
        }
    }
}

extension MapSize: Equatable {
    
    
}
