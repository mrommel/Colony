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

public class DiplomaticDealAI: Codable {
    
    var player: AbstractPlayer?
    
    // not serialized
    private var cachedValueOfPeaceWithHumanValue: Int
    
    // MARK: constructors

    init(player: AbstractPlayer?) {

        self.player = player
        
        self.cachedValueOfPeaceWithHumanValue = 0
    }
    
    public required init(from decoder: Decoder) throws {
    
        self.player = nil
        self.cachedValueOfPeaceWithHumanValue = 0
    }
    
    public func encode(to encoder: Encoder) throws {
    
        // NOOP
    }
    
    func offer(deal: DiplomaticDeal, with gameModel: GameModel?) -> DiplomaticDealOfferResponse {
        
        var response: DiplomaticDealOfferResponse = .none
        
        let dealValue = deal.value(useEvenValue: true, in: gameModel)
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
    
    /// A good time to make an offer to get Open Borders?
    func shouldMakeOfferForOpenBorders(to otherPlayer: AbstractPlayer?, deal: inout DiplomaticDeal, in gameModel: GameModel?) -> Bool {
        
        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        // Don't ask for Open Borders, if we're hostile or planning war
        let approach = diplomacyAI.approach(towards: otherPlayer)
        if approach == .hostile || approach == .war {
            return false
        }

        // Can we actually complete this deal?
        if !deal.isPossibleToTradeItem(from: otherPlayer, to: self.player, item: .openBorders, in: gameModel) {
            return false
        }

        // Do we actually want OB with eOtherPlayer?
        if diplomacyAI.isWantsOpenBorders(with: otherPlayer) {
            
            // Seed the deal with the item we want
            deal.addOpenBorders(with: otherPlayer, duration: 30 /* Standard DealDuration */)

            var dealAcceptable = false

            // AI evaluation
            if !otherPlayer.isHuman() {
                // Change the deal as necessary to make it work
                dealAcceptable = self.doEqualizeDealWithAI(deal: deal, with: otherPlayer, in: gameModel)
            } else {
                // Change the deal as necessary to make it work
                var uselessReferenceVariable: Bool = false
                var cantMatchOffer: Bool = false
                dealAcceptable = self.doEqualizeDealWithHuman(deal: &deal, with: otherPlayer, dontChangeMyExistingItems: false, dontChangeTheirExistingItems: true, dealGoodToBeginWith: &uselessReferenceVariable, cantMatchOffer: &cantMatchOffer, in: gameModel)
            }

            return dealAcceptable
        }

        return false
    }
    
    // Try to even out the value on both sides.  If bFavorMe is true we'll bias things in our favor if necessary
    private func doEqualizeDealWithAI(deal: DiplomaticDeal, with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Bool {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }
        
        guard let otherDiplomacyDealAI = otherPlayer.diplomacyDealAI else {
            fatalError("cant get otherDiplomacyDealAI")
        }

        var (totalValue, evenValueImOffering, evenValueTheyreOffering) = deal.value(useEvenValue: true, in: gameModel)

        let dealDuration = 30 // from game speed

        var makeOffer = false

        /////////////////////////////
        // Outline the boundaries for an acceptable deal
        /////////////////////////////

        let percentOverWeWillRequest = self.dealPercentLeewayWithAI()
        let percentUnderWeWillOffer = -self.dealPercentLeewayWithAI()

        let dealSumValue = evenValueImOffering + evenValueTheyreOffering

        var amountOverWeWillRequest = dealSumValue
        amountOverWeWillRequest *= percentOverWeWillRequest
        amountOverWeWillRequest /= 100;

        var amountUnderWeWillOffer = dealSumValue
        amountUnderWeWillOffer *= percentUnderWeWillOffer
        amountUnderWeWillOffer /= 100;

        // Deal is already even enough for us
        if totalValue <= amountOverWeWillRequest && totalValue >= amountUnderWeWillOffer {
            makeOffer = true
        }

        guard var counterDeal: DiplomaticDeal = deal.copy() else {
            fatalError("cant get a copy of deal")
        }

        if !makeOffer {
            
            /////////////////////////////
            // See if there are items we can add or remove from either side to balance out the deal if it's not already even
            /////////////////////////////

            var useEvenValue = true

            // TODO: add more methods
            /*self.doAddVoteCommitmentToThem(for: counterDeal, by: otherPlayer, dontChangeTheirExistingItems: false, totalValue, evenValueImOffering, evenValueTheyreOffering, amountOverWeWillRequest, useEvenValue: useEvenValue)
            self.doAddVoteCommitmentToUs(pCounterDeal, by: otherPlayer, dontChangeMyExistingItems: false, totalValue, evenValueImOffering, evenValueTheyreOffering, amountUnderWeWillOffer, useEvenValue: useEvenValue)*/

            self.doAddResourceToThem(for: counterDeal, by: otherPlayer, dontChangeTheirExistingItems: false, totalValue: &totalValue, valueImOffering: &evenValueImOffering, valueTheyreOffering: &evenValueTheyreOffering, amountOverWeWillRequest: amountOverWeWillRequest, dealDuration: dealDuration, useEvenValue: useEvenValue, in: gameModel)
            self.doAddResourceToUs(for: counterDeal, by: otherPlayer, dontChangeTheirExistingItems: false, totalValue: &totalValue, valueImOffering: &evenValueImOffering, valueTheyreOffering: &evenValueTheyreOffering, amountUnderWeWillOffer: amountUnderWeWillOffer, dealDuration: dealDuration, useEvenValue: useEvenValue, in: gameModel)

            /*DoAddOpenBordersToThem(pCounterDeal, eOtherPlayer, /*bDontChangeTheirExistingItems*/ true, iTotalValue, iEvenValueImOffering, iEvenValueTheyreOffering, iAmountOverWeWillRequest, iDealDuration, bUseEvenValue);
            DoAddOpenBordersToUs(pCounterDeal, eOtherPlayer, /*bDontChangeMyExistingItems*/ true, iTotalValue, iEvenValueImOffering, iEvenValueTheyreOffering, iAmountUnderWeWillOffer, iDealDuration, bUseEvenValue);

            DoAddGPTToThem(pCounterDeal, eOtherPlayer, /*bDontChangeTheirExistingItems*/ false, iTotalValue, iEvenValueImOffering, iEvenValueTheyreOffering, iDealDuration, bUseEvenValue);
            DoAddGPTToUs(pCounterDeal, eOtherPlayer, /*bDontChangeMyExistingItems*/ false, iTotalValue, iEvenValueImOffering, iEvenValueTheyreOffering, iDealDuration, bUseEvenValue);

            DoAddGoldToThem(pCounterDeal, eOtherPlayer, /*bDontChangeTheirExistingItems*/ false, iTotalValue, iEvenValueImOffering, iEvenValueTheyreOffering, bUseEvenValue);
            DoAddGoldToUs(pCounterDeal, eOtherPlayer, /*bDontChangeMyExistingItems*/ false, iTotalValue, iEvenValueImOffering, iEvenValueTheyreOffering, bUseEvenValue);

            DoRemoveGPTFromThem(pCounterDeal, eOtherPlayer, iTotalValue, iEvenValueImOffering, iEvenValueTheyreOffering, iDealDuration, bUseEvenValue);
            DoRemoveGPTFromUs(pCounterDeal, eOtherPlayer, iTotalValue, iEvenValueImOffering, iEvenValueTheyreOffering, iDealDuration, bUseEvenValue);

            DoRemoveGoldFromUs(pCounterDeal, eOtherPlayer, iTotalValue, iEvenValueImOffering, iEvenValueTheyreOffering, bUseEvenValue);
            DoRemoveGoldFromThem(pCounterDeal, eOtherPlayer, iTotalValue, iEvenValueImOffering, iEvenValueTheyreOffering, bUseEvenValue);
            */
            
            // Make sure we haven't removed everything from the deal!
            if counterDeal.tradeItems.count > 0  {

                let (_, valueIThinkImOffering, valueIThinkImGetting) = counterDeal.value(useEvenValue: true, in: gameModel)

                // We don't think we're getting enough for what's on our side of the table
                let lowEndOfWhatIWillAccept = valueIThinkImOffering - (valueIThinkImOffering * -percentUnderWeWillOffer / 100)
                if valueIThinkImGetting < lowEndOfWhatIWillAccept {
                    return false
                }

                // GET_PLAYER(eOtherPlayer).GetDealAI()->GetDealValue(pDeal, iValueTheyThinkTheyreOffering, iValueTheyThinkTheyreGetting, /*bUseEvenValue*/ false)
                let (_, valueTheyThinkTheyreOffering, valueTheyThinkTheyreGetting) = counterDeal.value(useEvenValue: false, in: gameModel)

                // They don't think they're getting enough for what's on their side of the table
                let lowEndOfWhatTheyWillAccept = valueTheyThinkTheyreOffering - (valueTheyThinkTheyreOffering * otherDiplomacyDealAI.dealPercentLeewayWithAI() / 100)
                if valueTheyThinkTheyreGetting < lowEndOfWhatTheyWillAccept {
                    return false
                }

                makeOffer = true
            }
        }

        return makeOffer
    }
    
    /// Try to even out the value on both sides.  If bFavorMe is true we'll bias things in our favor if necessary
    private func doEqualizeDealWithHuman(deal: inout DiplomaticDeal, with otherPlayer: AbstractPlayer?, dontChangeMyExistingItems: Bool, dontChangeTheirExistingItems: Bool, dealGoodToBeginWith: inout Bool, cantMatchOffer: inout Bool, in gameModel: GameModel?) -> Bool {
    
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }
        
        guard let otherDiplomacyDealAI = otherPlayer.diplomacyDealAI else {
            fatalError("cant get otherDiplomacyDealAI")
        }
        
        guard let activePlayer = gameModel?.activePlayer() else {
            fatalError("cant get activePlayer")
        }
        
        let dealDuration = 30
        var cantMatchOffer = false
        var makeOffer: Bool = false

        // Is this a peace deal?
        if deal.isPeaceTreatyTrade(with: otherPlayer) {
            deal.clearItems()
            makeOffer = self.isOfferPeace(with: otherPlayer, deal: &deal, equalizingDeals: true, in: gameModel)
        } else {
            var totalValueToMe: Int = 0
            var valueImOffering: Int = 0
            var valueTheyreOffering: Int = 0
            var amountOverWeWillRequest: Int = 0
            var amountUnderWeWillOffer: Int = 0
            makeOffer = self.isDealWithHumanAcceptable(deal: &deal, with: activePlayer, totalValueToMe: &totalValueToMe, valueImOffering: &valueImOffering, valueTheyreOffering: &valueTheyreOffering, amountOverWeWillRequest: &amountOverWeWillRequest, amountUnderWeWillOffer: &amountUnderWeWillOffer, cantMatchOffer: &cantMatchOffer, in: gameModel)

            if totalValueToMe < 0 && dontChangeTheirExistingItems {
                return false
            }

            if makeOffer {
                dealGoodToBeginWith = true
            } else {
                dealGoodToBeginWith = false
            }

            if !makeOffer {
                /////////////////////////////
                // See if there are items we can add or remove from either side to balance out the deal if it's not already even
                /////////////////////////////

                var useEvenValue = false

                // Maybe reorder these based on the AI's priorities (e.g. if it really doesn't want to give up Strategic Resources try adding those from us last)

                //DoAddCitiesToThem(pDeal, eOtherPlayer, bDontChangeTheirExistingItems, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, iAmountOverWeWillRequest, iDealDuration, bUseEvenValue);

                // TODO: add more methods
                /*DoAddVoteCommitmentToThem(pDeal, eOtherPlayer, bDontChangeTheirExistingItems, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, iAmountOverWeWillRequest, bUseEvenValue);
                DoAddVoteCommitmentToUs(pDeal, eOtherPlayer, bDontChangeMyExistingItems, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, iAmountUnderWeWillOffer, bUseEvenValue);

                DoAddEmbassyToThem(pDeal, eOtherPlayer, bDontChangeTheirExistingItems, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, iAmountOverWeWillRequest, bUseEvenValue);
                DoAddEmbassyToUs(pDeal, eOtherPlayer, bDontChangeMyExistingItems, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, iAmountUnderWeWillOffer, bUseEvenValue);*/

                self.doAddResourceToThem(for: deal, by: otherPlayer, dontChangeTheirExistingItems: dontChangeTheirExistingItems, totalValue: &totalValueToMe, valueImOffering: &valueImOffering, valueTheyreOffering: &valueTheyreOffering, amountOverWeWillRequest: amountOverWeWillRequest, dealDuration: dealDuration, useEvenValue: useEvenValue, in: gameModel)
                self.doAddResourceToUs(for: deal, by: otherPlayer, dontChangeTheirExistingItems: dontChangeMyExistingItems, totalValue: &totalValueToMe, valueImOffering: &valueImOffering, valueTheyreOffering: &valueTheyreOffering, amountUnderWeWillOffer: amountUnderWeWillOffer, dealDuration: dealDuration, useEvenValue: useEvenValue, in: gameModel)

                /*DoAddOpenBordersToThem(pDeal, eOtherPlayer, bDontChangeTheirExistingItems, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, iAmountOverWeWillRequest, iDealDuration, bUseEvenValue);
                DoAddOpenBordersToUs(pDeal, eOtherPlayer, bDontChangeMyExistingItems, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, iAmountUnderWeWillOffer, iDealDuration, bUseEvenValue);

                DoAddGPTToThem(pDeal, eOtherPlayer, bDontChangeTheirExistingItems, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, iDealDuration, bUseEvenValue);
                DoAddGPTToUs(pDeal, eOtherPlayer, bDontChangeMyExistingItems, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, iDealDuration, bUseEvenValue);

                DoAddGoldToThem(pDeal, eOtherPlayer, bDontChangeTheirExistingItems, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, bUseEvenValue);
                DoAddGoldToUs(pDeal, eOtherPlayer, bDontChangeMyExistingItems, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, bUseEvenValue);

                if !dontChangeTheirExistingItems {
                    DoRemoveGPTFromThem(pDeal, eOtherPlayer, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, iDealDuration, bUseEvenValue);
                }
                
                if !dontChangeMyExistingItems {
                    DoRemoveGPTFromUs(pDeal, eOtherPlayer, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, iDealDuration, bUseEvenValue);
                }

                DoRemoveGoldFromUs(pDeal, eOtherPlayer, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, bUseEvenValue);
                DoRemoveGoldFromThem(pDeal, eOtherPlayer, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, bUseEvenValue);

                DoAddCitiesToUs(pDeal, eOtherPlayer, bDontChangeMyExistingItems, iTotalValueToMe, iValueImOffering, iValueTheyreOffering, iAmountUnderWeWillOffer, bUseEvenValue);*/

                // Make sure we haven't removed everything from the deal!
                if deal.tradeItems.count > 0 {
                    makeOffer = self.isDealWithHumanAcceptable(deal: &deal, with: activePlayer, totalValueToMe: &totalValueToMe, valueImOffering: &valueImOffering, valueTheyreOffering: &valueTheyreOffering, amountOverWeWillRequest: &amountOverWeWillRequest, amountUnderWeWillOffer: &amountUnderWeWillOffer, cantMatchOffer: &cantMatchOffer, in: gameModel)
                }
            }
        }

        return makeOffer
    }
    
    /// Offer peace
    func isOfferPeace(with otherPlayer: AbstractPlayer?, deal: inout DiplomaticDeal, equalizingDeals: Bool, in gameModel: GameModel?) -> Bool {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }
        
        guard let otherDiplomacyAI = otherPlayer.diplomacyAI else {
            fatalError("cant get otherDiplomacyAI")
        }
        
        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        var result = false

        // Can we actually complete this deal?
        if !deal.isPossibleToTradeItem(from: self.player, to: otherPlayer, item: .peaceTreaty, in: gameModel) {
            return false
        }
        
        if !deal.isPossibleToTradeItem(from: otherPlayer, to: self.player, item: .peaceTreaty, in: gameModel) {
            return false
        }

        var peaceTreatyImWillingToOffer = diplomacyAI.treatyWillingToOffer(with: otherPlayer)
        let peaceTreatyImWillingToAccept = diplomacyAI.treatyWillingToAccept(with: otherPlayer)

        // Peace between AI players
        if !otherPlayer.isHuman() {
            
            let peaceTreatyTheyreWillingToAccept = otherDiplomacyAI.treatyWillingToAccept(with: self.player)
            var peaceTreatyTheyreWillingToOffer = otherDiplomacyAI.treatyWillingToOffer(with: self.player)

            // Is what we're willing to offer acceptable to eOtherPlayer?
            if peaceTreatyImWillingToOffer < peaceTreatyTheyreWillingToAccept {
                return false
            }
            
            // Is what eOtherPalyer is willing to offer acceptable to us?
            if peaceTreatyTheyreWillingToOffer < peaceTreatyImWillingToAccept {
                return false
            }

            // If we're both willing to give something up (for whatever reason) reduce the surrender level of both parties until White Peace is on one side
            if peaceTreatyImWillingToOffer > .whitePeace && peaceTreatyTheyreWillingToOffer > .whitePeace {
                
                let amountToReduce: Int = min(peaceTreatyImWillingToOffer.rawValue, peaceTreatyTheyreWillingToOffer.rawValue)

                peaceTreatyImWillingToOffer = peaceTreatyImWillingToOffer.decreased(by: amountToReduce)
                peaceTreatyTheyreWillingToOffer = peaceTreatyTheyreWillingToOffer.decreased(by: amountToReduce)
            }

            // Get the Peace in between if there's a gap
            if peaceTreatyImWillingToOffer > peaceTreatyTheyreWillingToAccept {
                peaceTreatyImWillingToOffer = PeaceTreatyType(rawValue: (peaceTreatyImWillingToOffer.rawValue + peaceTreatyTheyreWillingToAccept.rawValue) / 2)!
            }
            
            if peaceTreatyTheyreWillingToOffer > peaceTreatyImWillingToAccept {
                peaceTreatyTheyreWillingToOffer = PeaceTreatyType(rawValue: (peaceTreatyTheyreWillingToOffer.rawValue + peaceTreatyImWillingToAccept.rawValue) / 2)!
            }

            // I'm surrendering in this deal
            if peaceTreatyImWillingToOffer > peaceTreatyTheyreWillingToOffer {
                deal.surrendering = player.leader
                deal.updatePeaceTreatyType(to: peaceTreatyImWillingToOffer)

                self.doAddItemsToDealForPeaceTreaty(with: otherPlayer, deal: &deal, treaty: peaceTreatyImWillingToOffer, meSurrendering: true, in: gameModel)
            }
            // They're surrendering in this deal
            else if peaceTreatyImWillingToOffer < peaceTreatyTheyreWillingToOffer {
                deal.surrendering = otherPlayer.leader
                deal.updatePeaceTreatyType(to: peaceTreatyTheyreWillingToOffer)

                self.doAddItemsToDealForPeaceTreaty(with: otherPlayer, deal: &deal, treaty: peaceTreatyTheyreWillingToOffer, meSurrendering: false, in: gameModel)
            }

            // Add the peace items to the deal so that we actually stop the war
            let peaceTreatyDuration = 30
            deal.addPeaceTreaty(with: self.player, duration: peaceTreatyDuration, in: gameModel)
            deal.addPeaceTreaty(with: otherPlayer, duration: peaceTreatyDuration, in: gameModel)

            result = true
        } else {
            // Peace with a human
            
            if peaceTreatyImWillingToOffer > .whitePeace {
                
                // AI is surrendering
                deal.surrendering = player.leader
                deal.updatePeaceTreatyType(to: peaceTreatyImWillingToOffer)

                self.doAddItemsToDealForPeaceTreaty(with: otherPlayer, deal: &deal, treaty: peaceTreatyImWillingToOffer, meSurrendering: true, in: gameModel)

                // Store the value of the deal with the human so that we have a number to use for renegotiation (if necessary)
                let (_, valueImOffering, valueTheyreOffering) = deal.value(useEvenValue: false, in: gameModel)
                
                if !equalizingDeals {
                    self.updateCachedValueOfPeaceWithHuman(to: -valueImOffering)
                }
            } else if peaceTreatyImWillingToAccept > .whitePeace {
                
                // AI is asking human to surrender
                deal.surrendering = otherPlayer.leader
                deal.updatePeaceTreatyType(to: peaceTreatyImWillingToAccept)

                self.doAddItemsToDealForPeaceTreaty(with: otherPlayer, deal: &deal, treaty: peaceTreatyImWillingToAccept, meSurrendering: false, in: gameModel)

                // Store the value of the deal with the human so that we have a number to use for renegotiation (if necessary)
                let (_, valueImOffering, valueTheyreOffering) = deal.value(useEvenValue: false, in: gameModel)
                
                if !equalizingDeals {
                    self.updateCachedValueOfPeaceWithHuman(to: valueTheyreOffering)
                }
            } else {
                // if the case is that we both want white peace, don't forget to add the city-states into the peace deal.
                self.doAddPlayersAlliesToTreaty(with: otherPlayer, deal: deal)
            }

            let peaceTreatyDuration = 30
            deal.addPeaceTreaty(with: self.player, duration: peaceTreatyDuration, in: gameModel)
            deal.addPeaceTreaty(with: otherPlayer, duration: peaceTreatyDuration, in: gameModel)

            result = true
        }

        return result
    }
    
    /// Add appropriate items to pDeal based on what type of PeaceTreaty eTreaty is
    func doAddItemsToDealForPeaceTreaty(with otherPlayer: AbstractPlayer?, deal: inout DiplomaticDeal, treaty: PeaceTreatyType, meSurrendering: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var percentGoldToGive = 0
        var percentGPTToGive = 0
        var giveOpenBorders = false;
        var giveOnlyOneCity = false;
        var percentCitiesGiveUp = 0; /* 100 = all but capital */
        var giveUpStratResources = false;
        var giveUpLuxuryResources = false;

        // Setup what needs to be given up based on the level of the treaty
        switch treaty {
            
        case .whitePeace:
            // White Peace: nothing changes hands
            break

        case .armistice:
            percentGoldToGive = 50
            percentGPTToGive = 50

        case .settlement:
            percentGoldToGive = 100
            percentGPTToGive = 100

        case .backDown:
            percentGoldToGive = 100;
            percentGPTToGive = 100;
            giveOpenBorders = true
            giveUpStratResources = true

        case .submission:
            percentGoldToGive = 100
            percentGPTToGive = 100
            giveOpenBorders = true
            giveUpStratResources = true
            giveUpLuxuryResources = true

        case .surrender:
            giveOnlyOneCity = true

        case .cession:
            percentCitiesGiveUp = 25
            percentGoldToGive = 50

        case .capitulation:
            percentCitiesGiveUp = 33
            percentGoldToGive = 100

        case .unconditionalSurrender:
            percentCitiesGiveUp = 100
            percentGoldToGive = 100
            
        case .none:
            // NOOP
            break
        }

        let duration = 30

        guard let losingPlayer = meSurrendering ? self.player : otherPlayer else {
            fatalError("cant get loosing player")
        }
        
        guard let winningPlayer = meSurrendering ? otherPlayer : self.player else {
            fatalError("cant get winningPlayer player")
        }

        self.doAddPlayersAlliesToTreaty(with: otherPlayer, deal: deal)

        // Gold
        var gold = 0
        if percentGoldToGive > 0 {
            
            gold = deal.goldAvailable(of: losingPlayer, for: .gold, in: gameModel)
            if gold > 0 {
                gold = gold * percentGoldToGive / 100

                if deal.isPossibleToTradeItem(from: losingPlayer, to: winningPlayer, item: .gold, value: gold, in: gameModel) {
                    deal.addGoldTrade(from: losingPlayer, amount: gold, in: gameModel)
                }
            }
        }

        // Gold per turn
        var gpt = 0
        if percentGPTToGive > 0 {
            
            gpt = Int(min(losingPlayer.calculateGoldPerTurn(in: gameModel), winningPlayer.calculateGoldPerTurn(in: gameModel) / 3 /*ARMISTICE_GPT_DIVISOR*/))
            if gpt > 0 {
                gpt = gpt * percentGPTToGive / 100

                if gpt > 0 && deal.isPossibleToTradeItem(from: losingPlayer, to: winningPlayer, item: .goldPerTurn, value: gpt, duration: duration, in: gameModel) {
                    deal.addGoldPerTurnTrade(from: losingPlayer, amount: gpt, duration: duration, in: gameModel)
                }
            }
        }

        // Open Borders
        if giveOpenBorders {
            
            if deal.isPossibleToTradeItem(from: losingPlayer, to: winningPlayer, item: .openBorders, in: gameModel) {
                deal.addOpenBorders(with: losingPlayer, duration: duration)
            }
        }

        // Resources
        for resource in ResourceType.all {

            let usage = resource.usage()

            // Can't trade bonus Resources
            if usage == .bonus {
                continue
            }

            var resourceQuantity = losingPlayer.numAvailable(resource: resource)

            // Don't bother looking at this Resource if the other player doesn't even have any of it
            if resourceQuantity == 0 {
                continue
            }

            // Match with deal type
            if usage == .luxury && !giveUpLuxuryResources {
                continue
            }

            if usage == .strategic && !giveUpStratResources {
                continue
            }

            // Can only get 1 copy of a Luxury
            if usage == .luxury {
                resourceQuantity = 1
            }

            if deal.isPossibleToTradeItem(from: losingPlayer, to: winningPlayer, item: .resource, value: resourceQuantity, resource: resource, in: gameModel) {
                
                deal.addResourceTrade(from: losingPlayer, resource: resource, amount: resourceQuantity, duration: duration, in: gameModel)
            }
        }

        //    Give up all but capital?
        /*if percentCitiesGiveUp == 100 {
            
            // All Cities but the capital
            for cityRef in gameModel.cities(of: losingPlayer) {
                
                guard let city = cityRef else {
                    continue
                }
                
                if city.isCapital() {
                    continue;
                }

                if deal->IsPossibleToTradeItem(eLosingPlayer, eWinningPlayer, TRADE_ITEM_CITIES, pLoopCity->getX(), pLoopCity->getY()))
                {
                    pDeal->AddCityTrade(eLosingPlayer, pLoopCity->GetID());
                }
            }
        }*/

        // If the player only has 1 City then we can't get any more from him
        /*else if (iPercentCitiesGiveUp > 0 || bGiveOnlyOneCity && pLosingPlayer->getNumCities() > 1)
        {
            int iCityValue = 0;
            int iCityDistanceFromWinnersCapital = 0;
            int iWinnerCapitalX = -1, iWinnerCapitalY = -1;

            // If winner has no capital then we can't use proximity - it will stay at 0
            CvCity* pWinnerCapital = pWinningPlayer->getCapitalCity();
            if(pWinnerCapital != NULL)
            {
                iWinnerCapitalX = pWinnerCapital->getX();
                iWinnerCapitalY = pWinnerCapital->getY();
            }

            // Create vector of the losing players' Cities so we can see which are the closest to the winner
            CvWeightedVector<int> viCityProximities;

            // Loop through all of the loser's Cities
            for(pLoopCity = pLosingPlayer->firstCity(&iCityLoop); pLoopCity != NULL; pLoopCity = pLosingPlayer->nextCity(&iCityLoop))
            {
                // Get total city value of the loser
                iCityValue += GetCityValue(pLoopCity->getX(), pLoopCity->getY(), bMeSurrendering, eOtherPlayer, /*bUseEvenValue*/ true);

                // If winner has no capital, Distance defaults to 0
                if(pWinnerCapital != NULL)
                {
                    iCityDistanceFromWinnersCapital = plotDistance(iWinnerCapitalX, iWinnerCapitalY, pLoopCity->getX(), pLoopCity->getY());
                }

                // Divide the distance by three if the city was originally owned by the winning player to make these cities more likely
                if (pLoopCity->getOriginalOwner() == eWinningPlayer)
                {
                    iCityDistanceFromWinnersCapital /= 3;
                }

                // Don't include the capital in the list of Cities the winner can receive
                if(!pLoopCity->isCapital())
                {
                    viCityProximities.push_back(pLoopCity->GetID(), iCityDistanceFromWinnersCapital);
                }
            }

            // Sort the vector based on distance from winner's capital
            viCityProximities.SortItems();
            int iSortedCityID;

            // Just one city?
            if (bGiveOnlyOneCity)
            {
                iSortedCityID = viCityProximities.GetElement(viCityProximities.size() - 1);
                pDeal->AddCityTrade(eLosingPlayer, iSortedCityID);
            }

            else
            {
                // Determine the value of Cities to be given up
                int iCityValueToSurrender = iCityValue * iPercentCitiesGiveUp / 100;

                // Loop through sorted Cities and add them to the deal if they're under the amount to give up - start from the back of the list, because that's where the CLOSEST cities are
                for(int iSortedCityIndex = viCityProximities.size() - 1; iSortedCityIndex > -1 ; iSortedCityIndex--)
                {
                    iSortedCityID = viCityProximities.GetElement(iSortedCityIndex);
                    pLoopCity = pLosingPlayer->getCity(iSortedCityID);

                    iCityValue = GetCityValue(pLoopCity->getX(), pLoopCity->getY(), bMeSurrendering, eOtherPlayer, /*bUseEvenValue*/ true);

                    // City is worth less than what is left to be added to the deal, so add it
                    if(iCityValue < iCityValueToSurrender)
                    {
                        if(pDeal->IsPossibleToTradeItem(eLosingPlayer, eWinningPlayer, TRADE_ITEM_CITIES, pLoopCity->getX(), pLoopCity->getY()))
                        {
                            pDeal->AddCityTrade(eLosingPlayer, iSortedCityID);
                            iCityValueToSurrender -= iCityValue;
                        }
                    }
                }
            }
        }*/
    }
    
    /// Will this AI accept pDeal? Handles deal from both human and AI players
    // , , dontChangeMyExistingItems: Bool, dontChangeTheirExistingItems: Bool, dealGoodToBeginWith: inout Bool
    func isDealWithHumanAcceptable(deal: inout DiplomaticDeal, with otherPlayer: AbstractPlayer?, totalValueToMe: inout Int, valueImOffering: inout Int, valueTheyreOffering: inout Int, amountOverWeWillRequest: inout Int, amountUnderWeWillOffer: inout Int, cantMatchOffer: inout Bool, in gameModel: GameModel?) -> Bool {

        guard let playerLeader = self.player?.leader else {
            fatalError("cant get leader of player")
        }
        
        cantMatchOffer = false

        // Deal leeway with human
        let percentOverWeWillRequest = self.dealPercentLeewayWithHuman()
        let percentUnderWeWillOffer = 0

        // Now do the valuation
        (totalValueToMe, valueImOffering, valueTheyreOffering) = deal.value(useEvenValue: false, in: gameModel)

        // If no Gold in deal and within value of 1 GPT, then it's close enough
        if deal.goldTrade(with: otherPlayer) == 0 && deal.goldTrade(with: self.player) == 0 {
            
            let oneGPT = 25
            let diff = abs(valueTheyreOffering - valueImOffering)
            if diff < oneGPT {
                return true
            }
        }

        let dealSumValue = valueImOffering + valueTheyreOffering

        amountOverWeWillRequest = dealSumValue
        amountOverWeWillRequest *= percentOverWeWillRequest
        amountOverWeWillRequest /= 100

        amountUnderWeWillOffer = dealSumValue
        amountUnderWeWillOffer *= percentUnderWeWillOffer
        amountUnderWeWillOffer /= 100

        if deal.surrendering == playerLeader {
            // We're surrendering
            if totalValueToMe >= self.cachedValueOfPeaceWithHuman() {
                return true
            }
        } else if deal.isPeaceTreatyTrade(with: otherPlayer) {
            // Peace deal where we're not surrendering, value must equal cached value
            if totalValueToMe >= self.cachedValueOfPeaceWithHuman() {
                return true
            }
        } else if totalValueToMe <= amountOverWeWillRequest && totalValueToMe >= amountUnderWeWillOffer {
            // If we've gotten the deal to a point where we're happy, offer it up
            return true
        } else if totalValueToMe > amountOverWeWillRequest {
            cantMatchOffer = true
        }

        return false
    }
    
    /// Add third party peace for allied city-states
    func doAddPlayersAlliesToTreaty(with otherPlayer: AbstractPlayer?, deal: DiplomaticDeal) {
        
        let peaceDuration = 30
        
        /*for(int iMinorLoop = MAX_MAJOR_CIVS; iMinorLoop < MAX_CIV_PLAYERS; iMinorLoop++)
        {
            eMinor = (PlayerTypes) iMinorLoop;
            pMinor = &GET_PLAYER(eMinor);

            // Minor not alive?
            if(!pMinor->isAlive())
                continue;

            PlayerTypes eAlly = pMinor->GetMinorCivAI()->GetAlly();
            // ally of other player
            if (eAlly == eToPlayer)
            {
                // if they are not at war with us, continue
                if (!GET_TEAM(GetTeam()).isAtWar(pMinor->getTeam()))
                {
                    continue;
                }

                // if they are always at war with us, continue
                if (pMinor->GetMinorCivAI()->IsPermanentWar(GetTeam()))
                {
                    continue;
                }

                // Add peace with this minor to the deal
                // slewis - if there is not a peace deal with them already on the table and we can trade it
                if(!pDeal->IsThirdPartyPeaceTrade(GetPlayer()->GetID(), pMinor->getTeam()) && pDeal->IsPossibleToTradeItem(GetPlayer()->GetID(), eToPlayer, TRADE_ITEM_THIRD_PARTY_PEACE, pMinor->getTeam()))
                {
                    pDeal->AddThirdPartyPeace(GetPlayer()->GetID(), pMinor->getTeam(), iPeaceDuration);
                }
            }
            // ally with us
            else if (eAlly == GetPlayer()->GetID())
            {
                // if they are not at war with the opponent, continue
                if (!GET_TEAM(GET_PLAYER(eToPlayer).getTeam()).isAtWar(pMinor->getTeam()))
                {
                    continue;
                }

                // if they are always at war with them, continue
                if (pMinor->GetMinorCivAI()->IsPermanentWar(GET_PLAYER(eToPlayer).getTeam()))
                {
                    continue;
                }

                // Add peace with this minor to the deal
                // slewis - if there is not a peace deal with them already on the table and we can trade it
                if(!pDeal->IsThirdPartyPeaceTrade(eToPlayer, pMinor->getTeam()) && pDeal->IsPossibleToTradeItem(eToPlayer, GetPlayer()->GetID(), TRADE_ITEM_THIRD_PARTY_PEACE, pMinor->getTeam()))
                {
                    pDeal->AddThirdPartyPeace(eToPlayer, pMinor->getTeam(), iPeaceDuration);
                }
            }
        }*/
    }
    
    /// See if adding a Resource to their side of the deal helps even out pDeal
    func doAddResourceToThem(for deal: DiplomaticDeal, by otherPlayer: AbstractPlayer?, dontChangeTheirExistingItems: Bool, totalValue: inout Int, valueImOffering: inout Int, valueTheyreOffering: inout Int, amountOverWeWillRequest: Int, dealDuration :Int, useEvenValue: Bool, in gameModel: GameModel?) {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get otherLeader")
        }
        
        if !dontChangeTheirExistingItems {
            
            if totalValue < 0 {

                // Look to trade Luxuries first
                for resource in ResourceType.all {

                    if resource.usage() != .luxury {
                        continue
                    }

                    var resourceQuantity = player.numAvailable(resource: resource)

                    // Don't bother looking at this Resource if the other player doesn't even have any of it
                    if resourceQuantity <= 0 {
                        continue
                    }

                    // Don't bother if we wouldn't get Happiness from it due to World Congress
                    //if(GC.getGame().GetGameLeagues()->IsLuxuryHappinessBanned(eMyPlayer, eResource))
                    //    continue;

                    // Quantity is always 1 if it's a Luxury, 5 if Strategic
                    resourceQuantity = 1

                    // See if they can actually trade it to us
                    if deal.isPossibleToTradeItem(from: otherPlayer, to: self.player, item: .resource, value: resourceQuantity, resource: resource, in: gameModel) {
                        
                        let itemValue = DiplomaticDeal.valueFor(tradeItemType: .resource, from: otherLeader, to: player.leader, resource: resource, amount: resourceQuantity, duration: dealDuration, useEvenValue: useEvenValue, in: gameModel)

                        // If adding this to the deal doesn't take it over the limit, do it
                        if itemValue + totalValue <= amountOverWeWillRequest {
                            
                            // Try to change the current item, if it already exists, otherwise add it
                            if !deal.changeResourceTrade(from: otherPlayer, resource: resource, amount: resourceQuantity, duration: dealDuration, in: gameModel) {
                                
                                deal.addResourceTrade(from: otherPlayer, resource: resource, amount: resourceQuantity, duration: dealDuration, in: gameModel)
                                (totalValue, valueImOffering, valueTheyreOffering) = deal.value(useEvenValue: useEvenValue, in: gameModel)
                            }
                        }
                    }
                }

                // Now look at Strategic Resources
                for resource in ResourceType.all {

                    if resource.usage() != .strategic {
                        continue
                    }

                    var resourceQuantity = player.numAvailable(resource: resource)

                    // Don't bother looking at this Resource if the other player doesn't even have any of it
                    if resourceQuantity <= 0 {
                        continue
                    }

                    // Quantity is always 1 if it's a Luxury, 5 if Strategic
                    resourceQuantity = min(5, resourceQuantity)    // 5 or what they have, whichever is less

                    // See if they can actually trade it to us
                    if deal.isPossibleToTradeItem(from: otherPlayer, to: self.player, item: .resource, value: resourceQuantity, resource: resource, in: gameModel) {
                        
                        let itemValue = DiplomaticDeal.valueFor(tradeItemType: .resource, from: otherLeader, to: player.leader, resource: resource, amount: resourceQuantity, duration: dealDuration, useEvenValue: useEvenValue, in: gameModel)

                        // If adding this to the deal doesn't take it over the limit, do it
                        if itemValue + totalValue <= amountOverWeWillRequest {
                            // Try to change the current item if it already exists, otherwise add it
                            if !deal.changeResourceTrade(from: otherPlayer, resource: resource, amount: resourceQuantity, duration: dealDuration, in: gameModel) {
                                deal.addResourceTrade(from: otherPlayer, resource: resource, amount: resourceQuantity, duration: dealDuration, in: gameModel)
                                (totalValue, valueImOffering, valueTheyreOffering) = deal.value(useEvenValue: useEvenValue, in: gameModel)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// See if adding a Resource to our side of the deal helps even out pDeal
    func doAddResourceToUs(for deal: DiplomaticDeal, by otherPlayer: AbstractPlayer?, dontChangeTheirExistingItems: Bool, totalValue: inout Int, valueImOffering: inout Int, valueTheyreOffering: inout Int, amountUnderWeWillOffer: Int, dealDuration :Int, useEvenValue: Bool, in gameModel: GameModel?) {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get otherLeader")
        }
        
        if !dontChangeTheirExistingItems {
            
            if totalValue > 0 {

                for resource in ResourceType.all {

                    var resourceQuantity = player.numAvailable(resource: resource)

                    // Don't bother looking at this Resource if we don't even have any of it
                    if resourceQuantity == 0 {
                        continue
                    }

                    // Quantity is always 1 if it's a Luxury, 5 if Strategic
                    if resource.usage() == .luxury {
                        
                        resourceQuantity = 1

                        // Don't bother if they wouldn't get Happiness from it due to World Congress
                        //if(GC.getGame().GetGameLeagues()->IsLuxuryHappinessBanned(eThem, eResource))
                        //    continue;
                    } else {
                        resourceQuantity = min(5, resourceQuantity)    // 5 or what we have, whichever is less
                    }

                    // See if we can actually trade it to them
                    if deal.isPossibleToTradeItem(from: self.player, to: otherPlayer, item: .resource, value: resourceQuantity, resource: resource, in: gameModel) {

                        let itemValue = DiplomaticDeal.valueFor(tradeItemType: .resource, from: player.leader, to: otherLeader, resource: resource, amount: resourceQuantity, duration: dealDuration, useEvenValue: false, in: gameModel)

                        // If adding this to the deal doesn't take it under the min limit, do it
                        if -itemValue + totalValue >= amountUnderWeWillOffer {
                            // Try to change the current item if it already exists, otherwise add it
                            if !deal.changeResourceTrade(from: player, resource: resource, amount: resourceQuantity, duration: dealDuration, in: gameModel) {
                                deal.addResourceTrade(from: player, resource: resource, amount: resourceQuantity, duration: dealDuration, in: gameModel)
                                
                                (totalValue, valueImOffering, valueTheyreOffering) = deal.value(useEvenValue: useEvenValue, in: gameModel)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// A good time to make an offer to get an embassy?
    func makeOfferForEmbassy(to otherPlayer: AbstractPlayer?, deal: inout DiplomaticDeal, in gameModel: GameModel?) -> Bool {

        guard let diplomaticAI = self.player?.diplomacyAI else {
            fatalError("cant get diplomaticAI")
        }
        
        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }
        
        // Don't ask for Open Borders if we're hostile or planning war
        let approach = diplomaticAI.approach(towards: otherPlayer)
        if approach == .hostile || approach == .war || approach == .guarded {
            return false
        }

        // Can we actually complete this deal?
        if !deal.isPossibleToTradeItem(from: otherPlayer, to: self.player, item: .allowEmbassy, in: gameModel) {
            return false
        }

        // Do we actually want OB with eOtherPlayer?
        if diplomaticAI.wantsEmbassy(with: otherPlayer) {
            
            // Seed the deal with the item we want
            deal.addAllowEmbassy(with: otherPlayer)
            var dealAcceptable = false

            // AI evaluation
            if !otherPlayer.isHuman() {
                // Change the deal as necessary to make it work
                dealAcceptable = self.doEqualizeDealWithAI(deal: deal, with: otherPlayer, in: gameModel)
            } else {
                var uselessReferenceVariable: Bool = false
                var cantMatchOffer: Bool = false
                dealAcceptable = self.doEqualizeDealWithHuman(deal: &deal, with: otherPlayer, dontChangeMyExistingItems: false, dontChangeTheirExistingItems: true, dealGoodToBeginWith: &uselessReferenceVariable, cantMatchOffer: &cantMatchOffer, in: gameModel)    // Change the deal as necessary to make it work
            }

            return dealAcceptable
        }

        return false
    }
    
    // How much are we willing to back off on what our perceived value of a deal is with an AI player to make something work?
    func dealPercentLeewayWithAI() -> Int {
        
        return 25
    }
    
    // How much are we willing to back off on what our perceived value of a deal is with a human player to make something work?
    func dealPercentLeewayWithHuman() -> Int {

        return 10
    }
    
    /// What are we willing to give/receive for peace with the active human player?
    private func cachedValueOfPeaceWithHuman() -> Int {
        
        return self.cachedValueOfPeaceWithHumanValue        // NOT SERIALIZED
    }

    /// Sets what are we willing to give/receive for peace with the active human player
    private func updateCachedValueOfPeaceWithHuman(to value: Int) {
        
        self.cachedValueOfPeaceWithHumanValue = value        // NOT SERIALIZED
    }
}
