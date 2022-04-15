//
//  NotificationType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// todo: add parameter to enum
public enum NotificationType {

    case turn // 0

    case generic // 1

    case techNeeded // 2
    case civicNeeded // 3
    case productionNeeded(cityName: String, location: HexPoint) // 4
    case canChangeGovernment // 5
    case policiesNeeded // 6
    case canFoundPantheon // 7
    case governorTitleAvailable // 8

    case cityGrowth(cityName: String, population: Int, location: HexPoint) // 9
    case starving(cityName: String, location: HexPoint) // 10 parameter: city

    case diplomaticDeclaration // 11 parameter: player
    case war(leader: LeaderType) // 12
    case enemyInTerritory // 13 parameter: location, player

    case unitPromotion(location: HexPoint) // 14
    case unitNeedsOrders(location: HexPoint) // 15
    case unitDied(location: HexPoint) // 16

    case greatPersonJoined // 17 parameter: location
    case canRecruitGreatPerson(greatPerson: GreatPerson) // 18 parameter: greatPerson

    case cityLost(location: HexPoint) // 19
    case goodyHutDiscovered(location: HexPoint) // 20
    case barbarianCampDiscovered(location: HexPoint) // 21

    case waiting // 22

    case metCityState(cityState: CityStateType, first: Bool) // 23
    case questCityStateFulfilled(cityState: CityStateType, quest: CityStateQuestType) // 24
    case questCityStateObsolete(cityState: CityStateType, quest: CityStateQuestType) // 25
    case questCityStateGiven(cityState: CityStateType, quest: CityStateQuestType) // 26

    case momentAdded(type: MomentType) // 27
    case tradeRouteCapacityIncreased // 28

    case naturalWonderDiscovered(location: HexPoint) // 29
    case continentDiscovered(location: HexPoint, continentName: String) // 30
    case wonderBuilt // 31

    case cityCanShoot(cityName: String, location: HexPoint) // 32
    case cityAcquired(cityName: String, location: HexPoint) // 33

    public static var all: [NotificationType] = [
        .turn,
        .generic,
        .techNeeded,
        .civicNeeded,
        .productionNeeded(cityName: "", location: HexPoint.invalid),
        .canChangeGovernment,
        .policiesNeeded,
        .canFoundPantheon,
        .governorTitleAvailable,
        .cityGrowth(cityName: "", population: 0, location: HexPoint.invalid),
        .starving(cityName: "", location: HexPoint.invalid),
        .diplomaticDeclaration,
        .war(leader: LeaderType.none),
        .enemyInTerritory,
        .unitPromotion(location: HexPoint.invalid),
        .unitNeedsOrders(location: HexPoint.invalid),
        .unitDied(location: HexPoint.invalid),
        .greatPersonJoined,
        .canRecruitGreatPerson(greatPerson: .abuAlQasimAlZahrawi),
        .cityLost(location: HexPoint.invalid),
        .goodyHutDiscovered(location: HexPoint.invalid),
        .barbarianCampDiscovered(location: HexPoint.invalid),
        .metCityState(cityState: CityStateType.amsterdam, first: true),
        .waiting,
        .questCityStateFulfilled(cityState: CityStateType.amsterdam, quest: CityStateQuestType.none),
        .questCityStateObsolete(cityState: CityStateType.amsterdam, quest: CityStateQuestType.none),
        .questCityStateGiven(cityState: CityStateType.amsterdam, quest: CityStateQuestType.none),
        .momentAdded(type: MomentType.shipSunk),
        .tradeRouteCapacityIncreased,
        .naturalWonderDiscovered(location: HexPoint.invalid),
        .continentDiscovered(location: HexPoint.invalid, continentName: ""),
        .wonderBuilt,
        .cityCanShoot(cityName: "", location: HexPoint.invalid),
        .cityAcquired(cityName: "", location: HexPoint.invalid)
    ]

    func value() -> Int {

        switch self {

        case .turn:
            return 0
        case .generic:
            return 1
        case .techNeeded:
            return 2
        case .civicNeeded:
            return 3
        case .productionNeeded:
            return 4
        case .canChangeGovernment:
            return 5
        case .policiesNeeded:
            return 6
        case .canFoundPantheon:
            return 7
        case .governorTitleAvailable:
            return 8
        case .cityGrowth:
            return 9
        case .starving:
            return 10
        case .diplomaticDeclaration:
            return 11
        case .war:
            return 12
        case .enemyInTerritory:
            return 13
        case .unitPromotion:
            return 14
        case .unitNeedsOrders:
            return 15
        case .unitDied(location: _):
            return 16
        case .greatPersonJoined:
            return 17
        case .canRecruitGreatPerson(greatPerson: _):
            return 18
        case .cityLost(location: _):
            return 19
        case .goodyHutDiscovered(location: _):
            return 20
        case .barbarianCampDiscovered(location: _):
            return 21
        case .waiting:
            return 22
        case .metCityState(cityState: _, first: _):
            return 23
        case .questCityStateFulfilled(cityState: _, quest: _):
            return 24
        case .questCityStateObsolete(cityState: _, quest: _):
            return 25
        case .questCityStateGiven(cityState: _, quest: _):
            return 26
        case .momentAdded(type: _):
            return 27
        case .tradeRouteCapacityIncreased:
            return 28
        case .naturalWonderDiscovered(location: _):
            return 29
        case .continentDiscovered(location: _, continentName: _):
            return 30
        case .wonderBuilt:
            return 31
        case .cityCanShoot(cityName: _, location: _):
            return 32
        case .cityAcquired(cityName: _, location: _):
            return 33
        }
    }

    public func sameType(as type: NotificationType) -> Bool {

        return self.value() == type.value()
    }
}

extension NotificationType: Codable {

    enum CodingKeys: CodingKey {

        case rawValue // Int
        case locationValue // HexPoint
        case cityNameValue // String
        case cityPopulationValue // Int
        case leaderValue // LeaderType
        case greatPersonValue // GreatPersonType
        case boolValue
        case cityStateValue // CityStateType
        case questValue // QuestType
        case momentValue // MomentType
        case continentNameValue // String
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let rawValue = try container.decode(Int.self, forKey: .rawValue)

        switch rawValue {

        case 0:
            self = .turn
        case 1:
            self = .generic
        case 2:
            self = .techNeeded
        case 3:
            self = .civicNeeded
        case 4:
            let cityName = try container.decode(String.self, forKey: .cityNameValue)
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .productionNeeded(cityName: cityName, location: location)
        case 5:
            self = .canChangeGovernment
        case 6:
            self = .policiesNeeded
        case 7:
            self = .canFoundPantheon
        case 8: // parameter: player
            self = .governorTitleAvailable
        case 9: // parameter: city
            let cityName = try container.decode(String.self, forKey: .cityNameValue)
            let population = try container.decode(Int.self, forKey: .cityPopulationValue)
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .cityGrowth(cityName: cityName, population: population, location: location)
        case 10: // parameter: city
            let cityName = try container.decode(String.self, forKey: .cityNameValue)
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .starving(cityName: cityName, location: location)
        case 11: // parameter: player
            self = .diplomaticDeclaration
        case 12: // parameter: player
            let leader = try container.decode(LeaderType.self, forKey: .leaderValue)
            self = .war(leader: leader)
        case 13: // parameter: location, player
            self = .enemyInTerritory
        case 14:
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .unitPromotion(location: location)
        case 15:
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .unitNeedsOrders(location: location)
        case 16: // parameter: location
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .unitDied(location: location)
        case 17:
            self = .greatPersonJoined
        case 18:
            let greatPerson = try container.decode(GreatPerson.self, forKey: .greatPersonValue)
            self = .canRecruitGreatPerson(greatPerson: greatPerson)
        case 19:
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .cityLost(location: location)
        case 20:
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .goodyHutDiscovered(location: location)
        case 21:
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .barbarianCampDiscovered(location: location)
        case 22:
            self = .waiting
        case 23:
            let cityState = try container.decode(CityStateType.self, forKey: .cityStateValue)
            let first = try container.decode(Bool.self, forKey: .boolValue)
            self = .metCityState(cityState: cityState, first: first)
        case 24:
            let cityState = try container.decode(CityStateType.self, forKey: .cityStateValue)
            let quest = try container.decode(CityStateQuestType.self, forKey: .questValue)
            self = .questCityStateFulfilled(cityState: cityState, quest: quest)
        case 25:
            let cityState = try container.decode(CityStateType.self, forKey: .cityStateValue)
            let quest = try container.decode(CityStateQuestType.self, forKey: .questValue)
            self = .questCityStateObsolete(cityState: cityState, quest: quest)
        case 26:
            let cityState = try container.decode(CityStateType.self, forKey: .cityStateValue)
            let quest = try container.decode(CityStateQuestType.self, forKey: .questValue)
            self = .questCityStateGiven(cityState: cityState, quest: quest)
        case 27:
            let moment = try container.decode(MomentType.self, forKey: .momentValue)
            self = .momentAdded(type: moment)
        case 28:
            self = .tradeRouteCapacityIncreased
        case 29:
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .naturalWonderDiscovered(location: location)
        case 30:
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            let continentName = try container.decode(String.self, forKey: .continentNameValue)
            self = .continentDiscovered(location: location, continentName: continentName)
        case 31:
            self = .wonderBuilt
        case 32:
            let cityName = try container.decode(String.self, forKey: .cityNameValue)
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .cityCanShoot(cityName: cityName, location: location)
        case 33:
            let cityName = try container.decode(String.self, forKey: .cityNameValue)
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .cityAcquired(cityName: cityName, location: location)

        default:
            fatalError("value \(rawValue) not handled")
        }
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {

        case .turn:
            try container.encode(0, forKey: .rawValue)

        case .generic:
            try container.encode(1, forKey: .rawValue)

        case .techNeeded:
            try container.encode(2, forKey: .rawValue)

        case .civicNeeded:
            try container.encode(3, forKey: .rawValue)

        case .productionNeeded:
            try container.encode(4, forKey: .rawValue)

        case .canChangeGovernment:
            try container.encode(5, forKey: .rawValue)

        case .policiesNeeded:
            try container.encode(6, forKey: .rawValue)

        case .canFoundPantheon:
            try container.encode(7, forKey: .rawValue)

        case .governorTitleAvailable:
            try container.encode(8, forKey: .rawValue)

        case .cityGrowth(cityName: let cityName, population: let population, location: let location):
            try container.encode(9, forKey: .rawValue)
            try container.encode(cityName, forKey: .cityNameValue)
            try container.encode(population, forKey: .cityPopulationValue)
            try container.encode(location, forKey: .locationValue)

        case .starving(cityName: let cityName, location: let location):
            try container.encode(10, forKey: .rawValue)
            try container.encode(cityName, forKey: .cityNameValue)
            try container.encode(location, forKey: .locationValue)

        case .diplomaticDeclaration:
            try container.encode(11, forKey: .rawValue)

        case .war(leader: let leader):
            try container.encode(12, forKey: .rawValue)
            try container.encode(leader, forKey: .leaderValue)

        case .enemyInTerritory:
            try container.encode(13, forKey: .rawValue)

        case .unitPromotion(location: let location):
            try container.encode(14, forKey: .rawValue)
            try container.encode(location, forKey: .locationValue)

        case .unitNeedsOrders(location: let location):
            try container.encode(15, forKey: .rawValue)
            try container.encode(location, forKey: .locationValue)

        case .unitDied(location: let location):
            try container.encode(16, forKey: .rawValue)
            try container.encode(location, forKey: .locationValue)

        case .greatPersonJoined:
            try container.encode(17, forKey: .rawValue)

        case .canRecruitGreatPerson(greatPerson: let greatPerson):
            try container.encode(18, forKey: .rawValue)
            try container.encode(greatPerson, forKey: .greatPersonValue)

        case .cityLost(location: let location):
            try container.encode(19, forKey: .rawValue)
            try container.encode(location, forKey: .locationValue)

        case .goodyHutDiscovered(location: let location):
            try container.encode(20, forKey: .rawValue)
            try container.encode(location, forKey: .locationValue)

        case .barbarianCampDiscovered(location: let location):
            try container.encode(21, forKey: .rawValue)
            try container.encode(location, forKey: .locationValue)

        case .waiting:
            try container.encode(22, forKey: .rawValue)

        case .metCityState(cityState: let cityState, first: let first):
            try container.encode(23, forKey: .rawValue)
            try container.encode(cityState, forKey: .cityStateValue)
            try container.encode(first, forKey: .boolValue)

        case .questCityStateFulfilled(cityState: let cityState, quest: let quest):
            try container.encode(24, forKey: .rawValue)
            try container.encode(cityState, forKey: .cityStateValue)
            try container.encode(quest, forKey: .questValue)

        case .questCityStateObsolete(cityState: let cityState, quest: let quest):
            try container.encode(25, forKey: .rawValue)
            try container.encode(cityState, forKey: .cityStateValue)
            try container.encode(quest, forKey: .questValue)

        case .questCityStateGiven(cityState: let cityState, quest: let quest):
            try container.encode(26, forKey: .rawValue)
            try container.encode(cityState, forKey: .cityStateValue)
            try container.encode(quest, forKey: .questValue)

        case .momentAdded(type: let moment):
            try container.encode(27, forKey: .rawValue)
            try container.encode(moment, forKey: .momentValue)

        case .tradeRouteCapacityIncreased:
            try container.encode(28, forKey: .rawValue)

        case .naturalWonderDiscovered(location: let location):
            try container.encode(29, forKey: .rawValue)
            try container.encode(location, forKey: .locationValue)

        case .continentDiscovered(location: let location, continentName: let continentName):
            try container.encode(30, forKey: .rawValue)
            try container.encode(location, forKey: .locationValue)
            try container.encode(continentName, forKey: .continentNameValue)

        case .wonderBuilt:
            try container.encode(31, forKey: .rawValue)

        case .cityCanShoot(cityName: let cityName, location: let location):
            try container.encode(32, forKey: .rawValue)
            try container.encode(cityName, forKey: .cityNameValue)
            try container.encode(location, forKey: .locationValue)

        case .cityAcquired(cityName: let cityName, location: let location):
            try container.encode(33, forKey: .rawValue)
            try container.encode(cityName, forKey: .cityNameValue)
            try container.encode(location, forKey: .locationValue)
        }
    }
}

extension NotificationType: Equatable {

    public static func == (lhs: NotificationType, rhs: NotificationType) -> Bool {

        switch (lhs, rhs) {

        case (.turn, .turn):
            return true
        case (.generic, .generic):
            return true
        case (.techNeeded, .techNeeded):
            return true
        case (.civicNeeded, .civicNeeded):
            return true
        case (.productionNeeded, .productionNeeded):
            return true
        case (.canChangeGovernment, .canChangeGovernment):
            return true
        case (.policiesNeeded, .policiesNeeded):
            return true
        case (.canFoundPantheon, .canFoundPantheon):
            return true
        case (.governorTitleAvailable, .governorTitleAvailable):
            return true
        case (.cityGrowth, .cityGrowth):
            return true
        case (.starving, .starving):
            return true
        case (.diplomaticDeclaration, .diplomaticDeclaration):
            return true
        case (.war, .war):
            return true
        case (.enemyInTerritory, .enemyInTerritory):
            return true
        case (.unitPromotion, .unitPromotion):
            return true
        case (.unitNeedsOrders, .unitNeedsOrders):
            return true

        case (let .unitDied(location: lhsLocation), let .unitDied(rhsLocation)):
            return lhsLocation == rhsLocation

        case (.greatPersonJoined, .greatPersonJoined):
            return true
        case (let .canRecruitGreatPerson(greatPerson: lhsGreatPerson),
                  let .canRecruitGreatPerson(greatPerson: rhsGreatPerson)):
            return lhsGreatPerson == rhsGreatPerson

        case (let .cityLost(location: lhsLocation), let .cityLost(rhsLocation)):
            return lhsLocation == rhsLocation

        case (let .goodyHutDiscovered(location: lhsLocation), let .goodyHutDiscovered(rhsLocation)):
            return lhsLocation == rhsLocation

        case (let .barbarianCampDiscovered(location: lhsLocation), let .barbarianCampDiscovered(rhsLocation)):
            return lhsLocation == rhsLocation

        case (.waiting, .waiting):
            return true

        case (.metCityState(cityState: let lhsCityState, first: let lhsFirst),
              .metCityState(cityState: let rhsCityState, first: let rhsFirst)):
            return lhsCityState == rhsCityState && lhsFirst == rhsFirst

        case (.questCityStateFulfilled(cityState: let lhsCityState, quest: let lhsQuest),
              .questCityStateFulfilled(cityState: let rhsCityState, quest: let rhsQuest)):
            return lhsCityState == rhsCityState && lhsQuest == rhsQuest

        case (.questCityStateObsolete(cityState: let lhsCityState, quest: let lhsQuest),
              .questCityStateObsolete(cityState: let rhsCityState, quest: let rhsQuest)):
            return lhsCityState == rhsCityState && lhsQuest == rhsQuest

        case (.questCityStateGiven(cityState: let lhsCityState, quest: let lhsQuest),
              .questCityStateGiven(cityState: let rhsCityState, quest: let rhsQuest)):
            return lhsCityState == rhsCityState && lhsQuest == rhsQuest

        case (.momentAdded(type: let lhsMoment), .momentAdded(type: let rhsMoment)):
            return lhsMoment == rhsMoment

        case (.tradeRouteCapacityIncreased, .tradeRouteCapacityIncreased):
            return true

        case (.naturalWonderDiscovered(location: let lhsLocation), .naturalWonderDiscovered(location: let rhsLocation)):
            return lhsLocation == rhsLocation

        case (.continentDiscovered(location: let lhsLocation, continentName: let lhsContinentName),
              .continentDiscovered(location: let rhsLocation, continentName: let rhsContinentName)):
            return lhsLocation == rhsLocation && lhsContinentName == rhsContinentName

        case (.wonderBuilt, .wonderBuilt):
            return true

        case (.cityCanShoot(cityName: let lhsCityName, location: let lhsLocation),
            .cityCanShoot(cityName: let rhsCityName, location: let rhsLocation)):

            return lhsCityName == rhsCityName && lhsLocation == rhsLocation

        case (.cityAcquired(cityName: let lhsCityName, location: let lhsLocation),
            .cityAcquired(cityName: let rhsCityName, location: let rhsLocation)):

            return lhsCityName == rhsCityName && lhsLocation == rhsLocation

        default:
            if lhs.value() == rhs.value() {
                fatalError("comparison not handled - please add a case")
            }

            return false
        }
    }
}

extension NotificationType: Hashable {

    public func hash(into hasher: inout Hasher) {

        switch self {

        case .turn:
            hasher.combine(0)

        case .generic:
            hasher.combine(1)

        case .techNeeded:
            hasher.combine(2)

        case .civicNeeded:
            hasher.combine(3)

        case .productionNeeded(cityName: let cityName, location: let location):
            hasher.combine(4)
            hasher.combine(cityName)
            hasher.combine(location)

        case .canChangeGovernment:
            hasher.combine(5)

        case .policiesNeeded:
            hasher.combine(6)

        case .canFoundPantheon:
            hasher.combine(7)

        case .governorTitleAvailable:
            hasher.combine(8)

        case .cityGrowth:
            hasher.combine(9)

        case .starving:
            hasher.combine(10)

        case .diplomaticDeclaration:
            hasher.combine(11)

        case .war:
            hasher.combine(12)

        case .enemyInTerritory:
            hasher.combine(13)

        case .unitPromotion:
            hasher.combine(14)

        case .unitNeedsOrders:
            hasher.combine(15)

        case .unitDied(location: let location):
            hasher.combine(16)
            hasher.combine(location)

        case .greatPersonJoined:
            hasher.combine(17)

        case .canRecruitGreatPerson(greatPerson: let greatPerson):
            hasher.combine(18)
            hasher.combine(greatPerson)

        case .cityLost(location: let location):
            hasher.combine(19)
            hasher.combine(location)

        case .goodyHutDiscovered(location: let location):
            hasher.combine(20)
            hasher.combine(location)

        case .barbarianCampDiscovered(location: let location):
            hasher.combine(21)
            hasher.combine(location)

        case .waiting:
            hasher.combine(22)

        case .metCityState(cityState: let cityState, first: let first):
            hasher.combine(23)
            hasher.combine(cityState)
            hasher.combine(first)

        case .questCityStateFulfilled(cityState: let cityState, quest: let quest):
            hasher.combine(24)
            hasher.combine(cityState)
            hasher.combine(quest)

        case .questCityStateObsolete(cityState: let cityState, quest: let quest):
            hasher.combine(25)
            hasher.combine(cityState)
            hasher.combine(quest)

        case .questCityStateGiven(cityState: let cityState, quest: let quest):
            hasher.combine(26)
            hasher.combine(cityState)
            hasher.combine(quest)

        case .momentAdded(type: let type):
            hasher.combine(27)
            hasher.combine(type)

        case .tradeRouteCapacityIncreased:
            hasher.combine(28)

        case .naturalWonderDiscovered(location: let location):
            hasher.combine(29)
            hasher.combine(location)

        case .continentDiscovered(location: let location, continentName: let continentName):
            hasher.combine(30)
            hasher.combine(location)
            hasher.combine(continentName)

        case .wonderBuilt:
            hasher.combine(31)

        case .cityCanShoot(cityName: let cityName, location: let location):
            hasher.combine(32)
            hasher.combine(cityName)
            hasher.combine(location)

        case .cityAcquired(cityName: let cityName, location: let location):
            hasher.combine(33)
            hasher.combine(cityName)
            hasher.combine(location)
        }
    }
}
