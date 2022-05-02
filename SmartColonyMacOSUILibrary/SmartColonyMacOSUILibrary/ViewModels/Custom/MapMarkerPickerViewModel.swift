//
//  MapMarkerPickerViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 29.04.22.
//

import Foundation
import SmartAILibrary
import SmartAssets

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
    var districtMarkerViewModels: [MapMarkerTypeViewModel]

    @Published
    var wonderMarkerViewModels: [MapMarkerTypeViewModel]

    weak var delegate: MapMarkerPickerViewModelDelegate?

    init() {

        var tmpMarkerViewModels: [MapMarkerTypeViewModel] = []

        for mapMarkerType in MapMarkerType.districts {

            tmpMarkerViewModels.append(MapMarkerTypeViewModel(type: mapMarkerType))
        }

        self.districtMarkerViewModels = tmpMarkerViewModels

        tmpMarkerViewModels = []

        for mapMarkerType in MapMarkerType.wonders {

            tmpMarkerViewModels.append(MapMarkerTypeViewModel(type: mapMarkerType))
        }

        self.wonderMarkerViewModels = tmpMarkerViewModels
    }

    func update(location: HexPoint) {

        self.selectedLocation = location
    }

    func selectionColor(of type: MapMarkerType) -> TypeColor {

        if type == self.selectedType {
            return TypeColor.white
        } else {
            return Globals.Colors.dialogBackground
        }
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