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
}
