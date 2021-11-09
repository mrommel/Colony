//
//  OverallRankingViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class OverallRankingViewModel: ObservableObject {

    let id: UUID = UUID()

    let type: RankingViewType

    @Published
    var title: String

    @Published
    var summary: String

    @Published
    var civilizationViewModels: [CivilizationViewModel]

    init(type: RankingViewType, summary: String, civilizations: [CivilizationType]) {

        self.type = type

        self.title = type.name()
        self.summary = summary
        self.civilizationViewModels = civilizations.map {
            CivilizationViewModel(civilization: $0)
        }
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.type.iconTexture())
    }
}

extension OverallRankingViewModel: Hashable {

    static func == (lhs: OverallRankingViewModel, rhs: OverallRankingViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
