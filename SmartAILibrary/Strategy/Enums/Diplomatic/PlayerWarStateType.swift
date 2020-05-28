//
//  PlayerWarStateType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum PlayerWarStateType: Int, Comparable, Codable {

    case none

    case nearlyDefeated
    case defensive
    case stalemate
    case calm
    case offensive
    case nearlyWon
    
    static func < (lhs: PlayerWarStateType, rhs: PlayerWarStateType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
