//
//  CivicDiscoveredPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class CivicDiscoveredPopupViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var nameText: String

    @Published
    var civicViewModels: [CivicViewModel] = []

    @Published
    var quoteText: String

    private var civicType: CivicType = .none

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "TXT_KEY_RESEARCH_COMPLETED".localized()
        self.nameText = "-"
        self.quoteText = "-"
    }

    func update(for civicType: CivicType) {

        self.civicType = civicType
        self.nameText = self.civicType.name().localized()
        let quotes = self.civicType.quoteTexts()
        self.quoteText = !quotes.isEmpty ? quotes.randomItem().localized() : "-"
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.civicType.iconTexture())
    }

    func achievements() -> [NSImage] {

        var iconTextureNames: [String] = []

        let achievements = self.civicType.achievements()

        for buildingType in achievements.buildingTypes {
            iconTextureNames.append(buildingType.iconTexture())
        }

        for unitType in achievements.unitTypes {
            iconTextureNames.append(unitType.typeTexture())
        }

        for wonderType in achievements.wonderTypes {
            iconTextureNames.append(wonderType.iconTexture())
        }

        for buildType in achievements.buildTypes {
            iconTextureNames.append(buildType.iconTexture())
        }

        for districtType in achievements.districtTypes {
            iconTextureNames.append(districtType.iconTexture())
        }

        for policyCard in achievements.policyCards {
            iconTextureNames.append(policyCard.iconTexture())
        }

        return iconTextureNames.map { ImageCache.shared.image(for: $0) }
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
