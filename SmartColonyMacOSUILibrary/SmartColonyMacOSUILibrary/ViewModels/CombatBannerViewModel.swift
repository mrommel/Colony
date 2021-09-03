//
//  CombatBannerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 30.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class CombatBannerViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var attackerViewModel: CombatUnitViewModel

    @Published
    var defenderViewModel: CombatUnitViewModel

    @Published
    var combatPredictionText: String

    @Published
    var combatPredictionColor: TypeColor

    @Published
    var showBanner: Bool = false

    weak var delegate: GameViewModelDelegate?

    init(attacker: AbstractUnit? = nil, defender: AbstractUnit? = nil) {

        self.attackerViewModel = CombatUnitViewModel(combatType: .attacker)
        self.defenderViewModel = CombatUnitViewModel(combatType: .defender)
        self.combatPredictionText = "Unknown"
        self.combatPredictionColor = TypeColor.silverFoil

        if attacker != nil && defender != nil {
            // debug
            self.showBanner = true
        }

        self.update(for: attacker, and: defender)
    }

    func update(for attacker: AbstractUnit?, and defender: AbstractUnit?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        guard let attackerUnit = attacker else {
            // fatalError("cant get source unit")
            return
        }

        guard let attackerTile = gameModel.tile(at: attackerUnit.location) else {
            return
        }

        guard let defenderUnit = defender else {
            // fatalError("cant get target unit")
            return
        }

        guard let defenderTile = gameModel.tile(at: defenderUnit.location) else {
            return
        }

        let result = Combat.predictMeleeAttack(between: attackerUnit, and: defenderUnit, in: gameModel)

        self.combatPredictionText = result.value.text
        self.combatPredictionColor = result.value.color

        let attackerStrength = attackerUnit.attackStrength(
            against: defenderUnit,
            or: nil,
            on: attackerTile,
            in: gameModel
        )

        var attackerCombatModifiers: [CombatModifier] = []

        let baseAttackerStrength = CombatModifier(
            value: attackerUnit.baseCombatStrength(ignoreEmbarked: true),
            title: "Base Strength"
        )
        attackerCombatModifiers.append(baseAttackerStrength)

        for attackerStrengthModifier in attackerUnit.attackStrengthModifier(
            against: defenderUnit,
            or: nil,
            on: attackerTile,
            in: gameModel
        ) {
            print("att: \(attackerStrengthModifier.title) => \(attackerStrengthModifier.value)")
            attackerCombatModifiers.append(attackerStrengthModifier)
        }

        let defenderStrength = defenderUnit.defensiveStrength(
            against: attackerUnit,
            on: defenderTile,
            ranged: false,
            in: gameModel
        )

        var defenderCombatModifiers: [CombatModifier] = []

        let baseDefenderStrength = CombatModifier(
            value: defenderUnit.baseCombatStrength(ignoreEmbarked: true),
            title: "Base Strength"
        )
        defenderCombatModifiers.append(baseDefenderStrength)

        for defenderStrengthModifier in defenderUnit.defensiveStrengthModifier(
            against: defenderUnit,
            on: defenderTile,
            ranged: false,
            in: gameModel
        ) {
            print("def: \(defenderStrengthModifier.title) => \(defenderStrengthModifier.value)")
            defenderCombatModifiers.append(defenderStrengthModifier)
        }

        self.attackerViewModel.update(
            name: attackerUnit.name(),
            type: attackerUnit.type,
            strength: attackerStrength,
            healthPoints: attackerUnit.healthPoints(),
            combatModifiers: attackerCombatModifiers
        )
        self.defenderViewModel.update(
            name: defenderUnit.name(),
            type: defenderUnit.type,
            strength: defenderStrength,
            healthPoints: defenderUnit.healthPoints(),
            combatModifiers: defenderCombatModifiers
        )
    }
}
