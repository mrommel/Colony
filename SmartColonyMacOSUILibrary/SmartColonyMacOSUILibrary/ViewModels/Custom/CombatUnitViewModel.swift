//
//  CombatUnitViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.09.21.
//

import SwiftUI
import SmartAILibrary

enum CombatUnitViewType {

    case attacker
    case defender
}

class CombatUnitViewModel: ObservableObject {

    @Published
    var name: String

    @Published
    var strength: Int

    @Published
    var modifierViewModels: [CombatModifierViewModel] = []

    @Published
    var promotionViewModels: [CombatPromotionViewModel] = []

    private let combatType: CombatUnitViewType
    private var type: UnitType
    private var healthPoints: Int // 0..100

    init(combatType: CombatUnitViewType) {

        self.combatType = combatType
        self.name = "Warrior"
        self.type = .barbarianWarrior
        self.strength = 25
        self.healthPoints = 85
        self.modifierViewModels = [
            CombatModifierViewModel(modifier: CombatModifier(value: 25, title: "Base Strength")),
            CombatModifierViewModel(modifier: CombatModifier(value: 3, title: "Bonus due to difficulty")),
            CombatModifierViewModel(modifier: CombatModifier(value: 2, title: "Bonus due to something"))
        ]
        self.promotionViewModels = [
            CombatPromotionViewModel(promotion: .alpine),
            CombatPromotionViewModel(promotion: .commando)
        ]
    }

    func update(
        name: String,
        type: UnitType,
        strength: Int,
        healthPoints: Int,
        combatModifiers: [CombatModifier],
        promotions: [UnitPromotionType]) {

        self.name = name
        self.type = type
        self.strength = strength
        self.healthPoints = healthPoints
        self.modifierViewModels = []
        self.modifierViewModels = combatModifiers.map { CombatModifierViewModel(modifier: $0) }
        self.promotionViewModels = promotions.map { CombatPromotionViewModel(promotion: $0) }
    }

    func typeIcon() -> NSImage {

        return self.type.iconTexture()
    }

    func healthIcon() -> NSImage {

        let imageIndex = min(25, max(0, self.healthPoints / 4 )) // the assets are from 0 to 25
        var textureName: String = ""

        switch self.combatType {

        case .attacker:
            textureName = "attacker_health\(imageIndex)"
        case .defender:
            textureName = "defender_health\(imageIndex)"
        }

        return ImageCache.shared.image(for: textureName)
    }
}
