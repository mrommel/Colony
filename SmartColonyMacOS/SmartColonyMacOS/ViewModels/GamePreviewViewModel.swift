//
//  GamePreviewViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 29.04.22.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class GamePreviewViewModel: ObservableObject {

    @Published
    var civilization: CivilizationType

    @Published
    var leader: LeaderType

    @Published
    var handicap: HandicapType

    init() {

        self.civilization = .barbarian
        self.leader = .barbar
        self.handicap = .deity
    }

    func civilizationImage() -> NSImage {

        return ImageCache.shared.image(for: self.civilization.iconTexture())
    }

    func civilizationToolTip() -> String {

        return self.civilization.name().localized()
    }

    func leaderImage() -> NSImage {

        return ImageCache.shared.image(for: self.leader.iconTexture())
    }

    func leaderToolTip() -> String {

        return self.leader.name().localized()
    }

    func handicapImage() -> NSImage {

        return ImageCache.shared.image(for: self.handicap.iconTexture())
    }

    func handicapToolTip() -> String {

        return self.handicap.name().localized()
    }

    func speedImage() -> NSImage {

        return ImageCache.shared.image(for: "speed-standard")
    }
}
