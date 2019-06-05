//
//  Tile.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

class Tile {
    
    var point: HexPoint?
    var terrain: Terrain
    var terrainSprite: SKSpriteNode?
    
    var features: [Feature]
    var featureSprites: [SKSpriteNode] = []
    
    var continent: Continent?
    var building: Building
    
    var river: River?
    var riverFlowNorth: FlowDirection = .none
    var riverFlowNorthEast: FlowDirection = .none
    var riverFlowSouthEast: FlowDirection = .none
    var riverSprite: SKSpriteNode?
    
    var road: Bool = false
    var roadSprite: SKSpriteNode?
    
    var boardSprite: SKSpriteNode?
    
    init(at point: HexPoint, with terrain: Terrain) {
        self.point = point
        self.terrain = terrain
        self.features = []
        self.building = .none
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

extension Tile {
    
    var water: Bool {
        return self.terrain == .ocean || self.terrain == .shore
    }
    
    var ground: Bool {
        return !self.water
    }
}

extension Tile {
    
    func set(river: River?, with flow: FlowDirection) throws {
        self.river = river
        
        try setRiver(flow: flow)
    }
    
    func isRiver() -> Bool {
        
        return self.river != nil && (self.isRiverInNorth() || self.isRiverInNorthEast() || self.isRiverInSouthEast())
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
