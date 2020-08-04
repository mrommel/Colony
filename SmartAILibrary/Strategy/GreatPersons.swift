//
//  GreatPersons.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 04.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// https://forums.civfanatics.com/resources/the-mechanism-of-great-people.26276/
public class GreatPersons: Codable {

    enum CodingKeys: CodingKey {

        case spawned
        case current
    }

    var spawned: [GreatPerson]
    var current: [GreatPerson]

    init() {

        self.spawned = []
        self.current = []

        self.fillCurrent(in: .ancient)
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.spawned = try container.decode([GreatPerson].self, forKey: .spawned)
        self.current = try container.decode([GreatPerson].self, forKey: .current)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.spawned, forKey: .spawned)
        try container.encode(self.current, forKey: .current)
    }

    func fillCurrent(in era: EraType) {

        for greatPersonType in GreatPersonType.all {

            // check for empty slots
            if self.current.first(where: { $0.type() == greatPersonType }) == nil {

                var possibleGreatPersons = GreatPerson.all.filter({ $0.era() == era && $0.type() == greatPersonType && !self.spawned.contains($0) })

                // consider next era
                if possibleGreatPersons.count == 0 {
                    possibleGreatPersons = GreatPerson.all.filter({ $0.era() == era.next() && $0.type() == greatPersonType && !self.spawned.contains($0) })
                }

                if possibleGreatPersons.count != 0 {

                    self.current.append(possibleGreatPersons.randomItem())
                }
            }
        }
    }

    func person(of greatPersonType: GreatPersonType) -> GreatPerson? {

        return self.current.first(where: { $0.type() == greatPersonType })
    }

    func invalidate(greatPerson: GreatPerson, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        self.current.removeAll(where: { $0 == greatPerson })
        self.spawned.append(greatPerson)

        self.fillCurrent(in: gameModel.worldEra())
    }
}
