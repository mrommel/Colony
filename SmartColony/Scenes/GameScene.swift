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

enum UITurnState {

    case aiTurns // => lock UI
    case humanTurns // => UI enabled
}

class GameScene: BaseScene {

    // Constants
    let forceTouchLevel: CGFloat = 2.0

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

    private var turnButton: MessageBoxButtonNode?
    private var turnDialog: TurnDialog?

    // view model
    var viewModel: GameSceneViewModel?

    var selectedUnit: AbstractUnit? = nil
    var lastExecuted: TimeInterval = -1
    let queue = DispatchQueue(label: "update_queue")
    var readyUpdatingAI: Bool = true
    var uiTurnState: UITurnState = .aiTurns
    var blockingNotification: Notifications.Notification? = nil

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
        self.bottomRightBar?.delegate = self
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

        self.turnButton = MessageBoxButtonNode(imageNamed: "next", title: "Turn", buttonAction: {
            self.handleTurnButtonClick()
        })
        self.turnButton?.zPosition = 200
        self.safeAreaNode.addChild(self.turnButton!)

        // disable turn button
        self.changeUITurnState(to: .aiTurns)

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
        self.turnButton?.position = CGPoint(x: self.safeAreaNode.frame.halfWidth - 50, y: -self.safeAreaNode.frame.halfHeight + 112 + 21)
    }

    func zoom(to zoomScale: Double) {
        let zoomInAction = SKAction.scale(to: CGFloat(zoomScale), duration: 0.1)
        self.cameraNode.run(zoomInAction)
    }

    // MARK: game loop

    override func update(_ currentTime: TimeInterval) {

        // only check once per 1 sec
        if self.lastExecuted + 1 < currentTime {

            guard let gameModel = self.viewModel?.game else {
                fatalError("cant get game")
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human")
            }

            if self.readyUpdatingAI && humanPlayer.isActive() {
                self.changeUITurnState(to: .humanTurns)
            } else {
                if self.readyUpdatingAI {
                    self.readyUpdatingAI = false
                    queue.async {
                        print("-----------> before AI processing")
                        gameModel.update()
                        print("-----------> after AI processing")
                        self.readyUpdatingAI = true
                    }
                }
            }

            self.lastExecuted = currentTime
        }
    }

    // MARK: touch handling

    func handleTurnButtonClick() {

        print("---- turn pressed ------")

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        // debug
        /*for player in gameModel.players {
            print("-- score of \(player.leader) = \(player.score(for: gameModel))")
        }*/

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if self.uiTurnState == .humanTurns {

            if humanPlayer.canFinishTurn() {

                humanPlayer.endTurn(in: gameModel)
                self.changeUITurnState(to: .aiTurns)
            } else {

                if let blockingNotification = humanPlayer.blockingNotification() {
                    blockingNotification.activate(in: gameModel)
                }
            }
        }
    }

    func changeUITurnState(to state: UITurnState) {

        switch state {

        case .aiTurns:
            // disable turn Button
            self.turnButton?.disable()

            // show AI turn banner
            self.turnDialog = TurnDialog()
            self.turnDialog?.zPosition = 250
            self.cameraNode.addChild(self.turnDialog!)

        case .humanTurns:
            // enable turn Button
            self.turnButton?.enable()

            // update state
            self.updateTurnButton()

            // hide AI turn banner
            if self.turnDialog != nil {
                self.turnDialog?.close()
                self.turnDialog = nil
            }
        }

        self.uiTurnState = state
    }

    func updateTurnButton() {

        self.viewModel?.game?.updateTestEndTurn()

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if let blockingNotification = humanPlayer.blockingNotification() {
            self.turnButton?.title = blockingNotification.summary
        } else {
            self.turnButton?.title = "Turn"
        }
    }
    
    func showPopup(for commands: [Command], of unit: AbstractUnit?) {
        
        if commands.count == 0 {
            return
        }
        
        let commandsDialog = CommandsDialog(for: commands)
        commandsDialog.zPosition = 250
        
        commandsDialog.addResultHandler(handler: { commandResult in
            
            if commandResult == .commandFound {
                unit?.doFound(with: "abc", in: self.viewModel?.game)
            } else {
                fatalError("unhandled: \(commandResult)")
            }
            
            commandsDialog .close()
        })
               
        commandsDialog.addCancelAction(handler: {
            commandsDialog.close()
        })
        
        self.cameraNode.addChild(commandsDialog)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first!
        let touchLocation = touch.location(in: self.viewHex)
        let position = HexPoint(screen: touchLocation)

        if touch.force > self.forceTouchLevel {
            // force touch
            if let unit = viewModel?.game?.unit(at: position) {
                print("force touch: \(touch.force) at \(unit.type)")
                
                let commands = unit.commands(in: viewModel?.game)
                //print("commands: \(commands)")
                self.showPopup(for: commands, of: unit)
            }
        }
        
        //print("touch began with \(touch.tapCount) taps")
        if touch.tapCount == 2 {
            // double tap
            if let unit = viewModel?.game?.unit(at: position) {
                print("double tapped: \(unit.type)")
            }
        } else {
        
            if let unit = viewModel?.game?.unit(at: position) {
                self.select(unit: unit)
            } else {
                self.unselect()
            }
        }
    }

    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first!

        let touchLocation = touch.location(in: self.viewHex)
        let position = HexPoint(screen: touchLocation)

        if let selectedUnit = self.selectedUnit {

            if position != selectedUnit.location {

                let pathFinder = AStarPathfinder()
                pathFinder.dataSource = self.viewModel?.game?.ignoreUnitsPathfinderDataSource(for: selectedUnit.movementType(), for: selectedUnit.player)

                if let path = pathFinder.shortestPath(fromTileCoord: selectedUnit.location, toTileCoord: position) {
                    path.prepend(point: selectedUnit.location, cost: 0.0)
                    self.mapNode?.unitLayer.show(path: path, for: selectedUnit)
                } else {
                    self.mapNode?.unitLayer.clearPathSpriteBuffer()
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
        let position = HexPoint(screen: touchLocation)

        guard let bottomRightBar = self.bottomRightBar, !bottomRightBar.frame.contains(cameraLocation) else {
            self.bottomRightBar?.touchesEnded(touches, with: event)
            return
        }

        guard let bottomLeftBar = self.bottomLeftBar, !bottomLeftBar.frame.contains(cameraLocation) else {
            self.bottomLeftBar?.touchesEnded(touches, with: event)
            return
        }

        if let selectedUnit = self.selectedUnit {
            self.mapNode?.unitLayer.clearPathSpriteBuffer()
            self.mapNode?.unitLayer.hideFocus()
            self.mapNode?.unitLayer.move(unit: selectedUnit, to: position)
        }

        self.unselect()
    }

    func centerCamera(on hex: HexPoint) {

        let screenPosition = HexPoint.toScreen(hex: hex)
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

extension GameScene: UserInterfaceProtocol {

    func select(unit: AbstractUnit?) {

        self.mapNode?.unitLayer.showFocus(for: unit)
        self.selectedUnit = unit
        self.bottomLeftBar?.selectedUnitChanged(to: unit)
    }

    func unselect() {

        self.mapNode?.unitLayer.hideFocus()
        self.selectedUnit = nil
    }

    func isDiplomaticScreenActive() -> Bool {
        return false
    }

    func isPopupShown() -> Bool {
        return false
    }

    func showPopup(popupType: PopupType, data: PopupData?) {
        print("popup")
    }

    func showScreen(screenType: ScreenType) {
        print("screen")
    }

    func show(unit: AbstractUnit?) { // unit gets visible
        print("show")
    }

    func hide(unit: AbstractUnit?) { // unit gets hidden
        print("hide")
        self.mapNode?.unitLayer.hide(unit: unit)
        self.bottomLeftBar?.selectedUnitChanged(to: nil)
    }

    func move(unit: AbstractUnit?, on points: [HexPoint]) {
        print("move")
    }
    
    func show(city: AbstractCity?) {
        print("show city")
    }

    func showTooltip(at point: HexPoint, text: String, delay: Double) {
        print("tooltip")
    }

    func show(notification: Notifications.Notification) {
        fatalError("cant display: \(notification.type)")
    }

    func refresh(tile: AbstractTile?) {
        self.mapNode?.terrainLayer.update(tile: tile)
        self.mapNode?.featureLayer.update(tile: tile)
    }
}
