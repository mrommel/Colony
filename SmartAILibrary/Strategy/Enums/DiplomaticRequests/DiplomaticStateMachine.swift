//
//  DiplomaticStateMachine.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 09.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

/*import Foundation

public class DiplomaticStateMachine: FiniteStateMachine<DiplomaticRequestMessage> {
    
    var activeReply: DiplomaticReplyMessage = .genericReply
    
    public init(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, with initial: DiplomaticRequestMessage, in gameModel: GameModel?) {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let fromPlayer = fromPlayer else {
            fatalError("cant get from player")
        }
        
        guard let toPlayer = toPlayer else {
            fatalError("cant get to player")
        }
        
        super.init(initialState: FiniteState(identifier: DiplomaticRequestMessage.exit))
        
        // states
        let stateGreeting = FiniteState(identifier: DiplomaticRequestMessage.messageIntro)
        let stateInvitationToCapital = FiniteState(identifier: DiplomaticRequestMessage.invitationToCapital)
        
        let stateLeave = FiniteState(identifier: DiplomaticRequestMessage.exit)
        
        // transitions
        if !fromPlayer.hasDiscoveredCapital(of: toPlayer, in: gameModel) && !toPlayer.hasDiscoveredCapital(of: fromPlayer, in: gameModel) {
        
            stateGreeting.add(transition: FiniteStateTransition(state: stateInvitationToCapital, trigger: { return self.activeReply == .introReplyPositive }))
        } else {
            stateGreeting.add(transition: FiniteStateTransition(state: stateLeave, trigger: { return self.activeReply == .introReplyPositive }))
        }
        stateGreeting.add(transition: FiniteStateTransition(state: stateLeave, trigger: { return self.activeReply == .introReplyBusy }))
        
        stateInvitationToCapital.add(transition: FiniteStateTransition(state: stateLeave, trigger: { return self.activeReply == .invitationToCapitalPositive }))
        stateInvitationToCapital.add(transition: FiniteStateTransition(state: stateLeave, trigger: { return self.activeReply == .invitationToCapitalNegative }))
        
        switch initial {

        case .messageIntro:
            self.current = stateGreeting
        default:
            fatalError("not handled: \(initial)")
        }
    }
    
    public func handle(reply: DiplomaticReplyMessage) {
        
        self.activeReply = reply
        self.update()
    }
}*/
