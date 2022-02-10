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

                let unitRefs = game.units(of: humanPlayer)

                guard let unitRef = unitRefs.first, let unit = unitRef else {
                    return
                }

                print("center on \(unit.location)")
                self.centerOn = unit.location
            }
        }
    }

    @Published
    var combatUnitTarget: AbstractUnit?

    @Published
    var combatCityTarget: AbstractCity?

    @Published
    var unitSelectionMode: UnitSelectionMode = .pick

    @Published
    var showCommands: Bool = false

    var readyUpdatingAI: Bool = true
    var readyUpdatingHuman: Bool = true
    var refreshCities: Bool = false

    private var centerOn: HexPoint?
    private var lens: MapLensType?

    weak var delegate: GameViewModelDelegate?

    public init() {

        self.game = nil
    }

    func focus(on point: HexPoint) {

        self.centerOn = point
    }

    func unFocus() {

        self.centerOn = nil
    }

    func focus() -> HexPoint? {

        return self.centerOn
    }

    func show(mapLens: MapLensType) {

        self.lens = mapLens
    }

    func hideMapLens() {

        self.lens = nil
    }

    func mapLens() -> MapLensType? {

        return self.lens
    }

    func updateRect(at point: HexPoint, size: CGSize) {

        self.delegate?.updateRect(at: point, size: size)
    }
}
