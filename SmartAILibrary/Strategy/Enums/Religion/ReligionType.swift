//
//  ReligionType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/List_of_religions_in_Civ6
public enum ReligionType: Codable, Equatable {

    enum CodingKeys: String, CodingKey {

        case value
    }

    case none

    case atheism

    case buddhism
    case catholicism
    case confucianism
    case hinduism
    case islam
    case judaism
    case easternOrthodoxy
    case protestantism
    case shinto
    case sikhism
    case taoism
    case zoroastrianism

    case custom(title: String)

    public static var all: [ReligionType] = [
        .buddhism, .catholicism, .confucianism, .hinduism, .islam, .judaism, .easternOrthodoxy, .protestantism, .shinto, .sikhism, .taoism, .zoroastrianism
    ]

    // MARK: constructors

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let value = try container.decode(String.self, forKey: .value)
        self = ReligionType.from(key: value) ?? .none
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.toKey(), forKey: .value)
    }

    private func toKey() -> String {

        switch self {

        case .none:
            return "none"

        case .atheism:
            return "atheism"

        case .buddhism:
            return "buddhism"
        case .catholicism:
            return "catholicism"
        case .confucianism:
            return "confucianism"
        case .hinduism:
            return "hinduism"
        case .islam:
            return "islam"
        case .judaism:
            return "judaism"
        case .easternOrthodoxy:
            return "easternOrthodoxy"
        case .protestantism:
            return "protestantism"
        case .shinto:
            return "shinto"
        case .sikhism:
            return "sikhism"
        case .taoism:
            return "taoism"
        case .zoroastrianism:
            return "zoroastrianism"
        case .custom(title: let title):
            return "custom(\(title))"
        }
    }

    private static func from(key: String) -> ReligionType? {

        if key == "atheism" {
            return .atheism
        } else if key == "buddhism" {
            return .buddhism
        } else if key == "catholicism" {
            return .catholicism
        } else {
            fatalError("religion not handled: \(key)")
            //return .custom(title: key)
        }

        return nil
    }
}
