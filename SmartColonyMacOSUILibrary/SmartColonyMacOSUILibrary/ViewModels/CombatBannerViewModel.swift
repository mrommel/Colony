//
//  CombatBannerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 30.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class CombatUnitViewModel: ObservableObject {

    @Published
    var name: String

    @Published
    var strength: Int

    var type: UnitType

    init() {

        self.name = "-"
        self.type = .barbarianWarrior
        self.strength = 1
    }

    func update(name: String, type: UnitType, strength: Int) {

        self.name = name
        self.type = type
        self.strength = strength
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

    //private var sourceUnit: AbstractUnit?
    //private var targetUnit: AbstractUnit?

    weak var delegate: GameViewModelDelegate?

    init(source: AbstractUnit? = nil, target: AbstractUnit? = nil) {

        self.attackerViewModel = CombatUnitViewModel()
        self.defenderViewModel = CombatUnitViewModel()

        self.update(for: source, and: target)
    }

    func update(for attacker: AbstractUnit?, and defender: AbstractUnit?) {

        self.showBanner = true // remove me

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

        let attackerStrength = attackerUnit.attackStrength(against: defenderUnit, or: nil, on: nil, in: gameModel)

        for attackerStrengthModifier in attackerUnit.attackStrengthModifier(against: defenderUnit, or: nil, on: nil, in: gameModel) {

        }

        let defenderStrength = defenderUnit.defensiveStrength(against: attackerUnit, on: nil, ranged: false, in: gameModel)

        for defenderStrengthModifier in defenderUnit.defensiveStrengthModifier(against: defenderUnit, on: nil, ranged: false, in: gameModel) {

        }

        self.attackerViewModel.update(name: attackerUnit.name(), type: attackerUnit.type, strength: attackerStrength)
        self.defenderViewModel.update(name: defenderUnit.name(), type: defenderUnit.type, strength: defenderStrength)
    }
}
