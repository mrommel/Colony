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

        return self.techType.name()
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

        return iconTextureNames.map {
            return AchievementViewModel(imageName: $0)
        }
    }

    func boostText() -> String {

        if self.techType.eurekaSummary() == "" {
            return ""
        }

        if self.boosted {
            return "Boosted: " + self.techType.eurekaSummary()
        } else {
            return "To boost: " + self.techType.eurekaSummary()
        }
    }
}
