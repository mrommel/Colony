//
//  EraType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum EraType: Int, Codable {

    case none = -1

    case ancient = 0
    case classical = 1
    case medieval = 2
    case renaissance = 3
    case industrial = 4
    case modern = 5
    case atomic = 6
    case information = 7
    case future = 8

    public static var all: [EraType] {

        return [.ancient, .classical, .medieval, .renaissance, .industrial, .modern, .atomic, .information, .future]
    }

    public func title() -> String {

        return self.data().name
    }

    func next() -> EraType {

        return self.data().next
    }

    public func dedications() -> [DedicationType] {

        return DedicationType.all
            .filter { $0.eras().contains(self) }
    }

    func warWearinessValue(formal: Bool) -> Int {

        return formal ? self.data().formalWarWeariness : self.data().surpriseWarWeariness
    }

    // MARK: private methods

    private class EraTypeData {

        let name: String
        let next: EraType

        let formalWarWeariness: Int
        let surpriseWarWeariness: Int

        init(name: String, next: EraType, formalWarWeariness: Int, surpriseWarWeariness: Int) {

            self.name = name
            self.next = next

            self.formalWarWeariness = formalWarWeariness
            self.surpriseWarWeariness = surpriseWarWeariness
        }
    }

    private func data() -> EraTypeData {

        switch self {

        case .none:
            return EraTypeData(
                name: "",
                next: .none,
                formalWarWeariness: 0,
                surpriseWarWeariness: 0
            )

        case .ancient:
            return EraTypeData(
                name: "TXT_KEY_ERA_ANCIENT",
                next: .classical,
                formalWarWeariness: 16,
                surpriseWarWeariness: 16
            )

        case .classical:
            return EraTypeData(
                name: "TXT_KEY_ERA_CLASSICAL",
                next: .medieval,
                formalWarWeariness: 22,
                surpriseWarWeariness: 25
            )

        case .medieval:
            return EraTypeData(
                name: "TXT_KEY_ERA_MEDIEVAL",
                next: .renaissance,
                formalWarWeariness: 28,
                surpriseWarWeariness: 34
            )

        case .renaissance:
            return EraTypeData(
                name: "TXT_KEY_ERA_RENAISSANCE",
                next: .industrial,
                formalWarWeariness: 34,
                surpriseWarWeariness: 43
            )

        case .industrial:
            return EraTypeData(
                name: "TXT_KEY_ERA_INDUSTRIAL",
                next: .modern,
                formalWarWeariness: 40,
                surpriseWarWeariness: 52
            )

        case .modern:
            return EraTypeData(
                name: "TXT_KEY_ERA_MODERN",
                next: .atomic,
                formalWarWeariness: 40,
                surpriseWarWeariness: 52
            )

        case .atomic:
            return EraTypeData(
                name: "TXT_KEY_ERA_ATOMIC",
                next: .information,
                formalWarWeariness: 40,
                surpriseWarWeariness: 52
            )

        case .information:
            return EraTypeData(
                name: "TXT_KEY_ERA_INFORMATION",
                next: .future,
                formalWarWeariness: 40,
                surpriseWarWeariness: 52
            )

        case .future:
            return EraTypeData(
                name: "TXT_KEY_ERA_FUTURE",
                next: .none,
                formalWarWeariness: 40,
                surpriseWarWeariness: 52
            )
        }
    }
}

extension EraType: Comparable {

    public static func == (lhs: EraType, rhs: EraType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    public static func < (lhs: EraType, rhs: EraType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
