//
//  CityStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable type_body_length
enum CityStrategyType: Int, Codable {

    case none

    case tinyCity
    case smallCity
    case mediumCity
    case largeCity
    case landLocked

    case needTileImprovers
    case wantTileImprovers
    case enoughTileImprovers
    case needNavalGrowth
    case needNavalTileImprovement
    case enoughNavalTileImprovement
    case needImprovementFood
    case needImprovementProduction
    case haveTrainingFacility
    case capitalNeedSettler
    case capitalUnderThreat
    case underBlockade

    case coastCity
    case riverCity
    case mountainCity
    case hillCity
    case forestCity
    case jungleCity

    static var all: [CityStrategyType] {
        return [
                .tinyCity, .smallCity, .mediumCity, .largeCity,
                .landLocked,
                .needTileImprovers, .wantTileImprovers, .enoughTileImprovers,
                .needNavalGrowth,
                .needNavalTileImprovement, .enoughNavalTileImprovement,
                .needImprovementFood, .needImprovementProduction,
                .haveTrainingFacility, .capitalNeedSettler, .capitalUnderThreat,
                .underBlockade,

                .coastCity, .riverCity, .mountainCity, .hillCity, .forestCity, .jungleCity
        ]
    }

    // https://github.com/wangxinyu199306/Civ5Configuration/blob/4051683102bb0b87aa83411a7efcf8fbc7c7b557/Gameplay/XML/AI/CIV5AICityStrategies.xml
    func flavorModifiers() -> [Flavor] {

        switch self {

        case .none:
            return []

        case .tinyCity:
            return [
                Flavor(type: .growth, value: 10),
                Flavor(type: .offense, value: -2),
                Flavor(type: .naval, value: -4),
                Flavor(type: .navalRecon, value: -4),
                Flavor(type: .amenities, value: -10),
                Flavor(type: .expansion, value: -100),
                Flavor(type: .tileImprovement, value: -3),
                Flavor(type: .wonder, value: -6),
                Flavor(type: .science, value: -5),
                Flavor(type: .diplomacy, value: -300)
            ]
        case .smallCity:
            return [
                Flavor(type: .offense, value: -2),
                Flavor(type: .naval, value: -4),
                Flavor(type: .navalRecon, value: -4),
                Flavor(type: .amenities, value: -15),
                Flavor(type: .expansion, value: -100),
                Flavor(type: .tileImprovement, value: -3),
                Flavor(type: .wonder, value: -6),
                Flavor(type: .science, value: -5),
                Flavor(type: .diplomacy, value: -300)
            ]
        case .mediumCity:
            return [
                Flavor(type: .science, value: 10),
                Flavor(type: .amenities, value: 10),
                Flavor(type: .gold, value: 10),
                Flavor(type: .growth, value: 25),
                Flavor(type: .production, value: 10),
                Flavor(type: .diplomacy, value: -50)
            ]
        case .largeCity:
            return [
                Flavor(type: .science, value: 25),
                Flavor(type: .gold, value: 25),
                Flavor(type: .wonder, value: 25),
                Flavor(type: .growth, value: 15),
                Flavor(type: .amenities, value: 15)
            ]
        case .landLocked:
            return [
                Flavor(type: .naval, value: -100),
                Flavor(type: .navalRecon, value: -100),
                Flavor(type: .navalGrowth, value: -100),
                Flavor(type: .navalTileImprovement, value: -100)
            ]

        case .needTileImprovers:
            return [
                Flavor(type: .tileImprovement, value: 150)
            ]
        case .wantTileImprovers:
            return [
                Flavor(type: .tileImprovement, value: 35)
            ]
        case .enoughTileImprovers:
            return [
                Flavor(type: .tileImprovement, value: -100)
            ]
        case .needNavalGrowth:
            return [
                Flavor(type: .navalGrowth, value: 10)
            ]
        case .needNavalTileImprovement:
            return [
                Flavor(type: .navalGrowth, value: -5),
                Flavor(type: .navalTileImprovement, value: 50),
                Flavor(type: .growth, value: -5)
            ]
        case .enoughNavalTileImprovement:
            return [
                Flavor(type: .navalTileImprovement, value: -100)
            ]
        case .needImprovementFood: return []
        case .needImprovementProduction: return []
        case .haveTrainingFacility:
            return [
                Flavor(type: .offense, value: 6),
                Flavor(type: .defense, value: 6),
                Flavor(type: .ranged, value: 2),
                Flavor(type: .tileImprovement, value: -3),
                Flavor(type: .expansion, value: -3),
                Flavor(type: .growth, value: 10),
                Flavor(type: .amenities, value: 10),
                Flavor(type: .recon, value: -6)
            ]
        case .capitalNeedSettler:
            return [
                Flavor(type: .expansion, value: 250),
                Flavor(type: .wonder, value: -25)
            ]
        case .capitalUnderThreat:
            return [
                Flavor(type: .defense, value: 25),
                Flavor(type: .cityDefense, value: 15),
                Flavor(type: .militaryTraining, value: -25),
                Flavor(type: .culture, value: -25),
                Flavor(type: .amenities, value: -25),
                Flavor(type: .growth, value: -25),
                Flavor(type: .expansion, value: -25)
            ]

        case .underBlockade:
            return [
                Flavor(type: .cityDefense, value: 10),
                Flavor(type: .ranged, value: 5),
                Flavor(type: .naval, value: 20)
            ]
        case .coastCity:
            return [
                Flavor(type: .gold, value: 10)
            ]
        case .riverCity:
            return [
                Flavor(type: .gold, value: 5),
                Flavor(type: .growth, value: 5)
            ]
        case .mountainCity:
            return [
                Flavor(type: .science, value: 10)
            ]
        case .hillCity:
            return [
                Flavor(type: .production, value: 10)
            ]
        case .forestCity:
        return [
            Flavor(type: .production, value: 10)
        ]
        case .jungleCity:
        return [
            Flavor(type: .science, value: 10)
        ]

        }
    }

    func flavorThresholdModifiers() -> [Flavor] {

        switch self {

        case .none: return []

        case .tinyCity: return []
        case .smallCity: return []
        case .mediumCity: return []
        case .largeCity: return []
        case .landLocked: return []

        case .needTileImprovers: return []
        case .wantTileImprovers: return [
            Flavor(type: .tileImprovement, value: 2)
            ]
        case .enoughTileImprovers: return []
        case .needNavalGrowth: return []
        case .needNavalTileImprovement: return []
        case .enoughNavalTileImprovement: return []
        case .needImprovementFood: return []
        case .needImprovementProduction: return []
        case .haveTrainingFacility: return []
        case .capitalNeedSettler: return [
            Flavor(type: .expansion, value: -10),
            Flavor(type: .defense, value: 2)
        ]
        case .capitalUnderThreat: return []
        case .underBlockade: return []

        case .coastCity: return []
        case .riverCity: return []
        case .mountainCity: return []
        case .hillCity: return []
        case .forestCity: return []
        case .jungleCity: return []
        }
    }

    func flavorThresholdModifier(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavorThresholdModifiers().first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return 0
    }

    func weightThreshold() -> Int {

        switch self {

        case .none: return 0

        case .tinyCity: return 0
        case .smallCity: return 0
        case .mediumCity: return 0
        case .largeCity: return 0
        case .landLocked: return 0

        case .needTileImprovers: return 67
        case .wantTileImprovers: return 40
        case .enoughTileImprovers: return 100
        case .needNavalGrowth: return 40
        case .needNavalTileImprovement: return 0
        case .enoughNavalTileImprovement: return 0
        case .needImprovementFood: return 0
        case .needImprovementProduction: return 0
        case .haveTrainingFacility: return 0
        case .capitalNeedSettler: return 130
        case .capitalUnderThreat: return 0
        case .underBlockade: return 0

        case .coastCity: return 0
        case .riverCity: return 0
        case .mountainCity: return 0
        case .hillCity: return 0
        case .forestCity: return 0
        case .jungleCity: return 0
        }
    }

    func required() -> TechType? {

        switch self {

        case .none: return nil

        case .tinyCity: return nil
        case .smallCity: return nil
        case .mediumCity: return nil
        case .largeCity: return nil
        case .landLocked: return nil

        case .needTileImprovers: return nil
        case .wantTileImprovers: return nil
        case .enoughTileImprovers: return nil
        case .needNavalGrowth: return nil
        case .needNavalTileImprovement: return nil
        case .enoughNavalTileImprovement: return nil
        case .needImprovementFood: return nil
        case .needImprovementProduction: return nil
        case .haveTrainingFacility: return nil
        case .capitalNeedSettler: return nil
        case .capitalUnderThreat: return nil
        case .underBlockade: return nil

        case .coastCity: return nil
        case .riverCity: return nil
        case .mountainCity: return nil
        case .hillCity: return nil
        case .forestCity: return nil
        case .jungleCity: return nil
        }
    }

    func obsolete() -> TechType? {

        switch self {

        case .none: return nil

        case .tinyCity: return nil
        case .smallCity: return nil
        case .mediumCity: return nil
        case .largeCity: return nil
        case .landLocked: return nil

        case .needTileImprovers: return nil
        case .wantTileImprovers: return nil
        case .enoughTileImprovers: return nil
        case .needNavalGrowth: return nil
        case .needNavalTileImprovement: return nil
        case .enoughNavalTileImprovement: return nil
        case .needImprovementFood: return nil
        case .needImprovementProduction: return nil
        case .haveTrainingFacility: return nil
        case .capitalNeedSettler: return nil
        case .capitalUnderThreat: return nil
        case .underBlockade: return nil

        case .coastCity: return nil
        case .riverCity: return nil
        case .mountainCity: return nil
        case .hillCity: return nil
        case .forestCity: return nil
        case .jungleCity: return nil
        }
    }

    func permanent() -> Bool {

        switch self {

        case .none: return false

        case .tinyCity: return false
        case .smallCity: return false
        case .mediumCity: return false
        case .largeCity: return false
        case .landLocked: return true

        case .needTileImprovers: return false
        case .wantTileImprovers: return false
        case .enoughTileImprovers: return false
        case .needNavalGrowth: return false
        case .needNavalTileImprovement: return false
        case .enoughNavalTileImprovement: return false
        case .needImprovementFood: return false
        case .needImprovementProduction: return false
        case .haveTrainingFacility: return true
        case .capitalNeedSettler: return false
        case .capitalUnderThreat: return false
        case .underBlockade: return false

        case .coastCity: return false
        case .riverCity: return false
        case .mountainCity: return false
        case .hillCity: return false
        case .forestCity: return false
        case .jungleCity: return false
        }
    }

    func checkEachTurns() -> Int {

        switch self {

        case .none: return 1000

        case .tinyCity: return 5
        case .smallCity: return 5
        case .mediumCity: return 5
        case .largeCity: return 5
        case .landLocked: return -1

        case .needTileImprovers: return 2
        case .wantTileImprovers: return 2
        case .enoughTileImprovers: return 5
        case .needNavalGrowth: return 5
        case .needNavalTileImprovement: return 1
        case .enoughNavalTileImprovement: return 1
        case .needImprovementFood: return 2
        case .needImprovementProduction: return 2
        case .haveTrainingFacility: return -1
        case .capitalNeedSettler: return 2
        case .capitalUnderThreat: return 2
        case .underBlockade: return 2

        case .coastCity: return 2
        case .riverCity: return 2
        case .mountainCity: return 2
        case .hillCity: return 2
        case .forestCity: return 2
        case .jungleCity: return 2
        }
    }

    func minimumAdoptionTurns() -> Int {

        switch self {

        case .none: return 0

        case .tinyCity: return 5
        case .smallCity: return 5
        case .mediumCity: return 5
        case .largeCity: return 5
        case .landLocked: return -1

        case .needTileImprovers: return 2
        case .wantTileImprovers: return 2
        case .enoughTileImprovers: return 10
        case .needNavalGrowth: return 10
        case .needNavalTileImprovement: return 2
        case .enoughNavalTileImprovement: return 2
        case .needImprovementFood: return 2
        case .needImprovementProduction: return 2
        case .haveTrainingFacility: return -1
        case .capitalNeedSettler: return 4
        case .capitalUnderThreat: return 2
        case .underBlockade: return 2

        case .coastCity: return 2
        case .riverCity: return 2
        case .mountainCity: return 2
        case .hillCity: return 2
        case .forestCity: return 2
        case .jungleCity: return 2
        }
    }

    func shouldBeActive(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        switch self {

        case .none: return false

        case .tinyCity: return self.shouldBeActiveTinyCity(for: city)
        case .smallCity: return self.shouldBeActiveSmallCity(for: city)
        case .mediumCity: return self.shouldBeActiveMediumCity(for: city)
        case .largeCity: return self.shouldBeActiveLargeCity(for: city)
        case .landLocked: return self.shouldBeActiveLandLocked(for: city, in: gameModel)

        case .needTileImprovers: return self.shouldBeActiveNeedTileImprovers(for: city, in: gameModel)
        case .wantTileImprovers: return self.shouldBeActiveWantTileImprovers(for: city, in: gameModel)
        case .enoughTileImprovers: return self.shouldBeActiveEnoughTileImprovers(for: city, in: gameModel)
        case .needNavalGrowth: return self.shouldBeActiveNeedNavalGrowth(for: city, in: gameModel)
        case .needNavalTileImprovement: return self.shouldBeActiveNeedNavalTileImprovement(for: city, in: gameModel)
        case .enoughNavalTileImprovement: return self.shouldBeActiveEnoughNavalTileImprovement(for: city)
        case .needImprovementFood: return self.shouldBeActiveNeedImprovementFood(for: city, in: gameModel)
        case .needImprovementProduction: return self.shouldBeActiveNeedImprovementProduction(for: city, in: gameModel)
        case .haveTrainingFacility: return self.shouldBeActiveHaveTrainingFacility(for: city)
        case .capitalNeedSettler: return self.shouldBeActiveCapitalNeedSettler(for: city, in: gameModel)
        case .capitalUnderThreat: return self.shouldBeActiveCapitalUnderThreat(for: city, in: gameModel)
        case .underBlockade: return self.shouldBeActiveUnderBlockade(for: city)

        case .coastCity: return self.shouldBeActiveCoastCity(for: city, in: gameModel)
        case .riverCity: return self.shouldBeActiveRiverCity(for: city, in: gameModel)
        case .mountainCity: return self.shouldBeActiveMountainCity(for: city, in: gameModel)
        case .hillCity: return self.shouldBeActiveHillCity(for: city, in: gameModel)
        case .forestCity: return self.shouldBeActiveForestCity(for: city, in: gameModel)
        case .jungleCity: return self.shouldBeActiveJungleCity(for: city, in: gameModel)
        }
    }

// "Tiny City" City Strategy: If a City is under 2 Population tweak a number of different Flavors
    private func shouldBeActiveTinyCity(for city: AbstractCity?) -> Bool {

        guard let city = city else {
            fatalError("no city given")
        }

        return city.population() == 1
    }

// "Small City" City Strategy: If a City is under 3 Population tweak a number of different Flavors
    private func shouldBeActiveSmallCity(for city: AbstractCity?) -> Bool {

        guard let city = city else {
            fatalError("no city given")
        }

        return 2 <= city.population() && city.population() <= 4
    }

// "Medium City" City Strategy: If a City is 8 or above Population boost science
    private func shouldBeActiveMediumCity(for city: AbstractCity?) -> Bool {

        guard let city = city else {
            fatalError("no city given")
        }

        return 5 <= city.population() && city.population() <= 11
    }

// "Large City" City Strategy: If a City is 15 or above, boost science a LOT
    private func shouldBeActiveLargeCity(for city: AbstractCity?) -> Bool {

        guard let city = city else {
            fatalError("no city given")
        }

        return 12 <= city.population()
    }

    private func shouldBeActiveLandLocked(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let city = city else {
            fatalError("no city given")
        }

        if let isCoastal = gameModel?.isCoastal(at: city.location) {
            return !isCoastal
        }

        return false
    }

    // "Need Tile Improvers" City Strategy: Do we REALLY need to train some Workers?
    private func shouldBeActiveNeedTileImprovers(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = city?.player else {
            fatalError("cant get player")
        }

        guard let militaryAI = player.militaryAI else {
            fatalError("cant get militaryAI")
        }

        let currentNumCities = gameModel.cities(of: player).count

        if let lastTurnBuilderDisbanded = player.economicAI?.lastTurnBuilderDisbanded() {
            if lastTurnBuilderDisbanded > 0 && gameModel.currentTurn - lastTurnBuilderDisbanded <= 25 {

                return false
            }
        }

        let numBuilders = gameModel.units(of: player).count(where: { $0!.task() == .work })

        let numCities = max(1, (currentNumCities * 3) / 4)
        if numBuilders >= numCities {
            return false
        }

        // If we're losing at war, also return false
        if player.diplomacyAI?.stateOfAllWars == .losing {
            return false
        }

        // If we're under attack from Barbs and have 1 or fewer Cities and no credible defense then training more Workers will only hurt us
        if currentNumCities <= 1 {

            if militaryAI.adopted(militaryStrategy: .eradicateBarbarians) && militaryAI.adopted(militaryStrategy: .empireDefenseCritical) {
                return false
            }
        }

        let moddedNumBuilders = numBuilders * 67
        let moddedNumCities = currentNumCities + gameModel.cities(of: player).count(where: { $0!.isFeatureSurrounded() })

        // We have fewer than we think we should, or we have none at all
        if moddedNumBuilders <= moddedNumCities || moddedNumBuilders == 0 {

            // If we don't have any Workers by turn 30 we really need to get moving
            if gameModel.currentTurn > 30 { // AI_CITYSTRATEGY_NEED_TILE_IMPROVERS_DESPERATE_TURN
                return true
            }
        }

        return false
    }

    private func shouldBeActiveWantTileImprovers(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let city = city else {
            fatalError("no city given")
        }

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = city.player else {
            fatalError("cant get player")
        }

        /*guard let militaryAI = player.militaryAI else {
            fatalError("cant get militaryAI")
        }*/

        let currentNumCities = gameModel.cities(of: player).count

        if let lastTurnBuilderDisbanded = player.economicAI?.lastTurnBuilderDisbanded() {
            if lastTurnBuilderDisbanded > 0 && gameModel.currentTurn - lastTurnBuilderDisbanded <= 25 {

                return false
            }
        }

        let numSettlers = gameModel.units(of: player).count(where: { $0!.task() == .settle })
        let numBuilders = gameModel.units(of: player).count(where: { $0!.task() == .work })

        let numCities = max(1, (currentNumCities * 3) / 4)
        if numBuilders >= numCities {
            return false
        }

        // Don't get desperate for training a Builder here unless the City is at least of a certain size
        if city.population() >= 2 { // AI_CITYSTRATEGY_WANT_TILE_IMPROVERS_MINIMUM_SIZE

            // If we don't even have 1 builder on map or in a queue, turn this on immediately
            if numBuilders < 1 {
                return true
            }

            let weightThresholdModifier = self.weightThresholdModifier(for: player)    // 2 Extra Weight per TILE_IMPROVEMENT Flavor
            let perCityThreshold = self.weightThreshold() + weightThresholdModifier;    // 40

            var numResources = 0
            var numImprovedResources = 0

            // Look at all Tiles this City could potentially work to see if there are any Water Resources that could be improved
            for pt in city.location.areaWith(radius: City.workRadius) {

                if let tile = gameModel.tile(at: pt) {
                    if tile.owner()?.leader == player.leader {
                        if tile.terrain().isLand() {

                            if !tile.hasAnyResource(for: player) {
                                continue
                            }

                            let improvements = tile.possibleImprovements()

                            // no valid build found
                            if improvements.isEmpty {
                                continue
                            }

                            // already build
                            if tile.has(improvement: improvements[0]) {
                                numImprovedResources += 1
                            }

                            numResources += 1
                        }
                    }
                }
            }

            let manyUnimproveResources = (2 * (numResources - numImprovedResources)) > numResources
            var multiplier = numCities
            multiplier += gameModel.cities(of: player).count(where: { $0!.isFeatureSurrounded() })
            if manyUnimproveResources {
                multiplier += 1
            }

            multiplier += numSettlers

            let weightThreshold = (perCityThreshold * multiplier)

            // Do we want more Builders?
            if (numBuilders * 100) < weightThreshold {
                return player.treasury!.value() > 10
            }
        }

        return false
    }

    /// "Enough Tile Improvers" City Strategy: This is not a Player Strategy because we only want to prevent the training of new Builders, not nullify new Techs or Policies, which could still be very useful
    private func shouldBeActiveEnoughTileImprovers(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        guard let player = city.player else {
            fatalError("cant get city player")
        }

        guard let economicAI = player.economicAI else {
            fatalError("cant get economicAI")
        }

        guard let cityStrategyAI = city.cityStrategy else {
            fatalError("cant get city Strategy AI")
        }

        let lastTurnWorkerDisbanded = economicAI.lastTurnBuilderDisbanded()
        if lastTurnWorkerDisbanded >= 0 && (gameModel.currentTurn - lastTurnWorkerDisbanded) <= 10 {
            return true
        }

        if cityStrategyAI.adopted(cityStrategy: .needTileImprovers) {
            return false
        }

        let numBuilders = player.countUnitsWith(defaultTask: .work, in: gameModel)

        // If it's a minor with at least 1 worker per city, always return true
        /*if(GET_PLAYER(pCity->getOwner()).isMinorCiv())
        {
            if(iNumBuilders >= kPlayer.getNumCities())
                return true;
        }*/

        let cityStrategy: CityStrategyType = .enoughTileImprovers

        let weightThresholdModifier = cityStrategy.weightThresholdModifier(for: player) // 10 Extra Weight per TILE_IMPROVEMENT Flavor
        let perCityThreshold = cityStrategy.weightThreshold() + weightThresholdModifier    // 100

        let moddedNumCities = player.numCities(in: gameModel) + player.countCitiesFeatureSurrounded(in: gameModel)
        let weightThreshold = (perCityThreshold * moddedNumCities)

        // Average Player wants no more than 1.50 Builders per City [150 Weight is Average; range is 100 to 200]
        if numBuilders * 100 >= weightThreshold {
            return true
        }

        return false
    }

    /// "Need Naval Growth" City Strategy: Looks at the Tiles this City can work, and if there are a lot of Ocean tiles prioritizes NAVAL_GROWTH: should give us a Harbor eventually
    private func shouldBeActiveNeedNavalGrowth(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        guard let player = city.player else {
            fatalError("cant get city player")
        }

        guard let cityCitizens = city.cityCitizens else {
            fatalError("cant get city citizens")
        }

        var numOceanPlots = 0
        var numTotalWorkablePlots = 0

        // Look at all Tiles this City could potentially work
        for workingTileLocation in cityCitizens.workingTileLocations() {

            guard let loopPlot = gameModel.tile(at: workingTileLocation) else {
                continue
            }

            if loopPlot.isCity() {
                continue
            }

            guard player.isEqual(to: loopPlot.owner()) else {
                continue
            }

            numTotalWorkablePlots += 1

            if loopPlot.isWater() && loopPlot.feature() != .lake {
                numOceanPlots += 1
            }
        }

        if numTotalWorkablePlots > 0 {

            let cityStrategy: CityStrategyType = .needNavalGrowth

            let weightThresholdModifier = cityStrategy.weightThresholdModifier(for: player) // -1 Weight per NAVAL_GROWTH Flavor
            let weightThreshold = cityStrategy.weightThreshold() + weightThresholdModifier    // 40

            // If at least 35% (Average Player) of a City's workable Tiles are low-food Water then we really should be building a Harbor
            // [35 Weight is Average; range is 30 to 40]
            if (numOceanPlots * 100) / numTotalWorkablePlots >= weightThreshold {
                return true
            }
        }

        return false
    }

    /// "Need Naval Tile Improvement" City Strategy: If there's an unimproved Resource in the water that we could be using, HIGHLY prioritize NAVAL_TILE_IMPROVEMENT in this City: should give us a Workboat in short order
    private func shouldBeActiveNeedNavalTileImprovement(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        guard let player = city.player else {
            fatalError("cant get city player")
        }

        guard let cityCitizens = city.cityCitizens else {
            fatalError("cant get city citizens")
        }

        var numUnimprovedWaterResources = 0

        // Look at all Tiles this City could potentially work to see if there are any Water Resources that could be improved
        for workingTileLocation in cityCitizens.workingTileLocations() {

            guard let loopPlot = gameModel.tile(at: workingTileLocation) else {
                continue
            }

            guard player.isEqual(to: loopPlot.owner()) else {
                continue
            }

            if loopPlot.isWater() {
                // Only look at Tiles THIS City can use; Prevents issue where two Cities can look at the same tile the same turn and both want Workboats for it; By the time this Strategy is called for a City another City isn't guaranteed to have popped it's previous order and registered that it's now training a Workboat! :(
                if cityCitizens.isCanWork(at: workingTileLocation, in: gameModel) {
                    // Does this Tile already have a Resource, and if so, is it already improved?
                    if loopPlot.resource(for: player) != .none && loopPlot.improvement() == .none {
                        numUnimprovedWaterResources += 1
                    }
                }
            }

        }

        let numWaterTileImprovers = player.countUnitsWith(defaultTask: .workerSea, in: gameModel)

        // Are there more Water Resources we can build an Improvement on than we have Naval Tile Improvers?
        if numUnimprovedWaterResources > numWaterTileImprovers {
            return true
        }

        return false
    }

    /// "Enough Naval Tile Improvement" City Strategy: If we're not running "Need Naval Tile Improvement" then there's no need to worry about it at all
    private func shouldBeActiveEnoughNavalTileImprovement(for city: AbstractCity?) -> Bool {

        guard let cityStrategyAI = city?.cityStrategy else {
            fatalError("cant get city Strategy AI")
        }

        if !cityStrategyAI.adopted(cityStrategy: .needNavalTileImprovement) {
            return true
        }

        return false
    }

    /// "Need Improvement" City Strategy: if we need to get an improvement that increases a yield amount
    private func shouldBeActiveNeedImprovementFood(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let cityStrategyAI = city?.cityStrategy else {
            fatalError("cant get city Strategy AI")
        }

        if cityStrategyAI.deficientYield(in: gameModel) == .food {
            return true
        }

        return false
    }

    private func shouldBeActiveNeedImprovementProduction(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let cityStrategyAI = city?.cityStrategy else {
            fatalError("cant get city Strategy AI")
        }

        if cityStrategyAI.deficientYield(in: gameModel) == .food {
            return true
        }

        return false
    }

    private func shouldBeActiveHaveTrainingFacility(for city: AbstractCity?) -> Bool {

        guard let buildings = city?.buildings else {
            fatalError("cant get buildings")
        }

        if buildings.has(building: .barracks) {
            return true
        }

        /*if buildings.has(building: .armory) {
            return true
        }*/

        return false
    }

    /// "Capital Need Settler" City Strategy: have capital build a settler ASAP
    private func shouldBeActiveCapitalNeedSettler(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = city?.player else {
            fatalError("cant get player")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        guard let cityStrategy = city.cityStrategy else {
            fatalError("cant get cityStrategy")
        }

        guard let militaryAI = player.militaryAI else {
            fatalError("cant get militaryAI")
        }

        if !city.isCapital() {
            return false
        }

        let numCities = gameModel.cities(of: player).count
        let numSettlers = gameModel.units(of: player).count(where: { $0!.task() == .settle })
        let numCitiesAndSettlers = numCities + numSettlers

        if numCitiesAndSettlers < 3 {

            if gameModel.currentTurn > 100 && cityStrategy.adopted(cityStrategy: .capitalUnderThreat) {

                return false
            }

            if militaryAI.adopted(militaryStrategy: .warMobilization) {
                return false
            }

            let weightThresholdModifier = self.weightThresholdModifier(for: player)
            let weightThreshold = self.weightThreshold() + weightThresholdModifier

            if numCitiesAndSettlers == 1 && gameModel.currentTurn * 4 > weightThreshold {

                return true
            }

            if numCitiesAndSettlers == 2 && gameModel.currentTurn > weightThreshold {

                return true
            }
        }

        return false
    }

    private func weightThresholdModifier(for player: AbstractPlayer) -> Int {

        var value = 0

        for flavor in FlavorType.all {

            value += player.valueOfPersonalityFlavor(of: flavor) * self.flavorThresholdModifier(for: flavor)
        }

        return value
    }

    /// "Capital Under Threat" City Strategy: need military units, don't build buildings!
    private func shouldBeActiveCapitalUnderThreat(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let player = city?.player else {
            fatalError("cant get player")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        if !city.isCapital() {
            return false
        }

        if let mostThreatened = player.militaryAI?.mostThreatenedCity(in: gameModel) {

            if mostThreatened.location == city.location && mostThreatened.threatValue() > 200 {
                return true
            }
        }

        return false
    }

    private func shouldBeActiveUnderBlockade(for city: AbstractCity?) -> Bool {

        return false
    }

    private func shouldBeActiveRiverCity(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        return gameModel.river(at: city.location)
    }

    /// "Coast City" City Strategy: give a little flavor to this city
    private func shouldBeActiveCoastCity(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        return gameModel.isCoastal(at: city.location)
    }

    // "Hill City" City Strategy: give a little flavor to this city
    private func shouldBeActiveHillCity(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        var numHills = 0

        // scan the nearby tiles to see if there are at least two hills in the vicinity
        for pt in city.location.areaWith(radius: City.workRadius) {

            if let tile = gameModel.tile(at: pt) {
                if tile.owner()?.leader == city.player?.leader && tile.hasHills() {
                    numHills += 1

                    if numHills > 1 {
                        return true
                    }
                }
            }
        }

        return false
    }

    /// "Mountain City" City Strategy: give a little flavor to this city
    private func shouldBeActiveMountainCity(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        // scan the nearby tiles to see if there is a mountain close enough to build an observatory
        for pt in city.location.areaWith(radius: City.workRadius) {

            if let tile = gameModel.tile(at: pt) {
                if tile.has(feature: .mountains) {

                    return true
                }
            }
        }

        return false
    }

    /// "Forest City" City Strategy: give a little flavor to this city
    private func shouldBeActiveForestCity(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        var numForests = 0

        // scan the nearby tiles to see if there are at least two forests in the vicinity
        for pt in city.location.areaWith(radius: City.workRadius) {

            if let tile = gameModel.tile(at: pt) {
                if tile.owner()?.leader == city.player?.leader && tile.has(feature: .forest) {
                    numForests += 1

                    if numForests > 1 {
                        return true
                    }
                }
            }
        }

        return false
    }

    /// "Jungle City" City Strategy: give a little flavor to this city
    private func shouldBeActiveJungleCity(for city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        var numForests = 0

        // scan the nearby tiles to see if there are at least two jungles in the vicinity
        for pt in city.location.areaWith(radius: City.workRadius) {

            if let tile = gameModel.tile(at: pt) {
                if tile.owner()?.leader == city.player?.leader && tile.has(feature: .rainforest) {
                    numForests += 1

                    if numForests > 1 {
                        return true
                    }
                }
            }
        }

        return false
    }
}
