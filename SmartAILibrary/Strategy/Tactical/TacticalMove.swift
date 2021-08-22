//
//  TacticalMove.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class TacticalMove {

    var moveType: TacticalMoveType
    var priority: Int

    init() {

        self.moveType = .unassigned
        self.priority = TacticalMoveType.unassigned.priority()
    }
}

extension TacticalMove: Comparable {

    // this will sort highest priority to the beginning
    static func < (lhs: TacticalMove, rhs: TacticalMove) -> Bool {
        return lhs.priority > rhs.priority
    }

    static func == (lhs: TacticalMove, rhs: TacticalMove) -> Bool {
        return lhs.priority == rhs.priority && lhs.moveType == rhs.moveType
    }
}

extension TacticalMove: CustomStringConvertible, CustomDebugStringConvertible {

    var description: String {
        return "TacticalMove(\(self.priority), \(self.moveType))"
    }

    var debugDescription: String {
        return "TacticalMove(\(self.priority), \(self.moveType))"
    }
}
