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

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Amount of Culture produced by Citizens.\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        return toolTipText
    }

    public func foodPerTurnToolTip(in gameModel: GameModel?) -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Amount of Food produced by Citizens.\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        return toolTipText
    }

    public func productionPerTurnToolTip(in gameModel: GameModel?) -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Amount of Production produced by Citizens.\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        return toolTipText
    }

    public func goldPerTurnToolTip(in gameModel: GameModel?) -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Amount of Gold produced by Citizens.\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        return toolTipText
    }

    public func faithPerTurnToolTip(in gameModel: GameModel?) -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Amount of Faith produced by Citizens.\n",
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        return toolTipText
    }
}
