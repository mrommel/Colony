//
//  CivicProgressViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class CivicProgressViewModel: ObservableObject {

    let id: UUID = UUID()

    var civicType: CivicType

    @Published
    var progress: Int

    @Published
    var turns: Int

    @Published
    var boosted: Bool

    @Published
    var achievementViewModels: [AchievementViewModel] = []

    init() {

        self.civicType = .none
        self.progress = 0
        self.turns = 0
        self.boosted = false

        self.achievementViewModels = []
    }

#if DEBUG
    init(civicType: CivicType, progress: Int, turns: Int, boosted: Bool) {

        self.civicType = civicType
        self.progress = progress
        self.turns = turns
        self.boosted = boosted

        self.achievementViewModels = self.achievements()
    }
#endif

    func update(civicType: CivicType, progress: Int, turns: Int, boosted: Bool) {

        self.civicType = civicType
        self.progress = progress
        self.turns = turns
        self.boosted = boosted

        self.achievementViewModels = self.achievements()
    }

    func title() -> String {

        return self.civicType.name().localized()
    }

    func iconImage() -> NSImage {

        return ImageCache.shared.image(for: self.civicType.iconTexture())
    }

    func progressImage() -> NSImage {

        let progress_val = self.progress <= 100 ? self.progress : 100

        let textureName = "culture_progress_\(progress_val)"
        return ImageCache.shared.image(for: textureName)
    }

    private func achievements() -> [AchievementViewModel] {

        var achievementViewModels: [AchievementViewModel] = []

        let achievements = self.civicType.achievements()

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

        for policyCard in achievements.policyCards {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: policyCard.iconTexture(),
                    toolTipText: policyCard.toolTip()
                )
            )
        }

        if self.civicType.governorTitle() {
            achievementViewModels.append(
                AchievementViewModel(
                    imageName: "header-button-governors-active",
                    toolTipText: NSAttributedString(string: "TXT_KEY_GOVERNOR_TITLE".localized())
                )
            )
        }

        return achievementViewModels
    }

    func boostText() -> String {

        if self.civicType.inspirationSummary() == "" {
            return ""
        }

        if self.boosted {
            return "TXT_KEY_BOOSTED".localized() + " " +
                self.civicType.inspirationSummary().localized()
        } else {
            return "TXT_KEY_TO_BOOST".localized() + " " +
                self.civicType.inspirationSummary().localized()
        }
    }
}
