//
//  SelectPromotionDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 31.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class SelectPromotionDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var promotionViewModels: [PromotionViewModel] = []

    private var unit: AbstractUnit?

    weak var delegate: GameViewModelDelegate?

    init() {

    }

    func update(for unit: AbstractUnit?) {

        self.unit = unit

        self.updatePromotionList()
    }

    private func updatePromotionList() {

        guard let unit = self.unit else {
            fatalError("cant get unit")
        }

        var tmpPromotionViewModels: [PromotionViewModel] = []

        for promotionType in unit.gainedPromotions() {

            let promotionViewModel = PromotionViewModel(promotionType: promotionType, state: .gained)
            tmpPromotionViewModels.append(promotionViewModel)
        }

        for promotionType in unit.possiblePromotions() {

            let promotionViewModel = PromotionViewModel(promotionType: promotionType, state: .possible)
            promotionViewModel.delegate = self
            tmpPromotionViewModels.append(promotionViewModel)
        }

        self.promotionViewModels = tmpPromotionViewModels
    }
}

extension SelectPromotionDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}

extension SelectPromotionDialogViewModel: PromotionViewModelDelegate {

    func clicked(on promotion: UnitPromotionType) {

        self.unit?.doPromote(with: promotion)
        self.delegate?.closeDialog()
    }
}
