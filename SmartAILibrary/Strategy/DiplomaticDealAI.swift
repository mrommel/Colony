//
//  DiplomaticDealAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 24.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum DiplomaticDealOfferResponse {
    
    case none
    case acceptable
    case unacceptable
    case insulting
}

class DiplomaticDealAI {
    
    var player: AbstractPlayer?
    
    // MARK: constructors

    init(player: AbstractPlayer?) {

        self.player = player
    }
    
    func offer(deal: DiplomaticDeal, with gameModel: GameModel?) -> DiplomaticDealOfferResponse {
        
        var response: DiplomaticDealOfferResponse = .none
        
        let dealValue = deal.value(with: gameModel)
        let dealSum = dealValue.valueImOffering + dealValue.valueOtherOffering
        
        let iAmountOverWeWillRequest = dealSum * 10 / 100
        let iAmountUnderWeWillOffer = dealSum * -10 / 100
        
        var isDealAcceptable = false
        // If we've gotten the deal to a point where we're happy, offer it up
        if iAmountUnderWeWillOffer <= dealValue.value && dealValue.value <= iAmountOverWeWillRequest  {
            isDealAcceptable = true
        }

        // If they're actually giving us more than we're asking for (e.g. a gift) then accept the deal
        if !isDealAcceptable {
            
            if dealValue.valueOtherOffering > dealValue.valueImOffering {
                isDealAcceptable = true
            }
        }
        
        if isDealAcceptable {

            guard let fromPlayer = gameModel?.player(for: deal.from) else {
                fatalError("cant get player")
            }
            
            // If it's from a human, send it through the network
            if fromPlayer.isHuman() {
                
                // FIXME ???
            } else {
                response = .acceptable
            }
        } else if dealSum > -75 && dealValue.valueImOffering < (dealValue.valueOtherOffering * 5) { // We want more from this Deal
            
            response = .unacceptable
            
        } else { // Pretty bad deal for us
            
            response = .insulting
        }
        
        return response
    }
}
