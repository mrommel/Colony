//
//  CityBannerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.06.21.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

class CityBannerViewModel: ObservableObject {

    @Published
    var name: String

    @Published
    var main: NSColor

    @Published
    var accent: NSColor

    @Published
    var showBanner: Bool = true

    weak var delegate: GameViewModelDelegate?

    private var civilizationTextureName: String
    private var productionTextureName: String

    // MARK: constructors

    init() {

        self.name = "Dummy"
        self.main = .bilobaFlower
        self.accent = .blue
        self.civilizationTextureName = CivilizationType.aztecs.iconTexture()
        self.productionTextureName = BuildingType.ancientWalls.iconTexture()
    }

#if DEBUG
    init(name: String = "", civilization: CivilizationType) {

        self.name = name
        self.main = civilization.main
        self.accent = civilization.accent
        self.civilizationTextureName = civilization.iconTexture()
        self.productionTextureName = BuildingType.ancientWalls.iconTexture()
    }
#endif

    // MARK: methods

    func update(for cityRef: AbstractCity?) {

        guard let city = cityRef else {
            fatalError("cant get city")
        }

        self.name = city.name
        self.main = city.leader.civilization().main
        self.accent = city.leader.civilization().accent
        self.civilizationTextureName = city.leader.civilization().iconTexture()

        if let buildableItem = city.currentBuildableItem() {
            self.productionTextureName = buildableItem.iconTexture()
        } else {
            self.productionTextureName = "questionmark"
        }
    }

    func cityBannerBackground() -> NSImage {

        return ImageCache.shared.image(for: "city-banner")
            .resize(withSize: NSSize(width: 12, height: 12))!
    }

    func cityCivilizationImage() -> NSImage {

        return ImageCache.shared.image(for: self.civilizationTextureName)
    }

    func cityProductionImage() -> NSImage {

        return ImageCache.shared.image(for: self.productionTextureName)
    }
}
