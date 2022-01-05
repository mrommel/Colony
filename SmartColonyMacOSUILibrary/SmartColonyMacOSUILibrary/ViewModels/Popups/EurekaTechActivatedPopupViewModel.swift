//
//  EurekaTechActivatedPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class EurekaTechActivatedPopupViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var summaryText: String

    @Published
    var descriptionText: String

    private let techType: TechType

    weak var delegate: GameViewModelDelegate?

    init(techType: TechType) {

        self.techType = techType

        self.title = "TXT_KEY_EUREKA".localized()
        self.summaryText = techType.eurekaDescription().localized()
        self.descriptionText = "TXT_KEY_EUREKA_TRIGGERED".localizedWithFormat(with: [techType.name().localized()])
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.techType.iconTexture())
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
