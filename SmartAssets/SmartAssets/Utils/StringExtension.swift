//
//  StringExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 10.05.21.
//

import Foundation

extension String {

    /// Fetches a localized String with Arguments
    ///
    /// - Parameter arguments: parameters to be added in a string
    /// - Parameter comment: comment to this string
    /// - Returns: localized string
    /// https://stackoverflow.com/questions/26277626/how-to-use-nslocalizedstring-function-with-variables-in-swift
    public func localizedWithFormat(with arguments: CVarArg...) -> String {

        return String(format: self.localized(), arguments: arguments)
    }

    /// Fetches a localized String
    ///
    /// - Returns: return value(String) for key
    /// https://stackoverflow.com/questions/25081757/whats-nslocalizedstring-equivalent-in-swift
    public func localized(withComment comment: String? = nil) -> String {

        if self.starts(with: "TXT_KEY_CITY_NAME_") {
            return NSLocalizedString(
                self,
                tableName: "CityNames",
                bundle: Bundle.init(for: Textures.self),
                value: "",
                comment: comment ?? ""
            )
        }

        if self.starts(with: "TXT_KEY_CIVIC_") {
            return NSLocalizedString(
                self,
                tableName: "Civics",
                bundle: Bundle.init(for: Textures.self),
                value: "",
                comment: comment ?? ""
            )
        }

        if self.starts(with: "TXT_KEY_CIVILIZATION_") {
            return NSLocalizedString(
                self,
                tableName: "Civilizations",
                bundle: Bundle.init(for: Textures.self),
                value: "",
                comment: comment ?? ""
            )
        }

        if self.starts(with: "TXT_KEY_DEDICATION_") {
            return NSLocalizedString(
                self,
                tableName: "Dedications",
                bundle: Bundle.init(for: Textures.self),
                value: "",
                comment: comment ?? ""
            )
        }

        if self.starts(with: "TXT_KEY_") {
            return NSLocalizedString(
                self,
                tableName: nil, // Localizable default
                bundle: Bundle.init(for: Textures.self),
                value: "",
                comment: comment ?? ""
            )
        }

        return self
    }
}
