//
//  DominationRankingViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class DominationRankingViewModel: ObservableObject {

    private var id: UUID = UUID()

    @Published
    var toolTip: String

    @Published
    var leaderName: String

    @Published
    var capturedCapitals: [CivilizationViewModel]

    private let civilization: CivilizationType

    init(
        civilization: CivilizationType,
        leader: LeaderType,
        capturedCapitals: [CivilizationType]) {

        self.civilization = civilization
        self.toolTip = leader.name().localized()
        self.leaderName = leader.name().localized()
        self.capturedCapitals = capturedCapitals.map {
            return CivilizationViewModel(civilization: $0)
        }
    }

    func image() -> NSImage {

        ImageCache.shared.image(for: self.civilization.iconTexture())
    }
}

extension DominationRankingViewModel: Hashable {

    static func == (lhs: DominationRankingViewModel, rhs: DominationRankingViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
