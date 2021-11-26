//
//  CityBuildQueueManager.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 20.05.21.
//

import SmartAILibrary

protocol CityBuildQueueManagerDelegate: AnyObject {

    func queueUpdated()
}

class CityBuildQueueManager {

    let city: AbstractCity?

    weak var delegate: CityBuildQueueManagerDelegate?

    init(city: AbstractCity?) {

        self.city = city
    }
}

extension CityBuildQueueManager: UnitViewModelDelegate {

    func clicked(on unit: AbstractUnit?, at index: Int) {

        fatalError("should not happen")
    }

    func clicked(on unitType: UnitType, at index: Int) {

        print("remove unitType: \(unitType) at \(index)")
        self.city?.buildQueue.remove(at: index)
        self.delegate?.queueUpdated()
    }
}

extension CityBuildQueueManager: DistrictViewModelDelegate {

    func clicked(on districtType: DistrictType, at index: Int, in gameModel: GameModel?) {

        print("remove districtType: \(districtType) at \(index)")
        guard let buildableItem = self.city?.buildQueue.district(of: districtType) else {
            fatalError("cant get buildableItem")
        }

        guard let districtLocation = buildableItem.location,
              let tile = gameModel?.tile(at: districtLocation) else {
            fatalError("cant get tile")
        }

        tile.cancelBuildingDistrict()
        gameModel?.userInterface?.refresh(tile: tile)

        self.city?.buildQueue.remove(at: index)
        self.delegate?.queueUpdated()
    }
}

extension CityBuildQueueManager: BuildingViewModelDelegate {

    func clicked(on buildingType: BuildingType, at index: Int) {

        print("remove buildingType: \(buildingType) at \(index)")
        self.city?.buildQueue.remove(at: index)
        self.delegate?.queueUpdated()
    }
}

extension CityBuildQueueManager: WonderViewModelDelegate {

    func clicked(on wonderType: WonderType, at index: Int, in gameModel: GameModel?) {

        print("remove wonderType: \(wonderType) at \(index)")
        guard let buildableItem = self.city?.buildQueue.wonder(of: wonderType) else {
            fatalError("cant get buildableItem")
        }

        guard let wonderLocation = buildableItem.location,
              let tile = gameModel?.tile(at: wonderLocation) else {
            fatalError("cant get tile")
        }

        tile.cancelBuildingWonder()
        gameModel?.userInterface?.refresh(tile: tile)

        self.city?.buildQueue.remove(at: index)
        self.delegate?.queueUpdated()
    }
}
