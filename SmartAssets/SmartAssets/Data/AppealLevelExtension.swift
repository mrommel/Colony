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

    public func legendColor() -> TypeColor {

        switch self {

        case .breathtaking: return Globals.Colors.breathtakingAppeal
        case .charming: return Globals.Colors.charmingAppeal
        case .average: return Globals.Colors.averageAppeal
        case .uninviting: return Globals.Colors.uninvitingAppeal
        case .disgusting: return Globals.Colors.disgustingAppeal
        }
    }

    public func legendText() -> String {

        switch self {

        case .breathtaking: return "Breathtaking"
        case .charming: return "Charming"
        case .average: return "Average"
        case .uninviting: return "Uninviting"
        case .disgusting: return "Disgusting"
        }
    }
}
