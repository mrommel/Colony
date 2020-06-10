//
//  DiplomaticDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 13.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

class DiplomaticDialogViewModel {

    private let humanPlayer: AbstractPlayer?
    private let otherPlayer: AbstractPlayer?

    //let state: DiplomaticRequestState
    private var message: DiplomaticRequestMessage
    //let emotion: LeaderEmotionType

    // values
    //let playerTexture: String
    //let playerName: String

    //var messageText: String
    //var options: [DiplomaticReplyMessage]
    
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

        //
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
            selectedReply = options[0]
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
            //exchange knowledge about capital
            humanPlayer.discoverCapital(of: otherPlayer, in: self.gameModel)
            otherPlayer.discoverCapital(of: humanPlayer, in: self.gameModel)
            self.message = .exit
        case .peaceOffer:
            fatalError("not yet handled: \(self.message) with \(selectedReply)")
        case .embassyExchange:
            fatalError("not yet handled: \(self.message) + \(selectedReply)")
        case .embassyOffer:
            fatalError("not yet handled: \(self.message) + \(selectedReply)")
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
    
    func leave()
}

class DiplomaticDialog: Dialog {

    // MARK: ViewModel

    let viewModel: DiplomaticDialogViewModel

    // MARK: Constructors

    init(viewModel: DiplomaticDialogViewModel) {

        self.viewModel = viewModel
        
        let uiParser = UIParser()
        guard let diplomaticDialogConfiguration = uiParser.parse(from: "DiplomaticDialog") else {
            fatalError("cant load DiplomaticDialog configuration")
        }

        super.init(from: diplomaticDialogConfiguration)

        // connect
        self.viewModel.presenter = self
        
        // fill items
        self.viewModel.updateView()

        self.addResultHandler(handler: { result in

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
    
    func leave() {
        
        self.handleOkay()
    }
}
