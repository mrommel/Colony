//
//  AppealLevelExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 06.12.21.
//

import SmartAILibrary

extension AppealLevel {

    public func textureName() -> String {

        switch self {

        case .breathtaking: return "appeal-tile-breathtaking"
        case .charming: return "appeal-tile-charming"
        case .average: return "appeal-tile-average"
        case .uninviting: return "appeal-tile-uninviting"
        case .disgusting: return "appeal-tile-disgusting"
        }
    }
}
