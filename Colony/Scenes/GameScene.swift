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
    }

    var mapNode: MapNode?
    let viewHex: SKSpriteNode
    
    var focus: SKSpriteNode?
    var lastFocusPoint: HexPoint = HexPoint(x: 0, y: 0)
    
    var cameraNode: SKCameraNode!
    let positionLabel = SKLabelNode(fontNamed: "Chalkduster")
    
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
        
        let mapSize = CGSize(width: 20, height: 20)
        self.mapNode = MapNode(with: mapSize)
        self.mapNode?.xScale = 1.0
        self.mapNode?.yScale = 1.0
        
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
            self.addMessageBox()
        })
        exitButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        exitButton.zPosition = 200
        //exitButton.setScale(0.2)
        self.cameraNode.addChild(exitButton)
        
        // debug
        self.positionLabel.text = String("0, 0")
        self.positionLabel.fontSize = 10
        self.positionLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.positionLabel.zPosition = GameScene.Constants.ZLevels.labels
        
        self.cameraNode.addChild(self.positionLabel)
    }
    
    func addMessageBox() {
        let messageBox = MessageBoxNode(titled: "Cancel", message: "Do you really want to quit?")
        messageBox.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        messageBox.zPosition = 250
        messageBox.addAction(MessageBoxAction(title: "Cancel", type: .left, handler: {
            messageBox.dismiss()
        }))
        messageBox.addAction(MessageBoxAction(title: "Okay", type: .right, handler: {
            self.gameDelegate?.quitGame()
            messageBox.dismiss()
        }))
        self.cameraNode.addChild(messageBox)
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        var touchLocation = touch.location(in: self.viewHex)
        
        // FIXME: hm, not sure why this is needed
        touchLocation.x -= 20
        touchLocation.y -= 15
        
        let position = HexPoint(cube: mapDisplay.toHexCube(screen: touchLocation))
        self.positionLabel.text = "\(position)"
        
        self.moveFocus(to: position)
    }
    
    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self.viewHex)
            let previousLocation = touch.previousLocation(in: self.viewHex)
            
            let deltaX = (location.x) - (previousLocation.x)
            let deltaY = (location.y) - (previousLocation.y)
            
            self.cameraNode.position.x -= deltaX * 0.5
            self.cameraNode.position.y -= deltaY * 0.5
        }
    }
    
    func zoom(to zoomScale: CGFloat) {
        let zoomInAction = SKAction.scale(to: zoomScale, duration: 0.3)
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
        
        /*if let currentFocusedObject = self.engine?.focusedObject {
            if currentFocusedObject.state == GameObjectActions.walk {
                
                if let path = self.findPathFrom(from: currentFocusedObject.position, to: hex) {
                    currentFocusedObject.walk(on: path)
                    return
                }
            }
        }
        
        if let focusedObject = self.engine?.object(at: hex) {
            
            if focusedObject != self.engine?.focusedObject {
                self.engine?.focusedObject = focusedObject
                print("new focused object: \(focusedObject.identifier)")
            } else {
                if let actions = self.engine?.focusedObject?.actions() {
                    showActionPicker(for: (self.engine?.focusedObject!)!, with: actions)
                }
            }
        }*/
        
        self.lastFocusPoint = hex
    }
}
