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

        self.title = "Eureka"
        self.summaryText = techType.eurekaDescription()
        self.descriptionText = "Your knowledge of \(techType) has advanced considerably."
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.techType.iconTexture())
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
