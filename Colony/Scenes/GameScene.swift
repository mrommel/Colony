//
//  GameScene.swift
//  Colony
//
//  Created by Michael Rommel on 26.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import GameplayKit
//import Rswift

protocol GameDelegate: class {

    func select(object: GameObject?)
    func quitGame()
}

class GameScene: BaseScene {

    // MARK: Constants
    let headerHeight: CGFloat = 480

    struct Constants {

        struct ZLevels {
            static let terrain: CGFloat = 1.0
            static let underwater: CGFloat = 1.1
            static let caldera: CGFloat = 1.5
            static let snow: CGFloat = 2.0
            static let hill: CGFloat = 2.1
            static let mountain: CGFloat = 7.1 // 2.2 FIXME
            static let focus: CGFloat = 3.0
            static let feature: CGFloat = 4.0
            static let road: CGFloat = 4.1
            static let river: CGFloat = 4.2
            static let path: CGFloat = 4.3
            static let featureUpper: CGFloat = 4.5
            static let staticSprite: CGFloat = 5.0
            static let cityName: CGFloat = 5.5
            static let sprite: CGFloat = 6.0
            static let unitType: CGFloat = 8.0
            static let unitStrength: CGFloat = 10.0
            static let labels: CGFloat = 50.0
            static let sceneElements: CGFloat = 51.0
            static let dialogs: CGFloat = 52.0
            static let messages: CGFloat = 60.0
        }

        struct Visibility {
            static let currently: CGFloat = 1.0
            static let discovered: CGFloat = 0.5
        }

        static let initialScale: CGFloat = 0.25
    }

    var viewModel: GameSceneViewModel?

    // UI
    var backgroundNode: SKSpriteNode?
    var frameTopLeft: SKSpriteNode?
    var frameTopRight: SKSpriteNode?
    var frameBottomLeft: SKSpriteNode?
    var frameBottomRight: SKSpriteNode?
    var bottomLeftBar: BottomLeftBar?
    var bottomRightBar: BottomRightBar?

    var exitButton: MessageBoxButtonNode?

    var mapNode: MapNode?
    let viewHex: SKSpriteNode

    var coinLabel: SKLabelNode!
    var coinIconLabel: SKSpriteNode!
    let timeLabel = SKLabelNode(text: "0:00")

    // FIXME: move to view model
    var selectedUnitForMovement: Unit? = nil
    var selectedUnitForAttack: Unit? = nil
    var attackOverlay: SKSpriteNode?
    let forceTouchLevel: CGFloat = 3.0

    // booster handling
    var boosterNodeTelescope: BoosterNode?
    var boosterNodeTime: BoosterNode?

    var game: Game? // the reference
    weak var gameDelegate: GameDelegate?

    let userUsecase = UserUsecase()

    override init(size: CGSize) {

        self.viewHex = SKSpriteNode()

        super.init(size: size, layerOrdering: .cameraLayerOnTop)
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
    }

    override func didMove(to view: SKView) {

        super.didMove(to: view)

        let viewSize = (self.view?.bounds.size)!
        let deviceScale = self.size.width / 667

        guard let viewModel = self.viewModel else {
            fatalError("no ViewModel")
        }

        // the scale sets the zoom level of the camera on the given position
        self.cameraNode.xScale = Constants.initialScale
        self.cameraNode.yScale = Constants.initialScale

        // background
        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.zPosition = -100
        self.backgroundNode?.size = viewSize
        self.cameraNode.addChild(backgroundNode!)

        guard let user = userUsecase.currentUser() else {
            fatalError("can't get current user")
        }

        switch viewModel.type {

        case .level:

            guard let levelMeta = viewModel.levelMeta else {
                fatalError("no level meta")
            }

            guard let level = LevelManager.loadLevel(from: levelMeta) else {
                fatalError("no level")
            }

            self.game = Game(with: level, meta: levelMeta, coins: user.coins, boosterStock: user.boosterStock)

            self.mapNode = MapNode(with: level)
            self.bottomLeftBar = BottomLeftBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar = BottomRightBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar?.delegate = self

            self.showLevelIntroductionFor(levelMeta: levelMeta)

        case .game:
            self.game = self.viewModel?.game

            guard let level = self.viewModel?.getLevel() else {
                fatalError("no level")
            }

            self.mapNode = MapNode(with: level)
            self.bottomLeftBar = BottomLeftBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar = BottomRightBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar?.delegate = self

        case .generator:

            guard let map = viewModel.map else {
                fatalError()
            }

            let startPositionFinder = StartPositionFinder(map: map)
            let startPositions = startPositionFinder.identifyStartPositions()

            //let gameObjectManager = GameObjectManager(on: map)

            let levelMeta = LevelMeta(number: 0, title: "Generator", summary: "Dummy", difficulty: .easy, position: CGPoint(x: 0.0, y: 0.0), resource: "", rating: "", aiscript: "")
            let level = Level(duration: 300, map: map, startPositions: startPositions)

            self.game = Game(with: level, meta: levelMeta, coins: user.coins, boosterStock: user.boosterStock)

            self.mapNode = MapNode(with: level)
            self.bottomLeftBar = BottomLeftBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar = BottomRightBar(for: level, sized: CGSize(width: 200, height: 112))
            self.bottomRightBar?.delegate = self

            self.showLevelIntroductionFor(levelMeta: levelMeta)
        }

        self.game?.conditionDelegate = self
        self.game?.gameUpdateDelegate = self
        self.game?.add(gameObjectUnitDelegate: self)


        self.safeAreaNode.addChild(self.bottomLeftBar!)
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

        if viewModel.type == .generator {
            // save node
            let saveButton = MessageBoxButtonNode(titled: "Save", buttonAction: {

                LevelManager.storeLevelFrom(game: self.game, to: "level000X.lvl")

            })
            saveButton.position = CGPoint(x: 0, y: frame.size.height - headerHeight - 40)
            saveButton.zPosition = 200
            self.safeAreaNode.addChild(saveButton)
        }

        // infos
        self.coinLabel = SKLabelNode(text: "0000")
        self.coinLabel.fontSize = 18
        self.coinLabel.zPosition = GameScene.Constants.ZLevels.labels
        self.safeAreaNode.addChild(self.coinLabel)

        self.coinIconLabel = SKSpriteNode(imageNamed: "coin1")
        self.coinIconLabel.zPosition = GameScene.Constants.ZLevels.labels
        self.safeAreaNode.addChild(self.coinIconLabel)

        self.timeLabel.fontSize = 18
        self.timeLabel.zPosition = GameScene.Constants.ZLevels.labels
        self.safeAreaNode.addChild(self.timeLabel)

        // exit node
        self.exitButton = MessageBoxButtonNode(titled: "Cancel", buttonAction: {
            self.showQuitConfirmationDialog()
        })
        self.exitButton?.zPosition = 200
        self.safeAreaNode.addChild(self.exitButton!)

        // focus on selected unit
        if let mapNode = self.mapNode {
            if let selectedUnit = mapNode.gameObjectManager?.selected {
                self.centerCamera(on: selectedUnit.position)
            }
        }

        // FIXME
        let telescopeBoosterAvailable = self.game?.boosterStock.isAvailable(boosterType: .telescope) ?? false
        self.boosterNodeTelescope = BoosterNode(for: .telescope, active: telescopeBoosterAvailable)
        self.boosterNodeTelescope?.zPosition = 200
        self.boosterNodeTelescope?.position = CGPoint(x: 220, y: 250)
        self.boosterNodeTelescope?.delegate = self
        self.safeAreaNode.addChild(self.boosterNodeTelescope!)

        let timeBoosterAvailable = self.game?.boosterStock.isAvailable(boosterType: .time) ?? false
        self.boosterNodeTime = BoosterNode(for: .time, active: timeBoosterAvailable)
        self.boosterNodeTime?.zPosition = 200
        self.boosterNodeTime?.position = CGPoint(x: 220, y: 170)
        self.boosterNodeTime?.delegate = self
        self.safeAreaNode.addChild(self.boosterNodeTime!)
        
        self.updateLayout()
    }

    override func updateLayout() {

        super.updateLayout()

        let viewSize = (self.view?.bounds.size)!
        self.backgroundNode?.aspectFillTo(size: viewSize)
        
        self.mapNode?.updateLayout()

        self.frameTopLeft?.position = CGPoint(x: -self.frame.halfWidth, y: self.frame.halfHeight)
        self.frameTopRight?.position = CGPoint(x: self.frame.halfWidth, y: self.frame.halfHeight)
        self.frameBottomLeft?.position = CGPoint(x: -self.frame.halfWidth, y: -self.frame.halfHeight)
        self.frameBottomRight?.position = CGPoint(x: self.frame.halfWidth, y: -self.frame.halfHeight)

        self.coinIconLabel.position = CGPoint(x: -30, y: self.frame.halfHeight - 43)
        self.coinLabel.position = CGPoint(x: 0, y: self.frame.halfHeight - 50)
        self.timeLabel.position = CGPoint(x: self.frame.halfWidth - 50, y: self.frame.halfHeight - 50)

        self.bottomLeftBar?.position = CGPoint(x: -self.safeAreaNode.frame.halfWidth, y: -self.safeAreaNode.frame.halfHeight)
        self.bottomLeftBar?.updateLayout()

        self.bottomRightBar?.position = CGPoint(x: self.safeAreaNode.frame.halfWidth, y: -self.safeAreaNode.frame.halfHeight)
        self.bottomRightBar?.updateLayout()

        self.exitButton?.position = CGPoint(x: -self.safeAreaNode.frame.halfWidth + 50, y: -self.safeAreaNode.frame.halfHeight + 112 + 21)
    }

    func showQuitConfirmationDialog() {

        if let quitConfirmationDialog = UI.quitConfirmationDialog() {

            quitConfirmationDialog.zPosition = 250
            quitConfirmationDialog.addOkayAction(handler: {
                quitConfirmationDialog.close()

                self.game?.cancel()
                self.game = nil

                self.gameDelegate?.quitGame()
            })

            quitConfirmationDialog.addCancelAction(handler: {
                quitConfirmationDialog.close()
            })

            self.cameraNode.addChild(quitConfirmationDialog)
        }
    }

    func showLevelIntroductionFor(levelMeta: LevelMeta?) {

        if let levelIntroductionDialog = UI.levelIntroductionDialog(for: levelMeta) {

            levelIntroductionDialog.zPosition = 250
            levelIntroductionDialog.addOkayAction(handler: {
                levelIntroductionDialog.close()

                guard let duration = self.game?.duration else {
                    fatalError("can't get level duration")
                }

                // start timer
                self.game?.start(with: duration)
            })

            self.cameraNode.addChild(levelIntroductionDialog)
        }
    }

    func showAttackSymbol(at point: HexPoint, real: Bool) {

        self.hideAttackSymbol()

        self.attackOverlay = SKSpriteNode(imageNamed: "hex_attack")
        self.attackOverlay?.position = HexMapDisplay.shared.toScreen(hex: point)
        self.attackOverlay?.zPosition = GameScene.Constants.ZLevels.focus
        self.attackOverlay?.alpha = real ? 1.0 : 0.2
        self.attackOverlay?.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.viewHex.addChild(self.attackOverlay!)
        
        if real {
            let pulseUp = SKAction.scale(to: 1.2, duration: 1.0)
            let pulseDown = SKAction.scale(to: 0.8, duration: 1.0)
            let pulse = SKAction.sequence([pulseUp, pulseDown])
            let repeatPulse = SKAction.repeatForever(pulse)
            self.attackOverlay?.run(repeatPulse)
        }
    }

    func hideAttackSymbol() {
        
        self.attackOverlay?.removeFromParent()
        self.attackOverlay = nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let user = userUsecase.currentUser() else {
            fatalError("can't get current user")
        }

        let touch = touches.first!
        let touchLocation = touch.location(in: self.viewHex)
        let position = HexMapDisplay.shared.toHexPoint(screen: touchLocation)

        guard let units = self.game?.getUnits(at: position) else {
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
        self.selectedUnitForMovement = nil
    }

    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first!

        let touchLocation = touch.location(in: self.viewHex)
        let position = HexMapDisplay.shared.toHexPoint(screen: touchLocation)

        if touch.force > self.forceTouchLevel {
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
                    path.prepend(point: selectedUnit.position)
                    selectedUnit.gameObject?.show(path: path)
                } else {
                    selectedUnit.gameObject?.clearPathSpriteBuffer()
                }
            }
        } else {

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
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first!
        let cameraLocation = touch.location(in: self.cameraNode)
        let touchLocation = touch.location(in: self.viewHex)
        let position = HexMapDisplay.shared.toHexPoint(screen: touchLocation)

        guard let bottomRightBar = self.bottomRightBar, !bottomRightBar.frame.contains(cameraLocation) else {
            self.bottomRightBar?.touchesEnded(touches, with: event)
            return
        }

        guard let bottomLeftBar = self.bottomLeftBar, !bottomLeftBar.frame.contains(cameraLocation) else {
            self.bottomLeftBar?.touchesEnded(touches, with: event)
            return
        }

        if let selectedUnit = self.selectedUnitForAttack {
            // FIXME: do it
            //self.show(message: "initiate battle: \(selectedUnit)")
            self.showBattleDialog(between: self.game?.getSelectedUnitOfUser(), and: selectedUnit)
            
            self.selectedUnitForAttack = nil
        }

        if let selectedUnit = self.selectedUnitForMovement {
            selectedUnit.gameObject?.clearPathSpriteBuffer()

            self.mapNode?.moveSelectedUnit(to: position)
        }
        self.selectedUnitForMovement = nil

        self.hideAttackSymbol()
    }

    func target(at point: HexPoint) -> Unit? {

        guard let user = userUsecase.currentUser() else {
            fatalError("can't get current user")
        }
        
        if let units = self.game?.getUnits(at: point) {

            let filteredUnits = units.filter({ $0?.civilization != user.civilization })
            //filteredUnits = filteredUnits.filter({ $0?.type != .coin && $0?.type != .animal && $0?.type != .obstacle && $0?.type != .booster })
            
            // FIXME: how to select the attacker?
            //filteredUnits = filteredUnits.filter({ $0?.position.distance(to: <#T##HexPoint#>) })
            
            if filteredUnits.count == 0 {
                return nil
            }

            let firstUnit = filteredUnits.first!
            return firstUnit
        }

        return nil
    }

    func zoom(to zoomScale: CGFloat) {
        let zoomInAction = SKAction.scale(to: zoomScale, duration: 0.1)
        self.cameraNode.run(zoomInAction)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //print("tick")
    }

    func centerCamera(on hex: HexPoint) {

        var screenPosition = HexMapDisplay.shared.toScreen(hex: hex)
        // FIXME: hm, not sure why this is needed
        screenPosition.x += 20
        screenPosition.y += 15

        let cameraPositionInScene = self.convert(screenPosition, from: self.viewHex)

        self.cameraNode.position = cameraPositionInScene
        print("center camera on: \(cameraPositionInScene)")
    }
}

extension GameScene: BottomRightBarDelegate {

    func focus(on point: HexPoint) {
        self.centerCamera(on: point)
    }
}

extension GameScene: GameConditionDelegate {

    func won(with type: GameConditionType) {
        print("--- won with \(type) ---")

        if let victoryDialog = UI.victoryDialog() {
            victoryDialog.set(text: type.summary, identifier: "summary")
            victoryDialog.addOkayAction(handler: {

                self.game?.saveScore()
                self.game?.cancel()
                self.game = nil

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

                self.game?.cancel()
                self.game = nil

                self.gameDelegate?.quitGame()
            })

            self.cameraNode.addChild(defeatDialog)
        }
    }
}

extension GameScene: GameUpdateDelegate {

    func updateUI() {

        if let time = self.game?.timeRemainingInSeconds() {
            self.timeLabel.text = Formatters.Dates.getString(from: time)
        }

        if let coins = self.game?.coins {
            let coinText = Formatters.Numbers.getCoinString(from: coins)
            self.coinLabel.text = coinText
        }

        if let boosterStock = self.game?.boosterStock {
            if boosterStock.isAvailable(boosterType: .telescope) {
                self.boosterNodeTelescope?.enable()
            } else {
                self.boosterNodeTelescope?.disable()
            }

            if boosterStock.isAvailable(boosterType: .time) {
                self.boosterNodeTime?.enable()
            } else {
                self.boosterNodeTime?.disable()
            }
        }
    }
    
    /*func showBattleResultDialog(with result: BattleResult) {
        
        if let battleResultDialog = UI.battleResultDialog() {
            battleResultDialog.set(text: "att: \(result.attackerDamage) / def: \(result.defenderDamage)", identifier: "summary")
            battleResultDialog.addOkayAction(handler: {
                
                self.game?.resume()
                battleResultDialog.close()
            })
            
            self.cameraNode.addChild(battleResultDialog)
        }
    }*/

    func showBattleDialog(between source: Unit?, and target: Unit?) {

        if let battleDialog = UI.battleDialog() {
            
            // stop the timer
            self.game?.pause()
            
            let battle = Battle(between: source, and: target, attackType: .active, in: self.game)
            let prediction = battle.predict()
            
            battleDialog.show(prediction: prediction, for: target)
            battleDialog.addOkayAction(handler: {

                battleDialog.close()
                
                let result = battle.fight()
                
                self.showBattle(result: result, between: source, and: target)

                // handle attacker / defender dead
                if let isSourceDestroyed = source?.isDestroyed(), isSourceDestroyed {
                    self.removed(unit: source)
                }
                
                if let isTargetDestroyed = target?.isDestroyed(), isTargetDestroyed {
                    self.removed(unit: target)
                }
                
                // restart the game
                self.game?.resume()
            })

            battleDialog.addCancelAction(handler: {

                self.game?.resume()
                battleDialog.close()
            })

            self.cameraNode.addChild(battleDialog)
        }
    }
    
    func showBattle(result: BattleResult, between source: Unit?, and target: Unit?) {
        
        var sourceDirection: HexDirection = .north
        if let sourcePosition = source?.position, let targetPosition = target?.position {
            sourceDirection = HexMapDisplay.shared.screenDirection(from: sourcePosition, towards: targetPosition)
        }
        let targetDirection = sourceDirection.opposite
        
        if result.options.contains(.attackerStriked) {
            source?.gameObject?.showExplosion(in: sourceDirection)
            target?.gameObject?.showExplosionDelayed(in: targetDirection)
        } else if result.options.contains(.defenderStriked) {
            source?.gameObject?.showExplosionDelayed(in: sourceDirection)
            target?.gameObject?.showExplosion(in: targetDirection)
        } else if result.options.contains(.bothStriked) {
            source?.gameObject?.showExplosion(in: sourceDirection)
            target?.gameObject?.showExplosion(in: targetDirection)
        }
        
        source?.gameObject?.show(losses: result.attackerDamage)
        target?.gameObject?.show(losses: result.defenderDamage)
    }
}

extension GameScene: GameObjectUnitDelegate {
    
    func selectedUnitChanged(to unit: Unit?) {
        if let newPosition = unit?.position {
            self.centerCamera(on: newPosition)
        }
    }

    func removed(unit: Unit?) {
        // NOOP
        if let unit = unit {
            print("---- removed: \(unit.unitType), \(unit.civilization) got killed or is deleted")
        }
        //self.game.remo
    }
}

extension GameScene: BoosterActivationDelegate {

    func activated(boosterType: BoosterType) {
        self.game?.start(boosterType: boosterType)
        self.updateUI()
    }
}
