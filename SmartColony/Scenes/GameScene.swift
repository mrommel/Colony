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

class GameScene: BaseScene {
    
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
    
    // view model
    var viewModel: GameSceneViewModel?
    
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
        self.safeAreaNode.addChild(self.bottomLeftBar!)
        self.bottomRightBar = BottomRightBar(for: viewModel.game, sized: CGSize(width: 200, height: 112))
        //self.bottomRightBar?.delegate = self
        self.safeAreaNode.addChild(self.bottomRightBar!)

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

        //self.coinIconLabel.position = CGPoint(x: -30, y: self.frame.halfHeight - 43)
        //self.coinLabel.position = CGPoint(x: 0, y: self.frame.halfHeight - 50)
        //self.timeLabel.position = CGPoint(x: self.frame.halfWidth - 50, y: self.frame.halfHeight - 50)

        self.bottomLeftBar?.position = CGPoint(x: -self.safeAreaNode.frame.halfWidth, y: -self.safeAreaNode.frame.halfHeight)
        self.bottomLeftBar?.updateLayout()

        self.bottomRightBar?.position = CGPoint(x: self.safeAreaNode.frame.halfWidth, y: -self.safeAreaNode.frame.halfHeight)
        self.bottomRightBar?.updateLayout()

        //self.menuButton?.position = CGPoint(x: -self.safeAreaNode.frame.halfWidth + 35, y: self.safeAreaNode.frame.halfHeight - 35)
        //self.turnButton?.position = CGPoint(x: self.safeAreaNode.frame.halfWidth - 50, y: -self.safeAreaNode.frame.halfHeight + 112 + 21)
    }
    
    func zoom(to zoomScale: Double) {
        let zoomInAction = SKAction.scale(to: CGFloat(zoomScale), duration: 0.1)
        self.cameraNode.run(zoomInAction)
    }
    
    // MARK: touch handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first!
        let touchLocation = touch.location(in: self.viewHex)
        let position = HexPoint(screen: touchLocation)

        /*guard let units = self.game?.getUnits(at: position) else {
            fatalError("cant get units at \(position)")
        }

        if touch.force > self.forceTouchLevel {
            // force touch
            print("force touch: \(touch.force)")

            let target = self.target(at: position)

            if let newTarget = target {

                self.selectedUnitForAttack = newTarget
                self.showAttackSymbol(at: position, real: true)
                return
            } else {

                self.showAttackSymbol(at: position, real: false)
                return
            }
        }

        if units.count > 0 {

            let unit = units.first!
            if unit?.civilization == user.civilization {
                self.selectedUnitForMovement = unit
                self.selectedUnitForMovement?.gameObject?.showFocus()
                return
            }
        }

        self.selectedUnitForMovement?.gameObject?.hideFocus()
        self.selectedUnitForMovement = nil*/
    }

    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first!

        let touchLocation = touch.location(in: self.viewHex)
        let position = HexPoint(screen: touchLocation)

        /*if touch.force > self.forceTouchLevel {
            // force touch
            let target = self.target(at: position)

            if let newTarget = target {

                self.selectedUnitForAttack = newTarget
                self.showAttackSymbol(at: position, real: true)
                return
            } else {

                self.selectedUnitForAttack = nil
                self.showAttackSymbol(at: position, real: false)
                return
            }
        }

        if let selectedUnit = self.selectedUnitForMovement {

            if position != selectedUnit.position {

                let pathFinder = AStarPathfinder()
                pathFinder.dataSource = self.game?.pathfinderDataSource(for: selectedUnit.unitType.movementType, civilization: selectedUnit.civilization, ignoreSight: false)

                if let path = pathFinder.shortestPath(fromTileCoord: selectedUnit.position, toTileCoord: position) {
                    path.prepend(point: selectedUnit.position, cost: 0.0)
                    selectedUnit.gameObject?.show(path: path)
                } else {
                    selectedUnit.gameObject?.clearPathSpriteBuffer()
                }
            }
        } else {*/

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
        //}
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
            self.bottomLeftBar?.touchesEnded(touches, with: event)
            return
        }

        /*if let selectedUnit = self.selectedUnitForAttack {

            self.showBattleDialog(between: self.game?.getSelectedUnitOfUser(), and: selectedUnit)
            self.selectedUnitForAttack = nil
        }

        if let selectedUnit = self.selectedUnitForMovement {
            selectedUnit.gameObject?.clearPathSpriteBuffer()
            selectedUnit.gameObject?.hideFocus()
            self.mapNode?.moveSelectedUnit(to: position)
        }
        self.selectedUnitForMovement = nil

        self.hideAttackSymbol()*/
    }
}
