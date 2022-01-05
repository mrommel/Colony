//
//  EurekaCivicActivatedPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class EurekaCivicActivatedPopupViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var summaryText: String

    @Published
    var descriptionText: String

    private let civicType: CivicType

    weak var delegate: GameViewModelDelegate?

    init(civicType: CivicType) {

        self.civicType = civicType

        self.title = "TXT_KEY_INSPIRATION".localized()
        self.summaryText = civicType.eurekaDescription().localized()
        self.descriptionText = "TXT_KEY_INSPIRATION_TRIGGERED".localizedWithFormat(with: [civicType.name().localized()])
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.civicType.iconTexture())
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
