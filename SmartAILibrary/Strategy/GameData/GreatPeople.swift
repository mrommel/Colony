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
}

class GreatPeople: AbstractGreatPeople {

    enum CodingKeys: CodingKey {

        case points
    }

    // user properties / values
    var player: AbstractPlayer?
    var points: GreatPersonPoints

    // MARK: constructor

    init(player: Player?) {

        self.player = player
        self.points = GreatPersonPoints()
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.points = try container.decode(GreatPersonPoints.self, forKey: .points)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.points, forKey: .points)
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
}
