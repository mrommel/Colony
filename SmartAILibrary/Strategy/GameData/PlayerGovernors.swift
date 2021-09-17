//
//  PlayerGovernors.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

extension Double {
    static var min     = -Double.greatestFiniteMagnitude
    // static var MAX_NEG = -Double.leastNormalMagnitude
    // static var MIN_POS =  Double.leastNormalMagnitude
    static var max     =  Double.greatestFiniteMagnitude

    var positiveValue: Double {

        if self > 0.0 {
            return self
        }

        return 0.0
    }
}

public class Governor: Codable {

    enum CodingKeys: CodingKey {

        case type
        case location
        case titles
    }

    public let type: GovernorType

    var location: HexPoint = HexPoint.invalid // <= city
    var titles: [GovernorTitleType] = []

    // MARK: constructors

    public init(type: GovernorType) {

        self.type = type
        self.titles.append(self.type.defaultTitle())
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(GovernorType.self, forKey: .type)
        self.location = try container.decode(HexPoint.self, forKey: .location)
        self.titles = try container.decode([GovernorTitleType].self, forKey: .titles)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.titles, forKey: .titles)
    }

    public func promote(with title: GovernorTitleType) {

        guard !self.titles.contains(title) else {
            fatalError("cant promote governor with title he/she already has")
        }

        self.titles.append(title)
    }

    public func has(title: GovernorTitleType) -> Bool {

        return self.titles.contains(title)
    }

    public func assign(to cityRef: AbstractCity?) {

        guard let city = cityRef else {
            fatalError("cant get city")
        }

        self.location = city.location
    }

    public func unassign() {

        self.location = HexPoint.invalid
    }

    public func isAssigned() -> Bool {

        return self.location != HexPoint.invalid
    }

    public func possiblePromotions() -> [GovernorTitleType] {

        var promotions: [GovernorTitleType] = []

        for title in self.type.titles() {

            if !self.has(title: title) {

                var hasRequired = true
                for required in title.requiredOr() {
                    if !self.has(title: required) {
                        hasRequired = false
                    }
                }

                if hasRequired {
                    promotions.append(title)
                }
            }
        }

        return promotions
    }
}

public protocol AbstractPlayerGovernors: AnyObject, Codable {

    var player: AbstractPlayer? { get set }

    func addTitle()
    func numTitlesAvailable() -> Int
    func numTitlesSpent() -> Int

    func doTurn(in gameModel: GameModel?)

    func governor(with type: GovernorType) -> Governor?
}

class PlayerGovernors: AbstractPlayerGovernors {

    enum CodingKeys: CodingKey {

        case numTitlesAvailable
        case numTitlesSpent
        case lastEvaluation
        case governors
    }

    // user properties / values
    var player: AbstractPlayer?

    var numTitlesAvailableValue: Int
    var numTitlesSpentValue: Int
    var lastEvaluation: Int

    var governors: [Governor]

    // MARK: constructor

    init(player: Player?) {

        self.player = player
        // ...
        self.numTitlesAvailableValue = 0
        self.numTitlesSpentValue = 0
        self.lastEvaluation = 0

        self.governors = []
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.numTitlesAvailableValue = try container.decode(Int.self, forKey: .numTitlesAvailable)
        self.numTitlesSpentValue = try container.decode(Int.self, forKey: .numTitlesSpent)
        self.lastEvaluation = try container.decode(Int.self, forKey: .lastEvaluation)

        self.governors = try container.decode([Governor].self, forKey: .governors)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.numTitlesAvailableValue, forKey: .numTitlesAvailable)
        try container.encode(self.numTitlesSpentValue, forKey: .numTitlesSpent)
        try container.encode(self.lastEvaluation, forKey: .lastEvaluation)

        try container.encode(self.governors, forKey: .governors)
    }

    // MARK: methods

    func addTitle() {

        self.numTitlesAvailableValue += 1
    }

    func numTitlesAvailable() -> Int {

        return self.numTitlesAvailableValue
    }

    func numTitlesSpent() -> Int {

        return self.numTitlesSpentValue
    }

    func doTurn(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        if self.numTitlesAvailableValue > 0 {

            print("title needs to be spent => notification for human")

            if player.isHuman() {

                let notification = NotificationItem(
                    type: .governorTitleAvailable,
                    for: player.leader,
                    message: "Select governor title usage",
                    summary: "Select governor title usage2",
                    at: HexPoint.invalid,
                    other: .none
                )
                gameModel.userInterface?.add(notification: notification)
            } else {

                self.chooseBestGovernorTitleUsage(in: gameModel)
            }
        }

        // check assignments or re-assignments
        if !player.isHuman() {

            // assign to city + reassign to different city

            // every 20 turns
            if gameModel.currentTurn - self.lastEvaluation > 20 {

                //evaluate the best assignment and do it -
                //score each governor for each city
                //start assigning the best value
                // TODO

                self.lastEvaluation = gameModel.currentTurn
            }
        }
    }

    private func numActiveGovernors(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var numActiveGovernors: Int = 0

        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            if city.governor() != nil {
                numActiveGovernors += 1
            }
        }

        return numActiveGovernors
    }

    private func chooseBestGovernorTitleUsage(in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let numOfCities = gameModel?.cities(of: player).count ?? 0
        let numOfActiveGovernors = self.numActiveGovernors(in: gameModel)

        // appoint new or promote existing governors
        if 0 < numOfActiveGovernors && (numOfCities <= numOfActiveGovernors || numOfActiveGovernors >= GovernorType.all.count) {
            // promote
            self.promoteGovernor()
        } else {
            // appoint
            self.appointGovernor(in: gameModel)
        }
    }

    private func promoteGovernor() {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var possiblePromotions: [GovernorTitleType] = []

        for governor in self.governors {

            possiblePromotions.append(contentsOf: governor.possiblePromotions())
        }

        var bestPromotion: GovernorTitleType? = nil
        var bestValue: Int = Int.min

        for promotion in possiblePromotions {

            var val: Int = 0

            for flavorType in FlavorType.all {
                val += player.personalAndGrandStrategyFlavor(for: flavorType) * promotion.flavor(for: flavorType)
            }

            if val > bestValue {

                bestPromotion = promotion
                bestValue = val
            }
        }

        if let promotion = bestPromotion {

            var didPromote = false

            for governorType in GovernorType.all {
                if governorType.titles().contains(promotion) {

                    if let govenor = self.governors.first(where: { $0.type == governorType }) {

                        govenor.promote(with: promotion)
                        print("did promote \(govenor.type.name()) with \(promotion.name())")
                        didPromote = true
                    }
                }
            }

            guard didPromote else {
                fatalError("did not promote - pls fix me")
            }

        } else {
            fatalError("cant get promotion - pls fix me")
        }
    }

    private func appointGovernor(in gameModel: GameModel?) {

        if let governorType = self.chooseBestNewGovernor() {

            // find best city for this governor
            if let bestCity = self.bestCity(for: governorType, in: gameModel) {

                let governor = Governor(type: governorType)

                self.governors.append(governor)

                // directly assign
                bestCity.assign(governor: governorType)
            } else {
                print("cant get city for best governor: \(governorType.name())")
            }
        } else {
            print("Cant get governor")
        }
    }

    private func bestCity(for governorType: GovernorType, in gameModel: GameModel?) -> AbstractCity? {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var bestCity: AbstractCity?
        var bestValue: Double = Double.min

        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            let value = city.value(of: governorType, in: gameModel)

            if value > bestValue {

                bestCity = cityRef
                bestValue = value
            }
        }

        return bestCity
    }

    private func chooseBestNewGovernor() -> GovernorType? {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var bestGovernorType: GovernorType? = nil
        var bestValue: Int = Int.min

        for governorType in GovernorType.all where !self.governors.contains(where: { $0.type == governorType }) {

            var val = 0

            for flavorType in FlavorType.all {
                val += player.personalAndGrandStrategyFlavor(for: flavorType) * governorType.flavor(for: flavorType)
            }

            if val > bestValue {

                bestGovernorType = governorType
                bestValue = val
            }
        }

        return bestGovernorType
    }

    public func governor(with type: GovernorType) -> Governor? {

        return self.governors.first(where: { $0.type == type })
    }
}
