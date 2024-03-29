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
    var productionTitle: String

    @Published
    var productionEffects: [NSAttributedString]

    @Published
    var loyalityLabel: String

    @Published
    var religiousLabel: String

    @Published
    var amenitiesLabel: String

    @Published
    var housingLabel: String

    @Published
    var turnsUntilGrowthLabel: String

    @Published
    var showBanner: Bool = false

    weak var delegate: GameViewModelDelegate?

    private var civilizationTextureName: String
    private var productionTextureName: String
    private var commands: [CityCommandType] = []

    // MARK: constructors

    init() {

        self.name = "Dummy"
        self.main = .bilobaFlower
        self.accent = .blue
        self.civilizationTextureName = CivilizationType.aztecs.iconTexture()
        self.productionTextureName = BuildingType.ancientWalls.iconTexture()
        self.productionTitle = BuildingType.ancientWalls.name()
        self.productionEffects = BuildingType.ancientWalls.effects()
            .map { NSAttributedString(string: $0, attributes: Globals.Attributs.cityBannerAttributs) }

        self.loyalityLabel = "100"
        self.religiousLabel = "0"
        self.amenitiesLabel = "X"
        self.housingLabel = "X/Y"
        self.turnsUntilGrowthLabel = "X"

        self.foodYieldViewModel = YieldValueViewModel(
            yieldType: .food,
            initial: 0.0,
            type: .onlyDelta,
            withBackground: false
        )
        self.productionYieldViewModel = YieldValueViewModel(
            yieldType: .production,
            initial: 0.0,
            type: .onlyDelta,
            withBackground: false
        )
        self.goldYieldViewModel = YieldValueViewModel(
            yieldType: .gold,
            initial: 0.0,
            type: .onlyDelta,
            withBackground: false
        )
        self.scienceYieldViewModel = YieldValueViewModel(
            yieldType: .science,
            initial: 0.0,
            type: .onlyDelta,
            withBackground: false
        )
        self.cultureYieldViewModel = YieldValueViewModel(
            yieldType: .culture,
            initial: 0.0,
            type: .onlyDelta,
            withBackground: false
        )
        self.faithYieldViewModel = YieldValueViewModel(
            yieldType: .faith,
            initial: 0.0,
            type: .onlyDelta,
            withBackground: false
        )
    }

#if DEBUG
    init(name: String = "", civilization: CivilizationType) {

        self.name = name
        self.main = civilization.main
        self.accent = civilization.accent
        self.civilizationTextureName = civilization.iconTexture()
        self.productionTextureName = BuildingType.ancientWalls.iconTexture()
        self.productionTitle = BuildingType.ancientWalls.name()
        self.productionEffects = BuildingType.ancientWalls.effects()
            .map { NSAttributedString(string: $0, attributes: Globals.Attributs.cityBannerAttributs) }

        self.loyalityLabel = "100"
        self.religiousLabel = "0"
        self.amenitiesLabel = "X"
        self.housingLabel = "X/Y"
        self.turnsUntilGrowthLabel = "X"

        self.foodYieldViewModel = YieldValueViewModel(
            yieldType: .food,
            initial: 0.0,
            type: .onlyDelta,
            withBackground: false
        )
        self.productionYieldViewModel = YieldValueViewModel(
            yieldType: .production,
            initial: 0.0,
            type: .onlyDelta,
            withBackground: false
        )
        self.goldYieldViewModel = YieldValueViewModel(
            yieldType: .gold,
            initial: 0.0,
            type: .onlyDelta,
            withBackground: false
        )
        self.scienceYieldViewModel = YieldValueViewModel(
            yieldType: .science,
            initial: 0.0,
            type: .onlyDelta,
            withBackground: false
        )
        self.cultureYieldViewModel = YieldValueViewModel(
            yieldType: .culture,
            initial: 0.0,
            type: .onlyDelta,
            withBackground: false
        )
        self.faithYieldViewModel = YieldValueViewModel(
            yieldType: .faith,
            initial: 0.0,
            type: .onlyDelta,
            withBackground: false
        )

        self.showBanner = true
    }
#endif

    // MARK: methods

    func update(for cityRef: AbstractCity?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let city = cityRef as? City else {
            fatalError("cant get city")
        }

        self.name = city.name
        self.main = city.leader.civilization().main
        self.accent = city.leader.civilization().accent
        self.civilizationTextureName = city.leader.civilization().iconTexture()

        let labelTokenzier = LabelTokenizer()

        if let buildableItem = city.currentBuildableItem() {
            self.productionTextureName = buildableItem.iconTexture()
            self.productionTitle = buildableItem.name().localized()
            self.productionEffects = buildableItem.effects()
                .map { labelTokenzier.convert(text: $0.localized(), with: Globals.Attributs.cityBannerAttributs) }
        } else {
            self.productionTextureName = "questionmark"
            self.productionTitle = "TXT_KEY_CITY_NO_PRODUCTION".localized()
            self.productionEffects = []
        }

        self.loyalityLabel = "\(city.loyalty())"
        self.religiousLabel = "\(city.numReligiousCitizen())"
        self.amenitiesLabel = "\(city.amenitiesPerTurn(in: gameModel))/\(city.amenitiesNeeded())"
        self.housingLabel = "\(city.housingPerTurn(in: gameModel))/\(city.population())"
        self.turnsUntilGrowthLabel = "\(city.growthInTurns())"

        self.foodYieldViewModel.delta = city.foodPerTurn(in: gameModel)
        self.foodYieldViewModel.tooltip = city.foodPerTurnToolTip(in: gameModel)
        self.productionYieldViewModel.delta = city.productionPerTurn(in: gameModel)
        self.productionYieldViewModel.tooltip = city.productionPerTurnToolTip(in: gameModel)
        self.goldYieldViewModel.delta = city.goldPerTurn(in: gameModel)
        self.goldYieldViewModel.tooltip = city.goldPerTurnToolTip(in: gameModel)
        self.scienceYieldViewModel.delta = city.sciencePerTurn(in: gameModel)
        self.scienceYieldViewModel.tooltip = city.sciencePerTurnToolTip(in: gameModel)
        self.cultureYieldViewModel.delta = city.culturePerTurn(in: gameModel)
        self.cultureYieldViewModel.tooltip = city.culturePerTurnToolTip(in: gameModel)
        self.faithYieldViewModel.delta = city.faithPerTurn(in: gameModel)
        self.faithYieldViewModel.tooltip = city.faithPerTurnToolTip(in: gameModel)

        var tmpCommands: [CityCommandType] = []
        tmpCommands.append(.showBuilds(city: city))
        if city.canRangeStrike() && !city.isOutOfAttacks(in: gameModel) && city.isEnemyInRange(in: gameModel) {
            tmpCommands.append(.showRangedAttackTargets(city: city))
        }
        self.commands = tmpCommands
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

    func listImage() -> NSImage {

        return ImageCache.shared.image(for: "command-button-list")
    }

    func listClicked() {

        self.delegate?.showCityListDialog()
    }

    func commandImage(at index: Int) -> NSImage {

        if 0 <= index && index < self.commands.count {

            let command = self.commands[index]
            return ImageCache.shared.image(for: command.buttonTexture())
        }

        return NSImage(size: NSSize(width: 32, height: 32))
    }

    func commandClicked(at index: Int) {

        if 0 <= index && index < self.commands.count {

            let command = self.commands[index]
            // print("commandClicked(at: \(command.title()))")
            self.handle(command: command)
        }
    }

    func handle(command: CityCommandType) {

        switch command {

        case .showRangedAttackTargets(city: let city):
            self.delegate?.showRangedTargets(of: city)

        case .showBuilds(city: let city):
            self.delegate?.showCityChooseProductionDialog(for: city)

        case .aquireTiles(city: let city):
            self.delegate?.showCityAquireTilesDialog(for: city)

        case .purchaseGold(city: let city):
            self.delegate?.showCityPurchaseGoldDialog(for: city)

        case .purchaseFaith(city: let city):
            self.delegate?.showCityPurchaseFaithDialog(for: city)
        }
    }
}
