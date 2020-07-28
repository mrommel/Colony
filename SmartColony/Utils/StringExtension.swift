//
//  StringExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

extension String {
    
    func replaceIcons() -> String {
        
        var tmp = self
        
        tmp = tmp.replacingOccurrences(of: "Civ6StrengthIcon", with: "🗡️")
        tmp = tmp.replacingOccurrences(of: "Civ6RangedStrength", with: "🏹")
        // 🛡
        tmp = tmp.replacingOccurrences(of: "Civ6Production", with: "⚙️")
        tmp = tmp.replacingOccurrences(of: "Civ6Gold", with: "💰")
        tmp = tmp.replacingOccurrences(of: "Housing6", with: "🏠")
        tmp = tmp.replacingOccurrences(of: "Citizen6", with: "👨")
        tmp = tmp.replacingOccurrences(of: "ReligiousStrength6", with: "⛩️")
        tmp = tmp.replacingOccurrences(of: "Civ6Faith", with: "⛪")
        tmp = tmp.replacingOccurrences(of: "Scientist6", with: "👨‍🔬")
        tmp = tmp.replacingOccurrences(of: "Prophet6", with: "🧙‍♂️")
        // 🧪
        tmp = tmp.replacingOccurrences(of: "Amenities6", with: "🍭")
        
        return tmp
    }
}
