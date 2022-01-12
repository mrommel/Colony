//
//  PlayerGovernors.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractPlayerGovernors: AnyObject, Codable {

    var player: AbstractPlayer? { get set }

    func addTitle()
    func numTitlesAvailable() -> Int
    func numTitlesSpent() -> Int

    func doTurn(in gameModel: GameModel?)

    func governor(with type: GovernorType) -> Governor?

    func appoint(governor governorType: GovernorType, in gameModel: GameModel?)
    func promote(governor: Governor?, with title: GovernorTitleType, in gameModel: GameModel?)
    func assign(governor: Governor?, to selectedCity: AbstractCity?, in gameModel: GameModel?)
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

                player.notifications()?.add(notification: .governorTitleAvailable)
            } else {

                self.chooseBestGovernorTitleUsage(in: gameModel)
            }
        }

        // check assignments or re-assignments
        if !player.isHuman() {

            // every 20 turns
            if gameModel.currentTurn - self.lastEvaluation > 20 {

                // assign to city + reassign to different city
                self.reassignGovernors(in: gameModel)

                self.lastEvaluation = gameModel.currentTurn
            }
        }
    }

    // evaluate the best assignment and do it:
    //   score each governor for each city
    //   start assigning the best value
    private func reassignGovernors(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var cityLocations: [HexPoint] = gameModel.cities(of: player).map { $0?.location ?? HexPoint.invalid }
        var reassigned: Bool = false

        for governor in self.governors {

            var bestLocation: HexPoint = HexPoint.invalid
            var bestValue: Double = Double.min

            for cityLocation in cityLocations {

                guard let city = gameModel.city(at: cityLocation) else {
                    continue
                }

                let value = city.value(of: governor.type, in: gameModel)

                if value > bestValue {

                    bestValue = value
                    bestLocation = cityLocation
                }
            }

            guard bestLocation != HexPoint.invalid else {
                fatalError("Could not find a city location for \(governor.type)")
            }

            cityLocations.removeAll(where: { $0 == bestLocation })

            guard let bestCity = gameModel.city(at: bestLocation) else {
                fatalError("cant get best coty")
            }

            guard governor.assignedCity(in: gameModel)?.location != bestLocation else {
                print("\(player.leader.name()) decided to let governor \(governor.type.name()) stay in city \(bestCity.name)")
                continue
            }

            reassigned = true

            bestCity.assign(governor: .none)
            governor.unassign()

            bestCity.assign(governor: governor.type)
            governor.assign(to: bestCity)

            print("\(player.leader.name()) assigned governor \(governor.type.name()) to city \(bestCity.name)")
        }

        if !reassigned {
            print("\(player.leader.name()) did no reassignments fo governors")
        }
    }

    public func appoint(governor governorType: GovernorType, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard self.numTitlesAvailableValue > 0 else {
            fatalError("try to appoint a governor without available titles")
        }

        let governor = Governor(type: governorType)
        self.governors.append(governor)

        self.numTitlesSpentValue += 1
        self.numTitlesAvailableValue -= 1

        if self.governors.count == GovernorType.all.count && !player.hasMoment(of: .allGovernorsAppointed) {
            self.player?.addMoment(of: .allGovernorsAppointed, in: gameModel)
        }
    }

    public func promote(governor: Governor?, with title: GovernorTitleType, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard self.numTitlesAvailableValue > 0 else {
            fatalError("try to promote a governor without available titles")
        }

        governor?.promote(with: title)

        if governor?.titles.count == 6 && !player.hasMoment(of: .governorFullyPromoted) {
            player.addMoment(of: .governorFullyPromoted, in: gameModel)
        }

        self.numTitlesSpentValue += 1
        self.numTitlesAvailableValue -= 1
    }

    // and remove from any previous city
    public func assign(governor: Governor?, to selectedCity: AbstractCity?, in gameModel: GameModel?) {

        governor?.assignedCity(in: gameModel)?.assign(governor: .none)
        governor?.unassign()

        selectedCity?.assign(governor: governor?.type)
        governor?.assign(to: selectedCity)
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

    // AI function
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

    // AI function
    private func promoteGovernor() {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var possiblePromotions: [GovernorTitleType] = []

        for governor in self.governors {

            possiblePromotions.append(contentsOf: governor.possiblePromotions())
        }

        var bestPromotion: GovernorTitleType?
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

                        self.numTitlesSpentValue += 1
                        self.numTitlesAvailableValue -= 1
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

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        if let governorType = self.chooseBestNewGovernor() {

            // find best city for this governor
            if let bestCity = self.bestCity(for: governorType, in: gameModel) {

                let governor = Governor(type: governorType)

                self.governors.append(governor)

                if self.governors.count == GovernorType.all.count {
                    self.player?.addMoment(of: .allGovernorsAppointed, in: gameModel)
                }

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

        var bestGovernorType: GovernorType?
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
