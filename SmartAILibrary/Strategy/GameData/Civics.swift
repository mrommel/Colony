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
    func add(culture: Int, in gameModel: GameModel?)
    func chooseNextCivic() -> CivicType
}

class Civics: AbstractCivics {
    
    // civic tree
    var civics: [CivicType] = []
    
    // user properties / values
    var player: Player?
    private var currentCivicVal: CivicType? = nil
    var currentProgress: Int = 0
    var lastCultureInput: Int = 1
    
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
    
    // MARK: constructor
    
    init(player: Player?) {
        
        self.player = player
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
    
    func add(culture: Int, in gameModel: GameModel?) {
        
        guard let currentCivic = self.currentCivicVal else {
            fatalError("Can't add culture - no civic selected")
        }
        
        guard let player = self.player else {
            fatalError("Can't add culture - no player present")
        }
        
        self.currentProgress += culture
        self.lastCultureInput = culture
        
        if self.currentProgress >= currentCivic.cost() {
            
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
            let numberOfTurnsLeft = possibleCivic.cost() / self.lastCultureInput
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
}
