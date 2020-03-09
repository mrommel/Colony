//
//  Utils.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

extension Int {
    public static func random(number: Int) -> Int {
        return Int(arc4random_uniform(UInt32(number)))
    }
}

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

extension Array {

    mutating func prepend(_ newItem: Element) {
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
