//
//  GameScene.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

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
    private var viewHex: SKSpriteNode?
    var previousLocation: CGPoint = .zero
    
    // view model
    var viewModel: GameSceneViewModel?
    
    // MARK: constructors

    override init(size: CGSize) {

        super.init(size: size, layerOrdering: .nodeLayerOnTop)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: methods
    
    #if os(watchOS)
    override func sceneDidLoad() {
        self.setupScene(to: self.view)
    }
    #else
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.setupScene(to: view)
    }
    #endif

    func setupScene(to view: SKView) {

        self.viewHex = SKSpriteNode()
        self.viewHex?.name = "ViewHex"
        self.viewHex?.position = CGPoint(x: self.size.width * 0, y: self.size.height * 0.5)
        self.viewHex?.zPosition = 1.0

        self.rootNode.addChild(self.viewHex!)

        // position the camera on the gamescene.
        self.cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        // the scale sets the zoom level of the camera on the given position
        self.cameraNode.xScale = CGFloat(0.25)
        self.cameraNode.yScale = CGFloat(0.25)
        
        print("GameScene setup successful")
    }
    
    func setupMap() {
        
        guard let viewModel = self.viewModel else {
            print("no view model yet")
            return
        }
        
        guard self.mapNode == nil else {
            // already inited
            return
        }

        self.mapNode = MapNode(with: viewModel.game)
        self.viewHex?.addChild(self.mapNode!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func updateLayout() {

        super.updateLayout()

        self.mapNode?.updateLayout()
    }
    
    func zoom(to zoomScale: CGFloat) {

        let zoomInAction = SKAction.scale(to: zoomScale, duration: 1.0)
        self.cameraNode.run(zoomInAction)
    }
    
    var currentZoom: CGFloat {
        
        return self.cameraNode.xScale
    }
    
    func center(on point: CGPoint) {
        
        let centerAction = SKAction.move(to: point, duration: 1.0)
        self.cameraNode.run(centerAction)
    }
    
    var currentCenter: CGPoint {
        
        return self.cameraNode.position
    }
}

extension GameScene {
    
    override func mouseDown(with event: NSEvent) {
        
        let location = event.location(in: self)
        let touchLocation = self.convert(location, to: self.viewHex!) // / 3.0
        
        if touchLocation.x.isNaN || touchLocation.y.isNaN {
            return
        }
        
        let position = HexPoint(screen: location)
        print("position clicked: \(position)")
    }
    
    override func mouseDragged(with event: NSEvent) {

        if self.previousLocation == .zero {
            
            self.previousLocation = event.location(in: self)
            return
        }
        
        let touchLocation = event.location(in: self)
        print("clicked at: \(touchLocation)")

        let deltaX = (touchLocation.x) - (self.previousLocation.x)
        let deltaY = (touchLocation.y) - (self.previousLocation.y)

        self.cameraNode.position.x -= deltaX * 0.7
        self.cameraNode.position.y -= deltaY * 0.7
        
        self.previousLocation = event.location(in: self)
    }
    
    override func mouseUp(with event: NSEvent) {

        self.previousLocation = .zero
    }
    
    override func scrollWheel(with event: NSEvent) {
        print("scroll")
    }
}

extension GameScene {
    
    func showHexCoords() {
        
        self.mapNode?.showHexCoords()
    }
    
    func hideHexCoords() {
        
        self.mapNode?.hideHexCoords()
    }
    
    func showCompleteMap() {
        
        self.mapNode?.showCompleteMap()
    }
    
    func showVisibleMap() {
        
        self.mapNode?.showVisibleMap()
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
    
    func showResourceMarkers() {
        
        self.mapNode?.showResourceMarker()
    }
    
    func hideResourceMarkers() {
        
        self.mapNode?.hideResourceMarker()
    }
}
