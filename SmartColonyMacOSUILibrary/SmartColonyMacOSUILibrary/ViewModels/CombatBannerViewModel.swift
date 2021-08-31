//
//  CombatBannerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 30.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class CombatModifierViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    @Published
    var text: String

    init(text: String) {

        self.text = text
    }
}

extension CombatModifierViewModel: Hashable {

    static func == (lhs: CombatModifierViewModel, rhs: CombatModifierViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.text)
        hasher.combine(self.id)
    }
}

class CombatUnitViewModel: ObservableObject {

    @Published
    var name: String

    @Published
    var strength: Int

    @Published
    var modifierViewModels: [CombatModifierViewModel] = []

    var type: UnitType

    init() {

        self.name = "Warrior"
        self.type = .barbarianWarrior
        self.strength = 1
        self.modifierViewModels = [
            CombatModifierViewModel(text: "10 Base Strength"),
            CombatModifierViewModel(text: "+3 bonus due to difficulty"),
            CombatModifierViewModel(text: "+3 bonus due to difficulty")
        ]
    }

    func update(name: String, type: UnitType, strength: Int, modifierViewModels: [CombatModifierViewModel]) {

        self.name = name
        self.type = type
        self.strength = strength
        self.modifierViewModels = modifierViewModels
    }

    func typeIcon() -> NSImage {

        //return ImageCache.shared.image(for: self.type.typeTexture())
        return self.type.iconTexture()
    }
}

class CombatBannerViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var attackerViewModel: CombatUnitViewModel

    @Published
    var defenderViewModel: CombatUnitViewModel

    @Published
    var showBanner: Bool = false

    weak var delegate: GameViewModelDelegate?

    init(attacker: AbstractUnit? = nil, defender: AbstractUnit? = nil) {

        self.attackerViewModel = CombatUnitViewModel()
        self.defenderViewModel = CombatUnitViewModel()

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

        guard let defenderUnit = defender else {
            // fatalError("cant get target unit")
            return
        }

        let attackerStrength = attackerUnit.attackStrength(
            against: defenderUnit,
            or: nil,
            on: nil,
            in: gameModel
        )

        var attackerModifierViewModels: [CombatModifierViewModel] = []
        for attackerStrengthModifier in attackerUnit.attackStrengthModifier(
            against: defenderUnit,
            or: nil,
            on: nil,
            in: gameModel
        ) {
            //print("\(attackerStrengthModifier.modifierTitle) => \(attackerStrengthModifier.modifierValue)")
            attackerModifierViewModels.append(CombatModifierViewModel(text: attackerStrengthModifier.modifierTitle))
        }

        let defenderStrength = defenderUnit.defensiveStrength(
            against: attackerUnit,
            on: nil,
            ranged: false,
            in: gameModel
        )

        var defenderModifierViewModels: [CombatModifierViewModel] = []
        for defenderStrengthModifier in defenderUnit.defensiveStrengthModifier(
            against: defenderUnit,
            on: nil,
            ranged: false,
            in: gameModel
        ) {
            // print("\(defenderStrengthModifier.modifierTitle) => \(defenderStrengthModifier.modifierValue)")
            defenderModifierViewModels.append(CombatModifierViewModel(text: defenderStrengthModifier.modifierTitle))
        }

        self.attackerViewModel.update(
            name: attackerUnit.name(),
            type: attackerUnit.type,
            strength: attackerStrength,
            modifierViewModels: attackerModifierViewModels
        )
        self.defenderViewModel.update(
            name: defenderUnit.name(),
            type: defenderUnit.type,
            strength: defenderStrength,
            modifierViewModels: defenderModifierViewModels
        )
    }
}
