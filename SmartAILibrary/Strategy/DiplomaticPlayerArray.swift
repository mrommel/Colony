//
//  DiplomaticPlayerArray.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 08.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable nesting
class DiplomaticPlayerArray<ValueType: Codable>: Codable {

    enum CodingKeys: CodingKey {

        case items
    }

    private var items: [DiplomaticPlayerArrayItem<ValueType>]

    class DiplomaticPlayerArrayItem<ValueType: Codable>: Codable {

        enum CodingKeys: CodingKey {

            case leader
            case value
            case counter
        }

        let leader: LeaderType

        var value: ValueType
        let counter: Int

        init(between leader: LeaderType, value: ValueType) {

            self.leader = leader

            self.value = value
            self.counter = 0
        }

        public required init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.leader = try container.decode(LeaderType.self, forKey: .leader)
            self.value = try container.decode(ValueType.self, forKey: .value)
            self.counter = try container.decode(Int.self, forKey: .counter)
        }

        public func encode(to encoder: Encoder) throws {

            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.leader, forKey: .leader)
            try container.encode(self.value, forKey: .value)
            try container.encode(self.counter, forKey: .counter)
        }
    }

    init() {

        self.items = []
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.items = try container.decode([DiplomaticPlayerArrayItem<ValueType>].self, forKey: .items)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.items, forKey: .items)
    }

    func hasAgreement(against leader: LeaderType) -> Bool {

        return self.items.contains(where: { $0.leader == leader })
    }

    func agreement(against leader: LeaderType) -> DiplomaticPlayerArrayItem<ValueType>? {

        if let item = self.items.first(where: { $0.leader == leader }) {
            return item
        }

        return nil
    }

    func add(agreement: DiplomaticPlayerArrayItem<ValueType>) {

        self.items.append(agreement)
    }
}
