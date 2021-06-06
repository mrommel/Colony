//
//  PlayerYields.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

extension Player {
    
    // MARK: faith functions
    
    public func faith(in gameModel: GameModel?) -> Double {
        
        var value = 0.0

        // faith from our Cities
        value += self.faithFromCities(in: gameModel)
        
        return value
    }
    
    private func faithFromCities(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var faithVal = 0.0
        
        for cityRef in gameModel.cities(of: self) {
            
            guard let city = cityRef else {
                continue
            }
            
            faithVal += city.faithPerTurn(in: gameModel)
        }
        
        return faithVal
    }
    
    // MARK: science functions
    
    // GetScienceTimes100()
    public func science(in gameModel: GameModel?) -> Double {
        
        var value = 0.0

        // Science from our Cities
        value += self.scienceFromCities(in: gameModel)

        // Science from other players!
        // value += GetScienceFromOtherPlayersTimes100();

        // Happiness converted to Science? (Policies, etc.)
        // value += GetScienceFromHappinessTimes100();

        // Research Agreement bonuses
        // value += GetScienceFromResearchAgreementsTimes100();

        // If we have a negative Treasury + GPT then it gets removed from Science
        // value += GetScienceFromBudgetDeficitTimes100();

        return max(value, 0)
    }
    
    private func scienceFromCities(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var scienceVal = 0.0
        
        for cityRef in gameModel.cities(of: self) {
            
            guard let city = cityRef else {
                continue
            }
            
            scienceVal += city.sciencePerTurn(in: gameModel)
        }
        
        return scienceVal
    }
    
    // MARK: culture functpublic ions
    
    public func culture(in gameModel: GameModel?) -> Double {
        
        var value = 0.0

        // culture from our Cities
        value += self.cultureFromCities(in: gameModel)
        value += Double(self.cultureEarned)
        // ....
        
        self.cultureEarned = 0
        
        return value
    }
    
    private func cultureFromCities(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var cultureVal = 0.0
        
        for cityRef in gameModel.cities(of: self) {
            
            guard let city = cityRef else {
                continue
            }
            
            cultureVal += city.culturePerTurn(in: gameModel)
        }
        
        return cultureVal
    }
}
