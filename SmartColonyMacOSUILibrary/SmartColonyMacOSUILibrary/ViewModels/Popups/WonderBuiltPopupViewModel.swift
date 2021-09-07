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

    private let iconTexture: String

    weak var delegate: GameViewModelDelegate?

    init(wonderType: WonderType) {

        self.iconTexture = wonderType.iconTexture()
        self.title = "Wonder built"
        self.nameText = "Your civilization has finished construction on \(wonderType)"
        self.bonusTexts = wonderType.bonuses()
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.iconTexture)
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
