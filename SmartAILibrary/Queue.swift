//
//  Queue.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.01.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public struct Queue<T> {

    fileprivate var list = [T]()

    public init() {

    }

    public mutating func enqueue(_ element: T) {

        self.list.append(element)
    }

    public mutating func dequeue() -> T? {

        if !self.list.isEmpty {
            return self.list.removeFirst()
        } else {
            return nil
        }
    }

    public func peek() -> T? {

        if !self.list.isEmpty {
            return self.list[0]
        } else {
            return nil
        }
    }

    public var isEmpty: Bool {

        return self.list.isEmpty
    }

    var head: T? {
        return self.list.first
    }

    var tail: T? {
        return self.list.last
    }
}
