//
//  Governor.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public class Governor: Codable {

    enum CodingKeys: CodingKey {

        case type
        case location
        case titles
    }

    public let type: GovernorType

    var location: HexPoint = HexPoint.invalid // <= city
    var titles: [GovernorTitleType] = []

    // MARK: constructors

    public init(type: GovernorType) {

        self.type = type
        self.titles.append(self.type.defaultTitle())
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(GovernorType.self, forKey: .type)
        self.location = try container.decode(HexPoint.self, forKey: .location)
        self.titles = try container.decode([GovernorTitleType].self, forKey: .titles)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.titles, forKey: .titles)
    }

    public func promote(with title: GovernorTitleType) {

        guard !self.titles.contains(title) else {
            fatalError("cant promote governor with title he/she already has")
        }

        self.titles.append(title)
    }

    public func has(title: GovernorTitleType) -> Bool {

        return self.titles.contains(title)
    }

    public func assign(to cityRef: AbstractCity?) {

        guard let city = cityRef else {
            fatalError("cant get city")
        }

        self.location = city.location
    }

    public func unassign() {

        self.location = HexPoint.invalid
    }

    public func isAssigned() -> Bool {

        return self.location != HexPoint.invalid
    }

    public func possiblePromotions() -> [GovernorTitleType] {

        var promotions: [GovernorTitleType] = []

        for title in self.type.titles() {

            if !self.has(title: title) {

                var hasRequired = true
                for required in title.requiredOr() {
                    if !self.has(title: required) {
                        hasRequired = false
                    }
                }

                if hasRequired {
                    promotions.append(title)
                }
            }
        }

        return promotions
    }
}
