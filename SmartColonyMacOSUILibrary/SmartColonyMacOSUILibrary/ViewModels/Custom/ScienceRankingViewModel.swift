//
//  ScienceRankingViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class ScienceRankingViewModel: ObservableObject {

    private var id: UUID = UUID()

    @Published
    var toolTip: String

    @Published
    var leaderName: String

    @Published
    var science: Int

    private let civilization: CivilizationType

    init(civilization: CivilizationType, leader: LeaderType, science: Int) {

        self.civilization = civilization
        self.toolTip = leader.name()
        self.leaderName = leader.name()
        self.science = science
    }

    func image() -> NSImage {

        ImageCache.shared.image(for: self.civilization.iconTexture())
    }
}

extension ScienceRankingViewModel: Hashable {

    static func == (lhs: ScienceRankingViewModel, rhs: ScienceRankingViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
