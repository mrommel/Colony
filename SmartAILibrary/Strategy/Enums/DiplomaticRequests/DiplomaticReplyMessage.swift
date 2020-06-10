//
//  DiplomaticReplyMessage.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 09.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum DiplomaticReplyMessage {
    
    case genericReply
    
    // replies to messageIntro
    case introReplyPositive
    case introReplyBusy
    
    case invitationToCapitalPositive
    case invitationToCapitalNegative
    
    case exit
    
    public func text() -> String {
        
        switch self {
            
        case .genericReply:
            return "generic"
            
            // replies to messageIntro
        case .introReplyPositive:
            return "It is an honor to meet you."
        case .introReplyBusy:
            return "Well met stranger, but I'm afraid we are too busy to stay and chat."
            
            // replies to invitationToCapital
        case .invitationToCapitalPositive:
            return "Exchanging information on our capitals is a great idea. It should help promote trade."
        case .invitationToCapitalNegative:
            return "Sorry, we can't give away that information right now."
            
        case .exit:
            return "exit"
        }
    }
}
