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

    /*
    // Returns a CGRect that has the dimensions and position for any device with respect to any
     // specified scene. This will result in a boundary that can be utilised for positioning nodes
     // on a scene so that they are always visible
    func getVisibleScreen( sceneBounds: CGRect, viewBounds: CGSize) -> CGRect {
        var sceneHeight = sceneBounds.height
        var sceneWidth = sceneBounds.width
        let viewHeight = viewBounds.height
        let viewWidth = viewBounds.width
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        let deviceAspectRatio = viewWidth/viewHeight
        let sceneAspectRatio = sceneWidth/sceneHeight
        
        // If the the device's aspect ratio is smaller than the aspect ratio of the preset scene dimensions,
        // then that would mean that the visible width will need to be calculated
        // as the scene's height has been scaled to match the height of the device's screen.
        // To keep the aspect ratio of the scene this will mean that the width of the scene will extend
        // out from what is visible.
        // The opposite will happen in the device's aspect ratio is larger.
        if deviceAspectRatio < sceneAspectRatio {
            let newSceneWidth: CGFloat = (sceneWidth * viewHeight) / sceneHeight
            let sceneWidthDifference: CGFloat = (newSceneWidth - viewWidth)/2
            let diffPercentageWidth: CGFloat = sceneWidthDifference / (newSceneWidth)
            
            //Increase the x-offset by what isn't visible from the lrft of the scene
            x = diffPercentageWidth * sceneWidth
            //Multipled by 2 because the diffPercentageHeight is only accounts for one side(e.g right or left) not both
            sceneWidth = sceneWidth - (diffPercentageWidth * 2 * sceneWidth)
        } else {
            let newSceneHeight: CGFloat = (sceneHeight * viewWidth) / sceneWidth
            let sceneHeightDifference: CGFloat = (newSceneHeight - viewHeight)/2
            let diffPercentageHeight: CGFloat = fabs(sceneHeightDifference / (newSceneHeight))
            
            //Increase the y-offset by what isn't visible from the bottom of the scene
            y = diffPercentageHeight * sceneHeight
            //Multipled by 2 because the diffPercentageHeight is only accounts for one side(e.g top or bottom) not both
            sceneHeight = sceneHeight - (diffPercentageHeight * 2 * sceneHeight)
        }
        
        let visibleScreenOffset = CGRect(x: CGFloat(x),
            y: CGFloat(y),
            width: CGFloat(sceneWidth),
            height: CGFloat(sceneHeight))
        return visibleScreenOffset
    }
    */

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

        guard let gameModel = self.viewModel?.game else {
            return
        }

        // only check once per 0.5 sec
        if self.lastExecuted + 0.5 < currentTime {

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

        if self.viewModel?.refreshCities ?? false {

            //self.mapNode?.unitLayer.populate(with: gameModel)
            for player in gameModel.players {
                for city in gameModel.cities(of: player) {
                    self.mapNode?.cityLayer.update(city: city)
                }
            }

            self.viewModel?.refreshCities = false
        }

        if let center = self.viewModel?.centerOn {
            self.center(on: center)
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

    /*func center(on point: CGPoint) {
        
        let centerAction = SKAction.move(to: point, duration: 0.5)
        self.cameraNode.run(centerAction)
    }*/

    var currentCenter: CGPoint {

        return self.cameraNode.position
    }

    func center(on hex: HexPoint) {

        let screenPosition = HexPoint.toScreen(hex: hex)

        let centerAction = SKAction.move(to: screenPosition, duration: 0.3)
        self.cameraNode.run(centerAction)

        // Debug

        /*print("camera frame: \(self.cameraNode.frame)")
        print("camera zoom: \(self.currentZoom)")
        
        let sceneRect = self.viewHex!.calculateAccumulatedFrame()
        let visibleRect = self.getVisibleScreen(sceneBounds: sceneRect, viewBounds: self.view!.bounds.size)
        print("visibleRect: \(visibleRect)")*/

        //self.viewModel.gameEnvironment.change(visibleRect: CGRect)
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
        var selectedCity: Bool = false
        var selectedUnit: Bool = false

        if event.clickCount >= 2 {
            // double tap opens city
            if let city = game.city(at: position) {

                if humanPlayer.isEqual(to: city.player) {
                    self.showScreen(screenType: .city, city: city, other: nil, data: nil)
                    return
                }
            }
        } else {

            if let city = game.city(at: position) {
                if humanPlayer.isEqual(to: city.player) {
                    self.select(city: city)
                    selectedCity = true
                }
            }

            // problem: cities can have more units
            for unitRef in game.units(of: humanPlayer, at: position) {

                guard let unit = unitRef else {
                    continue
                }

                self.select(unit: unit)
                selectedUnit = true
            }

            /*if let combatUnit = game.unit(at: position, of: .combat) {
                if humanPlayer.isEqual(to: combatUnit.player) {
                    self.select(unit: combatUnit)
                    selectedUnit = true
                }
            } else if let civilianUnit = game.unit(at: position, of: .civilian) {
                if humanPlayer.isEqual(to: civilianUnit.player) {
                    self.select(unit: civilianUnit)
                    selectedUnit = true
                }
            }*/
        }

        if !selectedCity && !selectedUnit {
            self.unselect()
        }
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
                pathFinder.dataSource = self.viewModel?.game?.unitAwarePathfinderDataSource(
                    for: selectedUnit.movementType(),
                    for: selectedUnit.player,
                    unitMapType: selectedUnit.unitMapType(),
                    canEmbark: selectedUnit.canEverEmbark()
                )

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

            // notify overview
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

            guard let unitSelectionMode = self.viewModel?.unitSelectionMode else {
                fatalError("cant get selection mode")
            }

            switch unitSelectionMode {

            case .pick:
                self.mapNode?.unitLayer.clearPathSpriteBuffer()

                if selectedUnit.location != position {

                    let unitMission = UnitMission(type: .moveTo, buildType: nil, at: position, options: .none)
                    selectedUnit.push(mission: unitMission, in: self.viewModel?.game)

                    self.mapNode?.unitLayer.hideFocus()
                    self.updateCommands(for: selectedUnit)
                }

            case .meleeTarget:
                if let unitToAttack = self.viewModel?.game?.unit(at: position, of: .combat) {

                    self.viewModel?.delegate?.showCombatBanner(for: selectedUnit, and: unitToAttack)
                }

            case .rangedTarget:

                // NOOP
            break
            }

        }

        self.previousLocation = .zero
    }

    override func scrollWheel(with event: NSEvent) {
        print("scroll")
    }

    func updateCommands(for unit: AbstractUnit?) {

        guard let sceneCombatMode = self.viewModel?.unitSelectionMode else {
            return
        }

        if let unit = unit {

            switch sceneCombatMode {

            case .pick:
                let commands = unit.commands(in: self.viewModel?.game)
                self.viewModel?.delegate?.selectedUnitChanged(to: unit, commands: commands, in: self.viewModel?.game)

            case .meleeTarget, .rangedTarget:
                let commands = [Command(type: .cancelAttack, location: HexPoint.invalid)]
                self.viewModel?.delegate?.selectedUnitChanged(to: unit, commands: commands, in: self.viewModel?.game)
            }
        } else {
            self.viewModel?.delegate?.selectedUnitChanged(to: unit, commands: [], in: nil)
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
