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

protocol AbstractCivics {
    
    // civics
    func has(civic: CivicType) -> Bool
    func discover(civic: CivicType) throws
    
    func possibleCivics() -> [CivicType]
    func setCurrent(civic: CivicType) throws
    func currentCivic() -> CivicType?
    func chooseNextCivic() -> CivicType
    
    func add(culture: Double)
    func checkCultureProgress(in gameModel: GameModel?) throws
    
    // eurekas
    func eurekaValue(for civicType: CivicType) -> Int
    func changeEurekaValue(for civicType: CivicType, change: Int)
    func eurekaTriggered(for civicType: CivicType) -> Bool
    func triggerEureka(for civicType: CivicType)
}

class Civics: AbstractCivics {
    
    // civic tree
    var civics: [CivicType] = []
    
    // user properties / values
    var player: Player?
    private var currentCivicVal: CivicType? = nil
    var currentProgress: Double = 0.0
    var lastCultureInput: Double = 1.0
    
    // heureka
    private var eurekas: Eurekas
    
    // MARK: internal types
    
    class WeightedCivics {
        
        var civics: [WeightedCivic]
        
        struct WeightedCivic {
            let civic: CivicType
            let value: Double
        }
        
        init() {
            self.civics = []
        }
        
        func add(civic: CivicType, with weight: Double) {
            
            self.civics.append(WeightedCivic(civic: civic, value: weight))
        }
        
        func sortByWeight() {
            
            self.civics.sort { $0.value > $1.value }
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
        
        return self.currentCivicVal == nil
    }
    
    func currentCivic() -> CivicType? {
        
        return self.currentCivicVal
    }
    
    func setCurrent(civic: CivicType) throws {
        
        if !self.possibleCivics().contains(civic) {
            throw CivicError.cantSelectCurrentCivic
        }
        
        self.currentCivicVal = civic
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

        self.currentProgress += culture
        self.lastCultureInput = culture
    }
    
    func chooseNextCivic() -> CivicType {
        
        let weightedCivics: WeightedCivics = WeightedCivics()
        let possibleCivicsList = self.possibleCivics()
        
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
            let numberOfTurnsLeft = self.cost(of: possibleCivic) / self.lastCultureInput
            let additionalTurnCostFactor = 0.015 * Double(numberOfTurnsLeft)
            let totalCostFactor = 0.15 + additionalTurnCostFactor
            let weightDivisor = pow(Double(numberOfTurnsLeft), totalCostFactor)
            
            // modify weight
            weightByFlavor = Double(weightByFlavor) / weightDivisor
            
            weightedCivics.add(civic: possibleCivic, with: weightByFlavor)
        }
        
        // select one
        let numberOfSelectable = min(3, possibleCivicsList.count)
        let selectedIndex = Int.random(number: numberOfSelectable)
        
        weightedCivics.sortByWeight()
        let selectedTech = weightedCivics.civics[selectedIndex].civic
        
        return selectedTech
    }
    
    func checkCultureProgress(in gameModel: GameModel?) throws {
        
        guard let currentCivic = self.currentCivicVal else {
            fatalError("Can't add culture - no civic selected")
        }
        
        guard let player = self.player else {
            fatalError("Can't add culture - no player present")
        }
        
        if self.currentProgress >= self.cost(of: currentCivic) {
            
            do {
                try self.discover(civic: currentCivic)
                
                // trigger event to user
                if player.isHuman() {
                    //gameModel?.civicDiscoveredNotification?(currentCivic)
                    gameModel?.add(message: CivicDiscoveredMessage(with: currentCivic))
                }

                // enter era
                if currentCivic.era() > player.currentEra() {
                    
                    if player.isHuman() {
                        // gameModel?.eraEnteredNotification?(currentCivic.era())
                        gameModel?.add(message: EnteredEraMessage(with: currentCivic.era()))
                    }
                }
                
                self.currentCivicVal = nil
                
            } catch {
                fatalError("Can't discover civic - already discovered")
            }
        }
    }
    
    // eurekas
    private func cost(of civicType: CivicType) -> Double {
        
        var costValue = Double(civicType.cost())
    
        // eureka gives 50% off
        if self.eurekas.triggered(for: civicType) {
            costValue /= 2.0
        }
        
        return costValue
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
    
    func triggerEureka(for civicType: CivicType) {
        
        self.eurekas.eurakaTrigger.trigger(for: civicType)
    }
}
