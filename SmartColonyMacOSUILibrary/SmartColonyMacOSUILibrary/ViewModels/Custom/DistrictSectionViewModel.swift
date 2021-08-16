//
//  DistrictSectionViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI

class DistrictSectionViewModel {

    let districtViewModel: DistrictViewModel
    let buildingViewModels: [BuildingViewModel]

    init(districtViewModel: DistrictViewModel, buildingViewModels: [BuildingViewModel]) {

        self.districtViewModel = districtViewModel
        self.buildingViewModels = buildingViewModels
    }
}

extension DistrictSectionViewModel: Hashable {

    static func == (lhs: DistrictSectionViewModel, rhs: DistrictSectionViewModel) -> Bool {

        return lhs.districtViewModel.districtType == rhs.districtViewModel.districtType
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.districtViewModel.districtType)
    }
}
