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

    func refreshTile(at point: HexPoint)
    func updateRect(at point: HexPoint, size: CGSize)

    func showMeleeTargets(of unit: AbstractUnit?)
    func showRangedTargets(of unit: AbstractUnit?)
    func cancelAttacks()
    func showCombatBanner(for source: AbstractUnit?, and target: AbstractUnit?, ranged: Bool)
    func showCombatBanner(for source: AbstractUnit?, and target: AbstractCity?, ranged: Bool)
    func showCombatBanner(for source: AbstractCity?, and target: AbstractUnit?, ranged: Bool)
    func hideCombatBanner()

    func doCombat(of attacker: AbstractUnit?, against defender: AbstractUnit?)
    func doCombat(of attacker: AbstractUnit?, against defender: AbstractCity?)
    func doRangedCombat(of attacker: AbstractUnit?, against defender: AbstractUnit?)
    func doRangedCombat(of attacker: AbstractCity?, against defender: AbstractUnit?)
    func doRangedCombat(of attacker: AbstractUnit?, against defender: AbstractCity?)

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
    func showGovernorsDialog()
    func showGreatPeopleDialog()
    func showTradeRouteDialog()
    func showReligionDialog()
    func showRankingDialog()
    func showEraProgressDialog()

    func showCityDialog(for city: AbstractCity?)
    func showCityChooseProductionDialog(for city: AbstractCity?)
    func showCityBuildingsDialog(for city: AbstractCity?)
    func showDiplomaticDialog(with otherPlayer: AbstractPlayer?, data: DiplomaticData?, deal: DiplomaticDeal?)

    func showSelectPantheonDialog()
    func showSelectDedicationDialog()

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
    func showSelectionDialog(
        titled title: String,
        items: [SelectableItem],
        completion: @escaping (Int) -> Void
    )
    func showRenameDialog(
        title: String,
        summary: String,
        value: String,
        confirm: String,
        cancel: String,
        completion: @escaping (String) -> Void
    )

    func closeDialog()
    func closePopup()

    func update()

    func closeGame()
}

public protocol CloseGameViewModelDelegate: AnyObject {

    // func showReplay(for game: GameModel?)
    func closeGame()
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

    @Published
    var bottomRightBarViewModel: BottomRightBarViewModel

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
    var governorsDialogViewModel: GovernorsDialogViewModel

    @Published
    var greatPeopleDialogViewModel: GreatPeopleDialogViewModel

    @Published
    var tradeRoutesDialogViewModel: TradeRoutesDialogViewModel

    @Published
    var selectItemsDialogViewModel: SelectItemsDialogViewModel

    @Published
    var nameInputDialogViewModel: NameInputDialogViewModel

    @Published
    var religionDialogViewModel: ReligionDialogViewModel

    @Published
    var rankingDialogViewModel: RankingDialogViewModel

    @Published
    var victoryDialogViewModel: VictoryDialogViewModel

    @Published
    var eraProgressDialogViewModel: EraProgressDialogViewModel

    @Published
    var selectDedicationDialogViewModel: SelectDedicationDialogViewModel

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
        "grid9-progress", "leader-bagde",
        "header-bar-left", "header-bar-right", "city-banner", "grid9-button-district-active",
        "grid9-button-district", "grid9-button-highlighted", "questionmark", "tile-purchase-active",
        "tile-purchase-disabled", "tile-citizen-normal", "tile-citizen-selected", "tile-citizen-forced",
        "tile-districtAvailable", "tile-wonderAvailable", "tile-notAvailable",
        "city-canvas", "pantheon-background", "turns", "unit-banner", "combat-view",
        "unit-strength-background", "unit-strength-frame", "unit-strength-bar", "loyalty",
        "map-overview-canvas", "map-lens", "map-lens-active", "map-marker", "map-options"
    ]

    public weak var delegate: CloseGameViewModelDelegate?

    private var unitType: UnitType = .none
    private var unitLocation: HexPoint = .invalid

    // MARK: constructor

    public init(preloadAssets: Bool = false) {

        // init models
        self.gameSceneViewModel = GameSceneViewModel()
        self.notificationsViewModel = NotificationsViewModel()
        self.headerViewModel = HeaderViewModel()
        self.cityBannerViewModel = CityBannerViewModel()
        self.unitBannerViewModel = UnitBannerViewModel(selectedUnit: nil)
        self.combatBannerViewModel = CombatBannerViewModel()
        self.bottomRightBarViewModel = BottomRightBarViewModel()

        // dialogs
        self.governmentDialogViewModel = GovernmentDialogViewModel()
        self.changeGovernmentDialogViewModel = ChangeGovernmentDialogViewModel()
        self.changePolicyDialogViewModel = ChangePolicyDialogViewModel()
        self.techDialogViewModel = TechDialogViewModel()
        self.civicDialogViewModel = CivicDialogViewModel()
        self.nameInputDialogViewModel = NameInputDialogViewModel()
        self.confirmationDialogViewModel = ConfirmationDialogViewModel()
        self.cityDialogViewModel = CityDialogViewModel()
        self.diplomaticDialogViewModel = DiplomaticDialogViewModel()
        self.selectTradeCityDialogViewModel = SelectTradeCityDialogViewModel()
        self.unitListDialogViewModel = UnitListDialogViewModel()
        self.cityListDialogViewModel = CityListDialogViewModel()
        self.selectPromotionDialogViewModel = SelectPromotionDialogViewModel()
        self.selectPantheonDialogViewModel = SelectPantheonDialogViewModel()
        self.governorsDialogViewModel = GovernorsDialogViewModel()
        self.tradeRoutesDialogViewModel = TradeRoutesDialogViewModel()
        self.greatPeopleDialogViewModel = GreatPeopleDialogViewModel()
        self.selectItemsDialogViewModel = SelectItemsDialogViewModel()
        self.religionDialogViewModel = ReligionDialogViewModel()
        self.rankingDialogViewModel = RankingDialogViewModel()
        self.victoryDialogViewModel = VictoryDialogViewModel()
        self.eraProgressDialogViewModel = EraProgressDialogViewModel()
        self.selectDedicationDialogViewModel = SelectDedicationDialogViewModel()

        // connect models
        self.gameSceneViewModel.delegate = self
        self.notificationsViewModel.delegate = self
        self.headerViewModel.delegate = self
        self.cityBannerViewModel.delegate = self
        self.unitBannerViewModel.delegate = self
        self.combatBannerViewModel.delegate = self
        self.bottomRightBarViewModel.delegate = self

        self.governmentDialogViewModel.delegate = self
        self.changeGovernmentDialogViewModel.delegate = self
        self.changePolicyDialogViewModel.delegate = self
        self.techDialogViewModel.delegate = self
        self.civicDialogViewModel.delegate = self
        self.nameInputDialogViewModel.delegate = self
        self.confirmationDialogViewModel.delegate = self
        self.cityDialogViewModel.delegate = self
        self.diplomaticDialogViewModel.delegate = self
        self.selectTradeCityDialogViewModel.delegate = self
        self.unitListDialogViewModel.delegate = self
        self.cityListDialogViewModel.delegate = self
        self.selectPromotionDialogViewModel.delegate = self
        self.selectPantheonDialogViewModel.delegate = self
        self.governorsDialogViewModel.delegate = self
        self.tradeRoutesDialogViewModel.delegate = self
        self.greatPeopleDialogViewModel.delegate = self
        self.selectItemsDialogViewModel.delegate = self
        self.religionDialogViewModel.delegate = self
        self.rankingDialogViewModel.delegate = self
        self.victoryDialogViewModel.delegate = self
        self.eraProgressDialogViewModel.delegate = self
        self.selectDedicationDialogViewModel.delegate = self

        self.mapOptionShowResourceMarkers = self.gameEnvironment.displayOptions.value.showResourceMarkers
        self.mapOptionShowWater = self.gameEnvironment.displayOptions.value.showWater
        self.mapOptionShowYields = self.gameEnvironment.displayOptions.value.showYields

        self.mapOptionShowHexCoordinates = self.gameEnvironment.displayOptions.value.showHexCoordinates
        self.mapOptionShowCompleteMap = self.gameEnvironment.displayOptions.value.showCompleteMap

        if preloadAssets {
            self.loadAssets()
        }
    }

    // swiftlint:disable cyclomatic_complexity
    public func loadAssets() {

        // load assets into image cache
        print("-- pre-load images --")
        let bundle = Bundle.init(for: Textures.self)
        let textures: Textures = Textures(game: nil)

        print("- load \(textures.allTerrainTextureNames.count) terrain textures")
        for textureName in textures.allTerrainTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.allCoastTextureNames.count) coast textures")
        for textureName in textures.allCoastTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.allRiverTextureNames.count) river textures")
        for textureName in textures.allRiverTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.allFeatureTextureNames.count) feature textures")
        for textureName in textures.allFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.allIceFeatureTextureNames.count) ice textures")
        for textureName in textures.allIceFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.allSnowFeatureTextureNames.count) snow textures")
        for textureName in textures.allSnowFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.allResourceTextureNames.count) resource and marker textures")
        for textureName in textures.allResourceTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }
        for textureName in textures.allResourceMarkerTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.allBorderTextureNames.count) border textures")
        for textureName in textures.allBorderTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.allYieldsTextureNames.count) yield textures")
        for textureName in textures.allYieldsTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.allBoardTextureNames.count) board textures")
        for textureName in textures.allBoardTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.allImprovementTextureNames.count) improvement textures")
        for textureName in textures.allImprovementTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.allRoadTextureNames.count) road textures")
        for textureName in textures.allRoadTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.allPathTextureNames.count) + \(textures.allPathOutTextureNames.count) path textures")
        for textureName in textures.allPathTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }
        for textureName in textures.allPathOutTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.overviewTextureNames.count) overview textures")
        for textureName in textures.overviewTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
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
        for textureName in textures.buttonTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.globeTextureNames.count) globe textures")
        for textureName in textures.globeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.cultureProgressTextureNames.count) culture progress textures")
        for textureName in textures.cultureProgressTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.scienceProgressTextureNames.count) science progress textures")
        for textureName in textures.scienceProgressTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.attackerHealthTextureNames.count) attacker health textures")
        for textureName in textures.attackerHealthTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }
        print("- load \(textures.defenderHealthTextureNames.count) defender health textures")
        for textureName in textures.defenderHealthTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        print("- load \(textures.headerTextureNames.count) header textures")
        for textureName in textures.headerTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.cityProgressTextureNames.count) city progress textures")
        for textureName in textures.cityProgressTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.cityTextureNames.count) city textures")
        for textureName in textures.cityTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.commandTextureNames.count) command type textures")
        for textureName in textures.commandTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.commandButtonTextureNames.count) command button textures")
        for textureName in textures.commandButtonTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.cityCommandButtonTextureNames.count) city command textures")
        for textureName in textures.cityCommandButtonTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.policyCardTextureNames.count) policy card textures")
        for textureName in textures.policyCardTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.governmentStateBackgroundTextureNames.count) government state background textures")
        for textureName in textures.governmentStateBackgroundTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        print("- load \(textures.governmentTextureNames.count) government textures")
        for textureName in textures.governmentTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.governmentAmbientTextureNames.count) ambient textures")
        for textureName in textures.governmentAmbientTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.yieldTextureNames.count) / \(textures.yieldBackgroundTextureNames.count) yield textures")
        for textureName in textures.yieldTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }
        for textureName in textures.yieldBackgroundTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.techTextureNames.count) tech type textures")
        for textureName in textures.techTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.civicTextureNames.count) civic type textures")
        for textureName in textures.civicTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.buildTypeTextureNames.count) build type textures")
        for textureName in textures.buildTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.buildingTypeTextureNames.count) building type textures")
        for textureName in textures.buildingTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.wonderTypeTextureNames.count) wonder type textures")
        for textureName in textures.wonderTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.wonderTextureNames.count) wonder textures")
        for textureName in textures.wonderTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.wonderBuildingTextureNames.count) wonder building textures")
        for textureName in textures.wonderBuildingTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.districtTypeTextureNames.count) district type textures")
        for textureName in textures.districtTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.districtTextureNames.count) district textures")
        for textureName in textures.districtTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.districtBuildingTextureNames.count) district building textures")
        for textureName in textures.districtBuildingTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.leaderTypeTextureNames.count) leader type textures")
        for textureName in textures.leaderTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.civilizationTypeTextureNames.count) civilization type textures")
        for textureName in textures.civilizationTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        print("- load \(textures.pantheonTypeTextureNames.count) pantheon type textures")
        for textureName in textures.pantheonTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.religionTypeTextureNames.count) religion type textures")
        for textureName in textures.religionTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.beliefTypeTextureNames.count) belief type textures")
        for textureName in textures.beliefTypeTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.promotionTextureNames.count) promotion type textures")
        for textureName in textures.promotionTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        print("- load \(textures.promotionStateBackgroundTextureNames.count) promotion state textures")
        for textureName in textures.promotionStateBackgroundTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        print("- load \(textures.governorPortraitTextureNames.count) governor portrait textures")
        for textureName in textures.governorPortraitTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        print("- load \(textures.victoryTypesTextureNames.count) victory textures")
        for textureName in textures.victoryTypesTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        print("- load \(textures.dedicationTypesTextureNames.count) dedication textures")
        for textureName in textures.dedicationTypesTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
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

    func refreshTile(at point: HexPoint) {

        self.bottomRightBarViewModel.refreshTile(at: point)
    }

    func updateRect(at point: HexPoint, size: CGSize) {

        self.bottomRightBarViewModel.updateRect(at: point, size: size)
    }

    func focus(on point: HexPoint) {

        self.gameSceneViewModel.focus(on: point)
    }

    func showUnitBanner() {

        guard !self.unitBannerViewModel.showBanner else {
            return
        }

        self.unitBannerViewModel.showBanner = true
        self.cityBannerViewModel.showBanner = false
        //self.combatBannerViewModel.showBanner = false
    }

    func hideUnitBanner() {

        guard self.unitBannerViewModel.showBanner else {
            return
        }

        self.unitBannerViewModel.showBanner = false
        //self.combatBannerViewModel.showBanner = false
    }

    func select(unit: AbstractUnit?) {

        self.gameSceneViewModel.selectedUnit = unit
    }

    func selectedUnitChanged(to unit: AbstractUnit?, commands: [Command], in gameModel: GameModel?) {

        guard self.unitType != unit?.type || self.unitLocation != unit?.location else {
            return
        }

        self.unitBannerViewModel.selectedUnitChanged(to: unit, commands: commands, in: gameModel)
        self.unitType = unit?.type ?? .none
        self.unitLocation = unit?.location ?? .invalid
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

                if let otherCity = gameModel.city(at: neighbor) {

                    if (!player.isEqual(to: otherCity.player) && diplomacyAI.isAtWar(with: otherCity.player)) ||
                        otherCity.isBarbarian() {

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

                if let otherCity = gameModel.city(at: neighbor) {

                    if (!player.isEqual(to: otherCity.player) && diplomacyAI.isAtWar(with: otherCity.player)) ||
                        otherCity.isBarbarian() {

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

    func doCombat(of attacker: AbstractUnit?, against defender: AbstractCity?) {

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

    func doRangedCombat(of attacker: AbstractUnit?, against defender: AbstractCity?) {

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

    func showCombatBanner(for source: AbstractUnit?, and target: AbstractCity?, ranged: Bool) {

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

        case .ranking:
            self.showRankingDialog()

        case .victory:
            self.showVictoryDialog()

        default:
            print("screen: \(screenType) not handled")
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

    func closeGame() {

        self.delegate?.closeGame()
    }
}

extension GameViewModel: BottomRightBarViewModelDelegate {

    func selected(mapLens: MapLensType) {

        self.gameEnvironment.displayOptions.value.mapLens = mapLens
    }
}
