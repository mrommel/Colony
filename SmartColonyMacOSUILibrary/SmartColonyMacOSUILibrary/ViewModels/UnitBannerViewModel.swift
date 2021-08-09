//
//  UnitBannerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 09.08.21.
//

import SwiftUI
import SmartAILibrary

class UnitBannerViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var showBanner: Bool = false
    
    @Published
    var commands: [Command] = []
    
    private var selectedUnit: AbstractUnit? = nil
    
    weak var delegate: GameViewModelDelegate?
    
    init(selectedUnit: AbstractUnit? = nil) {
        
        self.selectedUnit = selectedUnit
    }
    
#if DEBUG
    init(selectedUnit: AbstractUnit? = nil, in gameModel: GameModel?) {
        
        self.selectedUnit = selectedUnit
        
        self.gameEnvironment.assign(game: gameModel)
        self.showBanner = true
    }
#endif
    
    public func unitName() -> String {
        
        if let selectedUnit = self.selectedUnit {
            return selectedUnit.name()
        } else {
            return ""
        }
    }
    
    public func unitMoves() -> String {
        
        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }
        
        if let selectedUnit = self.selectedUnit {
            return "\(selectedUnit.moves()) / \(selectedUnit.maxMoves(in: gameModel)) Moves"
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
            self.handle(command: command)
        }
    }
    
    func handle(command: Command) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        switch command.type {
        
        case .found:
            self.delegate?.showCityNameDialog()

        case .buildFarm:
            if let selectedUnit = self.selectedUnit {
                let farmBuildMission = UnitMission(type: .build, buildType: .farm, at: selectedUnit.location)
                selectedUnit.push(mission: farmBuildMission, in: gameModel)
            }
            
        case .buildMine:
            if let selectedUnit = self.selectedUnit {
                let mineBuildMission = UnitMission(type: .build, buildType: .mine, at: selectedUnit.location)
                selectedUnit.push(mission: mineBuildMission, in: gameModel)
            }
            
        case .buildCamp:
            if let selectedUnit = self.selectedUnit {
                let campBuildMission = UnitMission(type: .build, buildType: .camp, at: selectedUnit.location)
                selectedUnit.push(mission: campBuildMission, in: gameModel)
            }
        
        case .buildPasture:
            if let selectedUnit = self.selectedUnit {
                let pastureBuildMission = UnitMission(type: .build, buildType: .pasture, at: selectedUnit.location)
                selectedUnit.push(mission: pastureBuildMission, in: gameModel)
            }
            
        case .buildQuarry:
            if let selectedUnit = self.selectedUnit {
                let quarryBuildMission = UnitMission(type: .build, buildType: .quarry, at: selectedUnit.location)
                selectedUnit.push(mission: quarryBuildMission, in: gameModel)
            }
        case .buildFishingBoats:
            if let selectedUnit = self.selectedUnit {
                let fishingBuildMission = UnitMission(type: .build, buildType: .fishingBoats, at: selectedUnit.location)
                selectedUnit.push(mission: fishingBuildMission, in: gameModel)
            }
            
        case .pillage:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.doPillage(in: gameModel)
            }
            
        case .fortify:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.doFortify(in: gameModel)
            }
            
        case .hold:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.set(activityType: .hold, in: gameModel)
                //selectedUnit.finishMoves()
            }
            
        case .garrison:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.doGarrison(in: gameModel)
            }
        case .disband:
            if let selectedUnit = self.selectedUnit {
                
                gameModel.userInterface?.askToDisband(unit: selectedUnit, completion: { (disband) in
                    if disband {
                        selectedUnit.doKill(delayed: false, by: nil, in: gameModel)
                    }
                })
            }
        case .establishTradeRoute:
            if let selectedUnit = self.selectedUnit {
                
                guard let originCity = gameModel.city(at: selectedUnit.origin) else {
                    return // origin city does not exist anymore ?
                }
                
                let cities = selectedUnit.possibleTradeRouteTargets(in: gameModel)
                
                gameModel.userInterface?.askForCity(start: originCity, of: cities, completion: { (target) in
                    
                    if let targetCity = target {
                        if !selectedUnit.doEstablishTradeRoute(to: targetCity, in: gameModel) {
                            print("could not establish a trade route to \(targetCity.name)")
                        }
                    }
                })
            }
            
        case .attack:
            print("attack")
            if let selectedUnit = self.selectedUnit {
                // we need a target here
                self.showMeleeTargets(of: selectedUnit)
                //self.bottomCombatBar?.showCombatView()
            }
        
        case .rangedAttack:
            print("rangedAttack")
            if let selectedUnit = self.selectedUnit {
                // we need a target here
                self.showRangedTargets(of: selectedUnit)
                //self.bottomCombatBar?.showCombatView()
            }
            
        case .cancelAttack:
            print("cancelAttack")
            //self.cancelAttacks()
        }
    }
    
    func selectedUnitChanged(to unit: AbstractUnit?, commands: [Command], in gameModel: GameModel?) {
        
        self.selectedUnit = unit
        self.commands = commands
    }
    
    func showMeleeTargets(of unit: AbstractUnit?) {
        
        print("not implemented: showMeleeTargets")
    }
    
    func showRangedTargets(of unit: AbstractUnit?) {
        
        print("not implemented: showRangedTargets")
    }
}
