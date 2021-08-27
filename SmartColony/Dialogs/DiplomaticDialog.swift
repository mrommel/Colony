//
//  DiplomaticDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 13.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

// TODO move to separate file
/// anchor is center !
class EmbassyTradeItemNode: SpriteButtonNode {

    init() {

        super.init(
            titled: "Embassy",
            enabledButtonImage: "grid9_button_disabled",
            hoverButtonImage: "grid9_button_disabled",
            disabledButtonImage: "grid9_button_disabled",
            size: CGSize(width: 130, height: 35),
            buttonAction: {
                print("click on embassy")
            }
        )

        self.anchorPoint = .lowerCenter
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DiplomaticDialogViewModel {

    private let humanPlayer: AbstractPlayer?
    private let otherPlayer: AbstractPlayer?

    //let state: DiplomaticRequestState
    private var message: DiplomaticRequestMessage
    //let emotion: LeaderEmotionType

    var deal: DiplomaticDeal?

    let gameModel: GameModel?

    weak var presenter: DiplomaticDialogPresenterDelegate?

    //let stateMachine: DiplomaticStateMachine

    init(for humanPlayer: AbstractPlayer?, and otherPlayer: AbstractPlayer?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType, in gameModel: GameModel?) {

        guard let humanPlayer = humanPlayer else {
            fatalError("cant get humanPlayer")
        }

        guard !humanPlayer.isEqual(to: otherPlayer) else {
            fatalError("players are equal")
        }

        self.humanPlayer = humanPlayer
        self.otherPlayer = otherPlayer

        //self.state = state
        self.message = message
        //self.emotion = emotion

        self.gameModel = gameModel
    }

    func updateView() {

        // header
        let playerName = self.otherPlayer?.leader.name() ?? "no name"
        let playerIconTexture = self.otherPlayer?.leader.iconTexture() ?? "questionmark"

        self.presenter?.showLeader(named: playerName, with: playerIconTexture)

        // body
        let replies = self.message.diploOptions()
        let messageText = self.message.diploStringForMessage(for: self.humanPlayer, and: self.otherPlayer)

        self.presenter?.showMessage(text: messageText, with: replies)
    }

    func add(deal: DiplomaticDeal) {

        self.deal = deal

        self.presenter?.show(deal: deal)
    }

    func handle(result: DialogResultType) {

        guard let humanPlayer = self.humanPlayer else {
            fatalError("cant get humanPlayer")
        }

        guard let otherPlayer = self.otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        let options = self.message.diploOptions()

        var selectedReply: DiplomaticReplyMessage = .genericReply
        if result == .responseChoice0 {
            selectedReply = options[0]
        } else if result == .responseChoice1 {
            selectedReply = options[1]
        } else if result == .responseChoice2 {
            selectedReply = options[2]
        } else {
            fatalError("no gonna happen")
        }

        switch self.message {

        case .exit:
            break
        case .messageIntro:
            if selectedReply == .introReplyPositive {
                if !humanPlayer.hasDiscoveredCapital(of: otherPlayer, in: self.gameModel) && !otherPlayer.hasDiscoveredCapital(of: humanPlayer, in: self.gameModel) {
                    self.message = .invitationToCapital
                } else {
                    self.message = .exit
                }
            } else if selectedReply == .introReplyBusy {
                self.message = .exit
            }

        case .invitationToCapital:
            // exchange knowledge about capital
            humanPlayer.discoverCapital(of: otherPlayer, in: self.gameModel)
            otherPlayer.discoverCapital(of: humanPlayer, in: self.gameModel)
            self.message = .exit

        case .peaceOffer:
            fatalError("not yet handled: \(self.message) with \(selectedReply)")

        case .embassyExchange:
            if selectedReply == .dealPositive {
                print("deal positive")
                self.message = .exit
            } else if selectedReply == .dealNegative {
                print("deal negative")
                self.message = .exit
            }

        case .embassyOffer:
            if selectedReply == .dealPositive {
                print("deal positive")
                self.message = .exit
            } else if selectedReply == .dealNegative {
                print("deal negative")
                self.message = .exit
            }

        case .openBordersExchange:
            fatalError("not yet handled: \(self.message) + \(selectedReply)")
        case .openBordersOffer:
            fatalError("not yet handled: \(self.message) + \(selectedReply)")
        case .coopWarRequest:
            fatalError("not yet handled: \(self.message) + \(selectedReply)")
        case .coopWarTime:
            fatalError("not yet handled: \(self.message) + \(selectedReply)")
        }

        self.updateView()

        // if message is exit => leave
        if self.message == .exit {
            self.presenter?.leave()
        }
    }
}

protocol DiplomaticDialogPresenterDelegate: class {

    func showLeader(named leaderName: String, with iconName: String)
    func showMessage(text: String, with replies: [DiplomaticReplyMessage])
    func show(deal: DiplomaticDeal)

    func leave()
}

class DiplomaticDialog: Dialog {

    // MARK: ViewModel

    let viewModel: DiplomaticDialogViewModel

    // MARK: nodes

    var scrollNode: ScrollNode?
    var dealGiveNodes: [SKNode?] = []
    var dealReceiveNodes: [SKNode?] = []
    var possibleGiveNodes: [SKNode?] = []
    var possibleReceiveNodes: [SKNode?] = []

    // MARK: Constructors

    init(viewModel: DiplomaticDialogViewModel) {

        self.viewModel = viewModel

        let uiParser = UIParser()
        guard let diplomaticDialogConfiguration = uiParser.parse(from: "DiplomaticDialog") else {
            fatalError("cant load DiplomaticDialog configuration")
        }

        super.init(from: diplomaticDialogConfiguration)

        // scroll area
        self.scrollNode = ScrollNode(size: CGSize(width: 280, height: 150), contentSize: CGSize(width: 280, height: 200))
        self.scrollNode?.position = CGPoint(x: 0, y: -380)
        self.scrollNode?.zPosition = 199
        self.addChild(self.scrollNode!)

        // connect
        self.viewModel.presenter = self

        // fill items initially
        self.viewModel.updateView()

        self.addResultHandler(handler: { result in

            // one of the buttons has been clicked
            self.viewModel.handle(result: result)
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DiplomaticDialog: DiplomaticDialogPresenterDelegate {

    func showLeader(named leaderName: String, with iconName: String) {

        self.set(text: leaderName, identifier: "player_name")
        self.set(imageNamed: iconName, identifier: "player_image")
    }

    func showMessage(text: String, with replies: [DiplomaticReplyMessage]) {

        self.set(text: text, identifier: "player_message")

        for index in 0..<3 {
            self.item(with: "reponse\(index)")?.isHidden = true
        }

        for (index, option) in replies.enumerated() {

            self.set(text: option.text(), identifier: "reponse\(index)")
            self.item(with: "reponse\(index)")?.isHidden = false
        }
    }

    func show(deal: DiplomaticDeal) {

        // reset lists
        self.dealGiveNodes.removeAll()
        self.dealReceiveNodes.removeAll()
        self.possibleGiveNodes.removeAll()
        self.possibleReceiveNodes.removeAll()

        // add deal items
        for tradeIdem in deal.tradeItems {

            switch tradeIdem.type {

            case .gold:
                // NOOP
                break
            case .goldPerTurn:
                // NOOP
                break
            case .maps:
                // NOOP
                break
            case .resource:
                // NOOP
                break
            case .allowEmbassy:

                let embassyTradeItemNode = EmbassyTradeItemNode()
                embassyTradeItemNode.zPosition = 200

                self.scrollNode?.addScrolling(child: embassyTradeItemNode)

                // keep reference ?
                if tradeIdem.direction == .give {
                    self.dealGiveNodes.append(embassyTradeItemNode)
                } else {
                    self.dealReceiveNodes.append(embassyTradeItemNode)
                }

            case .openBorders:
                // NOOP
                break
            case .peaceTreaty:
                // NOOP
                break
            }
        }

        // add all possible items

        let h1Left = HorizontalLineNode(size: CGSize(width: 100, height: 5))
        h1Left.zPosition = 200
        self.scrollNode?.addScrolling(child: h1Left)

        self.possibleGiveNodes.append(h1Left)

        // gold
        // gold per turn
        // header luxury resources
        // luxury resources
        // header strategic resources
        // strategic resources
        // agreements
        // embassy
        let embassyTradeItemNodeGive = EmbassyTradeItemNode()
        embassyTradeItemNodeGive.zPosition = 200
        self.scrollNode?.addScrolling(child: embassyTradeItemNodeGive)

        self.possibleGiveNodes.append(embassyTradeItemNodeGive)

        // open borders
        // coop wars
        // header cities
        // cities (without capital)

        // add all possible items

        let h1Right = HorizontalLineNode(size: CGSize(width: 100, height: 5))
        h1Right.zPosition = 200
        self.scrollNode?.addScrolling(child: h1Right)

        self.possibleReceiveNodes.append(h1Right)

        // gold
        // gold per turn
        // header luxury resources
        // luxury resources
        // header strategic resources
        // strategic resources
        // agreements
        // embassy
        let embassyTradeItemNodeReceive = EmbassyTradeItemNode()
        embassyTradeItemNodeReceive.zPosition = 200
        self.scrollNode?.addScrolling(child: embassyTradeItemNodeReceive)

        self.possibleReceiveNodes.append(embassyTradeItemNodeReceive)

        // open borders
        // coop wars
        // header cities
        // cities (without capital)

        self.calculateContentSize()
    }

    private func calculateContentSize() {

        var calculatedHeight: CGFloat = 0.0
        let padding: CGFloat = 10.0

        // deal left
        var calculatedDealHeightLeft: CGFloat = -30.0
        for dealGiveNode in self.dealGiveNodes {

            dealGiveNode?.position = CGPoint(x: 70, y: calculatedDealHeightLeft)

            if let nodeWithHeight = dealGiveNode as? SizableNode {
                calculatedDealHeightLeft += nodeWithHeight.height()
            } else {
                fatalError("Node must be of type SizedNode")
            }

            calculatedDealHeightLeft += padding
        }

        // deal right
        var calculatedDealHeightRight: CGFloat = -30.0
        for dealReceiveNode in self.dealReceiveNodes {

            dealReceiveNode?.position = CGPoint(x: -70, y: calculatedDealHeightRight)

            if let nodeWithHeight = dealReceiveNode as? SizableNode {
                calculatedDealHeightRight += nodeWithHeight.height()
            } else {
                fatalError("Node must be of type SizedNode")
            }

            calculatedDealHeightRight += padding
        }

        calculatedHeight += max(calculatedDealHeightLeft, calculatedDealHeightRight)

        // possibilities left
        var calculatedPossibleHeightLeft: CGFloat = 0.0
        for possibleGiveNode in self.possibleGiveNodes {

            possibleGiveNode?.position = CGPoint(x: 70, y: calculatedHeight + calculatedPossibleHeightLeft)

            if let nodeWithHeight = possibleGiveNode as? SizableNode {
                calculatedPossibleHeightLeft += nodeWithHeight.height()
            } else {
                fatalError("Node must be of type SizedNode")
            }

            calculatedPossibleHeightLeft += padding
        }

        // possibilities left
        var calculatedPossibleHeightRight: CGFloat = 0.0
        for possibleReceiveNode in self.possibleReceiveNodes {

            possibleReceiveNode?.position = CGPoint(x: -70, y: calculatedHeight + calculatedPossibleHeightRight)

            if let nodeWithHeight = possibleReceiveNode as? SizableNode {
                calculatedPossibleHeightRight += nodeWithHeight.height()
            } else {
                fatalError("Node must be of type SizedNode")
            }

            calculatedPossibleHeightRight += padding
        }

        calculatedHeight += max(calculatedPossibleHeightLeft, calculatedPossibleHeightRight)
        self.scrollNode?.contentSize.height = max(calculatedHeight, 300)
    }

    func leave() {

        self.handleOkay()
    }
}
