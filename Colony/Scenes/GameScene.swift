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
            static let caldera: CGFloat = 1.5
            static let area: CGFloat = 2.0
            static let focus: CGFloat = 3.0
            static let feature: CGFloat = 4.0
            static let road: CGFloat = 4.1
            static let river: CGFloat = 4.2
            static let featureUpper: CGFloat = 4.5
            static let staticSprite: CGFloat = 5.0
            static let sprite: CGFloat = 6.0
            static let labels: CGFloat = 50.0
        }

        struct Visibility {
            static let currently: CGFloat = 1.0
            static let discovered: CGFloat = 0.5
        }
    }

    var viewModel: GameSceneViewModel?

    // UI
    var safeAreaNode: SafeAreaNode
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
    let coinLabel = SKLabelNode(text: "0000")
    let timeLabel = SKLabelNode(text: "0:00")
    var hasMoved = false

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

        let deviceScale = self.size.width / 667

        guard let viewModel = self.viewModel else {
            fatalError("no ViewModel")
        }

        // camera
        self.cameraNode = SKCameraNode() //initialize and assign an instance of SKCameraNode to the cam variable.

        //the scale sets the zoom level of the camera on the given position
        self.cameraNode.xScale = 0.25
        self.cameraNode.yScale = 0.25

        self.camera = cameraNode //set the scene's camera to reference cam
        self.addChild(cameraNode) //make the cam a childElement of the scene itself.

        // the safeAreaNode holds the UI
        self.cameraNode.addChild(self.safeAreaNode)
        self.safeAreaNode.updateLayout()

        switch viewModel.type {

        case .level:

            guard let levelURL = viewModel.levelURL else {
                fatalError("no level url")
            }

            guard let level = LevelManager.loadLevelFrom(url: levelURL) else {
                fatalError("no level")
            }
            
            self.game = Game(with: level)

            self.mapNode = MapNode(with: level)
            self.bottomLeftBar = BottomLeftBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar = BottomRightBar(for: level, sized: CGSize(width: 200, height: 112))

            self.showLevel(title: level.title, summary: level.summary)

        case .generator:

            guard let map = viewModel.map else {
                fatalError()
            }

            let startPositionFinder = StartPositionFinder(map: map)
            let startPositions = startPositionFinder.identifyStartPositions()
            
            let gameObjectManager = GameObjectManager(on: map)

            let level = Level(number: 0, title: "Generator", summary: "Dummy", difficulty: .easy, map: map, startPositions: startPositions, gameObjectManager: gameObjectManager)
            
            self.game = Game(with: level)

            self.mapNode = MapNode(with: level)
            self.bottomLeftBar = BottomLeftBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar = BottomRightBar(for: level, sized: CGSize(width: 200, height: 112))

            self.showLevel(title: "Free playing", summary: "Please ply free")
        }

        self.game?.conditionDelegate = self
        self.game?.gameUpdateDelegate = self
        self.game?.level?.gameObjectManager.gameObjectUnitDelegates.addDelegate(self)

        if let bottomLeftBar = self.bottomLeftBar {
            self.safeAreaNode.addChild(bottomLeftBar)
        }

        if let bottomRightBar = self.bottomRightBar {
            self.safeAreaNode.addChild(bottomRightBar)
        }

        viewHex.position = CGPoint(x: self.size.width * 0, y: self.size.height * 0.5) // FIXME ???
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

        // exit node
        self.exitButton = MessageBoxButtonNode(titled: "Cancel", buttonAction: {
            self.showQuitConfirmationDialog()
        })
        self.exitButton?.position = CGPoint(x: 0, y: frame.size.height - headerHeight)
        self.exitButton?.zPosition = 200

        if let exitButton = self.exitButton {
            self.safeAreaNode.addChild(exitButton)
        }

        if viewModel.type == .generator {
            // save node
            let saveButton = MessageBoxButtonNode(titled: "Save", buttonAction: {

                let map = self.viewModel?.map

                let startPositionFinder = StartPositionFinder(map: map)
                let startPositions = startPositionFinder.identifyStartPositions()

                let level = Level(number: 0, title: "Test", summary: "Dummy", difficulty: .easy, map: map!, startPositions: startPositions, gameObjectManager: self.mapNode!.gameObjectManager)

                LevelManager.store(level: level, to: "level000X.lvl")

            })
            saveButton.position = CGPoint(x: 0, y: frame.size.height - headerHeight - 40)
            saveButton.zPosition = 200
            self.safeAreaNode.addChild(saveButton)
        }

        // debug
        self.coinLabel.fontSize = 18
        self.coinLabel.zPosition = GameScene.Constants.ZLevels.labels
        self.safeAreaNode.addChild(self.coinLabel)
        
        self.timeLabel.fontSize = 18
        self.timeLabel.zPosition = GameScene.Constants.ZLevels.labels
        self.safeAreaNode.addChild(self.timeLabel)

        // focus on ship
        if let mapNode = self.mapNode {
            if let selectedUnit = mapNode.gameObjectManager.selected {
                self.centerCamera(on: selectedUnit.position)
                self.moveFocus(to: selectedUnit.position)
            }
        }
        
        self.updateLayout()
    }

    func updateLayout() {

        self.safeAreaNode.updateLayout()

        self.frameTopLeft?.position = CGPoint(x: -self.frame.halfWidth, y: self.frame.halfHeight)
        self.frameTopRight?.position = CGPoint(x: self.frame.halfWidth, y: self.frame.halfHeight)
        self.frameBottomLeft?.position = CGPoint(x: -self.frame.halfWidth, y: -self.frame.halfHeight)
        self.frameBottomRight?.position = CGPoint(x: self.frame.halfWidth, y: -self.frame.halfHeight)

        self.coinLabel.position = CGPoint(x: 0, y: self.frame.halfHeight - 50)
        self.timeLabel.position = CGPoint(x: self.frame.halfWidth - 50, y: self.frame.halfHeight - 50)
        
        self.bottomLeftBar?.position = CGPoint(x: -self.safeAreaNode.frame.halfWidth, y: -self.safeAreaNode.frame.halfHeight)
        self.bottomLeftBar?.updateLayout()

        self.bottomRightBar?.position = CGPoint(x: self.safeAreaNode.frame.halfWidth, y: -self.safeAreaNode.frame.halfHeight)
        self.bottomRightBar?.updateLayout()
    }

    func showQuitConfirmationDialog() {

        if let quitConfirmationDialog = UI.quitConfirmationDialog() {

            quitConfirmationDialog.zPosition = 250
            quitConfirmationDialog.addOkayAction(handler: {
                quitConfirmationDialog.close()
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

                // start timer
                self.game?.start()
            })

            self.cameraNode.addChild(levelIntroductionDialog)
        }
    }

    func placeFocusHex() {

        self.focus = SKSpriteNode(imageNamed: "hex_cursor")
        self.focus?.position = HexMapDisplay.shared.toScreen(hex: HexPoint(x: 0, y: 0))
        self.focus?.zPosition = GameScene.Constants.ZLevels.focus
        self.focus?.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.focus?.xScale = 1.0
        self.focus?.yScale = 1.0
        viewHex.addChild(self.focus!)
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
        //self.positionLabel.text = "\(position)"

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
            print("camera pos moved: \(self.cameraNode.position)")
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

        print("move to \(hex)")
        self.focus?.position = HexMapDisplay.shared.toScreen(hex: hex)

        self.mapNode?.moveShip(to: hex)

        if hex == self.lastFocusPoint {

            if let selectedUnit = self.mapNode?.gameObjectManager.selected {
                if selectedUnit.position == hex {
                    self.gameDelegate?.select(object: selectedUnit)
                }
            }
        }

        self.lastFocusPoint = hex
    }
}

extension GameScene: GameConditionDelegate {

    func won(with type: GameConditionType) {
        print("--- won with \(type) ---")

        if let victoryDialog = UI.victoryDialog() {
            victoryDialog.set(text: type.summary, identifier: "summary")
            victoryDialog.addOkayAction(handler: {
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
                self.gameDelegate?.quitGame()
            })

            self.cameraNode.addChild(defeatDialog)
        }
    }
}

extension GameScene: GameUpdateDelegate {
    
    func update(time: TimeInterval) {
        
        let interval = Int(time)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        
        self.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func update(coins: Int) {
        
        let coinText = Formatters.Numbers.getCoinString(from: coins)
        
        self.coinLabel.text = coinText
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
