//
//  DiplomaticDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

public enum IntelReportType: Int, Identifiable {

    case overview = 0
    case gossip = 1
    case accessLevel = 2
    case government = 3
    case agendas = 4
    case ownRelationship = 5
    case otherRelationships = 6

    public var id: Self { self }

    public static var tabs: [IntelReportType] = [

        .overview,
        .gossip,
        .accessLevel,
        .ownRelationship
    ]

    public static var icons: [IntelReportType] = [

        .gossip,
        .accessLevel,
        .government,
        .agendas,
        .ownRelationship,
        .otherRelationships
    ]
}

extension IntelReportType {

    public func title() -> String {

        switch self {

        case .overview: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_OVERVIEW"
        case .gossip: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_GOSSIP"
        case .accessLevel: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_ACCESS_LEVEL"
        case .government: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_GOVERNMENT"
        case .agendas: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_AGENDAS"
        case .ownRelationship: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_RELATIONSHIP"
        case .otherRelationships: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_OTHER_RELATIONSHIPS"
        }
    }

    public func buttonTexture() -> String {

        switch self {

        case .overview: return "intelReportType-button-overview"
        case .gossip: return "intelReportType-button-gossip"
        case .accessLevel: return "intelReportType-button-accessLevel"
        case .government: return ""
        case .agendas: return ""
        case .ownRelationship: return "intelReportType-button-ownRelationship"
        case .otherRelationships: return ""
        }
    }

    public func iconTexture() -> String {

        switch self {

        case .overview: return ""
        case .gossip: return "intelReportType-gossip"
        case .accessLevel: return "intelReportType-accessLevel"
        case .government: return "intelReportType-government"
        case .agendas: return "intelReportType-agendas"
        case .ownRelationship: return "intelReportType-ownRelationship"
        case .otherRelationships: return "intelReportType-otherRelationships"
        }
    }
}

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

    // reports
    @Published
    var intelReportType: IntelReportType = .overview

    @Published
    var discussionIntelReportTitle: String
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

        self.humanPlayer = humanPlayer
        self.otherPlayer = otherPlayer

        self.state = state
        self.messageType = message
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

        return player.leader.name()
    }

    func civilizationName() -> String {

        guard let player = self.otherPlayer else {
            return "None"
        }

        return player.leader.civilization().name().localized()
    }

    func select(report: IntelReportType) {

        self.intelReportType = report
        self.discussionIntelReportTitle = "TXT_KEY_DIPLOMACY_INTEL_REPORT_TITLE".localized() + self.intelReportType.title().localized()
    }

    func overview(for report: IntelReportType) -> String {

        switch report {

        case .overview:
            return "-"
        case .gossip:
            return "- No New Items"
        case .accessLevel:
            return "  None"
        case .government:
            return "- Chiefdom"
        case .agendas:
            return "-"
        case .ownRelationship:
            return "-"
        case .otherRelationships:
            return "-"
        }
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
