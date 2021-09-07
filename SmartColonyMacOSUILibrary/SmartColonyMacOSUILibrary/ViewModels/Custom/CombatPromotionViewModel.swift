//
//  CombatPromotionViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.09.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class CombatPromotionViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    private let promotion: UnitPromotionType

    init(promotion: UnitPromotionType) {

        self.promotion = promotion
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.promotion.iconTexture())
    }
}

extension CombatPromotionViewModel: Hashable {

    static func == (lhs: CombatPromotionViewModel, rhs: CombatPromotionViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
