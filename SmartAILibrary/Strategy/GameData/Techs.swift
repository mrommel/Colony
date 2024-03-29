//
//  Tech.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractTechs: AnyObject, Codable {

    var player: AbstractPlayer? { get set }

    // techs
    func has(tech: TechType) -> Bool
    func discover(tech: TechType, in gameModel: GameModel?) throws

    func currentScienceProgress() -> Double
    func currentScienceTurnsRemaining() -> Int
    func lastScienceEarned() -> Double

    func needToChooseTech() -> Bool
    func possibleTechs() -> [TechType]
    func setCurrent(tech: TechType, in gameModel: GameModel?) throws
    func currentTech() -> TechType?

    func numberOfDiscoveredTechs() -> Int

    func add(science: Double)
    func chooseNextTech() -> TechType

    func checkScienceProgress(in gameModel: GameModel?) throws

    // eurekas
    func eurekaValue(for techType: TechType) -> Int
    func changeEurekaValue(for techType: TechType, change: Int)
    func eurekaTriggered(for techType: TechType) -> Bool
    func triggerEureka(for techType: TechType, in gameModel: GameModel?)
}

enum TechError: Error {

    case cantSelectCurrentTech
    case alreadyDiscovered
}

class Techs: AbstractTechs {

    enum CodingKeys: CodingKey {

        case techs
        case currentTech
        case lastScienceEarned
        case progress

        case eurekas
    }

    // tech tree
    var techs: [TechType] = []

    // user properties / values
    var player: AbstractPlayer?
    private var currentTechValue: TechType?
    var lastScienceEarnedValue: Double = 1.0
    private var progress: WeightedTechList

    // heureka
    private var eurekas: TechEurekas

    // MARK: internal types

    class WeightedTechList: WeightedList<TechType> {

        override func fill() {

            for techType in TechType.all {
                self.add(weight: 0, for: techType)
            }
        }
    }

    // MARK: constructor

    init(player: Player?) {

        self.player = player

        self.eurekas = TechEurekas()
        self.progress = WeightedTechList()
        self.progress.fill()
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.techs = try container.decode([TechType].self, forKey: .techs)
        self.currentTechValue = try container.decodeIfPresent(TechType.self, forKey: .currentTech)
        self.lastScienceEarnedValue = try container.decode(Double.self, forKey: .lastScienceEarned)
        self.progress = try container.decode(WeightedTechList.self, forKey: .progress)
        self.eurekas = try container.decode(TechEurekas.self, forKey: .eurekas)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.techs, forKey: .techs)
        try container.encode(self.currentTechValue, forKey: .currentTech)
        try container.encode(self.lastScienceEarnedValue, forKey: .lastScienceEarned)
        try container.encode(self.progress, forKey: .progress)
        try container.encode(self.eurekas, forKey: .eurekas)
    }

    public func currentScienceProgress() -> Double {

        if let currentTech = self.currentTechValue {
            return self.progress.weight(of: currentTech)
        }

        return 0.0
    }

    private func turnsRemaining(for techType: TechType) -> Int {

        if self.lastScienceEarnedValue > 0.0 {

            let cost: Double = Double(techType.cost())
            let remaining = cost - self.progress.weight(of: techType)

            return Int(remaining / self.lastScienceEarnedValue + 0.5)
        }

        return 1
    }

    public func currentScienceTurnsRemaining() -> Int {

        if let currentTech = self.currentTechValue {
            return self.turnsRemaining(for: currentTech)
        }

        return 1
    }

    public func lastScienceEarned() -> Double {

        return self.lastScienceEarnedValue
    }

    // MARK: manage progress

    func flavorWeighted(of tech: TechType, for flavor: FlavorType) -> Double {

        guard let player = self.player else {
            return 0.0
        }

        return Double(tech.flavorValue(for: flavor) * player.leader.flavor(for: flavor))
    }

    func chooseNextTech() -> TechType {

        let weightedTechs: WeightedTechList = WeightedTechList()
        let possibleTechsList = self.possibleTechs()

        weightedTechs.items.removeAll()

        for possibleTech in possibleTechsList {

            var weightByFlavor = 0.0

            // weight of current tech
            for flavor in FlavorType.all {
                weightByFlavor += flavorWeighted(of: possibleTech, for: flavor)
            }

            // add techs that can be research with this tech, but only with a little less weight
            for activatedTech in possibleTech.leadsTo() {

                for flavor in FlavorType.all {
                    weightByFlavor += (flavorWeighted(of: activatedTech, for: flavor) * 0.75)
                }

                for secondActivatedTech in activatedTech.leadsTo() {

                    for flavor in FlavorType.all {
                        weightByFlavor += (flavorWeighted(of: secondActivatedTech, for: flavor) * 0.5)
                    }

                    for thirdActivatedTech in secondActivatedTech.leadsTo() {

                        for flavor in FlavorType.all {
                            weightByFlavor += (flavorWeighted(of: thirdActivatedTech, for: flavor) * 0.25)
                        }
                    }
                }
            }

            // revalue based on cost / number of turns
            let numberOfTurnsLeft = self.turnsRemaining(for: possibleTech)
            let additionalTurnCostFactor = 0.015 * Double(numberOfTurnsLeft)
            let totalCostFactor = 0.15 + additionalTurnCostFactor
            let weightDivisor = pow(Double(numberOfTurnsLeft), totalCostFactor)

            // modify weight
            weightByFlavor = Double(weightByFlavor) / weightDivisor

            weightedTechs.add(weight: weightByFlavor, for: possibleTech)
        }

        // select one
        let numberOfSelectable = min(3, possibleTechsList.count)
        let selectedIndex = Int.random(number: numberOfSelectable)

        let weightedTechsArray: [(TechType, Double)] = weightedTechs.items.sortedByValue.reversed()
        let selectedTech = weightedTechsArray[selectedIndex].0

        return selectedTech
    }

    // MARK: manage tech tree

    func has(tech: TechType) -> Bool {

        return self.techs.contains(tech)
    }

    func discover(tech: TechType, in gameModel: GameModel?) throws {

        guard let player = self.player else {
            fatalError("Can't discover tech - no player present")
        }

        if self.techs.contains(tech) {
            throw TechError.alreadyDiscovered
        }

        // check if this tech is the first of a new era
        let techsInEra = self.techs.count(where: { $0.era() == tech.era() })
        if techsInEra == 0 && tech.era() != .ancient {

            guard let gameModel = gameModel else {
                fatalError("cant get game")
            }

            if gameModel.anyHasMoment(of: .worldsFirstTechnologyOfNewEra(eraType: tech.era())) {
                self.player?.addMoment(of: .firstTechnologyOfNewEra(eraType: tech.era()), in: gameModel)
            } else {
                self.player?.addMoment(of: .worldsFirstTechnologyOfNewEra(eraType: tech.era()), in: gameModel)
            }
        }

        self.updateEurekas(in: gameModel)

        // check quests
        for quest in player.ownQuests(in: gameModel) {

            guard let gameModel = gameModel else {
                fatalError("cant get game")
            }

            if case .trainUnit(type: let unitType) = quest.type {
                var obsolete = false

                for upgradeUnitType in unitType.upgradesTo() {
                    if let requiredTech = upgradeUnitType.requiredTech() {
                        if requiredTech == tech {
                            obsolete = true
                        }
                    }
                }

                if let obsoleteTech = unitType.obsoleteTech() {
                    if obsoleteTech == tech {
                        obsolete = true
                    }
                }

                if obsolete {
                    if let cityStatePlayer = gameModel.cityStatePlayer(for: quest.cityState) {
                        cityStatePlayer.obsoleteQuest(by: player.leader, in: gameModel)
                    }
                }
            }

            if case .triggerEureka(tech: let questTechType) = quest.type {
                if questTechType == tech {
                    if let cityStatePlayer = gameModel.cityStatePlayer(for: quest.cityState) {
                        cityStatePlayer.obsoleteQuest(by: player.leader, in: gameModel)
                    }
                }
            }
        }

        // send gossip
        gameModel?.sendGossip(type: .technologyResearched(tech: tech), of: self.player)

        // check for printing
        // Researching the Printing technology. This will increase your visibility with all civilizations by one level.
        if tech == .printing {
            guard let gameModel = gameModel else {
                fatalError("cant get game")
            }

            for loopPlayer in gameModel.players {

                guard !loopPlayer.isBarbarian() && !loopPlayer.isFreeCity() && !loopPlayer.isCityState() else {
                    continue
                }

                guard !loopPlayer.isEqual(to: player) else {
                    continue
                }

                if player.hasMet(with: loopPlayer) {
                    player.diplomacyAI?.increaseAccessLevel(towards: loopPlayer)
                }
            }
        }

        self.techs.append(tech)
    }

    private func updateEurekas(in gameModel: GameModel?) {

        guard let civics = self.player?.civics else {
            fatalError("cant get civics")
        }

        // Games and Recreation - Research the Construction technology.
        if self.has(tech: .construction) {
            if !civics.inspirationTriggered(for: .gamesAndRecreation) {
                civics.triggerInspiration(for: .gamesAndRecreation, in: gameModel)
            }
        }

        // Mass Media - Research Radio.
        if self.has(tech: .radio) {
            if !civics.inspirationTriggered(for: .massMedia) {
                civics.triggerInspiration(for: .massMedia, in: gameModel)
            }
        }
    }

    func needToChooseTech() -> Bool {

        return self.currentTechValue == nil
    }

    func currentTech() -> TechType? {

        return self.currentTechValue
    }

    func eurekaValue(for techType: TechType) -> Int {

        return Int(self.eurekas.eurekaCounter.weight(of: techType))
    }

    func changeEurekaValue(for techType: TechType, change: Int) {

        self.eurekas.eurekaCounter.add(weight: change, for: techType)
    }

    func eurekaTriggered(for techType: TechType) -> Bool {

        return self.eurekas.eurakaTrigger.triggered(for: techType)
    }

    func triggerEureka(for techType: TechType, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("Can't trigger eurake - no player present")
        }

        // check if eureka is still needed
        if self.has(tech: techType) {
            return
        }

        // check if eureka is already active
        if self.eurekaTriggered(for: techType) {
            return
        }

        self.eurekas.eurakaTrigger.trigger(for: techType)

        // update progress
        var eurekaBoost = 0.5

        // freeInquiry + golden - [Eureka] Eureka provide an additional 10% of Technology costs.
        if player.currentAge() == .golden && player.has(dedication: .freeInquiry) {
            eurekaBoost += 0.1
        }

        self.progress.add(weight: Double(techType.cost()) * eurekaBoost, for: techType)

        // freeInquiry + normal - Gain +1 Era Score when you trigger a [Eureka] Eureka
        if player.currentAge() == .normal && player.has(dedication: .freeInquiry) {
            player.addMoment(of: .dedicationTriggered(dedicationType: .freeInquiry), in: gameModel)
        }

        // check quests
        for quest in player.ownQuests(in: gameModel) {

            if case .triggerEureka(tech: let questTechType) = quest.type {

                if techType == questTechType {
                    let cityStatePlayer = gameModel?.cityStatePlayer(for: quest.cityState)
                    cityStatePlayer?.fulfillQuest(by: player.leader, in: gameModel)
                }
            }
        }

        // trigger event to user
        if player.isHuman() {
            gameModel?.userInterface?.showPopup(popupType: .eurekaTriggered(tech: techType))
        }
    }

    func numberOfDiscoveredTechs() -> Int {

        var number = 0

        for tech in TechType.all {
            if self.has(tech: tech) {
                number += 1
            }
        }

        return number
    }

    func setCurrent(tech: TechType, in gameModel: GameModel?) throws {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("Can't add science - no player present")
        }

        if !self.possibleTechs().contains(tech) {
            throw TechError.cantSelectCurrentTech
        }

        self.currentTechValue = tech

        if player.isHuman() {
            gameModel.userInterface?.select(tech: tech)
        }
    }

    func possibleTechs() -> [TechType] {

        var returnTechs: [TechType] = []

        for tech in TechType.all {

            if self.has(tech: tech) {
                continue
            }

            var allRequiredPresent = true

            for req in tech.required() {

                if !self.has(tech: req) {
                    allRequiredPresent = false
                }
            }

            if allRequiredPresent {
                returnTechs.append(tech)
            }
        }

        return returnTechs
    }

    func add(science: Double) {

        if let currentTech = self.currentTechValue {
            self.progress.add(weight: science, for: currentTech)
        }
        self.lastScienceEarnedValue = science
    }

    func checkScienceProgress(in gameModel: GameModel?) throws {

        guard let player = self.player else {
            fatalError("Can't add science - no player present")
        }

        guard let currentTech = self.currentTechValue else {

            if !player.isHuman() {
                let bestTech = chooseNextTech()
                try self.setCurrent(tech: bestTech, in: gameModel)
            }

            return
        }

        if self.currentScienceProgress() >= Double(currentTech.cost()) {

            do {
                try self.discover(tech: currentTech, in: gameModel)

                // trigger event to user
                if player.isHuman() {
                    gameModel?.userInterface?.showPopup(popupType: .techDiscovered(tech: currentTech))
                }

                // enter era
                if currentTech.era() > player.currentEra() {

                    gameModel?.enter(era: currentTech.era(), for: player)
                    player.set(era: currentTech.era(), in: gameModel)

                    if player.isHuman() {
                        gameModel?.userInterface?.showPopup(popupType: .eraEntered(era: currentTech.era()))
                    }
                }

                self.currentTechValue = nil

                if player.isHuman() {
                    self.player?.notifications()?.add(notification: .techNeeded)
                }

            } catch {
                fatalError("Can't discover science - already discovered")
            }
        }
    }
}
