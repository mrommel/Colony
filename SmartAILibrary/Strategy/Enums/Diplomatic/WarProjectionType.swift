//
//  WarProjection.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum WarProjectionType: Int, Codable, Comparable {

    case destruction // WAR_PROJECTION_DESTRUCTION
    case defeat // WAR_PROJECTION_DEFEAT
    case stalemate // WAR_PROJECTION_STALEMATE
    case unknown // WAR_PROJECTION_UNKNOWN
    case good // WAR_PROJECTION_GOOD
    case veryGood // WAR_PROJECTION_VERY_GOOD

    public static func < (lhs: WarProjectionType, rhs: WarProjectionType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
