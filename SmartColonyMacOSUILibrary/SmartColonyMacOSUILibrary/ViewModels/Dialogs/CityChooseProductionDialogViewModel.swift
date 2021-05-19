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
    var unitViewModels: [UnitViewModel] = []
    
    @Published
    var districtSectionViewModels: [DistrictSectionViewModel] = []
    
    @Published
    var wonderViewModels: [WonderViewModel] = []
    
    private var city: AbstractCity? = nil
    
    weak var delegate: GameViewModelDelegate?
    
    init(city: AbstractCity? = nil) {

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
            
            // units
            let possibleUnitTypes = UnitType.all.filter { unitType in
                return city.canTrain(unit: unitType, in: game)
            }
            self.unitViewModels = possibleUnitTypes.map { unitType in
                
                let turns = 53 // fixme
                return UnitViewModel(unitType: unitType, turns: turns)
            }
            
            // districts / buildings
            self.districtSectionViewModels = DistrictType.all.map { districtType in
                
                if districts.has(district: districtType) {
                    
                    let districtModel = DistrictViewModel(districtType: districtType, active: true)
                    
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
                        return BuildingViewModel(buildingType: buildingType, turns: turns)
                    }
                    
                    return DistrictSectionViewModel(districtViewModel: districtModel, buildingViewModels: buildingViewModels)
                } else {
                    let turns = 53 // fixme
                    let districtModel = DistrictViewModel(districtType: districtType, turns: turns, active: false)
                    return DistrictSectionViewModel(districtViewModel: districtModel, buildingViewModels: [])
                }
            }
            
            // wonders
            
            
        }
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
}
