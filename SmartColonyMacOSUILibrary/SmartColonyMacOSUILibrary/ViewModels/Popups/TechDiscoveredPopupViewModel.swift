//
//  TechDiscoveredPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary

class TechDiscoveredPopupViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var nameText: String

    @Published
    var techViewModels: [TechViewModel] = []

    @Published
    var quoteText: String

    private let techType: TechType

    weak var delegate: GameViewModelDelegate?

    init(techType: TechType) {

        self.techType = techType

        self.title = "Research completed"
        self.nameText = self.techType.name()

        let quotes = self.techType.quoteTexts()
        self.quoteText = !quotes.isEmpty ? quotes.randomItem() : "-"
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.techType.iconTexture())
    }

    func achievements() -> [NSImage] {

        var iconTextureNames: [String] = []

        let achievements = self.techType.achievements()

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

        return iconTextureNames.map { ImageCache.shared.image(for: $0) }
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
