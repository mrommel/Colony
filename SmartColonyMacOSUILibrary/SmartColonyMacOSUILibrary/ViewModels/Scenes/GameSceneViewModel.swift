//
//  GameSceneViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.05.21.
//

import Cocoa
import SmartAILibrary
import SmartAssets

public class GameSceneViewModel: ObservableObject {
    
    enum GameSceneCombatMode {
        
        case none
        case melee
        case ranged
    }
    
    @Published
    var game: GameModel?
    
    @Published
    var selectedUnit: AbstractUnit? = nil
    
    @Published
    var sceneCombatMode: GameSceneCombatMode = .none
    
    @Published
    var turnButtonNotificationType: NotificationType = .unitNeedsOrders
    
    @Published
    var showCommands: Bool = false
    
    @Published
    var commands: [Command] = []
    
    public init() {
        
        self.game = nil
    }
    
    public func doTurn() {
        
        print("do turn: \(self.turnButtonNotificationType)")
        
        if self.turnButtonNotificationType == .turn {
            // self.delegate?.handleTurnButtonClicked()
            return
        } else if self.turnButtonNotificationType == .unitNeedsOrders {
            // self.delegate?.handleFocusOnUnit()
            return
        } else if self.turnButtonNotificationType == .techNeeded {
            // self.delegate?.handleTechNeeded()
            return
        } else if self.turnButtonNotificationType == .civicNeeded {
            // self.delegate?.handleCivicNeeded()
            return
        } else if self.turnButtonNotificationType == .productionNeeded {
            // self.delegate?.handleProductionNeeded(at: self.turnButtonNotificationLocation)
            return
        } else if self.turnButtonNotificationType == .policiesNeeded {
            // self.delegate?.handlePoliciesNeeded()
            return
        } else if self.turnButtonNotificationType == .unitPromotion {
            // self.delegate?.handleUnitPromotion(at: self.turnButtonNotificationLocation)
            return
        } else {
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        }
    }
    
    public func buttonImage() -> NSImage {
        
        if let selectedUnit = self.selectedUnit {
            return selectedUnit.type.iconTexture()
        } else {
            return NSImage(named: "button_generic")! 
        }
    }
    
    public func typeImage() -> NSImage {
        
        if let selectedUnit = self.selectedUnit {
            
            guard let civilization = selectedUnit.player?.leader.civilization() else {
                fatalError("cant get civ")
            }
            
            let image = ImageCache.shared.image(for: selectedUnit.type.typeTexture())
            image.isTemplate = true
            
            return image.tint(with: civilization.accent)
            
        } else {
            return ImageCache.shared.image(for: "unit-type-default")
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
    
    public func unitName() -> String {
        
        if let selectedUnit = self.selectedUnit {
            return selectedUnit.name()
        } else {
            return ""
        }
    }
    
    public func unitMoves() -> String {
        
        if let selectedUnit = self.selectedUnit {
            return "\(selectedUnit.moves()) / \(selectedUnit.maxMoves(in: self.game)) Moves"
        }
            
        return ""
    }
    
    public func unitHealth() -> String {
        
        if let selectedUnit = self.selectedUnit {
            return "\(selectedUnit.healthPoints()) ⚕"
        }
        
        return ""
    }
    
    public func unitCharges() -> String {
        
        if let selectedUnit = self.selectedUnit {
            if selectedUnit.type.buildCharges() > 0 {
                return "\(selectedUnit.buildCharges()) ♾"
            }
        }
        
        return ""
    }
    
    func commandImage(at index: Int) -> NSImage {
        
        if index < self.commands.count {
        
            let command = self.commands[index]
            return ImageCache.shared.image(for: command.type.buttonTexture())
        }
        
        //return NSImage(color: NSColor.red, size: NSSize(width: 32, height: 32))
        return NSImage(size: NSSize(width: 32, height: 32))
    }
    
    func commandClicked(at index: Int) {
        
        print("commandClicked(at: \(index))")
    }
    
    func selectedUnitChanged(commands: [Command], in gameModel: GameModel?) {
        
        self.turnButtonNotificationType = .unitNeedsOrders
        
        self.commands = commands
        
        self.showCommands =  self.selectedUnit != nil
    }
}
