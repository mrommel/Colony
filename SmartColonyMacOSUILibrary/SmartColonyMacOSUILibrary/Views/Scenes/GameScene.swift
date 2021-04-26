//
//  GameScene.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SpriteKit
import SmartAILibrary

class GameSceneViewModel {
    
    var game: GameModel?
    
    init(with game: GameModel?) {
        
        self.game = game
    }
}

class GameScene: BaseScene {

    // Constants
    let forceTouchLevel: CGFloat = 2.0

    // UI variables
    internal var mapNode: MapNode?
    private let viewHex: SKSpriteNode
    
    // view model
    var viewModel: GameSceneViewModel?
    
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

        let deviceScale = self.size.width / 667

        guard let viewModel = self.viewModel else {
            return
        }
        
        guard self.mapNode == nil else {
            // already inited
            return
        }

        // the scale sets the zoom level of the camera on the given position
        self.cameraNode.xScale = CGFloat(0.8) // 0.25
        self.cameraNode.yScale = CGFloat(0.8)
        
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
    }
    
    override func updateLayout() {

        super.updateLayout()

        self.mapNode?.updateLayout()
    }

    func zoom(to zoomScale: CGFloat) {

        guard self.cameraNode != nil else {
            return
        }
        
        let zoomInAction = SKAction.scale(to: zoomScale, duration: 3.0)
        self.cameraNode.run(zoomInAction)
    }
    
    func focus(on point: HexPoint) {
        
        guard self.cameraNode != nil else {
            return
        }
        
        let screePoint = HexPoint.toScreen(hex: point) * 3.0
        
        let moveCameraAction = SKAction.move(to: CGPoint(x: screePoint.x, y: screePoint.y), duration: 3.0)
        self.cameraNode.run(moveCameraAction)
    }
}

extension GameScene {
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let touchLocation = self.convert(location, to: self.viewHex) / 3.0
        let position = HexPoint(screen: touchLocation)
        print("position clicked: \(position)")
    }
}
