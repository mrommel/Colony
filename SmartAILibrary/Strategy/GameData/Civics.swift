//
//  Civic.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum CivicError: Error {

    case cantSelectCurrentCivic
    case alreadyDiscovered
}

public protocol AbstractCivics: AnyObject, Codable {

    var player: AbstractPlayer? { get set }

    // civics
    func has(civic: CivicType) -> Bool
    func discover(civic: CivicType, in gameModel: GameModel?) throws

    func currentCultureProgress() -> Double
    func currentCultureTurnsRemaining() -> Int
    func lastCultureInput() -> Double

    func needToChooseCivic() -> Bool
    func possibleCivics() -> [CivicType]
    func setCurrent(civic: CivicType, in gameModel: GameModel?) throws
    func currentCivic() -> CivicType?
    func chooseNextCivic() -> CivicType
    func numberOfDiscoveredCivics() -> Int

    func add(culture: Double)
    func checkCultureProgress(in gameModel: GameModel?) throws

    // eurekas
    func inspirationValue(for civicType: CivicType) -> Int
    func changeInspirationValue(for civicType: CivicType, change: Int)
    func inspirationTriggered(for civicType: CivicType) -> Bool
    func triggerInspiration(for civicType: CivicType, in gameModel: GameModel?)
}

class Civics: AbstractCivics {

    enum CodingKeys: CodingKey {

        case civics
        case currentCivic
        case lastCultureEarned
        case progress

        case inspirations
    }

    // civic tree
    var civics: [CivicType] = []

    // user properties / values
    var player: AbstractPlayer?
    private var currentCivicValue: CivicType?
    var lastCultureEarnedValue: Double = 1.0
    private var progress: WeightedCivicList

    // heureka
    private var inspirations: CivicInspirations

    // MARK: internal types

    class WeightedCivicList: WeightedList<CivicType> {

        override func fill() {

            for techType in CivicType.all {
                self.add(weight: 0, for: techType)
            }
        }
    }

    // MARK: constructor

    init(player: Player?) {

        self.player = player

        self.inspirations = CivicInspirations()
        self.progress = WeightedCivicList()
        self.progress.fill()
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.civics = try container.decode([CivicType].self, forKey: .civics)
        self.currentCivicValue = try container.decodeIfPresent(CivicType.self, forKey: .currentCivic)
        self.lastCultureEarnedValue = try container.decode(Double.self, forKey: .lastCultureEarned)
        self.progress = try container.decode(WeightedCivicList.self, forKey: .progress)
        self.inspirations = try container.decode(CivicInspirations.self, forKey: .inspirations)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.civics, forKey: .civics)
        try container.encode(self.currentCivicValue, forKey: .currentCivic)
        try container.encode(self.lastCultureEarnedValue, forKey: .lastCultureEarned)
        try container.encode(self.progress, forKey: .progress)
        try container.encode(self.inspirations, forKey: .inspirations)
    }

    public func currentCultureProgress() -> Double {

        if let currentCivic = self.currentCivicValue {
            return self.progress.weight(of: currentCivic)
        }

        return 0.0
    }

    private func turnsRemaining(for civicType: CivicType) -> Int {

        if self.lastCultureEarnedValue > 0.0 {

            let cost: Double = Double(civicType.cost())
            let remaining = cost - self.progress.weight(of: civicType)

            return Int(remaining / self.lastCultureEarnedValue + 0.5)
        }

        return 1
    }

    public func currentCultureTurnsRemaining() -> Int {

        if let currentCivic = self.currentCivicValue {
            return self.turnsRemaining(for: currentCivic)
        }

        return 1
    }

    public func lastCultureInput() -> Double {

        return self.lastCultureEarnedValue
    }

    // MARK: manage progress

    func flavorWeighted(of civic: CivicType, for flavor: FlavorType) -> Double {

        guard let player = self.player else {
            return 0.0
        }

        // FIXME
        return Double(civic.flavorValue(for: flavor) * player.leader.flavor(for: flavor))
        // return 0.0
    }

    func has(civic: CivicType) -> Bool {

        return self.civics.contains(civic)
    }

    func discover(civic: CivicType, in gameModel: GameModel?) throws {

        guard let player = self.player else {
            fatalError("Can't discover tech - no player present")
        }

        if self.civics.contains(civic) {
            throw CivicError.alreadyDiscovered
        }

        if civic.hasGovernorTitle() {
            self.player?.addGovernorTitle()
        }

        if civic.envoys() > 0 {
            player.changeUnassignedEnvoys(by: civic.envoys())

            // notify player about envoy to spend
            if player.isHuman() {
                player.notifications()?.add(notification: .envoyEarned)
            }
        }

        // check if this civic is the first of a new era
        let civicsInEra = self.civics.count(where: { $0.era() == civic.era() })
        if civicsInEra == 0 && civic.era() != .ancient {

            guard let gameModel = gameModel else {
                fatalError("cant get game")
            }

            if gameModel.anyHasMoment(of: .worldsFirstCivicOfNewEra(eraType: civic.era())) {
                self.player?.addMoment(of: .firstCivicOfNewEra(eraType: civic.era()), in: gameModel)
            } else {
                self.player?.addMoment(of: .worldsFirstCivicOfNewEra(eraType: civic.era()), in: gameModel)
            }
        }

        self.updateInspirations(in: gameModel)

        // check quests
        for quest in player.ownQuests(in: gameModel) {

            if case .triggerInspiration(civic: let questCivicType) = quest.type {
                if questCivicType == civic {
                    if let cityStatePlayer = gameModel?.cityStatePlayer(for: quest.cityState) {
                        cityStatePlayer.obsoleteQuest(by: player.leader, in: gameModel)
                    }
                }
            }
        }

        // send gossip
        gameModel?.sendGossip(type: .civicCompleted(civic: civic), of: self.player)

        self.civics.append(civic)

        self.player?.doUpdateTradeRouteCapacity(in: gameModel)

        // 
        if civic == .naturalHistory || civic == .culturalHeritage {

            gameModel?.checkArchaeologySites()
        }
    }

    func updateInspirations(in gameModel: GameModel?) {

        // NOOP
    }

    func needToChooseCivic() -> Bool {

        return self.currentCivicValue == nil
    }

    func currentCivic() -> CivicType? {

        return self.currentCivicValue
    }

    func setCurrent(civic: CivicType, in gameModel: GameModel?) throws {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("Can't add science - no player present")
        }

        if !self.possibleCivics().contains(civic) {
            throw CivicError.cantSelectCurrentCivic
        }

        self.currentCivicValue = civic

        if player.isHuman() {
            gameModel.userInterface?.select(civic: civic)
        }
    }

    func possibleCivics() -> [CivicType] {

        var returnCivics: [CivicType] = []

        for civic in CivicType.all {

            if self.has(civic: civic) {
                continue
            }

            var allRequiredPresent = true

            for req in civic.required() {

                if !self.has(civic: req) {
                    allRequiredPresent = false
                }
            }

            if allRequiredPresent {
                returnCivics.append(civic)
            }
        }

        return returnCivics
    }

    func add(culture: Double) {

        if let currentCivic = self.currentCivicValue {
            self.progress.add(weight: culture, for: currentCivic)
        }
        self.lastCultureEarnedValue = culture
    }

    func chooseNextCivic() -> CivicType {

        let weightedCivics: WeightedCivicList = WeightedCivicList()
        let possibleCivicsList = self.possibleCivics()

        weightedCivics.items.removeAll()

        for possibleCivic in possibleCivicsList {

            var weightByFlavor = 0.0

            // weight of current tech
            for flavor in FlavorType.all {
                weightByFlavor += flavorWeighted(of: possibleCivic, for: flavor)
            }

            // add techs that can be research with this tech, but only with a little less weight
            for activatedCivic in possibleCivic.leadsTo() {

                for flavor in FlavorType.all {
                    weightByFlavor += (flavorWeighted(of: activatedCivic, for: flavor) * 0.75)
                }

                for secondActivatedCivic in activatedCivic.leadsTo() {

                    for flavor in FlavorType.all {
                        weightByFlavor += (flavorWeighted(of: secondActivatedCivic, for: flavor) * 0.5)
                    }

                    for thirdActivatedCivic in secondActivatedCivic.leadsTo() {

                        for flavor in FlavorType.all {
                            weightByFlavor += (flavorWeighted(of: thirdActivatedCivic, for: flavor) * 0.25)
                        }
                    }
                }
            }

            // revalue based on cost / number of turns
            let numberOfTurnsLeft = self.turnsRemaining(for: possibleCivic)
            let additionalTurnCostFactor = 0.015 * Double(numberOfTurnsLeft)
            let totalCostFactor = 0.15 + additionalTurnCostFactor
            let weightDivisor = pow(Double(numberOfTurnsLeft), totalCostFactor)

            // modify weight
            weightByFlavor = Double(weightByFlavor) / weightDivisor

            weightedCivics.add(weight: weightByFlavor, for: possibleCivic)
        }

        // select one
        if let selectedCivic = weightedCivics.chooseFromTopChoices() {
            return selectedCivic
        }

        fatalError("cant get civic - not gonna happen")
    }

    func numberOfDiscoveredCivics() -> Int {

        var number = 0

        for civic in CivicType.all {
            if self.has(civic: civic) {
                number += 1
            }
        }

        return number
    }

    func checkCultureProgress(in gameModel: GameModel?) throws {

        guard let player = self.player else {
            fatalError("Can't add culture - no player present")
        }

        guard let currentCivic = self.currentCivicValue else {

            if !player.isHuman() {
                let bestCivic = self.chooseNextCivic()
                try self.setCurrent(civic: bestCivic, in: gameModel)
            }

            return
        }

        if self.currentCultureProgress() >= Double(currentCivic.cost()) {

            do {
                try self.discover(civic: currentCivic, in: gameModel)

                // trigger event to user
                if player.isHuman() {
                    gameModel?.userInterface?.showPopup(popupType: .civicDiscovered(civic: currentCivic))
                }

                // enter era
                if currentCivic.era() > player.currentEra() {

                    gameModel?.enter(era: currentCivic.era(), for: player)
                    player.set(era: currentCivic.era(), in: gameModel)

                    if player.isHuman() {
                        gameModel?.userInterface?.showPopup(popupType: .eraEntered(era: currentCivic.era()))
                    }
                }

                self.currentCivicValue = nil

                if player.isHuman() {
                    self.player?.notifications()?.add(notification: .civicNeeded)
                }

                player.set(canChangeGovernment: true)

            } catch {
                fatalError("Can't discover civic - already discovered")
            }
        }
    }

    func inspirationValue(for civicType: CivicType) -> Int {

        return Int(self.inspirations.inspirationCounter.weight(of: civicType))
    }

    func changeInspirationValue(for civicType: CivicType, change: Int) {

        self.inspirations.inspirationCounter.add(weight: change, for: civicType)
    }

    func inspirationTriggered(for civicType: CivicType) -> Bool {

        return self.inspirations.inspirationTrigger.triggered(for: civicType)
    }

    func triggerInspiration(for civicType: CivicType, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("Can't trigger eureka - no player present")
        }

        // check if eureka is still needed
        if self.has(civic: civicType) {
            return
        }

        // check if already active
        if self.inspirationTriggered(for: civicType) {
            return
        }

        self.inspirations.inspirationTrigger.trigger(for: civicType)

        // update progress
        var inspirationBoost = 0.5

        // penBrushAndVoice + golden - Inspiration [Inspiration] provide an additional 10% of Civic costs.
        if player.currentAge() == .golden && player.has(dedication: .penBrushAndVoice) {
            inspirationBoost += 0.1
        }

        self.progress.add(weight: Double(civicType.cost()) * inspirationBoost, for: civicType)

        // penBrushAndVoice + normal - Gain +1 Era Score when you trigger an [Inspiration] Inspiration
        if player.currentAge() == .normal && player.has(dedication: .penBrushAndVoice) {
            player.addMoment(of: .dedicationTriggered(dedicationType: .penBrushAndVoice), in: gameModel)
        }

        // check quests
        for quest in player.ownQuests(in: gameModel) {

            if case .triggerInspiration(civic: let questCivicType) = quest.type {

                if civicType == questCivicType {
                    let cityStatePlayer = gameModel?.cityStatePlayer(for: quest.cityState)
                    cityStatePlayer?.fulfillQuest(by: player.leader, in: gameModel)
                }
            }
        }

        // trigger event to user
        if player.isHuman() {
            gameModel?.userInterface?.showPopup(popupType: .inspirationTriggered(civic: civicType))
        }
    }
}
