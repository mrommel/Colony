//
//  PromotionState.swift
//  SmartAssets
//
//  Created by Michael Rommel on 31.08.21.
//

import Foundation

public enum PromotionState {

    case gained
    case possible
    case disabled

    public static var all: [PromotionState] = [.gained, .possible, .disabled]

    public func iconTexture() -> String {

        switch self {

        case .gained: return "promotion-state-gained"
        case .possible: return "promotion-state-possible"
        case .disabled: return "promotion-state-disabled"
        }
    }
}
