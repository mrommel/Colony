//
//  Command.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 12.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class Command {

    public let type: CommandType
    public let location: HexPoint

    public init(type: CommandType, location: HexPoint) {

        self.type = type
        self.location = location
    }

    public func title() -> String {

        return self.type.title()
    }
}
