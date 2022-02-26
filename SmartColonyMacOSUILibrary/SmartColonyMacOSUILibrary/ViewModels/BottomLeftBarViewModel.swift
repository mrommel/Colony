//
//  BottomLeftBarViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 11.01.22.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

protocol BottomLeftBarViewModelDelegate: AnyObject {

    func handleMainButtonClicked()
    func areAnimationsFinished() -> Bool
}

enum GameSceneTurnState {

    case aiTurns // => lock UI
    case humanTurns // => UI enabled
    case humanBlocked // dialog shown
}

public class BottomLeftBarViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var buttonViewModel: AnimatedImageViewModel

    @Published
    var selectedUnitCivilization: CivilizationType?

    @Published
    var selectedUnitType: UnitType?

    @Published
    var selectedUnitLocation: HexPoint?

    var globeImages: [NSImage] = []
    private var currentButtonNotificationType: NotificationType = .generic

    weak var delegate: BottomLeftBarViewModelDelegate?

    init() {

        let buttonImage = NSImage()
        self.buttonViewModel = AnimatedImageViewModel(image: buttonImage)
    }

    func preloadAssets() {

        if self.globeImages.isEmpty {
            self.globeImages = Array(0...90).map { "globe\($0)" }.map { globeTextureName in

                return ImageCache.shared.image(for: globeTextureName)
            }
        }
    }

    public func typeTemplateImage() -> NSImage {

        if let civilization = self.selectedUnitCivilization,
            let unitType = self.selectedUnitType {

            let image = ImageCache.shared.image(for: unitType.typeTemplateTexture())
            image.isTemplate = true

            return image.tint(with: civilization.accent)

        } else {
            return ImageCache.shared.image(for: "unit-type-template-default")
        }
    }

    public func typeBackgroundImage() -> NSImage {

        if let civilization = self.selectedUnitCivilization {

            return NSImage(color: civilization.main, size: NSSize(width: 16, height: 16))

        } else {
            return NSImage(color: .black, size: NSSize(width: 16, height: 16))
        }
    }

    func nextAgeImage() -> NSImage {

        guard let gameModel = self.gameEnvironment.game.value else {
            return ImageCache.shared.image(for: AgeType.normal.iconTexture())
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get game model")
        }

        let nextAge = humanPlayer.estimateNextAge(in: gameModel)

        return ImageCache.shared.image(for: nextAge.iconTexture())
    }

    func nextAgeProgress() -> String {

        guard let gameModel = self.gameEnvironment.game.value else {
            return ""
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get game model")
        }

        let eraScore: Int = humanPlayer.eraScore()
        let thresholds = humanPlayer.ageThresholds(in: gameModel)

        if eraScore < thresholds.lower {
            return "\(eraScore) / \(thresholds.lower)"
        } else if eraScore < thresholds.upper {
            return "\(eraScore) / \(thresholds.upper)"
        } else {
            return "\(eraScore) / ??"
        }
    }

    func updateTurnButton() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        gameModel.updateTestEndTurn() // -> this will update blockingNotification()

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if let blockingNotification = humanPlayer.blockingNotification() {

            if let location = self.selectedUnitLocation {
                /*if self.unitSelectionMode == .pick {
                    gameModel.userInterface?.select(unit: unit)
                }*/
                self.showButtonImage(from: .unitNeedsOrders(location: location))
            } else {
                // no unit selected - show blocking button
                self.showButtonImage(from: blockingNotification.type)
            }
        } else {
            if let delegate = self.delegate {
                if !delegate.areAnimationsFinished() {
                    // print("--- not finished")
                    self.showWaitingButton()
                } else {
                    // print("--- finished")
                    self.showTurnButton()
                }
            }
        }
    }

    func showWaitingButton() {

        self.showButtonImage(from: .waiting)
    }

    func showTurnButton() {

        self.showButtonImage(from: .turn)
    }

    func showSpinningGlobe() {

        self.buttonViewModel.playAnimation(images: self.globeImages, interval: 0.07, loop: true)
        self.currentButtonNotificationType = .generic
    }

    private func showButtonImage(from buttonNotificationType: NotificationType) {

        // only need to update image(s) if the type changes
        guard self.currentButtonNotificationType != buttonNotificationType else {
            return
        }

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        /*if self.uiTurnState != .humanTurns {
            return
        }*/

        if let location = self.selectedUnitLocation {

            for unit in gameModel.units(at: location) {

                if unit?.movesLeft() == 0 {
                    gameModel.userInterface?.unselect()
                    return
                }
            }
        }

        self.buttonViewModel.show(image: ImageCache.shared.image(for: buttonNotificationType.iconTexture()))
        self.currentButtonNotificationType = buttonNotificationType
    }

    func buttonClicked() {

        self.delegate?.handleMainButtonClicked()
    }
}
