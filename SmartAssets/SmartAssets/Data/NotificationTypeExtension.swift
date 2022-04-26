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
    public func title() -> String {

        switch self {

        case .turn:
            return "-"
        case .generic:
            return "-"
        case .techNeeded:
            return "Choose Research"
        case .civicNeeded:
            return "Choose Civic"
        case .productionNeeded(cityName: let cityName, location: _):
            return "\(cityName) needs production"
        case .canChangeGovernment:
            return "Change government"
        case .policiesNeeded:
            return "Choose policy cards"
        case .canFoundPantheon:
            return "Found a pantheon!"
        case .governorTitleAvailable:
            return "Governor title!"
        case .cityGrowth(cityName: let cityName, population: _, location: _):
            return "\(cityName) has grown"
        case .starving(cityName: let cityName, location: _):
            return "\(cityName) is starving"
        case .diplomaticDeclaration:
            return "diplomaticDeclaration"
        case .war(leader: _):
            return "Declaration of war"
        case .enemyInTerritory:
            return "An Enemy is Near!"
        case .unitPromotion(location: _):
            return "You can choose a Promotion for a unit."
        case .unitNeedsOrders(location: _):
            return "unitNeedsOrders"
        case .unitDied(location: _):
            return "Unit died"
        case .greatPersonJoined:
            return "greatPersonJoined"
        case .canRecruitGreatPerson(greatPerson: _):
            return "Great Person can be recruited"
        case .cityLost(location: _):
            return "City conquered"
        case .goodyHutDiscovered(location: _):
            return "Goodyhut discovered"
        case .barbarianCampDiscovered(location: _):
            return "Barbarian Camp discovered"
        case .metCityState(cityState: _, first: _):
            return "Met City State"
        case .waiting:
            return "Waiting"
        case .questCityStateFulfilled(cityState: _, quest: _):
            return "quest fulfilled"
        case .questCityStateObsolete(cityState: _, quest: _):
            return "quest obsolete"
        case .questCityStateGiven(cityState: _, quest: _):
            return "quest given"
        case .momentAdded(type: _):
            return "moment added"
        case .tradeRouteCapacityIncreased:
            return "Capacity for Trade Routes has increased"
        case .naturalWonderDiscovered(location: _):
            return "natural wonder discovered"
        case .continentDiscovered:
            return "new continent discovered"
        case .wonderBuilt:
            return "wonder built"
        case .cityCanShoot(cityName: let cityName, location: _): // TXT_KEY_NOTIFICATION_CITY_CAN_SHOOT
            return "The City of \(cityName) can attack a nearby enemy!"
        case .cityAcquired(cityName: _, location: _):
            return "Keep City?"
        }
    }

    public func message(in gameModel: GameModel?) -> String {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        switch self {

        case .turn:
            return "-"
        case .generic:
            return "-"
        case .techNeeded:
            return "You may select a new research project."
        case .civicNeeded:
            return "You may select a new civic project."
        case .productionNeeded(cityName: let cityName, location: _):
            return "\(cityName) needs production"
        case .canChangeGovernment:
            return "You can change the government"
        case .policiesNeeded:
            return "Please choose policy cards"
        case .canFoundPantheon:
            return "You have enough faith to found a pantheon!"
        case .governorTitleAvailable:
            return "You have a governor title you can spent."
        case .cityGrowth(cityName: let cityName, population: let population, location: _):
            return "The City of \(cityName) now has \(population) Citizens! " +
                "The new Citizen will automatically work the land near the City for additional " +
                "Food, Production or Gold."
        case .starving(cityName: let cityName, location: _):
            return "The City of \(cityName) is starving"
        case .diplomaticDeclaration:
            return "diplomaticDeclaration"
        case .war(leader: let leader):
            return "\(leader.name()) has declared war on you!"
        case .enemyInTerritory:
            return "An enemy unit has been spotted in our territory!"
        case .unitPromotion(location: _):
            return "A unit has gained enough experience in combat. You can choose a Promotion for this unit."
        case .unitNeedsOrders(location: _):
            return "unitNeedsOrders"
        case .unitDied(location: _):
            return "A unit died"
        case .greatPersonJoined:
            return "greatPersonJoined"
        case .canRecruitGreatPerson(greatPerson: let greatPerson):
            return "You can recruit \(greatPerson.name())"

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
            return "You have fulfilled a quest for \(cityState.name().localized())"
        case .questCityStateObsolete(cityState: _, quest: _):
            return "quest obsolete"
        case .questCityStateGiven(cityState: _, quest: _):
            return "quest given"
        case .momentAdded(type: let messageType):
            return messageType.summary().localized()
        case .tradeRouteCapacityIncreased:
            return "Capacity for Trade Routes has increased"
        case .naturalWonderDiscovered(location: let location):
            if let tile = gameModel.tile(at: location) {
                if tile.feature().isNaturalWonder() {
                    return "natural wonder \(tile.feature()) discovered"
                }
            }
            return "natural wonder discovered"
        case .continentDiscovered(location: _, continentName: let continentName):
            return "We have discovered a new continent. Our explorer is naming it \(continentName)."
        case .wonderBuilt:
            return "wonder built"
        case .cityCanShoot(cityName: let cityName, location: _): // TXT_KEY_NOTIFICATION_SUMMARY_CITY_CAN_SHOOT
            return "\(cityName) can fire upon an enemy!"
        case .cityAcquired(cityName: let cityName, location: _):
            return "You have acquired \(cityName)"
        }
    }
}
