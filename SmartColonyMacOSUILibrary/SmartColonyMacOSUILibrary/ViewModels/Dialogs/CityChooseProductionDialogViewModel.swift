//
//  CityChooseProductionDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary

class CityChooseProductionDialogViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var cityName: String = "-"
    
    @Published
    var queueViewModels: [QueueViewModel] = []
    
    @Published
    var unitViewModels: [UnitViewModel] = []
    
    @Published
    var districtSectionViewModels: [DistrictSectionViewModel] = []
    
    @Published
    var wonderViewModels: [WonderViewModel] = []
    
    private var city: AbstractCity? = nil
    private let queueManager: QueueManager
    
    weak var delegate: GameViewModelDelegate?
    
    init(city: AbstractCity? = nil) {

        self.queueManager = QueueManager()
        
        if city != nil {
            self.update(for: city)
        }
    }
    
    func update(for city: AbstractCity?) {
        
        self.city = city
        
        // populate values
        if let city = city {
            
            self.cityName = city.name
            
            guard let game = self.gameEnvironment.game.value else {
                return
            }
            
            guard let humanPlayer = game.humanPlayer() else {
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
                return city.canTrain(unit: unitType, in: game)
            }
            self.unitViewModels = possibleUnitTypes.map { unitType in
                
                let turns = 53 // fixme
                let unitViewModel = UnitViewModel(unitType: unitType, turns: turns)
                unitViewModel.delegate = self
                return unitViewModel
            }
            
            // districts / buildings
            self.districtSectionViewModels = DistrictType.all.map { districtType in
                
                if districts.has(district: districtType) {
                    
                    let districtModel = DistrictViewModel(districtType: districtType, active: true)
                    districtModel.delegate = self
                    
                    // filter buildingTypes
                    let possibleBuildingTypes = BuildingType.all.filter {
                        buildingType in
                        
                        return city.canBuild(building: buildingType, in: game) && !buildings.has(building: buildingType) && buildingType.district() == districtType
                    }
                    
                    let buildingViewModels: [BuildingViewModel] = possibleBuildingTypes.map { buildingType in
                        
                        let turns = 53 // fixme
                        if city.buildQueue.isBuilding(buildingType: buildingType) {
                            // buildingNode.disable()
                        }
                        let buildingViewModel = BuildingViewModel(buildingType: buildingType, turns: turns)
                        buildingViewModel.delegate = self
                        return buildingViewModel
                    }
                    
                    return DistrictSectionViewModel(districtViewModel: districtModel, buildingViewModels: buildingViewModels)
                } else {
                    let turns = 53 // fixme
                    let districtModel = DistrictViewModel(districtType: districtType, turns: turns, active: false)
                    districtModel.delegate = self
                    return DistrictSectionViewModel(districtViewModel: districtModel, buildingViewModels: [])
                }
            }
            
            // wonders
            let possibleWonderTypes = WonderType.all.filter { wonderType in
                return city.canBuild(wonder: wonderType, in: game)
            }
            self.wonderViewModels = possibleWonderTypes.map { wonderType in
                
                let turns = 53 // fixme
                let wonderViewModel = WonderViewModel(wonderType: wonderType, turns: turns)
                wonderViewModel.delegate = self
                return wonderViewModel
            }
        }
    }
    
    private func updateBuildQueue() {
        
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
                
                let turns = 43 // TODO
                let unitViewModel = UnitViewModel(unitType: unitType, turns: turns, at: index)
                unitViewModel.delegate = self.queueManager
                tmpBuildQueueModels.append(unitViewModel)
            case .district:
                print("-- district --")
                guard let districtType = currentBuilding.districtType else {
                    fatalError("no district type given")
                }
                
                let turns = 43 // TODO
                let districtViewModel = DistrictViewModel(districtType: districtType, turns: turns, active: false, at: index)
                districtViewModel.delegate = self.queueManager
                tmpBuildQueueModels.append(districtViewModel)
            case .building:
                print("-- building --")
                guard let buildingType = currentBuilding.buildingType else {
                    fatalError("no building type given")
                }
                
                let turns = 43 // TODO
                let buildingViewModel = BuildingViewModel(buildingType: buildingType, turns: turns, at: index)
                buildingViewModel.delegate = self.queueManager
                tmpBuildQueueModels.append(buildingViewModel)
            case .wonder:
                print("-- wonder --")
                guard let wonderType = currentBuilding.wonderType else {
                    fatalError("no wonder type given")
                }
                
                let turns = 43 // TODO
                let wonderViewModel = WonderViewModel(wonderType: wonderType, turns: turns, at: index)
                wonderViewModel.delegate = self.queueManager
                tmpBuildQueueModels.append(wonderViewModel)
            case .project:
                print("-- project --")
            }
        }
        
        self.queueViewModels = tmpBuildQueueModels
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
}

extension CityChooseProductionDialogViewModel: UnitViewModelDelegate {
    
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

extension CityChooseProductionDialogViewModel: DistrictViewModelDelegate {
    
    func clicked(on districtType: DistrictType, at index: Int) {
        print("clicked on \(districtType)")
    }
}

extension CityChooseProductionDialogViewModel: BuildingViewModelDelegate {
    
    func clicked(on buildingType: BuildingType, at index: Int) {
        print("clicked on \(buildingType)")
    }
}

extension CityChooseProductionDialogViewModel: WonderViewModelDelegate {
    
    func clicked(on wonderType: WonderType, at index: Int) {
        print("clicked on \(wonderType)")
    }
}
