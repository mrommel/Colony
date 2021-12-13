//
//  StringExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 10.05.21.
//

import Foundation

extension String {

    // https://stackoverflow.com/questions/25081757/whats-nslocalizedstring-equivalent-in-swift
    public func localized(withComment comment: String? = nil) -> String {

        if self.starts(with: "TXT_KEY_") {
            return NSLocalizedString(
                self,
                tableName: nil,
                bundle: Bundle.init(for: Textures.self),
                value: "",
                comment: comment ?? ""
            )
        }

        return self
    }

    // https://unicode-table.com/de/emoji/#link-symbols
    public func replaceIcons() -> String {

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
