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

    weak var delegate: GameViewModelDelegate?

    init() {

    }

    func update(for unit: AbstractUnit?) {

        self.updatePromotionList(for: unit)
    }

    private func updatePromotionList(for unit: AbstractUnit?) {
        
    }
}
