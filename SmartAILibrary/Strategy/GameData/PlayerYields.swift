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

        if self.isCityState() || self.isBarbarian() {
            return 0.0
        }

        var value = 0.0

        // faith from our Cities
        value += self.faithFromCities(in: gameModel)
        value += Double(self.faithEarned)
        // ....
        self.faithEarned = 0

        return value
    }

    public func faithFromCities(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if self.isCityState() || self.isBarbarian() {
            return 0.0
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

        var value: YieldValues = YieldValues(value: 0.0, percentage: 1.0)

        // Science from our Cities
        value += self.scienceFromCities(in: gameModel)
        value += self.scienceFromCityStates(in: gameModel)

        // Science from other players!
        // value += GetScienceFromOtherPlayersTimes100();

        // Happiness converted to Science? (Policies, etc.)
        // value += GetScienceFromHappinessTimes100();

        // Research Agreement bonuses
        // value += GetScienceFromResearchAgreementsTimes100();

        // If we have a negative Treasury + GPT then it gets removed from Science
        // value += GetScienceFromBudgetDeficitTimes100();

        return max(value.calc(), 0)
    }

    public func scienceFromCities(in gameModel: GameModel?) -> YieldValues {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var scienceVal: YieldValues = YieldValues(value: 0.0, percentage: 0.0)

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            scienceVal += city.sciencePerTurn(in: gameModel)
        }

        return scienceVal
    }

    public func scienceFromCityStates(in gameModel: GameModel?) -> YieldValues {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let government = self.government else {
            fatalError("cant get government")
        }

        let scienceVal = 0.0
        var scienceModifier = 0.0

        // internationalSpaceAgency - 5% [Science] Science per City-State you are the Suzerain of.
        if government.has(card: .internationalSpaceAgency) {
            var numberOfCityStatesMet: Int = 0
            for cityState in self.metCityStates(in: gameModel) {
                if self.isSuzerain(of: cityState, in: gameModel) {
                    numberOfCityStatesMet += 1
                }
            }
            scienceModifier += 0.05 * Double(numberOfCityStatesMet)
        }

        return YieldValues(value: scienceVal, percentage: scienceModifier)
    }

    // MARK: culture functpublic ions

    public func culture(in gameModel: GameModel?, consume: Bool) -> Double {

        var value = YieldValues(value: 0.0, percentage: 1.0)

        // culture from our Cities
        value += self.cultureFromCities(in: gameModel)
        value += self.cultureFromCityStates(in: gameModel)
        value += YieldValues(value: Double(self.cultureEarned))
        // ....

        if consume {
            self.cultureEarned = 0
        }

        return value.calc()
    }

    public func cultureFromCities(in gameModel: GameModel?) -> YieldValues {

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

        return YieldValues(value: cultureVal)
    }

    public func cultureFromCityStates(in gameModel: GameModel?) -> YieldValues {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let government = self.government else {
            fatalError("cant get government")
        }

        let cultureVal = 0.0
        var cultureModifier = 0.0

        // antananarivo suzerain bonus
        // Your Civilization gains +2% [Culture] Culture for each [GreatPerson] Great Person it has ever earned (up to 30%).
        if self.isSuzerain(of: .antananarivo, in: gameModel) {
            let numberOfSpawnedGreatPersons = self.greatPeople?.numberOfSpawnedGreatPersons() ?? 0
            cultureModifier += min(0.02 * Double(numberOfSpawnedGreatPersons), 0.3)
        }

        // collectiveActivism - 5% [Culture] Culture per City-State you are the Suzerain of.
        if government.has(card: .collectiveActivism) {
            var numberOfCityStatesMet: Int = 0
            for cityState in self.metCityStates(in: gameModel) {
                if self.isSuzerain(of: cityState, in: gameModel) {
                    numberOfCityStatesMet += 1
                }
            }
            cultureModifier += 0.05 * Double(numberOfCityStatesMet)
        }

        return YieldValues(value: cultureVal, percentage: cultureModifier)
    }
}
