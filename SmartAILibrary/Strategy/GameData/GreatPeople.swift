//
//  GreatPeople.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 31.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractGreatPeople: AnyObject, Codable {

    var player: AbstractPlayer? { get set }

    func add(points: GreatPersonPoints)
    func resetPoint(for greatPersonType: GreatPersonType)
    func value(for greatPersonType: GreatPersonType) -> Int

    func retire(greatPerson: GreatPerson)
    func hasRetired(greatPerson: GreatPerson) -> Bool
}

class GreatPeople: AbstractGreatPeople {

    enum CodingKeys: CodingKey {

        case points
        case retired
    }

    // user properties / values
    internal var player: AbstractPlayer?
    private var points: GreatPersonPoints
    private var retiredGreatPersons: [GreatPerson]

    // MARK: constructor

    init(player: Player?) {

        self.player = player
        self.points = GreatPersonPoints()
        self.retiredGreatPersons = []
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.points = try container.decode(GreatPersonPoints.self, forKey: .points)
        self.retiredGreatPersons = try container.decode([GreatPerson].self, forKey: .retired)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.points, forKey: .points)
        try container.encode(self.retiredGreatPersons, forKey: .retired)
    }

    func add(points value: GreatPersonPoints) {

        self.points.add(other: value)
    }

    func resetPoint(for greatPersonType: GreatPersonType) {

        self.points.add(value: -self.value(for: greatPersonType), for: greatPersonType)
    }

    func value(for greatPersonType: GreatPersonType) -> Int {

        return self.points.value(for: greatPersonType)
    }

    func retire(greatPerson: GreatPerson) {

        self.retiredGreatPersons.append(greatPerson)
    }

    func hasRetired(greatPerson: GreatPerson) -> Bool {

        return self.retiredGreatPersons.contains(where: { $0 == greatPerson })
    }
}
