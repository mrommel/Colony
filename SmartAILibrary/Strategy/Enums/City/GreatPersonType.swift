//
//  GreatPersonType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 31.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum GreatPersonType: Int, Codable {

    case greatGeneral
    case greatAdmiral
    case greatEngineer
    case greatMerchant
    case greatProphet
    case greatScientist
    case greatWriter
    case greatArtist
    case greatMusician

    public static var all: [GreatPersonType] {
        return [
            .greatGeneral,
            .greatAdmiral,
            .greatEngineer,
            .greatMerchant,
            .greatProphet,
            .greatScientist,
            .greatWriter,
            .greatArtist,
            .greatMusician
        ]
    }

    public func name() -> String {

        switch self {

        case .greatGeneral:
            return "Great General"
        case .greatAdmiral:
            return "Great Admiral"
        case .greatEngineer:
            return "Great Engineer"
        case .greatMerchant:
            return "Great Merchant"
        case .greatProphet:
            return "Great Prophet"
        case .greatScientist:
            return "Great Scientist"
        case .greatWriter:
            return "Great Writer"
        case .greatArtist:
            return "Great Artist"
        case .greatMusician:
            return "Great Musician"
        }
    }

    func unitType() -> UnitType {

        switch self {

        case .greatGeneral:
            return .general
        case .greatAdmiral:
            return .admiral
        case .greatEngineer:
            return .engineer
        case .greatMerchant:
            return .merchant
        case .greatProphet:
            return .prophet
        case .greatScientist:
            return .scientist
        case .greatWriter:
            return .writer
        case .greatArtist:
            return .artist
        case .greatMusician:
            return .musician
        }
    }
}
