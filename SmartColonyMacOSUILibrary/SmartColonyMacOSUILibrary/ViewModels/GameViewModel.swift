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

@propertyWrapper
public struct UserDefaultStorage<T: Codable> {

    private let key: String
    private let defaultValue: T

    private let userDefaults: UserDefaults

    public init(key: String, default: T, store: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = `default`
        self.userDefaults = store
    }

    public var wrappedValue: T {
        get {
            guard let data = userDefaults.data(forKey: key) else {
                return defaultValue
            }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: key)
        }
    }
}

protocol GameViewModelDelegate: AnyObject {

    func update(gameState: GameStateType)
    func updateTurnProgress(current: Int, maximum: Int)

    var selectedCity: AbstractCity? { get set }
    var selectedUnit: AbstractUnit? { get set }

    func changeUITurnState(to state: GameSceneTurnState)
    func updateStates()

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

    func showCityBanner()
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
    func showMomentsDialog()
    func showCityStateDialog()

    func showCityDialog(for city: AbstractCity?)
    func showCityChooseProductionDialog(for city: AbstractCity?)
    func showCityAquireTilesDialog(for city: AbstractCity?)
    func showCityPurchaseGoldDialog(for city: AbstractCity?)
    func showCityPurchaseFaithDialog(for city: AbstractCity?)
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
        cancel: String?,
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

    func closeGame()
    func closeGameAndShowTutorials()

    func selectMarker(at location: HexPoint)
}

public protocol CloseGameViewModelDelegate: AnyObject {

    // func showReplay(for game: GameModel?)
    func closeGame()

    func closeAndRestartGame()
    func closeGameAndLoad()
    func closeGameAndShowTutorials()
}

// swiftlint:disable type_body_length
public class GameViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var magnification: CGFloat = 0.5

    @Published
    public var gameSceneViewModel: GameSceneViewModel

    @Published
    var notificationsViewModel: NotificationsViewModel

    @Published
    var cityBannerViewModel: CityBannerViewModel

    @Published
    var unitBannerViewModel: UnitBannerViewModel

    @Published
    var combatBannerViewModel: CombatBannerViewModel

    @Published
    var topBarViewModel: TopBarViewModel

    @Published
    var headerViewModel: HeaderViewModel

    @Published
    var bannerViewModel: BannerViewModel

    @Published
    var bottomLeftBarViewModel: BottomLeftBarViewModel

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
    var cityStateDialogViewModel: CityStateDialogViewModel

    @Published
    var razeOrReturnCityDialogViewModel: RazeOrReturnCityDialogViewModel

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

    @Published
    var momentsDialogViewModel: MomentsDialogViewModel

    @Published
    var cityStatesDialogViewModel: CityStatesDialogViewModel

    // popups

    @Published
    var goodyHutRewardPopupViewModel: GoodyHutRewardPopupViewModel

    @Published
    var techDiscoveredPopupViewModel: TechDiscoveredPopupViewModel

    @Published
    var civicDiscoveredPopupViewModel: CivicDiscoveredPopupViewModel

    @Published
    var eraEnteredPopupViewModel: EraEnteredPopupViewModel

    @Published
    var eurekaTechActivatedPopupViewModel: EurekaTechActivatedPopupViewModel

    @Published
    var inspirationTriggeredPopupViewModel: InspirationTriggeredPopupViewModel

    @Published
    var wonderBuiltPopupViewModel: WonderBuiltPopupViewModel

    @Published
    var canFoundPantheonPopupViewModel: CanFoundPantheonPopupViewModel

    @Published
    var genericPopupViewModel: GenericPopupViewModel

    // UI

    @Published
    var gameMenuVisible: Bool = false

    @Published
    var gameMenuViewModel: GameMenuViewModel

    @Published
    var uiTurnState: GameSceneTurnState = .aiTurns

    @Published
    var currentScreenType: ScreenType = .none

    @Published
    var currentPopupType: PopupType = .none

    // main data

    var popups: [PopupType] = []

    var uiCombatMode: UICombatMode = .none

    @Published
    var selectedUnit: AbstractUnit? {

        didSet {
            if self.uiTurnState != .humanTurns {
                return
            }

            if let unit = self.selectedUnit {
                self.showUnitBanner()
                self.bottomLeftBarViewModel.selectedUnitCivilization = unit.player?.leader.civilization() ?? .unmet
                self.bottomLeftBarViewModel.selectedUnitType = unit.type
                self.bottomLeftBarViewModel.selectedUnitLocation = unit.location
            } else {
                self.hideUnitBanner()
                self.bottomLeftBarViewModel.selectedUnitCivilization = nil
                self.bottomLeftBarViewModel.selectedUnitType = nil
                self.bottomLeftBarViewModel.selectedUnitLocation = nil
            }
        }
    }

    @Published
    var selectedCity: AbstractCity? {

        didSet {
            if let selectedCity = self.selectedCity {
                print("select city: \(selectedCity.name)")
                self.showCityBanner()
            } else {
                self.hideCityBanner()
            }
        }
    }

    // MARK: map display options

    @Published
    public var mapOptionShowGrid: Bool = false {
        didSet {
            self.gameEnvironment.changeShowGrid(to: self.mapOptionShowGrid)
        }
    }

    @Published
    public var mapOptionShowResourceMarkers: Bool = false {
        didSet {
            self.gameEnvironment.changeShowResourceMarkers(to: self.mapOptionShowResourceMarkers)
        }
    }

    @Published
    public var mapOptionShowYields: Bool = false {
        didSet {
            self.gameEnvironment.changeShowYieldsMarkers(to: self.mapOptionShowYields)
        }
    }

    // debug

    @Published
    public var mapOptionShowHexCoordinates: Bool = false {
        didSet {
            self.gameEnvironment.changeShowHexCoords(to: self.mapOptionShowHexCoordinates)
        }
    }

    @Published
    public var mapOptionShowCompleteMap: Bool = false {
        didSet {
            self.gameEnvironment.changeShowCompleteMap(to: self.mapOptionShowCompleteMap)
        }
    }

    public weak var delegate: CloseGameViewModelDelegate?

    // MARK: constructor

    public init(preloadAssets: Bool = false) {

        // init models
        self.gameSceneViewModel = GameSceneViewModel()
        self.notificationsViewModel = NotificationsViewModel()
        self.cityBannerViewModel = CityBannerViewModel()
        self.unitBannerViewModel = UnitBannerViewModel(selectedUnit: nil)
        self.combatBannerViewModel = CombatBannerViewModel()
        self.topBarViewModel = TopBarViewModel()
        self.headerViewModel = HeaderViewModel()
        self.bannerViewModel = BannerViewModel()
        self.bottomLeftBarViewModel = BottomLeftBarViewModel()
        self.bottomRightBarViewModel = BottomRightBarViewModel()
        self.gameMenuViewModel = GameMenuViewModel()

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
        self.momentsDialogViewModel = MomentsDialogViewModel()
        self.cityStatesDialogViewModel = CityStatesDialogViewModel()
        self.cityStateDialogViewModel = CityStateDialogViewModel()
        self.razeOrReturnCityDialogViewModel = RazeOrReturnCityDialogViewModel()

        // popups
        self.goodyHutRewardPopupViewModel = GoodyHutRewardPopupViewModel()
        self.techDiscoveredPopupViewModel = TechDiscoveredPopupViewModel()
        self.civicDiscoveredPopupViewModel = CivicDiscoveredPopupViewModel()
        self.eraEnteredPopupViewModel = EraEnteredPopupViewModel()
        self.eurekaTechActivatedPopupViewModel = EurekaTechActivatedPopupViewModel()
        self.inspirationTriggeredPopupViewModel = InspirationTriggeredPopupViewModel()
        self.wonderBuiltPopupViewModel = WonderBuiltPopupViewModel()
        self.canFoundPantheonPopupViewModel = CanFoundPantheonPopupViewModel()
        self.genericPopupViewModel = GenericPopupViewModel()

        // connect models
        self.gameSceneViewModel.delegate = self
        self.notificationsViewModel.delegate = self
        self.cityBannerViewModel.delegate = self
        self.unitBannerViewModel.delegate = self
        self.combatBannerViewModel.delegate = self

        self.topBarViewModel.delegate = self
        self.headerViewModel.delegate = self
        self.bottomLeftBarViewModel.delegate = self
        self.bottomRightBarViewModel.delegate = self
        self.gameMenuViewModel.delegate = self

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
        self.momentsDialogViewModel.delegate = self
        self.cityStatesDialogViewModel.delegate = self
        self.cityStateDialogViewModel.delegate = self
        self.razeOrReturnCityDialogViewModel.delegate = self

        self.goodyHutRewardPopupViewModel.delegate = self
        self.techDiscoveredPopupViewModel.delegate = self
        self.civicDiscoveredPopupViewModel.delegate = self
        self.eraEnteredPopupViewModel.delegate = self
        self.eurekaTechActivatedPopupViewModel.delegate = self
        self.inspirationTriggeredPopupViewModel.delegate = self
        self.wonderBuiltPopupViewModel.delegate = self
        self.canFoundPantheonPopupViewModel.delegate = self
        self.genericPopupViewModel.delegate = self

        self.mapOptionShowGrid = self.gameEnvironment.displayOptions.value.showGrid
        self.mapOptionShowResourceMarkers = self.gameEnvironment.displayOptions.value.showResourceMarkers
        self.mapOptionShowYields = self.gameEnvironment.displayOptions.value.showYields

        self.mapOptionShowHexCoordinates = self.gameEnvironment.displayOptions.value.showHexCoordinates
        self.mapOptionShowCompleteMap = self.gameEnvironment.displayOptions.value.showCompleteMap

        if preloadAssets {
            self.loadAssets()
        }

        self.bannerViewModel.showBanner()
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

            // print("show popup: \(firstPopup)")

            switch firstPopup {

            case .techDiscovered(let techType):
                self.techDiscoveredPopupViewModel.update(for: techType)

            case .civicDiscovered(let civicType):
                self.civicDiscoveredPopupViewModel.update(for: civicType)

            case .eraEntered(let eraType):
                self.eraEnteredPopupViewModel.update(for: eraType)

            case .eurekaTriggered(let techType):
                self.eurekaTechActivatedPopupViewModel.update(for: techType)

            case .inspirationTriggered(let civicType):
                self.inspirationTriggeredPopupViewModel.update(for: civicType)

            case .goodyHutReward(let goodyType, let location):
                self.goodyHutRewardPopupViewModel.update(for: goodyType, at: location)

            case .wonderBuilt(let wonderType):
                self.wonderBuiltPopupViewModel.update(for: wonderType)

            case .cityRevolted(city: let cityRef):

                guard let city = cityRef else {
                    fatalError("no city provided")
                }

                let title = "TXT_KEY_POPUP_CITY_BECAME_FREE_CITY_TITLE".localized()
                let summary = "TXT_KEY_POPUP_CITY_BECAME_FREE_CITY_SUMMARY".localizedWithFormat(with: [city.name.localized()])
                self.genericPopupViewModel.update(with: title, and: summary)

            case .foreignCityRevolted(city: let cityRef):

                guard let city = cityRef else {
                    fatalError("no city provided")
                }

                let civName = city.previousLeader().civilization().name().localized()
                let cityName = city.name.localized()

                let title = "TXT_KEY_POPUP_FOREIGN_CITY_BECAME_FREE_CITY_TITLE".localized()
                let summary = "TXT_KEY_POPUP_FOREIGN_CITY_BECAME_FREE_CITY_SUMMARY".localizedWithFormat(with: [civName, cityName])
                self.genericPopupViewModel.update(with: title, and: summary)

            case .lostOwnCapital:
                let title = "TXT_KEY_POPUP_YOU_LOST_CAPITAL_TITLE".localized()
                let summary = "TXT_KEY_POPUP_YOU_LOST_CAPITAL_SUMMARY".localized()
                self.genericPopupViewModel.update(with: title, and: summary)

            case .lostCapital(leader: let leader):
                let title = "TXT_KEY_POPUP_OTHER_LOST_CAPITAL_TITLE".localized()
                let summary = "TXT_KEY_POPUP_OTHER_LOST_CAPITAL_SUMMARY".localizedWithFormat(with: [leader.name().localized()])
                self.genericPopupViewModel.update(with: title, and: summary)

            case .questFulfilled(cityState: let cityState, quest: let quest):
                let title = "TXT_KEY_POPUP_QUEST_FULFILLED_TITLE".localized()
                let summary = "TXT_KEY_POPUP_QUEST_FULFILLED_SUMMARY"
                    .localizedWithFormat(with: [quest.summary().localized(), cityState.name().localized()])
                self.genericPopupViewModel.update(with: title, and: summary)

            case .tutorialStart(tutorial: let tutorial):

                switch tutorial {

                case .none:
                    // NOOP
                    break

                case .movementAndExploration:
                    let title = "TXT_KEY_TUTORIAL_MOVEMENT_EXPLORATION_TITLE".localized()
                    let summary = "TXT_KEY_TUTORIAL_MOVEMENT_EXPLORATION_BODY".localized()
                    self.genericPopupViewModel.update(with: title, and: summary)

                case .foundFirstCity:
                    let title = "TXT_KEY_TUTORIAL_FOUND_FIRST_CITY_TITLE".localized()
                    let summary = "TXT_KEY_TUTORIAL_FOUND_FIRST_CITY_BODY".localized()
                    self.genericPopupViewModel.update(with: title, and: summary)

                case .improvingCity:
                    let title = "TXT_KEY_TUTORIAL_IMPROVING_CITY_TITLE".localized()
                    let summary = "TXT_KEY_TUTORIAL_IMPROVING_CITY_BODY".localized()
                    self.genericPopupViewModel.update(with: title, and: summary)

                case .establishTradeRoute:
                    let title = "TXT_KEY_TUTORIAL_ESTABLISH_TRADE_ROUTE_TITLE".localized()
                    let summary = "TXT_KEY_TUTORIAL_ESTABLISH_TRADE_ROUTE_BODY".localized()
                    self.genericPopupViewModel.update(with: title, and: summary)

                case .combatAndConquest:
                    let title = "TXT_KEY_TUTORIAL_COMBAT_CONQUEST_TITLE".localized()
                    let summary = "TXT_KEY_TUTORIAL_COMBAT_CONQUEST_BODY".localized()
                    self.genericPopupViewModel.update(with: title, and: summary)

                case .basicDiplomacy:
                    let title = "TXT_KEY_TUTORIAL_BASIC_DIPLOMACY_TITLE".localized()
                    let summary = "TXT_KEY_TUTORIAL_BASIC_DIPLOMACY_BODY".localized()
                    self.genericPopupViewModel.update(with: title, and: summary)
                }

            case .tutorialCityAttack(attacker: _, city: _):
                let title = "TXT_KEY_ADVISOR_CITY_ATTACK_DISPLAY".localized()
                let summary = "TXT_KEY_ADVISOR_CITY_ATTACK_BODY".localized()
                self.genericPopupViewModel.update(with: title, and: summary)

            case .tutorialBadUnitAttack(attacker: _, defender: _):
                let title = "TXT_KEY_ADVISOR_BAD_ATTACK_DISPLAY".localized()
                let summary = "TXT_KEY_ADVISOR_BAD_ATTACK_BODY".localized()
                self.genericPopupViewModel.update(with: title, and: summary)

            default:
                fatalError("not handled: \(firstPopup)")
            }

            self.currentPopupType = firstPopup

            self.popups.removeFirst()
            return
        }
    }

    func showGameMenu() {

        self.gameMenuVisible = true
    }

    func saveGame(as filename: String) {

        guard let gameModel = self.gameEnvironment.game.value else {
            print("cant save game: game not set")
            return
        }

        do {
            let applicationSupport = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )

            let bundleID = "SmartColonyMacOS"
            var appSupportSubDirectory = applicationSupport.appendingPathComponent(bundleID, isDirectory: true)

            var isDirectory: ObjCBool = true
            if !FileManager.default.fileExists(atPath: appSupportSubDirectory.path, isDirectory: &isDirectory) {
                try FileManager.default.createDirectory(at: appSupportSubDirectory, withIntermediateDirectories: true, attributes: nil)
            }

            appSupportSubDirectory.appendPathComponent(filename)

            let writer = GameWriter()
            guard writer.write(game: gameModel, to: appSupportSubDirectory) else {
                print("could not store tmp game")
                return
            }
        } catch {
            print("cant store file: \(error)")
            return
        }
    }
}

extension GameViewModel: GameMenuViewModelDelegate {

    func handle(action: GameMenuAction) {

        switch action {

        case .backToGame:
            self.gameMenuVisible = false

        case .restartGame:
            self.gameMenuVisible = false
            self.delegate?.closeAndRestartGame()

        case .quickSaveGame:
            guard let gameModel = self.gameEnvironment.game.value else {
                print("cant save game: game not set")
                self.gameMenuVisible = false
                return
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                print("cant human player")
                self.gameMenuVisible = false
                return
            }

            let filename = "\(humanPlayer.leader.name().localized()) \(gameModel.turnYear()).clny"

            self.saveGame(as: filename)
            self.gameMenuVisible = false

        case .saveGame:
            // will not be called
            break

        case .loadGame:
            self.gameMenuVisible = false
            self.delegate?.closeGameAndLoad()

        case .gameOptions:
            print("game options not implemented yet")
            self.gameMenuVisible = false

        case .retireGame:
            print("retire game not implemented yet")
            self.gameMenuVisible = false

        case .backToMainMenu:
            self.gameMenuVisible = false
            self.delegate?.closeGame()
        }
    }
}

extension GameViewModel: GameViewModelDelegate {

    func update(gameState: GameStateType) {

        if gameState == .over {
            // switch to human turn - to show victory screen
            self.changeUITurnState(to: .humanTurns)
        }
    }

    func updateTurnProgress(current: Int, maximum: Int) {

        self.bannerViewModel.updateBanner(current: current, maximum: maximum)
    }

    func refreshTile(at point: HexPoint) {

        self.bottomRightBarViewModel.refreshTile(at: point)
    }

    func updateRect(at point: HexPoint, size: CGSize) {

        self.bottomRightBarViewModel.updateRect(at: point, size: size)
    }

    func focus(on point: HexPoint) {

        self.gameSceneViewModel.focus(on: point)
    }

    func changeUITurnState(to state: GameSceneTurnState) {

        guard state != self.uiTurnState else {
            return
        }

        switch state {

        case .aiTurns:
            // show AI is working banner
            self.bannerViewModel.showBanner()

            // show AI turn
            self.bottomLeftBarViewModel.showSpinningGlobe()

            // write backup to file
            guard let gameModel = self.gameEnvironment.game.value else {
                print("cant get game")
                return
            }

            if self.uiTurnState == .humanTurns {
                let directory = NSTemporaryDirectory()
                let fileName = "current.clny"

                // This returns a URL? even though it is an NSURL class method
                guard let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName]) else {
                    fatalError("could not store tmp game url")
                }

                let writer = GameWriter()
                guard writer.write(game: gameModel, to: fullURL) else {
                    fatalError("could not store tmp game")
                }

                print("store turn backup: \(fullURL)")
            }

        case .humanTurns:

            // dirty hacks
            self.gameSceneViewModel.refreshCities = true

            // hide AI is working banner
            self.bannerViewModel.hideBanner()

        case .humanBlocked:
            // NOOP

            // self.view?.preferredFramesPerSecond = 60

            break
        }

        self.uiTurnState = state
    }

    func updateStates() {

        if self.uiTurnState == .humanTurns {

            // update main button
            self.bottomLeftBarViewModel.updateTurnButton()

            // update nodes
            self.topBarViewModel.update()
            self.headerViewModel.update()

            // update
            // self.updateLeaders()
        }
    }

    func showUnitBanner() {

        guard !self.unitBannerViewModel.showBanner else {
            return
        }

        self.unitBannerViewModel.showBanner = true
        self.cityBannerViewModel.showBanner = false
        // self.combatBannerViewModel.showBanner = false
    }

    func hideUnitBanner() {

        guard self.unitBannerViewModel.showBanner else {
            return
        }

        self.unitBannerViewModel.showBanner = false
        // self.combatBannerViewModel.showBanner = false
    }

    func select(unit: AbstractUnit?) {

        self.selectedUnit = unit
    }

    func selectedUnitChanged(to unit: AbstractUnit?, commands: [Command], in gameModel: GameModel?) {

        self.selectedUnit = unit
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

        guard let attackerPlayer = attacker?.player else {
            fatalError("cant get attacker player")
        }

        guard let defenderPlayer = defender?.player else {
            fatalError("cant get defender player")
        }

        if attackerPlayer.isHuman() {

            if let defenderUnit = defender {

                guard !defenderUnit.isHuman() else {
                    return
                }

                if !attackerPlayer.isAtWar(with: defenderPlayer) && !defenderPlayer.isBarbarian() {

                    let defenderPlayerName = defenderPlayer.leader.name().localized()

                    gameModel.userInterface?.askForConfirmation(
                        title: "TXT_KEY_DECLARE_WAR_TITLE".localized(),
                        question: "TXT_KEY_DECLARE_WAR_QUESTION".localizedWithFormat(with: [defenderPlayerName]),
                        confirm: "TXT_KEY_DECLARE_WAR_TEXT".localized(),
                        cancel: "TXT_KEY_CANCEL".localized(),
                        completion: { confirmed in
                            if confirmed {
                                attackerPlayer.doDeclareWar(to: defenderPlayer, in: gameModel)
                            }
                        })

                    return
                }
            }
        }

        if !attacker!.doAttack(into: defender!.location, steps: 1, in: gameModel) {
            print("attack failed")
        }
    }

    func doCombat(of attacker: AbstractUnit?, against defender: AbstractCity?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let attackerPlayer = attacker?.player else {
            fatalError("cant get attacker player")
        }

        guard let defenderPlayer = defender?.player else {
            fatalError("cant get defender player")
        }

        guard let attackerDiplomacyAI = attackerPlayer.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        if attackerPlayer.isHuman() {

            if let defenderUnit = defender {

                guard !defenderUnit.isHuman() else {
                    return
                }

                if !attackerPlayer.isAtWar(with: defenderPlayer) && !defenderPlayer.isBarbarian() {

                    let defenderPlayerName = defenderPlayer.leader.name().localized()

                    gameModel.userInterface?.askForConfirmation(
                        title: "Declare War?",
                        question: "Do you really want to declare war on \(defenderPlayerName)?",
                        confirm: "Declare War",
                        cancel: "Cancel",
                        completion: { confirmed in
                            if confirmed {
                                attackerPlayer.doDeclareWar(to: defenderPlayer, in: gameModel)
                            }
                        })

                    return
                }
            }
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

    func showCityBanner() {

        self.cityBannerViewModel.update(for: self.selectedCity)
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

        case .cityState:
            self.showCityStateDialog(for: city)

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

        case .cityStates:
            self.showCityStateDialog()

        case .razeOrReturnCity:
            self.showRazeOrReturnCity(for: city)

        case .moments:
            self.showMomentsDialog()

        default:
            print("screen: \(screenType) not handled")
        }
    }

    func checkPopups() -> Bool {

        if self.currentScreenType == .none {

            // print("-- checkPopups \(self.popups.count) / \(self.currentPopupType) --")
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
        self.topBarViewModel.update()
        self.headerViewModel.update()
        self.governmentDialogViewModel.update()

        self.currentScreenType = .none
    }

    func closeGame() {

        self.delegate?.closeGame()
    }

    func closeGameAndShowTutorials() {

        self.delegate?.closeGameAndShowTutorials()
    }

    func selectMarker(at location: HexPoint) {

        self.bottomRightBarViewModel.mapOverviewViewModel.selectMarker(at: location)
    }
}

extension GameViewModel: TopBarViewModelDelegate {

    func tradeRoutesClicked() {

        self.showTradeRouteDialog()
    }

    func envoysClicked() {

        self.showCityStateDialog()
    }

    func menuButtonClicked() {

        self.showGameMenu()
    }
}

extension GameViewModel: BottomRightBarViewModelDelegate {

    func selected(mapLens: MapLensType) {

        self.gameEnvironment.displayOptions.value.mapLens = mapLens
    }

    func enableMarkerMode() {

        self.gameSceneViewModel.unitSelectionMode = .marker
    }

    func cancelMarkerMode() {

        self.gameSceneViewModel.unitSelectionMode = .pick
    }
}

extension GameViewModel: BottomLeftBarViewModelDelegate {

    func areAnimationsRunning() -> Bool {

        return self.gameSceneViewModel.animationsAreRunning
    }

    func handleMainButtonClicked() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        guard gameModel.gameState() == .on else {
            return
        }

        let turnButtonNotificationType = humanPlayer.blockingNotification()?.type ?? .turn
        print("do turn: \(turnButtonNotificationType)")

        switch turnButtonNotificationType {

        case .turn:
            self.handleTurnButtonClicked()
        case .techNeeded:
            self.showTechListDialog()
        case .civicNeeded:
            self.showCivicListDialog()
        case .productionNeeded(cityName: _, location: let location):
            self.handleProductionNeeded(at: location)
        case .policiesNeeded:
            self.showChangePoliciesDialog()
        case .unitPromotion(location: let location):
            self.handleUnitPromotion(at: location)
        case .unitNeedsOrders(location: let location):
            self.handleFocusOnUnit(at: location)
        default:
            print("--- unhandled notification type: \(turnButtonNotificationType)")
        }
    }

    func handleTurnButtonClicked() {

        print("---- turn pressed ------")

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if self.uiTurnState == .humanTurns {

            if humanPlayer.isTurnActive() {
                humanPlayer.finishTurn()
                humanPlayer.setAutoMoves(to: true)
            }
        }
    }

    func handleFocusOnUnit(at location: HexPoint) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if let unit = self.selectedUnit {
            print("click on unit icon - \(unit.type) at \(location)")

            if unit.location != location {
                gameModel.userInterface?.unselect()

                if let unit = humanPlayer.firstReadyUnit(in: gameModel) {

                    self.selectedUnit = unit
                    gameModel.userInterface?.select(unit: unit)
                }
            }

            if !unit.readyToSelect() {
                gameModel.userInterface?.unselect()
                return
            }

            self.focus(on: unit.location)
        } else {

            if let unit = humanPlayer.firstReadyUnit(in: gameModel) {

                gameModel.userInterface?.select(unit: unit)
                self.focus(on: unit.location)
                return
            }
        }
    }

    func handleProductionNeeded(at location: HexPoint) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let city = gameModel.city(at: location) else {
            fatalError("cant get city at \(location)")
        }

        self.showCityDialog(for: city)
    }

    func handleUnitPromotion(at point: HexPoint) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let unit = gameModel.unit(at: point, of: .combat) else {
            fatalError("cant get unit at \(point)")
        }

        self.showSelectPromotionDialog(for: unit)
    }
}
