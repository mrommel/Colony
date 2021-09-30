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

    enum UnitSelectionMode {

        case pick
        case meleeUnitTargets
        case rangedUnitTargets
        case rangedCityTargets
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

            if self.selectedUnit != nil {
                self.delegate?.showUnitBanner()
                // self.buttonViewModel.show(image: selectedUnit.type.iconTexture())
            } else {
                self.delegate?.hideUnitBanner()
            }
        }
    }

    @Published
    var combatTarget: AbstractUnit?

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
    var unitSelectionMode: UnitSelectionMode = .pick

    @Published
    var turnButtonNotificationType: NotificationType = .generic {
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

    // var turnButtonNotificationLocation: HexPoint = .zero

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
        case .productionNeeded(cityName: _, location: let location):
            self.handleProductionNeeded(at: location)
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
        case .unitPromotion(location: let location):
            self.handleUnitPromotion(at: location)
        case .unitNeedsOrders:
            self.handleFocusOnUnit()
        case .unitDied:
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        case .greatPersonJoined:
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        case .governorTitleAvailable:
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
            self.delegate?.update()

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
    }

    func showBlockingButton(for blockingNotification: NotificationItem) {

        self.turnButtonNotificationType = blockingNotification.type
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
                if self.unitSelectionMode == .pick {
                    self.game?.userInterface?.select(unit: unit)
                }
            } else {
                // no unit selected - show blocking button
                self.showBlockingButton(for: blockingNotification)
            }
        } else {
            self.showTurnButton()
        }
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

            humanPlayer.finishTurn()
            humanPlayer.setAutoMoves(to: true)

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

        self.delegate?.showTechListDialog()
    }

    func handleCivicNeeded() {

        self.delegate?.showCivicListDialog()
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

        guard let gameModel = self.game else {
            fatalError("cant get game")
        }

        guard let unit = gameModel.unit(at: point, of: .combat) else {
            fatalError("cant get unit at \(point)")
        }

        self.delegate?.showSelectPromotionDialog(for: unit)
    }
}

extension GameSceneViewModel: TopBarViewModelDelegate {

    func treasuryClicked() {

        self.delegate?.showTreasuryDialog()
    }
}
