//
//  ReligionType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/List_of_religions_in_Civ6
public enum ReligionType: Codable, Hashable {

    enum CodingKeys: String, CodingKey {

        case value
    }

    case none

    // case pantheon

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

        .buddhism,
        .catholicism,
        .confucianism,
        .hinduism,
        .islam,
        .judaism,
        .easternOrthodoxy,
        .protestantism,
        .shinto,
        .sikhism,
        .taoism,
        .zoroastrianism
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

    public func name() -> String {

        switch self {

        case .none: return ""

        case .atheism: return "Atheism"

        case .buddhism: return "Buddhism"
        case .catholicism: return "Catholicism"
        case .confucianism: return "Confucianism"
        case .hinduism: return "Hinduism"
        case .islam: return "Islam"
        case .judaism: return "Judaism"
        case .easternOrthodoxy: return "Eastern Orthodoxy"
        case .protestantism: return "Protestantism"
        case .shinto: return "Shinto"
        case .sikhism: return "Sikhism"
        case .taoism: return "Taoism"
        case .zoroastrianism: return "Zoroastrianism"

        case .custom(title: let title):
            return title
        }
    }

    // MARK: private methods

    private func toKey() -> String {

        switch self {

        case .none:
            return "none"

        // case .pantheon:
        //     return "pantheon"

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

        if key == "none" {
            return ReligionType.none
        } else if key == "atheism" {
            return .atheism
        } else if key == "buddhism" {
            return .buddhism
        } else if key == "catholicism" {
            return .catholicism
        } else if key == "confucianism" {
            return .confucianism
        } else if key == "hinduism" {
            return .hinduism
        } else if key == "islam" {
            return .islam
        } else if key == "judaism" {
            return .judaism
        } else if key == "easternOrthodoxy" {
            return .easternOrthodoxy
        } else if key == "protestantism" {
            return .protestantism
        } else if key == "shinto" {
            return .shinto
        } else if key == "sikhism" {
            return .sikhism
        } else if key == "taoism" {
            return .taoism
        } else if key == "zoroastrianism" {
            return .zoroastrianism
        } else if key.starts(with: "custom(") {
            var title = key
            title = title.replacingOccurrences(of: "custom(", with: "")
            title = String(title.dropLast())
            return .custom(title: title)
        } else {
            fatalError("religion not handled: \(key)")
            // return .custom(title: key)
        }
    }
}
