//
//  Stack.swift
//  Colony
//
//  Created by Michael Rommel on 06.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

public struct Stack<Element> {

    fileprivate var array: [Element] = []

    public init() {}

    public init(array: [Element]) {
        self.array = array
    }

    public mutating func push(_ element: Element) {
        self.array.append(element)
    }

    @discardableResult
    public mutating func pop() -> Element? {
        return self.array.popLast()
    }

    public func peek() -> Element? {

        if !self.array.isEmpty {
            return self.array.last
        } else {
            return nil
        }
    }

    public var isEmpty: Bool {
        return self.array.isEmpty
    }

    public var count: Int {
        return self.array.count
    }

    public mutating func clear() {
        self.array.removeAll()
    }

    public mutating func forEach(_ fun: @escaping (Element) -> Void) {

        self.array.forEach { fun($0) }
    }

    public func toArray() -> [Element] {

        return self.array
    }
}
