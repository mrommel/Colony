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

public protocol AbstractCivics {

    // civics
    func has(civic: CivicType) -> Bool
    func discover(civic: CivicType) throws

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
    func eurekaValue(for civicType: CivicType) -> Int
    func changeEurekaValue(for civicType: CivicType, change: Int)
    func eurekaTriggered(for civicType: CivicType) -> Bool
    func triggerEureka(for civicType: CivicType, in gameModel: GameModel?)
}

class Civics: AbstractCivics {

    // civic tree
    var civics: [CivicType] = []

    // user properties / values
    var player: Player?
    private var currentCivicValue: CivicType? = nil
    var lastCultureEarnedValue: Double = 1.0
    private var progress: WeightedCivicList

    // heureka
    private var eurekas: Eurekas

    // MARK: internal types

    class WeightedCivicList: WeightedList<CivicType> {

        override func fill() {

            for techType in CivicType.all {
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

        class EurekaCounterList: WeightedList<CivicType> {

            override func fill() {

                for civicType in CivicType.all {
                    self.add(weight: 0, for: civicType)
                }
            }
        }

        class EurekaTriggeredList: WeightedList<CivicType> {

            override func fill() {

                for civicType in CivicType.all {
                    self.add(weight: 0, for: civicType)
                }
            }

            func trigger(for civicType: CivicType) {

                self.set(weight: 1.0, for: civicType)
            }

            func triggered(for civicType: CivicType) -> Bool {

                return self.weight(of: civicType) > 0.0
            }
        }

        init() {
            self.eurekaCounter = EurekaCounterList()
            self.eurekaCounter.fill()

            self.eurakaTrigger = EurekaTriggeredList()
            self.eurakaTrigger.fill()
        }

        func triggered(for civic: CivicType) -> Bool {

            return self.eurakaTrigger.triggered(for: civic)
        }
    }

    // MARK: constructor

    init(player: Player?) {

        self.player = player

        self.eurekas = Eurekas()
        self.progress = WeightedCivicList()
        self.progress.fill()
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
        //return 0.0
    }

    func has(civic: CivicType) -> Bool {

        return self.civics.contains(civic)
    }

    func discover(civic: CivicType) throws {

        if self.civics.contains(civic) {
            throw CivicError.alreadyDiscovered
        }

        self.civics.append(civic)
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
        let numberOfSelectable = min(3, possibleCivicsList.count)
        let selectedIndex = Int.random(number: numberOfSelectable)

        weightedCivics.sortByWeight()
        let selectedTech = weightedCivics.items[selectedIndex].itemType

        return selectedTech
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
                try self.discover(civic: currentCivic)

                // trigger event to user
                if player.isHuman() {
                    gameModel?.userInterface?.showPopup(popupType: .civicDiscovered, with: PopupData(civic: currentCivic))
                }

                // enter era
                if currentCivic.era() > player.currentEra() {

                    gameModel?.enter(era: currentCivic.era(), for: player)
                    
                    if player.isHuman() {
                        gameModel?.userInterface?.showPopup(popupType: .eraEntered, with: PopupData(era: currentCivic.era()))
                    }
                    
                    player.set(era: currentCivic.era())
                }

                self.currentCivicValue = nil

            } catch {
                fatalError("Can't discover civic - already discovered")
            }
        }
    }

    func eurekaValue(for civicType: CivicType) -> Int {

        return Int(self.eurekas.eurekaCounter.weight(of: civicType))
    }

    func changeEurekaValue(for civicType: CivicType, change: Int) {

        self.eurekas.eurekaCounter.add(weight: change, for: civicType)
    }

    func eurekaTriggered(for civicType: CivicType) -> Bool {

        return self.eurekas.eurakaTrigger.triggered(for: civicType)
    }

    func triggerEureka(for civicType: CivicType, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("Can't trigger eureka - no player present")
        }
        
        // check if already active
        if self.eurekaTriggered(for: civicType) {
            return
        }
        
        self.eurekas.eurakaTrigger.trigger(for: civicType)
        
        // update progress
        self.progress.add(weight: Double(civicType.cost()) * 0.5, for: civicType)
        
        // trigger event to user
        if player.isHuman() {
            gameModel?.userInterface?.showPopup(popupType: .eurekaActivated, with: PopupData(civic: civicType))
        }
    }
}
