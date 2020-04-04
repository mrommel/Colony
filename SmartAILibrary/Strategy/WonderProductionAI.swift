//
//  WonderProductionAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 24.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class WonderWeigths: WeightedList<WonderType> {

    override func fill() {
        
        for wonderType in WonderType.all {
            self.add(weight: 0.0, for: wonderType)
        }
    }
}

public class WonderProductionAI {
    
    private var player: AbstractPlayer?
    private var weights: WonderWeigths
    
    init(player: AbstractPlayer?) {

        self.player = player
        
        self.weights = WonderWeigths()
        self.weights.fill()
        
        self.initWeights()
    }
    
    func initWeights() {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        for flavorType in FlavorType.all {
            
            let leaderFlavor = player.personalAndGrandStrategyFlavor(for: flavorType)
            
            for wonderType in WonderType.all {
                
                let wonderFlavor = wonderType.flavor(for: flavorType)
                
                self.weights.add(weight: wonderFlavor * leaderFlavor, for: wonderType)
            }
        }
        
    }
    
    func chooseWonder(adjustForOtherPlayers: Bool, nextWonderWeight: Int, in gameModel: GameModel?) -> (WonderType, Int) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let citySpecializationAI = player.citySpecializationAI else {
            fatalError("cant get citySpecializationAI")
        }
        
        let cities = gameModel.cities(of: player)
        
        guard !cities.isEmpty else {
            fatalError("cant get cities")
        }

        // Reset list of all the possible wonders
        var buildables = WonderWeigths()

        // Guess which city will be producing this (doesn't matter that much since weights are all relative)
        var wonderCityRef: AbstractCity? = citySpecializationAI.wonderBuildCity()
        if wonderCityRef == nil {
            wonderCityRef = cities.first!
        }

        guard let wonderCity = wonderCityRef else {
            return (.none, 0)
        }

        var estimatedProductionPerTurn = wonderCity.productionPerTurn() // getProduction
        if estimatedProductionPerTurn < 1.0 {
            estimatedProductionPerTurn = 1.0
        }

        // Loop through adding the available wonders
        for wonderType in WonderType.all {
            
            // Make sure this wonder can be built now
            if self.haveCityToBuild(wonderType: wonderType, in: gameModel) {
                
                let turnsRequired = max(1.0, Double(wonderType.productionCost()) / estimatedProductionPerTurn)
                
                // 10 turns will add 0.02; 80 turns will add 0.16
                let additionalTurnCostFactor = 0.015 /* AI_PRODUCTION_WEIGHT_MOD_PER_TURN_LEFT */ * Double(turnsRequired)
                let totalCostFactor = 0.15 /* AI_PRODUCTION_WEIGHT_BASE_MOD */ + additionalTurnCostFactor    //
                let weightDivisor = pow(Double(turnsRequired), totalCostFactor)
                
                let weight = self.weights.weight(of: wonderType) / weightDivisor

                if adjustForOtherPlayers {
                    // Adjust weight for this wonder down based on number of other players currently working on it
                    /*int iNumOthersConstructing = 0;
                    for (int iPlayerLoop = 0; iPlayerLoop < MAX_MAJOR_CIVS; iPlayerLoop++)
                    {
                        PlayerTypes eLoopPlayer = (PlayerTypes) iPlayerLoop;
                        if (GET_PLAYER(eLoopPlayer).getBuildingClassMaking((BuildingClassTypes)kBuilding.GetBuildingClassType()) > 0)
                        {
                            iNumOthersConstructing++;
                        }
                    }
                    iWeight = iWeight / (1 + iNumOthersConstructing);*/
                }

                buildables.add(weight: weight, for: wonderType)
            }
        }

        // Sort items and grab the first one
        if !buildables.items.isEmpty {
            
            buildables.sort()
            //LogPossibleWonders();

            if buildables.totalWeights() > 0.0 {
                if let selection = buildables.chooseFromTopChoices() {
                    return (selection, Int(buildables.totalWeights()))
                }
            }
            
            // Nothing with any weight
            return (.none, 0)
            
        } else {
            // Unless we didn't find any
            return (.none, 0)
        }
    }
    
    /// Check to make sure some city can build this wonder
    private func haveCityToBuild(wonderType: WonderType, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        for loopCityRef in gameModel.cities(of: player) {
            
            guard let loopCity = loopCityRef else {
                continue
            }
            
            if loopCity.canBuild(wonder: wonderType, in: gameModel) {
                return true
            }
        }
        
        return false
    }
}
