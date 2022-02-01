//
//  CityBuildingsViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.05.21.
//

import SwiftUI
import SmartAILibrary

class CityBuildingsViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var districtsConstructed: String

    @Published
    var districtSectionViewModels: [DistrictSectionViewModel] = []

    @Published
    var wonderViewModels: [WonderViewModel] = []

    @Published
    var tradePostViewModels: [TradePostViewModel] = []

    private var city: AbstractCity?

    init(city: AbstractCity? = nil) {

        self.districtsConstructed = "0 Districts constructed"

        if city != nil {
            self.update(for: city)
        }
    }

    func update(for city: AbstractCity?) {

        self.city = city

        // populate values
        if let city = city {

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

            guard let cityTradingPosts = city.cityTradingPosts else {
                fatalError("cant get cityTradingPosts")
            }

            // districts / buildings
            let constructedDistrictTypes = DistrictType.all.filter { districtType in
                return districts.has(district: districtType)
            }

            self.districtsConstructed = "\(constructedDistrictTypes.count) Districts constructed"

            self.districtSectionViewModels = constructedDistrictTypes.map { districtType in

                let districtModel = DistrictViewModel(districtType: districtType, active: true)
                districtModel.delegate = self

                // filter buildingTypes
                let constructedBuildingTypes = BuildingType.all.filter { buildingType in

                    return buildings.has(building: buildingType) && buildingType.district() == districtType
                }

                let buildingViewModels: [BuildingViewModel] = constructedBuildingTypes.map { buildingType in

                    if city.buildQueue.isBuilding(building: buildingType) {
                        // buildingNode.disable()
                    }
                    let buildingViewModel = BuildingViewModel(buildingType: buildingType, turns: -1, showYields: true)
                    buildingViewModel.delegate = self
                    return buildingViewModel
                }

                return DistrictSectionViewModel(districtViewModel: districtModel, buildingViewModels: buildingViewModels)
            }

            // wonders
            let constructedWonderTypes = WonderType.all.filter { wonderType in
                return city.has(wonder: wonderType)
            }
            self.wonderViewModels = constructedWonderTypes.map { wonderType in

                let wonderViewModel = WonderViewModel(wonderType: wonderType, turns: -1, showYields: true)
                wonderViewModel.delegate = self
                return wonderViewModel
            }

            // trade routes
            let tradePostLeaders = LeaderType.all.filter { leaderType in
                return cityTradingPosts.hasTradingPost(for: leaderType)
            }
            self.tradePostViewModels = tradePostLeaders.map { tradePostLeader in

                return TradePostViewModel(leaderType: tradePostLeader)
            }
        }
    }
}

extension CityBuildingsViewModel: DistrictViewModelDelegate {

    func clicked(on districtType: DistrictType, at index: Int, in gameModel: GameModel?) {

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

        print("ask: really sell?")

        /*if city.canConstruct(district: districtType, in: game) {
            city.startBuilding(district: districtType)
            
            self.updateBuildQueue()
        } else {
            print("--- this should not happen - selected a district type \(districtType) that cannot be constructed in \(city.name) ---")
        }*/
    }
}

extension CityBuildingsViewModel: BuildingViewModelDelegate {

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

        print("ask: really sell?")

        /*if city.canBuild(building: buildingType, in: game) {
            city.startBuilding(building: buildingType)
            
            self.updateBuildQueue()
        } else {
            print("--- this should not happen - selected a building type \(buildingType) that cannot be constructed in \(city.name) ---")
        }*/
    }
}

extension CityBuildingsViewModel: WonderViewModelDelegate {

    func clicked(on wonderType: WonderType, at index: Int, in gameModel: GameModel?) {

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

        print("ask: really sell?")

        /*if city.canBuild(wonder: wonderType, in: game) {
            city.startBuilding(wonder: wonderType)
            
            self.updateBuildQueue()
        } else {
            print("--- this should not happen - selected a wonder type \(wonderType) that cannot be constructed in \(city.name) ---")
        }*/
    }
}
