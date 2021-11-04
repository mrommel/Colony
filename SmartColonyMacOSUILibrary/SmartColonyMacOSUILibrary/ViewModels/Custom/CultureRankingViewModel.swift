//
//  CultureRankingViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class CultureRankingViewModel: ObservableObject {

    private var id: UUID = UUID()

    @Published
    var toolTip: String

    @Published
    var leaderName: String

    @Published
    var domesticTourists: Int

    @Published
    var visitingTourists: Int

    @Published
    var maxOtherDomesticTourists: Int

    private let civilization: CivilizationType

    init(
        civilization: CivilizationType,
        leader: LeaderType,
        domesticTourists: Int,
        visitingTourists: Int,
        maxOtherDomesticTourists: Int) {

        self.civilization = civilization
        self.toolTip = leader.name()
        self.leaderName = leader.name()
        self.domesticTourists = domesticTourists
        self.visitingTourists = visitingTourists
        self.maxOtherDomesticTourists = maxOtherDomesticTourists
    }

    func image() -> NSImage {

        ImageCache.shared.image(for: self.civilization.iconTexture())
    }
}

extension CultureRankingViewModel: Hashable {

    static func == (lhs: CultureRankingViewModel, rhs: CultureRankingViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
