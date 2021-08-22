//
//  StringExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

extension String {
    
    // https://unicode-table.com/de/emoji/#link-symbols
    func replaceIcons() -> String {
        
        var temp = self
        
        temp = temp.replacingOccurrences(of: "Civ6StrengthIcon", with: "🗡️")
        temp = temp.replacingOccurrences(of: "Civ6RangedStrength", with: "🏹")
        //
        temp = temp.replacingOccurrences(of: "Civ6Science", with: "🧪")
        temp = temp.replacingOccurrences(of: "Civ6Culture", with: "🏺")
        temp = temp.replacingOccurrences(of: "Civ6Production", with: "⚙️")
        temp = temp.replacingOccurrences(of: "Civ6Gold", with: "💰")
        temp = temp.replacingOccurrences(of: "Housing6", with: "🏠")
        temp = temp.replacingOccurrences(of: "Citizen6", with: "👨")
        temp = temp.replacingOccurrences(of: "ReligiousStrength6", with: "⛩️")
        temp = temp.replacingOccurrences(of: "Civ6Faith", with: "⛪")
        temp = temp.replacingOccurrences(of: "Scientist6", with: "👨‍🔬")
        temp = temp.replacingOccurrences(of: "Prophet6", with: "🧙‍♂️")
        temp = temp.replacingOccurrences(of: "Amenities6", with: "🎡")
        
        temp = temp.replacingOccurrences(of: "Capital6", with: "✪")
        temp = temp.replacingOccurrences(of: "TradeRoute6", with: "💰")
        temp = temp.replacingOccurrences(of: "Governor6", with: "🤵")
        temp = temp.replacingOccurrences(of: "Tourism6", with: "🧳")

        temp = temp.replacingOccurrences(of: "DiplomaticVisibility6", with: "🗝")
        // 🕊 🛡 👣
        
        // 🤝🙂😐-🙁😡⚔
        // 🎨🎓💎
        
        return temp
    }
}
