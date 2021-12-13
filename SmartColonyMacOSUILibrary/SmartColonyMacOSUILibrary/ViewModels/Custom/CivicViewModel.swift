//
//  CivicViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

enum CivicTypeState {

    case researched
    case selected
    case possible
    case disabled

    func backgroundTexture() -> String {

        switch self {

        case .researched:
            return "civicInfo-researched"
        case .selected:
            return "civicInfo-researching"
        case .possible:
            return "civicInfo-active"
        case .disabled:
            return "civicInfo-disabled"
        }
    }
}

protocol CivicViewModelDelegate: AnyObject {

    func selected(civic: CivicType)
}

class CivicViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    var civicType: CivicType

    @Published
    var state: CivicTypeState

    @Published
    var achievementViewModels: [AchievementViewModel] = []

    let boosted: Bool
    let turns: Int

    weak var delegate: CivicViewModelDelegate?

    init(civicType: CivicType, state: CivicTypeState, boosted: Bool, turns: Int) {

        self.civicType = civicType
        self.state = state
        self.boosted = boosted
        self.turns = turns

        self.achievementViewModels = self.achievements()
    }

    func title() -> String {

        return self.civicType.name()
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.civicType.iconTexture())
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: self.state.backgroundTexture()).resize(withSize: NSSize(width: 42, height: 42))!
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

    func turnsText() -> String {

        if self.turns == -1 {
            return ""
        }

        return "Turns \(self.turns)" // TODO localize
    }

    func boostText() -> String {

        if self.civicType.eurekaSummary() == "" {
            return ""
        }

        if self.boosted {
            return "Boosted: " + self.civicType.eurekaSummary().localized() // TODO localize
        } else {
            return "To boost: " + self.civicType.eurekaSummary().localized() // TODO localize
        }
    }

    func selectCivic() {

        self.delegate?.selected(civic: self.civicType)
    }
}

extension CivicViewModel: Hashable {

    static func == (lhs: CivicViewModel, rhs: CivicViewModel) -> Bool {

        return lhs.civicType == rhs.civicType
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.civicType)
    }
}
