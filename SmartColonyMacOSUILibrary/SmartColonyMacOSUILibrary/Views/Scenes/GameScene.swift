//
//  GameScene.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class GameScene: BaseScene {

    // Constants
    let forceTouchLevel: CGFloat = 2.0

    // UI variables
    internal var mapNode: MapNode?
    private var viewHex: SKSpriteNode?
    var previousLocation: CGPoint = .zero
    var lastExecuted: TimeInterval = -1
    let queue: DispatchQueue = DispatchQueue(label: "update_queue")
    
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
        
        viewModel.game?.userInterface = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // only check once per 0.5 sec
        if self.lastExecuted + 0.5 < currentTime {

            guard let gameModel = self.viewModel?.game else {
                return
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human")
            }

            if self.viewModel!.readyUpdatingAI {

                if humanPlayer.isActive() {
                    self.viewModel?.changeUITurnState(to: .humanTurns)

                    if self.viewModel!.readyUpdatingHuman {

                        self.viewModel!.readyUpdatingHuman = false
                        self.queue.async {
                            //print("-----------> before human processing")
                            gameModel.update()
                            //print("-----------> after human processing")
                            self.viewModel!.readyUpdatingHuman = true
                        }
                    }

                } else {

                    self.viewModel!.readyUpdatingAI = false
                    self.queue.async {
                        //print("-----------> before AI processing")
                        gameModel.update()
                        //print("-----------> after AI processing")
                        self.viewModel!.readyUpdatingAI = true
                    }
                }
            }

            self.lastExecuted = currentTime
        }
        
        if let center = self.viewModel?.centerOn {
            self.center(on: center)
            self.zoom(to: 0.5)
            self.viewModel?.centerOn = nil
        }
    }
    
    override func updateLayout() {

        super.updateLayout()

        self.mapNode?.updateLayout()
    }
    
    func zoom(to zoomScale: CGFloat) {

        let zoomInAction = SKAction.scale(to: zoomScale, duration: 0.5)
        self.cameraNode.run(zoomInAction)
    }
    
    var currentZoom: CGFloat {
        
        return self.cameraNode.xScale
    }
    
    func center(on point: CGPoint) {
        
        let centerAction = SKAction.move(to: point, duration: 0.5)
        self.cameraNode.run(centerAction)
    }
    
    var currentCenter: CGPoint {
        
        return self.cameraNode.position
    }
    
    func center(on hex: HexPoint) {

        let screenPosition = HexPoint.toScreen(hex: hex)
        
        let centerAction = SKAction.move(to: screenPosition, duration: 0.5)
        self.cameraNode.run(centerAction)
    }
}

extension GameScene {
    
    override func mouseDown(with event: NSEvent) {

        guard let game = self.viewModel?.game else {
            print("cant get game")
            return
        }
        
        guard let humanPlayer = game.humanPlayer() else {
            fatalError("cant get humanPlayer")
        }
        
        let location = event.location(in: self)
        let touchLocation = self.convert(location, to: self.viewHex!) // / 3.0
        
        if touchLocation.x.isNaN || touchLocation.y.isNaN {
            return
        }
        
        let position = HexPoint(screen: location)
        
        if event.clickCount >= 2 {
            print("double click")
            // double tap opens city
            if let city = game.city(at: position) {

                if humanPlayer.isEqual(to: city.player) {
                    self.showScreen(screenType: .city, city: city, other: nil, data: nil)
                    return
                }
            }
        } else {

            if let combatUnit = game.unit(at: position, of: .combat) {
                if humanPlayer.isEqual(to: combatUnit.player) {
                    self.select(unit: combatUnit)
                    return
                }
            } else if let civilianUnit = game.unit(at: position, of: .civilian) {
                if humanPlayer.isEqual(to: civilianUnit.player) {
                    self.select(unit: civilianUnit)
                    return
                }
            }
        }

        self.unselect()
    }
    
    override func rightMouseDown(with event: NSEvent) {
        
        print("right down")
    }
    
    override func mouseMoved(with event: NSEvent) {
        print("moved")
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        if let selectedUnit = self.viewModel?.selectedUnit {
            
            let location = event.location(in: self)
            let touchLocation = self.convert(location, to: self.viewHex!)
            
            if touchLocation.x.isNaN || touchLocation.y.isNaN {
                return
            }
            
            let position = HexPoint(screen: location)
            
            if position != selectedUnit.location {

                let pathFinder = AStarPathfinder()
                pathFinder.dataSource = self.viewModel?.game?.unitAwarePathfinderDataSource(for: selectedUnit.movementType(), for: selectedUnit.player, unitMapType: selectedUnit.unitMapType(), canEmbark: selectedUnit.canEverEmbark())
                
                // update
                self.updateCommands(for: selectedUnit)
            
                if let path = pathFinder.shortestPath(fromTileCoord: selectedUnit.location, toTileCoord: position) {
                    path.prepend(point: selectedUnit.location, cost: 0.0)
                    self.mapNode?.unitLayer.show(path: path, for: selectedUnit)
                } else {
                    self.mapNode?.unitLayer.clearPathSpriteBuffer()
                }
            }
            
        } else {
            if self.previousLocation == .zero {
                
                self.previousLocation = event.location(in: self)
                return
            }
            
            let touchLocation = event.location(in: self)

            let deltaX = (touchLocation.x) - (self.previousLocation.x)
            let deltaY = (touchLocation.y) - (self.previousLocation.y)

            self.cameraNode.position.x -= deltaX * 0.7
            self.cameraNode.position.y -= deltaY * 0.7
            
            self.previousLocation = event.location(in: self)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        
        let location = event.location(in: self)
        let touchLocation = self.convert(location, to: self.viewHex!)
        
        if touchLocation.x.isNaN || touchLocation.y.isNaN {
            return
        }
        
        let position = HexPoint(screen: location)

        if let selectedUnit = self.viewModel?.selectedUnit {

            /*if self.uiCombatMode == .melee {
                
                if let unitToAttack = self.viewModel?.game?.unit(at: position, of: .combat) {
                    
                    self.bottomCombatBar?.combatPrediction(of: selectedUnit, against: unitToAttack, mode: .melee, in: self.viewModel?.game)
                }
                
            } else {*/
                
                self.mapNode?.unitLayer.clearPathSpriteBuffer()
                
                if selectedUnit.location != position {
                    self.mapNode?.unitLayer.hideFocus()
                    selectedUnit.queueMoveForVisualization(at: selectedUnit.location, in: self.viewModel?.game)
                    selectedUnit.doMoveOnPath(towards: position, previousETA: 0, buildingRoute: false, in: self.viewModel?.game)
                    self.updateCommands(for: selectedUnit)
                }
            //}
        }
        
        self.previousLocation = .zero
    }
    
    override func scrollWheel(with event: NSEvent) {
        print("scroll")
    }
    
    func updateCommands(for unit: AbstractUnit?) {
        
        guard let sceneCombatMode = self.viewModel?.sceneCombatMode else {
            return
        }
        
        if let unit = unit {
            
            switch sceneCombatMode {
                
            case .none:
                let commands = unit.commands(in: self.viewModel?.game)
                self.viewModel?.selectedUnitChanged(commands: commands, in: self.viewModel?.game)
                
            case .melee, .ranged:
                let commands = [Command(type: .cancelAttack, location: HexPoint.invalid)]
                self.viewModel?.selectedUnitChanged(commands: commands, in: self.viewModel?.game)
            }
        } else {
            self.viewModel?.selectedUnitChanged(commands: [], in: nil)
        }
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
