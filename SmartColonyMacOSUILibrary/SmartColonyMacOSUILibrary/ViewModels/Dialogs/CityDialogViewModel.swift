//
//  CityDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class CityDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var cityName: String = "-"

    @Published
    var population: Int = 1

    @Published
    var scienceYieldViewModel: YieldValueViewModel

    @Published
    var cultureYieldViewModel: YieldValueViewModel

    @Published
    var foodYieldViewModel: YieldValueViewModel

    @Published
    var productionYieldViewModel: YieldValueViewModel

    @Published
    var goldYieldViewModel: YieldValueViewModel

    @Published
    var faithYieldViewModel: YieldValueViewModel

    @Published
    var cityDetailViewType: CityDetailViewType = CityDetailViewType.production

    @Published
    var productionViewModel: CityProductionViewModel

    @Published
    var goldPurchaseViewModel: CityGoldPurchaseViewModel

    @Published
    var buildingsViewModel: CityBuildingsViewModel

    @Published
    var citizenViewModel: CityCitizenViewModel

    @Published
    var growthViewModel: CityGrowthViewModel

    @Published
    var religionViewModel: CityReligionViewModel

    @Published
    var loyaltyViewModel: CityLoyaltyViewModel

    private var city: AbstractCity?

    weak var delegate: GameViewModelDelegate? {
        didSet {
            self.goldPurchaseViewModel.delegate = self.delegate
        }
    }

    init(city: AbstractCity? = nil) {

        self.scienceYieldViewModel = YieldValueViewModel(yieldType: .science, initial: 0.0, type: .onlyDelta)
        self.cultureYieldViewModel = YieldValueViewModel(yieldType: .culture, initial: 0.0, type: .onlyDelta)
        self.foodYieldViewModel = YieldValueViewModel(yieldType: .food, initial: 0.0, type: .onlyDelta)
        self.productionYieldViewModel = YieldValueViewModel(yieldType: .production, initial: 0.0, type: .onlyDelta)
        self.goldYieldViewModel = YieldValueViewModel(yieldType: .gold, initial: 0.0, type: .onlyDelta)
        self.faithYieldViewModel = YieldValueViewModel(yieldType: .faith, initial: 0.0, type: .onlyDelta)

        self.productionViewModel = CityProductionViewModel(city: city)
        self.goldPurchaseViewModel = CityGoldPurchaseViewModel(city: city)
        self.buildingsViewModel = CityBuildingsViewModel(city: city)
        self.growthViewModel = CityGrowthViewModel(city: city)
        self.citizenViewModel = CityCitizenViewModel(city: city)
        self.religionViewModel = CityReligionViewModel(city: city)
        self.loyaltyViewModel = CityLoyaltyViewModel(city: city)

        self.citizenViewModel.delegate = self

        if city != nil {
            self.update(for: city)
        }
    }

    func update(for cityRef: AbstractCity?) {

        self.city = cityRef

        // populate values
        if let city = cityRef as? City {

            self.cityName = city.name
            self.population = city.population()

            guard let game = self.gameEnvironment.game.value else {
                return
            }

            self.scienceYieldViewModel.delta = city.sciencePerTurn(in: game)
            self.scienceYieldViewModel.tooltip = city.sciencePerTurnToolTip(in: game)
            self.cultureYieldViewModel.delta = city.culturePerTurn(in: game)
            self.cultureYieldViewModel.tooltip = city.culturePerTurnToolTip(in: game)
            self.foodYieldViewModel.delta = city.foodPerTurn(in: game)
            self.foodYieldViewModel.tooltip = city.foodPerTurnToolTip(in: game)
            self.productionYieldViewModel.delta = city.productionPerTurn(in: game)
            self.productionYieldViewModel.tooltip = city.productionPerTurnToolTip(in: game)
            self.goldYieldViewModel.delta = city.goldPerTurn(in: game)
            self.goldYieldViewModel.tooltip = city.goldPerTurnToolTip(in: game)
            self.faithYieldViewModel.delta = city.faithPerTurn(in: game)
            self.faithYieldViewModel.tooltip = city.faithPerTurnToolTip(in: game)

            self.productionViewModel.update(for: city, with: game)
            self.goldPurchaseViewModel.update(for: city)
            self.buildingsViewModel.update(for: city)
            self.growthViewModel.update(for: city)
            self.citizenViewModel.update(for: city)
            self.religionViewModel.update(for: city)
            self.loyaltyViewModel.update(for: city)
        }
    }

    func show(detail: CityDetailViewType) {

        self.cityDetailViewType = detail
    }

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}

extension CityDialogViewModel: CityCitizenViewModelDelegate {

    func yieldsUpdated() {

        if let city = self.city {

            guard let game = self.gameEnvironment.game.value else {
                return
            }

            self.population = city.population()

            self.scienceYieldViewModel.delta = city.sciencePerTurn(in: game)
            self.cultureYieldViewModel.delta = city.culturePerTurn(in: game)
            self.foodYieldViewModel.delta = city.foodPerTurn(in: game)
            self.productionYieldViewModel.delta = city.productionPerTurn(in: game)
            self.goldYieldViewModel.delta = city.goldPerTurn(in: game)
            self.faithYieldViewModel.delta = city.faithPerTurn(in: game)
        }
    }
}
