//
//  Tile.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

class Tile: Decodable {
    
    var point: HexPoint?
    var terrain: Terrain
    var terrainSprite: SKSpriteNode?
    
    var features: [Feature]
    var featureSprites: [SKSpriteNode] = []
    
    var city: City? = nil
    
    var continent: Continent?
    
    var riverName: String? = nil
    var riverFlowNorth: FlowDirection = .none
    var riverFlowNorthEast: FlowDirection = .none
    var riverFlowSouthEast: FlowDirection = .none
    var riverSprite: SKSpriteNode?
    
    var road: Bool = false
    var roadSprite: SKSpriteNode?
    
    var boardSprite: SKSpriteNode?
    
    enum CodingKeys: String, CodingKey {
        case point
        case terrain
        case features

        case riverName
        case riverFlowNorth
        case riverFlowNorthEast
        case riverFlowSouthEast
        case road
    }
    
    init(at point: HexPoint, with terrain: Terrain) {
        self.point = point
        self.terrain = terrain
        self.features = []
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.point = try values.decode(HexPoint.self, forKey: .point)
        self.terrain = try values.decode(Terrain.self, forKey: .terrain)
        self.features = try values.decode([Feature].self, forKey: .features)

        self.riverName = try values.decodeIfPresent(String.self, forKey: .riverName)
        self.riverFlowNorth = try values.decode(FlowDirection.self, forKey: .riverFlowNorth)
        self.riverFlowNorthEast = try values.decode(FlowDirection.self, forKey: .riverFlowNorthEast)
        self.riverFlowSouthEast = try values.decode(FlowDirection.self, forKey: .riverFlowSouthEast)
        self.road = try values.decode(Bool.self, forKey: .road)
    }
    
    func set(feature: Feature) {
        if !self.has(feature: feature) {
            features.append(feature)
        }
    }
    
    func remove(feature: Feature) {
        if self.has(feature: feature) {
            if let index = self.features.firstIndex(of: feature) {
                features.remove(at: index)
            }
        }
    }
    
    func has(feature: Feature) -> Bool {
        return self.features.contains(where: { $0 == feature })
    }
}

extension Tile: Equatable {
    
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        
        guard lhs.point != nil else {
            return false
        }
        
        guard rhs.point != nil else {
            return false
        }
        
        return lhs.point == rhs.point
    }
}

extension Tile: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.point, forKey: .point)
        try container.encode(self.terrain, forKey: .terrain)
        try container.encode(self.features, forKey: .features)
        try container.encodeIfPresent(self.riverName, forKey: .riverName)
        
        try container.encode(self.riverFlowNorth, forKey: .riverFlowNorth)
        try container.encode(self.riverFlowNorthEast, forKey: .riverFlowNorthEast)
        try container.encode(self.riverFlowSouthEast, forKey: .riverFlowSouthEast)
        try container.encode(self.road, forKey: .road)
    }
}

extension Tile {
    
    var isWater: Bool {
        return self.terrain == .ocean || self.terrain == .shore
    }
    
    var isGround: Bool {
        return !self.isWater
    }
}

extension Tile {

    func isNeighbor(to candidate: HexPoint) -> Bool {
        
        return self.point?.distance(to: candidate) == 1
    }
    
    func isRiverToCross(towards target: Tile) -> Bool {
        
        guard let targetPoint = target.point else {
            return false
        }
        
        if !self.isNeighbor(to: targetPoint) {
            return false
        }
        
        guard let direction = self.point?.direction(towards: targetPoint) else {
            return false
        }
        
        switch direction {
        case .north:
            return self.isRiverInNorth()
            
        case .northeast:
            return self.isRiverInNorthEast()
            
        case .southeast:
            return self.isRiverInSouthEast()
            
        case .south:
            return target.isRiverInNorth()
            
        case .southwest:
            return target.isRiverInNorthEast()
            
        case .northwest:
            return target.isRiverInSouthEast()
        }
    }
    
    /// cost to enter a terrain given the specified movementType
    /// -1.0 means not possible
    func movementCost(for movementType: GameObjectMoveType, from source: Tile) -> Float {
        
        // start with terrain cost
        let terrainCost = self.terrain.movementCost(for: movementType)
        
        // add feature costs
        var featureCost: Float = 0.0
        for feature in self.features {
            featureCost += feature.movementCost(for: movementType)
        }
        
        // add river crossing cost
        var riverCost: Float = 0.0
        if source.isRiverToCross(towards: self) {
            riverCost = 1.0 // FIXME - river cost per movementType
        }

        return terrainCost + featureCost + riverCost
    }
}

extension Tile {
    
    func set(river: River?, with flow: FlowDirection) throws {
        self.riverName = river?.name
        
        try setRiver(flow: flow)
    }
    
    func isRiver() -> Bool {
        
        return self.riverName != nil && (self.isRiverInNorth() || self.isRiverInNorthEast() || self.isRiverInSouthEast())
    }
    
    public func isRiverIn(direction: HexDirection) throws -> Bool {
        switch direction {
        case .north:
            return self.isRiverInNorth()
        case .northeast:
            return self.isRiverInNorthEast()
        case .southwest:
            return self.isRiverInSouthEast()
            
        default:
            throw FlowDirectionError.unsupported(flow: .none, in: direction)
        }
    }
    
    public func setRiver(flow: FlowDirection) throws {
        
        switch flow {
        case .northEast:
            try self.setRiverFlowInSouthEast(flow: flow)
        case .southWest:
            try self.setRiverFlowInSouthEast(flow: flow)
        case .northWest:
            try self.setRiverFlowInNorthEast(flow: flow)
        case .southEast:
            try self.setRiverFlowInNorthEast(flow: flow)
        case .east:
            try self.setRiverFlowInNorth(flow: flow)
        case .west:
            try self.setRiverFlowInNorth(flow: flow)
        default:
            throw FlowDirectionError.unsupported(flow: flow, in: .north)
        }
    }
    
    public func setRiver(flow: FlowDirection, in direction: HexDirection) throws {
        
        switch direction {
        case .north:
            try self.setRiverFlowInNorth(flow: flow)
        case .northeast:
            try self.setRiverFlowInNorthEast(flow: flow)
        case .southeast:
            try self.setRiverFlowInSouthEast(flow: flow)
        default:
            throw FlowDirectionError.unsupported(flow: flow, in: direction)
        }
    }
    
    public func isRiverIn(flow: FlowDirection) -> Bool {
        
        return self.riverFlowNorth == flow || self.riverFlowNorthEast == flow || self.riverFlowSouthEast == flow
    }
    
    // river in north can flow from east or west direction
    public func isRiverInNorth() -> Bool {
        return self.riverFlowNorth == .east || self.riverFlowNorth == .west
    }
    
    public func setRiverFlowInNorth(flow: FlowDirection) throws {
        
        guard flow == .east || flow == .west else {
            throw FlowDirectionError.unsupported(flow: flow, in: .north)
        }
        
        self.riverFlowNorth = flow
    }
    
    // river in north east can flow to northwest or southeast direction
    public func isRiverInNorthEast() -> Bool {
        return self.riverFlowNorthEast == .northWest || self.riverFlowNorthEast == .southEast
    }
    
    public func setRiverFlowInNorthEast(flow: FlowDirection) throws {
        
        guard flow == .northWest || flow == .southEast else {
            throw FlowDirectionError.unsupported(flow: flow, in: .northeast)
        }
        
        self.riverFlowNorthEast = flow
    }
    
    // river in south east can flow to northeast or southwest direction
    public func isRiverInSouthEast() -> Bool {
        return self.riverFlowSouthEast == .southWest || self.riverFlowSouthEast == .northEast
    }
    
    public func setRiverFlowInSouthEast(flow: FlowDirection) throws {
        
        guard flow == .southWest || flow == .northEast else {
            throw FlowDirectionError.unsupported(flow: flow, in: .southeast)
        }
        
        self.riverFlowSouthEast = flow
    }
    
    public var flows: [FlowDirection] {
        var result: [FlowDirection] = []
        
        if self.isRiverInNorth() {
            result.append(self.riverFlowNorth)
        }
        
        if self.isRiverInNorthEast() {
            result.append(self.riverFlowNorthEast)
        }
        
        if self.isRiverInSouthEast() {
            result.append(self.riverFlowSouthEast)
        }
        
        return result
    }
}
