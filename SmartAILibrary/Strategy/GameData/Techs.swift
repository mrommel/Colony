//
//  Tech.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractTechs {

    // techs
    func has(tech: TechType) -> Bool
    func discover(tech: TechType) throws

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

    // tech tree
    var techs: [TechType] = []

    // user properties / values
    var player: Player?
    private var currentTechValue: TechType? = nil
    var lastScienceEarnedValue: Double = 1.0
    private var progress: WeightedTechList

    // heureka
    private var eurekas: Eurekas

    // MARK: internal types

    class WeightedTechList: WeightedList<TechType> {

        override func fill() {

            for techType in TechType.all {
                self.add(weight: 0, for: techType)
            }
        }

        func sortByWeight() {

            self.items.sort { $0.weight > $1.weight }
        }
    }

    private class Eurekas {

        var eurekaCounter: EurekaCounterList
        var eurakaTrigger: EurekaTriggeredList

        class EurekaCounterList: WeightedList<TechType> {

            override func fill() {

                for techType in TechType.all {
                    self.add(weight: 0, for: techType)
                }
            }
        }

        class EurekaTriggeredList: WeightedList<TechType> {

            override func fill() {

                for techType in TechType.all {
                    self.add(weight: 0, for: techType)
                }
            }

            func trigger(for techType: TechType) {

                self.set(weight: 1.0, for: techType)
            }

            func triggered(for techType: TechType) -> Bool {

                return self.weight(of: techType) > 0.0
            }
        }

        init() {
            self.eurekaCounter = EurekaCounterList()
            self.eurekaCounter.fill()

            self.eurakaTrigger = EurekaTriggeredList()
            self.eurakaTrigger.fill()
        }

        func triggered(for tech: TechType) -> Bool {

            return self.eurakaTrigger.triggered(for: tech)
        }
    }

    // MARK: constructor

    init(player: Player?) {

        self.player = player

        self.eurekas = Eurekas()
        self.progress = WeightedTechList()
        self.progress.fill()
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

        weightedTechs.sortByWeight()
        let selectedTech = weightedTechs.items[selectedIndex].itemType

        return selectedTech
    }

    // MARK: manage tech tree

    func has(tech: TechType) -> Bool {

        return self.techs.contains(tech)
    }

    func discover(tech: TechType) throws {

        if self.techs.contains(tech) {
            throw TechError.alreadyDiscovered
        }

        self.techs.append(tech)
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

        // check if already active
        if self.eurekaTriggered(for: techType) {
            return
        }

        self.eurekas.eurakaTrigger.trigger(for: techType)

        // update progress
        self.progress.add(weight: Double(techType.cost()) * 0.5, for: techType)

        // trigger event to user
        if player.isHuman() {
            gameModel?.userInterface?.showPopup(popupType: .eurekaActivated, with: PopupData(tech: techType))
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
                try self.discover(tech: currentTech)

                // trigger event to user
                if player.isHuman() {
                    gameModel?.userInterface?.showPopup(popupType: .techDiscovered, with: PopupData(tech: currentTech))
                    
                    self.player?.notifications()?.add(type: .techNeeded, for: self.player, message: "Please choose a new Research", summary: "Choose Research", at: HexPoint.zero)
                }

                // enter era
                if currentTech.era() > player.currentEra() {

                    gameModel?.enter(era: currentTech.era(), for: player)

                    if player.isHuman() {
                        gameModel?.userInterface?.showPopup(popupType: .eraEntered, with: PopupData(era: currentTech.era()))
                    }

                    player.set(era: currentTech.era())
                }

                self.currentTechValue = nil

            } catch {
                fatalError("Can't discover science - already discovered")
            }
        }
    }
}
