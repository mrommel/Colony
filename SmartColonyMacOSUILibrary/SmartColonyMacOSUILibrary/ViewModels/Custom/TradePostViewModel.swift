//
//  TradePostViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.05.21.
//

import SwiftUI
import SmartAILibrary

class TradePostViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    var leaderType: LeaderType

    init(leaderType: LeaderType) {

        self.leaderType = leaderType
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.leaderType.iconTexture())
    }

    func title() -> String {

        guard let game = self.gameEnvironment.game.value else {
            return "-"
        }

        guard let humanPlayer = game.humanPlayer() else {
            return "-"
        }

        if humanPlayer.leader == self.leaderType {
            return "\(self.leaderType.name()) (You)"
        }

        return self.leaderType.name()
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: "grid9-button-active")
    }
}

extension TradePostViewModel: Hashable {

    static func == (lhs: TradePostViewModel, rhs: TradePostViewModel) -> Bool {

        return lhs.leaderType == rhs.leaderType
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.leaderType)
    }
}
