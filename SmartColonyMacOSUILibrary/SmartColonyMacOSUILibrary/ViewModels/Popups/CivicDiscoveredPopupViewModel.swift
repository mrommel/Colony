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
    var achievementViewModels: [AchievementViewModel] = []

    @Published
    var quoteText: String

    private var civicType: CivicType = .none

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "TXT_KEY_RESEARCH_COMPLETED".localized()
        self.nameText = "-"
        self.quoteText = "-"

        self.achievementViewModels = self.achievements()
    }

    func update(for civicType: CivicType) {

        self.civicType = civicType
        self.nameText = self.civicType.name().localized()
        let quotes = self.civicType.quoteTexts()
        self.quoteText = !quotes.isEmpty ? quotes.randomItem().localized() : "-"

        self.achievementViewModels = self.achievements()
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.civicType.iconTexture())
    }

    private func achievements() -> [AchievementViewModel] {

        var achievementViewModels: [AchievementViewModel] = []

        let achievements = self.civicType.achievements()

        for governmentType in achievements.governments {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: governmentType.iconTexture(),
                    mode: .medium,
                    toolTipText: governmentType.toolTip()
                )
            )
        }

        for buildingType in achievements.buildingTypes {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: buildingType.iconTexture(),
                    mode: .medium,
                    toolTipText: buildingType.toolTip()
                )
            )
        }

        for unitType in achievements.unitTypes {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: unitType.typeTexture(),
                    mode: .medium,
                    toolTipText: unitType.toolTip()
                )
            )
        }

        for wonderType in achievements.wonderTypes {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: wonderType.iconTexture(),
                    mode: .medium,
                    toolTipText: wonderType.toolTip()
                )
            )
        }

        for buildType in achievements.buildTypes {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: buildType.iconTexture(),
                    mode: .medium,
                    toolTipText: buildType.toolTip()
                )
            )
        }

        for districtType in achievements.districtTypes {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: districtType.iconTexture(),
                    mode: .medium,
                    toolTipText: districtType.toolTip()
                )
            )
        }

        for policyCard in achievements.policyCards {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: policyCard.iconTexture(),
                    mode: .medium,
                    toolTipText: policyCard.toolTip()
                )
            )
        }

        if self.civicType.hasGovernorTitle() {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: "header-button-governors",
                    mode: .medium,
                    toolTipText: NSAttributedString(string: "TXT_KEY_GOVERNOR_TITLE".localized())
                )
            )
        }

        if self.civicType.envoys() > 0 {

            var toolTipText = ""
            if self.civicType.envoys() == 1 {
                toolTipText = "1 " + "TXT_KEY_ENVOY".localized()
            } else {
                toolTipText = "\(self.civicType.envoys()) " + "TXT_KEY_ENVOYS".localized()
            }

            achievementViewModels.append(
                AchievementViewModel(
                    imageName: "envoy",
                    mode: .medium,
                    toolTipText: NSAttributedString(string: toolTipText, attributes: Globals.Attributs.tooltipTitleAttributs)
                )
            )
        }

        return achievementViewModels
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
