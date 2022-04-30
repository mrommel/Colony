//
//  MapMarkerPickerViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 29.04.22.
//

import Foundation
import SmartAILibrary

protocol MapMarkerPickerViewModelDelegate: AnyObject {

    func close()
    func addMarker(type: MapMarkerType, name: String, at location: HexPoint)
    func removeMarker(at location: HexPoint)
}

public class MapMarkerPickerViewModel: ObservableObject {

    @Published
    var name: String = ""

    @Published
    var selectedType: MapMarkerType = .none

    var selectedLocation: HexPoint = .invalid

    @Published
    var markerViewModels: [MapMarkerTypeViewModel]

    weak var delegate: MapMarkerPickerViewModelDelegate?

    init() {

        var tmpMarkerViewModels: [MapMarkerTypeViewModel] = []

        for mapMarkerType in MapMarkerType.all {

            tmpMarkerViewModels.append(MapMarkerTypeViewModel(type: mapMarkerType))
        }

        self.markerViewModels = tmpMarkerViewModels
    }

    func update(location: HexPoint) {

        self.selectedLocation = location
    }

    func cancelClicked() {

        self.delegate?.close()

        self.name = ""
        self.selectedType = .none
        self.selectedLocation = .invalid
    }

    func okayClicked() {

        self.delegate?.addMarker(type: self.selectedType, name: self.name, at: self.selectedLocation)

        self.name = ""
        self.selectedType = .none
        self.selectedLocation = .invalid
    }
}
