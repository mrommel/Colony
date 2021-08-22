//
//  OperationStateType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum OperationStateType: Codable, Equatable {

    enum Discriminator: String, Codable, CodingKey {

        case none

        case aborted
        case recruitingUnits
        case gatheringForces
        case movingToTarget
        case atTarget
        case successful
    }

    enum CodingKeys: String, CodingKey {
        case discriminator
        case abortValue
    }

    case none

    case aborted(reason: OperationAbortReasonType)
    case recruitingUnits
    case gatheringForces
    case movingToTarget
    case atTarget
    case successful

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let discriminator = try container.decode(Discriminator.self, forKey: CodingKeys.discriminator)

        switch discriminator {
        case .none:
            self = .none
        case .aborted:
            let reason = try container.decode(OperationAbortReasonType.self, forKey: .abortValue)
            self = .aborted(reason: reason)
        case .recruitingUnits:
            self = .recruitingUnits
        case .gatheringForces:
            self = .gatheringForces
        case .movingToTarget:
            self = .movingToTarget
        case .atTarget:
            self = .atTarget
        case .successful:
            self = .successful
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .none:
            try container.encode(Discriminator.none, forKey: .discriminator)
        case .aborted(let reason):
            try container.encode(Discriminator.aborted, forKey: .discriminator)
            try container.encode(reason, forKey: .abortValue)
        case .recruitingUnits:
            try container.encode(Discriminator.recruitingUnits, forKey: .discriminator)
        case .gatheringForces:
            try container.encode(Discriminator.gatheringForces, forKey: .discriminator)
        case .movingToTarget:
            try container.encode(Discriminator.movingToTarget, forKey: .discriminator)
        case .atTarget:
            try container.encode(Discriminator.atTarget, forKey: .discriminator)
        case .successful:
            try container.encode(Discriminator.successful, forKey: .discriminator)
        }
    }
}
