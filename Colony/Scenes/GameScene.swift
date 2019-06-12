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
    
    var map: HexagonTileMap? = nil
    
    var mapNode: MapNode?
    let viewHex: SKSpriteNode
    
    var focus: SKSpriteNode?
    var lastFocusPoint: HexPoint = HexPoint(x: 0, y: 0)
    
    var cameraNode: SKCameraNode!
    let positionLabel = SKLabelNode(fontNamed: "Chalkduster")
    var hasMoved = false
    
    let mapDisplay = HexMapDisplay()
    
    weak var gameDelegate: GameDelegate?
    
    override init(size: CGSize) {
        
        viewHex = SKSpriteNode()
        
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.2)
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
        
        let mapSize = CGSize(width: self.map?.tiles.columns ?? 1, height: self.map?.tiles.rows ?? 1)
        self.mapNode = MapNode(with: mapSize, map: self.map)
        self.mapNode?.xScale = 1.0
        self.mapNode?.yScale = 1.0
        self.mapNode?.gameObjectManager.conditionDelegate = self
        
        viewHex.position = CGPoint(x: self.size.width * 0, y: self.size.height * 0.25)
        viewHex.xScale = deviceScale
        viewHex.yScale = deviceScale
        viewHex.addChild(self.mapNode!)
        self.addChild(viewHex)
        
        self.placeFocusHex()
        
        // camera
        self.cameraNode = SKCameraNode() //initialize and assign an instance of SKCameraNode to the cam variable.
        self.cameraNode.xScale = 0.25
        self.cameraNode.yScale = 0.25 //the scale sets the zoom level of the camera on the given position
        
        self.camera = cameraNode //set the scene's camera to reference cam
        self.addChild(cameraNode) //make the cam a childElement of the scene itself.
        
        // position the camera on the gamescene.
        self.cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        // exit node
        let exitButton = MessageBoxButtonNode(titled: "Cancel", buttonAction: {
            self.showQuitConfirmationDialog()
        })
        exitButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 20)
        exitButton.zPosition = 200
        //exitButton.setScale(0.2)
        self.cameraNode.addChild(exitButton)
        
        // debug
        self.positionLabel.text = String("0, 0")
        self.positionLabel.fontSize = 10
        self.positionLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.positionLabel.zPosition = GameScene.Constants.ZLevels.labels
        
        self.cameraNode.addChild(self.positionLabel)
        
        // focus on ship
        if let mapNode = self.mapNode {
            let shipPosition = mapDisplay.toScreen(hex: mapNode.ship.position)
            var newCameraFocus = cameraNode.convert(shipPosition, to: self.viewHex)
            
            // FIXME: hm, not sure why this is needed
            newCameraFocus.x = newCameraFocus.x + 2.0
            newCameraFocus.y = newCameraFocus.y + 80.0
            
            self.cameraNode.position = newCameraFocus
        }
    }
    
    func showQuitConfirmationDialog() {
        
        if let quitConfirmationDialog = UI.quitConfirmationDialog() {
            
            quitConfirmationDialog.zPosition = 250
            print(quitConfirmationDialog.position)
            //quitConfirmationDialog.position = CGPoint(x: -150, y: 0)

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
    
    func placeFocusHex() {
        
        self.focus = SKSpriteNode(imageNamed: "hex_cursor")
        self.focus?.position = mapDisplay.toScreen(hex: HexPoint(x: 0, y: 0))
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
        
        let position = HexPoint(cube: mapDisplay.toHexCube(screen: touchLocation))
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
            
            self.cameraNode.position.x -= deltaX * 0.5
            self.cameraNode.position.y -= deltaY * 0.5
        }
    }
    
    func zoom(to zoomScale: CGFloat) {
        let zoomInAction = SKAction.scale(to: zoomScale, duration: 0.1)
        self.cameraNode.run(zoomInAction)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func moveFocus(to hex: HexPoint) {
        
        print("move to \(hex)")
        self.focus?.position = mapDisplay.toScreen(hex: hex)
        
        self.mapNode?.moveShip(to: hex)

        if hex == self.lastFocusPoint {
            
            if self.mapNode?.ship.position == hex {
                self.gameDelegate?.select(object: self.mapNode?.ship)
            }
        }
        
        self.lastFocusPoint = hex
    }
}

extension GameScene: GameConditionDelegate {
    
    func won(with type: GameConditionType) {
        print("--- won ---")
        
        if let victoryDialog = UI.victoryDialog() {
            
            victoryDialog.addOkayAction(handler: {
                self.gameDelegate?.quitGame()
            })
            
            self.cameraNode.addChild(victoryDialog)
        }
    }
    
    func lost(with type: GameConditionType) {
        print("--- lost ---")
        
        if let defeatDialog = UI.defeatDialog() {
            
            defeatDialog.addOkayAction(handler: {
                self.gameDelegate?.quitGame()
            })
            
            self.cameraNode.addChild(defeatDialog)
        }
    }
}
