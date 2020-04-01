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
