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

    func clicked(on districtType: DistrictType, at index: Int) {

        print("remove districtType: \(districtType) at \(index)")
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

    func clicked(on wonderType: WonderType, at index: Int) {

        print("remove wonderType: \(wonderType) at \(index)")
        self.city?.buildQueue.remove(at: index)
        self.delegate?.queueUpdated()
    }
}
