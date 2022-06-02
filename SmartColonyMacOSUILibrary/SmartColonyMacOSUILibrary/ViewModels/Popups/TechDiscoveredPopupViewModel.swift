//
//  TechDiscoveredPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class TechDiscoveredPopupViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var nameText: String

    @Published
    var achievementViewModels: [AchievementViewModel] = []

    @Published
    var quoteText: String

    private var techType: TechType = .none

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "TXT_KEY_RESEARCH_COMPLETED".localized()
        self.nameText = "-"
        self.quoteText = "-"

        self.achievementViewModels = self.achievements()
    }

    func update(for techType: TechType) {

        self.techType = techType

        self.nameText = self.techType.name().localized()

        let quotes = self.techType.quoteTexts()
        self.quoteText = !quotes.isEmpty ? quotes.randomItem().localized() : "-"
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.techType.iconTexture())
    }

    private func achievements() -> [AchievementViewModel] {

        var achievementViewModels: [AchievementViewModel] = []

        let achievements = self.techType.achievements()

        for buildingType in achievements.buildingTypes {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: buildingType.iconTexture(),
                    toolTipText: buildingType.toolTip()
                )
            )
        }

        for unitType in achievements.unitTypes {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: unitType.typeTexture(),
                    toolTipText: unitType.toolTip()
                )
            )
        }

        for wonderType in achievements.wonderTypes {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: wonderType.iconTexture(),
                    toolTipText: wonderType.toolTip()
                )
            )
        }

        for buildType in achievements.buildTypes {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: buildType.iconTexture(),
                    toolTipText: buildType.toolTip()
                )
            )
        }

        for districtType in achievements.districtTypes {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: districtType.iconTexture(),
                    toolTipText: districtType.toolTip()
                )
            )
        }

        return achievementViewModels
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
