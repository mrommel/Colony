//
//  BuildQueue.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class BuildQueue: Codable {
    
    enum CodingKeys: CodingKey {
    
        case items
    }
    
    fileprivate var items: [BuildableItem]
    
    init() {
        
        self.items = []
    }
    
    required public init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.items = try container.decode([BuildableItem].self, forKey: .items)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.items, forKey: .items)
    }
    
    public func add(item: BuildableItem) {
        
        self.items.append(item)
    }
    
    func remove(item: BuildableItem) {
    
        self.items.removeAll(where: { $0 == item })
    }
    
    func building(of buildingType: BuildingType) -> BuildableItem? {
        
        if let item = self.items.first(where: { $0.type == .building && $0.buildingType == buildingType }) {
            return item
        }
        
        return nil
    }
    
    public func isBuilding(buildingType: BuildingType) -> Bool {
        
        for item in self.items {
            
            if let type = item.buildingType {
                if type == buildingType {
                    return true
                }
            }
        }
        
        return false
    }
    
    func unit(of unitType: UnitType) -> BuildableItem? {
        
        if let item = self.items.first(where: { $0.type == .unit && $0.unitType == unitType }) {
            return item
        }
        
        return nil
    }
    
    public func hasBuildable() -> Bool {
        
        return self.items.count > 0
    }
    
    public func peek() -> BuildableItem? {
        
        return self.items.first
    }
    
    func pop() {
        
        self.items.removeFirst()
    }
    
    func clear() {
        
        self.items.removeAll()
    }
    
    public var count: Int {
        
        return self.items.count
    }
}

extension BuildQueue: Sequence {
    
    public func makeIterator() -> BuildQueueIterator {
        return BuildQueueIterator(queue: self)
    }
}

public struct BuildQueueIterator: IteratorProtocol {
    
    private let queue: BuildQueue
    private var index = 0
    
    init(queue: BuildQueue) {
        self.queue = queue
    }
    
    mutating public func next() -> BuildableItem? {
        
        guard 0 <= index else {
            return nil
        }
        
        // prevent out of bounds
        guard index < self.queue.items.count else {
            return nil
        }
        
        let item = self.queue.items[index]
        index += 1
        return item
    }
}
