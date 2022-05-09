//
//  Store.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 20.04.21.
//

import SwiftUI
import SmartAILibrary
import Combine

public struct MapDisplayOptions {

    public var showGrid: Bool = false
    public var showResourceMarkers: Bool = true
    public var showYields: Bool = false
    public var showCitizen: Bool = false

    // lenses
    public var mapLens: MapLensType = .none

    // debug
    public var showHexCoordinates: Bool = false
    public var showCompleteMap: Bool = false
}

extension EnvironmentValues {

    public var gameEnvironment: GameEnvironment {
        get {
            self[GameEnvironment.self]
        }
        set {
            self[GameEnvironment.self] = newValue
        }
    }
}

public class GameEnvironment: EnvironmentKey {

    public let game = CurrentValueSubject<GameModel?, Never>(nil)
    public let cursor = CurrentValueSubject<HexPoint, Never>(.zero)
    public let visibleRect = CurrentValueSubject<CGRect, Never>(.zero)
    public let displayOptions = CurrentValueSubject<MapDisplayOptions, Never>(MapDisplayOptions())

    public static let defaultValue = GameEnvironment()

    public init() {

    }

    public init(game: GameModel?) {
        self.game.value = game
    }

    public func assign(game: GameModel?) {
        self.game.send(game)
    }

    public func change(visibleRect rect: CGRect) {
        self.visibleRect.send(rect)
    }

    public func moveCursor(to value: HexPoint) {
        self.cursor.send(value)
    }

    public func changeShowGrid(to value: Bool) {

        var displayOptions = self.displayOptions.value
        displayOptions.showGrid = value
        self.displayOptions.send(displayOptions)
    }

    public func changeShowResourceMarkers(to value: Bool) {

        var displayOptions = self.displayOptions.value
        displayOptions.showResourceMarkers = value
        self.displayOptions.send(displayOptions)
    }

    public func changeShowYieldsMarkers(to value: Bool) {

        var displayOptions = self.displayOptions.value
        displayOptions.showYields = value
        self.displayOptions.send(displayOptions)
    }
}
