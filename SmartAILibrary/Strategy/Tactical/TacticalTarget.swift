//
//  TacticalTarget.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvTacticalTarget
//!  \brief        A target of opportunity for the tactical AI this turn
//
//!  Key Attributes:
//!  - Arises during processing of CvTacticalAI::FindTacticalTargets()
//!  - Targets are reexamined each turn (so shouldn't need to be serialized)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class TacticalTarget: Codable {

    enum CodingKeys: String, CodingKey {

        case targetType
        case target
        case targetLeader
        case dominanceZone
    }

    var targetType: TacticalTargetType
    var target: HexPoint
    var targetLeader: LeaderType
    let dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?

    // aux data
    var unit: AbstractUnit?
    var damage: Int = 0
    var city: AbstractCity?
    var threatValue: Int = 0
    var tile: AbstractTile?

    init(targetType: TacticalTargetType, target: HexPoint, targetLeader: LeaderType = .none, dominanceZone: TacticalAnalysisMap.TacticalDominanceZone? = nil) {

        self.targetType = targetType
        self.target = target
        self.targetLeader = targetLeader
        self.dominanceZone = dominanceZone
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.targetType = try container.decode(TacticalTargetType.self, forKey: .targetType)
        self.target = try container.decode(HexPoint.self, forKey: .target)
        self.targetLeader = try container.decode(LeaderType.self, forKey: .targetLeader)
        self.dominanceZone = nil // try container.decodeIfPresent(TacticalAnalysisMap.TacticalDominanceZone.self, forKey: .dominanceZone)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.targetType, forKey: .targetType)
        try container.encode(self.target, forKey: .target)
        try container.encode(self.targetLeader, forKey: .targetLeader)
        //try container.encodeIfPresent(self.dominanceZone, forKey: .dominanceZone)
    }

    /// This target make sense for this domain of unit/zone?
    func isTargetValidIn(domain: UnitDomainType) -> Bool {

        switch self.targetType {

        case .none: return false

            // always valid
        case .city, .cityToDefend, .lowPriorityCivilian, .mediumPriorityCivilian, .highPriorityCivilian, .veryHighPriorityCivilian, .lowPriorityUnit, .mediumPriorityUnit, .highPriorityUnit:
            return true

            // land targets
        case .barbarianCamp, .improvement, .improvementToDefend, .defensiveBastion, .ancientRuins, .tradeUnitLand, .tradeUnitLandPlot, .citadel, .improvementResource:
            return domain == .land

            // sea targets
        case .blockadeResourcePoint, .bombardmentZone, .embarkedMilitaryUnit, .embarkedCivilian, .tradeUnitSea, .tradeUnitSeaPlot:
            return domain == .sea
        }
    }

    /// Still a living target?
    func isTargetStillAlive(for attackingPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if self.targetType == .lowPriorityUnit ||
            self.targetType == .mediumPriorityUnit ||
            self.targetType == .highPriorityUnit {

            if let enemyDefender = gameModel.visibleEnemy(at: self.target, for: attackingPlayer) {

                if !enemyDefender.isDelayedDeath() {
                    return true
                }
            }
        } else if self.targetType == .city {

            if let enemyCity = gameModel.visibleEnemyCity(at: self.target, for: attackingPlayer) {

                if self.targetLeader == enemyCity.player?.leader {
                    return true
                }
            }
        }

        return false
    }
}

extension TacticalTarget: Comparable {

    static func < (lhs: TacticalTarget, rhs: TacticalTarget) -> Bool {

        return lhs.damage < rhs.damage
    }

    static func == (lhs: TacticalTarget, rhs: TacticalTarget) -> Bool {

        return lhs.damage == rhs.damage
    }
}
