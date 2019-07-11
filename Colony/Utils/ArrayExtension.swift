//
//  ArrayExtension.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 04.04.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

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
    
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
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

extension Array{
    mutating func prepend(_ newItem: Element) {
        let copy = self
        self = []
        self.append(newItem)
        self.append(contentsOf: copy)
    }
}

// https://www.hackingwithswift.com/example-code/language/how-to-count-matching-items-in-an-array
extension Collection {
    func count(where condition: (Element) throws -> Bool) rethrows -> Int {
        return try self.filter(condition).count
    }
}
