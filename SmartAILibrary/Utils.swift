//
//  Utils.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

extension Double {

    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }

    /**
     Create a random number Double
     
     - parameter min: Double
     - parameter max: Double
     
     - returns: Double
     */
    public static func random(minimum: Double, maximum: Double) -> Double {
        return Double.random * (maximum - minimum) + minimum
    }
}

extension Collection {
    
    func count(where test: (Element) throws -> Bool) rethrows -> Int {
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
            guard case let index = Int(arc4random_uniform(UInt32(count - $0))) + $0, index != $0 else { return }
            self.swapAt($0, index)
        }
        return self
    }

    public var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }

    public func choose(_ number: Int) -> Array { return Array(shuffled.prefix(number)) }
}

extension Array {

    public func randomItem() -> Element {
        let index = Int.random(minimum: 0, maximum: self.count - 1)
        return self[index]
    }
}

extension Array {

    func unique<T:Hashable>(map: ((Element) -> (T))) -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
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

extension IteratorProtocol {
    
    @discardableResult
    mutating func skip(_ n: Int) -> Element? {
        guard n > 0 else { return next() }
        return skip(n-1)
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
    public static func random(number: Int) -> Int {
        return Int(arc4random_uniform(UInt32(number)))
    }

    /**
    Random integer between min and max
    
    - parameter minimum: Int
    - parameter maximum: Int
    
    - returns: Int
    */
    public static func random(minimum: Int = 0, maximum: Int) -> Int {
        return Int.random(number: maximum - minimum + 1) + minimum
    }
}
