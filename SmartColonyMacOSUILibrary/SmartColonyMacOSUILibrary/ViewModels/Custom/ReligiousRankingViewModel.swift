//
//  ReligiousRankingViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class ReligiousRankingViewModel: ObservableObject {

    private var id: UUID = UUID()

    @Published
    var toolTip: String

    @Published
    var leaderName: String

    @Published
    var religionName: String

    @Published
    var convertedCivilizations: [CivilizationViewModel]

    private let civilization: CivilizationType

    init(
        civilization: CivilizationType,
        leader: LeaderType,
        religion: ReligionType,
        convertedCivilizations: [CivilizationType]
    ) {

        self.civilization = civilization
        self.toolTip = leader.name().localized()
        self.leaderName = leader.name().localized()
        self.religionName = religion.name().localized()
        self.convertedCivilizations = convertedCivilizations.map {
            return CivilizationViewModel(civilization: $0)
        }
    }

    func image() -> NSImage {

        ImageCache.shared.image(for: self.civilization.iconTexture())
    }
}

extension ReligiousRankingViewModel: Hashable {

    static func == (lhs: ReligiousRankingViewModel, rhs: ReligiousRankingViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
