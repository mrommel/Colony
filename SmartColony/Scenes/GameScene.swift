//
//  GameScene.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

protocol GameDelegate: class {

    func exit()
}

enum UITurnState {

    case aiTurns // => lock UI
    case humanTurns // => UI enabled
    case humanBlocked // dialog shown
}

class GameScene: BaseScene {

    // Constants
    let forceTouchLevel: CGFloat = 2.0

    // UI variables
    private var mapNode: MapNode?
    private let viewHex: SKSpriteNode

    private var backgroundNode: SKSpriteNode?
    private var frameTopLeft: SKSpriteNode?
    private var frameTopRight: SKSpriteNode?
    private var frameBottomLeft: SKSpriteNode?
    private var frameBottomRight: SKSpriteNode?
    private var bottomLeftBar: BottomLeftBar?
    private var bottomRightBar: BottomRightBar?
    private var notificationsNode: NotificationsNode?

    private var bannerNode: BannerNode?
    
    // yields
    private var scienceYield: YieldDisplayNode?
    private var cultureYield: YieldDisplayNode?
    private var goldYield: YieldDisplayNode?
    private var faithYield: YieldDisplayNode?

    // view model
    var viewModel: GameSceneViewModel?

    var selectedUnit: AbstractUnit? = nil
    var lastExecuted: TimeInterval = -1
    let queue = DispatchQueue(label: "update_queue")
    var readyUpdatingAI: Bool = true
    var readyUpdatingHuman: Bool = true
    var uiTurnState: UITurnState = .aiTurns
    var blockingNotification: Notification? = nil

    // delegate
    weak var gameDelegate: GameDelegate?

    override init(size: CGSize) {

        self.viewHex = SKSpriteNode()

        super.init(size: size, layerOrdering: .nodeLayerOnTop)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        super.didMove(to: view)

        let viewSize = (self.view?.bounds.size)!
        let deviceScale = self.size.width / 667

        guard let viewModel = self.viewModel else {
            fatalError("no ViewModel")
        }

        // the scale sets the zoom level of the camera on the given position
        self.cameraNode.xScale = CGFloat(Globals.Constants.initialScale)
        self.cameraNode.yScale = CGFloat(Globals.Constants.initialScale)

        // background
        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.zPosition = -100
        self.backgroundNode?.size = viewSize
        self.cameraNode.addChild(backgroundNode!)

        self.mapNode = MapNode(with: viewModel.game)
        self.bottomLeftBar = BottomLeftBar(sized: CGSize(width: 200, height: 112))
        self.bottomLeftBar?.delegate = self
        self.safeAreaNode.addChild(self.bottomLeftBar!)
        
        self.bottomRightBar = BottomRightBar(for: viewModel.game, sized: CGSize(width: 200, height: 112))
        self.bottomRightBar?.delegate = self
        self.safeAreaNode.addChild(self.bottomRightBar!)
        
        self.notificationsNode = NotificationsNode(sized: CGSize(width: 61, height: 300))
        self.notificationsNode?.delegate = self
        self.safeAreaNode.addChild(self.notificationsNode!)

        self.viewHex.name = "ViewHex"
        self.viewHex.position = CGPoint(x: self.size.width * 0, y: self.size.height * 0.5)
        self.viewHex.zPosition = 1.0
        self.viewHex.xScale = deviceScale
        self.viewHex.yScale = deviceScale
        self.viewHex.addChild(self.mapNode!)
        self.rootNode.addChild(self.viewHex)

        // position the camera on the gamescene.
        self.cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)

        self.frameTopLeft = SKSpriteNode(imageNamed: "frame_top_left")
        self.frameTopLeft?.position = CGPoint(x: -self.frame.halfWidth, y: frame.halfHeight)
        self.frameTopLeft?.zPosition = 3
        self.frameTopLeft?.anchorPoint = CGPoint.upperLeft
        self.safeAreaNode.addChild(self.frameTopLeft!)

        self.frameTopRight = SKSpriteNode(imageNamed: "frame_top_right")
        self.frameTopRight?.position = CGPoint(x: self.frame.halfWidth, y: frame.halfHeight)
        self.frameTopRight?.zPosition = 3
        self.frameTopRight?.anchorPoint = CGPoint.upperRight
        self.safeAreaNode.addChild(self.frameTopRight!)

        self.frameBottomLeft = SKSpriteNode(imageNamed: "frame_bottom_left")
        self.frameBottomLeft?.position = CGPoint(x: -self.frame.halfWidth, y: -frame.halfHeight)
        self.frameBottomLeft?.zPosition = 3
        self.frameBottomLeft?.anchorPoint = CGPoint.lowerLeft
        self.safeAreaNode.addChild(self.frameBottomLeft!)

        self.frameBottomRight = SKSpriteNode(imageNamed: "frame_bottom_right")
        self.frameBottomRight?.position = CGPoint(x: self.frame.halfWidth, y: -frame.halfHeight)
        self.frameBottomRight?.zPosition = 3
        self.frameBottomRight?.anchorPoint = CGPoint.lowerRight
        self.safeAreaNode.addChild(self.frameBottomRight!)

        self.bannerNode = BannerNode(text: "Other players are taking their turns, please wait ...")
        self.bannerNode?.zPosition = 200
        
        // yields
        self.scienceYield = YieldDisplayNode(for: .science, value: 0.0, size: CGSize(width: 60, height: 32))
        self.scienceYield?.position = CGPoint(x: -self.frame.halfWidth + 10, y: frame.halfHeight - 24)
        self.scienceYield?.zPosition = 400
        self.safeAreaNode.addChild(self.scienceYield!)
        
        self.cultureYield = YieldDisplayNode(for: .culture, value: 0.0, size: CGSize(width: 60, height: 32))
        self.cultureYield?.position = CGPoint(x: -self.frame.halfWidth + 75, y: frame.halfHeight - 24)
        self.cultureYield?.zPosition = 400
        self.safeAreaNode.addChild(self.cultureYield!)
        
        self.goldYield = YieldDisplayNode(for: .gold, value: 0.0, size: CGSize(width: 60, height: 32))
        self.goldYield?.position = CGPoint(x: -self.frame.halfWidth + 140, y: frame.halfHeight - 24)
        self.goldYield?.zPosition = 400
        self.safeAreaNode.addChild(self.goldYield!)
        
        self.faithYield = YieldDisplayNode(for: .faith, value: 0.0, size: CGSize(width: 60, height: 32))
        self.faithYield?.position = CGPoint(x: -self.frame.halfWidth + 205, y: frame.halfHeight - 24)
        self.faithYield?.zPosition = 400
        self.safeAreaNode.addChild(self.faithYield!)

        // disable turn button
        self.changeUITurnState(to: .aiTurns)

        self.updateLayout()
    }

    override func updateLayout() {

        super.updateLayout()

        let viewSize = (self.view?.bounds.size)!

        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.aspectFillTo(size: viewSize)

        self.mapNode?.updateLayout()

        self.frameTopLeft?.position = CGPoint(x: -self.frame.halfWidth, y: self.frame.halfHeight)
        self.frameTopRight?.position = CGPoint(x: self.frame.halfWidth, y: self.frame.halfHeight)
        self.frameBottomLeft?.position = CGPoint(x: -self.frame.halfWidth, y: -self.frame.halfHeight)
        self.frameBottomRight?.position = CGPoint(x: self.frame.halfWidth, y: -self.frame.halfHeight)

        self.bottomLeftBar?.position = CGPoint(x: -self.safeAreaNode.frame.halfWidth, y: -self.safeAreaNode.frame.halfHeight)
        self.bottomLeftBar?.updateLayout()

        self.bottomRightBar?.position = CGPoint(x: self.safeAreaNode.frame.halfWidth, y: -self.safeAreaNode.frame.halfHeight)
        self.bottomRightBar?.updateLayout()
        
        self.notificationsNode?.position = CGPoint(x: -self.safeAreaNode.frame.halfWidth, y: -self.safeAreaNode.frame.halfHeight)
        self.notificationsNode?.updateLayout()
        
        // yields
        self.scienceYield?.position = CGPoint(x: -self.frame.halfWidth + 10, y: frame.halfHeight - 24)
        self.cultureYield?.position = CGPoint(x: -self.frame.halfWidth + 75, y: frame.halfHeight - 24)
        self.goldYield?.position = CGPoint(x: -self.frame.halfWidth + 140, y: frame.halfHeight - 24)
        self.faithYield?.position = CGPoint(x: -self.frame.halfWidth + 205, y: frame.halfHeight - 24)
        
        // turn?
    }

    func zoom(to zoomScale: Double) {
        
        let zoomInAction = SKAction.scale(to: CGFloat(zoomScale), duration: 0.1)
        self.cameraNode.run(zoomInAction)
    }

    // MARK: game loop

    override func update(_ currentTime: TimeInterval) {

        // only check once per 1 sec
        if self.lastExecuted + 1 < currentTime {

            guard let gameModel = self.viewModel?.game else {
                fatalError("cant get game")
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human")
            }

            if self.readyUpdatingAI && humanPlayer.isActive() {
                self.changeUITurnState(to: .humanTurns)
                
                if self.readyUpdatingHuman {
                    
                    self.readyUpdatingHuman = false
                    queue.async {
                        //print("-----------> before human processing")
                        gameModel.update()
                        //print("-----------> after human processing")
                        self.readyUpdatingHuman = true
                    }
                }
                
            } else {
                if self.readyUpdatingAI {
                    self.readyUpdatingAI = false
                    queue.async {
                        print("-----------> before AI processing")
                        gameModel.update()
                        print("-----------> after AI processing")
                        self.readyUpdatingAI = true
                    }
                }
            }
            
            // update yields
            if let techs = humanPlayer.techs {
                self.scienceYield?.set(yieldValue: techs.currentScienceProgress()) // lastScienceEarned
            }
            
            if let civics = humanPlayer.civics {
                self.cultureYield?.set(yieldValue: civics.currentCultureProgress()) // lastCultureEarned
            }

            self.lastExecuted = currentTime
        }
    }

    // MARK: touch handling

    func changeUITurnState(to state: UITurnState) {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }
        
        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }
        
        switch state {

        case .aiTurns:
            // show AI is working banner
            self.safeAreaNode.addChild(self.bannerNode!)

            // show AI turn
            self.bottomLeftBar?.showSpinningGlobe()

        case .humanTurns:
            // hide AI is working banner
            self.bannerNode?.removeFromParent()

            // update state
            self.updateTurnButton()
            
            // update notifications
            /*if let notifications = humanPlayer.notifications() {
                self.notificationsNode?.notifications = notifications.notifications()
                self.notificationsNode?.rebuildNotificationBadges()
            }*/
            
        case .humanBlocked:
            // NOOP
            break
        }

        self.uiTurnState = state
    }

    func updateTurnButton() {

        self.bottomLeftBar?.hideSpinningGlobe()
        
        self.viewModel?.game?.updateTestEndTurn() // -> this will update blockingNotification()

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if let blockingNotification = humanPlayer.blockingNotification() {
            
            if self.selectedUnit == nil {
                // no unit selected - show blocking button
                self.bottomLeftBar?.showBlockingButton(for: blockingNotification)
            } else {
                // keep selected unit
            }
        } else {
            self.bottomLeftBar?.showTurnButton()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }
        
        guard self.uiTurnState == .humanTurns else {
            return
        }
        
        let touch = touches.first!
        let cameraLocation = touch.location(in: self.cameraNode)
        let touchLocation = touch.location(in: self.viewHex)
        let position = HexPoint(screen: touchLocation)
        
        if let bottomLeftBar = self.bottomLeftBar, bottomLeftBar.frame.contains(cameraLocation) {
            
            guard self.uiTurnState == .humanTurns else {
                return
            }
            
            if bottomLeftBar.handleTouches(touches, with: event) {
                return
            }
        }
        
        if touch.tapCount == 2 || touch.force > self.forceTouchLevel {
            
            // double tap opens city
            if let city = viewModel?.game?.city(at: position) {
                
                if humanPlayer.isEqual(to: city.player) {
                    self.showScreen(screenType: .city, city: city)
                    return
                }
            }
        } else {
        
            if let unit = viewModel?.game?.unit(at: position) {
                if humanPlayer.isEqual(to: unit.player) {
                    self.select(unit: unit)
                    return
                }
            }
        }
    
        self.unselect()
    }

    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first!

        let touchLocation = touch.location(in: self.viewHex)
        let position = HexPoint(screen: touchLocation)

        if let selectedUnit = self.selectedUnit {

            guard self.uiTurnState == .humanTurns else {
                return
            }
            
            if position != selectedUnit.location {

                let pathFinder = AStarPathfinder()
                pathFinder.dataSource = self.viewModel?.game?.ignoreUnitsPathfinderDataSource(for: selectedUnit.movementType(), for: selectedUnit.player)

                if let path = pathFinder.shortestPath(fromTileCoord: selectedUnit.location, toTileCoord: position) {
                    path.prepend(point: selectedUnit.location, cost: 0.0)
                    self.mapNode?.unitLayer.show(path: path, for: selectedUnit)
                } else {
                    self.mapNode?.unitLayer.clearPathSpriteBuffer()
                }
            }
        } else {

            let cameraLocation = touch.location(in: self.cameraNode)

            guard let bottomRightBar = self.bottomRightBar, !bottomRightBar.frame.contains(cameraLocation) else {
                return
            }

            guard let bottomLeftBar = self.bottomLeftBar, !bottomLeftBar.frame.contains(cameraLocation) else {
                return
            }

            let previousLocation = touch.previousLocation(in: self.viewHex)

            let deltaX = (touchLocation.x) - (previousLocation.x)
            let deltaY = (touchLocation.y) - (previousLocation.y)

            self.cameraNode.position.x -= deltaX * 0.7
            self.cameraNode.position.y -= deltaY * 0.7
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let cameraLocation = touch.location(in: self.cameraNode)
        let touchLocation = touch.location(in: self.viewHex)
        let position = HexPoint(screen: touchLocation)

        guard let bottomRightBar = self.bottomRightBar, !bottomRightBar.frame.contains(cameraLocation) else {
            self.bottomRightBar?.touchesEnded(touches, with: event)
            return
        }
        
        guard self.uiTurnState == .humanTurns else {
            return
        }
        
        if let notificationsNode = self.notificationsNode, notificationsNode.frame.contains(cameraLocation) {
            
            if notificationsNode.handleTouches(touches, with: event) {
                return
            }
        }

        if let selectedUnit = self.selectedUnit {
            
            self.mapNode?.unitLayer.clearPathSpriteBuffer()
            self.mapNode?.unitLayer.hideFocus()
            if selectedUnit.location != position {
                self.mapNode?.unitLayer.move(unit: selectedUnit, to: position)
            }
        }
    }

    func centerCamera(on hex: HexPoint) {

        let screenPosition = HexPoint.toScreen(hex: hex)
        let cameraPositionInScene = self.convert(screenPosition, from: self.viewHex)
        self.cameraNode.position = cameraPositionInScene
        //print("center camera on: \(cameraPositionInScene)")
    }
    
    func prepareForCityScreen() {
        
        self.uiTurnState = .humanBlocked
        
        // hide units
        self.mapNode?.unitLayer.removeFromParent()
        
        // hide bottom controls
        self.bottomLeftBar?.removeFromParent()
        self.bottomRightBar?.removeFromParent()
        self.notificationsNode?.removeFromParent()
    }
    
    func restoreFromCityScreen() {
        
        self.uiTurnState = .humanTurns
        
        // show units
        self.mapNode?.addChild(self.mapNode!.unitLayer)
        
        // re-add bottom controls
        self.safeAreaNode.addChild(self.bottomLeftBar!)
        self.safeAreaNode.addChild(self.bottomRightBar!)
        self.safeAreaNode.addChild(self.notificationsNode!)
    }
}

extension GameScene: BottomRightBarDelegate {

    func focus(on point: HexPoint) {
        
        self.centerCamera(on: point)
    }
}

extension GameScene: BottomLeftBarDelegate {
    
    func handle(command: Command) {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }
        
        switch command.type {
        case .found:
            if let selectedUnit = self.selectedUnit {
                
                self.prepareForCityScreen()
                
                let cityName = humanPlayer.newCityName(in: gameModel)
                let location = selectedUnit.location
                
                let cityNameDialog = CityNameDialog()
                cityNameDialog.zPosition = 250
                
                cityNameDialog.addOkayAction(handler: {
                    
                    if cityNameDialog.isValid() {
                        selectedUnit.doFound(with: cityNameDialog.getCityName(), in: self.viewModel?.game)
                        self.unselect()
                        cityNameDialog.close()
                        self.restoreFromCityScreen()
                        
                        if let city = self.viewModel?.game?.city(at: location) {
                            self.showScreen(screenType: .city, city: city)
                        }
                    }
                })
                       
                cityNameDialog.addCancelAction(handler: {
                    cityNameDialog.close()
                    self.restoreFromCityScreen()
                })
                
                self.cameraNode.add(dialog: cityNameDialog)
                cityNameDialog.set(textFieldInput: cityName)
            }
        case .buildFarm:
            // NOOP
            break
        case .buildMine:
            // NOOP
            break
        case .buildRoute:
            // NOOP
            break
        case .pillage:
            // NOOP
            break
        case .fortify:
            // NOOP
            break
        case .hold:
            // NOOP
            break
        case .garrison:
            // NOOP
            break
        }
    }
    
    func handleTurnButtonClicked() {

        print("---- turn pressed ------")

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        // debug
        /*for player in gameModel.players {
            print("-- score of \(player.leader) = \(player.score(for: gameModel))")
        }*/

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if self.uiTurnState == .humanTurns {

            if humanPlayer.canFinishTurn() {

                humanPlayer.endTurn(in: gameModel)
                self.changeUITurnState(to: .aiTurns)
            } else {

                /*if let blockingNotification = humanPlayer.blockingNotification() {
                    blockingNotification.activate(in: gameModel)
                }*/
            }
        }
    }
    
    func handleFocusOnUnit() {
        
        print("click on unit icon - \(self.selectedUnit?.type)")
    }
}

extension GameScene : NotificationsDelegate {

    func handle(notification: NotificationItem?) {
        
        guard let notification = notification else {
            fatalError("cant get notification")
        }
         
        switch notification.type {

        case .turn:
            fatalError("should not happen")
        case .generic:
            // NOOP
            break
        case .tech:
            notification.activate(in: self.viewModel?.game)
            break
        case .civic:
            notification.activate(in: self.viewModel?.game)
            break
        case .production:
            notification.activate(in: self.viewModel?.game)
            break
        case .cityGrowth:
            // NOOP
            break
        case .starving:
            // NOOP
            break
        case .diplomaticDeclaration:
            // NOOP
            break
        case .war:
            // NOOP
            break
        case .enemyInTerritory:
            // NOOP
            break
        case .unitPromotion:
            // NOOP
            break
        case .unitNeedsOrders:
            // NOOP
            break
        case .era:
            // NOOP
            break
        }
    }
}

extension GameScene: UserInterfaceProtocol {
    
    func select(unit: AbstractUnit?) {

        self.mapNode?.unitLayer.showFocus(for: unit)
        self.selectedUnit = unit
        
        if let commands = unit?.commands(in: self.viewModel?.game) {
            self.bottomLeftBar?.selectedUnitChanged(to: unit, commands: commands)
        }
    }

    func unselect() {

        self.mapNode?.unitLayer.hideFocus()
        self.bottomLeftBar?.selectedUnitChanged(to: nil, commands: [])
        self.selectedUnit = nil
    }

    func isDiplomaticScreenActive() -> Bool {
        return false
    }

    func isPopupShown() -> Bool {
        return false
    }

    func showPopup(popupType: PopupType, data: PopupData?) {
        print("popup")
    }

    func showScreen(screenType: ScreenType, city: AbstractCity? = nil) {
    
        if screenType == .city {
            
            self.prepareForCityScreen()
            
            let cityDialog = CityDialog(for: city, in: self.viewModel?.game)
            cityDialog.zPosition = 250
            
            cityDialog.addResultHandler(handler: { commandResult in
                
                self.restoreFromCityScreen()
                cityDialog.close()
            })
                   
            cityDialog.addCancelAction(handler: {
                self.restoreFromCityScreen()
                cityDialog.close()
            })
            
            self.cameraNode.add(dialog: cityDialog)
            
        } else if screenType == .techs {
            
            guard let gameModel = self.viewModel?.game else {
                fatalError("cant get game")
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human")
            }
            
            let scienceDialog = ScienceDialog(with: humanPlayer.techs)
            scienceDialog.zPosition = 250
                   
            scienceDialog.addCancelAction(handler: {
                scienceDialog.close()
            })
            
            scienceDialog.addResultHandler(handler: { result in
                //print("result: \(result) => \(result.toTech())")
                do {
                    try humanPlayer.techs?.setCurrent(tech: result.toTech())
                    //humanPlayer.notifications()?.update(in: self.viewModel?.game)
                    scienceDialog.close()
                } catch {
                    print("cant select tech \(error)")
                }
            })
            
            self.cameraNode.add(dialog: scienceDialog)
            
        } else if screenType == .civics {
            
            guard let gameModel = self.viewModel?.game else {
                fatalError("cant get game")
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human")
            }
            
            let civicDialog = CivicDialog(with: humanPlayer.civics)
            civicDialog.zPosition = 250
                   
            civicDialog.addCancelAction(handler: {
                civicDialog.close()
            })
            
            civicDialog.addResultHandler(handler: { result in
                
                //print("result: \(result) => \(result.toCivic())")
                do {
                    try humanPlayer.civics?.setCurrent(civic: result.toCivic())
                    civicDialog.close()
                } catch {
                    print("cant select tech \(error)")
                }
            })
            
            self.cameraNode.add(dialog: civicDialog)
            
        } else {
            print("screen: \(screenType) not handled")
        }
    }

    func show(unit: AbstractUnit?) {
        
        // unit gets visible again
        self.mapNode?.unitLayer.show(unit: unit)
    }

    func hide(unit: AbstractUnit?) {
        
        // unit gets hidden
        self.mapNode?.unitLayer.hide(unit: unit)
        self.unselect()
    }

    func move(unit: AbstractUnit?, on points: [HexPoint]) {
        print("move")
        let costs: [Double] = [Double].init(repeating: 0.0, count: points.count)
        self.mapNode?.unitLayer.move(unit: unit, on: HexPath(points: points, costs: costs))
    }
    
    func show(city: AbstractCity?) {

        self.mapNode?.cityLayer.show(city: city)
    }

    func showTooltip(at point: HexPoint, text: String, delay: Double) {
        print("tooltip")
    }

    func add(notification: NotificationItem) {

        self.notificationsNode?.add(notification: notification)
    }
    
    func remove(notification: NotificationItem) {
        
        self.notificationsNode?.remove(notification: notification)
    }

    func refresh(tile: AbstractTile?) {
        self.mapNode?.terrainLayer.update(tile: tile)
        self.mapNode?.featureLayer.update(tile: tile)
        self.mapNode?.improvementLayer.update(tile: tile)
    }
}
