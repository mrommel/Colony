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

    @Published
    var showLocationPicker: Bool

    @Published
    var hexagonGridViewModel: HexagonGridViewModel

    weak var delegate: GameViewModelDelegate?

    init(city: AbstractCity? = nil) {

        self.queueManager = CityBuildQueueManager(city: city)

        self.showLocationPicker = false
        self.hexagonGridViewModel = HexagonGridViewModel(mode: .empty)
        self.hexagonGridViewModel.delegate = self

        self.queueManager.delegate = self
    }

    func update(for city: AbstractCity?, with gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            return
        }

        self.city = city

        self.queueManager = CityBuildQueueManager(city: city)
        self.queueManager.delegate = self

        // populate values
        if let city = city {

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
                let productionPerTurn = city.productionPerTurn(in: gameModel)
                let turns = productionPerTurn > 0 ? Int(ceil(Double(productionCost) / productionPerTurn)) : 1000
                let unitViewModel = UnitViewModel(unitType: unitType, turns: turns)
                unitViewModel.delegate = self
                return unitViewModel
            }

            // districts / buildings
            let possibleDistrictTypes: [DistrictType] = DistrictType.all.filter { districtType in
                return city.canBuild(district: districtType, in: gameModel) || districts.has(district: districtType)
            }
            self.districtSectionViewModels = possibleDistrictTypes.map { districtType in

                if districts.has(district: districtType) {

                    let districtModel = DistrictViewModel(districtType: districtType, at: HexPoint.invalid, active: true)
                    districtModel.delegate = self

                    // filter buildingTypes
                    let possibleBuildingTypes = BuildingType.all.filter { buildingType in

                        return city.canBuild(building: buildingType, in: gameModel) &&
                            !buildings.has(building: buildingType) &&
                            buildingType.district() == districtType
                    }

                    let buildingViewModels: [BuildingViewModel] = possibleBuildingTypes.map { buildingType in

                        let productionCost = buildingType.productionCost()
                        let productionPerTurn = city.productionPerTurn(in: gameModel)
                        let turns = productionPerTurn > 0 ? Int(ceil(Double(productionCost) / productionPerTurn)) : 1000
                        if city.buildQueue.isBuilding(building: buildingType) {
                            // buildingNode.disable()
                        }
                        let buildingViewModel = BuildingViewModel(buildingType: buildingType, turns: turns)
                        buildingViewModel.delegate = self
                        return buildingViewModel
                    }

                    return DistrictSectionViewModel(districtViewModel: districtModel, buildingViewModels: buildingViewModels)
                } else {

                    let productionCost = districtType.productionCost()
                    let productionPerTurn = city.productionPerTurn(in: gameModel)
                    let turns = productionPerTurn > 0 ? Int(ceil(Double(productionCost) / productionPerTurn)) : 1000
                    let districtModel = DistrictViewModel(districtType: districtType, at: HexPoint.invalid, turns: turns, active: false)
                    districtModel.delegate = self
                    return DistrictSectionViewModel(districtViewModel: districtModel, buildingViewModels: [])
                }
            }

            // wonders
            let possibleWonderTypes: [WonderType] = WonderType.all.filter { wonderType in
                return city.canBuild(wonder: wonderType, in: gameModel)
            }
            self.wonderViewModels = possibleWonderTypes.map { wonderType in

                let productionCost = wonderType.productionCost()
                let productionPerTurn = city.productionPerTurn(in: gameModel)
                let turns = productionPerTurn > 0 ? Int(ceil(Double(productionCost) / productionPerTurn)) : 1000
                let wonderViewModel = WonderViewModel(wonderType: wonderType, at: HexPoint.invalid, turns: turns)
                wonderViewModel.delegate = self
                return wonderViewModel
            }

            // picker view
            self.hexagonGridViewModel.update(for: city, with: gameModel)
            self.hexagonGridViewModel.updateWorkingTiles(in: gameModel)
            self.showLocationPicker = false
        }
    }

    func onDroppedQueueItem(at index: Int, _ items: [NSItemProvider]) {

        if let firstProviderItem: NSItemProvider = items.first {

            firstProviderItem.loadObject(ofClass: UnitViewModel.self) { viewModelRepresentation, _ in

                if let unitViewModel = viewModelRepresentation as? UnitViewModel {

                    // remove at old location
                    if let oldIndex = self.queueViewModels.firstIndex(where: { $0.uuid == unitViewModel.uuid }) {
                        self.city?.buildQueue.remove(at: oldIndex)

                        let newIndex = index < oldIndex ? index : index - 1

                        // add item at new Index
                        self.city?.buildQueue.insert(item: BuildableItem(unitType: unitViewModel.unitType), at: newIndex)
                    }

                    // rebuild visible queue
                    DispatchQueue.main.async {
                        self.updateBuildQueue()
                    }
                }
            }

            firstProviderItem.loadObject(ofClass: BuildingViewModel.self) { viewModelRepresentation, _ in

                if let buildingViewModel = viewModelRepresentation as? BuildingViewModel {

                    // remove at old location
                    if let oldIndex = self.queueViewModels.firstIndex(where: { $0.uuid == buildingViewModel.uuid }) {
                        self.city?.buildQueue.remove(at: oldIndex)

                        let newIndex = index < oldIndex ? index : index - 1

                        // add item at new Index
                        self.city?.buildQueue.insert(item: BuildableItem(buildingType: buildingViewModel.buildingType), at: newIndex)
                    }

                    // rebuild visible queue
                    DispatchQueue.main.async {
                        self.updateBuildQueue()
                    }
                }
            }

            firstProviderItem.loadObject(ofClass: DistrictViewModel.self) { viewModelRepresentation, _ in

                if let districtViewModel = viewModelRepresentation as? DistrictViewModel {

                    // remove at old location
                    if let oldIndex = self.queueViewModels.firstIndex(where: { $0.uuid == districtViewModel.uuid }) {
                        self.city?.buildQueue.remove(at: oldIndex)

                        let newIndex = index < oldIndex ? index : index - 1

                        // add item at new Index
                        let buildableItem = BuildableItem(districtType: districtViewModel.districtType, at: districtViewModel.location)
                        self.city?.buildQueue.insert(item: buildableItem, at: newIndex)
                    }

                    // rebuild visible queue
                    DispatchQueue.main.async {
                        self.updateBuildQueue()
                    }
                }
            }

            firstProviderItem.loadObject(ofClass: WonderViewModel.self) { viewModelRepresentation, _ in

                if let wonderViewModel = viewModelRepresentation as? WonderViewModel {

                    // remove at old location
                    if let oldIndex = self.queueViewModels.firstIndex(where: { $0.uuid == wonderViewModel.uuid }) {
                        self.city?.buildQueue.remove(at: oldIndex)

                        let newIndex = index < oldIndex ? index : index - 1

                        // add item at new Index
                        let buildableItem = BuildableItem(wonderType: wonderViewModel.wonderType, at: wonderViewModel.location)
                        self.city?.buildQueue.insert(item: buildableItem, at: newIndex)
                    }
                }

                // rebuild visible queue
                DispatchQueue.main.async {
                    self.updateBuildQueue()
                }
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
        let productionPerTurn = city.productionPerTurn(in: gameModel)

        for (index, currentBuilding) in city.buildQueue.enumerated() {

            switch currentBuilding.type {

            case .unit:
                guard let unitType = currentBuilding.unitType else {
                    fatalError("no unit type given")
                }

                let productionCost = unitType.productionCost()

                let turns = productionPerTurn > 0.0 ? Int(ceil(Double(productionCost) / productionPerTurn)) : 100
                let unitViewModel = UnitViewModel(unitType: unitType, turns: turns, at: index)
                unitViewModel.delegate = self.queueManager
                tmpBuildQueueModels.append(unitViewModel)

            case .district:
                guard let districtType = currentBuilding.districtType else {
                    fatalError("no district type given")
                }

                let productionCost = districtType.productionCost()

                let turns = productionPerTurn > 0.0 ? Int(ceil(Double(productionCost) / productionPerTurn)) : 100
                let districtViewModel = DistrictViewModel(
                    districtType: districtType, at: currentBuilding.location!, turns: turns, active: false, at: index
                )
                districtViewModel.delegate = self.queueManager
                tmpBuildQueueModels.append(districtViewModel)

            case .building:
                guard let buildingType = currentBuilding.buildingType else {
                    fatalError("no building type given")
                }

                let productionCost = buildingType.productionCost()

                let turns = productionPerTurn > 0.0 ? Int(ceil(Double(productionCost) / productionPerTurn)) : 100
                let buildingViewModel = BuildingViewModel(buildingType: buildingType, turns: turns, at: index)
                buildingViewModel.delegate = self.queueManager
                tmpBuildQueueModels.append(buildingViewModel)

            case .wonder:
                guard let wonderType = currentBuilding.wonderType else {
                    fatalError("no wonder type given")
                }

                let productionCost = wonderType.productionCost()

                let turns = productionPerTurn > 0.0 ? Int(ceil(Double(productionCost) / productionPerTurn)) : 100
                let wonderViewModel = WonderViewModel(wonderType: wonderType, at: currentBuilding.location!, turns: turns, at: index)
                wonderViewModel.delegate = self.queueManager
                tmpBuildQueueModels.append(wonderViewModel)

            case .project:
                print("-- project --")
            }
        }

        self.queueViewModels = tmpBuildQueueModels
    }

    func cancelLocationPicker() {

        self.showLocationPicker = false
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

    func clicked(on districtType: DistrictType, at index: Int, in gameModel: GameModel?) {

        print("clicked on \(districtType)")

        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let humanPlayer = gameModel?.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard humanPlayer.leader == city.player?.leader else {
            fatalError("human player not city owner")
        }

        self.hexagonGridViewModel.mode = .districtLocation(type: districtType)
        self.hexagonGridViewModel.update(for: city, with: gameModel)
        self.hexagonGridViewModel.updateWorkingTiles(in: gameModel)
        self.showLocationPicker = true

        // now we wait for the result of the location picker in
        // func selected(district districtType: DistrictType, on districtLocation: HexPoint)
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

    func clicked(on wonderType: WonderType, at index: Int, in gameModel: GameModel?) {

        print("clicked on \(wonderType)")

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard humanPlayer.leader == city.player?.leader else {
            fatalError("human player not city owner")
        }

        self.hexagonGridViewModel.mode = .wonderLocation(type: wonderType)
        self.hexagonGridViewModel.update(for: city, with: gameModel)
        self.hexagonGridViewModel.updateWorkingTiles(in: gameModel)
        self.showLocationPicker = true

        // now we wait for the result of the location picker in
        // func selected(wonder wonderType: WonderType, on wonderLocation: HexPoint)
    }
}

extension CityProductionViewModel: CityBuildQueueManagerDelegate {

    func queueUpdated() {

        self.updateBuildQueue()
    }
}

extension CityProductionViewModel: HexagonGridViewModelDelegate {

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

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        guard let city = self.city else {
            fatalError("cant get city")
        }

        if city.canBuild(wonder: wonderType, at: wonderLocation, in: gameModel) {

            city.startBuilding(wonder: wonderType, at: wonderLocation, in: gameModel)

            self.updateBuildQueue()

            self.showLocationPicker = false
        } else {
            print("--- this should not happen - selected a wonder type \(wonderType) that cannot be constructed in \(city.name) ---")
        }
    }

    func selected(district districtType: DistrictType, on districtLocation: HexPoint) {

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        guard let city = self.city else {
            fatalError("cant get city")
        }

        if city.canBuild(district: districtType, at: districtLocation, in: gameModel) {

            city.startBuilding(district: districtType, at: districtLocation, in: gameModel)

            self.updateBuildQueue()

            self.showLocationPicker = false
        } else {
            print("--- this should not happen - selected a district type \(districtType) that cannot be constructed in \(city.name) ---")
        }
    }
}
