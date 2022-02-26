//
//  PolicyCardSlots.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class PolicyCardSlots {

    public var military: Int // red
    public var economic: Int // yellow
    public var diplomatic: Int // green
    public var wildcard: Int // lila

    public init(military: Int, economic: Int, diplomatic: Int, wildcard: Int) {

        self.military = military
        self.economic = economic
        self.diplomatic = diplomatic
        self.wildcard = wildcard
    }

    public func numberOfSlots(in slotType: PolicyCardSlotType) -> Int {

        switch slotType {

        case .military:
            return self.military
        case .economic:
            return self.economic
        case .diplomatic:
            return self.diplomatic
        case .wildcard:
            return self.wildcard
        case .darkAge:
            return 0
        }
    }

    public func types() -> [PolicyCardSlotType] {

        var list: [PolicyCardSlotType] = []

        for _ in 0..<self.military {
            list.append(.military)
        }

        for _ in 0..<self.economic {
            list.append(.economic)
        }

        for _ in 0..<self.diplomatic {
            list.append(.diplomatic)
        }

        for _ in 0..<self.wildcard {
            list.append(.wildcard)
        }

        return list
    }

    public func hint() -> String {

        return "\(self.military) / \(self.economic) / \(self.diplomatic) / \(self.wildcard)"
    }
}
