//
//  Stack.swift
//  Colony
//
//  Created by Michael Rommel on 06.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

struct Stack<Element> {

    fileprivate var array: [Element] = []

    mutating func push(_ element: Element) {
        self.array.append(element)
    }

    @discardableResult
    mutating func pop() -> Element? {
        return self.array.popLast()
    }

    func peek() -> Element? {
        return self.array.last
    }

    var isEmpty: Bool {
        return self.array.isEmpty
    }

    var count: Int {
        return self.array.count
    }

    mutating func clear() {
        self.array.removeAll()
    }
}
