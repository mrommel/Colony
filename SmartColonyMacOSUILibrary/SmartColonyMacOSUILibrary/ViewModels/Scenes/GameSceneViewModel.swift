//
//  GameSceneViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.05.21.
//

import Cocoa
import SmartAILibrary
import SmartAssets
import SwiftUI

public class GameSceneViewModel: ObservableObject {

    enum GameSceneCombatMode {

        case none
        case melee
        case ranged
    }

    enum GameSceneTurnState {

        case aiTurns // => lock UI
        case humanTurns // => UI enabled
        case humanBlocked // dialog shown
    }

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var game: GameModel? {
        willSet {
            objectWillChange.send()

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

                guard let game = self.game else {
                    return
                }

                guard let humanPlayer = game.humanPlayer() else {
                    return
                }

                self.mapOverviewViewModel.assign(game: game)

                let unitRefs = game.units(of: humanPlayer)

                guard let unitRef = unitRefs.first, let unit = unitRef else {
                    return
                }

                print("center on \(unit.location)")
                self.centerOn = unit.location

                /*
                CGEvent(mouseEventSource: nil, mouseType: CGEventType.leftMouseDown, mouseCursorPosition: CGPoint(x: 100, y: 100), mouseButton: CGMouseButton.left)?.post(tap: CGEventTapLocation.cghidEventTap)
                usleep(100)
                CGEvent(mouseEventSource: nil, mouseType: CGEventType.leftMouseUp, mouseCursorPosition: CGPoint(x: 100, y: 100), mouseButton: CGMouseButton.left)?.post(tap: CGEventTapLocation.cghidEventTap)
                */
            }
        }
    }

    @Published
    var selectedUnit: AbstractUnit? = nil {

        didSet {
            if self.uiTurnState != .humanTurns {
                return
            }

            if let selectedUnit = self.selectedUnit {
                self.delegate?.showUnitBanner()
                // self.buttonViewModel.show(image: selectedUnit.type.iconTexture())
            } else {
                self.delegate?.hideUnitBanner()
            }
        }
    }

    @Published
    var selectedCity: AbstractCity? = nil {

        didSet {
            if let selectedCity = self.selectedCity {
                print("select city: \(selectedCity.name)")
                self.delegate?.showCityBanner(for: selectedCity)
            } else {
                self.delegate?.hideCityBanner()
            }
        }
    }

    @Published
    var sceneCombatMode: GameSceneCombatMode = .none

    @Published
    var turnButtonNotificationType: NotificationType = .unitNeedsOrders {
        didSet {
            if self.uiTurnState != .humanTurns {
                return
            }

            if let unit = self.selectedUnit {

                if unit.movesLeft() == 0 {
                    self.game?.userInterface?.unselect()
                    return
                }

                return
            }

            self.buttonViewModel.show(image: ImageCache.shared.image(for: self.turnButtonNotificationType.iconTexture()))
        }
    }

    var turnButtonNotificationLocation: HexPoint = .zero

    @Published
    var uiTurnState: GameSceneTurnState = .humanTurns

    @Published
    var buttonViewModel: AnimatedImageViewModel

    @Published
    var topBarViewModel: TopBarViewModel

    @Published
    var mapOverviewViewModel: MapOverviewViewModel

    @Published
    var showCommands: Bool = false

    @Published
    var showBanner: Bool = true

    var readyUpdatingAI: Bool = true
    var readyUpdatingHuman: Bool = true
    var refreshCities: Bool = false

    var centerOn: HexPoint?

    var globeImages: [NSImage] = []

    weak var delegate: GameViewModelDelegate?

    public init() {

        self.game = nil

        let buttonImage = NSImage() // ImageCache.shared.image(for: NotificationType.unitNeedsOrders.iconTexture())
        self.buttonViewModel = AnimatedImageViewModel(image: buttonImage)
        self.topBarViewModel = TopBarViewModel()
        self.mapOverviewViewModel = MapOverviewViewModel()

        // connect delegates
        self.topBarViewModel.delegate = self
    }

    public func doTurn() {

        print("do turn: \(self.turnButtonNotificationType)")

        switch self.turnButtonNotificationType {

        case .turn:
            self.handleTurnButtonClicked()
        case .generic:
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        case .techNeeded:
            self.handleTechNeeded()
        case .civicNeeded:
            self.handleCivicNeeded()
        case .productionNeeded:
            self.handleProductionNeeded(at: self.turnButtonNotificationLocation)
        case .canChangeGovernment:
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        case .policiesNeeded:
            self.handlePoliciesNeeded()
        case .canFoundPantheon:
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        case .cityGrowth:
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        case .starving:
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        case .diplomaticDeclaration:
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        case .war:
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        case .enemyInTerritory:
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        case .unitPromotion:
            self.handleUnitPromotion(at: self.turnButtonNotificationLocation)
        case .unitNeedsOrders:
            self.handleFocusOnUnit()
        case .unitDied:
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        case .greatPersonJoined:
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        }
    }

    public func typeTemplateImage() -> NSImage {

        if let selectedUnit = self.selectedUnit {

            guard let civilization = selectedUnit.player?.leader.civilization() else {
                fatalError("cant get civ")
            }

            let image = ImageCache.shared.image(for: selectedUnit.type.typeTemplateTexture())
            image.isTemplate = true

            return image.tint(with: civilization.accent)

        } else {
            return ImageCache.shared.image(for: "unit-type-template-default")
        }
    }

    public func typeBackgroundImage() -> NSImage {

        if let selectedUnit = self.selectedUnit {

            guard let civilization = selectedUnit.player?.leader.civilization() else {
                fatalError("cant get civ")
            }

            return NSImage(color: civilization.main, size: NSSize(width: 16, height: 16))

        } else {
            return NSImage(color: .black, size: NSSize(width: 16, height: 16))
        }
    }

    func changeUITurnState(to state: GameSceneTurnState) {

        /*guard let gameModel = self.game else {
            fatalError("cant get game")
        }*/

        switch state {

        case .aiTurns:
            // show AI is working banner
            self.showBanner = true

            // show AI turn
            self.showSpinningGlobe()

        case .humanTurns:

            // dirty hacks
            self.refreshCities = true

            // hide AI is working banner
            self.showBanner = false

            // update nodes
            self.topBarViewModel.update()

            // update
            //self.updateLeaders()

            // update state
            self.updateTurnButton()

        case .humanBlocked:
            // NOOP

            // self.view?.preferredFramesPerSecond = 60

            break
        }

        self.uiTurnState = state
    }

    func showTurnButton() {

        self.turnButtonNotificationType = .turn
        self.turnButtonNotificationLocation = HexPoint.invalid
    }

    func showBlockingButton(for blockingNotification: NotificationItem) {

        self.turnButtonNotificationType = blockingNotification.type
        self.turnButtonNotificationLocation = blockingNotification.location
    }

    func showSpinningGlobe() {

        if self.globeImages.isEmpty {
            self.globeImages = Array(0...90).map { "globe\($0)" }.map { globeTextureName in

                return ImageCache.shared.image(for: globeTextureName)
            }
        }

        self.buttonViewModel.playAnimation(images: self.globeImages, interval: 0.07)
    }

    func hideSpinningGlobe() {

    }

    func updateTurnButton() {

        self.hideSpinningGlobe()

        self.game?.updateTestEndTurn() // -> this will update blockingNotification()

        guard let gameModel = self.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if let delegate = self.delegate {
            if delegate.checkPopups() {
                return
            }
        }

        if let blockingNotification = humanPlayer.blockingNotification() {

            if let unit = self.selectedUnit {
                self.game?.userInterface?.select(unit: unit)
            } else {
                // no unit selected - show blocking button
                self.showBlockingButton(for: blockingNotification)
            }
        } else {
            self.showTurnButton()
        }
    }

    // MARK: header view models

    func scienceHeaderViewModel() -> HeaderButtonViewModel {

        let viewModel = HeaderButtonViewModel(type: .science)
        viewModel.delegate = self

        return viewModel
    }

    func cultureHeaderViewModel() -> HeaderButtonViewModel {

        let viewModel = HeaderButtonViewModel(type: .culture)
        viewModel.delegate = self

        return viewModel
    }

    func governmentHeaderViewModel() -> HeaderButtonViewModel {

        let viewModel = HeaderButtonViewModel(type: .government)
        viewModel.delegate = self

        return viewModel
    }

    func logHeaderViewModel() -> HeaderButtonViewModel {

        let viewModel = HeaderButtonViewModel(type: .log)
        viewModel.delegate = self

        return viewModel
    }

    func rankingHeaderViewModel() -> HeaderButtonViewModel {

        let viewModel = HeaderButtonViewModel(type: .ranking)
        viewModel.delegate = self

        return viewModel
    }

    func tradeRoutesHeaderViewModel() -> HeaderButtonViewModel {

        let viewModel = HeaderButtonViewModel(type: .tradeRoutes)
        viewModel.delegate = self

        return viewModel
    }

    func techProgressViewModel() -> TechProgressViewModel {

        guard let gameModel = self.game else {
            return TechProgressViewModel(techType: .none, progress: 0, boosted: false)
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if let techs = humanPlayer.techs {
            if let currentTech = techs.currentTech() {
                let progressPercentage = techs.currentScienceProgress() / Double(currentTech.cost()) * 100.0
                return TechProgressViewModel(techType: currentTech, progress: Int(progressPercentage), boosted: false)
            }
        }

        return TechProgressViewModel(techType: .none, progress: 0, boosted: false)
    }

    func civicProgressViewModel() -> CivicProgressViewModel {

        guard let gameModel = self.game else {
            return CivicProgressViewModel(civicType: .none, progress: 0, boosted: false)
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if let civics = humanPlayer.civics {
            if let currentCivic = civics.currentCivic() {
                let progressPercentage = civics.currentCultureProgress() / Double(currentCivic.cost()) * 100.0
                return CivicProgressViewModel(civicType: currentCivic, progress: Int(progressPercentage), boosted: false)
            }
        }

        return CivicProgressViewModel(civicType: .none, progress: 0, boosted: false)
    }

    // MARK: callbacks

    func foundCity(named cityName: String) {

        if let selectedUnit = self.selectedUnit {
            let location = selectedUnit.location
            selectedUnit.doFound(with: cityName, in: self.game)
            self.game?.userInterface?.unselect()

            if let city = self.game?.city(at: location) {
                self.game?.userInterface?.showScreen(screenType: .city, city: city, other: nil, data: nil)
            }
        }
    }
}

extension GameSceneViewModel {

    func handleTurnButtonClicked() {

        print("---- turn pressed ------")

        guard let gameModel = self.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if self.uiTurnState == .humanTurns {

            if humanPlayer.canFinishTurn() {

                humanPlayer.endTurn(in: gameModel)
                self.changeUITurnState(to: .aiTurns)
            } else {
                print("cant finish turn")
                /*if let blockingNotification = humanPlayer.blockingNotification() {
                    blockingNotification.activate(in: gameModel)
                }*/
            }
        }
    }

    func handleFocusOnUnit() {

        if let unit = self.selectedUnit {
            print("click on unit icon - \(unit.type)")

            if !unit.readyToSelect() {
                self.game?.userInterface?.unselect()
                return
            }

            self.delegate?.focus(on: unit.location)
        } else {

            guard let gameModel = self.game else {
                fatalError("cant get game")
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human")
            }

            let units = gameModel.units(of: humanPlayer)

            for unitRef in units {

                if let unit = unitRef {
                    if unit.movesLeft() > 0 {
                        self.game?.userInterface?.select(unit: unit)
                        self.delegate?.focus(on: unit.location)
                        //self.centerCamera(on: unit.location)
                        return
                    }
                }
            }
        }
    }

    func handleTechNeeded() {

        self.delegate?.showChangeTechDialog()
    }

    func handleCivicNeeded() {

        self.delegate?.showChangeCivicDialog()
    }

    func handleProductionNeeded(at location: HexPoint) {

        guard let gameModel = self.game else {
            fatalError("cant get game")
        }

        guard let city = gameModel.city(at: location) else {
            fatalError("cant get city at \(location)")
        }

        self.delegate?.showCityDialog(for: city)
    }

    func handlePoliciesNeeded() {

        self.delegate?.showChangePoliciesDialog()
    }

    func handleUnitPromotion(at point: HexPoint) {
        fatalError("handleUnitPromotion")
    }
}

extension GameSceneViewModel: HeaderButtonViewModelDelegate {

    func clicked(on type: HeaderButtonType) {

        switch type {

        case .science:
            self.delegate?.showChangeTechDialog()
        case .culture:
            self.delegate?.showChangeCivicDialog()
        case .government:
            self.delegate?.showGovernmentDialog()
        case .log:
            print("log")
        case .ranking:
            print("ranking")
            // self.delegate?.showRankingDialog()
        case .tradeRoutes:
            self.delegate?.showTradeRouteDialog()
        }
    }
}

extension GameSceneViewModel: TopBarViewModelDelegate {

    func treasuryClicked() {

        self.delegate?.showTreasuryDialog()
    }
}
