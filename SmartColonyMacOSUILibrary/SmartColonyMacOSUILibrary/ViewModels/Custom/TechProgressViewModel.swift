//
//  TechProgressViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class TechProgressViewModel: ObservableObject {

    let id: UUID = UUID()

    var techType: TechType

    @Published
    var progress: Int

    @Published
    var turns: Int

    @Published
    var boosted: Bool

    @Published
    var achievementViewModels: [AchievementViewModel] = []

    init() {

        self.techType = .none
        self.progress = 0
        self.turns = 0
        self.boosted = false

        self.achievementViewModels = []
    }

#if DEBUG
    init(techType: TechType, progress: Int, turns: Int, boosted: Bool) {

        self.techType = techType
        self.progress = progress
        self.turns = turns
        self.boosted = boosted

        self.achievementViewModels = self.achievements()
    }
#endif

    func update(techType: TechType, progress: Int, turns: Int, boosted: Bool) {

        self.techType = techType
        self.progress = progress
        self.turns = turns
        self.boosted = boosted

        self.achievementViewModels = self.achievements()
    }

    func title() -> String {

        return self.techType.name().localized()
    }

    func iconImage() -> NSImage {

        return ImageCache.shared.image(for: self.techType.iconTexture())
    }

    func progressImage() -> NSImage {

        let progress_val = self.progress <= 100 ? self.progress : 100

        let textureName = "science_progress_\(progress_val)"
        return ImageCache.shared.image(for: textureName)
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

    func boostText() -> String {

        if self.techType.eurekaSummary() == "" {
            return ""
        }

        if self.boosted {
            return "TXT_KEY_BOOSTED".localized() + ": " +
            self.techType.eurekaSummary().localized()
        } else {
            return "TXT_KEY_TO_BOOST".localized() + ": " +
                self.techType.eurekaSummary().localized()
        }
    }
}
