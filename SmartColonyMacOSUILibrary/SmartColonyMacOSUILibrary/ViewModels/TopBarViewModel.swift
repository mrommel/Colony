//
//  TopBarViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol TopBarViewModelDelegate: AnyObject {

    func tradeRoutesClicked()
    func envoysClicked()
    func menuButtonClicked()
}

public class TopBarViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var scienceYieldValueViewModel: YieldValueViewModel

    @Published
    var cultureYieldValueViewModel: YieldValueViewModel

    @Published
    var faithYieldValueViewModel: YieldValueViewModel

    @Published
    var goldYieldValueViewModel: YieldValueViewModel

    @Published
    var tourismYieldValueViewModel: YieldValueViewModel

    @Published
    var tradeRoutesLabelText: String

    @Published
    var envoysLabelText: String

    // resources

    @Published
    var showResources: Bool

    @Published
    var horsesValueViewModel: ResourceValueViewModel

    @Published
    var ironValueViewModel: ResourceValueViewModel

    @Published
    var niterValueViewModel: ResourceValueViewModel

    @Published
    var coalValueViewModel: ResourceValueViewModel

    @Published
    var oilValueViewModel: ResourceValueViewModel

    @Published
    var aluminumValueViewModel: ResourceValueViewModel

    @Published
    var uraniumValueViewModel: ResourceValueViewModel

    @Published
    var turnYearText: String

    weak var delegate: TopBarViewModelDelegate?

    init() {

        self.scienceYieldValueViewModel = YieldValueViewModel(yieldType: .science, initial: 0.0, type: .onlyDelta)
        self.cultureYieldValueViewModel = YieldValueViewModel(yieldType: .culture, initial: 0.0, type: .onlyDelta)
        self.faithYieldValueViewModel = YieldValueViewModel(yieldType: .faith, initial: 0.0, type: .valueAndDelta)
        self.goldYieldValueViewModel = YieldValueViewModel(yieldType: .gold, initial: 0.0, type: .valueAndDelta)
        self.tourismYieldValueViewModel = YieldValueViewModel(yieldType: .tourism, initial: 0.0, type: .onlyValue)

        self.tradeRoutesLabelText = "0/0"
        self.envoysLabelText = "0"

        self.showResources = false
        self.horsesValueViewModel = ResourceValueViewModel(resourceType: .horses, initial: 0)
        self.ironValueViewModel = ResourceValueViewModel(resourceType: .iron, initial: 0)
        self.niterValueViewModel = ResourceValueViewModel(resourceType: .niter, initial: 0)
        self.coalValueViewModel = ResourceValueViewModel(resourceType: .coal, initial: 0)
        self.oilValueViewModel = ResourceValueViewModel(resourceType: .oil, initial: 0)
        self.aluminumValueViewModel = ResourceValueViewModel(resourceType: .aluminum, initial: 0)
        self.uraniumValueViewModel = ResourceValueViewModel(resourceType: .uranium, initial: 0)

        self.turnYearText = "-"

        self.scienceYieldValueViewModel.delta = 0.0
        self.cultureYieldValueViewModel.delta = 0.0
        self.faithYieldValueViewModel.value = 0.0
        self.faithYieldValueViewModel.delta = 0.0
        self.goldYieldValueViewModel.value = 0.0
        self.goldYieldValueViewModel.delta = 0.0
        self.tourismYieldValueViewModel.value = 0.0
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        self.scienceYieldValueViewModel.delta = humanPlayer.science(in: gameModel)
        self.scienceYieldValueViewModel.tooltip = self.scienceTooltip(for: humanPlayer, in: gameModel)

        self.cultureYieldValueViewModel.delta = humanPlayer.culture(in: gameModel, consume: false)
        self.cultureYieldValueViewModel.tooltip = self.cultureTooltip(for: humanPlayer, in: gameModel)

        self.faithYieldValueViewModel.value = humanPlayer.religion?.faith() ?? 0.0
        self.faithYieldValueViewModel.delta = humanPlayer.faith(in: gameModel)
        self.faithYieldValueViewModel.tooltip = self.faithTooltip(for: humanPlayer, in: gameModel)

        self.goldYieldValueViewModel.value = humanPlayer.treasury?.value() ?? 0.0
        self.goldYieldValueViewModel.delta = humanPlayer.treasury?.calculateGrossGold(in: gameModel) ?? 0.0
        self.goldYieldValueViewModel.tooltip = self.goldTooltip(for: humanPlayer, in: gameModel)

        self.tourismYieldValueViewModel.value = humanPlayer.currentTourism(in: gameModel)
        self.tourismYieldValueViewModel.tooltip = self.tourismTooltip(for: humanPlayer, in: gameModel)

        let numberOfTradeRoutes = humanPlayer.numberOfTradeRoutes()
        let tradingCapacity = humanPlayer.tradingCapacity()
        self.tradeRoutesLabelText = "\(numberOfTradeRoutes)/\(tradingCapacity)"

        self.envoysLabelText = "\(humanPlayer.numberOfAvailableEnvoys())"

        // gather resource
        let numHorses = humanPlayer.numStockpile(of: .horses)
        let numIron = humanPlayer.numStockpile(of: .iron)
        let numNiter = humanPlayer.numStockpile(of: .niter)
        let numCoal = humanPlayer.numStockpile(of: .coal)
        let numOil = humanPlayer.numStockpile(of: .oil)
        let numAluminum = humanPlayer.numStockpile(of: .aluminum)
        let numUranium = humanPlayer.numStockpile(of: .uranium)

        self.showResources = numHorses + numIron + numNiter + numCoal + numOil + numAluminum + numUranium > 0

        self.horsesValueViewModel.value = numHorses
        self.horsesValueViewModel.tooltip = self.resourceTooltip(of: .horses, for: humanPlayer)

        self.ironValueViewModel.value = numIron
        self.ironValueViewModel.tooltip = self.resourceTooltip(of: .iron, for: humanPlayer)

        self.niterValueViewModel.value = numNiter
        self.niterValueViewModel.tooltip = self.resourceTooltip(of: .niter, for: humanPlayer)

        self.coalValueViewModel.value = numCoal
        self.coalValueViewModel.tooltip = self.resourceTooltip(of: .coal, for: humanPlayer)

        self.oilValueViewModel.value = numOil
        self.oilValueViewModel.tooltip = self.resourceTooltip(of: .oil, for: humanPlayer)

        self.aluminumValueViewModel.value = numAluminum
        self.aluminumValueViewModel.tooltip = self.resourceTooltip(of: .aluminum, for: humanPlayer)

        self.uraniumValueViewModel.value = numUranium
        self.uraniumValueViewModel.tooltip = self.resourceTooltip(of: .uranium, for: humanPlayer)

        self.turnYearText = gameModel.turnYear()
    }

    func tradeRoutesClicked() {

        self.delegate?.tradeRoutesClicked()
    }

    func envoysClicked() {

        self.delegate?.envoysClicked()
    }

    func menuClicked() {

        self.delegate?.menuButtonClicked()
    }
}

extension TopBarViewModel {

    func scienceTooltip(for player: AbstractPlayer?, in gameModel: GameModel?) -> NSAttributedString {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = player else {
            fatalError("cant get player")
        }

        let tooltipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Science per turn",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(title)

        let line = NSAttributedString(
            string: "\n-------------",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(line)

        let cities = gameModel.cities(of: player)

        if !cities.isEmpty {

            let scienceFromCities = player.scienceFromCities(in: gameModel)
            let citiesYield = NSAttributedString(
                string: "\n+\(scienceFromCities) from Cities",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            tooltipText.append(citiesYield)

            for cityRef in cities {

                guard let city = cityRef else {
                    continue
                }

                let scienceFromCity = city.sciencePerTurn(in: gameModel)
                let cityYield = NSAttributedString(
                    string: "\n   +\(scienceFromCity) from \(city.name)",
                    attributes: Globals.Attributs.tooltipContentAttributs
                )
                tooltipText.append(cityYield)
            }
        }

        return tooltipText
    }

    func cultureTooltip(for player: AbstractPlayer?, in gameModel: GameModel?) -> NSAttributedString {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = player else {
            fatalError("cant get player")
        }

        let tooltipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Culture per turn",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(title)

        let line = NSAttributedString(
            string: "\n-------------",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(line)

        let cities = gameModel.cities(of: player)

        if !cities.isEmpty {

            let cultureFromCities = player.cultureFromCities(in: gameModel).calc()
            let citiesYield = NSAttributedString(
                string: "\n+\(cultureFromCities) from Cities",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            tooltipText.append(citiesYield)

            for cityRef in cities {

                guard let city = cityRef else {
                    continue
                }

                let cultureFromCity = city.culturePerTurn(in: gameModel)
                let cityYield = NSAttributedString(
                    string: "\n   +\(cultureFromCity) from \(city.name)",
                    attributes: Globals.Attributs.tooltipContentAttributs
                )
                tooltipText.append(cityYield)
            }

            let cultureFromCityStates = player.cultureFromCityStates(in: gameModel).calc()
            let cityStateYield = NSAttributedString(
                string: "\n+\(cultureFromCityStates) from City States",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            tooltipText.append(cityStateYield)
        }

        return tooltipText
    }

    func faithTooltip(for player: AbstractPlayer?, in gameModel: GameModel?) -> NSAttributedString {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = player else {
            fatalError("cant get player")
        }

        let tooltipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Faith per turn",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(title)

        let line = NSAttributedString(
            string: "\n-------------",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(line)

        let cities = gameModel.cities(of: player)

        if !cities.isEmpty {

            let faithFromCities = player.faithFromCities(in: gameModel)
            let citiesYield = NSAttributedString(
                string: "\n+\(faithFromCities) from Cities",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            tooltipText.append(citiesYield)

            for cityRef in cities {

                guard let city = cityRef else {
                    continue
                }

                let faithFromCity = city.faithPerTurn(in: gameModel)
                let cityYield = NSAttributedString(
                    string: "\n   +\(faithFromCity) from \(city.name)",
                    attributes: Globals.Attributs.tooltipContentAttributs
                )
                tooltipText.append(cityYield)
            }
        }

        return tooltipText
    }

    func goldTooltip(for player: AbstractPlayer?, in gameModel: GameModel?) -> NSAttributedString {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let treasury = player.treasury else {
            fatalError("can't get treasury")
        }

        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = Globals.Icons.gold
        attachment.setImage(height: 12, offset: 0)

        let tooltipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Gold per turn",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(title)

        let line = NSAttributedString(
            string: "\n-------------",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(line)

        // in
        let cityIncome = treasury.goldFromCities(in: gameModel)
        let dealIncome = treasury.goldPerTurnFromDiplomacy(in: gameModel)
        let tradeRoutes = treasury.goldFromTradeRoutes(in: gameModel)
        let income = cityIncome + dealIncome + tradeRoutes

        let goldIncome = String(format: "%.1f", income)
        let goldFromCities = String(format: "%.1f", cityIncome)
        let goldFromDeals = String(format: "%.1f", dealIncome)
        let goldFromTradeRoutes = String(format: "%.1f", tradeRoutes)

        let incomeTitle = NSAttributedString(
            string: "\nIncome",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(incomeTitle)

        let incomeFromCities = NSAttributedString(
            string: "\n\(goldFromCities) from cities",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(incomeFromCities)

        let incomeFromDeals = NSAttributedString(
            string: "\n\(goldFromDeals) from deals",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(incomeFromDeals)

        let incomeFromTradeRoutes = NSAttributedString(
            string: "\n\(goldFromTradeRoutes) from trade routes",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(incomeFromTradeRoutes)

        let incomeSum = NSAttributedString(
            string: "\nSum: \(goldIncome)",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(incomeSum)

        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        tooltipText.append(attachmentString)

        // out
        let cityMaintenance = treasury.goldForBuildingMaintenance(in: gameModel)
        let unitMaintenance = treasury.goldForUnitMaintenance(in: gameModel)
        let dealExpenses = treasury.goldPerTurnForDiplomacy(in: gameModel)
        let expenses = cityMaintenance + unitMaintenance + dealExpenses

        let goldExpenses = String(format: "%.1f", expenses)
        let goldForCityMaintenance = String(format: "%.1f", cityMaintenance)
        let goldForUnitMaintenance = String(format: "%.1f", unitMaintenance)
        let goldForDeals = String(format: "%.1f", dealExpenses)

        let expensesTitle = NSAttributedString(
            string: "\n\nExpenses",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(expensesTitle)

        let maintenanceForCities = NSAttributedString(
            string: "\n\n\(goldForCityMaintenance) for cities",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(maintenanceForCities)

        let maintenanceForUnits = NSAttributedString(
            string: "\n\(goldForUnitMaintenance) for units",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(maintenanceForUnits)

        let moneyForDeals = NSAttributedString(
            string: "\n\(goldForDeals) for deals",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(moneyForDeals)

        let sumExpenses = NSAttributedString(
            string: "\nSum: \(goldExpenses)",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(sumExpenses)
        tooltipText.append(attachmentString)

        return tooltipText
    }

    func tourismTooltip(for player: AbstractPlayer?, in gameModel: GameModel?) -> NSAttributedString {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let tourism = player.tourism else {
            fatalError("cant get tourism")
        }

        let tooltipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: "Tourism per turn",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(title)

        let line = NSAttributedString(
            string: "\n-------------",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(line)

        let cities = gameModel.cities(of: player)

        if !cities.isEmpty {

            let tourismFromCities = tourism.currentTourism(in: gameModel)
            let citiesYield = NSAttributedString(
                string: "\n+\(tourismFromCities) from Cities",
                attributes: Globals.Attributs.tooltipContentAttributs
            )
            tooltipText.append(citiesYield)

            for cityRef in cities {

                guard let city = cityRef else {
                    continue
                }

                let tourismFromCity = city.baseTourism(in: gameModel)
                let cityYield = NSAttributedString(
                    string: "\n   +\(tourismFromCity) from \(city.name)",
                    attributes: Globals.Attributs.tooltipContentAttributs
                )
                tooltipText.append(cityYield)
            }
        }

        return tooltipText
    }

    func resourceTooltip(of resource: ResourceType, for player: AbstractPlayer?) -> NSAttributedString {

        guard let player = player else {
            fatalError("cant get player")
        }

        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = ImageCache.shared.image(for: resource.textureMarkerName())
        attachment.setImage(height: 12, offset: 0)

        let tooltipText = NSMutableAttributedString()

        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        tooltipText.append(attachmentString)

        let title = NSAttributedString(
            string: resource.name(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        tooltipText.append(title)

        let stockpileValue = player.numStockpile(of: resource)
        let stockCapacity = player.numMaxStockpile(of: resource)
        let stockpile = NSAttributedString(
            string: "\n\(stockpileValue)/\(stockCapacity) in stockpile",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(stockpile)

        let stockAccumulating = player.numAvailable(resource: resource)
        let accumulating = NSAttributedString(
            string: "\nAccumulating: +\(stockAccumulating) per turn.",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(accumulating)

        let fromImprovements = NSAttributedString(
            string: "\n* +\(stockAccumulating) from Improvements",
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        tooltipText.append(fromImprovements)

        return tooltipText
    }
}
