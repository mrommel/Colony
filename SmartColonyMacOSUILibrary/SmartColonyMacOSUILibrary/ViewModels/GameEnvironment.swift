//
//  Store.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 20.04.21.
//

import SwiftUI
import SmartAILibrary
import Combine

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

    public static let defaultValue = GameEnvironment()

    public func assign(game: GameModel?) {
        self.game.send(game)
    }
    
    public func change(visibleRect rect: CGRect) {
        self.visibleRect.send(rect)
    }
    
    public func moveCursor(to value: HexPoint) {
        self.cursor.send(value)
    }
}

