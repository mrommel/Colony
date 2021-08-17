//
//  UnitViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary

protocol UnitViewModelDelegate: AnyObject {

    func clicked(on unitType: UnitType, at index: Int)
    func clicked(on unit: AbstractUnit?, at index: Int)
}

class UnitViewModel: QueueViewModel, ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    let unitType: UnitType
    let turns: Int
    let unit: AbstractUnit?
    let index: Int

    weak var delegate: UnitViewModelDelegate?

    init(unitType: UnitType, turns: Int = -1, at index: Int = -1) {

        self.unitType = unitType
        self.turns = turns
        self.unit = nil
        self.index = index

        super.init(queueType: .unit)
    }

    init(unit: AbstractUnit?, at index: Int = -1) {

        self.unitType = .barbarianWarrior
        self.turns = -1
        self.unit = unit
        self.index = index

        super.init(queueType: .unit)
    }

    func icon() -> NSImage {

        if let unit = self.unit {
            return ImageCache.shared.image(for: unit.type.typeTexture())
        }

        return ImageCache.shared.image(for: self.unitType.typeTexture())
    }

    func title() -> String {

        if let unit = self.unit {
            return unit.name()
        }

        return self.unitType.name()
    }

    func turnsText() -> String {
        
        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        if let unit = self.unit {
            return "\(unit.movesLeft()) / \(unit.maxMoves(in: gameModel)) moves"
        }
            
        if self.turns != -1 {
            return "\(self.turns)"
        }

        return ""
    }

    func turnsIcon() -> NSImage {

        if self.unit != nil {
            return NSImage()
        }
        
        if self.turns != -1 {
            return ImageCache.shared.image(for: "turns")
        }

        return NSImage()
    }

    func background() -> NSImage {

        return ImageCache.shared.image(for: "grid9-button-active")
    }

    func clicked() {

        if let unit = self.unit {
            self.delegate?.clicked(on: unit, at: self.index)
        } else {
            self.delegate?.clicked(on: self.unitType, at: self.index)
        }
    }
}

/*extension UnitViewModel: Hashable {
    
    static func == (lhs: UnitViewModel, rhs: UnitViewModel) -> Bool {
        
        return lhs.unitType == rhs.unitType
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.unitType)
    }
}*/
