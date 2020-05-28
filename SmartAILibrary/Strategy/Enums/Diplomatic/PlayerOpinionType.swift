//
//  PlayerOpinionType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum PlayerOpinionType: Int, Codable {

    case none

    case ally
    case friend
    case favorable
    case neutral
    case competitor
    case enemy
    case unforgivable
}
