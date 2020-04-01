//
//  Tech.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

protocol AbstractTechs {
    
    // techs
    func has(tech: TechType) -> Bool
    func discover(tech: TechType) throws
    
    func needToChooseTech() -> Bool
    func possibleTechs() -> [TechType]
    func setCurrent(tech: TechType) throws
    func currentTech() -> TechType?
    func numberOfDiscoveredTechs() -> Int
    
    func add(science: Double)
    func chooseNextTech() -> TechType
    
    func checkScienceProgress(in gameModel: GameModel?) throws
    
    // eurekas
    func eurekaValue(for techType: TechType) -> Int
    func changeEurekaValue(for techType: TechType, change: Int)
    func eurekaTriggered(for techType: TechType) -> Bool
    func triggerEureka(for techType: TechType)
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
    private var currentTechVal: TechType? = nil
    var currentProgress: Double = 0.0
    var lastScienceEarned: Double = 1.0
    
    // heureka
    private var eurekas: Eurekas
    
    // MARK: internal types
    
    class WeightedTechs {
        
        var techs: [WeightedTech]
        
        struct WeightedTech {
            let tech: TechType
            let value: Double
        }
        
        init() {
            self.techs = []
        }
        
        func add(tech: TechType, with weight: Double) {
            self.techs.append(WeightedTech(tech: tech, value: weight))
        }
        
        func sortByWeight() {
            
            self.techs.sort { $0.value > $1.value }
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
    }
    
    // MARK: manage progress
    
    func flavorWeighted(of tech: TechType, for flavor: FlavorType) -> Double {
        
        guard let player = self.player else {
            return 0.0
        }
        
        return Double(tech.flavorValue(for: flavor) * player.leader.flavor(for: flavor))
    }
    
    func chooseNextTech() -> TechType {
        
        let weightedTechs: WeightedTechs = WeightedTechs()
        let possibleTechsList = self.possibleTechs()
        
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
            let cost = self.cost(of: possibleTech)
            let numberOfTurnsLeft = cost / self.lastScienceEarned
            let additionalTurnCostFactor = 0.015 * Double(numberOfTurnsLeft)
            let totalCostFactor = 0.15 + additionalTurnCostFactor
            let weightDivisor = pow(Double(numberOfTurnsLeft), totalCostFactor)
            
            // modify weight
            weightByFlavor = Double(weightByFlavor) / weightDivisor
            
            weightedTechs.add(tech: possibleTech, with: weightByFlavor)
        }
        
        // select one
        let numberOfSelectable = min(3, possibleTechsList.count)
        let selectedIndex = Int.random(number: numberOfSelectable)
        
        weightedTechs.sortByWeight()
        let selectedTech = weightedTechs.techs[selectedIndex].tech
        
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
        
        return self.currentTechVal == nil
    }
    
    func currentTech() -> TechType? {
        
        return self.currentTechVal
    }
    
    private func cost(of techType: TechType) -> Double {
        
        var costValue = Double(techType.cost())
    
        // eureka gives 50% off
        if self.eurekas.triggered(for: techType) {
            costValue /= 2.0
        }
        
        return costValue
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
    
    func triggerEureka(for techType: TechType) {
        
        self.eurekas.eurakaTrigger.trigger(for: techType)
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
    
    func setCurrent(tech: TechType) throws {
        
        if !self.possibleTechs().contains(tech) {
            throw TechError.cantSelectCurrentTech
        }
        
        self.currentTechVal = tech
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
        
        self.currentProgress += science
        self.lastScienceEarned = science
    }
    
    func checkScienceProgress(in gameModel: GameModel?) throws {
        
        guard let player = self.player else {
            fatalError("Can't add science - no player present")
        }
        
        guard let currentTech = self.currentTechVal else {
            
            if player.isHuman() {
                gameModel?.add(message: PlayerNeedsTechSelectionMessage())
            } else {
                let bestTech = chooseNextTech()
                try self.setCurrent(tech: bestTech)
            }
            
            return
        }
        
        if self.currentProgress >= self.cost(of: currentTech) {
            
            do {
                try self.discover(tech: currentTech)
                
                // trigger event to user
                if player.isHuman() {
                    gameModel?.add(message: TechDiscoveredMessage(with: currentTech))
                }
                
                // enter era
                if currentTech.era() > player.currentEra() {
                    
                    if player.isHuman() {
                        gameModel?.add(message: EnteredEraMessage(with: currentTech.era()))
                    }
                    
                    player.set(era: currentTech.era())
                }
                
                self.currentTechVal = nil
                self.currentProgress = 0.0
                
            } catch {
                fatalError("Can't discover science - already discovered")
            }
        }
    }
}
