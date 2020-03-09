//
//  WeightedList.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class WeightedList<T : Equatable>: CustomDebugStringConvertible {
    
    var items: [WeightedItem<T>]
    
    class WeightedItem<T> {
        
        let itemType: T
        var weight: Int

        init(itemType: T, weight: Int) {
            self.itemType = itemType
            self.weight = weight
        }
    }
    
    init() {

        self.items = []
        
        fill()
    }
    
    func fill() {
        
    }

    func set(weight: Int, for itemType: T) {

        if let item = self.items.first(where: { $0.itemType == itemType }) {
            item.weight = weight
        } else {
            fatalError("not gonna happen")
        }
    }

    func add(weight: Int, for itemType: T) {

        if let item = self.items.first(where: { $0.itemType == itemType }) {
            item.weight += weight
        } else {
            //fatalError("not gonna happen")
            let newItem = WeightedItem<T>(itemType: itemType, weight: weight)
            self.items.append(newItem)
        }
    }

    func weight(of itemType: T) -> Int {

        if let item = self.items.first(where: { $0.itemType == itemType }) {
            return item.weight
        } else {
            fatalError("not gonna happen")
        }
    }

    /*func sorted() -> [T] {

        return self.items.sorted(by: { $0.weight > $1.weight }).map({ $0.itemType })
    }*/
    func sort() {

        self.items.sort(by: { $0.weight > $1.weight })
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
        
        if Int.random(number: abs(sumOfWeights)) <= abs(self.items[0].weight) {
            return self.items[0].itemType
        }
        
        return self.items[1].itemType
    }

    var debugDescription: String {

        var itemText = ""

        for item in self.items {
            itemText += "\(item.itemType):\(item.weight), "
        }

        return "WeightedList: { \(itemText) }"
    }
}
