//
//  BannerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.01.22.
//

import SwiftUI

public class BannerViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var bannerVisible: Bool

    @Published
    var bannerText: String

    @Published
    var currentPlayer: Int

    @Published
    var maximumPlayer: Int

    init() {

        self.bannerVisible = false
        self.bannerText = "Other players are taking their turns, please wait ..."
        self.currentPlayer = 0
        self.maximumPlayer = 10
    }

    func showBanner() {

        if !self.bannerVisible {
            self.bannerVisible = true
        }
    }

    func hideBanner() {

        if self.bannerVisible {
            self.bannerVisible = false
        }
    }

    func updateBanner(current: Int, maximum: Int) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        self.maximumPlayer = gameModel.players.count

        self.currentPlayer = current
        // self.maximumPlayer = maximum
    }
}
