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
        case marker
    }

    @Published
    var gameModel: GameModel? {
        willSet {
            self.objectWillChange.send()

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

                guard let gameModel = self.gameModel else {
                    return
                }

                guard let humanPlayer = gameModel.humanPlayer() else {
                    return
                }

                let unitRefs = gameModel.units(of: humanPlayer)

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
    private var refreshMapOptions: MapDisplayOptions?
    internal var shouldRebuild: Bool = false
    internal var animationsAreRunning: Bool = false

    weak var delegate: GameViewModelDelegate?

    public init() {

        self.gameModel = nil
    }

    public func rebuild() {

        print("rebuildMap")
        self.shouldRebuild = true
    }

    public func update(with mapOptions: MapDisplayOptions?) {

        // this will force MapNode to update
        self.refreshMapOptions = mapOptions
    }

    public func shouldRefreshMapOptions() -> MapDisplayOptions? {

        return self.refreshMapOptions
    }

    public func resetRefreshMapOptions() {

        self.refreshMapOptions = nil
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

    func updateRect(at point: HexPoint, size: CGSize) {

        self.delegate?.updateRect(at: point, size: size)
    }
}
