//
//  CityStateViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 28.02.22.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class CityStateViewModel: ObservableObject {

    @Published
    var name: String

    private let cityState: CityStateType

    init(cityState: CityStateType) {

        self.cityState = cityState

        self.name = cityState.name()
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.cityState.iconTexture())
    }
}

extension CityStateViewModel: Hashable {

    static func == (lhs: CityStateViewModel, rhs: CityStateViewModel) -> Bool {

        return lhs.cityState == rhs.cityState
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.cityState)
    }
}
