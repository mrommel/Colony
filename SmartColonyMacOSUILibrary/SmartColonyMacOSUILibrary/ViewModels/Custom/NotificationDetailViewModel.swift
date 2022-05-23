//
//  NotificationDetailViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.11.21.
//

import SwiftUI

protocol NotificationDetailViewModelDelegate: AnyObject {

    func clickedContent(with index: Int)
}

class NotificationDetailViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var titleText: String

    @Published
    var selectedText: String

    @Published
    var selected: Int = 0

    @Published
    var pages: Int

    private let texts: [String]

    weak var delegate: NotificationDetailViewModelDelegate?

    init(title: String, texts: [String]) {

        self.titleText = title
        self.texts = texts
        self.pages = texts.count
        self.selectedText = texts[0]
    }

    func clicked() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        guard humanPlayer.isActive() else {
            // only open dialog when human is active
            return
        }

        self.delegate?.clickedContent(with: self.selected)
    }

    func selectNextClicked() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        guard humanPlayer.isActive() else {
            // only open dialog when human is active
            return
        }

        self.selected = (self.selected + 1) % self.texts.count
        self.selectedText = self.texts[self.selected]
    }
}
