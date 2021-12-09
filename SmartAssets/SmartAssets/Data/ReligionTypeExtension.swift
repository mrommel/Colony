//
//  ReligionTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 03.10.21.
//

import SmartAILibrary

extension ReligionType {

    public func legendColor() -> TypeColor {

        switch self {

        case .none: return Globals.Colors.noneReligion

        case .atheism: return Globals.Colors.atheismReligion
        case .buddhism: return Globals.Colors.buddhismReligion
        case .catholicism: return Globals.Colors.catholicismReligion
        case .confucianism: return Globals.Colors.confucianismReligion
        case .hinduism: return Globals.Colors.hinduismReligion
        case .islam: return Globals.Colors.islamReligion
        case .judaism: return Globals.Colors.judaismReligion
        case .easternOrthodoxy: return Globals.Colors.easternOrthodoxyReligion
        case .protestantism: return Globals.Colors.protestantismReligion
        case .shinto: return Globals.Colors.shintoReligion
        case .sikhism: return Globals.Colors.sikhismReligion
        case .taoism: return Globals.Colors.taoismReligion
        case .zoroastrianism: return Globals.Colors.zoroastrianismReligion

        case .custom(title: _):
            return Globals.Colors.customReligion
        }
    }

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
