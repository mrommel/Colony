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
    private static let kTooltipTrigger: Double = 2.0
    private static let kTooltipDuration: Double = 2.0
    private static let kGameUpdateIntervall: Double = 0.5

    // UI variables
    internal var mapNode: MapNode?
    private var viewHex: SKSpriteNode?
    var previousLocation: CGPoint = .zero
    var lastExecuted: TimeInterval = -1
    var lastUpdated: TimeInterval = -1
    let gameUpdateBackgroundQueue: DispatchQueue = DispatchQueue(label: "gameUpdateBackgroundQueue", qos: .background, attributes: .concurrent)
    var gameUpdateMutex: Bool = true // means: can enter gameUpdate
    let pathfinderQueue: DispatchQueue = DispatchQueue(label: "pathfinderBackgroundQueue", qos: .background, attributes: .concurrent)

    var hoverLocation: HexPoint = .invalid
    var hoverTime: TimeInterval = -1

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

        guard let gameModel = self.viewModel?.gameModel else {
            print("no view model yet")
            return
        }

        let forceRebuild = self.viewModel?.shouldRebuild ?? false
        guard self.mapNode == nil || forceRebuild else {
            // already inited
            return
        }

        self.mapNode?.removeFromParent()

        self.mapNode = MapNode(with: gameModel)
        self.viewHex?.addChild(self.mapNode!)

        gameModel.userInterface = self

        gameModel.resendGoodyHutAndBarbarianCampNotifications()
    }

    override func update(_ currentTime: TimeInterval) {

        // only check once per x sec
        if self.lastExecuted + GameScene.kGameUpdateIntervall < currentTime {

            guard let gameModel = self.viewModel?.gameModel else {
                return
            }

            // mitigation
            if self.viewModel?.shouldRebuild ?? false {

                self.setupMap()
                self.viewModel?.shouldRebuild = false
            }

            // update animation checker
            let currentLeader: LeaderType = gameModel.activePlayer()?.leader ?? .none
            if let state = self.mapNode?.unitLayer.animationsAreRunning(for: currentLeader) {
                self.viewModel?.animationsAreRunning = state
            } else {
                self.viewModel?.animationsAreRunning = true
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human")
            }

            // check state
            if humanPlayer.hasProcessedAutoMoves() && humanPlayer.turnFinished() {

                self.viewModel?.delegate?.changeUITurnState(to: .aiTurns)
            }

            if self.viewModel!.readyUpdatingAI {

                if humanPlayer.isActive() {
                    self.viewModel?.delegate?.changeUITurnState(to: .humanTurns)
                    _ = self.viewModel?.delegate?.checkPopups()

                    // update all units strengths
                    for unit in gameModel.units(of: humanPlayer) {
                        self.mapNode?.unitLayer.update(unit: unit)
                    }

                    if self.viewModel!.readyUpdatingHuman {

                        self.viewModel!.readyUpdatingHuman = false

                        // this will make a gameModel.update() executed only once at a time
                        if self.gameUpdateMutex {
                            self.gameUpdateMutex = false
                            self.gameUpdateBackgroundQueue.async {
                                // print("-----------> before human processing")
                                gameModel.update()
                                self.gameUpdateMutex = true
                                // print("-----------> after human processing")
                                self.viewModel!.readyUpdatingHuman = true
                            }
                        }
                    }

                } else {

                    self.viewModel!.readyUpdatingAI = false

                    // this will make a gameModel.update() executed only once at a time
                    if self.gameUpdateMutex {
                        self.gameUpdateMutex = false
                        self.gameUpdateBackgroundQueue.async {
                            // print("-----------> before AI processing")
                            if let activePlayer = gameModel.activePlayer() {

                                guard !activePlayer.isHuman() else {
                                    fatalError("something wrong")
                                }

                                gameModel.update()

                                // print("-----------> after AI processing")
                                // self.viewModel!.readyUpdatingAI = true

                                // update all units animations + strengths
                                for unit in gameModel.units(of: activePlayer) {
                                    self.mapNode?.unitLayer.update(unit: unit)
                                }

                                // update animation checker
                                let currentLeader: LeaderType = activePlayer.leader
                                if let state = self.mapNode?.unitLayer.animationsAreRunning(for: currentLeader) {
                                    self.viewModel?.animationsAreRunning = state
                                } else {
                                    self.viewModel?.animationsAreRunning = true
                                }
                            } else {
                                gameModel.update()
                            }

                            self.viewModel!.readyUpdatingAI = true
                            self.gameUpdateMutex = true
                        }
                    }
                }
            }

            if self.viewModel?.refreshCities ?? false {

                // self.mapNode?.unitLayer.populate(with: gameModel)
                for player in gameModel.players {
                    for city in gameModel.cities(of: player) {
                        self.mapNode?.cityLayer.update(city: city)
                    }
                }

                self.mapNode?.unitLayer.checkDelayedDeath()

                self.viewModel?.refreshCities = false
            }

            if let focus = self.viewModel?.focus() {
                self.center(on: focus)
                self.viewModel?.unFocus()
            }

            if let mapOptions = self.viewModel?.shouldRefreshMapOptions() {

                self.mapNode?.refresh(with: mapOptions)
                self.viewModel?.resetRefreshMapOptions()
            }

            self.lastExecuted = currentTime
        }

        // only update view models once per 5 sex
        if self.lastUpdated + 2.0 < currentTime {

            self.lastUpdated = currentTime

            self.viewModel?.delegate?.updateStates()
            self.viewModel?.refreshCities = true
        }

        // if the cursor is more than 2 seconds on the same tile - show tooltip
        if (currentTime - self.hoverTime) > GameScene.kTooltipTrigger {

            self.checkTileHoverTooltip()
        }
    }

    private func checkTileHoverTooltip() {

        guard let gameModel = self.viewModel?.gameModel else {
            return
        }

        if self.viewModel?.unitSelectionMode != .pick {
            return
        }

        if self.viewModel?.delegate?.selectedUnit != nil {
            return
        }

        guard self.hoverLocation != .invalid else {
            return
        }

        guard let tile = gameModel.tile(at: self.hoverLocation) else {
            return
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        guard tile.isDiscovered(by: humanPlayer) else {
            return
        }

        self.showTooltip(at: self.hoverLocation, type: .tileInfo(tile: tile), delay: GameScene.kTooltipDuration)

        // reset values
        self.hoverTime = -1
        self.hoverLocation = .invalid
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

        let viewSize = self.viewSizeInLocalCoordinates(ignoreCameraScale: false)
        self.viewModel?.delegate?.updateRect(at: hex, size: viewSize)

        // Debug
        /*print("viewSize: \(viewSize)")

        let topLeftPoint = HexPoint(screen: CGPoint(x: 0.0, y: 0.0))
        let topRightPoint = HexPoint(screen: CGPoint(x: viewSize.width, y: 0.0))
        let bottomLeftPoint = HexPoint(screen: CGPoint(x: 0.0, y: viewSize.height))

        let dx = topRightPoint.x - topLeftPoint.x
        let dy = bottomLeftPoint.y - topRightPoint.y
        print("rect: \(dx)x\(dy)")*/

        /*print("camera frame: \(self.cameraNode.frame)")
        print("camera zoom: \(self.currentZoom)")*/

        /*let sceneRect = self.viewHex!.calculateAccumulatedFrame()
        let visibleRect = self.getVisibleScreen(sceneBounds: sceneRect, viewBounds: self.view!.bounds.size)
        print("visibleRect: \(visibleRect)")*/

        // self.viewModel.gameEnvironment.change(visibleRect: CGRect)
    }
}

extension SKScene {

    func viewSizeInLocalCoordinates(ignoreCameraScale: Bool = false) -> CGSize {
        let reference = CGPoint(x: view!.bounds.maxX, y: view!.bounds.maxY)
        var bottomLeft = convertPoint(fromView: .zero)
        var topRight = convertPoint(fromView: reference)

        if ignoreCameraScale, let camera = camera {
            bottomLeft = camera.convert(bottomLeft, from: self)
            topRight = camera.convert(topRight, from: self)
        }

        let delta = topRight - bottomLeft
        return CGSize(width: delta.x, height: -delta.y)
    }
}

extension GameScene {

    func updateCommands(for unit: AbstractUnit?) {

        guard let sceneCombatMode = self.viewModel?.unitSelectionMode else {
            return
        }

        if let unit = unit {

            switch sceneCombatMode {

            case .pick:
                let commands = unit.commands(in: self.viewModel?.gameModel)
                self.viewModel?.delegate?.selectedUnitChanged(to: unit, commands: commands, in: self.viewModel?.gameModel)

            case .meleeUnitTargets, .rangedUnitTargets:
                let commands = [Command(type: .cancelAttack, location: HexPoint.invalid)]
                self.viewModel?.delegate?.selectedUnitChanged(to: unit, commands: commands, in: self.viewModel?.gameModel)

            case .rangedCityTargets:
                // NOOP
                break

            case .marker:
                // NOOP
                break
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

    func showGrid() {

        self.mapNode?.showGrid()
    }

    func hideGrid() {

        self.mapNode?.hideGrid()
    }

    func showResourceMarkers() {

        self.mapNode?.showResourceMarker()
    }

    func hideResourceMarkers() {

        self.mapNode?.hideResourceMarker()
    }

    func currentMapLens() -> MapLensType {

        return self.mapNode?.currentMapLens() ?? .none
    }

    func set(mapLens: MapLensType) {

        self.mapNode?.set(mapLens: mapLens)
    }
}

extension GameScene: MouseAwareDelegate {

    func customMouseDown(with event: NSEvent) {

        guard let gameModel = self.viewModel?.gameModel else {
            print("cant get game")
            return
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get humanPlayer")
        }

        let location = event.location(in: self)
        let touchLocation = self.convert(location, to: self.viewHex!) // / 3.0

        if touchLocation.x.isNaN || touchLocation.y.isNaN {
            return
        }

        var position = HexPoint(screen: location)

        if gameModel.wrappedX() {
            position = gameModel.wrap(point: position)
        }

        var selectedCity: Bool = false
        var selectedUnit: Bool = false

        if event.clickCount >= 2 {
            // double tap opens city
            if let city = gameModel.city(at: position) {

                if humanPlayer.isEqual(to: city.player) {
                    self.showScreen(screenType: .city, city: city, other: nil, data: nil)
                    return
                }

                if city.player?.isCityState() ?? false {
                    self.showScreen(screenType: .cityState, city: city, other: nil, data: nil)
                    return
                }
            }
        } else {

            guard self.viewModel?.unitSelectionMode == .pick else {
                print("select target at: \(position)")
                return
            }

            if let city = gameModel.city(at: position) {
                if humanPlayer.isEqual(to: city.player) {
                    self.select(city: city)
                    selectedCity = true
                }
            }

            // problem: cities can have more units
            for unitRef in gameModel.units(of: humanPlayer, at: position) {

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

    func customRightMouseDown(with event: NSEvent) {

        if self.viewModel?.delegate?.selectedUnit != nil {
            self.unselect()
            self.viewModel?.unitSelectionMode = .pick
        } else {
            self.viewModel?.unitSelectionMode = .pick
        }
    }

    func customMouseMoved(with event: NSEvent) {

        let location = event.location(in: self)
        let touchLocation = self.convert(location, to: self.viewHex!) // / 3.0

        if touchLocation.x.isNaN || touchLocation.y.isNaN {
            return
        }

        let position = HexPoint(screen: location)

        if self.hoverLocation != position {
            self.hoverLocation = position
            self.hoverTime = event.timestamp
        }
    }

    func customMouseDragged(with event: NSEvent) {

        guard let gameModel = self.viewModel?.gameModel else {
            fatalError("cant get game")
        }

        if let selectedUnit = self.viewModel?.delegate?.selectedUnit {

            let location = event.location(in: self)
            let touchLocation = self.convert(location, to: self.viewHex!)

            if touchLocation.x.isNaN || touchLocation.y.isNaN {
                return
            }

            var position = HexPoint(screen: location)

            if gameModel.wrappedX() {
                position = gameModel.wrap(point: position)
            }

            if position != selectedUnit.location {

                self.pathfinderQueue.async {

                    let pathFinderDataSource = gameModel.unitAwarePathfinderDataSource(
                        for: selectedUnit.movementType(),
                        for: selectedUnit.player,
                        unitMapType: selectedUnit.unitMapType(),
                        canEmbark: selectedUnit.canEverEmbark(),
                        canEnterOcean: selectedUnit.player!.canEnterOcean()
                    )
                    let pathFinder = AStarPathfinder(with: pathFinderDataSource)

                    if var path = pathFinder.shortestPath(fromTileCoord: selectedUnit.location, toTileCoord: position) {

                        if path.contains(point: selectedUnit.location) {

                            path.cropPoints(until: selectedUnit.location)
                        } else {
                            if !path.startsWith(point: selectedUnit.location) {
                                path.prepend(point: selectedUnit.location, cost: 0.0)
                            }
                        }

                        DispatchQueue.main.async {
                            // update
                            self.updateCommands(for: selectedUnit)

                            self.mapNode?.unitLayer.show(path: path, for: selectedUnit)
                        }
                    } else {
                        DispatchQueue.main.async {
                            // update
                            self.updateCommands(for: selectedUnit)

                            self.mapNode?.unitLayer.clearPathSpriteBuffer()
                        }
                    }
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

            let transformedLocation = self.convert(self.cameraNode.position, to: self.viewHex!)

            let position: HexPoint = HexPoint(screen: transformedLocation)
            let viewSize = self.viewSizeInLocalCoordinates(ignoreCameraScale: false)
            self.viewModel?.delegate?.updateRect(at: position, size: viewSize)

            self.previousLocation = event.location(in: self)

            // notify overview
        }
    }

    func customMouseUp(with event: NSEvent) {

        guard let gameModel = self.viewModel?.gameModel else {
            fatalError("cant get game")
        }

        let location = event.location(in: self)
        let touchLocation = self.convert(location, to: self.viewHex!)

        if touchLocation.x.isNaN || touchLocation.y.isNaN {
            return
        }

        guard let unitSelectionMode = self.viewModel?.unitSelectionMode else {
            fatalError("cant get selection mode")
        }

        var position = HexPoint(screen: location)

        if gameModel.wrappedX() {
            position = gameModel.wrap(point: position)
        }

        if unitSelectionMode == .marker {
            self.viewModel?.delegate?.selectMarker(at: position)
            return
        }

        if let selectedUnit = self.viewModel?.delegate?.selectedUnit {

            switch unitSelectionMode {

            case .pick:
                self.mapNode?.unitLayer.clearPathSpriteBuffer()

                if selectedUnit.location != position {

                    selectedUnit.clearMissions()

                    let unitMission = UnitMission(type: .moveTo, buildType: nil, at: position, options: .none)
                    selectedUnit.push(mission: unitMission, in: self.viewModel?.gameModel)

                    self.mapNode?.unitLayer.hideFocus()
                    self.updateCommands(for: selectedUnit)

                    self.viewModel?.gameModel?.userInterface?.unselect()
                }

            case .meleeUnitTargets:
                self.mapNode?.unitLayer.clearPathSpriteBuffer()

                if let cityToAttack = self.viewModel?.gameModel?.city(at: position) {

                    var combatExecuted: Bool = false
                    if let combatTarget = self.viewModel?.combatCityTarget {

                        if cityToAttack.location == combatTarget.location {

                            self.viewModel?.delegate?.doCombat(of: selectedUnit, against: cityToAttack)

                            self.mapNode?.unitLayer.update(unit: selectedUnit)
                            self.mapNode?.cityLayer.update(city: cityToAttack)

                            combatExecuted = true
                            self.viewModel?.combatUnitTarget = nil
                            self.viewModel?.combatCityTarget = nil
                            self.viewModel?.delegate?.hideCombatBanner()
                            self.viewModel?.unitSelectionMode = .pick

                            self.mapNode?.unitLayer.hideAttackFocus()
                        }
                    }

                    if !combatExecuted {

                        self.viewModel?.delegate?.showCombatBanner(for: selectedUnit, and: cityToAttack, ranged: false)
                        self.viewModel?.combatCityTarget = cityToAttack
                    }

                } else if let unitToAttack = self.viewModel?.gameModel?.unit(at: position, of: .combat) {

                    var combatExecuted: Bool = false
                    if let combatTarget = self.viewModel?.combatUnitTarget {

                        if unitToAttack.location == combatTarget.location {

                            self.viewModel?.delegate?.doCombat(of: selectedUnit, against: unitToAttack)

                            self.mapNode?.unitLayer.update(unit: selectedUnit)
                            self.mapNode?.unitLayer.update(unit: unitToAttack)

                            combatExecuted = true
                            self.viewModel?.combatUnitTarget = nil
                            self.viewModel?.combatCityTarget = nil
                            self.viewModel?.delegate?.hideCombatBanner()
                            self.viewModel?.unitSelectionMode = .pick

                            self.mapNode?.unitLayer.hideAttackFocus()
                        }
                    }

                    if !combatExecuted {

                        self.viewModel?.delegate?.showCombatBanner(for: selectedUnit, and: unitToAttack, ranged: false)
                        self.viewModel?.combatUnitTarget = unitToAttack
                    }
                } else {
                    self.viewModel?.combatUnitTarget = nil
                    self.viewModel?.delegate?.hideCombatBanner()
                }

            case .rangedUnitTargets:
                self.mapNode?.unitLayer.clearPathSpriteBuffer()

                if let cityToAttack = self.viewModel?.gameModel?.city(at: position) {

                    var combatExecuted: Bool = false
                    if let combatTarget = self.viewModel?.combatCityTarget {

                        if cityToAttack.location == combatTarget.location {

                            self.viewModel?.delegate?.doRangedCombat(of: selectedUnit, against: cityToAttack)

                            self.mapNode?.unitLayer.update(unit: selectedUnit)
                            self.mapNode?.cityLayer.update(city: cityToAttack)

                            combatExecuted = true
                            self.viewModel?.combatUnitTarget = nil
                            self.viewModel?.combatCityTarget = nil
                            self.viewModel?.delegate?.hideCombatBanner()
                            self.viewModel?.unitSelectionMode = .pick

                            self.mapNode?.unitLayer.hideAttackFocus()
                        }
                    }

                    if !combatExecuted {

                        self.viewModel?.delegate?.showCombatBanner(for: selectedUnit, and: cityToAttack, ranged: true)
                        self.viewModel?.combatCityTarget = cityToAttack
                    }

                } else if let unitToAttack = self.viewModel?.gameModel?.unit(at: position, of: .combat) {

                    var combatExecuted: Bool = false
                    if let combatTarget = self.viewModel?.combatUnitTarget {

                        if unitToAttack.location == combatTarget.location {

                            self.viewModel?.delegate?.doRangedCombat(of: selectedUnit, against: unitToAttack)

                            self.mapNode?.unitLayer.update(unit: selectedUnit)
                            self.mapNode?.unitLayer.update(unit: unitToAttack)

                            combatExecuted = true
                            self.viewModel?.combatUnitTarget = nil
                            self.viewModel?.combatCityTarget = nil
                            self.viewModel?.delegate?.hideCombatBanner()
                            self.viewModel?.unitSelectionMode = .pick

                            self.mapNode?.unitLayer.hideAttackFocus()
                        }
                    }

                    if !combatExecuted {

                        self.viewModel?.delegate?.showCombatBanner(for: selectedUnit, and: unitToAttack, ranged: true)
                        self.viewModel?.combatUnitTarget = unitToAttack
                    }

                } else {
                    self.viewModel?.combatUnitTarget = nil
                    self.viewModel?.combatCityTarget = nil
                    self.viewModel?.delegate?.hideCombatBanner()
                }

            case .rangedCityTargets:
                fatalError("should not happen")

            case .marker:
                // NOOP
                break

            }
        }

        if let selectedCity = self.viewModel?.delegate?.selectedCity {

            switch unitSelectionMode {

            case .pick, .meleeUnitTargets, .rangedUnitTargets:
                // ignore
                break

            case .rangedCityTargets:
                if let unitToAttack = self.viewModel?.gameModel?.unit(at: position, of: .combat) {

                    var combatExecuted: Bool = false
                    if let combatTarget = self.viewModel?.combatUnitTarget {

                        if unitToAttack.location == combatTarget.location {

                            self.viewModel?.delegate?.doRangedCombat(of: selectedCity, against: unitToAttack)

                            // self.mapNode?.unitLayer.update(unit: selectedUnit)
                            self.mapNode?.unitLayer.update(unit: unitToAttack)

                            combatExecuted = true
                            self.viewModel?.combatUnitTarget = nil
                            self.viewModel?.delegate?.hideCombatBanner()
                            self.viewModel?.unitSelectionMode = .pick
                        }
                    }

                    if !combatExecuted {

                        self.viewModel?.delegate?.showCombatBanner(for: selectedCity, and: unitToAttack, ranged: true)
                        self.viewModel?.combatUnitTarget = unitToAttack
                    }

                } else {
                    self.viewModel?.combatUnitTarget = nil
                    self.viewModel?.delegate?.hideCombatBanner()
                }

            case .marker:
                // NOOP
                break
            }
        }

        self.previousLocation = .zero
    }
}
