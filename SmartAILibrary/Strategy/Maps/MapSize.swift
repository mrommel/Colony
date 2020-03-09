//
//  MapSize.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum MapSize {
    
    case duel
    case tiny
    case small
    case standard
    case custom(width: Int, height: Int)
    
    func numberOfTiles() -> Int {
        
        switch self {

        case .duel:
            return 42 * 22
        case .tiny:
            return 56 * 36
        case .small:
            return 66 * 42
        case .standard:
            return 80 * 52
        case .custom(let width, let height):
            return width * height
        }
    }
    
    func width() -> Int {
        
        switch self {

        case .duel:
            return 42
        case .tiny:
            return 56
        case .small:
            return 66
        case .standard:
            return 80
        case .custom(let width, _):
            return width
        }
    }
    
    func height() -> Int {
        
        switch self {

        case .duel:
            return 22
        case .tiny:
            return 36
        case .small:
            return 42
        case .standard:
            return 52
        case .custom( _, let height):
            return height
        }
    }
}
