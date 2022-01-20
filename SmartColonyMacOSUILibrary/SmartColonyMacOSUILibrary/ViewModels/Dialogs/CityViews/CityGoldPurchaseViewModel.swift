//
//  CityGoldPurchaseViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.01.22.
//

import SwiftUI
import SmartAILibrary

class CityGoldPurchaseViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var unitViewModels: [UnitViewModel] = []

    @Published
    var districtSectionViewModels: [DistrictSectionViewModel] = []

    private var city: AbstractCity?

    @Published
    var showLocationPicker: Bool

    @Published
    var hexagonGridViewModel: HexagonGridViewModel

    weak var delegate: GameViewModelDelegate?

    init(city: AbstractCity? = nil) {

        self.showLocationPicker = false
        self.hexagonGridViewModel = HexagonGridViewModel(mode: .empty)
        self.hexagonGridViewModel.delegate = self
    }

    func update(for city: AbstractCity?) {

        self.city = city

        // populate values
        if let city = city {

            guard let gameModel = self.gameEnvironment.game.value else {
                return
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human player")
            }

            guard humanPlayer.leader == city.player?.leader else {
                fatalError("human player not city owner")
            }

            // units
            let possibleUnitTypes = UnitType.all.filter { unitType in
                return city.canTrain(unit: unitType, in: gameModel)
            }
            self.unitViewModels = possibleUnitTypes.map { unitType in

                let goldCost = city.goldPurchaseCost(of: unitType)
                let enabled = goldCost < (humanPlayer.treasury?.value() ?? 0.0)
                let unitViewModel = UnitViewModel(unitType: unitType, gold: Int(goldCost), enabled: enabled)
                unitViewModel.delegate = self
                return unitViewModel
            }
        }
    }
}

extension CityGoldPurchaseViewModel: UnitViewModelDelegate {

    func clicked(on unitType: UnitType, at index: Int) {

        print("try to purchase: \(unitType)")
        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        let success = self.city?.purchase(unit: unitType, with: .gold, in: gameModel) ?? false
        print("purchase \(unitType): \(success)")
    }

    func clicked(on unit: AbstractUnit?, at index: Int) {

        // NOOP
    }
}

extension CityGoldPurchaseViewModel: HexagonGridViewModelDelegate {

    func purchaseTile(at point: HexPoint) {

        print("purchase")
    }

    func forceWorking(on point: HexPoint) {

        print("forceWorking")
    }

    func stopWorking(on point: HexPoint) {

        print("stopWorking")
    }

    func selected(wonder wonderType: WonderType, on wonderLocation: HexPoint) {

        self.showLocationPicker = false
    }

    func selected(district districtType: DistrictType, on districtLocation: HexPoint) {

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        guard let city = self.city else {
            fatalError("cant get city")
        }

        if city.canBuild(district: districtType, at: districtLocation, in: gameModel) {

            print("purchase with gold")

            self.showLocationPicker = false
        } else {
            print("--- this should not happen - selected a district type \(districtType) that cannot be constructed in \(city.name) ---")
        }
    }
}
