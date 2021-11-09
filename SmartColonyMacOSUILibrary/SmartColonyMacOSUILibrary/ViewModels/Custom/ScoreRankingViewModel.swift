//
//  ScoreRankingViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class ScoreRankingViewModel: ObservableObject {

    private var id: UUID = UUID()

    @Published
    var toolTip: String

    @Published
    var leaderName: String

    @Published
    var score: Int

    private let civilization: CivilizationType

    init(civilization: CivilizationType, leader: LeaderType, score: Int) {

        self.civilization = civilization
        self.toolTip = leader.name()
        self.leaderName = leader.name()
        self.score = score
    }

    func image() -> NSImage {

        ImageCache.shared.image(for: self.civilization.iconTexture())
    }
}

extension ScoreRankingViewModel: Hashable {

    static func == (lhs: ScoreRankingViewModel, rhs: ScoreRankingViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
