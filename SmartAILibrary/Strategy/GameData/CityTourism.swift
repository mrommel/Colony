//
//  CityTourism.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.11.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public class CityTourism: Codable {

    enum CodingKeys: CodingKey {

        // case lifetimeCulture
    }

    internal var city: AbstractCity?

    // MARK: constructor

    init(city: AbstractCity?) {

        self.city = city
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        // self.lifetimeCultureValue = try container.decode(Double.self, forKey: .lifetimeCulture)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        // try container.encode(self.lifetimeCultureValue, forKey: .lifetimeCulture)
    }

    func baseTourism(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let player = self.city?.player else {
            fatalError("cant get city player")
        }

        guard let cityWonders = city.wonders else {
            fatalError("cant get city wonders")
        }

        guard let playerCivics = player.civics else {
            fatalError("cant get player civics")
        }

        var rtnValue: Double = 0.0

        // All Wonders in the game generate +2 Tourism in the era they belong to and an additional +1 Tourism for each era that has passed. (France's wonders have double these values.)
        var tourismFromWonders: Double = 0.0
        for wonderType in WonderType.all {

            if cityWonders.has(wonder: wonderType) {
                tourismFromWonders += 2.0

                let eraDelta = player.currentEra().value() - wonderType.era().value()
                tourismFromWonders += Double(eraDelta) * 1.0
            }
        }
        rtnValue += tourismFromWonders

        // Holy Cities generate +8 Tourism per turn of the Religious variety.
        if city.has(district: .holySite) {
            rtnValue += 8.0
        }

        // walls + Conservation civic
        if playerCivics.has(civic: .conservation) {

            if city.has(building: .ancientWalls) {

                // Ancient Walls generate +1 Tourism after discovering the Conservation civic.
                rtnValue += 1.0
            } else if city.has(building: .medievalWalls) {

                // Ancient Walls generate +1 Tourism after discovering the Conservation civic.
                rtnValue += 2.0
            } else if city.has(building: .renaissanceWalls) {

                // Renaissance Walls generate +3 Tourism after discovering the Conservation civic.
                rtnValue += 3.0
            }
        }

        return rtnValue
    }
}
