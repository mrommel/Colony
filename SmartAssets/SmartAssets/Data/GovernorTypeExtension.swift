//
//  GovernorType.swift
//  SmartAssets
//
//  Created by Michael Rommel on 20.09.21.
//

import SmartAILibrary

extension GovernorType {

    public func portraitTexture() -> String {

        switch self {

        case .reyna: return "governor-portrait-reyna"
        case .victor: return "governor-portrait-victor"
        case .amani: return "governor-portrait-amani"
        case .magnus: return "governor-portrait-magnus"
        case .moksha: return "governor-portrait-moksha"
        case .liang: return "governor-portrait-liang"
        case .pingala: return "governor-portrait-pingala"
        }
    }
}
