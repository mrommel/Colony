//
//  SelectTradeCityDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.07.21.
//

import SwiftUI
import SmartAILibrary

class SelectTradeCityDialogViewModel: ObservableObject {

    typealias CityCompletionBlock = (AbstractCity?) -> Void

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    weak var delegate: GameViewModelDelegate?

    @Published
    var title: String

    @Published
    var question: String

    @Published
    var showTradeRoute: Bool = false

    @Published
    var foodYield: YieldValueViewModel

    @Published
    var productionYield: YieldValueViewModel

    @Published
    var goldYield: YieldValueViewModel

    @Published
    var scienceYield: YieldValueViewModel

    @Published
    var cultureYield: YieldValueViewModel

    @Published
    var faithYield: YieldValueViewModel

    @Published
    var targetCityViewModels: [TradeCityViewModel] = []

    var completion: CityCompletionBlock?
    var startCity: AbstractCity?
    var selectedCity: AbstractCity?

    init() {

        self.title = "From"
        self.question = "Select a Trade Route Destination."

        self.foodYield = YieldValueViewModel(yieldType: .food, initial: 0.0, type: .onlyValue, withBackground: false)
        self.productionYield = YieldValueViewModel(yieldType: .production, initial: 0.0, type: .onlyValue, withBackground: false)
        self.goldYield = YieldValueViewModel(yieldType: .gold, initial: 0.0, type: .onlyValue, withBackground: false)
        self.scienceYield = YieldValueViewModel(yieldType: .science, initial: 0.0, type: .onlyValue, withBackground: false)
        self.cultureYield = YieldValueViewModel(yieldType: .culture, initial: 0.0, type: .onlyValue, withBackground: false)
        self.faithYield = YieldValueViewModel(yieldType: .faith, initial: 0.0, type: .onlyValue, withBackground: false)
    }

#if DEBUG
    init(cities: [AbstractCity?]) {

        self.title = "From"
        self.question = "Select a Trade Route Destination."

        self.foodYield = YieldValueViewModel(yieldType: .food, initial: 0.0, type: .onlyValue, withBackground: false)
        self.productionYield = YieldValueViewModel(yieldType: .production, initial: 0.0, type: .onlyValue, withBackground: false)
        self.goldYield = YieldValueViewModel(yieldType: .gold, initial: 0.0, type: .onlyValue, withBackground: false)
        self.scienceYield = YieldValueViewModel(yieldType: .science, initial: 0.0, type: .onlyValue, withBackground: false)
        self.cultureYield = YieldValueViewModel(yieldType: .culture, initial: 0.0, type: .onlyValue, withBackground: false)
        self.faithYield = YieldValueViewModel(yieldType: .faith, initial: 0.0, type: .onlyValue, withBackground: false)

        self.buildCityModels(for: cities)
    }
#endif

    func update(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping CityCompletionBlock) {

        if let city = startCity {
            self.title = "\(city) to ..."
        }

        self.completion = completion
        self.startCity = startCity
        self.buildCityModels(for: cities)
    }

    private func buildCityModels(for cities: [AbstractCity?]) {

        var targetCityViewModels: [TradeCityViewModel] = []

        for cityRef in cities {

            guard let city = cityRef else {
                continue
            }

            let cityViewModel = TradeCityViewModel(city: city)
            cityViewModel.delegate = self
            targetCityViewModels.append(cityViewModel)
        }

        self.targetCityViewModels = targetCityViewModels
    }

    func closeDialog() {

        self.delegate?.closeDialog()
    }

    func confirmTradeRoute() {

        guard self.startCity != nil, self.selectedCity != nil else {
            print("cant select trade route")
            return
        }

        self.delegate?.closeDialog()
        self.completion?(self.selectedCity)
    }

    func cancelTradeRoute() {

        self.selectedCity = nil
        self.showTradeRoute = false
    }
}

extension SelectTradeCityDialogViewModel: TradeCityViewModelDelegate {

    func selected(city: AbstractCity?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        self.selectedCity = city
        self.showTradeRoute = true

        guard let startLocation = self.startCity?.location, let selectedLocation = self.selectedCity?.location else {
            fatalError("cant get city locations")
        }

        let tr = TradeRoute(start: startLocation, posts: [], end: selectedLocation)
        let yields = tr.yields(in: gameModel)

        // update yield values
        self.foodYield.value = yields.food
        self.productionYield.value = yields.production
        self.goldYield.value = yields.gold
        self.scienceYield.value = yields.science
        self.cultureYield.value = yields.culture
        self.faithYield.value = yields.faith
    }
}
