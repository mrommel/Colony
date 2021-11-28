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

    case cityConquered(location: HexPoint) // 19
    case goodyHutDiscovered(location: HexPoint) // 20
    case barbarianCampDiscovered(location: HexPoint) // 21

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
        .cityConquered(location: HexPoint.invalid),
        .goodyHutDiscovered(location: HexPoint.invalid),
        .barbarianCampDiscovered(location: HexPoint.invalid)
    ]

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
            return "unitPromotion"
        case .unitNeedsOrders(location: _):
            return "unitNeedsOrders"
        case .unitDied(location: _):
            return "Unit died"
        case .greatPersonJoined:
            return "greatPersonJoined"
        case .canRecruitGreatPerson(greatPerson: _):
            return "Great Person can be recruited"
        case .cityConquered(location: _):
            return "City conquered at xy"
        case .goodyHutDiscovered(location: _):
            return "Goodyhut discovered at xy"
        case .barbarianCampDiscovered(location: _):
            return "Barbarian Camp discovered at xy"
        }
    }

    func message() -> String {

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
            return "unitPromotion"
        case .unitNeedsOrders(location: _):
            return "unitNeedsOrders"
        case .unitDied(location: _):
            return "A unit died"
        case .greatPersonJoined:
            return "greatPersonJoined"
        case .canRecruitGreatPerson(greatPerson: let greatPerson):
            return "You can recruit \(greatPerson.name())"
        case .cityConquered(location: _):
            return "City qonquered"
        case .goodyHutDiscovered(location: _):
            return "Goodyhut discovered"
        case .barbarianCampDiscovered(location: _):
            return "Barbarian Camp discovered"
        }
    }

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
        case .cityConquered(location: _):
            return 19
        case .goodyHutDiscovered(location: _):
            return 20
        case .barbarianCampDiscovered(location: _):
            return 21
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
        case greatPersonValue // GreatPerson
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
            self = .cityConquered(location: location)
        case 20:
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .goodyHutDiscovered(location: location)
        case 21:
            let location = try container.decode(HexPoint.self, forKey: .locationValue)
            self = .barbarianCampDiscovered(location: location)
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

        case .cityConquered(location: let location):
            try container.encode(19, forKey: .rawValue)
            try container.encode(location, forKey: .locationValue)

        case .goodyHutDiscovered(location: let location):
            try container.encode(20, forKey: .rawValue)
            try container.encode(location, forKey: .locationValue)

        case .barbarianCampDiscovered(location: let location):
            try container.encode(21, forKey: .rawValue)
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
        case (let .canRecruitGreatPerson(greatPerson: lhsGreatPerson), let .canRecruitGreatPerson(greatPerson: rhsGreatPerson)):
            return lhsGreatPerson == rhsGreatPerson

        case (let .cityConquered(location: lhsLocation), let .cityConquered(rhsLocation)):
            return lhsLocation == rhsLocation

        case (let .goodyHutDiscovered(location: lhsLocation), let .goodyHutDiscovered(rhsLocation)):
            return lhsLocation == rhsLocation

        case (let .barbarianCampDiscovered(location: lhsLocation), let .barbarianCampDiscovered(rhsLocation)):
            return lhsLocation == rhsLocation

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
        case .productionNeeded:
            hasher.combine(4)
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
        case .cityConquered(location: let location):
            hasher.combine(19)
            hasher.combine(location)
        case .goodyHutDiscovered(location: let location):
            hasher.combine(20)
            hasher.combine(location)
        case .barbarianCampDiscovered(location: let location):
            hasher.combine(21)
            hasher.combine(location)
        }
    }
}
