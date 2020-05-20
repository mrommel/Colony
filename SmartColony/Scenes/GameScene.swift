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

class GameScenePopupData {
    
    let popupType: PopupType
    let popupData: PopupData?
    
    init(popupType: PopupType, popupData: PopupData?) {
        
        self.popupType = popupType
        self.popupData = popupData
    }
}

class GameScene: BaseScene {

    // Constants
    let forceTouchLevel: CGFloat = 2.0

    // UI variables
    internal var mapNode: MapNode?
    private let viewHex: SKSpriteNode

    private var backgroundNode: SKSpriteNode?
    private var topBarBackNode: SKSpriteNode?
    private var topBarNode: SKSpriteNode?
    private var leftHeaderBarNode: LeftHeaderBarNode?
    private var rightHeaderBarNode: RightHeaderBarNode?
    internal var scienceProgressNode: ScienceProgressNode?
    private var scienceProgressNodeHidden: Bool = false
    internal var cultureProgressNode: CultureProgressNode?
    private var cultureProgressNodeHidden: Bool = false

    private var frameTopLeft: SKSpriteNode?
    private var frameTopRight: SKSpriteNode?
    private var frameBottomLeft: SKSpriteNode?
    private var frameBottomRight: SKSpriteNode?
    internal var bottomLeftBar: BottomLeftBar?
    internal var bottomRightBar: BottomRightBar?
    internal var notificationsNode: NotificationsNode?

    private var bannerNode: BannerNode?

    // yields
    private var scienceYield: YieldDisplayNode?
    private var cultureYield: YieldDisplayNode?
    private var goldYield: YieldDisplayNode?
    private var faithYield: YieldDisplayNode?
    
    private var turnLabel: SKLabelNode?

    // view model
    var viewModel: GameSceneViewModel?

    var selectedUnit: AbstractUnit? = nil
    var lastExecuted: TimeInterval = -1
    let queue: DispatchQueue = DispatchQueue(label: "update_queue")
    var readyUpdatingAI: Bool = true
    var readyUpdatingHuman: Bool = true
    var uiTurnState: UITurnState = .aiTurns
    var blockingNotification: Notification? = nil
    var currentScreenType: ScreenType = .none
    var currentPopupType: PopupType = .none
    
    var popups: [GameScenePopupData] = []

    // delegate
    weak var gameDelegate: GameDelegate?

    // MARK: constructors
    
    override init(size: CGSize) {

        self.viewHex = SKSpriteNode()

        super.init(size: size, layerOrdering: .nodeLayerOnTop)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods

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

        let topBarBackTexture = SKTexture(imageNamed: "top_bar_back")
        self.topBarBackNode = SKSpriteNode(texture: topBarBackTexture, size: CGSize(width: self.frame.width, height: 40))
        self.topBarBackNode?.zPosition = 4
        self.topBarBackNode?.anchorPoint = CGPoint.upperLeft
        self.safeAreaNode.addChild(self.topBarBackNode!)

        let topBarTexture = SKTexture(imageNamed: "top_bar")
        self.topBarNode = SKSpriteNode(texture: topBarTexture, size: CGSize(width: self.frame.width, height: 40))
        self.topBarNode?.zPosition = 4
        self.topBarNode?.anchorPoint = CGPoint.upperLeft
        self.safeAreaNode.addChild(self.topBarNode!)
        
        self.leftHeaderBarNode = LeftHeaderBarNode()
        self.leftHeaderBarNode?.zPosition = 4
        self.leftHeaderBarNode?.delegate = self
        self.safeAreaNode.addChild(self.leftHeaderBarNode!)
        
        self.rightHeaderBarNode = RightHeaderBarNode()
        self.rightHeaderBarNode?.zPosition = 4
        self.rightHeaderBarNode?.delegate = self
        self.safeAreaNode.addChild(self.rightHeaderBarNode!)
        
        self.scienceProgressNode = ScienceProgressNode()
        self.scienceProgressNode?.zPosition = Globals.ZLevels.progressIndicator
        self.safeAreaNode.addChild(self.scienceProgressNode!)
        
        self.cultureProgressNode = CultureProgressNode()
        self.cultureProgressNode?.zPosition = Globals.ZLevels.progressIndicator
        self.safeAreaNode.addChild(self.cultureProgressNode!)
        
        self.bottomLeftBar = BottomLeftBar(sized: CGSize(width: 200, height: 112))
        self.bottomLeftBar?.delegate = self
        self.bottomLeftBar?.zPosition = Globals.ZLevels.bottomElements
        self.safeAreaNode.addChild(self.bottomLeftBar!)

        self.bottomRightBar = BottomRightBar(for: viewModel.game, sized: CGSize(width: 200, height: 112))
        self.bottomRightBar?.delegate = self
        self.bottomRightBar?.zPosition = Globals.ZLevels.bottomElements
        self.safeAreaNode.addChild(self.bottomRightBar!)

        self.notificationsNode = NotificationsNode(sized: CGSize(width: 61, height: 300))
        self.notificationsNode?.delegate = self
        self.notificationsNode?.zPosition = Globals.ZLevels.notifications
        self.safeAreaNode.addChild(self.notificationsNode!)

        self.viewHex.name = "ViewHex"
        self.viewHex.position = CGPoint(x: self.size.width * 0, y: self.size.height * 0.5)
        self.viewHex.zPosition = 1.0
        self.viewHex.xScale = deviceScale
        self.viewHex.yScale = deviceScale
        
        self.mapNode = MapNode(with: viewModel.game)
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
        self.scienceYield?.zPosition = 400
        self.safeAreaNode.addChild(self.scienceYield!)

        self.cultureYield = YieldDisplayNode(for: .culture, value: 0.0, size: CGSize(width: 60, height: 32))
        self.cultureYield?.zPosition = 400
        self.safeAreaNode.addChild(self.cultureYield!)

        self.goldYield = YieldDisplayNode(for: .gold, value: 0.0, size: CGSize(width: 60, height: 32))
        self.goldYield?.zPosition = 400
        self.goldYield?.action = { yieldType in
            self.showScreen(screenType: .treasury)
        }
        self.safeAreaNode.addChild(self.goldYield!)

        self.faithYield = YieldDisplayNode(for: .faith, value: 0.0, size: CGSize(width: 60, height: 32))
        self.faithYield?.zPosition = 400
        self.safeAreaNode.addChild(self.faithYield!)
        
        self.turnLabel = SKLabelNode(text: "4000 BC")
        self.turnLabel?.zPosition = 400
        self.turnLabel?.fontSize = 14
        self.turnLabel?.fontName = Globals.Fonts.customFontFamilyname
        self.turnLabel?.fontColor = .white
        self.turnLabel?.numberOfLines = 0
        self.turnLabel?.horizontalAlignmentMode = .right
        self.safeAreaNode.addChild(self.turnLabel!)

        // disable turn button
        self.changeUITurnState(to: .aiTurns)

        self.updateLayout()
    }

    override func updateLayout() {

        super.updateLayout()

        let viewSize = (self.view?.bounds.size)!

        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.aspectFillTo(size: viewSize)
        
        // top bar / yields
        var offsetY: CGFloat = 0.0
        if self.safeAreaNode.frame.origin.y == 34.0 {
            offsetY = 28.0
        }

        self.topBarBackNode?.position = CGPoint(x: -self.frame.halfWidth, y: self.frame.halfHeight - offsetY + 40.0)
        self.topBarBackNode?.size.width = self.frame.width
        self.topBarNode?.position = CGPoint(x: -self.frame.halfWidth, y: self.frame.halfHeight - offsetY + 1.0)
        self.topBarNode?.size.width = self.frame.width
        
        self.leftHeaderBarNode?.position = CGPoint(x: -self.frame.halfWidth, y: self.frame.halfHeight - offsetY - 39)
        self.rightHeaderBarNode?.position = CGPoint(x: self.frame.halfWidth, y: self.frame.halfHeight - offsetY - 39)
        
        var scienceProgressNodeDelta: CGFloat = 0.0
        var cultureProgressNodeDelta: CGFloat = 0.0
        if self.scienceProgressNodeHidden {
            scienceProgressNodeDelta = 400.0
            cultureProgressNodeDelta = 64.0
        }
        if self.cultureProgressNodeHidden {
            cultureProgressNodeDelta = 400.0
        }
        self.scienceProgressNode?.position = CGPoint(x: -self.frame.halfWidth, y: self.frame.halfHeight - offsetY - 22.0 + scienceProgressNodeDelta)
        self.cultureProgressNode?.position = CGPoint(x: -self.frame.halfWidth, y: self.frame.halfHeight - offsetY - 86 + cultureProgressNodeDelta)
        self.scienceProgressNode?.updateLayout()
        self.cultureProgressNode?.updateLayout()

        self.scienceYield?.position = CGPoint(x: -self.frame.halfWidth + 10, y: frame.halfHeight - offsetY - 2)
        self.cultureYield?.position = CGPoint(x: -self.frame.halfWidth + 75, y: frame.halfHeight - offsetY - 2)
        self.goldYield?.position = CGPoint(x: -self.frame.halfWidth + 140, y: frame.halfHeight - offsetY - 2)
        self.faithYield?.position = CGPoint(x: -self.frame.halfWidth + 205, y: frame.halfHeight - offsetY - 2)
        
        self.turnLabel?.position = CGPoint(x: self.frame.halfWidth - 40, y: frame.halfHeight - offsetY - 2 - 20)

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

        // turn?
    }

    func zoom(to zoomScale: Double) {

        let zoomInAction = SKAction.scale(to: CGFloat(zoomScale), duration: 0.1)
        self.cameraNode.run(zoomInAction)
    }

    // MARK: game loop

    override func update(_ currentTime: TimeInterval) {

        // only check once per 0.5 sec
        if self.lastExecuted + 0.5 < currentTime {

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
                    self.queue.async {
                        //print("-----------> before human processing")
                        gameModel.update()
                        //print("-----------> after human processing")
                        self.readyUpdatingHuman = true
                    }
                }

            } else {
                if self.readyUpdatingAI {
                    self.readyUpdatingAI = false
                    self.queue.async {
                        //print("-----------> before AI processing")
                        gameModel.update()
                        //print("-----------> after AI processing")
                        self.readyUpdatingAI = true
                    }
                }
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
            
            self.view?.preferredFramesPerSecond = 15

            // show AI turn
            self.bottomLeftBar?.showSpinningGlobe()

        case .humanTurns:
            // hide AI is working banner
            self.bannerNode?.removeFromParent()
            
            self.view?.preferredFramesPerSecond = 60
            
            self.turnLabel?.text = gameModel.turnYear()

            // update nodes
            if let techs = humanPlayer.techs {
                
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
            
            // update state
            self.updateTurnButton()

        case .humanBlocked:
            // NOOP
            
            self.view?.preferredFramesPerSecond = 60
            
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
        
        if self.currentScreenType == .none {
            
            if self.popups.count > 0 && self.currentPopupType == .none {
                self.displayPopups()
                return
            }
        }

        if let blockingNotification = humanPlayer.blockingNotification() {

            if let unit = self.selectedUnit {
                // keep selected unit
                if unit.movesLeft() <= 0 {
                    self.unselect()
                }
            } else {
                // no unit selected - show blocking button
                self.bottomLeftBar?.showBlockingButton(for: blockingNotification)
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
        
        let cameraLocation = touch.location(in: self.cameraNode)

        guard let bottomRightBar = self.bottomRightBar, !bottomRightBar.frame.contains(cameraLocation) else {
            return
        }

        guard let bottomLeftBar = self.bottomLeftBar, !bottomLeftBar.frame.contains(cameraLocation) else {
            return
        }

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
        
        guard let bottomLeftBar = self.bottomLeftBar, !bottomLeftBar.frame.contains(cameraLocation) else {
            print("touch ended in left bar")
            return
        }
        
        if let scienceProgressNode = self.scienceProgressNode {
            
            if !self.scienceProgressNodeHidden && scienceProgressNode.contains(cameraLocation) {
                //print("science progress touched")
                self.showScreen(screenType: .techs)
                return
            }
        }
        
        if let cultureProgressNode = self.cultureProgressNode {
            
            if !self.cultureProgressNodeHidden && cultureProgressNode.contains(cameraLocation) {
                //print("culture progress touched")
                self.showScreen(screenType: .civics)
                return
            }
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

extension GameScene: LeftHeaderBarNodeDelegate {
    
    func toogleScienceButton() {
        //self.scienceProgressNode?.position.
        self.scienceProgressNodeHidden = !self.scienceProgressNodeHidden
        self.updateLayout()
    }
    
    func toggleCultureButton() {
        self.cultureProgressNodeHidden = !self.cultureProgressNodeHidden
        self.updateLayout()
    }
}

extension GameScene: RightHeaderBarNodeDelegate {
}

extension GameScene: BottomRightBarDelegate {

    func focus(on point: HexPoint) {

        self.centerCamera(on: point)
    }
    
    func showYields() {
        self.mapNode?.showYields()
    }
    
    func hideYields() {
        self.mapNode?.hideYields()
    }
    
    func showWater() {
        self.mapNode?.showWater()
    }
    
    func hideWater() {
        self.mapNode?.hideWater()
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

                let cityNameDialog = CityNameDialog()
                cityNameDialog.zPosition = 250

                cityNameDialog.addOkayAction(handler: {

                    if cityNameDialog.isValid() {
                        
                        let location = selectedUnit.location
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
                
                let cityName = humanPlayer.newCityName(in: gameModel)
                cityNameDialog.set(textFieldInput: cityName)
            }
        case .buildFarm:
            if let selectedUnit = self.selectedUnit {
                let farmBuildMission = UnitMission(type: .build, buildType: .farm, at: selectedUnit.location)
                selectedUnit.push(mission: farmBuildMission, in: gameModel)
            }
            break
        case .buildMine:
            if let selectedUnit = self.selectedUnit {
                let mineBuildMission = UnitMission(type: .build, buildType: .mine, at: selectedUnit.location)
                selectedUnit.push(mission: mineBuildMission, in: gameModel)
            }
            break
        case .buildRoute:
            // NOOP
            break
        case .pillage:
            // NOOP
            break
        case .fortify:
            if let selectedUnit = self.selectedUnit {
                selectedUnit.doFortify(in: gameModel)
            }
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
                print("cant finish turn")
                /*if let blockingNotification = humanPlayer.blockingNotification() {
                    blockingNotification.activate(in: gameModel)
                }*/
            }
        }
    }

    func handleFocusOnUnit() {

        if let unit = self.selectedUnit {
            // print("click on unit icon - \(self.selectedUnit?.type)")
            self.centerCamera(on: unit.location)
        } else {

            guard let gameModel = self.viewModel?.game else {
                fatalError("cant get game")
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human")
            }

            let units = gameModel.units(of: humanPlayer)

            for unitRef in units {

                if let unit = unitRef {
                    if !unit.hasMoved(in: gameModel) {
                        self.select(unit: unit)
                        self.centerCamera(on: unit.location)
                        return
                    }
                }
            }
        }
    }
    
    func handleTechNeeded() {
        
        self.showTechDialog()
    }
    
    func handleCivicNeeded() {
        
        self.showCivicDialog()
    }
}

extension GameScene: NotificationsDelegate {

    func handle(notification: NotificationItem?) {

        guard let notification = notification else {
            fatalError("cant get notification")
        }
        
        notification.activate(in: self.viewModel?.game)
    }
}
