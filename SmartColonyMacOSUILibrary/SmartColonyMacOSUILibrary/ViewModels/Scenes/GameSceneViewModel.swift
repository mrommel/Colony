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
                
                /*
                CGEvent(mouseEventSource: nil, mouseType: CGEventType.leftMouseDown, mouseCursorPosition: CGPoint(x: 100, y: 100), mouseButton: CGMouseButton.left)?.post(tap: CGEventTapLocation.cghidEventTap)
                usleep(100)
                CGEvent(mouseEventSource: nil, mouseType: CGEventType.leftMouseUp, mouseCursorPosition: CGPoint(x: 100, y: 100), mouseButton: CGMouseButton.left)?.post(tap: CGEventTapLocation.cghidEventTap)
                */
            }
        }
    }
    
    @Published
    var selectedUnit: AbstractUnit? = nil {
        
        didSet {
            if self.uiTurnState != .humanTurns {
                return
            }
            
            if let selectedUnit = self.selectedUnit {
                self.buttonViewModel.show(image: selectedUnit.type.iconTexture())
            }
        }
    }
    
    @Published
    var selectedCity: AbstractCity? = nil {
        
        didSet {
            if let selectedCity = self.selectedCity {
                print("select city: \(selectedCity.name)")
                self.delegate?.showCityBanner(for: selectedCity)
            } else {
                self.delegate?.hideCityBanner()
            }
        }
    }
    
    @Published
    var sceneCombatMode: GameSceneCombatMode = .none
    
    @Published
    var turnButtonNotificationType: NotificationType = .unitNeedsOrders {
        didSet {
            if self.uiTurnState != .humanTurns {
                return
            }
            
            if let unit = self.selectedUnit {
                
                if unit.movesLeft() == 0 {
                    self.game?.userInterface?.unselect()
                    return
                }
                
                return
            }
            
            self.buttonViewModel.show(image: ImageCache.shared.image(for: self.turnButtonNotificationType.iconTexture()))
        }
    }
    
    var turnButtonNotificationLocation: HexPoint = .zero
    
    @Published
    var uiTurnState: GameSceneTurnState = .humanTurns
    
    @Published
    var buttonViewModel: AnimatedImageViewModel
    
    @Published
    var topBarViewModel: TopBarViewModel
    
    @Published
    var showCommands: Bool = false
    
    @Published
    var showBanner: Bool = true
    
    @Published
    var commands: [Command] = []
    
    var readyUpdatingAI: Bool = true
    var readyUpdatingHuman: Bool = true
    var refreshCities: Bool = false
    
    var centerOn: HexPoint? = nil
    
    var globeImages: [NSImage] = []
    
    weak var delegate: GameViewModelDelegate?
    
    public init() {
        
        self.game = nil
        
        let buttonImage = NSImage() // ImageCache.shared.image(for: NotificationType.unitNeedsOrders.iconTexture())
        self.buttonViewModel = AnimatedImageViewModel(image: buttonImage)
        self.topBarViewModel = TopBarViewModel()
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
    
    public func typeTemplateImage() -> NSImage {
        
        if let selectedUnit = self.selectedUnit {
            
            guard let civilization = selectedUnit.player?.leader.civilization() else {
                fatalError("cant get civ")
            }
            
            let image = ImageCache.shared.image(for: selectedUnit.type.typeTemplateTexture())
            image.isTemplate = true
            
            return image.tint(with: civilization.accent)
            
        } else {
            return ImageCache.shared.image(for: "unit-type-template-default")
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
            self.handle(command: command)
        }
    }
    
    func handle(command: Command) {

        guard let gameModel = self.game else {
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
    
    func selectedUnitChanged(commands: [Command], in gameModel: GameModel?) {
        
        self.turnButtonNotificationType = .unitNeedsOrders
        
        self.commands = commands
        
        self.showCommands =  self.selectedUnit != nil
    }
    
    func showMeleeTargets(of unit: AbstractUnit?) {
        
        print("not implemented: showMeleeTargets")
    }
    
    func showRangedTargets(of unit: AbstractUnit?) {
        
        print("not implemented: showRangedTargets")
    }
    
    func changeUITurnState(to state: GameSceneTurnState) {
        
        guard let gameModel = self.game else {
            fatalError("cant get game")
        }

        switch state {

        case .aiTurns:
            // show AI is working banner
            self.showBanner = true

            // show AI turn
            self.showSpinningGlobe()

        case .humanTurns:
            
            // dirty hacks
            self.refreshCities = true
            
            // hide AI is working banner
            self.showBanner = false
            
            // update nodes
            self.topBarViewModel.update()

            // update
            //self.updateLeaders()

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
        
        self.turnButtonNotificationType = .turn
        self.turnButtonNotificationLocation = HexPoint.invalid
    }
    
    func showBlockingButton(for blockingNotification: NotificationItem) {
        
        self.turnButtonNotificationType = blockingNotification.type
        self.turnButtonNotificationLocation = blockingNotification.location
    }
    
    func showSpinningGlobe() {
        
        if self.globeImages.count == 0 {
            self.globeImages = Array(0...90).map { "globe\($0)" }.map { globeTextureName in
                
                return ImageCache.shared.image(for: globeTextureName)
            }
        }
        
        self.buttonViewModel.playAnimation(images: self.globeImages, interval: 0.07)
    }
    
    func hideSpinningGlobe() {
        
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
        
        if let delegate = self.delegate {
            if delegate.checkPopups() {
                return
            }
        }

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
    
    // MARK: header view models
    
    func scienceHeaderViewModel() -> HeaderButtonViewModel {
        
        let viewModel = HeaderButtonViewModel(type: .science)
        viewModel.delegate = self
        
        return viewModel
    }
    
    func cultureHeaderViewModel() -> HeaderButtonViewModel {
        
        let viewModel = HeaderButtonViewModel(type: .culture)
        viewModel.delegate = self
        
        return viewModel
    }
    
    func governmentHeaderViewModel() -> HeaderButtonViewModel {
        
        let viewModel = HeaderButtonViewModel(type: .government)
        viewModel.delegate = self
        
        return viewModel
    }
    
    func logHeaderViewModel() -> HeaderButtonViewModel {
        
        let viewModel = HeaderButtonViewModel(type: .log)
        viewModel.delegate = self
        
        return viewModel
    }
    
    func rankingHeaderViewModel() -> HeaderButtonViewModel {
        
        let viewModel = HeaderButtonViewModel(type: .ranking)
        viewModel.delegate = self
        
        return viewModel
    }
    
    func tradeRoutesHeaderViewModel() -> HeaderButtonViewModel {
        
        let viewModel = HeaderButtonViewModel(type: .tradeRoutes)
        viewModel.delegate = self
        
        return viewModel
    }
    
    func techProgressViewModel() -> TechProgressViewModel {
        
        guard let gameModel = self.game else {
            return TechProgressViewModel(tech: .none, progress: 0, boosted: false)
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if let techs = humanPlayer.techs {
            if let currentTech = techs.currentTech() {
                let progressPercentage = techs.currentScienceProgress() / Double(currentTech.cost()) * 100.0
                return TechProgressViewModel(tech: currentTech, progress: Int(progressPercentage), boosted: false)
            }
        }

        return TechProgressViewModel(tech: .none, progress: 0, boosted: false)
    }
    
    func civicProgressViewModel() -> CivicProgressViewModel {
        
        guard let gameModel = self.game else {
            return CivicProgressViewModel(civic: .none, progress: 0, boosted: false)
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if let civics = humanPlayer.civics {
            if let currentCivic = civics.currentCivic() {
                let progressPercentage = civics.currentCultureProgress() / Double(currentCivic.cost()) * 100.0
                return CivicProgressViewModel(civic: currentCivic, progress: Int(progressPercentage), boosted: false)
            }
        }

        return CivicProgressViewModel(civic: .none, progress: 0, boosted: false)
    }
    
    // MARK: callbacks
    
    func foundCity(named cityName: String) {
        
        if let selectedUnit = self.selectedUnit {
            let location = selectedUnit.location
            selectedUnit.doFound(with: cityName, in: self.game)
            self.game?.userInterface?.unselect()

            if let city = self.game?.city(at: location) {
                self.game?.userInterface?.showScreen(screenType: .city, city: city, other: nil, data: nil)
            }
        }
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
        
        self.delegate?.showChangeTechDialog()
    }
    
    func handleCivicNeeded() {
        
        self.delegate?.showChangeCivicDialog()
    }
    
    func handleProductionNeeded(at location: HexPoint) {
        
        guard let gameModel = self.game else {
            fatalError("cant get game")
        }

        guard let city = gameModel.city(at: location) else {
            fatalError("cant get city at \(location)")
        }

        self.delegate?.showCityDialog(for: city)
    }
    
    func handlePoliciesNeeded() {
        
        self.delegate?.showChangePoliciesDialog()
    }
    
    func handleUnitPromotion(at point: HexPoint) {
        fatalError("handleUnitPromotion")
    }
}

extension GameSceneViewModel: HeaderButtonViewModelDelegate {
    
    func clicked(on type: HeaderButtonType) {
        
        switch type {
        
        case .science:
            self.delegate?.showChangeTechDialog()
        case .culture:
            self.delegate?.showChangeCivicDialog()
        case .government:
            self.delegate?.showGovernmentDialog()
        case .log:
            print("log")
        case .ranking:
            print("ranking")
        case .tradeRoutes:
            print("tradeRoutes")
        }
    }
}
