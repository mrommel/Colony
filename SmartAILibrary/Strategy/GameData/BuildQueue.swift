//
//  BuildQueue.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class BuildQueue {
    
    fileprivate var items: [BuildableItem]
    
    init() {
        
        self.items = []
    }
    
    func add(item: BuildableItem) {
        
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
    
    func unit(of unitType: UnitType) -> BuildableItem? {
        
        if let item = self.items.first(where: { $0.type == .unit && $0.unitType == unitType }) {
            return item
        }
        
        return nil
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
