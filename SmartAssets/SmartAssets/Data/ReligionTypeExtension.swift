//
//  ReligionTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 03.10.21.
//

import SmartAILibrary

extension ReligionType {

    public func iconTexture() -> String {

        switch self {

        case .none: return "religion-default"

        case .atheism: return "religion-atheism"
        case .buddhism: return "religion-buddhism"
        case .catholicism: return "religion-catholicism"
        case .confucianism: return "religion-confucianism"
        case .hinduism: return "religion-hinduism"
        case .islam: return "religion-islam"
        case .judaism: return "religion-judaism"
        case .easternOrthodoxy: return "religion-easternOrthodoxy"
        case .protestantism: return "religion-protestantism"
        case .shinto: return "religion-shinto"
        case .sikhism: return "religion-sikhism"
        case .taoism: return "religion-taoism"
        case .zoroastrianism: return "religion-zoroastrianism"

        case .custom(title: _):
            return "religion-default"
        }
    }
}
