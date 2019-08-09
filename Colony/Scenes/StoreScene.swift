//
//  StoreScene.swift
//  Colony
//
//  Created by Michael Rommel on 30.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol StoreDelegate: class {

    func quitStore()
    //func resetData()
}

class StoreScene: BaseScene {

    // nodes
    var backgroundNode: SKSpriteNode?
    var headerLabelNode: SKLabelNode?
    var headerIconNode: SKSpriteNode?
    var boosterStoreNodes: [BoosterStoreNode?] = []
    
    var coinsBackground: SKSpriteNode?
    var userCoinsLabelNode: SKLabelNode?
    var userCoinsValueNode: CoinsLabelNode?
    var calculatedCoinsLabelNode: SKLabelNode?
    var calculatedCoinsValueNode: CoinsLabelNode?
    var remainingCoinsLabelNode: SKLabelNode?
    var remainingCoinsValueNode: CoinsLabelNode?
    
    var backButton: MenuButtonNode?
    var purchaseButton: MenuButtonNode?

    // view model
    var viewModel: StoreSceneViewModel?

    // delegate
    weak var storeDelegate: StoreDelegate?

    override init(size: CGSize) {

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        super.didMove(to: view)

        guard let viewModel = self.viewModel else {
            fatalError("no ViewModel")
        }

        let viewSize = (self.view?.bounds.size)!

        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode?.zPosition = 0
        self.backgroundNode?.size = viewSize

        if let backgroundNode = self.backgroundNode {
            self.addChild(backgroundNode)
        }

        // header
        self.headerLabelNode = SKLabelNode(text: "Store")
        self.headerLabelNode?.zPosition = 1
        self.addChild(self.headerLabelNode!)

        let headerIconTexture = SKTexture(imageNamed: "cart")
        self.headerIconNode = SKSpriteNode(texture: headerIconTexture, color: .black, size: CGSize(width: 42, height: 42))
        self.headerIconNode?.zPosition = 1
        self.addChild(self.headerIconNode!)

        // items
        for boosterType in BoosterType.all {

            let boosterStoreNode = BoosterStoreNode(for: boosterType, amount: viewModel.initialAmount(of: boosterType), viewWidth: viewSize.width)
            boosterStoreNode.zPosition = 1
            self.addChild(boosterStoreNode)

            self.boosterStoreNodes.append(boosterStoreNode)
        }
        
        // coin labels
        self.coinsBackground = NineGridTextureSprite(imageNamed: "grid9_info_banner", size: CGSize(width: viewSize.width - 32, height: 120))
        self.coinsBackground?.anchorPoint = CGPoint.upperLeft
        self.coinsBackground?.zPosition = 1
        self.addChild(self.coinsBackground!)
        
        self.userCoinsLabelNode = SKLabelNode(text: "Coins you have")
        self.userCoinsLabelNode?.zPosition = 2
        self.userCoinsLabelNode?.horizontalAlignmentMode = .left
        self.userCoinsLabelNode?.fontSize = 18
        self.addChild(self.userCoinsLabelNode!)
        self.userCoinsValueNode = CoinsLabelNode(coins: viewModel.currentCoins())
        self.userCoinsValueNode?.zPosition = 2
        self.addChild(self.userCoinsValueNode!)
        
        self.calculatedCoinsLabelNode = SKLabelNode(text: "Coins you spend")
        self.calculatedCoinsLabelNode?.zPosition = 2
        self.calculatedCoinsLabelNode?.horizontalAlignmentMode = .left
        self.calculatedCoinsLabelNode?.fontSize = 18
        self.addChild(self.calculatedCoinsLabelNode!)
        self.calculatedCoinsValueNode = CoinsLabelNode(coins: viewModel.calculateCosts())
        self.calculatedCoinsValueNode?.zPosition = 2
        self.addChild(self.calculatedCoinsValueNode!)
        
        self.remainingCoinsLabelNode = SKLabelNode(text: "Coins you have left")
        self.remainingCoinsLabelNode?.zPosition = 2
        self.remainingCoinsLabelNode?.horizontalAlignmentMode = .left
        self.remainingCoinsLabelNode?.fontSize = 18
        self.addChild(self.remainingCoinsLabelNode!)
        self.remainingCoinsValueNode = CoinsLabelNode(coins: viewModel.remainingCoins())
        self.remainingCoinsValueNode?.zPosition = 2
        self.addChild(self.remainingCoinsValueNode!)

        self.backButton = MenuButtonNode(titled: "Back", sized: CGSize(width: 150, height: 42),
            buttonAction: {
                self.storeDelegate?.quitStore()
            })
        self.backButton?.zPosition = 2
        self.addChild(self.backButton!)

        self.purchaseButton = MenuButtonNode(imageNamed: "cart", title: "Buy",
            sized: CGSize(width: 150, height: 42),
            buttonAction: {

                guard let viewModel = self.viewModel else {
                    fatalError("no ViewModel")
                }

                if viewModel.valid() {
                    viewModel.execute()
                    self.show(message: "Purchased", for: 3.0)
                } else {
                    self.show(message: "Not enough money - please remove items from the cart", for: 3.0)
                }
            })
        self.purchaseButton?.zPosition = 2
        self.purchaseButton?.disable()
        self.addChild(self.purchaseButton!)

        self.updateLayout()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self.backgroundNode!)
            let previousLocation = touch.previousLocation(in: self.backgroundNode!)

            let deltaY = (location.y) - (previousLocation.y)

            self.cameraNode.position.x = 0.0
            self.cameraNode.position.y -= deltaY * 0.7

            self.limitCamera()
        }
    }
    
    func limitCamera() {
        
        let landscape = UIApplication.shared.statusBarOrientation.isLandscape
        let minY: CGFloat = landscape ? -690.0 : 0.0 // FIXME: different devices?
        let maxY: CGFloat = 0.0
        
        if self.cameraNode.position.y < minY {
            self.cameraNode.position.y = minY
        }
        
        if self.cameraNode.position.y > maxY {
            self.cameraNode.position.y = maxY
        }
    }

    override func updateLayout() {

        super.updateLayout()
        
        self.limitCamera()

        let viewSize = (self.view?.bounds.size)!
        let backgroundTileHeight = 812 * viewSize.width / 375

        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        //self.backgroundNode?.size = CGSize(width: viewSize.width, height: backgroundTileHeight)
        self.backgroundNode?.aspectFillTo(size: viewSize)

        self.headerLabelNode?.position = CGPoint(x: 0, y: viewSize.halfHeight - 72)
        self.headerIconNode?.position = CGPoint(x: -self.headerLabelNode!.frame.size.halfWidth - 24, y: viewSize.halfHeight - 62)

        var deltaY = viewSize.height - 150
        for boosterStoreNode in self.boosterStoreNodes {
            boosterStoreNode?.size = CGSize(width: viewSize.width - 32, height: 84)
            boosterStoreNode?.position = CGPoint(x: 16 - viewSize.halfWidth, y: deltaY - viewSize.halfHeight)
            boosterStoreNode?.updateLayout()
            boosterStoreNode?.delegate = self

            deltaY -= 92
        }
        
        self.coinsBackground?.size = CGSize(width: viewSize.width - 32, height: 120)
        self.coinsBackground?.position = CGPoint(x: 16 - viewSize.halfWidth, y: (-backgroundTileHeight / 2.0) + 246)
        self.userCoinsLabelNode?.position = CGPoint(x: -150, y: (-backgroundTileHeight / 2.0) + 220)
        self.userCoinsValueNode?.position = CGPoint(x: 120, y: (-backgroundTileHeight / 2.0) + 220)
        self.calculatedCoinsLabelNode?.position = CGPoint(x: -150, y: (-backgroundTileHeight / 2.0) + 180)
        self.calculatedCoinsValueNode?.position = CGPoint(x: 120, y: (-backgroundTileHeight / 2.0) + 180)
        self.remainingCoinsLabelNode?.position = CGPoint(x: -150, y: (-backgroundTileHeight / 2.0) + 140)
        self.remainingCoinsValueNode?.position = CGPoint(x: 120, y: (-backgroundTileHeight / 2.0) + 140)

        self.backButton?.position = CGPoint(x: -100, y: (-backgroundTileHeight / 2.0) + 80)
        self.purchaseButton?.position = CGPoint(x: 100, y: (-backgroundTileHeight / 2.0) + 80)
    }
}

extension StoreScene: BoosterStoreNodeDelegate {

    func handleNew(value: Int, for boosterType: BoosterType) {

        guard let viewModel = self.viewModel else {
            fatalError("no ViewModel")
        }

        viewModel.updateCart(for: boosterType, amount: value)

        // new coins
        let costs = viewModel.calculateCosts()
        let remaining = viewModel.remainingCoins()
        
        self.calculatedCoinsValueNode?.coins = costs
        self.remainingCoinsValueNode?.coins = remaining
        
        if remaining < 0 || viewModel.itemsInCart() == 0 {
            self.purchaseButton?.disable()
        } else {
            self.purchaseButton?.enable()
        }
    }
}

