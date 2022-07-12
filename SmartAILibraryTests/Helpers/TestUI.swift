//
//  TestUI.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 21.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

@testable import SmartAILibrary

class TestUI: UserInterfaceDelegate {

    func update(gameState: GameStateType) {}
    func update(activePlayer: AbstractPlayer?) {}

    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData? = nil) {}

    func showLeaderMessage(
        from fromPlayer: AbstractPlayer?,
        to toPlayer: AbstractPlayer?,
        deal: DiplomaticDeal?,
        state: DiplomaticRequestState,
        message: DiplomaticRequestMessage,
        emotion: LeaderEmotionType
    ) {}

    func showPopup(popupType: PopupType) {}

    func showScreen(screenType: ScreenType, city: AbstractCity?) {}

    func isShown(screen: ScreenType) -> Bool {
        return false
    }

    func add(notification: NotificationItem) {}
    func remove(notification: NotificationItem) {}

    func select(unit: AbstractUnit?) {}
    func unselect() {}

    func show(unit: AbstractUnit?) {}
    func hide(unit: AbstractUnit?) {}
    func move(unit: AbstractUnit?, on points: [HexPoint]) {}
    func refresh(unit: AbstractUnit?) {}
    func animate(unit: AbstractUnit?, animation: UnitAnimationType) {}
    func animate(city: AbstractCity?, animation: CityAnimationType) {}

    func clearAttackFocus() {}

    func showAttackFocus(at point: HexPoint) {}

    func askForConfirmation(title: String, question: String, confirm: String, cancel: String, completion: @escaping (Bool) -> Void) {}
    func askForCity(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping (AbstractCity?) -> Void) {}
    func askForSelection(title: String, items: [SelectableItem], completion: @escaping (Int) -> Void) {}
    func askForInput(title: String, summary: String, value: String, confirm: String, cancel: String, completion: @escaping (String) -> Void) {}

    func select(tech: TechType) {}
    func select(civic: CivicType) {}

    func show(unit: AbstractUnit?, at location: HexPoint) {}
    func hide(unit: AbstractUnit?, at location: HexPoint) {}
    func enterCity(unit: AbstractUnit?, at location: HexPoint) {}
    func leaveCity(unit: AbstractUnit?, at location: HexPoint) {}
    func remove(city: AbstractCity?) {}

    func show(city: AbstractCity?) {}
    func update(city: AbstractCity?) {}

    func refresh(tile: AbstractTile?) {}

    func showTooltip(at point: HexPoint, type: TooltipType, delay: Double) {}

    func focus(on location: HexPoint) {}

    func animationsAreRunning(for leader: LeaderType) -> Bool { return false }

    func finish(tutorial: TutorialType) {}
}
