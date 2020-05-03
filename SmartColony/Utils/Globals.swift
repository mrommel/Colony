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
        static let water: CGFloat = 1.1
        static let underwater: CGFloat = 1.2
        static let border: CGFloat = 1.3
        static let caldera: CGFloat = 1.5
        static let snow: CGFloat = 2.0
        static let hill: CGFloat = 2.1
        static let focus: CGFloat = 3.0
        static let feature: CGFloat = 4.0
        static let road: CGFloat = 4.1
        static let river: CGFloat = 4.2
        static let path: CGFloat = 4.3
        static let featureUpper: CGFloat = 4.5
        static let resource: CGFloat = 4.9
        //static let staticSprite: CGFloat = 5.0
        static let mountain: CGFloat = 5.4 // 2.2 FIXME
        static let improvement: CGFloat = 5.45
        static let cityName: CGFloat = 5.5
        static let city: CGFloat = 5.8
        static let yields: CGFloat = 5.9
        static let unit: CGFloat = 6.0
        static let unitType: CGFloat = 8.0
        static let unitStrength: CGFloat = 10.0
        static let labels: CGFloat = 50.0
        
        static let sceneElements: CGFloat = 51.0
        static let dialogs: CGFloat = 52.0
        static let progressIndicator: CGFloat = 60.0
        static let notifications: CGFloat = 60.0
        static let bottomElements: CGFloat = 61.0
    }

    struct Visibility {
        static let currently: CGFloat = 1.0
        static let discovered: CGFloat = 0.5
    }

    struct Constants {
        static let initialScale: Double = 0.25
    }
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
