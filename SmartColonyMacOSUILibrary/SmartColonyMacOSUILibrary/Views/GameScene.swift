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

        //let viewSize = (self.view?.bounds.size)!
        let deviceScale = self.size.width / 667

        guard let viewModel = self.viewModel else {
            //fatalError("no ViewModel")
            return
        }
        
        guard self.mapNode == nil else {
            // already inited
            return
        }

        // the scale sets the zoom level of the camera on the given position
        self.cameraNode.xScale = CGFloat(0.8) // 0.25
        self.cameraNode.yScale = CGFloat(0.8)
        
        //let screenSize = NSScreen.main?.frame.size ?? .zero
        //let screenWidth = screenSize.width
        
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

    func zoom(to zoomScale: Double) {

        let zoomInAction = SKAction.scale(to: CGFloat(zoomScale), duration: 0.1)
        self.cameraNode.run(zoomInAction)
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
