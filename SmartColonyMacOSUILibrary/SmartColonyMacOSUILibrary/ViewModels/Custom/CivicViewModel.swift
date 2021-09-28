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

        if self.civicType.governorTitle() {
            iconTextureNames.append("header-button-governors-active")
        }

        return iconTextureNames.map {
            return AchievementViewModel(imageName: $0)
        }
    }

    func turnsText() -> String {

        if self.turns == -1 {
            return ""
        }

        return "Turns \(self.turns)"
    }

    func boostText() -> String {

        if self.civicType.eurekaSummary() == "" {
            return ""
        }

        if self.boosted {
            return "Boosted: " + self.civicType.eurekaSummary()
        } else {
            return "To boost: " + self.civicType.eurekaSummary()
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
