//
//  CityStateViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 28.02.22.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol CityStateViewModelDelegate: AnyObject {

    func center(on cityState: CityStateType)
}

class CityStateViewModel: ObservableObject {

    @Published
    var name: String

    @Published
    var envoys: Int = 0 {
        didSet {
            print("number of envoys updated")
        }
    }

    private let cityState: CityStateType
    weak var delegate: CityStateViewModelDelegate?

    init(cityState: CityStateType) {

        self.cityState = cityState

        self.name = cityState.name()
    }

    func cityStateImage() -> NSImage {

        return ImageCache.shared.image(for: self.cityState.iconTexture())
    }

    func jumpToImage() -> NSImage {

        return ImageCache.shared.image(for: "jump-to")
    }

    func centerClicked() {

        self.delegate?.center(on: self.cityState)
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
