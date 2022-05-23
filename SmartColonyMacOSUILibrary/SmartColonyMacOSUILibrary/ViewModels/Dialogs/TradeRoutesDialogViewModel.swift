//
//  TradeRoutesDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

enum TradeRoutesViewType {

    case myRoutes
    case foreign
    case available
}

class TradeRoutesDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var viewType: TradeRoutesViewType = .myRoutes

    @Published
    var selectedStartCityIndex: Int = 0 {
        didSet {
            self.updateTradeRouteList()
        }
    }

    @Published
    var tradeRouteViewModels: [TradeRouteViewModel] = []

    weak var delegate: GameViewModelDelegate?

    init() {

    }

    func update() {

        self.updateTradeRouteList()
    }

    func select(viewType: TradeRoutesViewType) {

        self.viewType = viewType

        self.updateTradeRouteList()
    }

    var startCities: [PickerData] {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        var array: [PickerData] = []

        for cityRef in gameModel.cities(of: humanPlayer) {

            guard let city = cityRef else {
                continue
            }

            array.append(PickerData(name: city.name, image: self.leaderImage(for: humanPlayer.leader)))
        }

        return array
    }

    private func updateTradeRouteList() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        switch self.viewType {

        case .myRoutes:
            var tmpTradeRouteViewModels: [TradeRouteViewModel] = []
            let allHumanPlayerUnits = gameModel.units(of: humanPlayer)

            for humanTraderUnit in allHumanPlayerUnits where humanTraderUnit?.type == .trader {

                guard let unit = humanTraderUnit else {
                    continue
                }

                guard let tradeRouteData = unit.tradeRouteData() else {
                    continue // unit has no trade route data
                }

                guard let startCity = tradeRouteData.startCity(in: gameModel) else {
                    fatalError("cant get start city")
                }

                guard let endCity = tradeRouteData.endCity(in: gameModel) else {
                    fatalError("cant get end city")
                }

                let title = "\(startCity.name) to \(endCity.name)"
                let yields = tradeRouteData.yields(in: gameModel)
                let remainingTurns = tradeRouteData.expiresInTurns(for: unit, in: gameModel)

                let tradeRouteViewModel = TradeRouteViewModel(title: title, yields: yields, remainingTurns: remainingTurns)
                tmpTradeRouteViewModels.append(tradeRouteViewModel)
            }

            self.tradeRouteViewModels = tmpTradeRouteViewModels

        case .foreign:
            var tmpTradeRouteViewModels: [TradeRouteViewModel] = []
            let allTraderUnits = gameModel.units(with: .trader)

            // check all foreign traders
            for traderUnit in allTraderUnits where traderUnit?.player?.leader != humanPlayer.leader {

                guard let unit = traderUnit else {
                    continue
                }

                guard let tradeRouteDate = unit.tradeRouteData() else {
                    continue
                }

                guard let endCity = tradeRouteDate.endCity(in: gameModel) else {
                    fatalError("cant get end City")
                }

                // skip city cities of other players / ensure the end city of human player
                guard endCity.leader == humanPlayer.leader else {
                    continue
                }

                guard let tradeRouteData = unit.tradeRouteData() else {
                    fatalError("unit has no trade route data")
                }

                guard let startCity = tradeRouteData.startCity(in: gameModel) else {
                    fatalError("cant get start city")
                }

                guard let endCity = tradeRouteData.endCity(in: gameModel) else {
                    fatalError("cant get end city")
                }

                let title = "\(startCity.name) to \(endCity.name)"
                let yields = tradeRouteData.yields(in: gameModel)
                let remainingTurns = tradeRouteData.expiresInTurns(for: unit, in: gameModel)

                let tradeRouteViewModel = TradeRouteViewModel(title: title, yields: yields, remainingTurns: remainingTurns)
                tmpTradeRouteViewModels.append(tradeRouteViewModel)
            }

            self.tradeRouteViewModels = tmpTradeRouteViewModels

        case .available:

            var tmpTradeRouteViewModels: [TradeRouteViewModel] = []

            let sourceCityRef = gameModel.cities(of: humanPlayer)[self.selectedStartCityIndex]

            guard let sourceCity = sourceCityRef else {
                fatalError("cant get selected source city")
            }

            let pathFinderDataSource = gameModel.unitAwarePathfinderDataSource(
                for: .walk,
                for: sourceCity.player,
                ignoreOwner: true,
                unitMapType: .civilian,
                canEmbark: false,
                canEnterOcean: false
            )
            let pathFinder = AStarPathfinder(with: pathFinderDataSource)

            let tmpTraderUnit = Unit(at: sourceCity.location, type: .trader, owner: humanPlayer)
            for targetCityRef in tmpTraderUnit.possibleTradeRouteTargets(in: gameModel) {

                guard let targetCity = targetCityRef else {
                    continue
                }

                if var path = pathFinder.shortestPath(fromTileCoord: sourceCity.location, toTileCoord: targetCity.location) {

                    path.prepend(point: sourceCity.location, cost: 0.0)

                    if path.last?.0 != targetCity.location {
                        path.append(point: targetCity.location, cost: 0.0)
                    }

                    let title = targetCity.name
                    let tradeRoute = TradeRoute(path: path)
                    let yields = tradeRoute.yields(in: gameModel)

                    let tradeRouteViewModel = TradeRouteViewModel(title: title, yields: yields, remainingTurns: Int.max)
                    tmpTradeRouteViewModels.append(tradeRouteViewModel)
                }
            }

            self.tradeRouteViewModels = tmpTradeRouteViewModels
        }
    }

    private func leaderImage(for leaderType: LeaderType, targetSize: NSSize = NSSize(width: 16, height: 16)) -> NSImage {

        let bundle = Bundle.init(for: Textures.self)

        return (bundle.image(forResource: leaderType.iconTexture())?.resize(withSize: targetSize)) ?? NSImage(named: "sun.max.fill")!
    }

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
