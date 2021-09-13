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

        self.update(for: attacker, and: defender, ranged: false)
    }

    func update(for attacker: AbstractUnit?, and defender: AbstractUnit?, ranged: Bool) {

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

        if ranged {
            let result = Combat.predictRangedAttack(between: attackerUnit, and: defenderUnit, in: gameModel)

            self.combatPredictionText = result.value.text
            self.combatPredictionColor = result.value.color

            let attackerStrength = attackerUnit.rangedCombatStrength(against: defenderUnit,
                or: nil,
                on: attackerTile,
                attacking: true,
                in: gameModel
            )

            var attackerCombatModifiers: [CombatModifier] = []

            let baseAttackerStrength = CombatModifier(
                value: attackerUnit.baseRangedCombatStrength(),
                title: "Ranged Strength"
            )
            attackerCombatModifiers.append(baseAttackerStrength)

            for attackerStrengthModifier in attackerUnit.attackStrengthModifier(
                against: defenderUnit,
                or: nil,
                on: attackerTile,
                in: gameModel
            ) {
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
                defenderCombatModifiers.append(defenderStrengthModifier)
            }

            self.attackerViewModel.update(
                name: attackerUnit.name(),
                type: attackerUnit.type,
                strength: attackerStrength,
                healthPoints: attackerUnit.healthPoints(),
                combatModifiers: attackerCombatModifiers,
                promotions: attackerUnit.gainedPromotions()
            )
            self.defenderViewModel.update(
                name: defenderUnit.name(),
                type: defenderUnit.type,
                strength: defenderStrength,
                healthPoints: defenderUnit.healthPoints(),
                combatModifiers: defenderCombatModifiers,
                promotions: defenderUnit.gainedPromotions()
            )

        } else {
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
                defenderCombatModifiers.append(defenderStrengthModifier)
            }

            self.attackerViewModel.update(
                name: attackerUnit.name(),
                type: attackerUnit.type,
                strength: attackerStrength,
                healthPoints: attackerUnit.healthPoints(),
                combatModifiers: attackerCombatModifiers,
                promotions: attackerUnit.gainedPromotions()
            )
            self.defenderViewModel.update(
                name: defenderUnit.name(),
                type: defenderUnit.type,
                strength: defenderStrength,
                healthPoints: defenderUnit.healthPoints(),
                combatModifiers: defenderCombatModifiers,
                promotions: defenderUnit.gainedPromotions()
            )
        }
    }

    func update(for attacker: AbstractCity?, and defender: AbstractUnit?, ranged: Bool) {

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        guard let attackerCity = attacker else {
            // fatalError("cant get source unit")
            return
        }

        guard let attackerTile = gameModel.tile(at: attackerCity.location) else {
            return
        }

        guard let defenderUnit = defender else {
            // fatalError("cant get target unit")
            return
        }

        guard let defenderTile = gameModel.tile(at: defenderUnit.location) else {
            return
        }

        let result = Combat.predictRangedAttack(between: attackerCity, and: defenderUnit, in: gameModel)

        self.combatPredictionText = result.value.text
        self.combatPredictionColor = result.value.color

        let attackerStrength = attackerCity.rangedCombatStrength(
            against: defenderUnit,
            on: attackerTile
        )

        var attackerCombatModifiers: [CombatModifier] = []

        let baseAttackerStrength = CombatModifier(
            value: attackerStrength,
            title: "Base Strength"
        )
        attackerCombatModifiers.append(baseAttackerStrength)

        /*for attackerStrengthModifier in attackerUnit.attackStrengthModifier(
            against: defenderUnit,
            or: nil,
            on: attackerTile,
            in: gameModel
        ) {
            attackerCombatModifiers.append(attackerStrengthModifier)
        }*/

        let defenderStrength = defenderUnit.defensiveStrength(
            against: nil,
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
            defenderCombatModifiers.append(defenderStrengthModifier)
        }

        self.attackerViewModel.update(
            name: attackerCity.name,
            type: UnitType.none,
            strength: attackerStrength,
            healthPoints: attackerCity.healthPoints(),
            combatModifiers: attackerCombatModifiers,
            promotions: []
        )
        self.defenderViewModel.update(
            name: defenderUnit.name(),
            type: defenderUnit.type,
            strength: defenderStrength,
            healthPoints: defenderUnit.healthPoints(),
            combatModifiers: defenderCombatModifiers,
            promotions: defenderUnit.gainedPromotions()
        )
    }

    func update(for attacker: AbstractUnit?, and defender: AbstractCity?, ranged: Bool) {

        fatalError("Not implemented: unit => city")
    }
}
