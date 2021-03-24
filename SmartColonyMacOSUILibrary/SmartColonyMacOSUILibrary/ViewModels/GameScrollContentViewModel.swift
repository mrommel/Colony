//
//  MapScrollContentViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 21.03.21.
//

import Foundation
import SmartAILibrary

open class GameScrollContentViewModel: ObservableObject {
    
    @Published public var game: GameModel? = nil {
        didSet {
            self.gameChanged()
        }
    }
    @Published public var zoom: CGFloat
    
    public var didChange: ((HexPoint) -> ())? = nil
    public var shouldRedraw: (() -> ())? = nil

    public init() {
        self.zoom = 1.0
    }
    
    open func setFocus(to tile: AbstractTile?) {
    }
    
    open func options() -> GameDisplayOptions {
        
        return GameDisplayOptions(showFeatures: true, showResources: true, showBorders: true, showStartPositions: false, showInhabitants: false, showSupportedPeople: false)
    }
    
    open func draw(at point: HexPoint) {

        guard let game = self.game else {
            return
        }
        
        // draw
    }
    
    open func gameChanged() {
        // NOOP
    }
    
    public func doTurn() {
        
        guard let humanPlayer = self.game?.humanPlayer() else {
            fatalError("no human player given")
        }
        
        while !humanPlayer.canFinishTurn() {

            self.game?.update()
        }

        humanPlayer.endTurn(in: self.game)
    }
}
