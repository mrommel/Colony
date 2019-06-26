//
//  GameScene.swift
//  Colony
//
//  Created by Michael Rommel on 26.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import GameplayKit

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

    var mapNode: MapNode?
    var mapOverviewNode: MapOverviewNode?
    let viewHex: SKSpriteNode

    var focus: SKSpriteNode?
    var lastFocusPoint: HexPoint = HexPoint(x: 0, y: 0)

    var cameraNode: SKCameraNode!
    let positionLabel = SKLabelNode(fontNamed: "Chalkduster")
    var hasMoved = false

    weak var gameDelegate: GameDelegate?

    override init(size: CGSize) {

        viewHex = SKSpriteNode()

        super.init(size: size)
        //self.anchorPoint = CGPoint(x: 0.0, y: 0.0) // 0.2
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

        switch viewModel.type {

        case .level:

            guard let levelURL = viewModel.levelURL else {
                fatalError("no level url")
            }

            guard let level = LevelManager.loadLevelFrom(url: levelURL) else {
                fatalError("no level")
            }

            self.mapNode = MapNode(with: level)
            
            self.mapOverviewNode = MapOverviewNode(with: level.map, size: CGSize(width: 100, height: 100))
            
            self.showLevel(title: level.title, summary: level.summary)
            
        case .generator:
            self.mapNode = MapNode(with: viewModel.map)
            
            self.mapOverviewNode = MapOverviewNode(with: viewModel.map, size: CGSize(width: 100, height: 100))
        }

        self.mapNode?.xScale = 1.0
        self.mapNode?.yScale = 1.0
        self.mapNode?.gameObjectManager.conditionDelegate = self
        
        let mapOverviewBodyTexture = SKTexture(imageNamed: "map_overview_body")
        let mapOverviewBody = SKSpriteNode(texture: mapOverviewBodyTexture, color: .black, size: CGSize(width: 110, height: 105))
        mapOverviewBody.position = CGPoint(x: 0, y: -self.frame.halfHeight + 100)
        mapOverviewBody.zPosition = 49
        self.cameraNode.addChild(mapOverviewBody)
        
        self.mapOverviewNode?.position = CGPoint(x: 0, y: -self.frame.halfHeight + 100)
        self.mapOverviewNode?.zPosition = 50
        self.cameraNode.addChild(self.mapOverviewNode!)

        viewHex.position = CGPoint(x: self.size.width * 0, y: self.size.height * 0.5)
        viewHex.xScale = deviceScale
        viewHex.yScale = deviceScale
        viewHex.addChild(self.mapNode!)
        self.addChild(viewHex)

        self.placeFocusHex()

        // position the camera on the gamescene.
        self.cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)

        // header (with timer)
        let headerBackground = SKSpriteNode(imageNamed: "header")
        headerBackground.position = CGPoint(x: -self.frame.halfWidth, y: frame.size.height)
        headerBackground.zPosition = 2
        headerBackground.size = CGSize(width: frame.size.width, height: headerHeight)
        headerBackground.anchorPoint = CGPoint(x: 0, y: 1.0)
        self.cameraNode.addChild(headerBackground)
        
        let frameLeft = SKSpriteNode(imageNamed: "frame_left")
        frameLeft.position = CGPoint(x: -self.frame.halfWidth, y: frame.size.height - headerHeight)
        frameLeft.zPosition = 2
        frameLeft.anchorPoint = CGPoint(x: 0, y: 1.0)
        self.cameraNode.addChild(frameLeft)
        
        let frameRight = SKSpriteNode(imageNamed: "frame_right")
        frameRight.position = CGPoint(x: self.frame.halfWidth, y: frame.size.height - headerHeight)
        frameRight.zPosition = 2
        frameRight.anchorPoint = CGPoint.upperRight
        self.cameraNode.addChild(frameRight)
        
        // exit node
        let exitButton = MessageBoxButtonNode(titled: "Cancel", buttonAction: {
            self.showQuitConfirmationDialog()
        })
        exitButton.position = CGPoint(x: 0, y: frame.size.height - headerHeight)
        exitButton.zPosition = 200
        self.cameraNode.addChild(exitButton)

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
            self.cameraNode.addChild(saveButton)
        }

        // debug
        self.positionLabel.text = String("0, 0")
        self.positionLabel.fontSize = 10
        self.positionLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.positionLabel.zPosition = GameScene.Constants.ZLevels.labels

        self.cameraNode.addChild(self.positionLabel)

        // focus on ship
        if let mapNode = self.mapNode {
            if let ship = mapNode.gameObjectManager.unitBy(identifier: "ship") {
               self.centerCamera(to: ship.position)
            }
        }
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
                self.mapNode?.gameObjectManager.start()
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
        var touchLocation = touch.location(in: self.viewHex)

        // FIXME: hm, not sure why this is needed
        touchLocation.x -= 20
        touchLocation.y -= 15

        let position = HexMapDisplay.shared.toHexPoint(screen: touchLocation)
        self.positionLabel.text = "\(position)"

        if !self.hasMoved {
            self.moveFocus(to: position)
        }
    }

    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self.viewHex)
            let previousLocation = touch.previousLocation(in: self.viewHex)

            let deltaX = (location.x) - (previousLocation.x)
            let deltaY = (location.y) - (previousLocation.y)

            if abs(deltaX) > 0.1 || abs(deltaY) > 0.1 {
                self.hasMoved = true
            }

            self.cameraNode.position.x -= deltaX * 0.7
            self.cameraNode.position.y -= deltaY * 0.7
            print("camera pos: \(self.cameraNode.position)")
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
    
    func centerCamera(to hex: HexPoint) {

        let screenPosition = HexMapDisplay.shared.toScreen(hex: hex)
        var newCameraFocus = cameraNode.convert(screenPosition, to: self.viewHex)
        
        // FIXME: hm, not sure why this is needed
        newCameraFocus.x = newCameraFocus.x - 270
        newCameraFocus.y = newCameraFocus.y + 350
        
        self.cameraNode.position = newCameraFocus
        print("center camera on: \(newCameraFocus)")
        
        // bad: (575.6199340820312, -176.4716796875) - 250
        // good: (300, 100)
    }

    func moveFocus(to hex: HexPoint) {

        print("move to \(hex)")
        self.focus?.position = HexMapDisplay.shared.toScreen(hex: hex)

        self.mapNode?.moveShip(to: hex)

        if hex == self.lastFocusPoint {

            if let ship = self.mapNode?.gameObjectManager.unitBy(identifier: "ship") {
                if ship.position == hex {
                    self.gameDelegate?.select(object: ship)
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
