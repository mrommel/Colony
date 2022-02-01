//
//  TechViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

enum TechTypeState {

    case researched
    case selected
    case possible
    case disabled

    func backgroundTexture() -> String {

        switch self {

        case .researched:
            return "techInfo-researched"
        case .selected:
            return "techInfo-researching"
        case .possible:
            return "techInfo-active"
        case .disabled:
            return "techInfo-disabled"
        }
    }
}

protocol TechViewModelDelegate: AnyObject {

    func selected(tech: TechType)
}

class TechViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    var techType: TechType

    @Published
    var state: TechTypeState

    @Published
    var achievementViewModels: [AchievementViewModel] = []

    let boosted: Bool
    let turns: Int

    weak var delegate: TechViewModelDelegate?

    init(techType: TechType, state: TechTypeState, boosted: Bool, turns: Int) {

        self.techType = techType
        self.state = state
        self.boosted = boosted
        self.turns = turns

        self.achievementViewModels = self.achievements()
    }

    func title() -> String {

        return self.techType.name().localized()
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.techType.iconTexture())
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: self.state.backgroundTexture())
            .resize(withSize: NSSize(width: 42, height: 42))!
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

    func turnsText() -> String {

        if self.turns == -1 {
            return ""
        }

        return "TXT_KEY_TURNS".localized() + " " + "\(self.turns)"
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

    func selectTech() {

        self.delegate?.selected(tech: self.techType)
    }
}

extension TechViewModel: Hashable {

    static func == (lhs: TechViewModel, rhs: TechViewModel) -> Bool {

        return lhs.techType == rhs.techType
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.techType)
    }
}
