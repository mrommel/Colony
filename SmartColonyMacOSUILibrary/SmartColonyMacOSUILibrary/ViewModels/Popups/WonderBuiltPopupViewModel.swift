//
//  WonderBuiltPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class WonderBuiltPopupViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var nameText: String

    @Published
    var bonusTexts: [String]

    private var iconTexture: String

    weak var delegate: GameViewModelDelegate?

    init() {

        self.iconTexture = WonderType.alhambra.iconTexture()
        self.title = "Wonder built"
        self.nameText = "-"
        self.bonusTexts = []
    }

    func update(for wonderType: WonderType) {

        self.iconTexture = wonderType.iconTexture()

        self.nameText = "Your civilization has finished construction on \(wonderType)"
        self.bonusTexts = wonderType.effects()
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.iconTexture)
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
