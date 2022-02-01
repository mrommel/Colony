//
//  Queue.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.01.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public class Queue<T> {

    var list = [T]()

    public init() {

    }

    public func enqueue(_ element: T) {

        self.list.append(element)
    }

    public func dequeue() -> T? {

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
}
