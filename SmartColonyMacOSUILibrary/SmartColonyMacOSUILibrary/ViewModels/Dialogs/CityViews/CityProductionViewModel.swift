//
//  CityProductionViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary

class CityProductionViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var queueViewModels: [QueueViewModel] = []

    @Published
    var unitViewModels: [UnitViewModel] = []

    @Published
    var districtSectionViewModels: [DistrictSectionViewModel] = []

    @Published
    var wonderViewModels: [WonderViewModel] = []

    private var city: AbstractCity?
    private var queueManager: CityBuildQueueManager

    weak var delegate: GameViewModelDelegate?

    init(city: AbstractCity? = nil) {

        self.queueManager = CityBuildQueueManager(city: city)
        self.queueManager.delegate = self

        if city != nil {
            self.update(for: city)
        }
    }

    func update(for city: AbstractCity?) {

        self.city = city

        self.queueManager = CityBuildQueueManager(city: city)
        self.queueManager.delegate = self

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

            guard let buildings = city.buildings else {
                fatalError("cant get buildings")
            }

            guard let districts = city.districts else {
                fatalError("cant get districts")
            }

            // build queue
            self.updateBuildQueue()

            // units
            let possibleUnitTypes = UnitType.all.filter { unitType in
                return city.canTrain(unit: unitType, in: gameModel)
            }
            self.unitViewModels = possibleUnitTypes.map { unitType in

                let productionCost = unitType.productionCost()
                let turns = Int(ceil(Double(productionCost) / city.productionPerTurn(in: gameModel)))
                let unitViewModel = UnitViewModel(unitType: unitType, turns: turns)
                unitViewModel.delegate = self
                return unitViewModel
            }

            // districts / buildings
            let possibleDistrictTypes = DistrictType.all.filter { districtType in
                return city.canConstruct(district: districtType, in: gameModel) || districts.has(district: districtType)
            }
            self.districtSectionViewModels = possibleDistrictTypes.map { districtType in

                if districts.has(district: districtType) {

                    let districtModel = DistrictViewModel(districtType: districtType, active: true)
                    districtModel.delegate = self

                    // filter buildingTypes
                    let possibleBuildingTypes = BuildingType.all.filter {
                        buildingType in

                        return city.canBuild(building: buildingType, in: gameModel) && !buildings.has(building: buildingType) && buildingType.district() == districtType
                    }

                    let buildingViewModels: [BuildingViewModel] = possibleBuildingTypes.map { buildingType in

                        let productionCost = buildingType.productionCost()
                        let turns = Int(ceil(Double(productionCost) / city.productionPerTurn(in: gameModel)))
                        if city.buildQueue.isBuilding(buildingType: buildingType) {
                            // buildingNode.disable()
                        }
                        let buildingViewModel = BuildingViewModel(buildingType: buildingType, turns: turns)
                        buildingViewModel.delegate = self
                        return buildingViewModel
                    }

                    return DistrictSectionViewModel(districtViewModel: districtModel, buildingViewModels: buildingViewModels)
                } else {

                    let productionCost = districtType.productionCost()
                    let turns = Int(ceil(Double(productionCost) / city.productionPerTurn(in: gameModel)))
                    let districtModel = DistrictViewModel(districtType: districtType, turns: turns, active: false)
                    districtModel.delegate = self
                    return DistrictSectionViewModel(districtViewModel: districtModel, buildingViewModels: [])
                }
            }

            // wonders
            let possibleWonderTypes = WonderType.all.filter { wonderType in
                return city.canBuild(wonder: wonderType, in: gameModel)
            }
            self.wonderViewModels = possibleWonderTypes.map { wonderType in

                let productionCost = wonderType.productionCost()
                let turns = Int(ceil(Double(productionCost) / city.productionPerTurn(in: gameModel)))
                let wonderViewModel = WonderViewModel(wonderType: wonderType, turns: turns)
                wonderViewModel.delegate = self
                return wonderViewModel
            }
        }
    }

    private func updateBuildQueue() {

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        guard let city = self.city else {
            fatalError("cant get city")
        }

        var tmpBuildQueueModels: [QueueViewModel] = []

        for (index, currentBuilding) in city.buildQueue.enumerated() {

            switch currentBuilding.type {

            case .unit:
                print("-- unit --")
                guard let unitType = currentBuilding.unitType else {
                    fatalError("no unit type given")
                }

                let productionCost = unitType.productionCost()
                let turns = Int(ceil(Double(productionCost) / city.productionPerTurn(in: gameModel)))
                let unitViewModel = UnitViewModel(unitType: unitType, turns: turns, at: index)
                unitViewModel.delegate = self.queueManager
                tmpBuildQueueModels.append(unitViewModel)
            case .district:
                print("-- district --")
                guard let districtType = currentBuilding.districtType else {
                    fatalError("no district type given")
                }

                let productionCost = districtType.productionCost()
                let turns = Int(ceil(Double(productionCost) / city.productionPerTurn(in: gameModel)))
                let districtViewModel = DistrictViewModel(districtType: districtType, turns: turns, active: false, at: index)
                districtViewModel.delegate = self.queueManager
                tmpBuildQueueModels.append(districtViewModel)
            case .building:
                print("-- building --")
                guard let buildingType = currentBuilding.buildingType else {
                    fatalError("no building type given")
                }

                let productionCost = buildingType.productionCost()
                let turns = Int(ceil(Double(productionCost) / city.productionPerTurn(in: gameModel)))
                let buildingViewModel = BuildingViewModel(buildingType: buildingType, turns: turns, at: index)
                buildingViewModel.delegate = self.queueManager
                tmpBuildQueueModels.append(buildingViewModel)
            case .wonder:
                print("-- wonder --")
                guard let wonderType = currentBuilding.wonderType else {
                    fatalError("no wonder type given")
                }

                let productionCost = wonderType.productionCost()
                let turns = Int(ceil(Double(productionCost) / city.productionPerTurn(in: gameModel)))
                let wonderViewModel = WonderViewModel(wonderType: wonderType, turns: turns, at: index)
                wonderViewModel.delegate = self.queueManager
                tmpBuildQueueModels.append(wonderViewModel)
            case .project:
                print("-- project --")
            }
        }

        self.queueViewModels = tmpBuildQueueModels
    }
}

extension CityProductionViewModel: UnitViewModelDelegate {

    func clicked(on unit: AbstractUnit?, at index: Int) {

        fatalError("should not happen")
    }

    func clicked(on unitType: UnitType, at index: Int) {

        print("clicked on \(unitType)")

        guard let game = self.gameEnvironment.game.value else {
            return
        }

        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let humanPlayer = game.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard humanPlayer.leader == city.player?.leader else {
            fatalError("human player not city owner")
        }

        if city.canTrain(unit: unitType, in: game) {
            city.startTraining(unit: unitType)

            self.updateBuildQueue()
        } else {
            print("--- this should not happen - selected a unit type \(unitType) that cannot be trained in \(city.name) ---")
        }
    }
}

extension CityProductionViewModel: DistrictViewModelDelegate {

    func clicked(on districtType: DistrictType, at index: Int) {

        print("clicked on \(districtType)")

        guard let game = self.gameEnvironment.game.value else {
            return
        }

        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let humanPlayer = game.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard humanPlayer.leader == city.player?.leader else {
            fatalError("human player not city owner")
        }

        if city.canConstruct(district: districtType, in: game) {
            city.startBuilding(district: districtType)

            self.updateBuildQueue()
        } else {
            print("--- this should not happen - selected a district type \(districtType) that cannot be constructed in \(city.name) ---")
        }
    }
}

extension CityProductionViewModel: BuildingViewModelDelegate {

    func clicked(on buildingType: BuildingType, at index: Int) {

        print("clicked on \(buildingType)")

        guard let game = self.gameEnvironment.game.value else {
            return
        }

        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let humanPlayer = game.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard humanPlayer.leader == city.player?.leader else {
            fatalError("human player not city owner")
        }

        if city.canBuild(building: buildingType, in: game) {
            city.startBuilding(building: buildingType)

            self.updateBuildQueue()
        } else {
            print("--- this should not happen - selected a building type \(buildingType) that cannot be constructed in \(city.name) ---")
        }
    }
}

extension CityProductionViewModel: WonderViewModelDelegate {

    func clicked(on wonderType: WonderType, at index: Int) {

        print("clicked on \(wonderType)")

        guard let game = self.gameEnvironment.game.value else {
            return
        }

        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let humanPlayer = game.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard humanPlayer.leader == city.player?.leader else {
            fatalError("human player not city owner")
        }

        if city.canBuild(wonder: wonderType, in: game) {
            city.startBuilding(wonder: wonderType)

            self.updateBuildQueue()
        } else {
            print("--- this should not happen - selected a wonder type \(wonderType) that cannot be constructed in \(city.name) ---")
        }
    }
}

extension CityProductionViewModel: CityBuildQueueManagerDelegate {

    func queueUpdated() {

        self.updateBuildQueue()
    }
}
