//
//  StringExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 10.05.21.
//

import Foundation

extension String {
    
    // https://unicode-table.com/de/emoji/#link-symbols
    public func replaceIcons() -> String {
        
        var tmp = self
        
        tmp = tmp.replacingOccurrences(of: "Civ6StrengthIcon", with: "🗡️")
        tmp = tmp.replacingOccurrences(of: "Civ6RangedStrength", with: "🏹")
        //
        tmp = tmp.replacingOccurrences(of: "Civ6Science", with: "🧪")
        tmp = tmp.replacingOccurrences(of: "Civ6Culture", with: "🏺")
        tmp = tmp.replacingOccurrences(of: "Civ6Production", with: "⚙️")
        tmp = tmp.replacingOccurrences(of: "Civ6Gold", with: "💰")
        tmp = tmp.replacingOccurrences(of: "Housing6", with: "🏠")
        tmp = tmp.replacingOccurrences(of: "Citizen6", with: "👨")
        tmp = tmp.replacingOccurrences(of: "ReligiousStrength6", with: "⛩️")
        tmp = tmp.replacingOccurrences(of: "Civ6Faith", with: "⛪")
        tmp = tmp.replacingOccurrences(of: "Scientist6", with: "👨‍🔬")
        tmp = tmp.replacingOccurrences(of: "Prophet6", with: "🧙‍♂️")
        tmp = tmp.replacingOccurrences(of: "Amenities6", with: "🎡")
        
        tmp = tmp.replacingOccurrences(of: "Capital6", with: "✪")
        tmp = tmp.replacingOccurrences(of: "TradeRoute6", with: "💰")
        tmp = tmp.replacingOccurrences(of: "Governor6", with: "🤵")
        tmp = tmp.replacingOccurrences(of: "Tourism6", with: "🧳")

        tmp = tmp.replacingOccurrences(of: "DiplomaticVisibility6", with: "🗝")
        // 🕊 🛡 👣
        
        // 🤝🙂😐-🙁😡⚔
        // 🎨🎓💎
        
        return tmp
    }
}
