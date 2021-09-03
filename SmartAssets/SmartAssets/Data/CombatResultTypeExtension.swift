//
//  CombatResultTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 02.09.21.
//

import SmartAILibrary

extension CombatResultType {

    public var text: String {

        switch self {

        case .totalDefeat: return "Total defeat"
        case .majorDefeat: return "Major defeat"
        case .minorDefeat: return "Minor defeat"
        case .stalemate: return "Stalemate"
        case .minorVictory: return "Minor Victory"
        case .majorVictory: return "Major Victory"
        case .totalVictory: return "Total Victory"
        }
    }

    public var color: TypeColor {

        switch self {

        case .totalDefeat: return TypeColor.sangria
        case .majorDefeat: return TypeColor.sangria
        case .minorDefeat: return TypeColor.venetianRed
        case .stalemate: return TypeColor.matterhornGray
        case .minorVictory: return TypeColor.kellyGreen
        case .majorVictory: return TypeColor.crusoe
        case .totalVictory: return TypeColor.crusoe
        }
    }
}
