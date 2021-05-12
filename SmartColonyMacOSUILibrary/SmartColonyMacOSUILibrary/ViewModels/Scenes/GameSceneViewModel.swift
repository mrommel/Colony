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
    
    enum GameSceneTurnState {

        case aiTurns // => lock UI
        case humanTurns // => UI enabled
        case humanBlocked // dialog shown
    }
    
    @Published
    var game: GameModel?
    
    @Published
    var selectedUnit: AbstractUnit? = nil
    
    @Published
    var sceneCombatMode: GameSceneCombatMode = .none
    
    @Published
    var turnButtonNotificationType: NotificationType = .unitNeedsOrders
    
    var turnButtonNotificationLocation: HexPoint = .zero
    
    @Published
    var uiTurnState: GameSceneTurnState = .humanTurns
    
    @Published
    var showCommands: Bool = false
    
    @Published
    var commands: [Command] = []
    
    var readyUpdatingAI: Bool = true
    var readyUpdatingHuman: Bool = true
    
    weak var delegate: GameViewModelDelegate?
    
    public init() {
        
        self.game = nil
    }
    
    public func doTurn() {
        
        print("do turn: \(self.turnButtonNotificationType)")
        
        if self.turnButtonNotificationType == .turn {
            self.handleTurnButtonClicked()
            return
        } else if self.turnButtonNotificationType == .unitNeedsOrders {
            self.handleFocusOnUnit()
            return
        } else if self.turnButtonNotificationType == .techNeeded {
            self.handleTechNeeded()
            return
        } else if self.turnButtonNotificationType == .civicNeeded {
            self.handleCivicNeeded()
            return
        } else if self.turnButtonNotificationType == .productionNeeded {
            self.handleProductionNeeded(at: self.turnButtonNotificationLocation)
            return
        } else if self.turnButtonNotificationType == .policiesNeeded {
            self.handlePoliciesNeeded()
            return
        } else if self.turnButtonNotificationType == .unitPromotion {
            self.handleUnitPromotion(at: self.turnButtonNotificationLocation)
            return
        } else {
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        }
    }
    
    public func buttonImage() -> NSImage {
        
        if let selectedUnit = self.selectedUnit {
            return selectedUnit.type.iconTexture()
        } else {
            return ImageCache.shared.image(for: self.turnButtonNotificationType.iconTexture())
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
        
        if 0 <= index && index < self.commands.count {
        
            let command = self.commands[index]
            return ImageCache.shared.image(for: command.type.buttonTexture())
        }
        
        return NSImage(size: NSSize(width: 32, height: 32))
    }
    
    func commandClicked(at index: Int) {
        
        if 0 <= index && index < self.commands.count {
        
            let command = self.commands[index]
            print("commandClicked(at: \(command.title()))")
        }
    }
    
    func selectedUnitChanged(commands: [Command], in gameModel: GameModel?) {
        
        self.turnButtonNotificationType = .unitNeedsOrders
        
        self.commands = commands
        
        self.showCommands =  self.selectedUnit != nil
    }
    
    func changeUITurnState(to state: GameSceneTurnState) {
        
        guard let gameModel = self.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        switch state {

        case .aiTurns:
            // show AI is working banner
            // self.safeAreaNode.addChild(self.bannerNode!)

            //self.view?.preferredFramesPerSecond = 15

            // show AI turn
            self.showSpinningGlobe()

        case .humanTurns:
            
            // dirty hacks
            /*self.mapNode?.unitLayer.populate(with: gameModel)
            for player in gameModel.players {
                for city in gameModel.cities(of: player) {
                    self.mapNode?.cityLayer.update(city: city)
                }
            }*/
            
            // hide AI is working banner
            //self.bannerNode?.removeFromParent()

            //self.view?.preferredFramesPerSecond = 60

            //self.turnLabel?.text = gameModel.turnYear()

            // update nodes
            /*if let techs = humanPlayer.techs {

                if let currentTech = techs.currentTech() {
                    let progressPercentage = techs.currentScienceProgress() / Double(currentTech.cost()) * 100.0
                    self.scienceProgressNode?.update(tech: currentTech, progress: Int(progressPercentage), turnsRemaining: techs.currentScienceTurnsRemaining())
                } else {
                    self.scienceProgressNode?.update(tech: .none, progress: 0, turnsRemaining: 0)
                }

                self.scienceYield?.set(yieldValue: techs.currentScienceProgress()) // lastScienceEarned
            }

            if let civics = humanPlayer.civics {

                if let currentCivic = civics.currentCivic() {
                    let progressPercentage = civics.currentCultureProgress() / Double(currentCivic.cost()) * 100.0
                    self.cultureProgressNode?.update(civic: currentCivic, progress: Int(progressPercentage), turnsRemaining: civics.currentCultureTurnsRemaining())
                } else {
                    self.cultureProgressNode?.update(civic: .none, progress: 0, turnsRemaining: 0)
                }

                self.cultureYield?.set(yieldValue: civics.currentCultureProgress()) // lastCultureEarned
            }

            if let treasury = humanPlayer.treasury {
                self.goldYield?.set(yieldValue: treasury.value())
            }
            
            if let religion = humanPlayer.religion {
                self.faithYield?.set(yieldValue: religion.value())
            }

            // update
            self.updateLeaders()*/

            // update state
            self.updateTurnButton()

        case .humanBlocked:
            // NOOP

            // self.view?.preferredFramesPerSecond = 60

            break
        }

        self.uiTurnState = state
    }
    
    func showTurnButton() {
        
        // self.unitImageNode?.texture = SKTexture(imageNamed: "button_turn")
        self.turnButtonNotificationType = .turn
    }
    
    func showBlockingButton(for blockingNotification: NotificationItem) {
        
        // self.unitImageNode?.texture = SKTexture(imageNamed: blockingNotification.type.iconTexture())
        self.turnButtonNotificationType = blockingNotification.type
        self.turnButtonNotificationLocation = blockingNotification.location
    }
    
    func showSpinningGlobe() {
        
        /*let globeAtlas = GameObjectAtlas(atlasName: "globe", template: "globe", range: 0..<91)
        
        // start animation
        let globeFrames: [SKTexture] = globeAtlas.textures
        let globeRotation = SKAction.repeatForever(SKAction.animate(with: globeFrames, timePerFrame: 0.07))
        
        self.unitImageNode?.run(globeRotation, withKey: BottomLeftBar.globeActionKey)*/
    }
    
    func hideSpinningGlobe() {
        
        //self.unitImageNode?.removeAction(forKey: BottomLeftBar.globeActionKey)
    }
    
    func updateTurnButton() {

        self.hideSpinningGlobe()

        self.game?.updateTestEndTurn() // -> this will update blockingNotification()

        guard let gameModel = self.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        /*if self.currentScreenType == .none {

            if self.popups.count > 0 && self.currentPopupType == .none {
                self.displayPopups()
                return
            }
        }*/

        if let blockingNotification = humanPlayer.blockingNotification() {

            if let unit = self.selectedUnit {
                if !unit.readyToMove() {
                    self.game?.userInterface?.unselect()
                } else {
                    self.game?.userInterface?.select(unit: unit)
                }
            } else {

                // no unit selected - show blocking button
                self.showBlockingButton(for: blockingNotification)
            }
        } else {
            self.showTurnButton()
        }
    }
    
    func scienceYieldValueViewModel() -> YieldValueViewModel {
        
        guard let gameModel = self.game else {
            return YieldValueViewModel(yieldType: .science, value: 0.0)
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }
        
        var scienceValue = 0.0
        if let techs = humanPlayer.techs {
            scienceValue = techs.currentScienceProgress()
        }
        
        return YieldValueViewModel(yieldType: .science, value: scienceValue)
    }
    
    func cultureYieldValueViewModel() -> YieldValueViewModel {
        
        guard let gameModel = self.game else {
            return YieldValueViewModel(yieldType: .culture, value: 0.0)
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }
        
        var cultureValue = 0.0
        if let civics = humanPlayer.civics {
            cultureValue = civics.currentCultureProgress()
        }
        
        return YieldValueViewModel(yieldType: .culture, value: cultureValue)
    }
}

extension GameSceneViewModel {
    
    func handleTurnButtonClicked() {
        
        print("---- turn pressed ------")

        guard let gameModel = self.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if self.uiTurnState == .humanTurns {

            if humanPlayer.canFinishTurn() {

                humanPlayer.endTurn(in: gameModel)
                self.changeUITurnState(to: .aiTurns)
            } else {
                print("cant finish turn")
                /*if let blockingNotification = humanPlayer.blockingNotification() {
                    blockingNotification.activate(in: gameModel)
                }*/
            }
        }
    }
    
    func handleFocusOnUnit() {
        
        if let unit = self.selectedUnit {
            print("click on unit icon - \(unit.type)")
            
            if unit.movesLeft() == 0 {
                self.game?.userInterface?.unselect()
                return
            }
            
            self.delegate?.focus(on: unit.location)
            //self.centerCamera(on: unit.location)
        } else {

            guard let gameModel = self.game else {
                fatalError("cant get game")
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human")
            }

            let units = gameModel.units(of: humanPlayer)

            for unitRef in units {

                if let unit = unitRef {
                    if unit.movesLeft() > 0 {
                        self.game?.userInterface?.select(unit: unit)
                        self.delegate?.focus(on: unit.location)
                        //self.centerCamera(on: unit.location)
                        return
                    }
                }
            }
        }
    }
    
    func handleTechNeeded() {
        fatalError("handleTechNeeded")
    }
    
    func handleCivicNeeded() {
        fatalError("handleCivicNeeded")
    }
    
    func handleProductionNeeded(at point: HexPoint) {
        fatalError("handleProductionNeeded")
    }
    
    func handlePoliciesNeeded() {
        
        self.delegate?.showChangePoliciesDialog()
    }
    
    func handleUnitPromotion(at point: HexPoint) {
        fatalError("handleUnitPromotion")
    }
}
