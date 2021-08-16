//
//  EurekaCivicActivatedPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary

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

        self.title = "Inspiration"
        self.summaryText = civicType.eurekaDescription()
        self.descriptionText = "Your progress towards \(civicType   ) has advanced considerably."
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.civicType.iconTexture())
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
