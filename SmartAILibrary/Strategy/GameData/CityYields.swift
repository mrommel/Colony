//
//  CityYields.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 01.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

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
            // +1 Admiral6 Great Admiral point per turn
            greatPeoplePoints.greatAdmiral += 1
        }

        // greatLibrary
        if wonders.has(wonder: .greatLibrary) {
            // +1 Writer6 Great Writer point per turn
            greatPeoplePoints.greatWriter += 1
            // +1 Scientist6 Great Scientist point per turn
            greatPeoplePoints.greatScientist += 1
        }

        // colossus
        if wonders.has(wonder: .colossus) {
            // +1 Admiral6 Great Admiral point per turn
            greatPeoplePoints.greatAdmiral += 1
        }

        // terracottaArmy
        if wonders.has(wonder: .terracottaArmy) {
            // +2 General6 Great General points per turn
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
            // +1 Prophet6 Great Prophet point per turn.
            greatPeoplePoints.greatProphet += 1
        }

        // barracks
        if buildings.has(building: .barracks) {
            // +1 General6 Great General point per turn
            greatPeoplePoints.greatGeneral += 1
        }

        // amphitheater
        if buildings.has(building: .amphitheater) {
            // +1 Writer6 Great Writer point per turn
            greatPeoplePoints.greatWriter += 1
        }

        // lighthouse
        if buildings.has(building: .lighthouse) {
            //+1 Admiral6 Great Admiral point per turn
            greatPeoplePoints.greatAdmiral += 1
        }

        // stable
        if buildings.has(building: .stable) {
            // +1 General6 Great General point per turn
            greatPeoplePoints.greatGeneral += 1
        }

        // market
        if buildings.has(building: .market) {
            // +1 Merchant6 Great Merchant point per turn
            greatPeoplePoints.greatMerchant += 1
        }

        // temple
        if buildings.has(building: .temple) {
            // +1 Prophet6 Great Prophet point per turn.
            greatPeoplePoints.greatProphet += 1
        }

        // workshop
        if buildings.has(building: .workshop) {
            // +1 Engineer6 Great Engineer point per turn
            greatPeoplePoints.greatEngineer += 1
        }

        // shipyard
        if buildings.has(building: .shipyard) {
            // +1 Admiral6 Great Admiral point per turn
            greatPeoplePoints.greatAdmiral += 1
        }

        return greatPeoplePoints
    }
    
    private func greatPeoplePointsFromDistricts() -> GreatPersonPoints {
        
        guard let districts = self.districts else {
            fatalError("cant get districts")
        }
        
        let greatPeoplePoints: GreatPersonPoints = GreatPersonPoints()
        
        // harbor
        if districts.has(district: .harbor) {
            // +1 Admiral6 Great Admiral point per turn
            greatPeoplePoints.greatAdmiral += 1
        }

        // holySite
        if districts.has(district: .holySite) {
            // +1 Prophet6 Great Prophet point per turn.
            greatPeoplePoints.greatProphet += 1
        }

        return greatPeoplePoints
    }
    
    // MARK: production functions

    public func productionPerTurn(in gameModel: GameModel?) -> Double {

        var productionPerTurn: Double = 0.0

        productionPerTurn += self.productionFromTiles(in: gameModel)
        productionPerTurn += self.productionFromGovernmentType()
        productionPerTurn += self.productionFromBuildings()
        productionPerTurn += self.productionFromTradeRoutes(in: gameModel)
        productionPerTurn += self.featureProduction()

        return productionPerTurn
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

        var productionValue: Double = 0.0

        if let centerTile = gameModel.tile(at: self.location) {

            productionValue += centerTile.yields(for: self.player, ignoreFeature: false).production

            // The yield of the tile occupied by the city center will be increased to 2 Food and 1 Production, if either was previously lower (before any bonus yields are applied).
            if productionValue < 1.0 {
                productionValue = 1.0
            }
        }

        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    productionValue += adjacentTile.yields(for: self.player, ignoreFeature: false).production

                    if adjacentTile.terrain() == .desert && !adjacentTile.has(feature: .floodplains) && wonders.has(wonder: .petra) {
                        // +2 Civ6Food Food, +2 Civ6Gold Gold, and +1 Civ6Production Production on all Desert tiles for this city (non-Floodplains).
                        productionValue += 1.0
                    }
                    
                    // motherRussia
                    if adjacentTile.terrain() == .tundra && player?.leader.civilization().ability() == .motherRussia {
                        // Tundra tiles provide +1 Civ6Faith Faith and +1 Civ6Production Production, in addition to their usual yields.
                        productionValue += 1.0
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

        var faithPerTurn: Double = 0.0

        faithPerTurn += self.faithFromTiles(in: gameModel)
        faithPerTurn += self.faithFromGovernmentType()
        faithPerTurn += self.faithFromBuildings()
        faithPerTurn += self.faithFromWonders()
        faithPerTurn += self.faithFromTradeRoutes(in: gameModel)

        return faithPerTurn
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

                    // mausoleumAtHalicarnassus
                    if adjacentTile.terrain() == .shore && wonders.has(wonder: .mausoleumAtHalicarnassus) {
                        // +1 Civ6Science Science, +1 Civ6Faith Faith, and +1 Civ6Culture Culture to all Coast tiles in this city.
                        faithFromTiles += 1.0
                    }
                    
                    // motherRussia
                    if adjacentTile.terrain() == .tundra && player?.leader.civilization().ability() == .motherRussia {
                        // Tundra tiles provide +1 Civ6Faith Faith and +1 Civ6Production Production, in addition to their usual yields.
                        faithFromTiles += 1.0
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

    private func faithFromWonders() -> Double {

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        var faithFromWonders: Double = 0.0

        // stonehenge
        if wonders.has(wonder: .stonehenge) {
            // +2 Civ6Faith Faith
            faithFromWonders += 2.0
        }

        // oracle
        if wonders.has(wonder: .oracle) {
            // +1 Civ6Faith Faith
            faithFromWonders += 1.0
        }

        // mahabodhiTemple
        if wonders.has(wonder: .mahabodhiTemple) {
            // +4 Civ6Faith Faith
            faithFromWonders += 4.0
        }

        return faithFromWonders
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
    
    // MARK: culture functions
    
    public func culturePerTurn(in gameModel: GameModel?) -> Double {

        var culturePerTurn: Double = 0.0

        culturePerTurn += self.cultureFromTiles(in: gameModel)
        culturePerTurn += self.cultureFromGovernmentType()
        culturePerTurn += self.cultureFromBuildings()
        culturePerTurn += self.cultureFromWonders()
        culturePerTurn += self.cultureFromPopulation()
        culturePerTurn += self.cultureFromTradeRoutes(in: gameModel)
        culturePerTurn += self.baseYieldRateFromSpecialists.weight(of: .culture)

        return culturePerTurn
    }

    private func cultureFromTiles(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        var cultureFromTiles: Double = 0.0

        if let centerTile = gameModel.tile(at: self.location) {

            cultureFromTiles += centerTile.yields(for: self.player, ignoreFeature: false).culture
        }

        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    cultureFromTiles += adjacentTile.yields(for: self.player, ignoreFeature: false).culture

                    // mausoleumAtHalicarnassus
                    if adjacentTile.terrain() == .shore && wonders.has(wonder: .mausoleumAtHalicarnassus) {
                        // +1 Civ6Science Science, +1 Civ6Faith Faith, and +1 Civ6Culture Culture to all Coast tiles in this city.
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

        return cultureFromBuildings
    }

    private func cultureFromWonders() -> Double {

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        var cultureFromWonders: Double = 0.0

        // pyramids
        if wonders.has(wonder: .pyramids) {
            // +2 Civ6Culture Culture
            cultureFromWonders += 2.0
        }

        // oracle
        if wonders.has(wonder: .oracle) {
            // +1 Civ6Culture Culture
            cultureFromWonders += 1.0
        }

        // colosseum
        if wonders.has(wonder: .colosseum) {
            // +2 Civ6Culture Culture
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
    
    // MARK: gold functions
    
    public func goldPerTurn(in gameModel: GameModel?) -> Double {

        var goldPerTurn: Double = 0.0

        goldPerTurn += self.goldFromTiles(in: gameModel)
        goldPerTurn += self.goldFromGovernmentType()
        goldPerTurn += self.goldFromBuildings()
        goldPerTurn += self.goldFromWonders()
        goldPerTurn += self.goldFromTradeRoutes(in: gameModel)

        return goldPerTurn
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
                        // +2 Civ6Food Food, +2 Civ6Gold Gold, and +1 Civ6Production Production on all Desert tiles for this city (non-Floodplains).
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
            // +3 Civ6Gold Gold
            goldFromWonders += 3.0
        }

        // colossus
        if wonders.has(wonder: .colossus) {
            // +3 Civ6Gold Gold
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
        }
        
        return goldFromTradeRoutes
    }
    
    // MARK: science functions

    public func sciencePerTurn(in gameModel: GameModel?) -> Double {

        var sciencePerTurn: Double = 0.0

        sciencePerTurn += self.scienceFromTiles(in: gameModel)
        sciencePerTurn += self.scienceFromGovernmentType()
        sciencePerTurn += self.scienceFromBuildings()
        sciencePerTurn += self.scienceFromWonders()
        sciencePerTurn += self.scienceFromPopulation()
        sciencePerTurn += self.scienceFromTradeRoutes(in: gameModel)
        sciencePerTurn += self.baseYieldRateFromSpecialists.weight(of: .science)

        return sciencePerTurn
    }
    
    private func scienceFromTiles(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
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
                    if adjacentTile.terrain() == .shore && wonders.has(wonder: .mausoleumAtHalicarnassus) {
                        // +1 Civ6Science Science, +1 Civ6Faith Faith, and +1 Civ6Culture Culture to all Coast tiles in this city.
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

    private func scienceFromBuildings() -> Double {

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var scienceFromBuildings: Double = 0.0

        // gather yields from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                scienceFromBuildings += building.yields().science
            }
        }

        return scienceFromBuildings
    }

    private func scienceFromWonders() -> Double {

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        var scienceFromWonders: Double = 0.0

        if wonders.has(wonder: .greatLibrary) {
            // +2 Civ6Science Science
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
    
    // MARK: food functions
    
    public func foodPerTurn(in gameModel: GameModel?) -> Double {
        
        var foodPerTurn: Double = 0.0
        
        foodPerTurn += self.foodFromTiles(in: gameModel)
        foodPerTurn += self.foodFromGovernmentType()
        foodPerTurn += self.foodFromBuildings(in: gameModel)
        foodPerTurn += self.foodFromWonders(in: gameModel)
        foodPerTurn += self.foodFromTradeRoutes(in: gameModel)
        
        return foodPerTurn
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
                        // +2 Civ6Food Food, +2 Civ6Gold Gold, and +1 Civ6Production Production on all Desert tiles for this city (non-Floodplains).
                        foodValue += 2.0
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
            // +4 Civ6Food Food
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
        
        var housing = self.baseHousing(in: gameModel)
        housing += self.housingFromBuildings()
        housing += self.housingFromGovernmentType()
        housing += self.housingFromWonders()
        housing += self.housingFromImprovements(in: gameModel)
         
        return housing
    }
    
    func baseHousing(in gameModel: GameModel?) -> Double {
        
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
    
    private func housingFromBuildings() -> Double {
    
        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }
        
        return buildings.housing()
    }
    
    // housing from government
    private func housingFromGovernmentType() -> Double {
        
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
            
        // All cities with a district receive +1 Housing6 Housing and +1 Amenities6 Amenity.
        if government.currentGovernment() == .classicalRepublic {

            if districts.hasAny() {
                housingFromGovernment += 1.0
            }
        }
        
        // +1 Housing6 Housing per level of Walls.
        if government.currentGovernment() == .monarchy {

            if buildings.has(building: .ancientWalls) {
                housingFromGovernment += 1.0
            }
            
            if buildings.has(building: .medievalWalls) {
                housingFromGovernment += 2.0
            }
            
            if buildings.has(building: .renaissanceWalls) {
                housingFromGovernment += 3.0
            }
        }
        
        // .. and +1 Housing6 Housing per District.
        if government.currentGovernment() == .democracy {
            housingFromGovernment += Double(districts.numberOfBuildDsitricts())
        }
        
        // +1 Housing6 Housing in all cities with at least 2 specialty districts.
        if government.has(card: .insulae) {
            if districts.numberOfBuildDsitricts() >= 2 {
                housingFromGovernment += 1.0
            }
        }
        
        return housingFromGovernment
    }
    
    private func housingFromWonders() -> Double {
        
        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }
        
        var housingFromWonders: Double = 0.0
        
        if wonders.has(wonder: .templeOfArtemis) {
            // +3 Housing6 Housing
            housingFromWonders += 3.0
        }
        
        if wonders.has(wonder: .hangingGardens) {
            // +2 Housing6 Housing
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
}
