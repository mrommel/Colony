//
//  GameScene.swift
//  Colony
//
//  Created by Michael Rommel on 26.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import GameplayKit
import Rswift

protocol GameDelegate: class {

    func select(object: GameObject?)
    func quitGame()
}

class GameScene: SKScene {

    // MARK: Constants
    let headerHeight: CGFloat = 480

    struct Constants {

        struct ZLevels {
            static let terrain: CGFloat = 1.0
            static let underwater: CGFloat = 1.1
            static let caldera: CGFloat = 1.5
            static let area: CGFloat = 2.0
            static let focus: CGFloat = 3.0
            static let feature: CGFloat = 4.0
            static let road: CGFloat = 4.1
            static let river: CGFloat = 4.2
            static let path: CGFloat = 4.3
            static let featureUpper: CGFloat = 4.5
            static let staticSprite: CGFloat = 5.0
            static let cityName: CGFloat = 5.5
            static let sprite: CGFloat = 6.0
            static let labels: CGFloat = 50.0
            static let dialogs: CGFloat = 50.0
        }

        struct Visibility {
            static let currently: CGFloat = 1.0
            static let discovered: CGFloat = 0.5
        }
        
        static let initialScale: CGFloat = 0.25
    }

    var viewModel: GameSceneViewModel?

    // UI
    var safeAreaNode: SafeAreaNode
    var backgroundNode: SKSpriteNode?
    var frameTopLeft: SKSpriteNode?
    var frameTopRight: SKSpriteNode?
    var frameBottomLeft: SKSpriteNode?
    var frameBottomRight: SKSpriteNode?
    var bottomLeftBar: BottomLeftBar?
    var bottomRightBar: BottomRightBar?

    var exitButton: MessageBoxButtonNode?

    var mapNode: MapNode?
    let viewHex: SKSpriteNode

    var focus: SKSpriteNode?
    var lastFocusPoint: HexPoint = HexPoint(x: 0, y: 0)

    var cameraNode: SKCameraNode!
    var coinLabel: SKLabelNode!
    var coinIconLabel: SKSpriteNode!
    let timeLabel = SKLabelNode(text: "0:00")
    var hasMoved = false
    
    // booster handling
    var boosterNodeTelescope: BoosterNode?
    var boosterNodeTime: BoosterNode?

    var game: Game? // the reference
    weak var gameDelegate: GameDelegate?

    override init(size: CGSize) {

        self.safeAreaNode = SafeAreaNode()
        self.viewHex = SKSpriteNode()

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Deallocating GameScene")

        self.removeAllActions()
        self.removeAllChildren()
        self.removeFromParent()

        self.mapNode = nil
        self.focus = nil
    }

    override func didMove(to view: SKView) {

        let viewSize = (self.view?.bounds.size)!
        let deviceScale = self.size.width / 667

        guard let viewModel = self.viewModel else {
            fatalError("no ViewModel")
        }

        // camera
        self.cameraNode = SKCameraNode() //initialize and assign an instance of SKCameraNode to the cam variable.

        //the scale sets the zoom level of the camera on the given position
        self.cameraNode.xScale = Constants.initialScale
        self.cameraNode.yScale = Constants.initialScale

        self.camera = cameraNode //set the scene's camera to reference cam
        self.addChild(cameraNode) //make the cam a childElement of the scene itself.

        // the safeAreaNode holds the UI
        self.cameraNode.addChild(self.safeAreaNode)
        self.safeAreaNode.updateLayout()
        
        // background
        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.zPosition = -100
        self.backgroundNode?.size = viewSize
        self.cameraNode.addChild(backgroundNode!)
        
        let userUsecase = UserUsecase()
        guard let user = userUsecase.currentUser() else {
            fatalError("can't get current user")
        }

        switch viewModel.type {

        case .level:

            guard let levelURL = viewModel.levelURL else {
                fatalError("no level url")
            }

            guard let level = LevelManager.loadLevelFrom(url: levelURL) else {
                fatalError("no level")
            }
            
            self.game = Game(with: level, coins: user.coins, boosterStock: user.boosterStock)

            self.mapNode = MapNode(with: level)
            self.bottomLeftBar = BottomLeftBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar = BottomRightBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar?.delegate = self

            self.showLevel(title: level.title, summary: level.summary)

        case .game:
            self.game = self.viewModel?.game
            
            guard let level = self.viewModel?.getLevel() else {
                fatalError("no level")
            }
            
            self.mapNode = MapNode(with: level)
            self.bottomLeftBar = BottomLeftBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar = BottomRightBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar?.delegate = self

        case .generator:

            guard let map = viewModel.map else {
                fatalError()
            }

            let startPositionFinder = StartPositionFinder(map: map)
            let startPositions = startPositionFinder.identifyStartPositions()
            
            let gameObjectManager = GameObjectManager(on: map)

            let level = Level(number: 0, title: "Generator", summary: "Dummy", difficulty: .easy, duration: 300, map: map, startPositions: startPositions, gameObjectManager: gameObjectManager)
            
            self.game = Game(with: level, coins: user.coins, boosterStock: user.boosterStock)

            self.mapNode = MapNode(with: level)
            self.bottomLeftBar = BottomLeftBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar = BottomRightBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar?.delegate = self

            self.showLevel(title: "Free playing", summary: "Please play free")
        }

        self.game?.conditionDelegate = self
        self.game?.gameUpdateDelegate = self
        self.game?.add(gameObjectUnitDelegate: self)

        if let bottomLeftBar = self.bottomLeftBar {
            self.safeAreaNode.addChild(bottomLeftBar)
        }

        if let bottomRightBar = self.bottomRightBar {
            self.safeAreaNode.addChild(bottomRightBar)
        }

        viewHex.position = CGPoint(x: self.size.width * 0, y: self.size.height * 0.5)
        viewHex.xScale = deviceScale
        viewHex.yScale = deviceScale
        viewHex.addChild(self.mapNode!)
        self.addChild(viewHex)

        self.placeFocusHex()

        // position the camera on the gamescene.
        self.cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)

        self.frameTopLeft = SKSpriteNode(imageNamed: "frame_top_left")
        self.frameTopLeft?.position = CGPoint(x: -self.frame.halfWidth, y: frame.halfHeight)
        self.frameTopLeft?.zPosition = 3
        self.frameTopLeft?.anchorPoint = CGPoint.upperLeft

        if let frameTopLeft = self.frameTopLeft {
            self.safeAreaNode.addChild(frameTopLeft)
        }

        self.frameTopRight = SKSpriteNode(imageNamed: "frame_top_right")
        self.frameTopRight?.position = CGPoint(x: self.frame.halfWidth, y: frame.halfHeight)
        self.frameTopRight?.zPosition = 3
        self.frameTopRight?.anchorPoint = CGPoint.upperRight

        if let frameTopRight = self.frameTopRight {
            self.safeAreaNode.addChild(frameTopRight)
        }

        self.frameBottomLeft = SKSpriteNode(imageNamed: "frame_bottom_left")
        self.frameBottomLeft?.position = CGPoint(x: -self.frame.halfWidth, y: -frame.halfHeight)
        self.frameBottomLeft?.zPosition = 3
        self.frameBottomLeft?.anchorPoint = CGPoint.lowerLeft

        if let frameBottomLeft = self.frameBottomLeft {
            self.safeAreaNode.addChild(frameBottomLeft)
        }

        self.frameBottomRight = SKSpriteNode(imageNamed: "frame_bottom_right")
        self.frameBottomRight?.position = CGPoint(x: self.frame.halfWidth, y: -frame.halfHeight)
        self.frameBottomRight?.zPosition = 3
        self.frameBottomRight?.anchorPoint = CGPoint.lowerRight

        if let frameBottomRight = self.frameBottomRight {
            self.safeAreaNode.addChild(frameBottomRight)
        }

        if viewModel.type == .generator {
            // save node
            let saveButton = MessageBoxButtonNode(titled: "Save", buttonAction: {

                /*let map = self.viewModel?.map

                let startPositionFinder = StartPositionFinder(map: map)
                let startPositions = startPositionFinder.identifyStartPositions()

                let level = Level(number: 0, title: "Test", summary: "Dummy", difficulty: .easy, map: map!, startPositions: startPositions, gameObjectManager: self.mapNode!.gameObjectManager)*/

                LevelManager.store(game: self.game, to: "level000X.lvl")

            })
            saveButton.position = CGPoint(x: 0, y: frame.size.height - headerHeight - 40)
            saveButton.zPosition = 200
            self.safeAreaNode.addChild(saveButton)
        }

        // infos
        self.coinLabel = SKLabelNode(text: "0000")
        self.coinLabel.fontSize = 18
        self.coinLabel.zPosition = GameScene.Constants.ZLevels.labels
        self.safeAreaNode.addChild(self.coinLabel)
        
        self.coinIconLabel = SKSpriteNode(imageNamed: "coin1")
        self.coinIconLabel.zPosition = GameScene.Constants.ZLevels.labels
        self.safeAreaNode.addChild(self.coinIconLabel)
        
        self.timeLabel.fontSize = 18
        self.timeLabel.zPosition = GameScene.Constants.ZLevels.labels
        self.safeAreaNode.addChild(self.timeLabel)
        
        // exit node
        self.exitButton = MessageBoxButtonNode(titled: "Cancel", buttonAction: {
            self.showQuitConfirmationDialog()
        })
        self.exitButton?.zPosition = 200
        self.safeAreaNode.addChild(self.exitButton!)

        // focus on ship
        if let mapNode = self.mapNode {
            if let selectedUnit = mapNode.gameObjectManager.selected {
                self.centerCamera(on: selectedUnit.position)
                self.moveFocus(to: selectedUnit.position)
            }
        }
        
        self.updateLayout()
        
        // FIXME
        let telescopeBoosterAvailable = self.game?.boosterStock.isAvailable(boosterType: .telescope) ?? false
        self.boosterNodeTelescope = BoosterNode(for: .telescope, active: telescopeBoosterAvailable)
        self.boosterNodeTelescope?.zPosition = 200
        self.boosterNodeTelescope?.position = CGPoint(x: 220, y: 250)
        self.boosterNodeTelescope?.delegate = self
        self.safeAreaNode.addChild(self.boosterNodeTelescope!)
        
        let timeBoosterAvailable = self.game?.boosterStock.isAvailable(boosterType: .time) ?? false
        self.boosterNodeTime = BoosterNode(for: .time, active: timeBoosterAvailable)
        self.boosterNodeTime?.zPosition = 200
        self.boosterNodeTime?.position = CGPoint(x: 220, y: 170)
        self.boosterNodeTime?.delegate = self
        self.safeAreaNode.addChild(self.boosterNodeTime!)
    }

    func updateLayout() {

        self.safeAreaNode.updateLayout()
        
        self.mapNode?.updateLayout()

        self.frameTopLeft?.position = CGPoint(x: -self.frame.halfWidth, y: self.frame.halfHeight)
        self.frameTopRight?.position = CGPoint(x: self.frame.halfWidth, y: self.frame.halfHeight)
        self.frameBottomLeft?.position = CGPoint(x: -self.frame.halfWidth, y: -self.frame.halfHeight)
        self.frameBottomRight?.position = CGPoint(x: self.frame.halfWidth, y: -self.frame.halfHeight)

        self.coinIconLabel.position = CGPoint(x: -30, y: self.frame.halfHeight - 43)
        self.coinLabel.position = CGPoint(x: 0, y: self.frame.halfHeight - 50)
        self.timeLabel.position = CGPoint(x: self.frame.halfWidth - 50, y: self.frame.halfHeight - 50)
        
        self.bottomLeftBar?.position = CGPoint(x: -self.safeAreaNode.frame.halfWidth, y: -self.safeAreaNode.frame.halfHeight)
        self.bottomLeftBar?.updateLayout()

        self.bottomRightBar?.position = CGPoint(x: self.safeAreaNode.frame.halfWidth, y: -self.safeAreaNode.frame.halfHeight)
        self.bottomRightBar?.updateLayout()
        
        self.exitButton?.position = CGPoint(x: -self.safeAreaNode.frame.halfWidth + 50, y: -self.safeAreaNode.frame.halfHeight + 112 + 21)
    }

    func showQuitConfirmationDialog() {

        if let quitConfirmationDialog = UI.quitConfirmationDialog() {

            quitConfirmationDialog.zPosition = 250
            quitConfirmationDialog.addOkayAction(handler: {
                quitConfirmationDialog.close()
                
                self.game?.cancel()
                self.game = nil
                
                self.gameDelegate?.quitGame()
            })

            quitConfirmationDialog.addCancelAction(handler: {
                quitConfirmationDialog.close()
            })

            self.cameraNode.addChild(quitConfirmationDialog)
        }
    }

    func showLevel(title: String, summary: String) {

        if let levelIntroductionDialog = UI.levelIntroductionDialog() {

            levelIntroductionDialog.zPosition = 250
            levelIntroductionDialog.set(text: title, identifier: "title")
            levelIntroductionDialog.set(text: summary, identifier: "summary")
            levelIntroductionDialog.addOkayAction(handler: {
                levelIntroductionDialog.close()

                guard let duration = self.game?.duration else {
                    fatalError("can't get level duration")
                }
                
                // start timer
                self.game?.start(with: duration)
            })

            self.cameraNode.addChild(levelIntroductionDialog)
        }
    }

    func placeFocusHex() {

        self.focus = SKSpriteNode(imageNamed: "hex_cursor")
        self.focus?.position = HexMapDisplay.shared.toScreen(hex: HexPoint(x: 0, y: 0))
        self.focus?.zPosition = GameScene.Constants.ZLevels.focus
        self.focus?.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        //self.focus?.xScale = 1.0
        //self.focus?.yScale = 1.0
        self.viewHex.addChild(self.focus!)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.hasMoved = false
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first!
        let cameraLocation = touch.location(in: self.cameraNode)

        guard let bottomRightBar = self.bottomRightBar, !bottomRightBar.frame.contains(cameraLocation) else {
            self.bottomRightBar?.touchesEnded(touches, with: event)
            return
        }

        guard let bottomLeftBar = self.bottomLeftBar, !bottomLeftBar.frame.contains(cameraLocation) else {
            self.bottomLeftBar?.touchesEnded(touches, with: event)
            return
        }

        var touchLocation = touch.location(in: self.viewHex)

        // FIXME: hm, not sure why this is needed
        touchLocation.x -= 20
        touchLocation.y -= 15

        let position = HexMapDisplay.shared.toHexPoint(screen: touchLocation)
        print("new focus: \(position)")

        if !self.hasMoved {
            self.moveFocus(to: position)
        }
    }

    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {

            let cameraLocation = touch.location(in: self.cameraNode)

            guard let bottomRightBar = self.bottomRightBar, !bottomRightBar.frame.contains(cameraLocation) else {
                return
            }

            guard let bottomLeftBar = self.bottomLeftBar, !bottomLeftBar.frame.contains(cameraLocation) else {
                return
            }

            let location = touch.location(in: self.viewHex)
            let previousLocation = touch.previousLocation(in: self.viewHex)

            let deltaX = (location.x) - (previousLocation.x)
            let deltaY = (location.y) - (previousLocation.y)

            if abs(deltaX) > 0.1 || abs(deltaY) > 0.1 {
                self.hasMoved = true
            }

            self.cameraNode.position.x -= deltaX * 0.7
            self.cameraNode.position.y -= deltaY * 0.7
            //print("camera pos moved: \(self.cameraNode.position)")
        }
    }

    func zoom(to zoomScale: CGFloat) {
        let zoomInAction = SKAction.scale(to: zoomScale, duration: 0.1)
        self.cameraNode.run(zoomInAction)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //print("tick")
    }

    func centerCamera(on hex: HexPoint) {

        var screenPosition = HexMapDisplay.shared.toScreen(hex: hex)
        // FIXME: hm, not sure why this is needed
        screenPosition.x += 20
        screenPosition.y += 15

        let cameraPositionInScene = self.convert(screenPosition, from: self.viewHex)

        self.cameraNode.position = cameraPositionInScene
        print("center camera on: \(cameraPositionInScene)")
    }

    func moveFocus(to hex: HexPoint) {

        //print("move to \(hex)")
        self.focus?.position = HexMapDisplay.shared.toScreen(hex: hex)

        self.mapNode?.moveSelectedUnit(to: hex)

        if hex == self.lastFocusPoint {

            // debug
            //if let selectedCity = self.mapNode?.gameObjectManager.selected as? CityObject {
                
            if let city = self.game?.city(at: hex) {
                let cityDialog = UI.cityDialog(for: city)
                cityDialog?.addOkayAction(handler: {
                    cityDialog?.close()
                })
                self.cameraNode.addChild(cityDialog!)
            }
                
                /*let newSize = CitySize.all.randomItem()
                let newWalls = Bool.random()
                
                selectedCity.size = newSize
                selectedCity.walls = newWalls*/
            }
            /*if let selectedUnit = self.mapNode?.gameObjectManager.selected {
                if selectedUnit.position == hex {
                    self.gameDelegate?.select(object: selectedUnit)
                }
            }*/
        //}

        self.lastFocusPoint = hex
    }
}

extension GameScene: BottomRightBarDelegate {
    
    func focus(on point: HexPoint) {
        self.centerCamera(on: point)
    }
}

extension GameScene: GameConditionDelegate {

    func won(with type: GameConditionType) {
        print("--- won with \(type) ---")

        if let victoryDialog = UI.victoryDialog() {
            victoryDialog.set(text: type.summary, identifier: "summary")
            victoryDialog.addOkayAction(handler: {
                
                self.game?.saveScore()
                self.game?.cancel()
                self.game = nil
                
                self.gameDelegate?.quitGame()
            })

            self.cameraNode.addChild(victoryDialog)
        }
    }

    func lost(with type: GameConditionType) {
        print("--- lost with \(type) ---")

        if let defeatDialog = UI.defeatDialog() {
            defeatDialog.set(text: type.summary, identifier: "summary")
            defeatDialog.addOkayAction(handler: {
                
                self.game?.cancel()
                self.game = nil
                
                self.gameDelegate?.quitGame()
            })

            self.cameraNode.addChild(defeatDialog)
        }
    }
}

extension GameScene: GameUpdateDelegate {
    
    func updateUI() {
        
        if let time = self.game?.timeRemainingInSeconds() {
            self.timeLabel.text = Formatters.Dates.getString(from: time)
        }
        
        if let coins = self.game?.coins {
            let coinText = Formatters.Numbers.getCoinString(from: coins)
            self.coinLabel.text = coinText
        }
        
        if let boosterStock = self.game?.boosterStock {
            if boosterStock.isAvailable(boosterType: .telescope) {
                self.boosterNodeTelescope?.enable()
            } else {
                self.boosterNodeTelescope?.disable()
            }
            
            if boosterStock.isAvailable(boosterType: .time) {
                self.boosterNodeTime?.enable()
            } else {
                self.boosterNodeTime?.disable()
            }
        }
    }
}

extension GameScene: GameObjectUnitDelegate {
    
    func selectedGameObjectChanged(to gameObject: GameObject?) {
        if let newPosition = gameObject?.position {
            self.centerCamera(on: newPosition)
            self.moveFocus(to: newPosition)
        }
    }
    
    func removed(gameObject: GameObject?) {
        // NOOP
    }
}

extension GameScene: BoosterActivationDelegate {
    
    func activated(boosterType: BoosterType) {
        self.game?.start(boosterType: boosterType)
        self.updateUI()
    }
}
