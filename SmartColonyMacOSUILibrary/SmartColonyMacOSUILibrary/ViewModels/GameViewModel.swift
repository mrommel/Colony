//
//  GameViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.04.21.
//

import SmartAILibrary
import SmartAssets
import Cocoa
import SwiftUI

enum UICombatMode {

    case none
    case melee
    case rangedUnit
    case rangedCity
}

protocol GameViewModelDelegate: AnyObject {

    func focus(on point: HexPoint)
    func showUnitBanner()
    func hideUnitBanner()
    func select(unit: AbstractUnit?)
    func selectedUnitChanged(to unit: AbstractUnit?, commands: [Command], in gameModel: GameModel?)

    func showMeleeTargets(of unit: AbstractUnit?)
    func showRangedTargets(of unit: AbstractUnit?)
    func cancelAttacks()
    func showCombatBanner(for source: AbstractUnit?, and target: AbstractUnit?, ranged: Bool)
    func showCombatBanner(for source: AbstractCity?, and target: AbstractUnit?, ranged: Bool)
    func hideCombatBanner()

    func doCombat(of attacker: AbstractUnit?, against defender: AbstractUnit?)
    func doRangedCombat(of attacker: AbstractUnit?, against defender: AbstractUnit?)
    func doRangedCombat(of attacker: AbstractCity?, against defender: AbstractUnit?)

    func showCityBanner(for city: AbstractCity?)
    func hideCityBanner()
    func showRangedTargets(of city: AbstractCity?)

    func showPopup(popupType: PopupType)
    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData?)

    func showTechTreeDialog()
    func showTechListDialog()
    func showCivicTreeDialog()
    func showCivicListDialog()

    func showGovernmentDialog()
    func showChangeGovernmentDialog()
    func showChangePoliciesDialog()
    func showTreasuryDialog()
    func showGovernorsDialog()
    func showGreatPeopleDialog()
    func showTradeRouteDialog()
    func showReligionDialog()

    func showCityNameDialog()
    func foundCity(named cityName: String)
    func showCityDialog(for city: AbstractCity?)
    func showCityChooseProductionDialog(for city: AbstractCity?)
    func showCityBuildingsDialog(for city: AbstractCity?)
    func showDiplomaticDialog(with otherPlayer: AbstractPlayer?, data: DiplomaticData?, deal: DiplomaticDeal?)

    func showSelectPantheonDialog()

    func showUnitListDialog()
    func showCityListDialog()
    func showSelectPromotionDialog(for unit: AbstractUnit?)

    func isShown(screen: ScreenType) -> Bool

    func checkPopups() -> Bool
    func add(notification: NotificationItem)
    func remove(notification: NotificationItem)

    func showSelectCityDialog(
        start startCity: AbstractCity?,
        of cities: [AbstractCity?],
        completion: @escaping (AbstractCity?) -> Void
    )
    func showConfirmationDialog(
        title: String,
        question: String,
        confirm: String,
        cancel: String,
        completion: @escaping (Bool) -> Void
    )
    func showSelectionDialog(titled title: String, items: [SelectableItem], completion: @escaping (Int) -> Void)

    func closeDialog()
    func closePopup()

    func update()
}

// swiftlint:disable type_body_length
public class GameViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var magnification: CGFloat = 0.5

    @Published
    var gameSceneViewModel: GameSceneViewModel

    @Published
    var notificationsViewModel: NotificationsViewModel

    @Published
    var cityBannerViewModel: CityBannerViewModel

    @Published
    var unitBannerViewModel: UnitBannerViewModel

    @Published
    var combatBannerViewModel: CombatBannerViewModel

    @Published
    var headerViewModel: HeaderViewModel

    // dialogs

    @Published
    var governmentDialogViewModel: GovernmentDialogViewModel

    @Published
    var changeGovernmentDialogViewModel: ChangeGovernmentDialogViewModel

    @Published
    var changePolicyDialogViewModel: ChangePolicyDialogViewModel

    @Published
    var techDialogViewModel: TechDialogViewModel

    @Published
    var civicDialogViewModel: CivicDialogViewModel

    @Published
    var diplomaticDialogViewModel: DiplomaticDialogViewModel

    @Published
    var cityNameDialogViewModel: CityNameDialogViewModel

    @Published
    var confirmationDialogViewModel: ConfirmationDialogViewModel

    @Published
    var selectTradeCityDialogViewModel: SelectTradeCityDialogViewModel

    @Published
    var cityDialogViewModel: CityDialogViewModel

    @Published
    var unitListDialogViewModel: UnitListDialogViewModel

    @Published
    var cityListDialogViewModel: CityListDialogViewModel

    @Published
    var selectPromotionDialogViewModel: SelectPromotionDialogViewModel

    @Published
    var selectPantheonDialogViewModel: SelectPantheonDialogViewModel

    @Published
    var treasuryDialogViewModel: TreasuryDialogViewModel

    @Published
    var governorsDialogViewModel: GovernorsDialogViewModel

    @Published
    var greatPeopleDialogViewModel: GreatPeopleDialogViewModel

    @Published
    var tradeRoutesDialogViewModel: TradeRoutesDialogViewModel

    @Published
    var selectItemsDialogViewModel: SelectItemsDialogViewModel

    @Published
    var religionDialogViewModel: ReligionDialogViewModel

    // UI

    @Published
    var currentScreenType: ScreenType = .none

    @Published
    var currentPopupType: PopupType = .none

    var popups: [PopupType] = []

    var uiCombatMode: UICombatMode = .none

    // MARK: map display options

    @Published
    public var mapOptionShowResourceMarkers: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showResourceMarkers = self.mapOptionShowResourceMarkers
        }
    }

    @Published
    public var mapOptionShowYields: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showYields = self.mapOptionShowYields
        }
    }

    @Published
    public var mapOptionShowWater: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showWater = self.mapOptionShowWater
        }
    }

    // debug

    @Published
    public var mapOptionShowHexCoordinates: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showHexCoordinates = self.mapOptionShowHexCoordinates
        }
    }

    @Published
    public var mapOptionShowCompleteMap: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showCompleteMap = self.mapOptionShowCompleteMap
        }
    }

    private let textureNames: [String] = [
        "water", "focus-attack1", "focus-attack2", "focus-attack3",
        "focus1", "focus2", "focus3", "focus4", "focus5", "focus6",
        "unit-type-background", "cursor", "top-bar", "grid9-dialog",
        "techInfo-active", "techInfo-disabled", "techInfo-researched", "techInfo-researching",
        "civicInfo-active", "civicInfo-disabled", "civicInfo-researched", "civicInfo-researching",
        "notification-bagde", "notification-bottom", "notification-top", "grid9-button-active",
        "grid9-button-clicked", "banner", "science-progress", "culture-progress", "header-bar-button",
        "header-bar-left", "header-bar-right", "city-banner", "grid9-button-district-active",
        "grid9-button-district", "grid9-button-highlighted", "questionmark", "tile-purchase-active",
        "tile-purchase-disabled", "tile-citizen-normal", "tile-citizen-selected", "tile-citizen-forced",
        "city-canvas", "pantheon-background", "turns", "unit-banner", "combat-view",
        "unit-strength-background", "unit-strength-frame", "unit-strength-bar", "loyalty"
    ]

    // MARK: constructor

    public init(preloadAssets: Bool = false) {

        // init models
        self.gameSceneViewModel = GameSceneViewModel()
        self.notificationsViewModel = NotificationsViewModel()
        self.headerViewModel = HeaderViewModel()
        self.cityBannerViewModel = CityBannerViewModel()
        self.unitBannerViewModel = UnitBannerViewModel(selectedUnit: nil)
        self.combatBannerViewModel = CombatBannerViewModel()

        // dialogs
        self.governmentDialogViewModel = GovernmentDialogViewModel()
        self.changeGovernmentDialogViewModel = ChangeGovernmentDialogViewModel()
        self.changePolicyDialogViewModel = ChangePolicyDialogViewModel()
        self.techDialogViewModel = TechDialogViewModel()
        self.civicDialogViewModel = CivicDialogViewModel()
        self.cityNameDialogViewModel = CityNameDialogViewModel()
        self.confirmationDialogViewModel = ConfirmationDialogViewModel()
        self.cityDialogViewModel = CityDialogViewModel()
        self.diplomaticDialogViewModel = DiplomaticDialogViewModel()
        self.selectTradeCityDialogViewModel = SelectTradeCityDialogViewModel()
        self.unitListDialogViewModel = UnitListDialogViewModel()
        self.cityListDialogViewModel = CityListDialogViewModel()
        self.selectPromotionDialogViewModel = SelectPromotionDialogViewModel()
        self.selectPantheonDialogViewModel = SelectPantheonDialogViewModel()
        self.treasuryDialogViewModel = TreasuryDialogViewModel()
        self.governorsDialogViewModel = GovernorsDialogViewModel()
        self.tradeRoutesDialogViewModel = TradeRoutesDialogViewModel()
        self.greatPeopleDialogViewModel = GreatPeopleDialogViewModel()
        self.selectItemsDialogViewModel = SelectItemsDialogViewModel()
        self.religionDialogViewModel = ReligionDialogViewModel()

        // connect models
        self.gameSceneViewModel.delegate = self
        self.notificationsViewModel.delegate = self
        self.headerViewModel.delegate = self
        self.cityBannerViewModel.delegate = self
        self.unitBannerViewModel.delegate = self
        self.combatBannerViewModel.delegate = self

        self.governmentDialogViewModel.delegate = self
        self.changeGovernmentDialogViewModel.delegate = self
        self.changePolicyDialogViewModel.delegate = self
        self.techDialogViewModel.delegate = self
        self.civicDialogViewModel.delegate = self
        self.cityNameDialogViewModel.delegate = self
        self.confirmationDialogViewModel.delegate = self
        self.cityDialogViewModel.delegate = self
        self.diplomaticDialogViewModel.delegate = self
        self.selectTradeCityDialogViewModel.delegate = self
        self.unitListDialogViewModel.delegate = self
        self.cityListDialogViewModel.delegate = self
        self.selectPromotionDialogViewModel.delegate = self
        self.selectPantheonDialogViewModel.delegate = self
        self.treasuryDialogViewModel.delegate = self
        self.governorsDialogViewModel.delegate = self
        self.tradeRoutesDialogViewModel.delegate = self
        self.greatPeopleDialogViewModel.delegate = self
        self.selectItemsDialogViewModel.delegate = self
        self.religionDialogViewModel.delegate = self

        self.mapOptionShowResourceMarkers = self.gameEnvironment.displayOptions.value.showResourceMarkers
        self.mapOptionShowWater = self.gameEnvironment.displayOptions.value.showWater
        self.mapOptionShowYields = self.gameEnvironment.displayOptions.value.showYields

        self.mapOptionShowHexCoordinates = self.gameEnvironment.displayOptions.value.showHexCoordinates
        self.mapOptionShowCompleteMap = self.gameEnvironment.displayOptions.value.showCompleteMap

        if preloadAssets {
            self.loadAssets()
        }
    }

    public func loadAssets() {

        // load assets into image cache
        print("-- pre-load images --")
        let bundle = Bundle.init(for: Textures.self)
        let textures: Textures = Textures(game: nil)

        print("- load \(textures.allTerrainTextureNames.count) terrain textures")
        for terrainTextureName in textures.allTerrainTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: terrainTextureName), for: terrainTextureName)
        }

        print("- load \(textures.allCoastTextureNames.count) coast textures")
        for coastTextureName in textures.allCoastTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: coastTextureName), for: coastTextureName)
        }

        print("- load \(textures.allRiverTextureNames.count) river textures")
        for riverTextureName in textures.allRiverTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: riverTextureName), for: riverTextureName)
        }

        print("- load \(textures.allFeatureTextureNames.count) feature textures")
        for featureTextureName in textures.allFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: featureTextureName), for: featureTextureName)
        }

        print("- load \(textures.allIceFeatureTextureNames.count) ice textures")
        for iceFeatureTextureName in textures.allIceFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: iceFeatureTextureName), for: iceFeatureTextureName)
        }

        print("- load \(textures.allSnowFeatureTextureNames.count) snow textures")
        for snowFeatureTextureName in textures.allSnowFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: snowFeatureTextureName), for: snowFeatureTextureName)
        }

        print("- load \(textures.allResourceTextureNames.count) resource and marker textures")
        for resourceTextureName in textures.allResourceTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: resourceTextureName), for: resourceTextureName)
        }
        for resourceMarkerTextureName in textures.allResourceMarkerTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: resourceMarkerTextureName), for: resourceMarkerTextureName)
        }

        print("- load \(textures.allBorderTextureNames.count) border textures")
        for borderTextureName in textures.allBorderTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: borderTextureName), for: borderTextureName)
        }

        print("- load \(textures.allYieldsTextureNames.count) yield textures")
        for yieldTextureName in textures.allYieldsTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: yieldTextureName), for: yieldTextureName)
        }

        print("- load \(textures.allBoardTextureNames.count) board textures")
        for boardTextureName in textures.allBoardTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: boardTextureName), for: boardTextureName)
        }

        print("- load \(textures.allImprovementTextureNames.count) improvement textures")
        for improvementTextureName in textures.allImprovementTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: improvementTextureName), for: improvementTextureName)
        }

        print("- load \(textures.allRoadTextureNames.count) road textures")
        for roadTextureName in textures.allRoadTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: roadTextureName), for: roadTextureName)
        }

        print("- load \(textures.allPathTextureNames.count) + \(textures.allPathOutTextureNames.count) path textures")
        for pathTextureName in textures.allPathTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: pathTextureName), for: pathTextureName)
        }
        for pathTextureName in textures.allPathOutTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: pathTextureName), for: pathTextureName)
        }

        print("- load \(textures.overviewTextureNames.count) overview textures")
        for overviewTextureName in textures.overviewTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: overviewTextureName), for: overviewTextureName)
        }

        var unitTextures: Int = 0
        for unitType in UnitType.all {

            if let idleTextures = unitType.idleAtlas?.textures {
                for (index, texture) in idleTextures.enumerated() {
                    ImageCache.shared.add(image: texture, for: "\(unitType.name().lowercased())-idle-\(index)")

                    unitTextures += 1
                }
            } else {
                print("cant get idle textures of \(unitType.name())")
            }

            ImageCache.shared.add(image: bundle.image(forResource: unitType.portraitTexture()), for: unitType.portraitTexture())
            ImageCache.shared.add(image: bundle.image(forResource: unitType.typeTexture()), for: unitType.typeTexture())
            ImageCache.shared.add(image: bundle.image(forResource: unitType.typeTemplateTexture()), for: unitType.typeTemplateTexture())
        }
        print("- load \(unitTextures) unit textures")

        // populate cache with ui textures
        print("- load \(self.textureNames.count) misc textures")
        for textureName in self.textureNames {
            if !ImageCache.shared.exists(key: textureName) {
                // load from SmartAsset package
                ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
            }
        }

        print("- load \(textures.buttonTextureNames.count) button textures")
        for buttonTextureName in textures.buttonTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: buttonTextureName), for: buttonTextureName)
        }

        print("- load \(textures.globeTextureNames.count) globe textures")
        for globeTextureName in textures.globeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: globeTextureName), for: globeTextureName)
        }

        print("- load \(textures.cultureProgressTextureNames.count) culture progress textures")
        for cultureProgressTextureName in textures.cultureProgressTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: cultureProgressTextureName), for: cultureProgressTextureName)
        }

        print("- load \(textures.scienceProgressTextureNames.count) science progress textures")
        for scienceProgressTextureName in textures.scienceProgressTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: scienceProgressTextureName), for: scienceProgressTextureName)
        }

        print("- load \(textures.attackerHealthTextureNames.count) attacker health textures")
        for attackerHealthTextureName in textures.attackerHealthTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: attackerHealthTextureName),
                for: attackerHealthTextureName
            )
        }
        print("- load \(textures.defenderHealthTextureNames.count) defender health textures")
        for defenderHealthTextureName in textures.defenderHealthTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: defenderHealthTextureName),
                for: defenderHealthTextureName
            )
        }

        print("- load \(textures.headerTextureNames.count) header textures")
        for headerTextureName in textures.headerTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: headerTextureName), for: headerTextureName)
        }

        print("- load \(textures.cityProgressTextureNames.count) city progress textures")
        for cityProgressTextureName in textures.cityProgressTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: cityProgressTextureName), for: cityProgressTextureName)
        }

        print("- load \(textures.cityTextureNames.count) city textures")
        for cityTextureName in textures.cityTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: cityTextureName), for: cityTextureName)
        }

        print("- load \(textures.commandTextureNames.count) command type textures")
        for commandTextureName in textures.commandTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: commandTextureName), for: commandTextureName)
        }

        print("- load \(textures.commandButtonTextureNames.count) command button textures")
        for commandButtonTextureName in textures.commandButtonTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: commandButtonTextureName), for: commandButtonTextureName)
        }

        print("- load \(textures.cityCommandButtonTextureNames.count) city command textures")
        for cityCommandTextureName in textures.cityCommandButtonTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: cityCommandTextureName), for: cityCommandTextureName)
        }

        print("- load \(textures.policyCardTextureNames.count) policy card textures")
        for policyCardTextureName in textures.policyCardTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: policyCardTextureName), for: policyCardTextureName)
        }

        print("- load \(textures.governmentStateBackgroundTextureNames.count) government state background textures")
        for governmentStateBackgroundTextureName in textures.governmentStateBackgroundTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: governmentStateBackgroundTextureName),
                for: governmentStateBackgroundTextureName
            )
        }

        print("- load \(textures.governmentTextureNames.count) government textures")
        for governmentTextureName in textures.governmentTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: governmentTextureName), for: governmentTextureName)
        }

        print("- load \(textures.governmentAmbientTextureNames.count) ambient textures")
        for governmentAmbientTextureName in textures.governmentAmbientTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: governmentAmbientTextureName), for: governmentAmbientTextureName)
        }

        print("- load \(textures.yieldTextureNames.count) / \(textures.yieldBackgroundTextureNames.count) yield textures")
        for yieldTextureName in textures.yieldTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: yieldTextureName), for: yieldTextureName)
        }
        for yieldBackgroundTextureName in textures.yieldBackgroundTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: yieldBackgroundTextureName), for: yieldBackgroundTextureName)
        }

        print("- load \(textures.techTextureNames.count) tech type textures")
        for techTextureName in textures.techTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: techTextureName), for: techTextureName)
        }

        print("- load \(textures.civicTextureNames.count) civic type textures")
        for civicTextureName in textures.civicTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: civicTextureName), for: civicTextureName)
        }

        print("- load \(textures.buildTypeTextureNames.count) build type textures")
        for buildTypeTextureName in textures.buildTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: buildTypeTextureName), for: buildTypeTextureName)
        }

        print("- load \(textures.buildingTypeTextureNames.count) building type textures")
        for buildingTypeTextureName in textures.buildingTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: buildingTypeTextureName), for: buildingTypeTextureName)
        }

        print("- load \(textures.wonderTypeTextureNames.count) wonder type textures")
        for wonderTypeTextureName in textures.wonderTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: wonderTypeTextureName), for: wonderTypeTextureName)
        }

        print("- load \(textures.districtTypeTextureNames.count) district type textures")
        for districtTypeTextureName in textures.districtTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: districtTypeTextureName), for: districtTypeTextureName)
        }

        print("- load \(textures.leaderTypeTextureNames.count) leader type textures")
        for leaderTypeTextureName in textures.leaderTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: leaderTypeTextureName), for: leaderTypeTextureName)
        }

        print("- load \(textures.civilizationTypeTextureNames.count) civilization type textures")
        for civilizationTypeTextureName in textures.civilizationTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: civilizationTypeTextureName),
                for: civilizationTypeTextureName
            )
        }

        print("- load \(textures.pantheonTypeTextureNames.count) pantheon type textures")
        for pantheonTypeTextureName in textures.pantheonTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: pantheonTypeTextureName), for: pantheonTypeTextureName)
        }

        print("- load \(textures.religionTypeTextureNames.count) religion type textures")
        for religionTypeTextureName in textures.religionTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: religionTypeTextureName), for: religionTypeTextureName)
        }

        print("- load \(textures.beliefTypeTextureNames.count) belief type textures")
        for beliefTypeTextureName in textures.beliefTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: beliefTypeTextureName), for: beliefTypeTextureName)
        }

        print("- load \(textures.promotionTextureNames.count) promotion type textures")
        for promotionTextureName in textures.promotionTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: promotionTextureName), for: promotionTextureName)
        }

        print("- load \(textures.promotionStateBackgroundTextureNames.count) promotion state textures")
        for promotionStateBackgroundTextureName in textures.promotionStateBackgroundTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: promotionStateBackgroundTextureName),
                for: promotionStateBackgroundTextureName
            )
        }

        print("- load \(textures.governorPortraitTextureNames.count) governor portrait textures")
        for governorPortraitTextureName in textures.governorPortraitTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: governorPortraitTextureName),
                for: governorPortraitTextureName
            )
        }

        print("-- all textures loaded --")
    }

    public func centerCapital() {

        guard let game = self.gameEnvironment.game.value else {
            print("cant center on capital: game not set")
            return
        }

        guard let human = game.humanPlayer() else {
            print("cant center on capital: human not set")
            return
        }

        if let capital = game.capital(of: human) {
            self.gameEnvironment.moveCursor(to: capital.location)
            self.centerOnCursor()
            return
        }

        if let unitRef = game.units(of: human).first, let unit = unitRef {
            self.gameEnvironment.moveCursor(to: unit.location)
            self.centerOnCursor()
            return
        }

        print("cant center on capital: no capital nor units")
    }

    func update() {

        self.headerViewModel.update()
    }

    public func centerOnCursor() {

        let cursor = self.gameEnvironment.cursor.value

        self.focus(on: cursor)
    }

    public func zoomIn() {

        self.magnification *= 0.75
    }

    public func zoomOut() {

        self.magnification /= 0.75
    }

    public func zoomReset() {

        self.magnification = 1.0
    }

    func displayPopups() {

        guard self.currentPopupType == .none else {
            print("popup already shown: \(self.currentPopupType)")
            return
        }

        if let firstPopup = self.popups.first {

            print("show popup: \(firstPopup)")

            switch firstPopup {

            case .none:
                // NOOP
                break
            case .declareWarQuestion(_):
                // NOOP
                break
            case .barbarianCampCleared:
                // NOOP
                break

            case .techDiscovered(let techType):
                self.currentPopupType = .techDiscovered(tech: techType)

            case .civicDiscovered(let civicType):
                self.currentPopupType = .civicDiscovered(civic: civicType)

            case .eraEntered(let eraType):
                self.currentPopupType = .eraEntered(era: eraType)

            case .eurekaTechActivated(let techType):
                self.currentPopupType = .eurekaTechActivated(tech: techType)

            case .eurekaCivicActivated(let civicType):
                self.currentPopupType = .eurekaCivicActivated(civic: civicType)

            case .goodyHutReward(let goodyType, let location):
                self.currentPopupType = .goodyHutReward(goodyType: goodyType, location: location)

            case .unitTrained(unit: _):
                // NOOP
                break

            case .buildingBuilt:
                // NOOP
                break

            case .wonderBuilt(let wonderType):
                self.currentPopupType = .wonderBuilt(wonder: wonderType)

            case .religionByCityAdopted(_, _):
                fatalError("religionByCityAdopted")

            case .religionNewMajority(_):
                // TXT_KEY_NOTIFICATION_RELIGION_NEW_PLAYER_MAJORITY
                fatalError("TXT_KEY_NOTIFICATION_RELIGION_NEW_PLAYER_MAJORITY")
            case .religionCanBuyMissionary:
                // TXT_KEY_NOTIFICATION_ENOUGH_FAITH_FOR_MISSIONARY
                fatalError("TXT_KEY_NOTIFICATION_ENOUGH_FAITH_FOR_MISSIONARY")
            case .canFoundPantheon:
                self.currentPopupType = .canFoundPantheon

            case .religionNeedNewAutomaticFaithSelection:
                // TXT_KEY_NOTIFICATION_NEED_NEW_AUTOMATIC_FAITH_SELECTION
                fatalError("TXT_KEY_NOTIFICATION_NEED_NEW_AUTOMATIC_FAITH_SELECTION")
            case .religionEnoughFaithForMissionary:
                // ENOUGH_FAITH_FOR_MISSIONARY
                fatalError("ENOUGH_FAITH_FOR_MISSIONARY")
            }

            self.popups.removeFirst()
            return
        }
    }
}

extension GameViewModel: GameViewModelDelegate {

    func focus(on point: HexPoint) {

        self.gameSceneViewModel.centerOn = point
    }

    func showUnitBanner() {

        self.unitBannerViewModel.showBanner = true
        self.cityBannerViewModel.showBanner = false
        //self.combatBannerViewModel.showBanner = false
    }

    func hideUnitBanner() {

        self.unitBannerViewModel.showBanner = false
        //self.combatBannerViewModel.showBanner = false
    }

    func select(unit: AbstractUnit?) {

        self.gameSceneViewModel.selectedUnit = unit
    }

    func selectedUnitChanged(to unit: AbstractUnit?, commands: [Command], in gameModel: GameModel?) {

        self.unitBannerViewModel.selectedUnitChanged(to: unit, commands: commands, in: gameModel)
    }

    func showMeleeTargets(of unit: AbstractUnit?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let player = unit?.player else {
            fatalError("cant get unit player")
        }

        guard let diplomacyAI = unit?.player?.diplomacyAI else {
            fatalError("cant get unit player diplomacyAI")
        }

        self.uiCombatMode = .melee

        if let unit = unit {

            // reset icons
            gameModel.userInterface?.clearAttackFocus()

            // check neighbors
            for dir in HexDirection.all {

                let neighbor = unit.location.neighbor(in: dir)

                if let otherUnit = gameModel.unit(at: neighbor, of: .combat) {

                    if (!player.isEqual(to: otherUnit.player) && diplomacyAI.isAtWar(with: otherUnit.player)) ||
                        otherUnit.isBarbarian() {
                        gameModel.userInterface?.showAttackFocus(at: neighbor)
                    }
                }
            }

            self.gameSceneViewModel.unitSelectionMode = .meleeUnitTargets
        }
    }

    func showRangedTargets(of unit: AbstractUnit?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let player = unit?.player else {
            fatalError("cant get unit player")
        }

        guard let diplomacyAI = unit?.player?.diplomacyAI else {
            fatalError("cant get unit player diplomacyAI")
        }

        self.uiCombatMode = .rangedUnit

        if let unit = unit {

            // reset icons
            gameModel.userInterface?.clearAttackFocus()

            // check neighbors
            for neighbor in unit.location.areaWith(radius: unit.range()) {

                if let otherUnit = gameModel.unit(at: neighbor, of: .combat) {

                    if !player.isEqual(to: otherUnit.player) && (diplomacyAI.isAtWar(with: otherUnit.player) || otherUnit.isBarbarian()) {
                        gameModel.userInterface?.showAttackFocus(at: neighbor)
                    }
                }
            }

            self.gameSceneViewModel.unitSelectionMode = .rangedUnitTargets
        }
    }

    func doCombat(of attacker: AbstractUnit?, against defender: AbstractUnit?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        if !attacker!.doAttack(into: defender!.location, steps: 1, in: gameModel) {
            print("attack failed")
        }
    }

    func doRangedCombat(of attacker: AbstractUnit?, against defender: AbstractUnit?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        if !attacker!.doRangeAttack(at: defender!.location, in: gameModel) {
            print("attack failed")
        }
    }

    func doRangedCombat(of attacker: AbstractCity?, against defender: AbstractUnit?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        if !attacker!.doRangeAttack(at: defender!.location, in: gameModel) {
            print("attack failed")
        }
    }

    func cancelAttacks() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        // reset icons
        gameModel.userInterface?.clearAttackFocus()

        self.uiCombatMode = .none
        self.gameSceneViewModel.unitSelectionMode = .pick
    }

    func showCombatBanner(for source: AbstractUnit?, and target: AbstractUnit?, ranged: Bool) {

        self.combatBannerViewModel.update(for: source, and: target, ranged: ranged)

        self.cityBannerViewModel.showBanner = false
        self.unitBannerViewModel.showBanner = false
        self.combatBannerViewModel.showBanner = true
    }

    func showCombatBanner(for source: AbstractCity?, and target: AbstractUnit?, ranged: Bool) {

        guard ranged == true else {
            fatalError("combat from city towards unit must be ranged")
        }

        self.combatBannerViewModel.update(for: source, and: target, ranged: ranged)

        self.cityBannerViewModel.showBanner = false
        self.unitBannerViewModel.showBanner = false
        self.combatBannerViewModel.showBanner = true
    }

    func hideCombatBanner() {

        self.combatBannerViewModel.showBanner = false
    }

    func showCityBanner(for city: AbstractCity?) {

        self.cityBannerViewModel.update(for: city)
        self.cityBannerViewModel.showBanner = true
        self.unitBannerViewModel.showBanner = false
        self.combatBannerViewModel.showBanner = false
    }

    func hideCityBanner() {

        self.cityBannerViewModel.showBanner = false
    }

    func showRangedTargets(of city: AbstractCity?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let player = city?.player else {
            fatalError("cant get unit player")
        }

        guard let diplomacyAI = city?.player?.diplomacyAI else {
            fatalError("cant get unit player diplomacyAI")
        }

        self.uiCombatMode = .rangedCity

        if let city = city {

            // reset icons
            gameModel.userInterface?.clearAttackFocus()

            // check neighbors
            for neighbor in city.location.areaWith(radius: 2) {

                if let otherUnit = gameModel.unit(at: neighbor, of: .combat) {

                    if !player.isEqual(to: otherUnit.player) && (diplomacyAI.isAtWar(with: otherUnit.player) || otherUnit.isBarbarian()) {
                        gameModel.userInterface?.showAttackFocus(at: neighbor)
                    }
                }
            }

            self.gameSceneViewModel.unitSelectionMode = .rangedCityTargets
        }
    }

    func showPopup(popupType: PopupType) {

        self.popups.append(popupType)
    }

    func closePopup() {

        self.currentPopupType = .none
    }

    func showScreen(screenType: ScreenType, city: AbstractCity?, other otherPlayer: AbstractPlayer?, data: DiplomaticData?) {

        switch screenType {

        case .interimRanking:
            // self.showInterimRankingDialog()
            print("==> interimRanking")

        case .diplomatic:
            self.showDiplomaticDialog(with: otherPlayer, data: data, deal: nil)

        case .city:
            self.showCityDialog(for: city)

        case .techTree:
            self.showTechTreeDialog()

        case .techList:
            self.showTechListDialog()

        case .civicTree:
            self.showCivicTreeDialog()

        case .civicList:
            self.showCivicListDialog()

        case .treasury:
            self.showTreasuryDialog()

        case .menu:
            // self.showMenuDialog()
            print("==> menu")

        case .government:
            self.showGovernmentDialog()

        case .selectPromotion:

            guard let gameModel = self.gameEnvironment.game.value else {
                fatalError("cant get game")
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human player")
            }

            if let promotableUnit = humanPlayer.firstPromotableUnit(in: gameModel) {

                self.showSelectPromotionDialog(for: promotableUnit)
            }
        case .changePolicies:
            self.showChangePoliciesDialog()

        case .selectPantheon:
            self.showSelectPantheonDialog()

        case .governors:
            self.showGovernorsDialog()

        case .religion:
            self.showReligionDialog()

        default:
            print("screen: \(screenType) not handled")
        }
    }

    func foundCity(named cityName: String) {

        self.gameSceneViewModel.foundCity(named: cityName)
    }

    func showConfirmationDialog(
        title: String,
        question: String,
        confirm: String,
        cancel: String,
        completion: @escaping (Bool) -> Void
    ) {

        if self.currentScreenType == .confirm {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.confirmationDialogViewModel.update(
                title: title,
                question: question,
                confirm: confirm,
                cancel: cancel,
                completion: completion
            )
            self.currentScreenType = .confirm
        } else {
            fatalError("cant show disband unit confirmation dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showSelectCityDialog(start startCity: AbstractCity?,
                              of cities: [AbstractCity?],
                              completion: @escaping (AbstractCity?) -> Void) {

        if self.currentScreenType == .selectTradeCity {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.selectTradeCityDialogViewModel.update(start: startCity, of: cities, completion: completion)
            self.currentScreenType = .selectTradeCity
        } else {
            fatalError("cant show select trade city dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showSelectionDialog(titled title: String,
                             items: [SelectableItem],
                             completion: @escaping (Int) -> Void) {

        if self.currentScreenType == .selectItems {
            // already shown
            return
        }

        let previousScreenType: ScreenType = self.currentScreenType

        let tmpCompletion: SelectItemsDialogViewModel.SelectItemsCompletionBlock = { selectedIndex in

            // switch back to previous screen, ...
            self.currentScreenType = previousScreenType

            // ... before calling the completion handler of that screen
            completion(selectedIndex)
        }

        if self.currentScreenType == .none || self.currentScreenType == .governors {
            self.selectItemsDialogViewModel.update(title: title, items: items, completion: tmpCompletion)
            self.currentScreenType = .selectItems
        } else {
            fatalError("cant show select items dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showDiplomaticDialog(with otherPlayer: AbstractPlayer?, data: DiplomaticData?, deal: DiplomaticDeal?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        guard let data = data else {
            fatalError("cant get data")
        }

        if self.currentScreenType == .diplomatic {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.diplomaticDialogViewModel.update(
                for: humanPlayer,
                and: otherPlayer,
                state: data.state,
                message: data.message,
                emotion: data.emotion,
                in: gameModel
            )

            if let deal = deal {
                diplomaticDialogViewModel.add(deal: deal)
            }

            DispatchQueue.main.async {
                self.currentScreenType = .diplomatic
            }
        } else {
            fatalError("cant show diplomatic dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showUnitListDialog() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if self.currentScreenType == .unitList {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.unitListDialogViewModel.update(for: humanPlayer)
            self.currentScreenType = .unitList
        } else {
            fatalError("cant show unit list dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showCityListDialog() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if self.currentScreenType == .cityList {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.cityListDialogViewModel.update(for: humanPlayer)
            self.currentScreenType = .cityList
        } else {
            fatalError("cant show city list dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showSelectPromotionDialog(for unit: AbstractUnit?) {

        if self.currentScreenType == .selectPromotion {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.selectPromotionDialogViewModel.update(for: unit)
            self.currentScreenType = .selectPromotion
        } else {
            fatalError("cant show select promotion dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showSelectPantheonDialog() {

        if self.currentScreenType == .selectPantheon {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.selectPantheonDialogViewModel.update()
            self.currentScreenType = .selectPantheon
        } else {
            fatalError("cant show select pantheon dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func checkPopups() -> Bool {

        if self.currentScreenType == .none {

            //print("-- checkPopups \(self.popups.count) / \(self.currentPopupType) --")
            if !self.popups.isEmpty && self.currentPopupType == .none {
                self.displayPopups()
                return true
            }
        }

        return false
    }

    func add(notification: NotificationItem) {

        self.notificationsViewModel.add(notification: notification)
    }

    func remove(notification: NotificationItem) {

        self.notificationsViewModel.remove(notification: notification)
    }

    func isShown(screen: ScreenType) -> Bool {

        return self.currentScreenType == screen
    }

    func closeDialog() {

        // update some models
        self.governmentDialogViewModel.update()

        self.currentScreenType = .none
    }
}
