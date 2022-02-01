//
//  VictoryTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 11.01.22.
//

import SmartAILibrary

extension VictoryType {

    public func iconTexture() -> String {

        switch self {

        case .domination: return "victoryType-domination"
        case .cultural: return "victoryType-culture"
        case .science: return "victoryType-science"
        case .diplomatic: return "victoryType-diplomatic"
        case .religious: return "victoryType-religion"
        case .score: return "victoryType-score"
        case .conquest: return "victoryType-domination"
        }
    }
}
