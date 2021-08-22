//
//  Flavor.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class Flavor: Codable {

    enum CodingKeys: String, CodingKey {

        case type
        case value
    }

    let type: FlavorType
    var value: Int

    init(type: FlavorType, value: Int) {

        self.type = type
        self.value = value
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(FlavorType.self, forKey: .type)
        self.value = try container.decode(Int.self, forKey: .value)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encode(self.value, forKey: .value)
    }
}

extension Flavor: CustomDebugStringConvertible {

    var debugDescription: String {

        return "(Flavor: \(self.type), \(self.value))"
    }
}
