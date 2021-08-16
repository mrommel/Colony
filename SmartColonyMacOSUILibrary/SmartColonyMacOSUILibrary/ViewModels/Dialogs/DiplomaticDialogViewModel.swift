//
//  DiplomaticDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.06.21.
//

import SwiftUI
import SmartAILibrary

public class DiplomaticDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    // private
    private var humanPlayer: AbstractPlayer?
    private var otherPlayer: AbstractPlayer?
    private var messageType: DiplomaticRequestMessage = .messageIntro {
        didSet {
            self.updateMessageAndReplies()
        }
    }

    @Published
    var message: String = ""

    @Published
    var replyViewModels: [ReplyViewModel] = []

    weak var delegate: GameViewModelDelegate?

    public init() {

    }

#if DEBUG
    public init(for humanPlayer: AbstractPlayer?, and otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        self.update(for: humanPlayer, and: otherPlayer, state: .intro, message: .messageIntro, emotion: .neutral, in: gameModel)
    }
#endif

    func update(for humanPlayer: AbstractPlayer?, and otherPlayer: AbstractPlayer?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType, in gameModel: GameModel?) {

        self.humanPlayer = humanPlayer
        self.otherPlayer = otherPlayer
        self.messageType = message
    }

    func add(deal: DiplomaticDeal) {

        // self.deal = deal

        // self.presenter?.show(deal: deal)
    }

    private func updateMessageAndReplies() {

        self.message = self.messageType.diploStringForMessage(for: self.humanPlayer, and: self.otherPlayer)

        self.replyViewModels = []
        let replies = self.messageType.diploOptions()
        for reply in replies {

            // fix: if one player doesn't have a capital, skip this option
            //if reply == .

            let replyViewModel = ReplyViewModel(reply: reply)
            replyViewModel.delegate = self
            self.replyViewModels.append(replyViewModel)
        }
    }

    func leaderImage() -> NSImage {

        guard let player = self.otherPlayer else {
            return ImageCache.shared.image(for: LeaderType.none.iconTexture())
        }

        return ImageCache.shared.image(for: player.leader.iconTexture())
    }

    func leaderName() -> String {

        guard let player = self.otherPlayer else {
            return "None"
        }

        return player.leader.name()
    }

    func civilizationName() -> String {

        guard let player = self.otherPlayer else {
            return "None"
        }

        return player.leader.civilization().name()
    }
}

extension DiplomaticDialogViewModel: ReplyViewModelDelegate {

    func selected(reply: DiplomaticReplyMessage) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = self.humanPlayer else {
            fatalError("cant get humanPlayer")
        }

        guard let otherPlayer = self.otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        switch self.messageType {

        case .exit:
            break

        case .messageIntro:
            if reply == .introReplyPositive {
                if humanPlayer.hasCapital(in: gameModel) && !humanPlayer.hasDiscoveredCapital(of: otherPlayer, in: gameModel) &&
                    otherPlayer.hasCapital(in: gameModel) && !otherPlayer.hasDiscoveredCapital(of: humanPlayer, in: gameModel) {
                    self.messageType = .invitationToCapital
                } else {
                    self.messageType = .exit
                }
            } else if reply == .introReplyBusy {
                self.messageType = .exit
            }

        case .invitationToCapital:
            // exchange knowledge about capital
            humanPlayer.discoverCapital(of: otherPlayer, in: gameModel)
            otherPlayer.discoverCapital(of: humanPlayer, in: gameModel)
            self.messageType = .exit

        case .peaceOffer:
            fatalError("not yet handled: \(self.message) with \(reply)")

        case .embassyExchange:
            if reply == .dealPositive {
                print("deal positive")
                self.messageType = .exit
            } else if reply == .dealNegative {
                print("deal negative")
                self.messageType = .exit
            }

        case .embassyOffer:
            if reply == .dealPositive {
                print("deal positive")
                self.messageType = .exit
            } else if reply == .dealNegative {
                print("deal negative")
                self.messageType = .exit
            }

        case .openBordersExchange:
            fatalError("not yet handled: \(self.messageType) + \(reply)")
        case .openBordersOffer:
            fatalError("not yet handled: \(self.messageType) + \(reply)")
        case .coopWarRequest:
            fatalError("not yet handled: \(self.messageType) + \(reply)")
        case .coopWarTime:
            fatalError("not yet handled: \(self.messageType) + \(reply)")
        }

        // if message is exit => leave
        if self.messageType == .exit {
            self.delegate?.closeDialog()
        }
    }
}
