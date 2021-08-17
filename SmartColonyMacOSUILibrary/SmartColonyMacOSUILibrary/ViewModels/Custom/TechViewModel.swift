//
//  TechViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI
import SmartAILibrary

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

        return self.techType.name()
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.techType.iconTexture())
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: self.state.backgroundTexture()).resize(withSize: NSSize(width: 42, height: 42))!
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

    func turnsText() -> String {

        if self.turns == -1 {
            return ""
        }

        return "Turns \(self.turns)"
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
