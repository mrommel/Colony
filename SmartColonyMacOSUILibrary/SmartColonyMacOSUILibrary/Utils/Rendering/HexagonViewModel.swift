//
//  HexagonViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol HexagonViewModelDelegate: AnyObject {
    
    func clicked(on point: HexPoint)
}

class HexagonViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    let tile: AbstractTile
    
    weak var delegate: HexagonViewModelDelegate?
    
    init(tile: AbstractTile) {
        
        self.tile = tile
    }
    
    func color() -> NSColor {
        
        guard let gameModel = self.gameEnvironment.game.value else {
            return NSColor.black
        }
        
        guard let humanPlayer = gameModel.humanPlayer() else {
            return NSColor.black
        }
        
        if self.tile.isVisible(to: humanPlayer) {
            return self.tile.terrain().overviewColor()
        } else if self.tile.isDiscovered(by: humanPlayer) {
            return self.tile.terrain().forgottenColor()
        } else {
            return Globals.Colors.overviewBackground
        }
    }
    
    func offset() -> CGSize {
        
        let screenPoint = HexPoint.toScreen(hex: self.tile.point)
        return CGSize(fromPoint: CGPoint(x: screenPoint.x, y: -screenPoint.y))
    }
    
    func showMountains() -> Bool {
        
        return self.tile.feature() == .mountains
    }
    
    func mountainsImage() -> NSImage {
        
        guard let gameModel = self.gameEnvironment.game.value else {
            return NSImage()
        }
        
        guard let humanPlayer = gameModel.humanPlayer() else {
            return NSImage()
        }
        
        if self.tile.isVisible(to: humanPlayer) {
            return ImageCache.shared.image(for: "overview-mountains")
        } else if self.tile.isDiscovered(by: humanPlayer) {
            return ImageCache.shared.image(for: "overview-mountains-passive")
        } else {
            return NSImage()
        }
    }
    
    func showHills() -> Bool {
        
        return self.tile.hasHills()
    }
    
    func hillsImage() -> NSImage {
        
        guard let gameModel = self.gameEnvironment.game.value else {
            return NSImage()
        }
        
        guard let humanPlayer = gameModel.humanPlayer() else {
            return NSImage()
        }
        
        if self.tile.isVisible(to: humanPlayer) {
            return ImageCache.shared.image(for: "overview-hills")
        } else if self.tile.isDiscovered(by: humanPlayer) {
            return ImageCache.shared.image(for: "overview-hills-passive")
        } else {
            return NSImage()
        }
    }
    
    func showForest() -> Bool {
        
        return self.tile.feature() == .forest
    }
    
    func forestImage() -> NSImage {
        
        guard let gameModel = self.gameEnvironment.game.value else {
            return NSImage()
        }
        
        guard let humanPlayer = gameModel.humanPlayer() else {
            return NSImage()
        }
        
        if self.tile.isVisible(to: humanPlayer) {
            return ImageCache.shared.image(for: "overview-forest")
        } else if self.tile.isDiscovered(by: humanPlayer) {
            return ImageCache.shared.image(for: "overview-forest-passive")
        } else {
            return NSImage()
        }
    }
    
    func clicked() {
        
        self.delegate?.clicked(on: self.tile.point)
    }
}

extension HexagonViewModel: Hashable {
    
    static func == (lhs: HexagonViewModel, rhs: HexagonViewModel) -> Bool {
        
        return lhs.tile.point == rhs.tile.point
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.tile.point)
    }
}
