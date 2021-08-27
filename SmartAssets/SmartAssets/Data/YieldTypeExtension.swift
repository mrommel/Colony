//
//  YieldTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 12.05.21.
//

import SmartAILibrary

extension YieldType {

    public func backgroundTexture() -> String {

        switch self {

        case .none: return "box-blue"

        case .food: return "box-food"
        case .production: return "box-production"
        case .gold: return "box-gold"
        case .science: return "box-science"
        case .culture: return "box-culture"
        case .faith: return "box-faith"
        }
    }

    public func iconTexture() -> String {

        switch self {

        case .none: return "none"

        case .food: return "food"
        case .production: return "production"
        case .gold: return "gold"
        case .science: return "science"

        case .culture: return "culture"
        case .faith: return "faith"
        }
    }

    public func fontColor() -> TypeColor {

        switch self {

        case .none: return .white

        case .food: return TypeColor(hex: "#4f6645")!
        case .production: return TypeColor(hex: "#664c38")!
        case .gold: return TypeColor(hex: "#665839")!
        case .science: return TypeColor(hex: "#365066")!

        case .culture: return TypeColor(hex: "#5b4966")!
        case .faith: return TypeColor(hex: "#285966")!
        }
    }
}
