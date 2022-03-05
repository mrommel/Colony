//
//  CityYields.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 01.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public struct YieldValues {

    let value: Double
    let percentage: Double

    init(value: Double, percentage: Double = 0.0) {

        self.value = value
        self.percentage = percentage
    }

    func calc() -> Double {

        return self.value * self.percentage
    }
}

func + (left: YieldValues, right: YieldValues) -> YieldValues {

    return YieldValues(value: left.value + right.value, percentage: left.percentage + right.percentage)
}

// infix operator +=
func += (lhs: inout YieldValues, rhs: YieldValues) { lhs = (lhs + rhs) }

extension City {

    // MARK: greatPeople functions

    public func greatPeoplePointsPerTurn(in gameModel: GameModel?) -> GreatPersonPoints {

        let greatPeoplePerTurn: GreatPersonPoints = GreatPersonPoints()

        greatPeoplePerTurn.add(other: self.greatPeoplePointsFromWonders())
        greatPeoplePerTurn.add(other: self.greatPeoplePointsFromBuildings())
        greatPeoplePerTurn.add(other: self.greatPeoplePointsFromDistricts())

        return greatPeoplePerTurn
    }

    private func greatPeoplePointsFromWonders() -> GreatPersonPoints {

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        let greatPeoplePoints: GreatPersonPoints = GreatPersonPoints()

        // greatLighthouse
        if wonders.has(wonder: .greatLighthouse) {
            // +1 Great Admiral point per turn
            greatPeoplePoints.greatAdmiral += 1
        }

        // greatLibrary
        if wonders.has(wonder: .greatLibrary) {
            // +1 Great Writer point per turn
            greatPeoplePoints.greatWriter += 1
            // +1 Great Scientist point per turn
            greatPeoplePoints.greatScientist += 1
        }

        // colossus
        if wonders.has(wonder: .colossus) {
            // +1 Great Admiral point per turn
            greatPeoplePoints.greatAdmiral += 1
        }

        // terracottaArmy
        if wonders.has(wonder: .terracottaArmy) {
            // +2 Great General points per turn
            greatPeoplePoints.greatGeneral += 2
        }

        // alhambra
        if wonders.has(wonder: .alhambra) {
            // +2 Great General points per turn
            greatPeoplePoints.greatGeneral += 2
        }

        return greatPeoplePoints
    }

    private func greatPeoplePointsFromBuildings() -> GreatPersonPoints {

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        let greatPeoplePoints: GreatPersonPoints = GreatPersonPoints()

        // shrine
        if buildings.has(building: .shrine) {
            // +1 Great Prophet point per turn.
            greatPeoplePoints.greatProphet += 1
        }

        // barracks
        if buildings.has(building: .barracks) {
            // +1 Great General point per turn
            greatPeoplePoints.greatGeneral += 1
        }

        // amphitheater
        if buildings.has(building: .amphitheater) {
            // +1 Great Writer point per turn
            greatPeoplePoints.greatWriter += 1
        }

        // lighthouse
        if buildings.has(building: .lighthouse) {
            // +1 Great Admiral point per turn
            greatPeoplePoints.greatAdmiral += 1
        }

        // stable
        if buildings.has(building: .stable) {
            // +1 Great General point per turn
            greatPeoplePoints.greatGeneral += 1
        }

        // market
        if buildings.has(building: .market) {
            // +1 Great Merchant point per turn
            greatPeoplePoints.greatMerchant += 1
        }

        // temple
        if buildings.has(building: .temple) {
            // +1 Great Prophet point per turn.
            greatPeoplePoints.greatProphet += 1
        }

        // workshop
        if buildings.has(building: .workshop) {
            // +1 Great Engineer point per turn
            greatPeoplePoints.greatEngineer += 1
        }

        // shipyard
        if buildings.has(building: .shipyard) {
            // +1 Great Admiral point per turn
            greatPeoplePoints.greatAdmiral += 1
        }

        return greatPeoplePoints
    }

    private func greatPeoplePointsFromDistricts() -> GreatPersonPoints {

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        let greatPeoplePoints: GreatPersonPoints = GreatPersonPoints()

        // campus - +1 Great Scientist Great Scientist point per turn.
        if districts.has(district: .campus) {

            greatPeoplePoints.greatScientist += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatScientist += 2
            }

            if self.player?.religion?.pantheon() == .divineSpark && self.has(building: .library) {
                // +1 [GreatPerson] Great Person Points from Holy Sites (Prophet), Campuses with a Library (Scientist), and Theater Squares with an Amphitheater (Writer).
                greatPeoplePoints.greatScientist += 1
            }
        }

        // harbor - +1 Great Admiral point per turn
        if districts.has(district: .harbor) {

            greatPeoplePoints.greatAdmiral += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatAdmiral += 2
            }
        }

        // holySite - +1 Great Prophet point per turn
        if districts.has(district: .holySite) {

            greatPeoplePoints.greatProphet += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatProphet += 2
            }

            if self.player?.religion?.pantheon() == .divineSpark {
                // +1 [GreatPerson] Great Person Points from Holy Sites (Prophet), Campuses with a Library (Scientist), and Theater Squares with an Amphitheater (Writer).
                greatPeoplePoints.greatProphet += 1
            }
        }

        // theatherSquare
        if districts.has(district: .theatherSquare) {

            // +1 Great Writer point per turn
            greatPeoplePoints.greatWriter += 1

            // +1 Great Artist point per turn
            greatPeoplePoints.greatArtist += 1

            // +1 Great Musician point per turn
            greatPeoplePoints.greatMusician += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatWriter += 2
                greatPeoplePoints.greatArtist += 2
                greatPeoplePoints.greatMusician += 2
            }

            if self.player?.religion?.pantheon() == .divineSpark && self.has(building: .amphitheater) {
                // +1 [GreatPerson] Great Person Points from Holy Sites (Prophet), Campuses with a Library (Scientist), and Theater Squares with an Amphitheater (Writer).
                greatPeoplePoints.greatWriter += 1
            }
        }

        // encampment - +1 Great General point per turn
        if districts.has(district: .encampment) {

            greatPeoplePoints.greatGeneral += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatGeneral += 2
            }
        }

        // commercialHub - +1 Great Merchant point per turn
        if districts.has(district: .commercialHub) {

            greatPeoplePoints.greatMerchant += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatMerchant += 2
            }
        }

        // industrial - +1 Great Engineer point per turn
        if districts.has(district: .industrialZone) {

            greatPeoplePoints.greatEngineer += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatEngineer += 2
            }
        }

        return greatPeoplePoints
    }

    // MARK: production functions

    public func productionPerTurn(in gameModel: GameModel?) -> Double {

        var productionPerTurn: YieldValues = YieldValues(value: 0.0, percentage: 1.0)

        productionPerTurn += YieldValues(value: self.productionFromTiles(in: gameModel))
        productionPerTurn += YieldValues(value: self.productionFromGovernmentType())
        productionPerTurn += YieldValues(value: self.productionFromDistricts(in: gameModel))
        productionPerTurn += YieldValues(value: self.productionFromBuildings())
        productionPerTurn += YieldValues(value: self.productionFromTradeRoutes(in: gameModel))
        productionPerTurn += YieldValues(value: self.featureProduction())

        // cap yields based on loyalty
        productionPerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        return productionPerTurn.calc()
    }

    private func productionFromTiles(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let hasHueyTeocalli = player.has(wonder: .hueyTeocalli, in: gameModel)
        var productionValue: Double = 0.0

        if let centerTile = gameModel.tile(at: self.location) {

            productionValue += centerTile.yields(for: player, ignoreFeature: false).production

            // The yield of the tile occupied by the city center will be increased to 2 Food and 1 Production, if either was previously lower (before any bonus yields are applied).
            if productionValue < 1.0 {
                productionValue = 1.0
            }
        }

        let envoyEffects = player.envoyEffects(in: gameModel)

        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let workedTile = gameModel.tile(at: point) {
                    productionValue += workedTile.yields(for: player, ignoreFeature: false).production

                    // city has petra: +2 Food, +2 Gold, and +1 Production
                    // on all Desert tiles for this city (non-Floodplains).
                    if workedTile.terrain() == .desert && !workedTile.has(feature: .floodplains) && wonders.has(wonder: .petra) {
                        productionValue += 1.0
                    }

                    // motherRussia
                    if workedTile.terrain() == .tundra && player.leader.civilization().ability() == .motherRussia {
                        // Tundra tiles provide +1 Faith and +1 Production, in addition to their usual yields.
                        productionValue += 1.0
                    }

                    // player has hueyTeocalli: +1 Food and +1 Production for each Lake tile in your empire.
                    if workedTile.has(feature: .lake) && hasHueyTeocalli {
                        productionValue += 1.0
                    }

                    // city has chichenItza: +2 Culture and +1 Production to all Rainforest tiles for this city.
                    if workedTile.has(feature: .rainforest) && self.has(wonder: .chichenItza) {
                        productionValue += 1.0
                    }

                    // etemenanki - +2 Science and +1 Production to all Marsh tiles in your empire.
                    if workedTile.has(feature: .marsh) && player.has(wonder: .etemenanki, in: gameModel) {
                        productionValue += 1.0
                    }

                    // etemenanki - +1 Science and +1 Production on all Floodplains tiles in this city.
                    if workedTile.has(feature: .floodplains) && self.has(wonder: .etemenanki) {
                        productionValue += 1.0
                    }

                    // godOfTheSea - 1 [Production] Production from Fishing Boats.
                    if workedTile.improvement() == .fishingBoats && player.religion?.pantheon() == .godOfTheSea {
                        productionValue += 1.0
                    }

                    // ladyOfTheReedsAndMarshes - +2 [Production] Production from Marsh, Oasis, and Desert Floodplains.
                    if (workedTile.has(feature: .marsh) || workedTile.has(feature: .oasis) || workedTile.has(feature: .floodplains)) &&
                        self.player?.religion?.pantheon() == .ladyOfTheReedsAndMarshes {
                        productionValue += 1.0
                    }

                    // godOfCraftsmen - +1 [Production] Production and +1 [Faith] Faith from improved Strategic resources.
                    if self.player?.religion?.pantheon() == .godOfCraftsmen {
                        if workedTile.resource(for: player).usage() == .strategic && workedTile.hasAnyImprovement() {
                            productionValue += 1.0
                        }
                    }

                    // goddessOfTheHunt - +1 [Food] Food and +1 [Production] Production from Camps.
                    if workedTile.improvement() == .camp && player.religion?.pantheon() == .goddessOfTheHunt {
                        productionValue += 1.0
                    }

                    // auckland suzerain
                    // Shallow water tiles worked by [Citizen] Citizens provide +1 [Production] Production. Additional +1 when you reach the Industrial Era
                    if workedTile.terrain() == .shore {
                        if envoyEffects.contains(where: { $0.cityState == .auckland && $0.level == .suzerain }) {

                            productionValue += 1.0

                            if player.currentEra() == .industrial {
                                productionValue += 1.0
                            }
                        }
                    }
                }
            }
        }

        return productionValue
    }

    func productionFromGovernmentType() -> Double {

        guard let player = self.player else {
            fatalError("no player provided")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var productionFromGovernmentType: Double = 0.0

        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // +1 to all yields for each government building and Palace in a city.
            if government.currentGovernment() == .autocracy {

                productionFromGovernmentType += Double(buildings.numOfBuildings(of: BuildingCategoryType.government))
            }

            // urbanPlanning: +1 Production in all cities.
            if government.has(card: .urbanPlanning) {

                productionFromGovernmentType += 1
            }
        }

        return productionFromGovernmentType
    }

    func productionFromDistricts(in gameModel: GameModel?) -> Double {

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var productionFromDistricts: Double = 0.0

        if districts.has(district: .industrialZone) {

            if let industrialLocation = self.location(of: .industrialZone) {

                for neighbor in industrialLocation.neighbors() {

                    guard let neighborTile = gameModel?.tile(at: neighbor) else {
                        continue
                    }

                    // Standard bonus (+1 Production) for each adjacent Mine or a Quarry
                    if neighborTile.has(improvement: .mine) || neighborTile.has(improvement: .quarry) {
                        productionFromDistricts += 1
                    }

                    // Minor bonus (+½ Production) for each adjacent district tile
                    if neighborTile.district() != .none {
                        productionFromDistricts += 0.5
                    }
                }
            }
        }

        return productionFromDistricts
    }

    func productionFromBuildings() -> Double {

        guard let buildings = self.buildings else {
            fatalError("no buildings set")
        }

        var productionFromBuildings: Double = 0.0

        // gather food from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                productionFromBuildings += building.yields().production
            }
        }

        return productionFromBuildings
    }

    private func productionFromTradeRoutes(in gameModel: GameModel?) -> Double {

        guard let tradeRoutes = self.player?.tradeRoutes?.tradeRoutesStarting(at: self) else {
            fatalError("cant get tradeRoutes")
        }

        var productionFromTradeRoutes: Double = 0.0

        for tradeRoute in tradeRoutes {
            productionFromTradeRoutes += tradeRoute.yields(in: gameModel).production
        }

        return productionFromTradeRoutes
    }

    // MARK: faith functions

    public func faithPerTurn(in gameModel: GameModel?) -> Double {

        var faithPerTurn: YieldValues = YieldValues(value: 0.0, percentage: 1.0)

        faithPerTurn += YieldValues(value: self.faithFromTiles(in: gameModel))
        faithPerTurn += YieldValues(value: self.faithFromGovernmentType())
        faithPerTurn += YieldValues(value: self.faithFromBuildings())
        faithPerTurn += YieldValues(value: self.faithFromDistricts(in: gameModel))
        faithPerTurn += self.faithFromWonders(in: gameModel)
        faithPerTurn += YieldValues(value: self.faithFromTradeRoutes(in: gameModel))
        faithPerTurn += YieldValues(value: self.faithFromEnvoys(in: gameModel))

        // cap yields based on loyalty
        faithPerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        return faithPerTurn.calc()
    }

    private func faithFromTiles(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        var faithFromTiles: Double = 0.0

        if let centerTile = gameModel.tile(at: self.location) {

            faithFromTiles += centerTile.yields(for: self.player, ignoreFeature: false).faith
        }

        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    faithFromTiles += adjacentTile.yields(for: self.player, ignoreFeature: false).faith

                    // mausoleumAtHalicarnassus - +1 Science, +1 Faith, and +1 Culture to all Coast tiles in this city.
                    if adjacentTile.terrain() == .shore && wonders.has(wonder: .mausoleumAtHalicarnassus) {
                        faithFromTiles += 1.0
                    }

                    // motherRussia - Tundra tiles provide +1 Faith and +1 Production, in addition to their usual yields.
                    if adjacentTile.terrain() == .tundra && player?.leader.civilization().ability() == .motherRussia {
                        faithFromTiles += 1.0
                    }

                    // stoneCircles - +2 [Faith] Faith from Quarries.
                    if self.player?.religion?.pantheon() == .stoneCircles {
                        if adjacentTile.improvement() == .quarry {
                            faithFromTiles += 2.0
                        }
                    }

                    // earthGoddess - +1 [Faith] Faith from tiles with Breathtaking Appeal.
                    if self.player?.religion?.pantheon() == .earthGoddess {
                        if adjacentTile.appealLevel(in: gameModel) == .breathtaking {
                            faithFromTiles += 1.0
                        }
                    }

                    // godOfCraftsmen - +1 [Production] Production and +1 [Faith] Faith from improved Strategic resources.
                    if self.player?.religion?.pantheon() == .godOfCraftsmen {
                        if adjacentTile.resource(for: player).usage() == .strategic && adjacentTile.hasAnyImprovement() {
                            faithFromTiles += 1.0
                        }
                    }

                    // religiousIdols - +2 [Faith] Faith from Mines over Luxury and Bonus resources.
                    if self.player?.religion?.pantheon() == .religiousIdols {
                        let resourceUsage = adjacentTile.resource(for: player).usage()
                        if (resourceUsage == .luxury || resourceUsage == .bonus) && adjacentTile.improvement() == .mine {
                            faithFromTiles += 2.0
                        }
                    }
                }
            }
        }

        return faithFromTiles
    }

    private func faithFromGovernmentType() -> Double {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var faithFromGovernmentValue: Double = 0.0

        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // +1 to all yields for each government building and Palace in a city.
            if government.currentGovernment() == .autocracy {

                faithFromGovernmentValue += Double(buildings.numOfBuildings(of: BuildingCategoryType.government))
            }

            // godKing
            if government.has(card: .godKing) && self.capitalValue == true {

                faithFromGovernmentValue += 1
            }
        }

        return faithFromGovernmentValue
    }

    private func faithFromBuildings() -> Double {

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var faithFromBuildings: Double = 0.0

        // gather yields from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                faithFromBuildings += building.yields().faith
            }
        }

        return faithFromBuildings
    }

    private func faithFromDistricts(in gameModel: GameModel?) -> Double {

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var faithFromDistricts: Double = 0.0

        if districts.has(district: .holySite) {

            if let holySiteLocation = self.location(of: .holySite) {

                for neighbor in holySiteLocation.neighbors() {

                    guard let neighborTile = gameModel?.tile(at: neighbor) else {
                        continue
                    }

                    if neighborTile.feature().isNaturalWonder() {
                        // Major bonus (+2 Faith) for each adjacent Natural Wonder
                        faithFromDistricts += 2.0
                    }

                    if neighborTile.feature() == .mountains {
                        // Standard bonus (+1 Faith) for each adjacent Mountain tile
                        faithFromDistricts += 1.0
                    }

                    if neighborTile.feature() == .forest || neighborTile.feature() == .rainforest {
                        // Minor bonus (+½ Faith) for each adjacent District District tile and each adjacent unimproved Woods tile
                        faithFromDistricts += 0.5
                    }

                    if self.player?.religion?.pantheon() == .danceOfTheAurora {
                        if neighborTile.terrain() == .tundra {
                            // Holy Site districts get +1 [Faith] Faith from adjacent Tundra tiles.
                            faithFromDistricts += 1.0
                        }
                    }

                    if self.player?.religion?.pantheon() == .desertFolklore {
                        if neighborTile.terrain() == .desert {
                            // Holy Site districts get +1 [Faith] Faith from adjacent Desert tiles.
                            faithFromDistricts += 1.0
                        }
                    }

                    if self.player?.religion?.pantheon() == .desertFolklore {
                        if neighborTile.has(feature: .rainforest) {
                            // Holy Site districts get +1 [Faith] Faith from adjacent Rainforest tiles.
                            faithFromDistricts += 1.0
                        }
                    }
                }
            }
        }

        return faithFromDistricts
    }

    private func faithFromWonders(in gameModel: GameModel?) -> YieldValues {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var faithFromWonders: Double = 0.0
        var faithPercentageFromWonders: Double = 0.0

        // stonehenge - +2 Faith
        if self.has(wonder: .stonehenge) {
            faithFromWonders += 2.0
        }

        // oracle - +1 Faith
        if self.has(wonder: .oracle) {
            faithFromWonders += 1.0
        }

        // mahabodhiTemple - +4 Faith
        if self.has(wonder: .mahabodhiTemple) {
            faithFromWonders += 4.0
        }

        // kotokuIn - +20% Faith in this city.
        if self.has(wonder: .kotokuIn) {
            faithPercentageFromWonders += 0.2
        }

        // jebelBarkal - Provides +4 Faith to all your cities that are within 6 tiles.
        if player.has(wonder: .jebelBarkal, in: gameModel) {
            if let wonderCity = player.city(with: .jebelBarkal, in: gameModel) {
                if wonderCity.location.distance(to: self.location) <= 6 {
                    faithFromWonders += 4.0
                }
            }
        }

        return YieldValues(value: faithFromWonders, percentage: faithPercentageFromWonders)
    }

    private func faithFromTradeRoutes(in gameModel: GameModel?) -> Double {

        guard let tradeRoutes = self.player?.tradeRoutes?.tradeRoutesStarting(at: self) else {
            fatalError("cant get tradeRoutes")
        }

        var faithFromTradeRoutes: Double = 0.0

        for tradeRoute in tradeRoutes {
            faithFromTradeRoutes += tradeRoute.yields(in: gameModel).faith
        }

        return faithFromTradeRoutes
    }

    private func faithFromEnvoys(in gameModel: GameModel?) -> Double {

        guard let effects = self.player?.envoyEffects(in: gameModel) else {
            fatalError("cant get envoyEffects")
        }

        var faithFromEnvoys: Double = 0.0

        for effect in effects {

            // religious: +2 Faith Faith in the Capital Capital.
            if effect.category == .religious && effect.level == .first && self.capitalValue {
                faithFromEnvoys += 2.0
            }

            // religious: +2 Faith Faith in every Shrine building.
            if effect.category == .religious && effect.level == .third && self.has(building: .shrine) {
                faithFromEnvoys += 2.0
            }

            // religious: +2 Faith Faith in every Temple building.
            if effect.category == .religious && effect.level == .sixth && self.has(building: .temple) {
                faithFromEnvoys += 2.0
            }
        }

        return faithFromEnvoys
    }

    // MARK: culture functions

    public func culturePerTurn(in gameModel: GameModel?) -> Double {

        var culturePerTurn: YieldValues = YieldValues(value: 0.0, percentage: 1.0)

        culturePerTurn += YieldValues(value: self.cultureFromTiles(in: gameModel))
        culturePerTurn += YieldValues(value: self.cultureFromGovernmentType())
        culturePerTurn += YieldValues(value: self.cultureFromDistricts(in: gameModel))
        culturePerTurn += YieldValues(value: self.cultureFromBuildings())
        culturePerTurn += YieldValues(value: self.cultureFromWonders(in: gameModel))
        culturePerTurn += YieldValues(value: self.cultureFromPopulation())
        culturePerTurn += YieldValues(value: self.cultureFromTradeRoutes(in: gameModel))
        culturePerTurn += self.cultureFromGovernors()
        culturePerTurn += YieldValues(value: self.baseYieldRateFromSpecialists.weight(of: .culture))
        culturePerTurn += YieldValues(value: self.cultureFromEnvoys(in: gameModel))

        // cap yields based on loyalty
        culturePerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        return culturePerTurn.calc()
    }

    private func cultureFromTiles(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        var cultureFromTiles: Double = 0.0

        if let centerTile = gameModel.tile(at: self.location) {

            cultureFromTiles += centerTile.yields(for: self.player, ignoreFeature: false).culture
        }

        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    cultureFromTiles += adjacentTile.yields(for: self.player, ignoreFeature: false).culture

                    // city has mausoleumAtHalicarnassus: +1 Science, +1 Faith,
                    // and +1 Culture to all Coast tiles in this city.
                    if adjacentTile.terrain() == .shore && self.has(wonder: .mausoleumAtHalicarnassus) {
                        cultureFromTiles += 1.0
                    }

                    // city has chichenItza: +2 Culture and +1 Production to all Rainforest tiles for this city.
                    if adjacentTile.has(feature: .rainforest) && self.has(wonder: .chichenItza) {
                        cultureFromTiles += 2.0
                    }

                    // godOfTheOpenSky - +1 Culture from Pastures.
                    if adjacentTile.improvement() == .pasture && self.player?.religion?.pantheon() == .godOfTheOpenSky {
                        cultureFromTiles += 1.0
                    }

                    // goddessOfFestivals - +1 [Culture] Culture from Plantations.
                    if adjacentTile.improvement() == .plantation && self.player?.religion?.pantheon() == .goddessOfFestivals {
                        cultureFromTiles += 1.0
                    }
                }
            }
        }

        return cultureFromTiles
    }

    private func cultureFromGovernmentType() -> Double {

        guard let player = self.player else {
            fatalError("Cant get player")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var cultureFromGovernmentValue: Double = 0.0

        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // +1 to all yields for each government building and Palace in a city.
            if government.currentGovernment() == .autocracy {

                cultureFromGovernmentValue += Double(buildings.numOfBuildings(of: BuildingCategoryType.government))
            }
        }

        return cultureFromGovernmentValue
    }

    private func cultureFromDistricts(in gameModel: GameModel?) -> Double {

        guard let player = self.player else {
            fatalError("Cant get player")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var cultureFromDistricts: Double = 0.0

        // district
        if districts.has(district: .campus) {

            if let campusLocation = self.location(of: .campus) {

                for neighbor in campusLocation.neighbors() {

                    guard let neighborTile = gameModel?.tile(at: neighbor) else {
                        continue
                    }

                    // Major bonus (+2 Culture) for each adjacent Wonder
                    if neighborTile.feature().isNaturalWonder() {
                        cultureFromDistricts += 2
                    }

                    // Major bonus (+2 Culture) for each adjacent Water Park or Entertainment Complex district tile
                    if neighborTile.district() == .entertainmentComplex {
                        cultureFromDistricts += 2
                    }

                    // Major bonus (+2 Culture) for each adjacent Pamukkale tile

                    // Minor bonus (+½ Culture) for each adjacent district tile
                    if neighborTile.district() != .none {
                        cultureFromDistricts += 0.5
                    }
                }
            }
        }

        // penBrushAndVoice + golden - +1 [Culture] Culture per Specialty District for each city.
        if player.currentAge() == .golden && player.has(dedication: .penBrushAndVoice) {

            for districtType in DistrictType.all {
                if districts.has(district: districtType) {
                    if districtType.isSpecialty() {
                        cultureFromDistricts += 1.0
                    }
                }
            }
        }

        return cultureFromDistricts
    }

    private func cultureFromBuildings() -> Double {

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var cultureFromBuildings: Double = 0.0

        // gather yields from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                cultureFromBuildings += building.yields().culture
            }
        }

        // Monument: +1 additional Culture if city is at maximum Loyalty.
        if buildings.has(building: .monument) && self.loyaltyState() == .loyal {

            cultureFromBuildings += 1
        }

        return cultureFromBuildings
    }

    private func cultureFromWonders(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var cultureFromWonders: Double = 0.0

        var locationOfColosseum: HexPoint = .invalid

        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            if city.has(wonder: .colosseum) {
                locationOfColosseum = city.location
            }
        }

        // pyramids
        if self.has(wonder: .pyramids) {
            // +2 Culture
            cultureFromWonders += 2.0
        }

        // oracle
        if self.has(wonder: .oracle) {
            // +1 Culture
            cultureFromWonders += 1.0
        }

        // colosseum - +2 Culture for every city in 6 tiles
        if self.has(wonder: .colosseum) || locationOfColosseum.distance(to: self.location) <= 6 {
            cultureFromWonders += 2.0
        }

        return cultureFromWonders
    }

    private func cultureFromPopulation() -> Double {

        // science & culture from population
        return self.populationValue * 0.3
    }

    private func cultureFromTradeRoutes(in gameModel: GameModel?) -> Double {

        guard let tradeRoutes = self.player?.tradeRoutes?.tradeRoutesStarting(at: self) else {
            fatalError("cant get tradeRoutes")
        }

        var cultureFromTradeRoutes: Double = 0.0

        for tradeRoute in tradeRoutes {
            cultureFromTradeRoutes += tradeRoute.yields(in: gameModel).culture
        }

        return cultureFromTradeRoutes
    }

    private func cultureFromGovernors() -> YieldValues {

        var cultureFromGovernors: YieldValues = YieldValues(value: 0.0, percentage: 0.0)

        // +1 Culture per turn for each Citizen Citizen in the city.
        if self.hasGovernorTitle(of: .connoisseur) {
            cultureFromGovernors += YieldValues(value: Double(self.population()))
        }

        // 15% increase in Science and Culture generated by the city.
        if self.hasGovernorTitle(of: .librarian) {
            cultureFromGovernors += YieldValues(value: 0.0, percentage: 0.15)
        }

        return cultureFromGovernors
    }

    private func cultureFromEnvoys(in gameModel: GameModel?) -> Double {

        guard let effects = self.player?.envoyEffects(in: gameModel) else {
            fatalError("cant get envoyEffects")
        }

        var cultureFromEnvoys: Double = 0.0

        for effect in effects {

            // +2 Culture Culture in the Capital Capital.
            if effect.category == .cultural && effect.level == .first && self.capitalValue {
                cultureFromEnvoys += 2.0
            }

            // +2 Culture Culture in every Amphitheater building.
            if effect.category == .cultural && effect.level == .third && self.has(building: .amphitheater) {
                cultureFromEnvoys += 2.0
            }

            // +2 Culture Culture in every Art Museum and Archaeological Museum building.
            if effect.category == .cultural && effect.level == .sixth {
                fatalError("not handled")
                /*if self.has(building: .museum) {
                 cultureFromEnvoys += 2.0
                 }
                 if self.has(building: .arch) {
                 cultureFromEnvoys += 2.0
                 }
                 */
            }
        }

        return cultureFromEnvoys
    }

    // MARK: gold functions

    public func goldPerTurn(in gameModel: GameModel?) -> Double {

        var goldPerTurn: YieldValues = YieldValues(value: 0.0, percentage: 1.0)

        goldPerTurn += YieldValues(value: self.goldFromTiles(in: gameModel))
        goldPerTurn += YieldValues(value: self.goldFromGovernmentType())
        goldPerTurn += YieldValues(value: self.goldFromDistricts(in: gameModel))
        goldPerTurn += YieldValues(value: self.goldFromBuildings())
        goldPerTurn += YieldValues(value: self.goldFromWonders())
        goldPerTurn += YieldValues(value: self.goldFromTradeRoutes(in: gameModel))
        goldPerTurn += YieldValues(value: self.goldFromEnvoys(in: gameModel))

        // cap yields based on loyalty
        goldPerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        return goldPerTurn.calc()
    }

    private func goldFromTiles(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        var goldValue: Double = 0.0

        if let centerTile = gameModel.tile(at: self.location) {

            goldValue += centerTile.yields(for: self.player, ignoreFeature: false).gold
        }

        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    goldValue += adjacentTile.yields(for: self.player, ignoreFeature: false).gold

                    if adjacentTile.terrain() == .desert && !adjacentTile.has(feature: .floodplains) && wonders.has(wonder: .petra) {
                        // +2 Food, +2 Gold, and +1 Production on all Desert tiles for this city (non-Floodplains).
                        goldValue += 2.0
                    }
                }
            }
        }

        return goldValue
    }

    private func goldFromGovernmentType() -> Double {

        guard let player = self.player else {
            fatalError("no player provided")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var goldFromGovernmentValue: Double = 0.0

        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // +1 to all yields for each government building and Palace in a city.
            if government.currentGovernment() == .autocracy {

                goldFromGovernmentValue += Double(buildings.numOfBuildings(of: BuildingCategoryType.government))
            }

            // godKing
            if government.has(card: .godKing) && self.capitalValue == true {

                goldFromGovernmentValue += 1.0
            }
        }

        return goldFromGovernmentValue
    }

    private func goldFromDistricts(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var goldFromDistricts: Double = 0.0

        if districts.has(district: .harbor) {

            if let harborLocation = self.location(of: .harbor) {

                for neighbor in harborLocation.neighbors() {

                    guard let neighborTile = gameModel.tile(at: neighbor) else {
                        continue
                    }

                    // Major bonus (+2 Gold) for being adjacent to the City Center
                    if neighborTile.point == self.location {
                        goldFromDistricts += 2.0
                    }

                    // Standard bonus (+1 Gold) for each adjacent Sea resource
                    if neighborTile.isWater() && neighborTile.hasAnyResource(for: self.player) {
                        goldFromDistricts += 1.0
                    }

                    // Minor bonus (+½ Gold) for each adjacent District
                    if neighborTile.district() != .none {
                        goldFromDistricts += 0.5
                    }
                }
            }
        }

        if districts.has(district: .commercialHub) {

            if let commercialHubLocation = self.location(of: .commercialHub) {

                var harborOrRiver: Bool = false

                for neighbor in commercialHubLocation.neighbors() {

                    guard let neighborTile = gameModel.tile(at: neighbor) else {
                        continue
                    }

                    // Major bonus (+2 Gold) for a nearby River or a Harbor District.",
                    if neighborTile.has(district: .harbor) {
                        harborOrRiver = true
                    }

                    // Major bonus (+2 Gold) for each adjacent Pamukkale tile.",

                    // Minor bonus (+½ Gold) for each nearby District.",
                    if neighborTile.district() != .none {
                        goldFromDistricts += 0.5
                    }
                }

                // Major bonus (+2 Gold) for a nearby River or a Harbor District.",
                if gameModel.river(at: commercialHubLocation) {
                    harborOrRiver = true
                }

                if harborOrRiver {
                    goldFromDistricts += 2.0
                }
            }
        }

        return goldFromDistricts
    }

    private func goldFromBuildings() -> Double {

        guard let buildings = self.buildings else {
            fatalError("Cant get buildings")
        }

        var goldFromBuildings: Double = 0.0

        //
        if buildings.has(building: .palace) {
            goldFromBuildings += BuildingType.palace.yields().gold
        }

        // gather yields from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                goldFromBuildings += building.yields().gold
            }
        }

        return goldFromBuildings
    }

    private func goldFromWonders() -> Double {

        guard let wonders = self.wonders else {
            fatalError("Cant get wonders")
        }

        var goldFromWonders: Double = 0.0

        // greatLighthouse
        if wonders.has(wonder: .greatLighthouse) {
            // +3 Gold
            goldFromWonders += 3.0
        }

        // colossus
        if wonders.has(wonder: .colossus) {
            // +3 Gold
            goldFromWonders += 3.0
        }

        return goldFromWonders
    }

    private func goldFromTradeRoutes(in gameModel: GameModel?) -> Double {

        guard let tradeRoutes = self.player?.tradeRoutes?.tradeRoutesStarting(at: self) else {
            fatalError("cant get tradeRoutes")
        }

        var goldFromTradeRoutes: Double = 0.0

        for tradeRoute in tradeRoutes {
            goldFromTradeRoutes += tradeRoute.yields(in: gameModel).gold

            // +3 Gold per turn for each foreign Trade Route Trade Route passing through the city.
            if self.hasGovernorTitle(of: .landAcquisition) && tradeRoute.isInternational(in: gameModel) {
                goldFromTradeRoutes += 3
            }
        }

        return goldFromTradeRoutes
    }

    private func goldFromEnvoys(in gameModel: GameModel?) -> Double {

        guard let effects = self.player?.envoyEffects(in: gameModel) else {
            fatalError("cant get envoyEffects")
        }

        var goldFromEnvoys: Double = 0.0

        for effect in effects {

            // +4 Gold Gold in the Capital Capital.
            if effect.category == .trade && effect.level == .first && self.capitalValue {
                goldFromEnvoys += 4.0
            }

            // +2 Gold Gold in every Market and Lighthouse building.
            if effect.category == .trade && effect.level == .third {
                if self.has(building: .market) {
                    goldFromEnvoys += 2.0
                }

                if self.has(building: .lighthouse) {
                    goldFromEnvoys += 2.0
                }
            }

            // +2 Gold Gold in every Bank and Shipyard building.
            if effect.category == .trade && effect.level == .sixth {
                fatalError("not handled")
                /*if self.has(building: .bank) {
                    goldFromEnvoys += 2.0
                }*/

                if self.has(building: .shipyard) {
                    goldFromEnvoys += 2.0
                }
            }
        }

        return goldFromEnvoys
    }

    // MARK: science functions

    public func sciencePerTurn(in gameModel: GameModel?) -> Double {

        var sciencePerTurn: YieldValues = YieldValues(value: 0.0, percentage: 1.0)

        sciencePerTurn += YieldValues(value: self.scienceFromTiles(in: gameModel))
        sciencePerTurn += YieldValues(value: self.scienceFromGovernmentType())
        sciencePerTurn += YieldValues(value: self.scienceFromBuildings())
        sciencePerTurn += YieldValues(value: self.scienceFromDistricts(in: gameModel))
        sciencePerTurn += YieldValues(value: self.scienceFromWonders())
        sciencePerTurn += YieldValues(value: self.scienceFromPopulation())
        sciencePerTurn += YieldValues(value: self.scienceFromTradeRoutes(in: gameModel))
        sciencePerTurn += self.scienceFromGovernors()
        sciencePerTurn += YieldValues(value: self.baseYieldRateFromSpecialists.weight(of: .science))
        sciencePerTurn += YieldValues(value: self.scienceFromEnvoys(in: gameModel))

        // cap yields based on loyalty
        sciencePerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        return sciencePerTurn.calc()
    }

    private func scienceFromTiles(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        guard let player = self.player else {
            fatalError("no player provided")
        }

        var scienceFromTiles: Double = 0.0

        if let centerTile = gameModel.tile(at: self.location) {

            scienceFromTiles += centerTile.yields(for: self.player, ignoreFeature: false).science
        }

        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    scienceFromTiles += adjacentTile.yields(for: self.player, ignoreFeature: false).science

                    // mausoleumAtHalicarnassus
                    if adjacentTile.terrain() == .shore && self.has(wonder: .mausoleumAtHalicarnassus) {
                        // +1 Science, +1 Faith, and +1 Culture to all Coast tiles in this city.
                        scienceFromTiles += 1.0
                    }

                    // etemenanki - +2 Science and +1 Production to all Marsh tiles in your empire.
                    if adjacentTile.has(feature: .marsh) && player.has(wonder: .etemenanki, in: gameModel) {
                        scienceFromTiles += 2.0
                    }

                    // etemenanki - +1 Science and +1 Production on all Floodplains tiles in this city.
                    if adjacentTile.has(feature: .floodplains) && self.has(wonder: .etemenanki) {
                        scienceFromTiles += 1.0
                    }
                }
            }
        }

        return scienceFromTiles
    }

    private func scienceFromGovernmentType() -> Double {

        guard let player = self.player else {
            fatalError("Cant get player")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var scienceFromGovernmentValue: Double = 0.0

        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // +1 to all yields for each government building and Palace in a city.
            if government.currentGovernment() == .autocracy {

                scienceFromGovernmentValue += Double(buildings.numOfBuildings(of: BuildingCategoryType.government))
            }
        }

        return scienceFromGovernmentValue
    }

    private func scienceFromDistricts(in gameModel: GameModel?) -> Double {

        guard let player = self.player else {
            fatalError("Cant get player")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var scienceFromDistricts: Double = 0.0

        // district
        if districts.has(district: .campus) {

            if let campusLocation = self.location(of: .campus) {

                for neighbor in campusLocation.neighbors() {

                    guard let neighborTile = gameModel?.tile(at: neighbor) else {
                        continue
                    }

                    // Major bonus (+2 Science) for each adjacent Geothermal Fissure and Reef tile.
                    if neighborTile.has(feature: .geyser) || neighborTile.has(feature: .reef) {
                        scienceFromDistricts += 2.0
                    }

                    // Major bonus (+2 Science) for each adjacent Great Barrier Reef tile.
                    if neighborTile.has(feature: .greatBarrierReef) {
                        scienceFromDistricts += 2.0
                    }

                    // Standard bonus (+1 Science) for each adjacent Mountain tile.
                    if neighborTile.has(feature: .mountains) {
                        scienceFromDistricts += 1.0
                    }

                    // Minor bonus (+½ Science) for each adjacent Rainforest and district tile.
                    if neighborTile.has(feature: .rainforest) || neighborTile.district() != .none {
                        scienceFromDistricts += 0.5
                    }
                }
            }
        }

        // freeInquiry + golden - Commercial Hubs and Harbors provide [Science] Science equal to their [Gold] Gold bonus.
        if player.currentAge() == .golden && player.has(dedication: .freeInquiry) {
            if districts.has(district: .commercialHub) {
                scienceFromDistricts += 2.0 // not exactly what the bonus says
            }

            if districts.has(district: .harbor) {
                scienceFromDistricts += 2.0 // not exactly what the bonus says
            }
        }

        return scienceFromDistricts
    }

    private func scienceFromBuildings() -> Double {

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        guard let greatPeople = self.player?.greatPeople else {
            fatalError("cant get greatPeople")
        }

        var scienceFromBuildings: Double = 0.0

        // gather yields from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                scienceFromBuildings += building.yields().science
            }

            // Libraries provide +1 Science.
            // https://civilization.fandom.com/wiki/Hypatia_(Civ6)
            if building == .library && greatPeople.hasRetired(greatPerson: .hypatia) {
                scienceFromBuildings += 1
            }
        }

        return scienceFromBuildings
    }

    private func scienceFromWonders() -> Double {

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        var scienceFromWonders: Double = 0.0

        // greatLibrary - +2 Science
        if wonders.has(wonder: .greatLibrary) {
            scienceFromWonders += 2.0
        }

        return scienceFromWonders
    }

    private func scienceFromPopulation() -> Double {

        // science & culture from population
        return self.populationValue * 0.5
    }

    private func scienceFromTradeRoutes(in gameModel: GameModel?) -> Double {

        guard let tradeRoutes = self.player?.tradeRoutes?.tradeRoutesStarting(at: self) else {
            fatalError("cant get tradeRoutes")
        }

        var scienceFromTradeRoutes: Double = 0.0

        for tradeRoute in tradeRoutes {
            scienceFromTradeRoutes += tradeRoute.yields(in: gameModel).science
        }

        return scienceFromTradeRoutes
    }

    private func scienceFromGovernors() -> YieldValues {

        var scienceFromGovernors: YieldValues = YieldValues(value: 0.0, percentage: 1.0)

        // +1 Science per turn for each Citizen in the city.
        if self.hasGovernorTitle(of: .researcher) {
            scienceFromGovernors += YieldValues(value: Double(self.population()))
        }

        // 15% increase in Science and Culture generated by the city.
        if self.hasGovernorTitle(of: .librarian) {
            scienceFromGovernors += YieldValues(value: 0.0, percentage: 0.15)
        }

        return scienceFromGovernors
    }

    private func scienceFromEnvoys(in gameModel: GameModel?) -> Double {

        guard let effects = self.player?.envoyEffects(in: gameModel) else {
            fatalError("cant get envoyEffects")
        }

        var scienceFromEnvoys: Double = 0.0

        for effect in effects {

            // +2 Science Science in the Capital Capital.
            if effect.category == .scientific && effect.level == .first && self.capitalValue {
                scienceFromEnvoys += 2.0
            }

            // +2 Science Science in every Library building.
            if effect.category == .scientific && effect.level == .third && self.has(building: .library) {
                scienceFromEnvoys += 2.0
            }

            // +2 Science Science in every University building.
            if effect.category == .scientific && effect.level == .sixth /* && (self.has(building: .university) */ {
                fatalError("not handled")
                scienceFromEnvoys += 2.0
            }
        }

        return scienceFromEnvoys
    }

    // MARK: food functions

    public func foodPerTurn(in gameModel: GameModel?) -> Double {

        var foodPerTurn: YieldValues = YieldValues(value: 0.0, percentage: 1.0)

        foodPerTurn += YieldValues(value: self.foodFromTiles(in: gameModel))
        foodPerTurn += YieldValues(value: self.foodFromGovernmentType())
        foodPerTurn += YieldValues(value: self.foodFromBuildings(in: gameModel))
        foodPerTurn += YieldValues(value: self.foodFromWonders(in: gameModel))
        foodPerTurn += YieldValues(value: self.foodFromTradeRoutes(in: gameModel))

        // cap yields based on loyalty
        foodPerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        return foodPerTurn.calc()
    }

    private func foodFromTiles(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let hasHueyTeocalli = player.has(wonder: .hueyTeocalli, in: gameModel)
        var foodValue: Double = 0.0

        if let centerTile = gameModel.tile(at: self.location) {

            foodValue += centerTile.yields(for: self.player, ignoreFeature: false).food

            // The yield of the tile occupied by the city center will be increased to 2 Food and 1 Production, if either was previously lower (before any bonus yields are applied).
            if foodValue < 2.0 {
                foodValue = 2.0
            }
        }

        for point in cityCitizens.workingTileLocations() {

            // DEBUG
            /*if cityCitizens.isWorked(at: point) {
                print("-- working tile at: \(point)")
            } else {
                print("-- non working tile at: \(point)")
            }*/

            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    foodValue += adjacentTile.yields(for: self.player, ignoreFeature: false).food

                    if adjacentTile.terrain() == .desert && !adjacentTile.has(feature: .floodplains) && wonders.has(wonder: .petra) {
                        // +2 Food, +2 Gold, and +1 Production on all Desert tiles for this city (non-Floodplains).
                        foodValue += 2.0
                    }

                    // +1 Food and +1 Production for each Lake tile in your empire.
                    if adjacentTile.has(feature: .lake) && hasHueyTeocalli {
                        foodValue += 1.0
                    }

                    // goddessOfTheHunt - +1 [Food] Food and +1 [Production] Production from Camps.
                    if adjacentTile.improvement() == .camp && self.player?.religion?.pantheon() == .goddessOfTheHunt {
                        foodValue += 1.0
                    }
                }
            }
        }

        return foodValue
    }

    private func foodFromGovernmentType() -> Double {

        guard let player = self.player else {
            fatalError("no player provided")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var foodFromGovernmentValue: Double = 0.0

        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // +1 to all yields for each government building and Palace in a city.
            if government.currentGovernment() == .autocracy {

                foodFromGovernmentValue += Double(buildings.numOfBuildings(of: BuildingCategoryType.government))
            }
        }

        return foodFromGovernmentValue
    }

    private func foodFromBuildings(in gameModel: GameModel?) -> Double {

        guard let buildings = self.buildings else {
            fatalError("no buildings set")
        }

        var foodFromBuildings: Double = 0.0

        // gather food from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                foodFromBuildings += building.yields().food
            }
        }

        // handle special building rules
        if buildings.has(building: .waterMill) {
            foodFromBuildings += self.amountOfNearby(resource: .rice, in: gameModel)
            foodFromBuildings += self.amountOfNearby(resource: .wheat, in: gameModel)
        }

        if buildings.has(building: .lighthouse) {
            foodFromBuildings += self.amountOfNearby(terrain: .shore, in: gameModel)
            // fixme: lake feature
        }

        return foodFromBuildings
    }

    private func foodFromWonders(in gameModel: GameModel?) -> Double {

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        var foodFromWonders: Double = 0.0

        if wonders.has(wonder: .templeOfArtemis) {
            // +4 Food
            foodFromWonders += 4.0
        }

        return foodFromWonders
    }

    private func foodFromTradeRoutes(in gameModel: GameModel?) -> Double {

        guard let tradeRoutes = self.player?.tradeRoutes?.tradeRoutesStarting(at: self) else {
            fatalError("cant get tradeRoutes")
        }

        var foodFromTradeRoutes: Double = 0.0

        for tradeRoute in tradeRoutes {
            foodFromTradeRoutes += tradeRoute.yields(in: gameModel).food
        }

        return foodFromTradeRoutes
    }

    // MARK: housing functions

    public func housingPerTurn(in gameModel: GameModel?) -> Double {

        var housingPerTurn: YieldValues = YieldValues(value: 0.0, percentage: 1.0)

        housingPerTurn += YieldValues(value: self.baseHousing(in: gameModel))
        housingPerTurn += YieldValues(value: self.housingFromBuildings())
        housingPerTurn += YieldValues(value: self.housingFromDistricts(in: gameModel))
        housingPerTurn += YieldValues(value: self.housingFromWonders(in: gameModel))
        housingPerTurn += YieldValues(value: self.housingFromImprovements(in: gameModel))
        housingPerTurn += YieldValues(value: housingFromGovernment())
        housingPerTurn += YieldValues(value: self.housingFromGovernors())

        // cap yields based on loyalty
        housingPerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        return housingPerTurn.calc()
    }

    public func baseHousing(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if let tile = gameModel.tile(at: self.location) {
            for neighbor in self.location.neighbors() {
                if let neighborTile = gameModel.tile(at: neighbor) {
                    if tile.isRiverToCross(towards: neighborTile) {
                        return 5
                    }
                }
            }
        }

        if gameModel.isCoastal(at: self.location) {
            return 3
        }

        return 2
    }

    public func housingFromBuildings() -> Double {

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        return buildings.housing()
    }

    public func housingFromDistricts(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var housingFromDistricts: Double = 0.0

        // district
        if self.has(district: .aqueduct) {

            var hasFreshWater: Bool = false
            if let tile = gameModel.tile(at: self.location) {
                for neighbor in self.location.neighbors() {
                    if let neighborTile = gameModel.tile(at: neighbor) {
                        if tile.isRiverToCross(towards: neighborTile) {
                            hasFreshWater = true
                        }
                    }
                }
            }

            // Cities that do not yet have existing fresh water receive up to 6 Housing.
            if !hasFreshWater {
                housingFromDistricts += 6
            } else {
                // Cities that already have existing fresh water will instead get 2 Housing.
                housingFromDistricts += 2
            }
        }

        // for now there can only be one
        if self.has(district: .neighborhood) {

            // A district in your city that provides Housing based on the Appeal of the tile.
            if let neighborhoodLocation = self.location(of: .neighborhood) {
                if let neighborhoodTile = gameModel.tile(at: neighborhoodLocation) {
                    let appeal = neighborhoodTile.appealLevel(in: gameModel)
                    housingFromDistricts += Double(appeal.housing())
                }
            }
        }

        if self.has(district: .holySite) {

            // riverGoddess - +2 [Amenities] Amenities and +2 [Housing] Housing to cities if they have a Holy Site district adjacent to a River.
            if let holySiteLocation = self.location(of: .holySite) {

                var isHolySiteAdjacentToRiver = false

                for neighbor in holySiteLocation.neighbors() {

                    if gameModel.river(at: neighbor) {
                        isHolySiteAdjacentToRiver = true
                        break
                    }
                }

                if isHolySiteAdjacentToRiver {
                    housingFromDistricts += 2.0
                }
            }
        }

        return housingFromDistricts
    }

    public func housingFromGovernment() -> Double {

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var housingFromDistricts: Double = 0.0

        // All cities with a district receive +1 Housing6 Housing and +1 Amenities6 Amenity.
        if government.currentGovernment() == .classicalRepublic {

            if districts.hasAny() {
                housingFromDistricts += 1.0
            }
        }

        // .. and +1 Housing6 Housing per District.
        if government.currentGovernment() == .democracy {
            housingFromDistricts += Double(districts.numberOfBuiltDistricts())
        }

        // +1 Housing6 Housing in all cities with at least 2 specialty districts.
        if government.has(card: .insulae) {
            if districts.numberOfBuiltDistricts() >= 2 {
                housingFromDistricts += 1.0
            }
        }

        return housingFromDistricts
    }

    public func housingFromWonders(in gameModel: GameModel?) -> Double {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var housingFromWonders: Double = 0.0

        // city has templeOfArtemis: +3 Housing
        if self.has(wonder: .templeOfArtemis) {
            housingFromWonders += 3.0
        }

        // city has hangingGardens: +2 Housing
        if self.has(wonder: .hangingGardens) {
            housingFromWonders += 2.0
        }

        // player has angkorWat: +1 Housing in all cities.
        if player.has(wonder: .angkorWat, in: gameModel) {
            housingFromWonders += 2.0
        }

        return housingFromWonders
    }

    // Each Farm, Pasture, Plantation, or Camp supports a small amount of Citizen6 Population — 1 Housing6 Housing for every 2 such improvements.
    private func housingFromImprovements(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        var farms: Int = 0
        var pastures: Int = 0
        var plantations: Int = 0
        var camps: Int = 0

        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {

                    // farms
                    if adjacentTile.has(improvement: .farm) {
                        farms += 1
                    }

                    // pastures
                    if adjacentTile.has(improvement: .pasture) {
                        pastures += 1
                    }

                    // plantations
                    if adjacentTile.has(improvement: .plantation) {
                        plantations += 1
                    }

                    // camps
                    if adjacentTile.has(improvement: .camp) {
                        camps += 1
                    }
                }
            }
        }

        var housingValue: Double = 0.0

        housingValue += Double((farms / 2))
        housingValue += Double((pastures / 2))
        housingValue += Double((plantations / 2))
        housingValue += Double((camps / 2))

        return housingValue
    }

    private func housingFromGovernors() -> Double {

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        var housingValue: Double = 0.0

        // Established Governors with at least 2 Promotions provide +1 Amenity and +2 Housing.
        if government.has(card: .civilPrestige) && self.numOfGovernorTitles() >= 2 {

            housingValue += 2.0
        }

        return housingValue
    }
}
