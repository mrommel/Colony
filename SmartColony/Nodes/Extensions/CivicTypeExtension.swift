//
//  CivicTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 18.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension CivicType {
    
    func iconTexture() -> String {
    
        switch self {
        case .stateWorkforce: return "civic_default"
        case .craftsmanship: return "civic_default"
        case .codeOfLaws: return "civic_codeOfLaws"
        case .earlyEmpire: return "civic_default"
        case .foreignTrade: return "civic_default"
        case .mysticism:return "civic_default"
            
        case .militaryTradition: return "civic_default"
        case .defensiveTactics: return "civic_default"
        case .gamesAndRecreation: return "civic_default"
        case .politicalPhilosophy: return "civic_default"
        case .recordedHistory: return "civic_default"
        case .dramaAndPoetry: return "civic_default"
        case .theology: return "civic_default"
        case .militaryTraining: return "civic_default"
        case .navalTradition: return "civic_default"
        case .feudalism: return "civic_default"
        case .medievalFaires: return "civic_default"
        case .civilService: return "civic_default"
        case .guilds: return "civic_default"
        case .mercenaries: return "civic_default"
        case .divineRight: return "civic_default"
        case .enlightenment: return "civic_default"
        case .humanism: return "civic_default"
        case .mercantilism: return "civic_default"
        case .diplomaticService: return "civic_default"
        case .exploration: return "civic_default"
        case .reformedChurch: return "civic_default"
        case .civilEngineering: return "civic_default"
        case .colonialism: return "civic_default"
        case .nationalism: return "civic_default"
        case .operaAndBallet: return "civic_default"
        case .naturalHistory: return "civic_default"
        case .urbanization: return "civic_default"
        case .scorchedEarth: return "civic_default"
        case .conservation: return "civic_default"
        case .massMedia: return "civic_default"
        case .mobilization: return "civic_default"
        case .capitalism: return "civic_default"
        case .ideology: return "civic_default"
        case .nuclearProgram: return "civic_default"
        case .suffrage: return "civic_default"
        case .totalitarianism: return "civic_default"
        case .classStruggle:return "civic_default"
        case .culturalHeritage: return "civic_default"
        case .coldWar: return "civic_default"
        case .professionalSports: return "civic_default"
        case .rapidDeployment: return "civic_default"
        case .spaceRace: return "civic_default"
        }
    }
}
