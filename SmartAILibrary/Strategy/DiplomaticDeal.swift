//
//  DiplomaticDeal.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 26.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum DiplomaticDealItemType: Int, Codable {

    case gold // TRADE_ITEM_GOLD
    case goldPerTurn // TRADE_ITEM_GOLD_PER_TURN
    case maps // TRADE_ITEM_MAPS
    case resource // TRADE_ITEM_RESOURCES
    // TRADE_ITEM_CITIES,
    // TRADE_ITEM_UNITS,
    case allowEmbassy // TRADE_ITEM_ALLOW_EMBASSY,
    case openBorders // TRADE_ITEM_OPEN_BORDERS,
    
    /*TRADE_ITEM_DEFENSIVE_PACT,
    TRADE_ITEM_RESEARCH_AGREEMENT,
    TRADE_ITEM_TRADE_AGREEMENT, // not in use
    TRADE_ITEM_PERMANENT_ALLIANCE,
    TRADE_ITEM_SURRENDER,
    TRADE_ITEM_TRUCE,Ü*/
    case peaceTreaty // TRADE_ITEM_PEACE_TREATY,
    /*TRADE_ITEM_THIRD_PARTY_PEACE,
    TRADE_ITEM_THIRD_PARTY_WAR,
    TRADE_ITEM_THIRD_PARTY_EMBARGO, // not in use
    TRADE_ITEM_DECLARATION_OF_FRIENDSHIP,    // Only "traded" between human players*/
    
    func goldCost() -> Double {
        
        switch self {

        case .gold: return 0.0
        case .goldPerTurn: return 0.0
        case .maps: return 0.0
        case .resource: return 0.0
            
        case .openBorders: return 0.0
        case .allowEmbassy: return 0.0
        case .peaceTreaty: return 0.0
        }
    }
}

public enum DiplomaticDealDirectionType: Int, Codable {

    case give
    case receive
}

public class DiplomaticDealItem: Codable {

    enum CodingKeys: CodingKey {

        case type
        case direction
        case amount
        case resource
        case duration
    }
    
    public let type: DiplomaticDealItemType
    public let direction: DiplomaticDealDirectionType
    public var amount: Int
    public let resource: ResourceType
    public var duration: Int

    public init(type: DiplomaticDealItemType, direction: DiplomaticDealDirectionType, amount: Int, duration: Int) {

        self.type = type
        self.direction = direction
        self.amount = amount
        self.duration = duration
        self.resource = .none
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.type = try container.decode(DiplomaticDealItemType.self, forKey: .type)
        self.direction = try container.decode(DiplomaticDealDirectionType.self, forKey: .direction)
        self.amount = try container.decode(Int.self, forKey: .amount)
        self.resource = try container.decode(ResourceType.self, forKey: .resource)
        self.duration = try container.decode(Int.self, forKey: .duration)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encode(self.direction, forKey: .direction)
        try container.encode(self.amount, forKey: .amount)
        try container.encode(self.duration, forKey: .duration)
        try container.encode(self.resource, forKey: .resource)
    }
}

class DiplomaticGoldDealItem: DiplomaticDealItem {

    init(direction: DiplomaticDealDirectionType, amount: Int) {
        super.init(type: .gold, direction: direction, amount: amount, duration: 0)
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class DiplomaticGoldPerTurnDealItem: DiplomaticDealItem {

    init(direction: DiplomaticDealDirectionType, amount: Int, duration: Int) {
        super.init(type: .goldPerTurn, direction: direction, amount: amount, duration: duration)
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

public class DiplomaticDeal: Codable {

    enum CodingKeys: CodingKey {

        case from
        case to
        case surrendering
        case tradeItems
        case peaceTreatyType
    }
    
    typealias DiplomaticDealValue = (value: Int, valueImOffering: Int, valueOtherOffering: Int)

    public let from: LeaderType
    public let to: LeaderType
    public var surrendering: LeaderType
    public var tradeItems: [DiplomaticDealItem]
    public var peaceTreatyType: PeaceTreatyType

    // MARK: constructors

    public init(from fromLeader: LeaderType, to toLeader: LeaderType) {

        self.from = fromLeader
        self.to = toLeader
        self.surrendering = .none
        self.tradeItems = []
        self.peaceTreatyType = .none
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.from = try container.decode(LeaderType.self, forKey: .from)
        self.to = try container.decode(LeaderType.self, forKey: .to)
        self.surrendering = try container.decode(LeaderType.self, forKey: .surrendering)
        self.tradeItems = try container.decode([DiplomaticDealItem].self, forKey: .tradeItems)
        self.peaceTreatyType = try container.decode(PeaceTreatyType.self, forKey: .peaceTreatyType)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.from, forKey: .from)
        try container.encode(self.to, forKey: .to)
        try container.encode(self.surrendering, forKey: .surrendering)
        try container.encode(self.tradeItems, forKey: .tradeItems)
        try container.encode(self.peaceTreatyType, forKey: .peaceTreatyType)
    }
    
    // deep copy
    func copy() -> DiplomaticDeal? {
        
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONDecoder().decode(DiplomaticDeal.self, from: data)
    }
    
    // MARK: public static methods

    public static func valueFor(tradeItemType: DiplomaticDealItemType, from fromLeader: LeaderType, to toLeader: LeaderType, resource: ResourceType = .none, amount: Int = 0, duration: Int = 0, useEvenValue: Bool, in gameModel: GameModel?) -> Int {
    
        let deal = DiplomaticDeal(from: fromLeader, to: toLeader)
        return deal.valueFor(tradeItemType: tradeItemType, resource: resource, amount: amount, duration: duration, useEvenValue: useEvenValue, in: gameModel)
    }
    
    // MARK: public methods

    func value(useEvenValue: Bool, in gameModel: GameModel?) -> DiplomaticDealValue {

        var val: DiplomaticDealValue = (value: 0, valueImOffering: 0, valueOtherOffering: 0)

        for tradeItem in self.tradeItems {

            let itemValue = self.valueFor(tradeItemType: tradeItem.type, resource: tradeItem.resource, amount: tradeItem.amount, duration: tradeItem.duration, useEvenValue: useEvenValue, in: gameModel)

            if tradeItem.direction == .give {
                val.value -= itemValue
                val.valueImOffering += itemValue
            } else {
                val.value += itemValue
                val.valueOtherOffering += itemValue
            }
        }

        return val
    }
    
    /// Insert a resource trade
    func addResourceTrade(from otherPlayer: AbstractPlayer?, resource: ResourceType, amount: Int, duration: Int, in gameModel: GameModel?) {
        
        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get otherLeader")
        }
        
        var direction = DiplomaticDealDirectionType.give
        var targetLeader = self.to
        if self.to == otherLeader {
            targetLeader = self.from
            direction = .receive
        }
        
        if self.isPossibleToTradeItem(from: otherPlayer, to: gameModel?.player(for: targetLeader), item: .resource, value: amount, resource: resource, in: gameModel) {
            
            let item = DiplomaticDealItem(type: .resource, direction: direction, amount: amount, duration: duration)
            self.tradeItems.append(item)
        } else {
            fatalError("DEAL: Trying to add an invalid Resource to a deal")
        }
    }
    
    func changeResourceTrade(from otherPlayer: AbstractPlayer?, resource: ResourceType, amount: Int, duration: Int, in gameModel: GameModel?) -> Bool {

        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get otherLeader")
        }
        
        var direction = DiplomaticDealDirectionType.give
        var targetLeader = self.to
        if self.to == otherLeader {
            targetLeader = self.from
            direction = .receive
        }
        
        for tradeItem in self.tradeItems {
        
            if tradeItem.type == .resource && tradeItem.direction == direction && tradeItem.resource == resource {
                
                if self.isPossibleToTradeItem(from: otherPlayer, to: gameModel?.player(for: targetLeader), item: .resource, value: amount, resource: resource, in: gameModel) {
                    
                    tradeItem.amount = amount
                    tradeItem.duration = duration
                    //it->m_iFinalTurn = iDuration + GC.getGame().getGameTurn();
                    return true
                }
            }
        }
        return false
    }
    
    /// Insert ending a war
    func addPeaceTreaty(with otherPlayer: AbstractPlayer?, duration: Int, in gameModel: GameModel?) {
        
        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get otherLeader")
        }
        
        var direction = DiplomaticDealDirectionType.give
        var targetLeader = self.to
        if self.to == otherLeader {
            targetLeader = self.from
            direction = .receive
        }
        
        if self.isPossibleToTradeItem(from: gameModel?.player(for: self.from), to: gameModel?.player(for: targetLeader), item: .peaceTreaty, in: gameModel) {
            
            let item = DiplomaticDealItem(type: .peaceTreaty, direction: .give, amount: 0, duration: 30)
            tradeItems.append(item)
        } else  {
            fatalError("DEAL: Trying to add an invalid Peace Treaty item to a deal");
        }
    }
        
    // MARK: private methods

    private func valueFor(tradeItemType: DiplomaticDealItemType, resource: ResourceType, amount: Int, duration: Int, useEvenValue: Bool, in gameModel: GameModel?) -> Int {

        switch tradeItemType {

        case .gold:
            return self.valueForGold(amount: amount, useEvenValue: useEvenValue, in: gameModel)
        case .goldPerTurn:
            return self.valueForGoldPerTurn(amount: amount, duration: duration, useEvenValue: useEvenValue, in: gameModel)
        case .resource:
            return self.valueForResourcePerTurn(for: resource, amount: amount, duration: duration, useEvenValue: useEvenValue, in: gameModel)
        case .maps:
            return 0
        case .openBorders:
            return 0
        case .allowEmbassy:
            return 0
        case .peaceTreaty:
            return 0
        }
    }

    private func valueForGold(amount: Int, useEvenValue: Bool, in gameModel: GameModel?) -> Int {

        let iMultiplier = 100
        var returnValue = amount * iMultiplier
        var iModifier = 0

        guard let fromPlayer = gameModel?.player(for: self.from) else {
            fatalError("cant get player")
        }
        
        guard let toPlayer = gameModel?.player(for: self.to) else {
            fatalError("cant get player")
        }
        
        // Approach is important
        if let approach = fromPlayer.diplomacyAI?.approach(towards: to) {

            switch approach {

            case .hostile:
                iModifier = 150
            case .guarded:
                iModifier = 110
            case .afraid, .friendly, .neutrally:
                iModifier = 100
                /*default:
                iModifier = 100*/
            default:
                // NOOP
                break
            }

            returnValue *= 100
            returnValue /= iModifier
        }

        // Opinion also matters
        if let opinion = fromPlayer.diplomacyAI?.opinion(of: toPlayer) {

            switch opinion {

            case .ally, .friend, .favorable, .neutral:
                iModifier = 100
            case .competitor:
                iModifier = 115
            case .enemy:
                iModifier = 140
            case.unforgivable:
                iModifier = 200
                /*default:
                iModifier = 100*/
            default:
                // NOOP
                break
            }

            returnValue *= 100
            returnValue /= iModifier
        }

        return returnValue
    }
    
    func goldTrade(with otherPlayer: AbstractPlayer?) -> Int {
        
        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get otherLeader")
        }
        
        var direction: DiplomaticDealDirectionType = .give
        if self.to == otherLeader {
            direction = .receive
        }
        
        for item in self.tradeItems {
            
            if item.type == .gold && direction == .give { // ?? unsure
                return item.amount
            }
        }
        
        return 0
    }
    
    /// How much Gold does ePlayer have available to be used in this Deal?
    func goldAvailable(of player: AbstractPlayer?, for itemToBeChanged: DiplomaticDealItemType, in gameModel: GameModel?) -> Int {
        
        guard let treasury = player?.treasury else {
            fatalError("cant get treasury")
        }
        
        guard let playerLeader = player?.leader else {
            fatalError("cant get playerLeader")
        }
        
        var direction: DiplomaticDealDirectionType = .give
        var targetLeader = self.to
        if self.to == playerLeader {
            direction = .receive
            targetLeader = self.from
        }
        
        var goldAvailable = Int(treasury.value())

        // Remove Gold we're sending to the other player in this deal (unless we're changing it)
        if itemToBeChanged != .gold {
            goldAvailable -= self.goldTrade(with: player)
        }

        var goldCost: Int = 0

        // Loop through all trade items to see if they have a cost
        for item in self.tradeItems {
            
            // Don't count something against itself when trying to add it
            if item.type == itemToBeChanged {
                
                if direction == .give {
                    goldCost = self.tradeItemGoldCost(for: item.type, of: player, and: gameModel?.player(for: targetLeader))

                    if goldCost != 0 {
                        // Negative cost valid?  Maybe ;-O
                        goldAvailable -= goldCost
                    }
                }
            }
        }

        return goldAvailable
    }
    
    /// Some trade items require Gold to be spent by both players
    func tradeItemGoldCost(for itemType: DiplomaticDealItemType, of player1: AbstractPlayer?, and player2: AbstractPlayer?) -> Int {
        
        let goldCost = 0

        switch itemType {
        //case .research:
        //    goldCost = GC.getGame().GetResearchAgreementCost(ePlayer1, ePlayer2);
        
        //case .tradeAgreement:
        //    goldCost = 250
        default:
            // noop
            break
        }

        return goldCost
    }
    
    func isPeaceTreatyTrade(with otherPlayer: AbstractPlayer?) -> Bool {
        
        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get otherLeader")
        }
        
        var direction: DiplomaticDealDirectionType = .give
        if self.to == otherLeader {
            direction = .receive
        }
        
        for item in self.tradeItems {
            
            if item.type == .peaceTreaty && direction == .give { // ?? unsure
                return true
            }
        }
        
        return false
    }
    
    func updatePeaceTreatyType(to peaceTreatyType: PeaceTreatyType) {
        
        self.peaceTreatyType = peaceTreatyType
    }

    private func valueForGoldPerTurn(amount: Int, duration: Int, useEvenValue: Bool, in gameModel: GameModel?) -> Int {

        let iMultiplier = 80
        var returnValue = amount * duration * iMultiplier
        var iModifier = 0

        guard let fromPlayer = gameModel?.player(for: self.from) else {
            fatalError("cant get player")
        }
        
        guard let toPlayer = gameModel?.player(for: self.to) else {
            fatalError("cant get player")
        }
        
        // Approach is important
        if let approach = fromPlayer.diplomacyAI?.approach(towards: toPlayer) {

            switch approach {

            case .hostile:
                iModifier = 150
            case .guarded:
                iModifier = 110
            case .afraid, .friendly, .neutrally:
                iModifier = 100
                /*default:
                iModifier = 100*/
            default:
                // NOOP
                break
            }

            returnValue *= 100
            returnValue /= iModifier
        }

        // Opinion also matters
        if let opinion = fromPlayer.diplomacyAI?.opinion(of: toPlayer) {

            switch opinion {

            case .ally, .friend, .favorable, .neutral:
                iModifier = 100
            case .competitor:
                iModifier = 115
            case .enemy:
                iModifier = 140
            case.unforgivable:
                iModifier = 200
                /*default:
                iModifier = 100*/
            default:
                // NOOP
                break
            }

            returnValue *= 100
            returnValue /= iModifier
        }

        return returnValue
    }

    private func valueForResourcePerTurn(for resource: ResourceType, amount: Int, duration: Int, useEvenValue: Bool, in gameModel: GameModel?) -> Int {

        guard let fromPlayer = gameModel?.player(for: self.from) else {
            fatalError("cant get player")
        }
        
        guard let toPlayer = gameModel?.player(for: self.to) else {
            fatalError("cant get player")
        }
        
        var returnValue = 0
        var modifier = 0
        
        switch resource.usage() {

        case .bonus:
            // NOOP
            break

        case .luxury:
            let happinessFromResource = 4
            
            // Ex: 1 Silk for 4 Happiness * 30 turns * 2 = 240
            returnValue = happinessFromResource * amount * duration * 2
            
        case .strategic:
            // limit effect of strategic resources to number of cities
            //resourceQuantity = min(max(5, self.from.ci))
            // NOOP
            break
        }
        
        // Approach is important
        if let approach = fromPlayer.diplomacyAI?.approach(towards: toPlayer) {

            switch approach {

            case .hostile:
                modifier = 150
            case .guarded:
                modifier = 110
            case .afraid, .friendly, .neutrally:
                modifier = 100
                /*default:
                iModifier = 100*/
            default:
                // NOOP
                break
            }

            returnValue *= 100
            returnValue /= modifier
        }

        // Opinion also matters
        if let opinion = fromPlayer.diplomacyAI?.opinion(of: toPlayer) {

            switch opinion {

            case .ally, .friend, .favorable, .neutral:
                modifier = 100
            case .competitor:
                modifier = 115
            case .enemy:
                modifier = 140
            case.unforgivable:
                modifier = 200
                /*default:
                iModifier = 100*/
            default:
                // NOOP
                break
            }

            returnValue *= 100
            returnValue /= modifier
        }

        return returnValue
    }
    
    // Is it actually possible for a player to offer up this trade item?
    func isPossibleToTradeItem(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, item: DiplomaticDealItemType, value: Int = 0, resource: ResourceType = .none, duration: Int = 0, checkOtherPlayerValidity: Bool = false, finalizing: Bool = false, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let treasury = fromPlayer?.treasury else {
            fatalError("cant get treasury")
        }
         
        guard let fromPlayer = fromPlayer else {
            fatalError("cant get from player")
        }
        
        guard let toPlayer = toPlayer else {
            fatalError("cant get to player")
        }
        
        // The Data parameters can be -1, which means we don't care about whatever data is stored there (e.g. -1 for Gold means can we trade ANY amount of Gold?)
        /*CvPlayer* pFromPlayer = &GET_PLAYER(ePlayer);
        CvPlayer* pToPlayer = &GET_PLAYER(eToPlayer);

        TeamTypes eFromTeam = pFromPlayer->getTeam();
        TeamTypes eToTeam = pToPlayer->getTeam();

        CvTeam* pFromTeam = &GET_TEAM(eFromTeam);
        CvTeam* pToTeam = &GET_TEAM(eToTeam);

        CvDeal* pRenewDeal = pFromPlayer->GetDiplomacyAI()->GetDealToRenew();
        if (!pRenewDeal)
        {
            pRenewDeal = pToPlayer->GetDiplomacyAI()->GetDealToRenew();
        }*/

        var goldAvailable = treasury.value() // GetGoldAvailable(ePlayer, eItem)

        // Some items require gold be spent (e.g. Research and Trade Agreements)
        let cost = item.goldCost() // GC.getGame().GetGameDeals()->GetTradeItemGoldCost(eItem, ePlayer, eToPlayer);
        if cost > 0 && goldAvailable < cost {
            return false
        }

        goldAvailable -= cost

        ////////////////////////////////////////////////////

        if item == .gold {
        
            // Gold
            // Can't trade more Gold than you have
            let gold = value
            if gold != -1 && goldAvailable < Double(gold) {
                return false
            }
        } else if item == .goldPerTurn {
            
            // Gold per Turn
            // Can't trade more GPT than you're making
            let goldPerTurn = value
            if goldPerTurn != -1 && treasury.calculateGrossGold(in: gameModel) < Double(goldPerTurn) {
                return false
            }
        } else if item == .maps {
            
            // Map
            return false
        } else if item == .resource {
            
            // Resource
            if resource != .none {
                let resourceQuantity = value

                // Can't trade a negative amount of something!
                if resourceQuantity < 0 {
                    return false
                }

                let numAvailable = fromPlayer.numAvailable(resource: resource)
                let numInRenewDeal = 0
                let numInExistingDeal = 0

                /*if (pRenewDeal)
                {
                    // count any that are in the renew deal
                    TradedItemList::iterator it;
                    for(it = pRenewDeal->m_TradedItems.begin(); it != pRenewDeal->m_TradedItems.end(); ++it)
                    {
                        if(it->m_eItemType == TRADE_ITEM_RESOURCES && it->m_eFromPlayer == ePlayer && (ResourceTypes)it->m_iData1 == eResource)
                        {
                            // credit the amount
                            iNumInRenewDeal += it->m_iData2;
                        }
                    }

                    // remove any that are in this deal
                    for(it = m_TradedItems.begin(); it != m_TradedItems.end(); ++it)
                    {
                        if(it->m_eItemType == TRADE_ITEM_RESOURCES && it->m_eFromPlayer == ePlayer && (ResourceTypes)it->m_iData1 == eResource)
                        {
                            iNumInExistingDeal += it->m_iData2;
                        }
                    }
                }*/

                // Offering up more of a Resource than we have available
                if numAvailable + numInRenewDeal - numInExistingDeal < resourceQuantity {
                    return false
                }

                // Must be a Luxury or a Strategic Resource
                if resource.usage() != .luxury && resource.usage() != .strategic {
                    return false
                }

                if resource.usage() == .luxury {
                    
                    // Can't trade Luxury, if the other player already has one
                    if toPlayer.numAvailable(resource: resource) > max(numInRenewDeal - numInExistingDeal, 0) {
                        return false
                    }
                }

                // Can't trade them something they're already giving us in the deal
                /*if self.isResourceTrade(eToPlayer, eResource) {
                    return false
                }*/
            }
        }
        // City
        /*else if(eItem == TRADE_ITEM_CITIES)
        {
            CvCity* pCity = NULL;
            CvPlot* pPlot = GC.getMap().plot(iData1, iData2);
            if(pPlot != NULL)
                pCity = pPlot->getPlotCity();

            if(pCity != NULL)
            {
                // Can't trade someone else's city
                if(pCity->getOwner() != ePlayer)
                    return false;

                // Can't trade one's capital
                if(pCity->isCapital())
                    return false;

                // Can't trade a city to a human in an OCC game
                if(GC.getGame().isOption(GAMEOPTION_ONE_CITY_CHALLENGE) && GET_PLAYER(eToPlayer).isHuman())
                    return false;
            }
            // Can't trade a null city
            else
                return false;

            // Can't already have this city in the deal
            if(!bFinalizing && IsCityTrade(ePlayer, iData1, iData2))
                return false;
        }
        // Unit
        else if(eItem == TRADE_ITEM_UNITS)
        {
            return false;
        }*/
        
        else if item == .allowEmbassy { // Embassy
            
            // too few cities
            if gameModel.cities(of: toPlayer).count < 1 {
                return false
            }
            
            // Does not have tech for Embassy trading
            if !toPlayer.isAllowEmbassyTradingAllowed() {
                return false
            }
            
            // Already has embassy
            if toPlayer.hasEmbassy(with: fromPlayer) {
                return false
            }
            
            // Same team
            if toPlayer.leader == fromPlayer.leader {
                return false
            }
        } else if item == .openBorders {
            
            // Open Borders
            // Neither of us yet has the Tech for OP
            if !fromPlayer.isOpenBordersTradingAllowed() && !toPlayer.isOpenBordersTradingAllowed() {
                return false
            }
            
            // Embassy has not been established
            if !fromPlayer.hasEmbassy(with: toPlayer) {
                return false
            }
            
            let ignoreExistingOP = true
            /*if renewDeal {
                // count any that are in the renew deal
                int iEndingTurn = -1;
                TradedItemList::iterator it;
                for(it = pRenewDeal->m_TradedItems.begin(); it != pRenewDeal->m_TradedItems.end(); ++it)
                {
                    if(it->m_eItemType == TRADE_ITEM_OPEN_BORDERS && (it->m_eFromPlayer == ePlayer || it->m_eFromPlayer == eToPlayer == ePlayer))
                    {
                        iEndingTurn = it->m_iFinalTurn;
                    }
                }

                if (iEndingTurn == GC.getGame().getGameTurn()) {
                    ignoreExistingOP = false
                }
            }*/

            // Already has OP
            if fromPlayer.isAllowsOpenBorders(with: toPlayer) && ignoreExistingOP {
                return false
            }
        }
        // Defensive Pact
        /*else if(eItem == TRADE_ITEM_DEFENSIVE_PACT)
        {
            // Neither of us yet has the Tech for DP
            if(!pFromTeam->isDefensivePactTradingAllowed() && !pToTeam->isDefensivePactTradingAllowed())
                return false;
            // Embassy has not been established
            if(!pFromTeam->HasEmbassyAtTeam(eToTeam) || !pToTeam->HasEmbassyAtTeam(eFromTeam))
                return false;
            // Already has DP
            if(pFromTeam->IsHasDefensivePact(eToTeam))
                return false;
            // Same Team
            if(eFromTeam == eToTeam)
                return false;

            // Check to see if the other player can trade this item to us as well.  If we can't, we can't trade it either
            if(bCheckOtherPlayerValidity)
            {
                if(!IsPossibleToTradeItem(eToPlayer, ePlayer, eItem, iData1, iData2, /*bCheckOtherPlayerValidity*/ false))
                    return false;
            }
        }
        // Research Agreement
        else if(eItem == TRADE_ITEM_RESEARCH_AGREEMENT)
        {
            if(GC.getGame().isOption(GAMEOPTION_NO_SCIENCE))
                return false;

            // Neither of us yet has the Tech for RA
            if(!pFromTeam->IsResearchAgreementTradingAllowed() && !pToTeam->IsResearchAgreementTradingAllowed())
                return false;
            // Embassy has not been established with this team
            if(!pFromTeam->HasEmbassyAtTeam(eToTeam) || !pToTeam->HasEmbassyAtTeam(eFromTeam))
                return false;
            // DoF has not been made with this player
            if(!pFromPlayer->GetDiplomacyAI()->IsDoFAccepted(eToPlayer) || !pToPlayer->GetDiplomacyAI()->IsDoFAccepted(ePlayer))
                return false;
            // Already has RA
            if(pFromTeam->IsHasResearchAgreement(eToTeam))
                return false;
            // Same Team
            if(eFromTeam == eToTeam)
                return false;
            // Someone already has all techs
            if(pFromTeam->GetTeamTechs()->HasResearchedAllTechs() || pToTeam->GetTeamTechs()->HasResearchedAllTechs())
                return false;

            // Check to see if the other player can trade this item to us as well.  If we can't, we can't trade it either
            if(bCheckOtherPlayerValidity)
            {
                if(!IsPossibleToTradeItem(eToPlayer, ePlayer, eItem, iData1, iData2, /*bCheckOtherPlayerValidity*/ false))
                    return false;
            }
        }
        // Trade Agreement
        else if(eItem == TRADE_ITEM_TRADE_AGREEMENT)
        {
            // Neither of us yet has the Tech for TA
            if(!pFromTeam->IsTradeAgreementTradingAllowed() && !pToTeam->IsTradeAgreementTradingAllowed())
                return false;
            // Already has TA
            if(pFromTeam->IsHasTradeAgreement(eToTeam))
                return false;
            // Same Team
            if(eFromTeam == eToTeam)
                return false;

            // Check to see if the other player can trade this item to us as well.  If we can't, we can't trade it either
            if(bCheckOtherPlayerValidity)
            {
                if(!IsPossibleToTradeItem(eToPlayer, ePlayer, eItem, iData1, iData2, /*bCheckOtherPlayerValidity*/ false))
                    return false;
            }
        }
        // Permanent Alliance
        else if(eItem == TRADE_ITEM_PERMANENT_ALLIANCE)
            return false;
        // Surrender
        else if(eItem == TRADE_ITEM_SURRENDER)
            return false;
        // Truce
        else if(eItem == TRADE_ITEM_TRUCE)
            return false;
        */
        else if item == .peaceTreaty {
            
            // Peace Treaty
            if !fromPlayer.isAtWar(with: toPlayer) {
                return false
            }

            if !toPlayer.isAtWar(with: fromPlayer) {
                return false
            }
        }
        // Third Party Peace
        /*else if(eItem == TRADE_ITEM_THIRD_PARTY_PEACE)
        {
            TeamTypes eThirdTeam = (TeamTypes) iData1;

            // Can't be the same team
            if(eFromTeam == eThirdTeam)
                return false;

            // Can't ask teammates
            if(eToTeam == eFromTeam)
                return false;

            // Must be alive
            if(!GET_TEAM(eThirdTeam).isAlive())
                return false;

            // Player that wants Peace hasn't yet met the 3rd Team
            if(!pToTeam->isHasMet(eThirdTeam))
                return false;
            // Player that would go to Peace hasn't yet met the 3rd Team
            if(!pFromTeam->isHasMet(eThirdTeam))
                return false;
            // Player that would go to peace is already at peace with the 3rd Team
            if(!pFromTeam->isAtWar(eThirdTeam))
                return false;

            // Can't already have this in the deal
            //if (IsThirdPartyPeaceTrade( ePlayer, GET_TEAM(eThirdTeam).getLeaderID() ))
            //    return false;

            // If eThirdTeam is an AI then they have to want peace with ToTeam
            CvPlayer* pOtherPlayer = &GET_PLAYER(GET_TEAM(eThirdTeam).getLeaderID());
            // Minor civ
            if(pOtherPlayer->isMinorCiv())
            {
                // Minor at permanent war with this player
                if(pOtherPlayer->GetMinorCivAI()->IsPermanentWar(eFromTeam))
                    return false;

                // Minor's ally at war with this player?
                else if(pOtherPlayer->GetMinorCivAI()->IsPeaceBlocked(eFromTeam))
                {
                    // If the ally is us, don't block peace here
                    if(pOtherPlayer->GetMinorCivAI()->GetAlly() != eToPlayer)
                        return false;
                }
            }
            // Major civ
            else
            {
                // Can't ask them to make peace with a human, because we have no way of knowing if the human wants peace
                if(pOtherPlayer->isHuman())
                    return false;

                // Player does not want peace with eOtherPlayer
                if(pFromPlayer->isHuman() || pFromPlayer->GetDiplomacyAI()->GetWarGoal(pOtherPlayer->GetID()) < WAR_GOAL_DAMAGE)
                    return false;

                // Other player does not want peace with eToPlayer
                if(!pOtherPlayer->GetDiplomacyAI()->IsWantsPeaceWithPlayer(ePlayer))
                    return false;
            }
        }
        // Third Party War
        else if(eItem == TRADE_ITEM_THIRD_PARTY_WAR)
        {
            TeamTypes eThirdTeam = (TeamTypes) iData1;

            // Can't be the same team
            if(eFromTeam == eThirdTeam)
                return false;

            // Can't ask teammates
            if(eToTeam == eFromTeam)
                return false;

            // Must be alive
            if(!GET_TEAM(eThirdTeam).isAlive())
                return false;

            // Player that would go to war hasn't yet met the 3rd Team
            if(!pToTeam->isHasMet(eThirdTeam))
                return false;
            // Player that wants war not met this team
            if(!pFromTeam->isHasMet(eThirdTeam))
                return false;

            // Player that would go to war is already at war with the 3rd Team
            if(pFromTeam->isAtWar(eThirdTeam))
                return false;

            // Can this player actually declare war?
            if(!pFromTeam->canDeclareWar(eThirdTeam))
                return false;

            // Can't already have this in the deal
            //if (IsThirdPartyWarTrade( ePlayer, GET_TEAM(eThirdTeam).getLeaderID() ))
            //    return false;

            // Can't ask a player to declare war on their ally
            if(GET_TEAM(eThirdTeam).isMinorCiv())
            {
                if(GET_PLAYER(GET_TEAM(eThirdTeam).getLeaderID()).GetMinorCivAI()->GetAlly() == ePlayer)
                    return false;
            }
        }
        // Third Party Embargo
        else if(eItem == TRADE_ITEM_THIRD_PARTY_EMBARGO)
        {
            return false;
        }
        // Declaration of friendship
        else if(eItem == TRADE_ITEM_DECLARATION_OF_FRIENDSHIP)
        {
            // If we are at war, then we can't until we make peace
            if(pFromTeam->isAtWar(eToTeam))
                return false;

            // Already have a DoF?
            if (pFromPlayer->GetDiplomacyAI()->IsDoFAccepted(eToPlayer) && pToPlayer->GetDiplomacyAI()->IsDoFAccepted(ePlayer))
                return false;
        }*/

        return true
    }
    
    func addOpenBorders(with player: AbstractPlayer?, duration: Int) {
        
        if self.from == player?.leader {
            self.tradeItems.append(DiplomaticDealItem(type: .openBorders, direction: .give, amount: 0, duration: duration))
        } else {
            self.tradeItems.append(DiplomaticDealItem(type: .openBorders, direction: .receive, amount: 0, duration: duration))
        }
    }
    
    func addAllowEmbassy(with player: AbstractPlayer?) {
        
        if self.from == player?.leader {
            self.tradeItems.append(DiplomaticDealItem(type: .allowEmbassy, direction: .give, amount: 0, duration: 0))
        } else {
            self.tradeItems.append(DiplomaticDealItem(type: .allowEmbassy, direction: .receive, amount: 0, duration: 0))
        }
    }
    
    func oppositeLeader(of leader: LeaderType) -> LeaderType {
        
        if self.from == leader {
            return self.to
        } else {
            return self.from
        }
    }
    
    /// Insert an immediate gold trade
    func addGoldTrade(from otherPlayer: AbstractPlayer?, amount: Int, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get otherLeader")
        }
        
        var direction = DiplomaticDealDirectionType.give
        var targetLeader = self.to
        if self.to == otherLeader {
            targetLeader = self.from
            direction = .receive
        }
        
        if self.isPossibleToTradeItem(from: otherPlayer, to: gameModel.player(for: targetLeader), item: .gold, value: amount, in: gameModel) {
            
            let item = DiplomaticDealItem(type: .gold, direction: direction, amount: amount, duration: 0)
            self.tradeItems.append(item)
        } else {
            fatalError("DEAL: Trying to add an invalid Gold amount to a deal")
        }
    }
    
    func addGoldPerTurnTrade(from otherPlayer: AbstractPlayer?, amount: Int, duration: Int, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get otherLeader")
        }
        
        var direction = DiplomaticDealDirectionType.give
        var targetLeader = self.to
        if self.to == otherLeader {
            targetLeader = self.from
            direction = .receive
        }
        
        if self.isPossibleToTradeItem(from: otherPlayer, to: gameModel.player(for: targetLeader), item: .goldPerTurn, value: amount, duration: duration, in: gameModel) {
            
            let item = DiplomaticDealItem(type: .goldPerTurn, direction: direction, amount: amount, duration: duration)
            self.tradeItems.append(item)
        } else {
            fatalError("DEAL: Trying to add an invalid GPT amount to a deal");
        }
    }
    
    /// Burn it... burn it all...
    func clearItems() {
        
        self.tradeItems.removeAll()

        //m_iFinalTurn = -1;
        //self.duration = -1
        //m_iStartTurn = -1;
        //m_bConsideringForRenewal = false;
        //m_bCheckedForRenewal = false;
        //m_bDealCancelled = false;

        //SetPeaceTreatyType(NO_PEACE_TREATY_TYPE);
        self.surrendering = .none
        //SetDemandingPlayer(NO_PLAYER);
        //SetRequestingPlayer(NO_PLAYER);
    }
}
