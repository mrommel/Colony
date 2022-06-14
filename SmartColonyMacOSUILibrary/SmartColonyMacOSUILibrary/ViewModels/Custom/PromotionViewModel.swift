//
//  PromotionViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 31.08.21.
//

import SmartAssets
import SwiftUI
import SmartAILibrary

protocol PromotionViewModelDelegate: AnyObject {

    func clicked(on promotion: UnitPromotionType)
}

class PromotionViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    @Published
    var name: String

    @Published
    var effect: String

    private let typeTexture: String
    private let state: PromotionState
    private let promotionType: UnitPromotionType

    weak var delegate: PromotionViewModelDelegate?

    init(promotionType: UnitPromotionType, state: PromotionState) {

        self.promotionType = promotionType

        self.name = promotionType.name().localized()
        self.effect = promotionType.effect().localized()
        self.typeTexture = promotionType.iconTexture()
        self.state = state
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.typeTexture)
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: self.state.iconTexture())
    }

    func selectPromotion() {

        self.delegate?.clicked(on: self.promotionType)
    }
}

extension PromotionViewModel: Hashable {

    static func == (lhs: PromotionViewModel, rhs: PromotionViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
