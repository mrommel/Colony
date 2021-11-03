//
//  RankingViewType.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import Foundation

enum RankingViewType {

    case overall
    case score
    case science
    case culture
    case domination
    case religion

    static var all: [RankingViewType] = [
        .overall, .score, .science, .culture, .domination, .religion
    ]

    static var values: [RankingViewType] = [
        .score, .science, .culture, .domination, .religion
    ]

    func name() -> String {

        switch self {

        case .overall:
            return "Overall"
        case .score:
            return "Score"
        case .science:
            return "Science"
        case .culture:
            return "Culture"
        case .domination:
            return "Domination"
        case .religion:
            return "Religion"
        }
    }

    func iconTexture() -> String {

        switch self {

        case .overall:
            return "victoryType-overall"
        case .score:
            return "victoryType-score"
        case .science:
            return "victoryType-science"
        case .culture:
            return "victoryType-culture"
        case .domination:
            return "victoryType-domination"
        case .religion:
            return "victoryType-religion"
            // victoryType-diplomatic
        }
    }
}
