//
//  DiplomaticDeal.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 26.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum DiplomaticDealItemType: Int, Codable {

    case gold
    case goldPerTurn
    case resource
}

enum DiplomaticDealDirectionType: Int, Codable {

    case give
    case receive
}

class DiplomaticDealItem: Codable {

    enum CodingKeys: CodingKey {

        case type
        case direction
        case amount
        case resource
        case duration
    }
    
    let type: DiplomaticDealItemType
    let direction: DiplomaticDealDirectionType
    let amount: Int
    let resource: ResourceType
    let duration: Int

    init(type: DiplomaticDealItemType, direction: DiplomaticDealDirectionType, amount: Int, duration: Int) {

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

class DiplomaticDeal: Codable {

    enum CodingKeys: CodingKey {

        case from
        case to
        case tradeItems
    }
    
    typealias DiplomaticDealValue = (value: Int, valueImOffering: Int, valueOtherOffering: Int)

    let from: LeaderType
    let to: LeaderType
    var tradeItems: [DiplomaticDealItem]

    // MARK: constructors

    init(from fromLeader: LeaderType, to toLeader: LeaderType) {

        self.from = fromLeader
        self.to = toLeader
        self.tradeItems = []
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.from = try container.decode(LeaderType.self, forKey: .from)
        self.to = try container.decode(LeaderType.self, forKey: .to)
        self.tradeItems = try container.decode([DiplomaticDealItem].self, forKey: .tradeItems)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.from, forKey: .from)
        try container.encode(self.to, forKey: .to)
        try container.encode(self.tradeItems, forKey: .tradeItems)
    }

    // MARK: public methods

    func value(with gameModel: GameModel?) -> DiplomaticDealValue {

        var val: DiplomaticDealValue = (value: 0, valueImOffering: 0, valueOtherOffering: 0)

        for tradeItem in self.tradeItems {

            let itemValue = self.valueFor(tradeItemType: tradeItem.type, resource: tradeItem.resource, amount: tradeItem.amount, duration: tradeItem.duration, with: gameModel)

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

    // MARK: private methods

    private func valueFor(tradeItemType: DiplomaticDealItemType, resource: ResourceType, amount: Int, duration: Int, with gameModel: GameModel?) -> Int {

        switch tradeItemType {

        case .gold:
            return self.valueForGold(amount: amount, with: gameModel)
        case .goldPerTurn:
            return self.valueForGoldPerTurn(amount: amount, duration: duration, with: gameModel)
        case .resource:
            return self.valueForResourcePerTurn(for: resource, amount: amount, duration: duration, with: gameModel)
        }
    }

    private func valueForGold(amount: Int, with gameModel: GameModel?) -> Int {

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

    private func valueForGoldPerTurn(amount: Int, duration: Int, with gameModel: GameModel?) -> Int {

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

    private func valueForResourcePerTurn(for resource: ResourceType, amount: Int, duration: Int, with gameModel: GameModel?) -> Int {

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
}
