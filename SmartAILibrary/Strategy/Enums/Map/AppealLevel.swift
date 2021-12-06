//
//  AppealLevel.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.11.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum AppealLevel {

    case breathtaking
    case charming
    case average
    case uninviting
    case disgusting

    public static var all: [AppealLevel] = [

        .breathtaking,
        .charming,
        .average,
        .uninviting,
        .disgusting
    ]

    public static func from(appeal: Int) -> AppealLevel {

        if appeal >= 4 {
            return .breathtaking
        } else if appeal >= 2 {
            return .charming
        } else if appeal >= -1 {
            return .average
        } else if appeal >= -3 {
            return .uninviting
        } else {
            return .disgusting
        }
    }

    public func name() -> String {

        switch self {

        case .breathtaking: return "Breathtaking"
        case .charming: return "Charming"
        case .average: return "Average"
        case .uninviting: return "Uninviting"
        case .disgusting: return "Disgusting"
        }
    }

    public func housing() -> Int {

        switch self {

        case .breathtaking: return 6
        case .charming: return 5
        case .average: return 4
        case .uninviting: return 3
        case .disgusting: return 2
        }
    }
}
