//
//  NotificationTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 09.05.21.
//

import SmartAILibrary

extension NotificationType {

    // https://civ6.fandom.com/wiki/Category:Notification_icons
    public func iconTexture() -> String {

        switch self {

        case .turn: return "button-turn"

        case .generic: return "button-default"

        case .techNeeded: return "button-tech-needed"
        case .civicNeeded: return "button-civic-needed"
        case .productionNeeded: return "button-production-needed"
        case .canFoundPantheon: return "button-pantheon-needed"

        case .cityGrowth: return "button-city-growth"
        case .starving: return "button-starving"
        case .diplomaticDeclaration: return "button-diplomatic-declaration"
        case .war: return "button-war"
        case .enemyInTerritory: return "button-enemy-in-territory"
        case .unitPromotion: return "button-promotion"
        case .unitNeedsOrders: return "button-unit-needs-orders"
        case .unitDied: return "button-unit-died"

        case .canChangeGovernment: return "button-change-government"
        case .policiesNeeded: return "button-policies-needed"

        case .greatPersonJoined: return "button-great-person-joined"
        case .canRecruitGreatPerson: return "button-default"

        case .governorTitleAvailable: return "button-default"

        case .cityConquered: return "button-default"
        case .goodyHutDiscovered: return "button-goodyHutDiscovered"
        case .barbarianCampDiscovered: return "button-barbarianCampDiscovered"

        case .waiting: return "button-waiting"

        case .metCityState: return "button-met-city-state"

        case .questCityStateFulfilled: return "button-questCompleted"
        case .questCityStateObsolete: return "button-default"
        case .questCityStateGiven: return "button-default"
        }
    }
}
