//
//  InspirationTriggeredPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class InspirationTriggeredPopupViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var summaryText: String

    @Published
    var descriptionText: String

    private var civicType: CivicType = .none

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "TXT_KEY_INSPIRATION".localized()
        self.summaryText = "-"
        self.descriptionText = "-"
    }

    func update(for civicType: CivicType) {

        self.civicType = civicType

        self.summaryText = civicType.inspirationDescription().localized()
        self.descriptionText = "TXT_KEY_INSPIRATION_TRIGGERED".localizedWithFormat(with: [civicType.name().localized()])
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.civicType.iconTexture())
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
