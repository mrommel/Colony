//
//  DiplomaticDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

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

    // messages
    @Published
    var state: DiplomaticRequestState = .intro

    @Published
    var message: String = ""

    @Published
    var replyViewModels: [ReplyViewModel] = []
    // messages

    // actions
    @Published
    var canSendDelegation: Bool = false

    @Published
    var canDenounce: Bool = false

    @Published
    var canDeclareWar: Bool = false

    @Published
    var canDeclareFriendship: Bool = false

    @Published
    var canMakeDeal: Bool = false
    // actions

    // reports
    @Published
    var intelReportType: IntelReportType = .overview

    @Published
    var discussionIntelReportTitle: String

    @Published
    var relationShipRating: Double = 0.0

    @Published
    var relationShipLabel: String = ""

    @Published
    var accessLevelLabel: String = ""

    @Published
    var approachItemViewModels: [ApproachItemViewModel] = []

    @Published
    var lastGossipItems: [String] = []

    @Published
    var olderGossipItems: [String] = []
    // reports

    weak var delegate: GameViewModelDelegate?

    public init() {

        self.discussionIntelReportTitle = "TXT_KEY_DIPLOMACY_INTEL_REPORT_TITLE".localized() + IntelReportType.overview.title().localized()
    }

#if DEBUG
    public convenience init(for humanPlayer: AbstractPlayer?, and otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        self.init()

        self.update(for: humanPlayer,
                       and: otherPlayer,
                       state: .intro,
                       message: .messageIntro,
                       emotion: .neutral,
                       in: gameModel)
    }
#endif

    func update(for humanPlayer: AbstractPlayer?,
                and otherPlayer: AbstractPlayer?,
                state: DiplomaticRequestState,
                message: DiplomaticRequestMessage,
                emotion: LeaderEmotionType,
                in gameModel: GameModel?) {

        /* guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        } */

        self.humanPlayer = humanPlayer
        self.otherPlayer = otherPlayer

        self.state = state
        self.messageType = message

        // fill data
        guard let humanPlayer = self.humanPlayer else {
            fatalError("cant get humanPlayer")
        }

        guard let humanPlayerDiplomacyAI = humanPlayer.diplomacyAI else {
            fatalError("cant get humanPlayer diplomacyAI")
        }

        guard let otherPlayer = self.otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        guard let otherPlayerDiplomacyAI = otherPlayer.diplomacyAI else {
            fatalError("cant get otherPlayer diplomacyAI")
        }

        // access level tab
        let accessLevel: AccessLevel = humanPlayerDiplomacyAI.accessLevel(towards: otherPlayer)
        self.accessLevelLabel = accessLevel.name()

        // relations tab
        let approachValue = otherPlayerDiplomacyAI.approachValue(towards: humanPlayer)
        let approach = otherPlayerDiplomacyAI.approach(towards: humanPlayer)
        self.relationShipRating = Double(approachValue)
        self.relationShipLabel = approach.name().localized()

        var tmpApproachItemViewModels: [ApproachItemViewModel] = []
        for approachItem in otherPlayerDiplomacyAI.approachItems(towards: humanPlayer) {
            tmpApproachItemViewModels.append(ApproachItemViewModel(value: approachItem.value, text: approachItem.type.summary()))
        }
        self.approachItemViewModels = tmpApproachItemViewModels

        // gossip
        let gossipItems: [GossipItem] = humanPlayerDiplomacyAI.gossipItems(for: otherPlayer)
        let lastItems: [GossipItem] = gossipItems.filter { return $0.isLastTenTurns(in: gameModel) }
        self.lastGossipItems = lastItems.map { $0.source().text() + $0.type().text(for: humanPlayer.leader.civilization()) }
        /*self.olderGossipItems = gossipItems
            .filter { return !$0.isLastTenTurns(in: gameModel) }
            .map { $0.source().text() + $0.type().text(for: "abc") }*/

        self.updateActions()
    }

    func add(deal: DiplomaticDeal) {

        // self.deal = deal

        // self.presenter?.show(deal: deal)
    }

    private func updateMessageAndReplies() {

        guard self.humanPlayer?.isHuman() ?? false else {
            fatalError("human player not human")
        }

        self.message = self.messageType.diploStringForMessage(for: self.otherPlayer, and: self.humanPlayer)

        self.replyViewModels = []
        let replies = self.messageType.diploOptions()
        for reply in replies {

            // fix: if one player doesn't have a capital, skip this option
            // if reply == .

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

        return player.leader.name().localized()
    }

    func civilizationName() -> String {

        guard let player = self.otherPlayer else {
            return "None"
        }

        return player.leader.civilization().name().localized()
    }

    func relationShipImage() -> NSImage {

        guard let humanPlayer = self.humanPlayer else {
            fatalError("cant get humanPlayer")
        }

        guard let otherPlayer = self.otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        guard let otherPlayerDiplomacyAI = otherPlayer.diplomacyAI else {
            fatalError("cant get otherPlayer diplomacyAI")
        }

        let approach = otherPlayerDiplomacyAI.approach(towards: humanPlayer)

        return ImageCache.shared.image(for: approach.iconTexture())
    }

    func accessLevelImage() -> NSImage {

        guard let humanPlayer = self.humanPlayer else {
            fatalError("cant get humanPlayer")
        }

        guard let humanPlayerDiplomacyAI = humanPlayer.diplomacyAI else {
            fatalError("cant get humanPlayer diplomacyAI")
        }

        guard let otherPlayer = self.otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        guard let otherPlayerDiplomacyAI = otherPlayer.diplomacyAI else {
            fatalError("cant get otherPlayer diplomacyAI")
        }

        let accessLevel: AccessLevel = humanPlayerDiplomacyAI.accessLevel(towards: otherPlayer)

        return ImageCache.shared.image(for: accessLevel.iconTexture())
    }

    func select(report: IntelReportType) {

        self.intelReportType = report
        self.discussionIntelReportTitle = "TXT_KEY_DIPLOMACY_INTEL_REPORT_TITLE".localized() + self.intelReportType.title().localized()
    }

    func updateActions() {

        guard let playerDiplomacyAI = self.humanPlayer?.diplomacyAI else {
            fatalError("cant get player diplomacy")
        }

        self.canSendDelegation = playerDiplomacyAI.canSendDelegation(to: otherPlayer)
        self.canDenounce = playerDiplomacyAI.canDenounce(player: otherPlayer)
        self.canDeclareWar = playerDiplomacyAI.canDeclareWar(to: otherPlayer)
        self.canDeclareFriendship = playerDiplomacyAI.canDeclareFriendship(with: otherPlayer)
    }

    func overview(for report: IntelReportType) -> NSAttributedString {

        /*guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = self.humanPlayer else {
            fatalError("cant get humanPlayer")
        }*/

        guard let otherPlayer = self.otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        guard let currentGovernment = otherPlayer.government?.currentGovernment() else {
            fatalError("cant get current government")
        }

        guard let otherPlayerDiplomacyAI = otherPlayer.diplomacyAI else {
            fatalError("cant get otherPlayer diplomacyAI")
        }

        var agendas: [String] = []

        let publicAgendaName: String = otherPlayer.leader.agenda().name().localized()
        agendas.append(publicAgendaName)

        let hiddenAgendaName: String = otherPlayer.hiddenAgenda()?.name().localized() ?? ""
        if !hiddenAgendaName.isEmpty {
            agendas.append(hiddenAgendaName)
        }

        let tokenizer = LabelTokenizer()

        let approach: PlayerApproachType = otherPlayerDiplomacyAI.approach(towards: humanPlayer)

        switch report {

        case .action:
            return NSAttributedString(string: "-")
        case .overview:
            return NSAttributedString(string: "-")
        case .gossip:
            return tokenizer.bulletPointList(from: ["No New Items"])
        case .accessLevel:
            return tokenizer.bulletPointList(from: ["None"])
        case .government:
            return tokenizer.bulletPointList(from: [currentGovernment.name().localized()])
        case .agendas:
            return tokenizer.bulletPointList(from: agendas)
        case .ownRelationship:
            return tokenizer.bulletPointList(from: [approach.name()]) // how the otherplayer sees us
        case .otherRelationships:
            return NSAttributedString(string: "-")
        }
    }

    func declareFriendshipClicked() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let playerDiplomacyAI = self.humanPlayer?.diplomacyAI else {
            fatalError("cant get player diplomacy")
        }

        if playerDiplomacyAI.canDeclareFriendship(with: self.otherPlayer) {
            playerDiplomacyAI.doDeclarationOfFriendship(with: self.otherPlayer, in: gameModel)
        }

        self.updateActions()
    }

    func sendDelegationClicked() {

        guard let playerDiplomacyAI = self.humanPlayer?.diplomacyAI else {
            fatalError("cant get player diplomacy")
        }

        if playerDiplomacyAI.canSendDelegation(to: otherPlayer) {
            self.humanPlayer?.diplomacyAI?.doSendDelegation(to: self.otherPlayer)
        }

        self.updateActions()
    }

    func sendEmbassyClicked() {

        guard let playerDiplomacyAI = self.humanPlayer?.diplomacyAI else {
            fatalError("cant get player diplomacy")
        }

        if playerDiplomacyAI.canSendEmbassy(to: otherPlayer) {
            self.humanPlayer?.diplomacyAI?.doSendEmbassy(to: self.otherPlayer)
        }

        self.updateActions()
    }

    func denounceClicked() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let playerDiplomacyAI = self.humanPlayer?.diplomacyAI else {
            fatalError("cant get player diplomacy")
        }

        if playerDiplomacyAI.canDenounce(player: otherPlayer) {
            self.humanPlayer?.diplomacyAI?.doDenounce(player: self.otherPlayer, in: gameModel)
        }

        self.updateActions()
    }

    func declareSurpriseWarClicked() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let playerDiplomacyAI = self.humanPlayer?.diplomacyAI else {
            fatalError("cant get player diplomacy")
        }

        if playerDiplomacyAI.canDeclareWar(to: otherPlayer) {
            self.humanPlayer?.doDeclareWar(to: self.otherPlayer, in: gameModel)
        }

        self.updateActions()
    }

    func makeDealClicked() {

        // change something on the UI !
    }

    func closeDialog() {

        self.delegate?.closeDialog()
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

        let incomingMessageType = self.messageType

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

        if incomingMessageType == self.messageType {
            print("WARNING: diplomatic dialog is in a loop")
        }

        // if message is exit => leave
        if self.messageType == .exit {
            self.delegate?.closeDialog()
        }
    }
}
