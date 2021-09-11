//
//  ProjectType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum ProjectCategory {

    case city
    case district
    case competition
}

public enum ProjectType: Int, Codable {

    // city
    case repairOuterDefenses

    // district
    case breadAndCircuses
    case campusResearchGrants
    // ...

    // competition

    static var all: [ProjectType] {
        return [
            // city
            .repairOuterDefenses,

            // district
            .breadAndCircuses, .campusResearchGrants

            // competition
        ]
    }

    func flavours() -> [Flavor] {

        return []
    }

    func required() -> TechType? {

        return nil
    }

    // in production units
    func productionCost() -> Int {

        return 0
    }
}
