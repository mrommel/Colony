//
//  MoveOptions.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public struct MoveOptions : OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    static public let none        = MoveOptions([])
    static public let declareWar  = MoveOptions(rawValue: 1 << 0)
    static public let attack      = MoveOptions(rawValue: 1 << 1)
    static public let stayOnLand  = MoveOptions(rawValue: 1 << 2)
}
