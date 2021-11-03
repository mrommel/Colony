//
//  WeightedList.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

extension Dictionary where Value: Comparable {
    var sortedByValue: [(Key, Value)] { return Array(self).sorted { $0.1 < $1.1} }
}

extension Dictionary where Key: Comparable {
    var sortedByKey: [(Key, Value)] { return Array(self).sorted { $0.0 < $1.0 } }
}

public class WeightedList<T: Codable & Hashable>: Codable, CustomDebugStringConvertible {

    enum CodingKeys: CodingKey {
        case items
    }

    var items: [T: Double]

    // MARK: constructors

    public init() {

        self.items = [T: Double]()

        self.fill()
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.items = try container.decode(Dictionary<T, Double>.self, forKey: .items)
    }

    // MARK: methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.items, forKey: .items)
    }

    public var keys: Dictionary<T, Double>.Keys {

        return self.items.keys
    }

    func has(itemType: T) -> Bool {

        return self.items[itemType] != nil
    }

    var count: Int {

        return self.items.count
    }

    var isEmpty: Bool {

        return self.items.isEmpty
    }

    func isZero() -> Bool {

        for value in self.items.values where value != 0.0 {
            return false
        }

        return true
    }

    func fill() {

    }

    public func set(weight: Double, for itemType: T) {

        self.items[itemType] = weight
    }

    public func add(weight: Double, for itemType: T) {

        let newValue = (self.items[itemType] ?? 0.0) + weight
        self.items[itemType] = newValue
    }

    public func add(weight: Int, for itemType: T) {

        let newValue = (self.items[itemType] ?? 0.0) + Double(weight)
        self.items[itemType] = newValue
    }

    public func weight(of itemType: T) -> Double {

        return self.items[itemType] ?? 0.0
    }

    func chooseLargest() -> T? {

        if self.items.count < 1 {
            return nil
        }

        return self.items.sortedByValue.reversed()[0].0
    }

    func chooseSecondLargest() -> T? {

        if self.items.count < 2 {
            return nil
        }

        return self.items.sortedByValue.reversed()[1].0
    }

    func chooseFromTopChoices() -> T? {

        if self.items.count < 1 {
            return nil
        }

        if self.items.count < 2 {
            return self.chooseLargest()
        }

        // analyze first two items
        let sortedItems: [(T, Double)] = self.items.sortedByValue.reversed()
        let sumOfWeights: Double = sortedItems[0].1 + sortedItems[1].1

        if Double.random(minimum: 0.0, maximum: fabs(sumOfWeights)) <= fabs(sortedItems[0].1) {
            return sortedItems[0].0
        }

        return sortedItems[1].0
    }

    func chooseRandom() -> T? {

        if self.items.count < 1 {
            return nil
        }

        return self.items.randomElement()?.0
    }

    func append(contentsOf contents: WeightedList<T>) {

        for key in contents.items.keys {

            self.items[key] = contents.items[key]
        }
    }

    func totalWeights() -> Double {

        return self.items.values.reduce(0.0, +)
    }

    func item(by randomValue: Double) -> T? {

        let sortedItems: [(T, Double)] = self.items.sortedByValue.reversed()
        var sum = 0.0

        for item in sortedItems {
            if sum <= randomValue && randomValue < sum + item.1 {
                return item.0
            }

            sum += item.1
        }

        return nil
    }

    func filter(where isIncluded: (T, Double) throws -> Bool) rethrows -> WeightedList<T> {

        let list = WeightedList<T>()

        let filteredItem = try self.items.filter(isIncluded)
        for item in filteredItem {
            list.add(weight: item.value, for: item.key)
        }

        return list
    }

    public func sortedValues() -> [T] {

        let sortedItems: [(T, Double)] = self.items.sortedByValue.reversed()
        return sortedItems.map { $0.0 }
    }

    public var debugDescription: String {

        var itemText = ""

        for item in self.items {
            itemText += "\(item.key): \(item.value), "
        }

        return "WeightedList: { \(itemText) }"
    }
}
/*
extension WeightedList: Sequence {

    public func makeIterator() -> WeightedListIterator<T> {
        return WeightedListIterator<T>(weightedList: self)
    }
}

public struct WeightedListIterator<T: Codable & Hashable>: IteratorProtocol {

    private let weightedList: WeightedList<T>
    private var index = 0

    init(weightedList: WeightedList<T>) {
        self.weightedList = weightedList
    }

    mutating public func next() -> WeightedList<T>.WeightedItem<T>? {

        guard 0 <= index else {
            return nil
        }

        // prevent out of bounds
        guard index < self.weightedList.items.count else {
            return nil
        }

        let point = self.weightedList.items[index]
        index += 1
        return point
    }
}*/
