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

        case .techNeeded: return "button-techNeeded"
        case .civicNeeded: return "button-civicNeeded"
        case .productionNeeded: return "button-productionNeeded"
        case .canFoundPantheon: return "button-pantheonNeeded"

        case .cityGrowth: return "button-cityGrowth"
        case .starving: return "button-starving"
        case .diplomaticDeclaration: return "button-diplomaticDeclaration"
        case .war: return "button-war"
        case .enemyInTerritory: return "button-enemyInTerritory"
        case .unitPromotion: return "button-promotion"
        case .unitNeedsOrders: return "button-unitNeedsOrders"
        case .unitDied: return "button-unitDied"

        case .canChangeGovernment: return "button-changeGovernment"
        case .policiesNeeded: return "button-policiesNeeded"

        case .greatPersonJoined: return "button-greatPersonJoined"
        case .canRecruitGreatPerson: return "button-default"

        case .governorTitleAvailable: return "button-default"

        case .cityLost: return "button-cityLost"
        case .goodyHutDiscovered: return "button-goodyHutDiscovered"
        case .barbarianCampDiscovered: return "button-barbarianCampDiscovered"

        case .waiting: return "button-waiting"

        case .metCityState: return "button-metCityState"

        case .questCityStateFulfilled: return "button-questCompleted"
        case .questCityStateObsolete: return "button-default"
        case .questCityStateGiven: return "button-default"

        case .momentAdded: return "button-momentAdded"
        case .tradeRouteCapacityIncreased: return "button-tradeRouteCapacityIncreased"
        case .naturalWonderDiscovered: return "button-naturalWonderDiscovered"
        case .continentDiscovered: return "button-continentDiscovered"
        case .wonderBuilt: return "button-wonderBuilt"
        case .cityCanShoot: return "button-cityCanShoot"
        case .cityAcquired: return "button-cityAcquired"
        }
    }

    // https://github.com/kouyx/Civ5-mod/blob/9327eabbacdecc34f3cbceed00489d405f7a9823/Civ5_mod_file/Assets/Gameplay/XML/NewText/EN_US/CIV5GameTextInfos_Jon.xml
    // https://github.com/mrobaczyk/civ6/blob/2ddd96f594417b8c6493b83bb73f9190339d6851/Base/Assets/Text/en_US/Notifications_Text.xml
    public func message() -> String {

        switch self {

        case .turn:
            return "-"

        case .generic:
            return "-"

        case .techNeeded:
            return "TXT_KEY_NOTIFICATION_CHOOSE_TECH_MESSAGE".localized() 

        case .civicNeeded:
            return "TXT_KEY_NOTIFICATION_CHOOSE_CIVIC_MESSAGE".localized() 

        case .productionNeeded(cityName: _, location: _):
            return "TXT_KEY_NOTIFICATION_CHOOSE_CITY_PRODUCTION_MESSAGE".localized()

        case .canChangeGovernment:
            return "TXT_KEY_NOTIFICATION_CONSIDER_GOVERNMENT_CHANGE_MESSAGE".localized()

        case .policiesNeeded:
            return "TXT_KEY_NOTIFICATION_FILL_CIVIC_SLOT_MESSAGE".localized()

        case .canFoundPantheon:
            return "TXT_KEY_NOTIFICATION_CHOOSE_PANTHEON_MESSAGE".localized()

        case .governorTitleAvailable:
            return "TXT_KEY_NOTIFICATION_GOVERNOR_TITLE_GAINED_MESSAGE".localized()

        case .cityGrowth(cityName: let cityName, population: _, location: _):
            return "TXT_KEY_NOTIFICATION_CITY_GROWN_MESSAGE".localizedWithFormat(with: [cityName])

        case .starving(cityName: _, location: _):
            return "TXT_KEY_NOTIFICATION_CITY_STARVING_MESSAGE".localized()

        case .diplomaticDeclaration:
            return "TXT_KEY_NOTIFICATION_DIPLOMATIC_DECLARATION_MESSAGE".localized()

        case .war(leader: _):
            return "TXT_KEY_NOTIFICATION_DECLARE_WAR_MESSAGE".localized()

        case .enemyInTerritory:
            return "TXT_KEY_NOTIFICATION_ENEMY_IN_TERRITORY_MESSAGE".localized()

        case .unitPromotion(location: _):
            return "TXT_KEY_NOTIFICATION_UNIT_PROMOTION_AVAILABLE_MESSAGE".localized()

        case .unitNeedsOrders(location: _):
            return "TXT_KEY_NOTIFICATION_COMMAND_UNITS_MESSAGE".localized()

        case .unitDied(location: _):
            return "TXT_KEY_NOTIFICATION_UNIT_DIED_MESSAGE".localized()

        case .greatPersonJoined:
            return "TXT_KEY_NOTIFICATION_GREAT_PERSON_JOINED_MESSAGE".localized()

        case .canRecruitGreatPerson(greatPerson: _):
            return "TXT_KEY_NOTIFICATION_CLAIM_GREAT_PERSON_MESSAGE".localized()

        case .cityLost(location: _):
            return "TXT_KEY_NOTIFICATION_CITY_CONQUERED_MESSAGE".localized()

        case .goodyHutDiscovered(location: _):
            return "TXT_KEY_NOTIFICATION_DISCOVER_GOODY_HUT_MESSAGE".localized()

        case .barbarianCampDiscovered(location: _):
            return "TXT_KEY_NOTIFICATION_NEW_BARBARIAN_CAMP_MESSAGE".localized()

        case .metCityState(cityState: _, first: _):
            return "TXT_KEY_NOTIFICATION_PLAYER_MET_MESSAGE_CITY_STATE_MESSAGE".localized()

        case .waiting:
            return "TXT_KEY_NOTIFICATION_WAITING_MESSAGE".localized()

        case .questCityStateFulfilled(cityState: _, quest: _):
            return "TXT_KEY_NOTIFICATION_CITYSTATE_QUEST_COMPLETED_MESSAGE".localized()

        case .questCityStateObsolete(cityState: _, quest: _):
            return "TXT_KEY_NOTIFICATION_CITYSTATE_QUEST_OBSOLETE_MESSAGE".localized()

        case .questCityStateGiven(cityState: _, quest: _):
            return "TXT_KEY_NOTIFICATION_CITYSTATE_QUEST_GIVEN_MESSAGE".localized()

        case .momentAdded(type: _):
            return "TXT_KEY_NOTIFICATION_MOMENT_ADDED".localized()

        case .tradeRouteCapacityIncreased:
            return "TXT_KEY_NOTIFICATION_TRADE_ROUTE_CAPACITY_INCREASED_MESSAGE".localized()

        case .naturalWonderDiscovered(location: _):
            return "TXT_KEY_NOTIFICATION_DISCOVER_NATURAL_WONDER_MESSAGE".localized()

        case .continentDiscovered:
            return "TXT_KEY_NOTIFICATION_DISCOVER_CONTINENT_MESSAGE".localized()

        case .wonderBuilt:
            return "TXT_KEY_NOTIFICATION_WONDER_COMPLETED_MESSAGE".localized()

        case .cityCanShoot(cityName: _, location: _):
            return "TXT_KEY_NOTIFICATION_CITY_RANGE_ATTACK_MESSAGE".localized()

        case .cityAcquired(cityName: _, location: _):
            return "TXT_KEY_NOTIFICATION_CONSIDER_RAZE_CITY_MESSAGE".localized()
        }
    }

    public func summary(in gameModel: GameModel?) -> String {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        switch self {

        case .turn:
            return "-"

        case .generic:
            return "-"

        case .techNeeded:
            return "TXT_KEY_NOTIFICATION_CHOOSE_TECH_SUMMARY".localized()

        case .civicNeeded:
            return "TXT_KEY_NOTIFICATION_CHOOSE_CIVIC_SUMMARY".localized()

        case .productionNeeded(cityName: let cityName, location: _):
            return "TXT_KEY_NOTIFICATION_CHOOSE_CITY_PRODUCTION_SUMMARY".localizedWithFormat(with: [cityName])

        case .canChangeGovernment:
            return "TXT_KEY_NOTIFICATION_CONSIDER_GOVERNMENT_CHANGE_SUMMARY".localized()

        case .policiesNeeded:
            return "TXT_KEY_NOTIFICATION_FILL_CIVIC_SLOT_SUMMARY".localized()

        case .canFoundPantheon:
            return "TXT_KEY_NOTIFICATION_CHOOSE_PANTHEON_SUMMARY".localized()

        case .governorTitleAvailable:
            return "You have a governor title you can spent."

        case .cityGrowth(cityName: let cityName, population: let population, location: _):
            return "The City of \(cityName) now has \(population) Citizens! " +
                "The new Citizen will automatically work the land near the City for additional " +
                "Food, Production or Gold."

        case .starving(cityName: let cityName, location: _):
            return "\(cityName) does not provide enough [Food] Food for its people to eat. If this continues, it will lose [Citizen] Citizens!" // LOC_NOTIFICATION_CITY_STARVING_SUMMARY

        case .diplomaticDeclaration:
            return "diplomaticDeclaration"

        case .war(leader: let leader):
            return "\(leader.name()) has declared war on you!"

        case .enemyInTerritory:
            return "An enemy unit has been spotted in our territory!"

        case .unitPromotion(location: _):
            return "A unit has gained enough experience in combat. You can choose a Promotion for this unit."

        case .unitNeedsOrders(location: _):
            return "Move a unit or have it perform an operation." // LOC_NOTIFICATION_COMMAND_UNITS_SUMMARY

        case .unitDied(location: _):
            return "A unit died"

        case .greatPersonJoined:
            return "greatPersonJoined"

        case .canRecruitGreatPerson(greatPerson: let greatPerson):
            return "You have earned \(greatPerson.name()), and need to choose whether to accept them or pass on them." // LOC_NOTIFICATION_CLAIM_GREAT_PERSON_SUMMARY

        case .cityLost(location: let location):

            guard let city = gameModel.city(at: location) else {
                fatalError("cant get city")
            }

            if let newOwnerName = city.player?.leader.name() {
                return "\(city.name) has been conquered by \(newOwnerName)"
            }

            return "\(city.name) has been conquered"

        case .goodyHutDiscovered(location: let location):

            if let city = gameModel.nearestCity(at: location, of: gameModel.humanPlayer()) {
                return "Goodyhut near \(city.name) discovered"
            }

            return "Goodyhut discovered"

        case .barbarianCampDiscovered(location: let location):

            if let city = gameModel.nearestCity(at: location, of: gameModel.humanPlayer()) {
                return "Barbarian Camp near \(city.name) discovered"
            }

            return "Barbarian Camp discovered"

        case .metCityState(cityState: let cityState, first: _):
            return "Met City State \(cityState.name().localized())"

        case .waiting:
            return "Waiting"

        case .questCityStateFulfilled(cityState: let cityState, quest: _):
            return "You completed a quest for the \(cityState.name().localized()) and earned a reward: 1 [Envoy] Envoy." // LOC_NOTIFICATION_CITYSTATE_QUEST_COMPLETED_SUMMARY

        case .questCityStateObsolete(cityState: _, quest: _):
            return "quest obsolete"

        case .questCityStateGiven(cityState: let cityState, quest: let quest):
            return "The \(cityState.name().localized()) has given you a new quest: \(quest.summary().localized())." // LOC_NOTIFICATION_CITYSTATE_QUEST_GIVEN_SUMMARY

        case .momentAdded(type: let messageType):
            return messageType.summary().localized()

        case .tradeRouteCapacityIncreased:
            return "You are now able to create and maintain more [TradeRoute] Trade Routes than before." // LOC_NOTIFICATION_TRADE_ROUTE_CAPACITY_INCREASED_SUMMARY

        case .naturalWonderDiscovered(location: let location):
            if let tile = gameModel.tile(at: location) {
                if tile.feature().isNaturalWonder() {
                    return "You have discovered the Natural wonder \(tile.feature().name().localized()) " // LOC_NOTIFICATION_DISCOVER_NATURAL_WONDER_SUMMARY
                }
            }
            return "Natural Wonder Discovered" // LOC_NOTIFICATION_DISCOVER_NATURAL_WONDER_MESSAGE

        case .continentDiscovered(location: _, continentName: let continentName):
            return "We have discovered a new continent. Our explorer is naming it \(continentName)." // LOC_NOTIFICATION_DISCOVER_CONTINENT_SUMMARY

        case .wonderBuilt(wonder: let wonderType, civilization: let civilizationType):
            if civilizationType == .unmet {
                return "An unmet player has finished building the world wonder \(wonderType.name().localized())." // LOC_NOTIFICATION_WONDER_COMPLETED_UNMET_PLAYER_SUMMARY
            } else {
                return "\(civilizationType.name().localized()) has finished building the world wonder \(wonderType.name().localized())." // LOC_NOTIFICATION_WONDER_COMPLETED_SUMMARY
            }

        case .cityCanShoot(cityName: let cityName, location: _):
            return "Your city \(cityName) can perform a ranged attack upon an enemy!" // -

        case .cityAcquired(cityName: let cityName, location: _):
            return "You conquered \(cityName) this turn. Decide whether to liberate, raze, or keep it." // LOC_NOTIFICATION_CONSIDER_RAZE_CITY_SUMMARY
        }
    }

    public func tooltip(in gameModel: GameModel?) -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.message(), // already localized
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        toolTipText.append(NSAttributedString(string: "\n"))

        let content = NSAttributedString(
            string: self.summary(in: gameModel), // already localized
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(content)

        return toolTipText
    }
}
