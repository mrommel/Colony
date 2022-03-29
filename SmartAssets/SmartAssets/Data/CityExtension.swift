//
//  CityExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 14.09.21.
//

import SmartAILibrary

extension City {

    public func iconTexture() -> String {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var eraName: String = "-ancient"

        switch player.currentEra() {

        case .none, .ancient, .classical:
            eraName = "-ancient"
        case .medieval, .renaissance:
            eraName = "-medieval"
        case .industrial:
            eraName = "-industrial"
        case .modern, .atomic, .information, .future:
            eraName = "-modern"
        }

        var sizeName: String = "-small"

        if self.population() < 4 {
            sizeName = "-small"
        } else if self.population() < 7 {
            sizeName = "-medium"
        } else {
            sizeName = "-large"
        }

        var wallsName: String = "-noWalls"

        if self.has(building: .renaissanceWalls) {
            wallsName = "-renaissanceWalls"
        } else if self.has(building: .medievalWalls) {
            wallsName = "-medievalWalls"
        } else if self.has(building: .ancientWalls) {
            wallsName = "-ancientWalls"
        }

        return "city\(eraName)\(sizeName)\(wallsName)"
    }

    public func sciencePerTurnToolTip(in gameModel: GameModel?) -> NSAttributedString {

        let scienceFromTiles: Double = self.scienceFromTiles(in: gameModel)
        let scienceFromGovernmentType: Double = self.scienceFromGovernmentType()
        let scienceFromBuildings: Double = self.scienceFromBuildings()
        let scienceFromDistricts: Double = self.scienceFromDistricts(in: gameModel)
        let scienceFromWonders: Double = self.scienceFromWonders()
        let scienceFromPopulation: Double = self.scienceFromPopulation()
        let scienceFromTradeRoutes: Double = self.scienceFromTradeRoutes(in: gameModel)
        /*sciencePerTurn += self.scienceFromGovernors()
        sciencePerTurn += YieldValues(value: self.baseYieldRateFromSpecialists.weight(of: .science))
        sciencePerTurn += self.scienceFromEnvoys(in: gameModel)*/

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Amount of Science produced by Citizens.\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let scienceFromTilesText = NSAttributedString(
            string: "\n\(scienceFromTiles) from Worked Tiles",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(scienceFromTilesText)

        if scienceFromGovernmentType != 0.0 {
            let scienceFromGovernmentTypeText = NSAttributedString(
                string: "\n\(scienceFromGovernmentType) from Government",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(scienceFromGovernmentTypeText)
        }

        let scienceFromBuildingsText = NSAttributedString(
            string: "\n\(scienceFromBuildings) from Buildings",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(scienceFromBuildingsText)

        let scienceFromPopulationText = NSAttributedString(
            string: "\n\(scienceFromPopulation) from Population",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(scienceFromPopulationText)

        let scienceFromDistrictsText = NSAttributedString(
            string: "\n\(scienceFromDistricts) from Districts",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(scienceFromDistrictsText)

        let scienceFromWondersText = NSAttributedString(
            string: "\n\(scienceFromWonders) from Wonders",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(scienceFromWondersText)

        let scienceFromTradeRoutesText = NSAttributedString(
            string: "\n\(scienceFromTradeRoutes) from Outgoing Trade Routes",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(scienceFromTradeRoutesText)

        // modifiers?
        // amenities

        return toolTipText
    }

    public func culturePerTurnToolTip(in gameModel: GameModel?) -> NSAttributedString {

        let cultureFromTiles: Double = self.cultureFromTiles(in: gameModel)
        let cultureFromGovernmentType: Double = self.cultureFromGovernmentType()
        let cultureFromDistricts: Double = self.cultureFromDistricts(in: gameModel)
        let cultureFromBuildings: Double = self.cultureFromBuildings()
        let cultureFromWonders: Double = self.cultureFromWonders(in: gameModel)
        let cultureFromPopulation: Double = self.cultureFromPopulation()
        let cultureFromTradeRoutes: Double = self.cultureFromTradeRoutes(in: gameModel)
        /*culturePerTurn += self.cultureFromGovernors()
        culturePerTurn += YieldValues(value: self.baseYieldRateFromSpecialists.weight(of: .culture))
        culturePerTurn += YieldValues(value: self.cultureFromEnvoys(in: gameModel))*/

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Amount of Culture produced by Citizens.\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let cultureFromTilesText = NSAttributedString(
            string: "\n\(cultureFromTiles) from Worked Tiles",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(cultureFromTilesText)

        if cultureFromGovernmentType > 0.0 {
            let cultureFromGovernmentTypeText = NSAttributedString(
                string: "\n\(cultureFromGovernmentType) from Government",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(cultureFromGovernmentTypeText)
        }

        if cultureFromDistricts > 0.0 {
            let cultureFromDistrictsText = NSAttributedString(
                string: "\n\(cultureFromDistricts) from Districts",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(cultureFromDistrictsText)
        }

        let cultureFromBuildingsText = NSAttributedString(
            string: "\n\(cultureFromBuildings) from Buildings",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(cultureFromBuildingsText)

        if cultureFromWonders > 0.0 {
            let cultureFromWondersText = NSAttributedString(
                string: "\n\(cultureFromWonders) from Wonders",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(cultureFromWondersText)
        }

        let cultureFromPopulationText = NSAttributedString(
            string: "\n\(cultureFromPopulation) from Population",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(cultureFromPopulationText)

        if cultureFromTradeRoutes > 0.0 {
            let cultureFromTradeRoutesText = NSAttributedString(
                string: "\n\(cultureFromTradeRoutes) from Trade Routes",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(cultureFromTradeRoutesText)
        }

        return toolTipText
    }

    public func foodPerTurnToolTip(in gameModel: GameModel?) -> NSAttributedString {

        let foodFromTiles: Double = self.foodFromTiles(in: gameModel)
        let foodFromGovernmentType: Double = self.foodFromGovernmentType()
        let foodFromBuildings: Double = self.foodFromBuildings(in: gameModel)
        let foodFromWonders: Double = self.foodFromWonders(in: gameModel)
        let foodFromTradeRoutes: Double = self.foodFromTradeRoutes(in: gameModel)

        // cap yields based on loyalty
        // foodPerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Amount of Food produced by Citizens.\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        if foodFromTiles > 0.0 {
            let foodFromTilesText = NSAttributedString(
                string: "\n\(foodFromTiles) from Tiles",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(foodFromTilesText)
        }

        if foodFromGovernmentType > 0.0 {
            let foodFromGovernmentTypeText = NSAttributedString(
                string: "\n\(foodFromGovernmentType) from Government",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(foodFromGovernmentTypeText)
        }

        if foodFromBuildings > 0.0 {
            let foodFromBuildingsText = NSAttributedString(
                string: "\n\(foodFromBuildings) from Buildings",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(foodFromBuildingsText)
        }

        if foodFromWonders > 0.0 {
            let foodFromWondersText = NSAttributedString(
                string: "\n\(foodFromWonders) from Wonders",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(foodFromWondersText)
        }

        if foodFromTradeRoutes > 0.0 {
            let foodFromTradeRoutesText = NSAttributedString(
                string: "\n\(foodFromTradeRoutes) from Trade Routes",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(foodFromTradeRoutesText)
        }

        return toolTipText
    }

    public func productionPerTurnToolTip(in gameModel: GameModel?) -> NSAttributedString {

        let productionFromTiles: Double = self.productionFromTiles(in: gameModel)
        let productionFromGovernmentType: Double = self.productionFromGovernmentType()
        let productionFromDistricts: Double = self.productionFromDistricts(in: gameModel)
        let productionFromBuildings: Double = self.productionFromBuildings()
        let productionFromTradeRoutes: Double = self.productionFromTradeRoutes(in: gameModel)
        let featureProduction: Double = self.featureProduction()

        // cap yields based on loyalty
        // productionPerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Amount of Production produced by Citizens.\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        if productionFromTiles > 0.0 {
            let productionFromTilesText = NSAttributedString(
                string: "\n\(productionFromTiles) from Tiles",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(productionFromTilesText)
        }

        if productionFromGovernmentType > 0.0 {
            let productionFromGovernmentTypeText = NSAttributedString(
                string: "\n\(productionFromGovernmentType) from Government",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(productionFromGovernmentTypeText)
        }

        if productionFromDistricts > 0.0 {
            let productionFromDistrictsText = NSAttributedString(
                string: "\n\(productionFromDistricts) from Districts",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(productionFromDistrictsText)
        }

        if productionFromBuildings > 0.0 {
            let productionFromBuildingsText = NSAttributedString(
                string: "\n\(productionFromBuildings) from Buildings",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(productionFromBuildingsText)
        }

        if productionFromTradeRoutes > 0.0 {
            let productionFromTradeRoutesText = NSAttributedString(
                string: "\n\(productionFromTradeRoutes) from Trade Routes",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(productionFromTradeRoutesText)
        }

        if featureProduction > 0.0 {
            let featureProductionText = NSAttributedString(
                string: "\n\(featureProduction) from Feature Removal",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(featureProductionText)
        }

        return toolTipText
    }

    public func goldPerTurnToolTip(in gameModel: GameModel?) -> NSAttributedString {

        let goldFromTiles: Double = self.goldFromTiles(in: gameModel)
        let goldFromGovernmentType: Double = self.goldFromGovernmentType()
        let goldFromDistricts: Double = self.goldFromDistricts(in: gameModel)
        let goldFromBuildings: Double = self.goldFromBuildings()
        let goldFromWonders: Double = self.goldFromWonders()
        let goldFromTradeRoutes: Double = self.goldFromTradeRoutes(in: gameModel)
        let goldFromEnvoys: Double = self.goldFromEnvoys(in: gameModel)

        // cap yields based on loyalty
        // goldPerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Amount of Gold produced by Citizens.\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        if goldFromTiles > 0.0 {
            let goldFromTilesText = NSAttributedString(
                string: "\n\(goldFromTiles) from Tiles",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(goldFromTilesText)
        }

        if goldFromGovernmentType > 0.0 {
            let goldFromGovernmentTypeText = NSAttributedString(
                string: "\n\(goldFromGovernmentType) from Government",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(goldFromGovernmentTypeText)
        }

        if goldFromDistricts > 0.0 {
            let goldFromDistrictsText = NSAttributedString(
                string: "\n\(goldFromDistricts) from Districts",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(goldFromDistrictsText)
        }

        if goldFromBuildings > 0.0 {
            let goldFromBuildingsText = NSAttributedString(
                string: "\n\(goldFromBuildings) from Buildings",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(goldFromBuildingsText)
        }

        if goldFromWonders > 0.0 {
            let goldFromWondersText = NSAttributedString(
                string: "\n\(goldFromWonders) from Wonders",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(goldFromWondersText)
        }

        if goldFromTradeRoutes > 0.0 {
            let goldFromTradeRoutesText = NSAttributedString(
                string: "\n\(goldFromTradeRoutes) from Trade Routes",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(goldFromTradeRoutesText)
        }

        if goldFromEnvoys > 0.0 {
            let goldFromEnvoysText = NSAttributedString(
                string: "\n\(goldFromEnvoys) from Envoys",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(goldFromEnvoysText)
        }

        return toolTipText
    }

    public func faithPerTurnToolTip(in gameModel: GameModel?) -> NSAttributedString {

        let faithFromTiles: Double = self.faithFromTiles(in: gameModel)
        let faithFromGovernmentType: Double = self.faithFromGovernmentType()
        let faithFromBuildings: Double = self.faithFromBuildings()
        let faithFromDistricts: Double = self.faithFromDistricts(in: gameModel)
        var faithWonderYields = self.faithFromWonders(in: gameModel)
        faithWonderYields.set(percentage: 1.0)
        let faithFromWonders: Double = faithWonderYields.calc()
        let faithFromTradeRoutes: Double = self.faithFromTradeRoutes(in: gameModel)
        let faithFromEnvoys: Double = self.faithFromEnvoys(in: gameModel)

        // cap yields based on loyalty
        // faithPerTurn += YieldValues(value: 0.0, percentage: self.loyaltyState().yieldPercentage())

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Amount of Faith produced by Citizens.\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        if faithFromTiles > 0.0 {
            let faithFromTilesText = NSAttributedString(
                string: "\n\(faithFromTiles) from Tiles",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(faithFromTilesText)
        }

        if faithFromGovernmentType > 0.0 {
            let faithFromGovernmentTypeText = NSAttributedString(
                string: "\n\(faithFromGovernmentType) from Government",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(faithFromGovernmentTypeText)
        }

        if faithFromBuildings > 0.0 {
            let faithFromBuildingsText = NSAttributedString(
                string: "\n\(faithFromBuildings) from Buildings",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(faithFromBuildingsText)
        }

        if faithFromDistricts > 0.0 {
            let faithFromDistrictsText = NSAttributedString(
                string: "\n\(faithFromDistricts) from Districts",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(faithFromDistrictsText)
        }

        if faithFromWonders > 0.0 {
            let faithFromWondersText = NSAttributedString(
                string: "\n\(faithFromWonders) from Wonders",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(faithFromWondersText)
        }

        if faithFromTradeRoutes > 0.0 {
            let faithFromTradeRoutesText = NSAttributedString(
                string: "\n\(faithFromTradeRoutes) from Trade Routes",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(faithFromTradeRoutesText)
        }

        if faithFromEnvoys > 0.0 {
            let faithFromEnvoysText = NSAttributedString(
                string: "\n\(faithFromEnvoys) from Envoys",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            toolTipText.append(faithFromEnvoysText)
        }

        return toolTipText
    }
}
