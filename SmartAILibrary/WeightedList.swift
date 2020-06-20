//
//  WeightedList.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class WeightedList<T : Codable & Equatable>: Codable, CustomDebugStringConvertible {
    
    enum CodingKeys: CodingKey {
        case items
    }
    
    var items: [WeightedItem<T>]
    
    class WeightedItem<T : Codable>: Codable {
        
        enum CodingKeys: CodingKey {
            case item
            case weight
        }
        
        let itemType: T
        var weight: Double

        init(itemType: T, weight: Double) {
            self.itemType = itemType
            self.weight = weight
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.itemType = try container.decode(T.self, forKey: .item)
            self.weight = try container.decode(Double.self, forKey: .weight)
        }
        
        func encode(to encoder: Encoder) throws {
            
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.itemType, forKey: .item)
            try container.encode(self.weight, forKey: .weight)
        }
    }
    
    // MARK: constructors
    
    init() {

        self.items = []
        
        fill()
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.items = try container.decode([WeightedItem<T>].self, forKey: .items)
    }
    
    // MARK: methods
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.items, forKey: .items)
    }
    
    func has(itemType: T) -> Bool {
        
        return self.items.first(where: { $0.itemType == itemType }) != nil
    }
    
    var count: Int {
        
        return self.items.count
    }
    
    func isZero() -> Bool {
        
        for item in self.items {
            if item.weight != 0.0 {
                return false
            }
        }
        
        return true
    }
    
    func fill() {
        
    }

    func set(weight: Double, for itemType: T) {

        if let item = self.items.first(where: { $0.itemType == itemType }) {
            item.weight = weight
        } else {
            let newItem = WeightedItem<T>(itemType: itemType, weight: weight)
            self.items.append(newItem)
        }
    }

    func add(weight: Double, for itemType: T) {

        if let item = self.items.first(where: { $0.itemType == itemType }) {
            item.weight += weight
        } else {
            let newItem = WeightedItem<T>(itemType: itemType, weight: weight)
            self.items.append(newItem)
        }
    }
    
    func add(weight: Int, for itemType: T) {

        if let item = self.items.first(where: { $0.itemType == itemType }) {
            item.weight += Double(weight)
        } else {
            let newItem = WeightedItem<T>(itemType: itemType, weight: Double(weight))
            self.items.append(newItem)
        }
    }

    func weight(of itemType: T) -> Double {

        if let item = self.items.first(where: { $0.itemType == itemType }) {
            return item.weight
        } else {
            fatalError("not gonna happen")
        }
    }

    func sort() {

        self.items.sort(by: { $0.weight > $1.weight })
    }
    
    func sortReverse() {
        
        self.items.sort(by: { $0.weight < $1.weight })
    }
    
    func chooseBest() -> T? {
        
        if self.items.count < 1 {
            return nil
        }
        
        return self.items[0].itemType
    }
    
    func chooseSecondBest() -> T? {
        
        if self.items.count < 2 {
            return nil
        }
        
        return self.items[1].itemType
    }
    
    func chooseFromTopChoices() -> T? {
        
        if self.items.count < 1 {
            return nil
        }
        
        if self.items.count < 2 {
            return self.items.first?.itemType
        }
        
        // analyze first two items
        let sumOfWeights = self.items[0].weight + self.items[1].weight
        
        if Double.random(minimum: 0.0, maximum: fabs(sumOfWeights)) <= fabs(self.items[0].weight) {
            return self.items[0].itemType
        }
        
        return self.items[1].itemType
    }
    
    func append(contentsOf contents: WeightedList<T>) {
        
        self.items.append(contentsOf: contents.items)
    }
    
    func totalWeights() -> Double {
        
        var sum = 0.0
        
        for item in self.items {
            sum += item.weight
        }
        
        return sum
    }
    
    func item(by randomValue: Double) -> T? {
        
        var sum = 0.0
        
        for item in self.items {
            if sum <= randomValue && randomValue < sum + item.weight {
                return item.itemType
            }
            
            sum += item.weight
        }
        
        return nil
    }

    var debugDescription: String {

        var itemText = ""

        for item in self.items {
            itemText += "\(item.itemType):\(item.weight), "
        }

        return "WeightedList: { \(itemText) }"
    }
}
