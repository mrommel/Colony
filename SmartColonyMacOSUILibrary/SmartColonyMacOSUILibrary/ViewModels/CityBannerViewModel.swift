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

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var name: String

    @Published
    var main: NSColor

    @Published
    var accent: NSColor

    @Published
    var foodYieldViewModel: YieldValueViewModel

    @Published
    var productionYieldViewModel: YieldValueViewModel

    @Published
    var goldYieldViewModel: YieldValueViewModel

    @Published
    var scienceYieldViewModel: YieldValueViewModel

    @Published
    var cultureYieldViewModel: YieldValueViewModel

    @Published
    var faithYieldViewModel: YieldValueViewModel

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

        self.foodYieldViewModel = YieldValueViewModel(yieldType: .food, initial: 0.0, type: .onlyDelta, withBackground: false)
        self.productionYieldViewModel = YieldValueViewModel(yieldType: .production, initial: 0.0, type: .onlyDelta, withBackground: false)
        self.goldYieldViewModel = YieldValueViewModel(yieldType: .gold, initial: 0.0, type: .onlyDelta, withBackground: false)
        self.scienceYieldViewModel = YieldValueViewModel(yieldType: .science, initial: 0.0, type: .onlyDelta, withBackground: false)
        self.cultureYieldViewModel = YieldValueViewModel(yieldType: .culture, initial: 0.0, type: .onlyDelta, withBackground: false)
        self.faithYieldViewModel = YieldValueViewModel(yieldType: .faith, initial: 0.0, type: .onlyDelta, withBackground: false)
    }

#if DEBUG
    init(name: String = "", civilization: CivilizationType) {

        self.name = name
        self.main = civilization.main
        self.accent = civilization.accent
        self.civilizationTextureName = civilization.iconTexture()
        self.productionTextureName = BuildingType.ancientWalls.iconTexture()

        self.foodYieldViewModel = YieldValueViewModel(yieldType: .food, initial: 0.0, type: .onlyDelta, withBackground: false)
        self.productionYieldViewModel = YieldValueViewModel(yieldType: .production, initial: 0.0, type: .onlyDelta, withBackground: false)
        self.goldYieldViewModel = YieldValueViewModel(yieldType: .gold, initial: 0.0, type: .onlyDelta, withBackground: false)
        self.scienceYieldViewModel = YieldValueViewModel(yieldType: .science, initial: 0.0, type: .onlyDelta, withBackground: false)
        self.cultureYieldViewModel = YieldValueViewModel(yieldType: .culture, initial: 0.0, type: .onlyDelta, withBackground: false)
        self.faithYieldViewModel = YieldValueViewModel(yieldType: .faith, initial: 0.0, type: .onlyDelta, withBackground: false)
    }
#endif

    // MARK: methods

    func update(for cityRef: AbstractCity?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

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

        self.foodYieldViewModel.delta = city.foodPerTurn(in: gameModel)
        self.productionYieldViewModel.delta = city.productionPerTurn(in: gameModel)
        self.goldYieldViewModel.delta = city.goldPerTurn(in: gameModel)
        self.scienceYieldViewModel.delta = city.sciencePerTurn(in: gameModel)
        self.cultureYieldViewModel.delta = city.culturePerTurn(in: gameModel)
        self.faithYieldViewModel.delta = city.faithPerTurn(in: gameModel)
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
