//
//  Globals.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import UIKit

public struct Globals {
    
    struct ZLevels {
        static let terrain: CGFloat = 1.0
        static let underwater: CGFloat = 1.1
        static let caldera: CGFloat = 1.5
        static let snow: CGFloat = 2.0
        static let hill: CGFloat = 2.1
        static let focus: CGFloat = 3.0
        static let feature: CGFloat = 4.0
        static let road: CGFloat = 4.1
        static let river: CGFloat = 4.2
        static let path: CGFloat = 4.3
        static let featureUpper: CGFloat = 4.5
        static let staticSprite: CGFloat = 5.0
        static let cityName: CGFloat = 5.5
        static let sprite: CGFloat = 6.0
        static let mountain: CGFloat = 7.1 // 2.2 FIXME
        static let unitType: CGFloat = 8.0
        static let unitStrength: CGFloat = 10.0
        static let labels: CGFloat = 50.0
        static let sceneElements: CGFloat = 51.0
        static let dialogs: CGFloat = 52.0
        static let messages: CGFloat = 60.0
    }

    struct Visibility {
        static let currently: CGFloat = 1.0
        static let discovered: CGFloat = 0.5
    }

    static let initialScale: CGFloat = 0.25
}

public extension Globals {
    
    struct Fonts {
        
        public static let systemFontBold = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        public static let systemFontBoldFamilyname = systemFontBold.familyName
        
        public static let systemFont = UIFont.systemFont(ofSize: 24)
        public static let systemFontFamilyname = systemFont.familyName
        
        public static let customFontBold = UIFont(name: "DIN Next for AVM", size: 24)
        public static let customFontBoldFamilyname = "DIN Next for AVM"
        
        public static let customFont = UIFont(name: "DIN Next for AVM", size: 24)
        public static let customFontFamilyname = "DIN Next for AVM"
    }
}