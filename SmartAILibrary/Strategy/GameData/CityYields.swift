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
    var percentage: Double

    init(value: Double, percentage: Double = 0.0) {

        self.value = value
        self.percentage = percentage
    }

    public mutating func set(percentage: Double) {

        self.percentage = percentage
    }

    public func calc() -> Double {

        return self.value * self.percentage
    }
}

func + (left: YieldValues, right: YieldValues) -> YieldValues {

    return YieldValues(value: left.value + right.value, percentage: left.percentage + right.percentage)
}

func + (left: YieldValues, right: Double) -> YieldValues {

    return YieldValues(value: left.value + right, percentage: left.percentage)
}

// infix operator +=
func += (lhs: inout YieldValues, rhs: YieldValues) { lhs = (lhs + rhs) }
func += (lhs: inout YieldValues, rhs: Double) { lhs = (lhs + rhs) }

extension City {

    // MARK: greatPeople functions

    public func greatPeoplePointsPerTurn(in gameModel: GameModel?) -> GreatPersonPoints {

        let greatPeoplePerTurn: GreatPersonPoints = GreatPersonPoints()

        greatPeoplePerTurn.add(other: self.greatPeoplePointsFromWonders())
        greatPeoplePerTurn.add(other: self.greatPeoplePointsFromBuildings())
        greatPeoplePerTurn.add(other: self.greatPeoplePointsFromDistricts(in: gameModel))
        greatPeoplePerTurn.add(other: self.greatPeoplePointsFromGovernments())

        greatPeoplePerTurn.modify(by: self.greatPeopleModifierFromGovernors())

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

        // universityOfSankore
        if wonders.has(wonder: .universityOfSankore) {
            // +2 Great Scientist points per turn
            greatPeoplePoints.greatScientist += 2
        }

        // greatZimbabwe
        if wonders.has(wonder: .greatZimbabwe) {
            // +2 Great Merchant points per turn
            greatPeoplePoints.greatMerchant += 2
        }

        // casaDeContratacion
        if wonders.has(wonder: .casaDeContratacion) {
            // +3 Great Merchant points per turn
            greatPeoplePoints.greatMerchant += 3
        }

        // venetianArsenal
        if wonders.has(wonder: .venetianArsenal) {
            // +2 Great Engineer points per turn
            greatPeoplePoints.greatEngineer += 2
        }

        // torreDeBelem
        if wonders.has(wonder: .torreDeBelem) {
            // +1 Great Admiral point per turn
            greatPeoplePoints.greatAdmiral += 1
        }

        return greatPeoplePoints
    }

    private func greatPeoplePointsFromBuildings() -> GreatPersonPoints {

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        let greatPeoplePoints: GreatPersonPoints = GreatPersonPoints()

        // library
        if buildings.has(building: .library) {
            // +1 Great Scientist point per turn
            greatPeoplePoints.greatScientist += 1
        }

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

        // armory
        if buildings.has(building: .armory) {
            // +1 Great General point per turn
            greatPeoplePoints.greatGeneral += 1
        }

        // university
        if buildings.has(building: .university) {
            // +1 Great Scientist point per turn
            greatPeoplePoints.greatScientist += 1
        }

        // market
        if buildings.has(building: .bank) {
            // +1 Great Merchant point per turn
            greatPeoplePoints.greatMerchant += 1
        }

        return greatPeoplePoints
    }

    private func greatPeoplePointsFromDistricts(in gameModel: GameModel?) -> GreatPersonPoints {

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let greatPeoplePoints: GreatPersonPoints = GreatPersonPoints()

        // campus - +1 Great Scientist Great Scientist point per turn.
        if districts.has(district: .campus) {

            greatPeoplePoints.greatScientist += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatScientist += 2
            }

            if player.religion?.pantheon() == .divineSpark && self.has(building: .library) {
                // +1 [GreatPerson] Great Person Points from Holy Sites (Prophet), Campuses with a Library (Scientist), and Theater Squares with an Amphitheater (Writer).
                greatPeoplePoints.greatScientist += 1
            }

            // stockhol suzerain bonus
            // Your districts with a building provide +1 [GreatPerson] Great Person point of their type ([GreatWriter] Great Writer,
            // [GreatArtist] Great Artist, and [GreatMusician] Great Musician for Theater Square districts with a building).
            if player.isSuzerain(of: .stockholm, in: gameModel) {
                if self.hasBuildings(in: .campus) {
                    greatPeoplePoints.greatScientist += 1
                }
            }
        }

        // harbor - +1 Great Admiral point per turn
        if districts.has(district: .harbor) {

            greatPeoplePoints.greatAdmiral += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatAdmiral += 2
            }

            // stockhol suzerain bonus
            // Your districts with a building provide +1 [GreatPerson] Great Person point of their type ([GreatWriter] Great Writer,
            // [GreatArtist] Great Artist, and [GreatMusician] Great Musician for Theater Square districts with a building).
            if player.isSuzerain(of: .stockholm, in: gameModel) {
                if self.hasBuildings(in: .harbor) {
                    greatPeoplePoints.greatAdmiral += 1
                }
            }
        }

        // holySite - +1 Great Prophet point per turn
        if districts.has(district: .holySite) {

            greatPeoplePoints.greatProphet += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatProphet += 2
            }

            if player.religion?.pantheon() == .divineSpark {
                // +1 [GreatPerson] Great Person Points from Holy Sites (Prophet), Campuses with a Library (Scientist), and Theater Squares with an Amphitheater (Writer).
                greatPeoplePoints.greatProphet += 1
            }

            // stockholm suzerain bonus
            // Your districts with a building provide +1 [GreatPerson] Great Person point of their type ([GreatWriter] Great Writer,
            // [GreatArtist] Great Artist, and [GreatMusician] Great Musician for Theater Square districts with a building).
            if player.isSuzerain(of: .stockholm, in: gameModel) {
                if self.hasBuildings(in: .holySite) {
                    greatPeoplePoints.greatProphet += 1
                }
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

            // stockhol suzerain bonus
            // Your districts with a building provide +1 [GreatPerson] Great Person point of their type ([GreatWriter] Great Writer,
            // [GreatArtist] Great Artist, and [GreatMusician] Great Musician for Theater Square districts with a building).
            if player.isSuzerain(of: .stockholm, in: gameModel) {
                if self.hasBuildings(in: .theatherSquare) {
                    greatPeoplePoints.greatWriter += 1
                    greatPeoplePoints.greatArtist += 1
                    greatPeoplePoints.greatMusician += 1
                }
            }
        }

        // encampment - +1 Great General point per turn
        if districts.has(district: .encampment) {

            greatPeoplePoints.greatGeneral += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatGeneral += 2
            }

            // stockhol suzerain bonus
            // Your districts with a building provide +1 [GreatPerson] Great Person point of their type ([GreatWriter] Great Writer,
            // [GreatArtist] Great Artist, and [GreatMusician] Great Musician for Theater Square districts with a building).
            if player.isSuzerain(of: .stockholm, in: gameModel) {
                if self.hasBuildings(in: .encampment) {
                    greatPeoplePoints.greatGeneral += 1
                }
            }
        }

        // commercialHub - +1 Great Merchant point per turn
        if districts.has(district: .commercialHub) {

            greatPeoplePoints.greatMerchant += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatMerchant += 2
            }

            // stockhol suzerain bonus
            // Your districts with a building provide +1 [GreatPerson] Great Person point of their type ([GreatWriter] Great Writer,
            // [GreatArtist] Great Artist, and [GreatMusician] Great Musician for Theater Square districts with a building).
            if player.isSuzerain(of: .stockholm, in: gameModel) {
                if self.hasBuildings(in: .commercialHub) {
                    greatPeoplePoints.greatMerchant += 1
                }
            }
        }

        // industrial - +1 Great Engineer point per turn
        if districts.has(district: .industrialZone) {

            greatPeoplePoints.greatEngineer += 1

            // Districts in this city provide +2 Great Person points of their type.
            if self.has(wonder: .oracle) {
                greatPeoplePoints.greatEngineer += 2
            }

            // stockhol suzerain bonus
            // Your districts with a building provide +1 [GreatPerson] Great Person point of their type ([GreatWriter] Great Writer,
            // [GreatArtist] Great Artist, and [GreatMusician] Great Musician for Theater Square districts with a building).
            if player.isSuzerain(of: .stockholm, in: gameModel) {
                if self.hasBuildings(in: .industrialZone) {
                    greatPeoplePoints.greatEngineer += 1
                }
            }
        }

        return greatPeoplePoints
    }

    private func greatPeoplePointsFromGovernments() -> GreatPersonPoints {

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get city buildings")
        }

        let greatPeoplePoints: GreatPersonPoints = GreatPersonPoints()

        // invention - +4 [GreatEngineer] Great Engineer points per turn. +2 additional [GreatEngineer] Great Engineer points for every Workshop.
        if government.has(card: .invention) {
            if buildings.has(building: .workshop) {
                greatPeoplePoints.greatEngineer += 2
            }
        }

        // frescoes - +2 [GreatArtist] Great Artist points per turn. +2 additional [GreatArtist] Great Artist points for every Art Museum.
        if government.has(card: .frescoes) {
            if buildings.has(building: .artMuseum) {
                greatPeoplePoints.greatArtist += 2
            }
        }

        // militaryOrganization - +2 [GreatGeneral] Great General points for every Armory and +4 [GreatGeneral] Great General points for every Military Academy. [GreatGeneral] Great Generals receive +2 [Movement] Movement.
        if government.has(card: .militaryOrganization) {
            if buildings.has(building: .armory) {
                greatPeoplePoints.greatGeneral += 2
            }
            if buildings.has(building: .militaryAcademy) {
                greatPeoplePoints.greatGeneral += 4
            }
        }

        // laissezFaire - +2 [GreatMerchant] Great Merchant points for every Bank and +4 [GreatMerchant] Great Merchant points for every Stock Exchange. +2 [GreatAdmiral] Great Admiral points for every Shipyard and +4 [GreatAdmiral] Great Admiral points for every Seaport.
        if government.has(card: .laissezFaire) {
            if buildings.has(building: .bank) {
                greatPeoplePoints.greatMerchant += 2
            }
            if buildings.has(building: .stockExchange) {
                greatPeoplePoints.greatMerchant += 4
            }
            if buildings.has(building: .shipyard) {
                greatPeoplePoints.greatAdmiral += 2
            }
            /*if buildings.has(building: .seaport) {
                greatPeoplePoints.greatAdmiral += 4
            }*/
        }

        return greatPeoplePoints
    }

    private func greatPeopleModifierFromGovernors() -> Double {

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        var greatPeopleModifier: Double = 1.0

        if let governor = self.governor() {
            // Pingala - grants - +100% [GreatPeople] Great People points generated per turn in the city.
            if governor.type == .pingala && governor.has(title: .grants) {
                greatPeopleModifier += 1.0
            }
        }

        // collectivism - Farms +1 [Food] Food. All cities +2 [Housing] Housing. +100% Industrial Zone adjacency bonuses.
        //          BUT: [GreatPerson] Great People Points earned 50% slower.
        if government.has(card: .collectivism) {
            greatPeopleModifier -= 0.5
        }

        return greatPeopleModifier
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

    public func productionFromTiles(in gameModel: GameModel?) -> Double {

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
        let hasStBasilsCathedral = player.has(wonder: .stBasilsCathedral, in: gameModel)
        var productionValue: Double = 0.0

        if let centerTile = gameModel.tile(at: self.location) {

            productionValue += centerTile.yields(for: player, ignoreFeature: false).production

            // The yield of the tile occupied by the city center will be increased to 2 Food and 1 Production, if either was previously lower (before any bonus yields are applied).
            if productionValue < 1.0 {
                productionValue = 1.0
            }
        }

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

                    // stBasilsCathedral
                    if workedTile.terrain() == .tundra && hasStBasilsCathedral {
                        // +1 Food, +1 Production, and +1 Culture on all Tundra tiles for this city.
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

                    // godOfTheSea - 1 Production from Fishing Boats.
                    if workedTile.improvement() == .fishingBoats && player.religion?.pantheon() == .godOfTheSea {
                        productionValue += 1.0
                    }

                    // ladyOfTheReedsAndMarshes - +2 Production from Marsh, Oasis, and Desert Floodplains.
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

                    // auckland suzerain bonus
                    // Shallow water tiles worked by [Citizen] Citizens provide +1 [Production] Production. Additional +1 when you reach the Industrial Era
                    if player.isSuzerain(of: .auckland, in: gameModel) {
                        if workedTile.terrain() == .shore {

                            productionValue += 1.0

                            if player.currentEra() == .industrial {
                                productionValue += 1.0
                            }
                        }
                    }

                    // johannesburg suzerain bonus
                    // Cities receive +1 [Production] Production for every improved resource type. After researching Industrialization it becomes +2 [Production] Production.
                    if player.isSuzerain(of: .johannesburg, in: gameModel) {
                        if workedTile.hasAnyImprovement() && workedTile.resource(for: self.player) != .none {

                            productionValue += 1.0

                            if player.has(tech: .industrialization) {
                                productionValue += 1.0
                            }
                        }
                    }
                }
            }
        }

        return productionValue
    }

    public func productionFromGovernmentType() -> Double {

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
                productionFromGovernmentType += Double(buildings.numberOfBuildings(of: BuildingCategoryType.government))
            }

            // urbanPlanning: +1 Production in all cities.
            if government.has(card: .urbanPlanning) {
                productionFromGovernmentType += 1
            }
        }

        return productionFromGovernmentType
    }

    public func productionFromDistricts(in gameModel: GameModel?) -> Double {

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var productionFromDistricts: Double = 0.0
        var policyCardModifier: Double = 1.0

        // yields from cards
        // craftsmen - +100% Industrial Zone adjacency bonuses.
        if government.has(card: .craftsmen) {
            policyCardModifier += 1.0
        }

        // fiveYearPlan - +100% Campus and Industrial Zone district adjacency bonuses.
        if government.has(card: .fiveYearPlan) {
            policyCardModifier += 1.0
        }

        // collectivism - Farms +1 [Food] Food. All cities +2 [Housing] Housing. +100% Industrial Zone adjacency bonuses.
        //          BUT: [GreatPerson] Great People Points earned 50% slower.
        if government.has(card: .collectivism) {
            policyCardModifier += 1.0
        }

        if districts.has(district: .industrialZone) {

            if let industrialLocation = self.location(of: .industrialZone) {

                for neighbor in industrialLocation.neighbors() {

                    guard let neighborTile = gameModel?.tile(at: neighbor) else {
                        continue
                    }

                    // Major bonus (+2 Production) for each adjacent Aqueduct, Dam, Canal or Bath
                    if neighborTile.district() == .aqueduct /*||
                        neighborTile.district() == .dam ||
                        neighborTile.district() == .canal ||
                        neighborTile.district() == .bath */ {
                        productionFromDistricts += 2.0 * policyCardModifier
                        continue
                    }

                    // Standard bonus (+1 Production) for each adjacent Strategic Resource and Quarry
                    if neighborTile.has(improvement: .quarry) {
                        productionFromDistricts += 1.0 * policyCardModifier
                        continue
                    }

                    if neighborTile.resource(for: player).usage() == .strategic {
                        productionFromDistricts += 1.0 * policyCardModifier
                    }

                    // Minor bonus (+½ Production) for each adjacent district tile, Mine or Lumber Mill
                    if neighborTile.has(improvement: .mine) /*|| neighborTile.has(improvement: .lumberMill)*/ {
                        productionFromDistricts += 0.5 * policyCardModifier
                    }

                    if neighborTile.district() != .none {
                        productionFromDistricts += 0.5 * policyCardModifier
                    }
                }
            }
        }

        return productionFromDistricts
    }

    public func productionFromBuildings() -> Double {

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

    public func productionFromTradeRoutes(in gameModel: GameModel?) -> Double {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let tradeRoutes = self.player?.tradeRoutes?.tradeRoutesStarting(at: self) else {
            fatalError("cant get tradeRoutes")
        }

        var productionFromTradeRoutes: Double = 0.0
        let civilizations: WeightedList<CivilizationType> = WeightedList<CivilizationType>()

        for tradeRoute in tradeRoutes {
            productionFromTradeRoutes += tradeRoute.yields(in: gameModel).production

            if tradeRoute.isInternational(in: gameModel) {
                guard let endCity = tradeRoute.endCity(in: gameModel) else {
                    continue
                }

                guard let endCityPlayer = endCity.player else {
                    continue
                }

                guard !endCityPlayer.isBarbarian() && !endCityPlayer.isFreeCity() && !endCityPlayer.isCityState() else {
                    continue
                }

                civilizations.add(weight: 1.0, for: endCityPlayer.leader.civilization())
            }
        }

        var numberOfForeignCivilizations: Int = 0

        for civilization in CivilizationType.all {

            if civilizations.weight(of: civilization) > 0.0 {
                numberOfForeignCivilizations += 1
            }
        }

        // Singapore suzerain bonus
        // Your cities receive +2 [Production] Production for each foreign civilization they have a [TradeRoute] Trade Route to.
        if player.isSuzerain(of: .singapore, in: gameModel) {
            productionFromTradeRoutes += 2.0 * Double(numberOfForeignCivilizations)
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

    public func faithFromTiles(in gameModel: GameModel?) -> Double {

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

    public func faithFromGovernmentType() -> Double {

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

                faithFromGovernmentValue += Double(buildings.numberOfBuildings(of: BuildingCategoryType.government))
            }

            // godKing
            if government.has(card: .godKing) && self.capitalValue == true {

                faithFromGovernmentValue += 1
            }
        }

        return faithFromGovernmentValue
    }

    public func faithFromBuildings() -> Double {

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

    public func faithFromDistricts(in gameModel: GameModel?) -> Double {

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var faithFromDistricts: Double = 0.0
        var policyCardModifier: Double = 1.0

        // yields from cards
        // scripture - +100% Holy Site district adjacency bonuses.
        if government.has(card: .scripture) {
            policyCardModifier += 1.0
        }

        if districts.has(district: .holySite) {

            if let holySiteLocation = self.location(of: .holySite) {

                for neighbor in holySiteLocation.neighbors() {

                    guard let neighborTile = gameModel?.tile(at: neighbor) else {
                        continue
                    }

                    if neighborTile.feature().isNaturalWonder() {
                        // Major bonus (+2 Faith) for each adjacent Natural Wonder
                        faithFromDistricts += 2.0 * policyCardModifier
                    }

                    if neighborTile.feature() == .mountains {
                        // Standard bonus (+1 Faith) for each adjacent Mountain tile
                        faithFromDistricts += 1.0 * policyCardModifier
                    }

                    if neighborTile.feature() == .forest || neighborTile.feature() == .rainforest {
                        // Minor bonus (+½ Faith) for each adjacent District District tile and each adjacent unimproved Woods tile
                        faithFromDistricts += 0.5 * policyCardModifier
                    }

                    if self.player?.religion?.pantheon() == .danceOfTheAurora {
                        if neighborTile.terrain() == .tundra {
                            // Holy Site districts get +1 Faith from adjacent Tundra tiles.
                            faithFromDistricts += 1.0
                        }
                    }

                    if self.player?.religion?.pantheon() == .desertFolklore {
                        if neighborTile.terrain() == .desert {
                            // Holy Site districts get +1 Faith from adjacent Desert tiles.
                            faithFromDistricts += 1.0
                        }
                    }

                    if self.player?.religion?.pantheon() == .desertFolklore {
                        if neighborTile.has(feature: .rainforest) {
                            // Holy Site districts get +1 Faith from adjacent Rainforest tiles.
                            faithFromDistricts += 1.0
                        }
                    }
                }
            }
        }

        if let governor = self.governor() {
            // moksha - bishop - +2 Faith per specialty district in this city.
            if governor.type == .moksha && governor.has(title: .bishop) {
                faithFromDistricts += 2.0 * Double(districts.numberOfSpecialtyDistricts())
            }
        }

        return faithFromDistricts
    }

    public func faithFromWonders(in gameModel: GameModel?) -> YieldValues {

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

    public func faithFromTradeRoutes(in gameModel: GameModel?) -> Double {

        guard let tradeRoutes = self.player?.tradeRoutes?.tradeRoutesStarting(at: self) else {
            fatalError("cant get tradeRoutes")
        }

        var faithFromTradeRoutes: Double = 0.0

        for tradeRoute in tradeRoutes {
            faithFromTradeRoutes += tradeRoute.yields(in: gameModel).faith
        }

        return faithFromTradeRoutes
    }

    public func faithFromEnvoys(in gameModel: GameModel?) -> Double {

        guard let effects = self.player?.envoyEffects(in: gameModel) else {
            fatalError("cant get envoyEffects")
        }

        var faithFromEnvoys: Double = 0.0

        for effect in effects {

            // religious: +2 Faith Faith in the Capital Capital.
            if effect.isEqual(category: .religious, at: .first) && self.capitalValue {
                faithFromEnvoys += 2.0
            }

            // religious: +2 Faith Faith in every Shrine building.
            if effect.isEqual(category: .religious, at: .third) && self.has(building: .shrine) {
                faithFromEnvoys += 2.0
            }

            // religious: +2 Faith Faith in every Temple building.
            if effect.isEqual(category: .religious, at: .sixth) && self.has(building: .temple) {
                faithFromEnvoys += 2.0
            }
        }

        return faithFromEnvoys
    }

    // MARK: culture functions

    public func culturePerTurn(in gameModel: GameModel?) -> Double {

        var culturePerTurn: YieldValues = YieldValues(value: 0.0, percentage: 1.0)

        culturePerTurn += YieldValues(value: self.cultureFromTiles(in: gameModel))
        culturePerTurn += self.cultureFromGovernmentType()
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

    public func cultureFromTiles(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var cultureFromTiles: Double = 0.0
        let hasStBasilsCathedral = player.has(wonder: .stBasilsCathedral, in: gameModel)

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

                    // stBasilsCathedral
                    if adjacentTile.terrain() == .tundra && hasStBasilsCathedral {
                        // +1 Food, +1 Production, and +1 Culture on all Tundra tiles for this city.
                        cultureFromTiles += 1.0
                    }

                    // godOfTheOpenSky - +1 Culture from Pastures.
                    if adjacentTile.improvement() == .pasture && self.player?.religion?.pantheon() == .godOfTheOpenSky {
                        cultureFromTiles += 1.0
                    }

                    // goddessOfFestivals - +1 Culture from Plantations.
                    if adjacentTile.improvement() == .plantation && self.player?.religion?.pantheon() == .goddessOfFestivals {
                        cultureFromTiles += 1.0
                    }
                }
            }
        }

        return cultureFromTiles
    }

    public func cultureFromGovernmentType() -> YieldValues {

        guard let player = self.player else {
            fatalError("Cant get player")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var cultureFromGovernmentValue: YieldValues = YieldValues(value: 0.0, percentage: 0.0)

        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // +1 to all yields for each government building and Palace in a city.
            if government.currentGovernment() == .autocracy {

                cultureFromGovernmentValue += Double(buildings.numberOfBuildings(of: BuildingCategoryType.government))
            }

            // thirdAlternative- +2 [Culture] Culture and +4 [Gold] Gold from each Research Lab, Military Academy, Coal Power Plant, Oil Power Plant, and Nuclear Power Plant.
            if government.has(card: .thirdAlternative) {
                /*if buildings.has(building: .researchLab) {
                    cultureFromGovernmentValue += 2
                }*/
                if buildings.has(building: .militaryAcademy) {
                    cultureFromGovernmentValue += 2
                }
                if buildings.has(building: .coalPowerPlant) {
                    cultureFromGovernmentValue += 2
                }
                /*if buildings.has(building: .oilPowerPlant) {
                    cultureFromGovernmentValue += 2
                }
                if buildings.has(building: .nuclearPowerPlant) {
                    cultureFromGovernmentValue += 2
                }*/
            }

            // despoticPaternalism - +4 Loyalty per turn in cities with [Governor] Governors.
            //   BUT: -15% [Science] Science and -15% [Culture] Culture in all cities without an established [Governor] Governor.
            if government.has(card: .despoticPaternalism) {
                if self.governor() == nil {
                    cultureFromGovernmentValue.percentage -= 0.15
                }
            }

            // monasticism - +75% [Science] Science in cities with a Holy Site.
            //        BUT: -25% [Culture] Culture in all cities.
            if government.has(card: .monasticism) {
                cultureFromGovernmentValue.percentage -= 0.25
            }
        }

        return cultureFromGovernmentValue
    }

    public func cultureFromDistricts(in gameModel: GameModel?) -> Double {

        guard let player = self.player else {
            fatalError("Cant get player")
        }

        guard let government = player.government else {
            fatalError("Cant get government")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var cultureFromDistricts: Double = 0.0
        var policyCardModifier: Double = 1.0

        // yields from cards
        // aesthetics - +100% Theater Square district adjacency bonuses.
        if government.has(card: .aesthetics) {
            policyCardModifier += 1.0
        }

        // meritocracy - Each city receives +1 [Culture] Culture for each specialty District it constructs.
        if government.has(card: .meritocracy) {
            cultureFromDistricts += 1.0 * Double(districts.numberOfSpecialtyDistricts())
        }

        // district
        if districts.has(district: .theatherSquare) {

            if let campusLocation = self.location(of: .theatherSquare) {

                for neighbor in campusLocation.neighbors() {

                    guard let neighborTile = gameModel?.tile(at: neighbor) else {
                        continue
                    }

                    // Major bonus (+2 Culture) for each adjacent Wonder
                    if neighborTile.feature().isNaturalWonder() {
                        cultureFromDistricts += 2.0 * policyCardModifier
                    }

                    // Major bonus (+2 Culture) for each adjacent Water Park or Entertainment Complex district tile
                    if neighborTile.district() == .entertainmentComplex {
                        cultureFromDistricts += 2.0 * policyCardModifier
                    }

                    // Major bonus (+2 Culture) for each adjacent Pamukkale tile

                    // Minor bonus (+½ Culture) for each adjacent district tile
                    if neighborTile.district() != .none {
                        cultureFromDistricts += 0.5 * policyCardModifier
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

    public func cultureFromBuildings() -> Double {

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

    public func cultureFromWonders(in gameModel: GameModel?) -> Double {

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

    public func cultureFromPopulation() -> Double {

        // science & culture from population
        return self.populationValue * 0.3
    }

    public func cultureFromTradeRoutes(in gameModel: GameModel?) -> Double {

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

        // connoisseur - +1 Culture per turn for each Citizen Citizen in the city.
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
            if effect.isEqual(category: .cultural, at: .first) && self.capitalValue {
                cultureFromEnvoys += 2.0
            }

            // +2 Culture Culture in every Amphitheater building.
            if effect.isEqual(category: .cultural, at: .third) && self.has(building: .amphitheater) {
                cultureFromEnvoys += 2.0
            }

            // +2 Culture Culture in every Art Museum and Archaeological Museum building.
            if effect.isEqual(category: .cultural, at: .sixth) {
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
        goldPerTurn += self.goldFromGovernmentType()
        goldPerTurn += YieldValues(value: self.goldFromDistricts(in: gameModel))
        goldPerTurn += YieldValues(value: self.goldFromBuildings())
        goldPerTurn += YieldValues(value: self.goldFromWonders())
        goldPerTurn += YieldValues(value: self.goldFromTradeRoutes(in: gameModel))
        goldPerTurn += YieldValues(value: self.goldFromEnvoys(in: gameModel))

        // cap yields based on loyalty
        goldPerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        return goldPerTurn.calc()
    }

    public func goldFromTiles(in gameModel: GameModel?) -> Double {

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

                    // Reyna + forestryManagement - This city receives +2 Gold for each unimproved feature.
                    if adjacentTile.has(feature: .forest) && !adjacentTile.hasAnyImprovement() {
                        if let governor = self.governor() {
                            if governor.type == .reyna && governor.has(title: .forestryManagement) {
                                goldValue = 2.0
                            }
                        }
                    }
                }
            }
        }

        return goldValue
    }

    public func goldFromGovernmentType() -> YieldValues {

        guard let player = self.player else {
            fatalError("no player provided")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var goldFromGovernmentValue: YieldValues = YieldValues(value: 0.0, percentage: 0.0)

        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // +1 to all yields for each government building and Palace in a city.
            if government.currentGovernment() == .autocracy {
                goldFromGovernmentValue += Double(buildings.numberOfBuildings(of: BuildingCategoryType.government))
            }

            // godKing
            if government.has(card: .godKing) && self.capitalValue == true {
                goldFromGovernmentValue += 1.0
            }

            // thirdAlternative- +2 [Culture] Culture and +4 [Gold] Gold from each Research Lab, Military Academy, Coal Power Plant, Oil Power Plant, and Nuclear Power Plant.
            if government.has(card: .thirdAlternative) {
                /*if buildings.has(building: .researchLab) {
                 goldFromGovernmentValue += 4
                }*/
                if buildings.has(building: .militaryAcademy) {
                    goldFromGovernmentValue += 4
                }
                if buildings.has(building: .coalPowerPlant) {
                    goldFromGovernmentValue += 4
                }
                /*if buildings.has(building: .oilPowerPlant) {
                 goldFromGovernmentValue += 4
                }
                if buildings.has(building: .nuclearPowerPlant) {
                 goldFromGovernmentValue += 4
                }*/
            }

            // - Decentralization    Cities with 6 or less [Citizen] population receive +4 Loyalty per turn.
            //    BUT: Cities with more than 6 Citizen population receive -15% [Gold] Gold.
            if government.has(card: .decentralization) && self.population() > 6 {
                goldFromGovernmentValue += YieldValues(value: 0.0, percentage: -0.15)
            }
        }

        // yields from governors
        if let governor = self.governor() {

            // Reyna + taxCollector - +2 Gold per turn for each Citizen in the city.
            if governor.type == .reyna && governor.has(title: .taxCollector) {
                goldFromGovernmentValue += 2.0 * Double(self.population())
            }
        }

        return goldFromGovernmentValue
    }

    public func goldFromDistricts(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var goldFromDistricts: Double = 0.0
        var governorModifier: Double = 1.0
        var policyCardHarborModifier: Double = 1.0
        var policyCardCommercialHubModifier: Double = 1.0

        // yields from governors
        if let governor = self.governor() {

            // Reyna + harbormaster - Double adjacency bonuses from Commercial Hubs and Harbors in the city.
            if governor.type == .reyna && governor.has(title: .harbormaster) {
                governorModifier += 1.0
            }
        }

        // yields from cards
        // navalInfrastructure - +100% Harbor district adjacency bonus.
        if government.has(card: .navalInfrastructure) {
            policyCardHarborModifier += 1.0
        }

        // townCharters - +100% Commercial Hub adjacency bonuses.
        if government.has(card: .townCharters) {
            policyCardCommercialHubModifier += 1.0
        }

        // economicUnion - +100% Commercial Hub and Harbor district adjacency bonuses.
        if government.has(card: .townCharters) {
            policyCardHarborModifier += 1.0
            policyCardCommercialHubModifier += 1.0
        }

        // harbor
        if districts.has(district: .harbor) {

            if let harborLocation = self.location(of: .harbor) {

                for neighbor in harborLocation.neighbors() {

                    guard let neighborTile = gameModel.tile(at: neighbor) else {
                        continue
                    }

                    // Major bonus (+2 Gold) for being adjacent to the City Center
                    if neighborTile.point == self.location {
                        goldFromDistricts += 2.0 * governorModifier * policyCardHarborModifier
                    }

                    // Standard bonus (+1 Gold) for each adjacent Sea resource
                    if neighborTile.isWater() && neighborTile.hasAnyResource(for: self.player) {
                        goldFromDistricts += 1.0 * governorModifier * policyCardHarborModifier
                    }

                    // Minor bonus (+½ Gold) for each adjacent District
                    if neighborTile.district() != .none {
                        goldFromDistricts += 0.5 * governorModifier * policyCardHarborModifier
                    }
                }
            }
        }

        // commercialHub
        if districts.has(district: .commercialHub) {

            if let commercialHubLocation = self.location(of: .commercialHub) {

                var harborOrRiver: Bool = false

                for neighbor in commercialHubLocation.neighbors() {

                    guard let neighborTile = gameModel.tile(at: neighbor) else {
                        continue
                    }

                    // Major bonus (+2 Gold) for a nearby River or a Harbor District.
                    if neighborTile.has(district: .harbor) {
                        harborOrRiver = true
                    }

                    // Major bonus (+2 Gold) for each adjacent Pamukkale tile.

                    // Minor bonus (+½ Gold) for each nearby District.
                    if neighborTile.district() != .none {
                        goldFromDistricts += 0.5 * governorModifier * policyCardCommercialHubModifier
                    }
                }

                // Major bonus (+2 Gold) for a nearby River or a Harbor District.",
                if gameModel.river(at: commercialHubLocation) {
                    harborOrRiver = true
                }

                if harborOrRiver {
                    goldFromDistricts += 2.0 * governorModifier * policyCardCommercialHubModifier
                }
            }
        }

        return goldFromDistricts
    }

    public func goldFromBuildings() -> Double {

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

    public func goldFromWonders() -> Double {

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

    public func goldFromTradeRoutes(in gameModel: GameModel?) -> Double {

        guard let tradeRoutes = self.player?.tradeRoutes?.tradeRoutesStarting(at: self) else {
            fatalError("cant get tradeRoutes")
        }

        var goldFromTradeRoutes: Double = 0.0

        for tradeRoute in tradeRoutes {
            goldFromTradeRoutes += tradeRoute.yields(in: gameModel).gold

            // landAcquisition - +3 Gold per turn for each foreign Trade Route passing through the city.
            if self.hasGovernorTitle(of: .landAcquisition) && tradeRoute.isInternational(in: gameModel) {
                goldFromTradeRoutes += 3
            }
        }

        return goldFromTradeRoutes
    }

    public func goldFromEnvoys(in gameModel: GameModel?) -> Double {

        guard let effects = self.player?.envoyEffects(in: gameModel) else {
            fatalError("cant get envoyEffects")
        }

        var goldFromEnvoys: Double = 0.0

        for effect in effects {

            // +4 Gold in the Capital.
            if effect.isEqual(category: .trade, at: .first) && self.capitalValue {
                goldFromEnvoys += 4.0
            }

            // +2 Gold in every Market and Lighthouse building.
            if effect.isEqual(category: .trade, at: .third) {
                if self.has(building: .market) {
                    goldFromEnvoys += 2.0
                }

                if self.has(building: .lighthouse) {
                    goldFromEnvoys += 2.0
                }
            }

            // +2 Gold in every Bank and Shipyard building.
            if effect.cityState.category() == .trade && effect.level == .sixth {
                if self.has(building: .bank) {
                    goldFromEnvoys += 2.0
                }

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
        sciencePerTurn += self.scienceFromGovernmentType()
        sciencePerTurn += YieldValues(value: self.scienceFromBuildings())
        sciencePerTurn += self.scienceFromDistricts(in: gameModel)
        sciencePerTurn += YieldValues(value: self.scienceFromWonders())
        sciencePerTurn += YieldValues(value: self.scienceFromPopulation())
        sciencePerTurn += YieldValues(value: self.scienceFromTradeRoutes(in: gameModel))
        sciencePerTurn += self.scienceFromGovernors()
        // this is broken - not sure why
        // sciencePerTurn += YieldValues(value: self.baseYieldRateFromSpecialists.weight(of: .science))
        sciencePerTurn += self.scienceFromEnvoys(in: gameModel)

        // cap yields based on loyalty
        sciencePerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        return sciencePerTurn.calc()
    }

    public func scienceFromTiles(in gameModel: GameModel?) -> Double {

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

    public func scienceFromGovernmentType() -> YieldValues {

        guard let player = self.player else {
            fatalError("Cant get player")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var scienceFromGovernmentValue: YieldValues = YieldValues(value: 0.0, percentage: 0.0)

        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // +1 to all yields for each government building and Palace in a city.
            if government.currentGovernment() == .autocracy {

                scienceFromGovernmentValue += Double(buildings.numberOfBuildings(of: BuildingCategoryType.government))
            }

            // militaryResearch - Military Academies, Seaports, and Renaissance Walls generate +2 [Science] Science.
            if government.has(card: .militaryResearch) {
                if buildings.has(building: .militaryAcademy) {
                    scienceFromGovernmentValue += 2.0
                }
                /*if buildings.has(building: .seaport) {
                    scienceFromGovernmentValue += 2.0
                }*/
                if buildings.has(building: .renaissanceWalls) {
                    scienceFromGovernmentValue += 2.0
                }
            }

            // despoticPaternalism - +4 Loyalty per turn in cities with [Governor] Governors.
            //   BUT: -15% [Science] Science and -15% [Culture] Culture in all cities without an established [Governor] Governor.
            if government.has(card: .despoticPaternalism) {
                if self.governor() == nil {
                    scienceFromGovernmentValue.percentage += -0.15
                }
            }
        }

        return scienceFromGovernmentValue
    }

    public func scienceFromDistricts(in gameModel: GameModel?) -> YieldValues {

        guard let player = self.player else {
            fatalError("Cant get player")
        }

        guard let government = player.government else {
            fatalError("Cant get government")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var scienceFromDistricts: YieldValues = YieldValues(value: 0.0, percentage: 0.0)
        var policyCardModifier: Double = 1.0

        // yields from cards
        // naturalPhilosophy - +100% Campus district adjacency bonuses.
        if government.has(card: .naturalPhilosophy) {
            policyCardModifier += 1.0
        }

        // fiveYearPlan - +100% Campus and Industrial Zone district adjacency bonuses.
        if government.has(card: .fiveYearPlan) {
            policyCardModifier += 1.0
        }

        // district
        if districts.has(district: .campus) {

            if let campusLocation = self.location(of: .campus) {

                for neighbor in campusLocation.neighbors() {

                    guard let neighborTile = gameModel?.tile(at: neighbor) else {
                        continue
                    }

                    // Major bonus (+2 Science) for each adjacent Geothermal Fissure and Reef tile.
                    if neighborTile.has(feature: .geyser) || neighborTile.has(feature: .reef) {
                        scienceFromDistricts += 2.0 * policyCardModifier
                    }

                    // Major bonus (+2 Science) for each adjacent Great Barrier Reef tile.
                    if neighborTile.has(feature: .greatBarrierReef) {
                        scienceFromDistricts += 2.0 * policyCardModifier
                    }

                    // Standard bonus (+1 Science) for each adjacent Mountain tile.
                    if neighborTile.has(feature: .mountains) {
                        scienceFromDistricts += 1.0 * policyCardModifier
                    }

                    // Minor bonus (+½ Science) for each adjacent Rainforest and district tile.
                    if neighborTile.has(feature: .rainforest) || neighborTile.district() != .none {
                        scienceFromDistricts += 0.5 * policyCardModifier
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

        // monasticism - +75% [Science] Science in cities with a Holy Site.
        //        BUT: -25% [Culture] Culture in all cities.
        if government.has(card: .monasticism) && districts.has(district: .holySite) {
            scienceFromDistricts.percentage += 0.75
        }

        return scienceFromDistricts
    }

    public func scienceFromBuildings() -> Double {

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

    public func scienceFromWonders() -> Double {

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

    public func scienceFromPopulation() -> Double {

        // science & culture from population
        return self.populationValue * 0.5
    }

    public func scienceFromTradeRoutes(in gameModel: GameModel?) -> Double {

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

        var scienceFromGovernors: YieldValues = YieldValues(value: 0.0, percentage: 0.0)

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

    public func scienceFromEnvoys(in gameModel: GameModel?) -> YieldValues {

        guard let player = self.player else {
            fatalError("Cant get player")
        }

        guard let effects = self.player?.envoyEffects(in: gameModel) else {
            fatalError("cant get envoyEffects")
        }

        var scienceFromEnvoys: YieldValues = YieldValues(value: 0.0, percentage: 0.0)

        for effect in effects {

            // +2 Science Science in the Capital Capital.
            if effect.isEqual(category: .scientific, at: .first) && self.capitalValue {
                scienceFromEnvoys += YieldValues(value: 2.0)
            }

            // +2 Science Science in every Library building.
            if effect.isEqual(category: .scientific, at: .third) && self.has(building: .library) {
                scienceFromEnvoys += YieldValues(value: 2.0)
            }

            // +2 Science Science in every University building.
            if effect.isEqual(category: .scientific, at: .sixth) && self.has(building: .university) {
                scienceFromEnvoys += YieldValues(value: 2.0)
            }

            // taruga suzerain effect
            // Your cities receive +5% [Science] Science for each different Strategic Resource they have.
            if effect.cityState == .taruga && effect.level == .suzerain {
                let differentResources = Double(self.numberOfDifferentStrategicResources(in: gameModel))
                scienceFromEnvoys += YieldValues(value: 5.0 * differentResources)
            }

            // geneva suzerain effect
            // Your cities earn +15% [Science] Science whenever you are not at war with any civilization.
            if effect.cityState == .geneva && effect.level == .suzerain {
                if player.atWarCount() == 0 {
                    scienceFromEnvoys += YieldValues(value: 0.0, percentage: 0.15)
                }
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
        foodPerTurn += self.foodFromGovernors(in: gameModel)

        // cap yields based on loyalty
        foodPerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        return foodPerTurn.calc()
    }

    public func foodFromTiles(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let government = player.government else {
            fatalError("cant get player government")
        }

        let hasHueyTeocalli = player.has(wonder: .hueyTeocalli, in: gameModel)
        let hasStBasilsCathedral = player.has(wonder: .stBasilsCathedral, in: gameModel)
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

                    // stBasilsCathedral
                    if adjacentTile.terrain() == .tundra && hasStBasilsCathedral {
                        // +1 Food, +1 Production, and +1 Culture on all Tundra tiles for this city.
                        foodValue += 1.0
                    }

                    // goddessOfTheHunt - +1 Food and +1 Production from Camps.
                    if adjacentTile.improvement() == .camp && self.player?.religion?.pantheon() == .goddessOfTheHunt {
                        foodValue += 1.0
                    }

                    // waterMill - Bonus resources improved by Farms gain +1 Food each.
                    if buildings.has(building: .waterMill) &&
                        adjacentTile.improvement() == .farm &&
                        adjacentTile.resource(for: self.player).usage() == .bonus {

                        foodValue += 1.0
                    }

                    // collectivism - Farms +1 [Food] Food. All cities +2 [Housing] Housing. +100% Industrial Zone adjacency bonuses.
                    //          BUT: [GreatPerson] Great People Points earned 50% slower.
                    if adjacentTile.improvement() == .farm && government.has(card: .collectivism) {
                        foodValue += 1.0
                    }
                }
            }
        }

        return foodValue
    }

    public func foodFromGovernmentType() -> Double {

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

                foodFromGovernmentValue += Double(buildings.numberOfBuildings(of: BuildingCategoryType.government))
            }
        }

        return foodFromGovernmentValue
    }

    public func foodFromBuildings(in gameModel: GameModel?) -> Double {

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

    public func foodFromWonders(in gameModel: GameModel?) -> Double {

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

    public func foodFromTradeRoutes(in gameModel: GameModel?) -> Double {

        guard let tradeRoutes = self.player?.tradeRoutes?.tradeRoutesStarting(at: self) else {
            fatalError("cant get tradeRoutes")
        }

        var foodFromTradeRoutes: Double = 0.0

        for tradeRoute in tradeRoutes {
            foodFromTradeRoutes += tradeRoute.yields(in: gameModel).food
        }

        return foodFromTradeRoutes
    }

    private func foodFromGovernors(in gameModel: GameModel?) -> YieldValues {

        var foodFromGovernors: YieldValues = YieldValues(value: 0.0, percentage: 0.0)

        if let governor = self.governor() {
            // surplusLogistics - +20% [Food] Food Growth in the city.
            if governor.has(title: .surplusLogistics) {
                foodFromGovernors.percentage += 0.2
            }
        }

        return foodFromGovernors
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
                    if tile.isRiverToCross(towards: neighborTile, wrapX: gameModel.wrappedX() ? gameModel.mapSize().width() : -1) {
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

        var housingFromBuildings: Double = 0.0

        housingFromBuildings += buildings.housing()

        // audienceChamber - +2 Amenities and +4 Housing in Cities with Governors.
        if buildings.has(building: .audienceChamber) && self.governor() != nil {
            housingFromBuildings += 4
        }

        return housingFromBuildings
    }

    public func housingFromDistricts(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        var housingFromDistricts: Double = 0.0

        // district
        if self.has(district: .aqueduct) {

            var hasFreshWater: Bool = false
            if let tile = gameModel.tile(at: self.location) {
                for neighbor in self.location.neighbors() {
                    if let neighborTile = gameModel.tile(at: neighbor) {
                        if tile.isRiverToCross(towards: neighborTile, wrapX: gameModel.wrappedX() ? gameModel.mapSize().width() : -1) {
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

        if self.has(district: .preserve) {
            // Grants up to 3 Housing Housing based on tile's Appeal
            if let tile = gameModel.tile(at: self.location) {
                let appealLevel = tile.appealLevel(in: gameModel)
                housingFromDistricts += Double(appealLevel.housing()) / 2.0
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

        // medinaQuarter - +2 [Housing] Housing in all cities with at least 3 specialty Districts.
        if government.has(card: .medinaQuarter) {
            if districts.numberOfSpecialtyDistricts() >= 3 {
                housingFromDistricts += 2.0
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

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var housingFromGovernment: Double = 0.0

        // All cities with a district receive +1 Housing and +1 Amenity.
        if government.currentGovernment() == .classicalRepublic {

            if districts.hasAny() {
                housingFromGovernment += 1.0
            }
        }

        // .. and +1 Housing per District.
        if government.currentGovernment() == .democracy {
            housingFromGovernment += Double(districts.numberOfBuiltDistricts())
        }

        // +1 Housing in all cities with at least 2 specialty districts.
        if government.has(card: .insulae) {
            if districts.numberOfBuiltDistricts() >= 2 {
                housingFromGovernment += 1.0
            }
        }

        // medievalWalls: +2 Housing under the Monarchy Government.
        if government.currentGovernment() == .monarchy {
            if buildings.has(building: .medievalWalls) {
                housingFromGovernment += 2.0
            }
        }

        // newDeal - +4 [Housing] Housing and +2 [Amenities] Amenities to all cities with at least 3 specialty districts.
        if government.has(card: .newDeal) {
            if districts.numberOfBuiltDistricts() >= 3 {
                housingFromGovernment += 4.0
            }
        }

        // collectivism - Farms +1 [Food] Food. All cities +2 [Housing] Housing. +100% Industrial Zone adjacency bonuses.
        //          BUT: [GreatPerson] Great People Points earned 50% slower.
        if government.has(card: .collectivism) {
            housingFromGovernment += 2.0
        }

        return housingFromGovernment
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
        if government.has(card: .civilPrestige) && self.numberOfGovernorTitles() >= 2 {

            housingValue += 2.0
        }

        if let governor = self.governor() {
            // Liang - waterWorks - +2 Housing for every Neighborhood and Aqueduct district in this city.
            if governor.type == .liang && governor.has(title: .waterWorks) {
                let numberOfNeighborhoods = self.has(district: .neighborhood) ? 1.0 : 0.0
                let numberOfAqueducts = self.has(district: .aqueduct) ? 1.0 : 0.0
                housingValue += 2.0 * (numberOfNeighborhoods + numberOfAqueducts)
            }

            // civilPrestige - Established [Governor] Governors with at least 2 [Promotion] Promotions provide +1 [Amenities] Amenity and +2 [Housing] Housing.
            if government.has(card: .civilPrestige) && governor.titles.count >= 2 {
                housingValue += 2.0
            }
        }

        return housingValue
    }

    // MARK: helper

    public func numberOfDifferentStrategicResources(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        let resources: WeightedList<ResourceType> = WeightedList<ResourceType>()

        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let workedTile = gameModel.tile(at: point) {

                    let resourceType = workedTile.resource(for: self.player)
                    if resourceType.usage() == .strategic {
                        resources.add(weight: 1, for: resourceType)
                    }
                }
            }
        }

        var result: Int = 0

        for resourceType in ResourceType.strategic {

            if resources.weight(of: resourceType) > 0.0 {
                result += 1
            }
        }

        return result
    }

    // MARK: amenities functions

    public func amenitiesPerTurn(in gameModel: GameModel?) -> Double {

        var amenitiesPerTurn: Double = 0.0

        amenitiesPerTurn += self.amenitiesFromTiles(in: gameModel)
        amenitiesPerTurn += self.amenitiesFromLuxuries()
        amenitiesPerTurn += self.amenitiesFromDistrict(in: gameModel)
        amenitiesPerTurn += self.amenitiesFromBuildings()
        amenitiesPerTurn += self.amenitiesFromWonders(in: gameModel)
        amenitiesPerTurn += self.amenitiesFromCivics(in: gameModel)

        return amenitiesPerTurn
    }

    public func amenitiesFromLuxuries() -> Double {

        return Double(self.luxuries.count)
    }

    public func amenitiesFromBuildings() -> Double {

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var amenitiesFromBuildings: Double = 0.0

        // gather amenities from buildingss
        for building in BuildingType.all {
            if buildings.has(building: building) {
                amenitiesFromBuildings += Double(building.amenities())
            }
        }

        // audienceChamber - +2 Amenities and +4 Housing in Cities with Governors.
        if buildings.has(building: .audienceChamber) && self.governor() != nil {
            amenitiesFromBuildings += 2
        }

        return amenitiesFromBuildings
    }

    public func amenitiesFromWonders(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var locationOfColosseum: HexPoint = .invalid

        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            if city.has(wonder: .colosseum) {
                locationOfColosseum = city.location
            }
        }

        var amenitiesFromWonders: Double = 0.0

        // gather amenities from buildingss
        for wonder in WonderType.all {
            if self.has(wonder: wonder) {
                amenitiesFromWonders += Double(wonder.amenities())
            }
        }

        // temple of artemis
        if self.has(wonder: .templeOfArtemis) {
            for loopPoint in self.location.areaWith(radius: 3) {

                guard let loopTile = gameModel.tile(at: loopPoint) else {
                    continue
                }
                if loopTile.has(improvement: .camp) || loopTile.has(improvement: .pasture) || loopTile.has(improvement: .plantation) {
                    // Each Camp, Pasture, and Plantation improvement within 4 tiles of this wonder provides +1 Amenities6 Amenity.
                    amenitiesFromWonders += 1.0
                }
            }
        }

        // colosseum - +2 [Culture] Culture, +2 Loyalty, +2 [Amenities] Amenities from entertainment
        // to each City Center within 6 tiles.
        if self.has(wonder: .colosseum) || locationOfColosseum.distance(to: self.location) <= 6 {
            amenitiesFromWonders += 2.0
        }

        return amenitiesFromWonders
    }

    // amenities from districts
    public func amenitiesFromDistrict(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var amenitiesFromDistrict: Double = 0.0

        // "All cities with a district receive +1 Housing6 Housing and +1 Amenities6 Amenity."
        if government.currentGovernment() == .classicalRepublic {

            if districts.hasAny() {
                amenitiesFromDistrict += 1.0
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
                    amenitiesFromDistrict += 2.0
                }
            }
        }

        return amenitiesFromDistrict
    }

    private func amenitiesFromTiles(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var amenitiesFromTiles: Double = 0.0

        var hueyTeocalliLocation: HexPoint = .invalid
        if player.has(wonder: .hueyTeocalli, in: gameModel) {
            for point in cityCitizens.workingTileLocations() {
                if cityCitizens.isWorked(at: point) {
                    if let adjacentTile = gameModel.tile(at: point) {
                        if adjacentTile.has(wonder: .hueyTeocalli) {
                            hueyTeocalliLocation = point
                        }
                    }
                }
            }
        }

        // +1 Amenity from entertainment for each Lake tile within one tile of Huey Teocalli.
        // (This includes the Lake tile where the wonder is placed.)
        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                // if let adjacentTile = gameModel.tile(at: point) {
                if point == hueyTeocalliLocation || point.isNeighbor(of: hueyTeocalliLocation) {
                    amenitiesFromTiles += 1
                }
                // }
            }
        }

        return amenitiesFromTiles
    }

    public func amenitiesFromCivics(in gameModel: GameModel?) -> Double {

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var amenitiesFromCivics: Double = 0.0

        // Retainers - +1 Amenity in cities with a garrisoned unit.
        if government.has(card: .retainers) {
            if self.garrisonedUnitValue != nil {
                amenitiesFromCivics += 1
            }
        }

        // Civil Prestige - +1 Amenity and +2 Housing in cities with established Governors with 2+ promotions.
        if government.has(card: .retainers) {
            if let governor = self.governor() {
                if governor.titles.count >= 2 {
                    amenitiesFromCivics += 1
                }
            }
        }

        // Liberalism - +1 Amenity in cities with 2+ specialty districts.
        if government.has(card: .liberalism) {
            if districts.numberOfBuiltDistricts() >= 2 {
                amenitiesFromCivics += 1
            }
        }

        // Police State - -2 Spy operation level in your lands. -1 Amenity in all cities.
        if government.has(card: .policyState) {
            amenitiesFromCivics -= 1
        }

        // New Deal - +2 Amenities and +4 Housing in all cities with 3+ specialty districts.
        if government.has(card: .newDeal) {
            if districts.numberOfBuiltDistricts() >= 3 {
                amenitiesFromCivics += 2
            }
        }

        // civilPrestige - Established [Governor] Governors with at least 2 [Promotion] Promotions provide +1 [Amenities] Amenity and +2 [Housing] Housing.
        if government.has(card: .civilPrestige) {
            if let governor = self.governor() {
                if governor.titles.count >= 2 {
                    amenitiesFromCivics += 1.0
                }
            }
        }

        // Sports Media    +100% Theater Square adjacency bonuses, and Stadiums generate +1 Amenities Amenity.
        // Music Censorship    Other civs' Rock Bands cannot enter your territory. -1 Amenities Amenity in all cities.

        // robberBarons - +50% Gold in cities with a Stock Exchange. +25% Production Production in cities with a Factory.
        //   BUT: -2 Amenities in all cities.
        if government.has(card: .robberBarons) {
            if buildings.has(building: .stockExchange) {
                amenitiesFromCivics -= 2
            }
        }

        // - Automated Workforce    +20% Production towards city projects.
        //    BUT: -1 Amenities  and -5 Loyalty in all cities.
        if government.has(card: .automatedWorkforce) {
            amenitiesFromCivics -= 1
        }

        return amenitiesFromCivics
    }
}
