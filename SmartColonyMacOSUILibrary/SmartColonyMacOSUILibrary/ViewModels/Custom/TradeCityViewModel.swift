//
//  CityViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.07.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol TradeCityViewModelDelegate: AnyObject {

    func selected(city: AbstractCity?)
}

class TradeCityViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    @Published
    var title: String

    @Published
    var leaderType: LeaderType

    // var yields

    let city: AbstractCity?
    weak var delegate: TradeCityViewModelDelegate?

    init(city: AbstractCity?) {

        self.city = city

        if let city = self.city {
            self.title = "\(city.name.localized()) (\(city.population()))"
            self.leaderType = city.player?.leader ?? .barbar
        } else {
            self.title = "Berlin (1)"
            self.leaderType = .barbar
        }
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.leaderType.iconTexture())
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: "pantheon-background")
    }

    func selectCity() {

        self.delegate?.selected(city: self.city)
    }
}
