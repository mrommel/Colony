//
//  CivicTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.05.21.
//

import SmartAILibrary

extension CivicType {
    
    func iconTexture() -> String {
    
        switch self {
        
        case .none: return "civic-default"
            
            // ancient
        case .stateWorkforce: return "civic-stateWorkforce"
        case .craftsmanship: return "civic-craftsmanship"
        case .codeOfLaws: return "civic-codeOfLaws"
        case .earlyEmpire: return "civic-earlyEmpire"
        case .foreignTrade: return "civic-foreignTrade"
        case .mysticism:return "civic-mysticism"
            
            // classical
        case .militaryTradition: return "civic-default"
        case .defensiveTactics: return "civic-default"
        case .gamesAndRecreation: return "civic-default"
        case .politicalPhilosophy: return "civic-default"
        case .recordedHistory: return "civic-default"
        case .dramaAndPoetry: return "civic-default"
        case .theology: return "civic-default"
        case .militaryTraining: return "civic-default"
        case .navalTradition: return "civic-default"
        case .feudalism: return "civic-default"
        case .medievalFaires: return "civic-default"
        case .civilService: return "civic-default"
        case .guilds: return "civic-default"
        case .mercenaries: return "civic-default"
        case .divineRight: return "civic-default"
        case .enlightenment: return "civic-default"
        case .humanism: return "civic-default"
        case .mercantilism: return "civic-default"
        case .diplomaticService: return "civic-default"
        case .exploration: return "civic-default"
        case .reformedChurch: return "civic-default"
        case .civilEngineering: return "civic-default"
        case .colonialism: return "civic-default"
        case .nationalism: return "civic-default"
        case .operaAndBallet: return "civic-default"
        case .naturalHistory: return "civic-default"
        case .urbanization: return "civic-default"
        case .scorchedEarth: return "civic-default"
        case .conservation: return "civic-default"
        case .massMedia: return "civic-default"
        case .mobilization: return "civic-default"
        case .capitalism: return "civic-default"
        case .ideology: return "civic-default"
        case .nuclearProgram: return "civic-default"
        case .suffrage: return "civic-default"
        case .totalitarianism: return "civic-default"
        case .classStruggle:return "civic-default"
        case .culturalHeritage: return "civic-default"
        case .coldWar: return "civic-default"
        case .professionalSports: return "civic-default"
        case .rapidDeployment: return "civic-default"
        case .spaceRace: return "civic-default"
        }
    }
}
