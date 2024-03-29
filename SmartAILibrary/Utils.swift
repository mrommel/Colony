//
//  Utils.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable legacy_random
extension Double {

    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return drand48()
    }

    /**
     Create a random number Double
     
     - parameter min: Double
     - parameter max: Double
     
     - returns: Double
     */
    public static func random(minimum from: Double, maximum to: Double) -> Double {
        let seed = drand48()
        return seed * (to - from) + from
    }
}

extension Double {

    static var min     = -Double.greatestFiniteMagnitude
    static var max     =  Double.greatestFiniteMagnitude

    var positiveValue: Double {

        if self > 0.0 {
            return self
        }

        return 0.0
    }
}

extension Double {

    public var display: String {

        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal

        return formatter.string(for: self) ?? "-"
    }

    public var deltaDisplay: String {

        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        formatter.positivePrefix = "+"

        return formatter.string(for: self) ?? "-"
    }
}

extension Float {

    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        return Float(drand48())
    }

    /**
     Create a random number Double
     
     - parameter min: Double
     - parameter max: Double
     
     - returns: Double
     */
    public static func random(minimum from: Float, maximum to: Float) -> Float {
        let seed = drand48()
        return Float(seed * Double(to - from)) + from
    }
}

extension Collection {

    public func count(where test: (Element) throws -> Bool) rethrows -> Int {
        return try self.filter(test).count
    }
}

// http://stackoverflow.com/questions/27259332/get-random-elements-from-array-in-swift
extension Array {

    /// Returns an array containing this sequence shuffled
    public var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }

    /// Shuffles this sequence in place
    @discardableResult
    public mutating func shuffle() -> Array {
        indices.dropLast().forEach {
            guard case let index = Int.random(number: count - $0) + $0, index != $0 else { return }
            self.swapAt($0, index)
        }
        return self
    }

    // public var chooseOne: Element { return self[Int.random(maximum: self.count)] }

    public func choose(_ number: Int) -> Array { return Array(self.shuffled.prefix(number)) }
}

extension Array {

    public func randomItem() -> Element {
        let index = Int.random(maximum: self.count)
        return self[index]
    }
}

extension Array {

    public func unique<T: Hashable>(map: ((Element) -> (T))) -> [Element] {
        var set = Set<T>() // the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() // keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}

extension Array {

    public mutating func prepend(_ newItem: Element) {
        let copy = self
        self = []
        self.append(newItem)
        self.append(contentsOf: copy)
    }
}

extension Array {

    /// The second element of the collection.
    ///
    /// If the collection is too small, the value of this property is `nil`.
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let secondNumber = numbers.second {
    ///         print(secondNumber)
    ///     }
    ///     // Prints "20"
    public var second: Element? {

        if self.count < 2 {
            return nil
        }

        return self[1]
    }

    /// The third element of the collection.
    ///
    /// If the collection is too small, the value of this property is `nil`.
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let thirdNumber = numbers.third {
    ///         print(thirdNumber)
    ///     }
    ///     // Prints "30"
    public var third: Element? {

        if self.count < 3 {
            return nil
        }

        return self[2]
    }
}

extension IteratorProtocol {

    @discardableResult
    mutating func skip(_ items: Int) -> Element? {
        guard items > 0 else { return next() }
        return skip(items - 1)
    }
}

extension Sequence where Element: Hashable {

    public func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension Int {

    // Returns a random Int point number between 0 and Int.max.
    public static var random: Int {
        return Int.random(number: Int.max)
    }

    /**
    Random integer between 0 and n-1.
    
    - parameter number: Int
    
    - returns: Int
    */
    public static func random(number to: Int) -> Int {
        let seed = drand48()
        return Int(seed * Double(to))
    }

    /**
    Random integer between min and max
    
    - parameter minimum: Int
    - parameter maximum: Int
    
    - returns: Int
    */
    public static func random(minimum from: Int = 0, maximum to: Int) -> Int {
        let seed = drand48()
        return Int(seed * Double(to - from)) + from
    }
}

extension Array where Element: Comparable {

    func containsSameElements(as other: [Element]) -> Bool {

        return self.count == other.count && self.sorted() == other.sorted()
    }
}

extension Thread {

    var isRunningXCTest: Bool {

        for key in self.threadDictionary.allKeys {

            guard let keyAsString = key as? String else {
                continue
            }

            if keyAsString.split(separator: ".").contains("xctest") {
                return true
            }
        }

        return false
    }
}

infix operator ||=
func ||= (lhs: inout Bool, rhs: Bool) { lhs = (lhs || rhs) }
