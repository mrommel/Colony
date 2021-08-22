//
//  Flavors.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class Flavors: Codable {

    enum CodingKeys: String, CodingKey {

        case items
    }

    private var items: [Flavor]

    init() {

        self.items = []

        for flavorType in FlavorType.all {

            self.items.append(Flavor(type: flavorType, value: 0))
        }
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.items = try container.decode([Flavor].self, forKey: .items)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.items, forKey: .items)
    }

    func reset() {

        for item in self.items {

            item.value = 0
        }
    }

    func value(of flavorType: FlavorType) -> Int {

        if let flavor = self.items.first(where: { $0.type == flavorType }) {

            return flavor.value
        }

        return 0
    }

    func add(value: Int, for flavorType: FlavorType) {

        if let item = self.items.first(where: { $0.type == flavorType }) {
            item.value += value
        }
    }
}

extension Flavors {

    static func +=(lhs: inout Flavors, rhs: Flavor) {

        if let item = lhs.items.first(where: { $0.type == rhs.type }) {
            item.value += rhs.value
        }
    }
}

extension Flavors: CustomDebugStringConvertible {

    var debugDescription: String {

        var str = ""

        for item in self.items {
            str += "\(item); "
        }

        return "Flavors: [\(str)]"
    }
}
