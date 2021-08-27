//
//  CivilizationTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 09.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

extension CivilizationType {

    func iconTexture() -> String {

        switch self {

        case .barbarian: return "civilization_barbarian"

        case .greek: return "civilization_greek"
        case .roman: return "civilization_roman"
        case .english: return "civilization_english"
        case .aztecs: return "civilization_aztecs"
        case .persian: return "civilization_persian"
        case .french: return "civilization_french"
        case .egyptian: return "civilization_egyptian"
        case .german: return "civilization_german"
        case .russian: return "civilization_russian"
        }
    }

    func iconColor() -> UIColor {

        switch self {

        case .barbarian: return UIColor(hex: "#000000")

        case .greek: return UIColor(hex: "#418dfe")
        case .roman: return UIColor(hex: "#f0c800")
        case .english: return UIColor(hex: "#ffffff")
        case .aztecs: return UIColor(hex: "#A43E25")
        case .persian: return UIColor(hex: "#9A2B22")
        case .french: return UIColor(hex: "#EBEB8B")
        case .egyptian: return UIColor(hex: "#5400d1")
        case .german: return UIColor(hex: "#252b21")
        case .russian: return UIColor(hex: "#000000")
        }
    }

    func backgroundColor() -> UIColor {

        switch self {

        case .barbarian: return UIColor(hex: "#be0000")

        case .greek: return UIColor(hex: "#ffffff")
        case .roman: return UIColor(hex: "#460076")
        case .english: return UIColor(hex: "#ff92fd")
        case .aztecs: return UIColor(hex: "#9CE8C2")
        case .persian: return UIColor(hex: "#7BACF8")
        case .french: return UIColor(hex: "#0000CD")
        case .egyptian: return UIColor(hex: "#fffd03")
        case .german: return UIColor(hex: "#b4b3b9")
        case .russian: return UIColor(hex: "#f0b400")
        }
    }
}
