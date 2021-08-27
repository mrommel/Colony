//
//  DialogTextAlign.swift
//  SmartColony
//
//  Created by Michael Rommel on 14.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

enum DialogTextAlign: String, Codable {

    case center = "center"
    case left = "left"
    case right = "right"

    func toHorizontalAlignmentMode() -> SKLabelHorizontalAlignmentMode {

        switch self {

        case .center: return .center
        case .left: return .left
        case .right: return .right
        }
    }
}
