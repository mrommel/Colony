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

class StoreScene: SKScene {

    var safeAreaNode: SafeAreaNode

    var backgroundNode: SKSpriteNode?
    var headerLabelNode: SKLabelNode?
    var headerIconNode: SKSpriteNode?
    var boosterStoreNodes: [BoosterStoreNode?] = []
    var backButton: MenuButtonNode?
    var purchaseButton: MenuButtonNode?

    var cameraNode: SKCameraNode!

    var viewModel: StoreSceneViewModel?

    weak var storeDelegate: StoreDelegate?

    override init(size: CGSize) {

        self.safeAreaNode = SafeAreaNode()

        super.init(size: size)

        self.addChild(self.safeAreaNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        guard let viewModel = self.viewModel else {
            fatalError("no ViewModel")
        }

        // camera
        self.cameraNode = SKCameraNode() //initialize and assign an instance of SKCameraNode to the cam variable.
        self.camera = self.cameraNode //set the scene's camera to reference cam
        self.addChild(self.cameraNode) //make the cam a childElement of the scene itself.

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

        self.backButton = MenuButtonNode(titled: "Back", sized: CGSize(width: 150, height: 42),
            buttonAction: {
                self.storeDelegate?.quitStore()
            })
        self.backButton?.zPosition = 2
        self.addChild(self.backButton!)

        self.purchaseButton = MenuButtonNode(imageNamed: "cart", title: "Buy", sized: CGSize(width: 150, height: 42), buttonAction: {
                
                guard let viewModel = self.viewModel else {
                    fatalError("no ViewModel")
                }
                
                if viewModel.valid() {
                    viewModel.execute()
                } else {
                    
                }
            })
        self.purchaseButton?.zPosition = 2
        self.addChild(self.purchaseButton!)

        self.updateLayout()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        let landscape = UIApplication.shared.statusBarOrientation.isLandscape

        let minY: CGFloat = landscape ? -690.0 : 0.0 // FIXME: different devices?
        let maxY: CGFloat = 0.0

        for touch in touches {
            let location = touch.location(in: self.backgroundNode!)
            let previousLocation = touch.previousLocation(in: self.backgroundNode!)

            let deltaY = (location.y) - (previousLocation.y)

            self.cameraNode.position.x = 0.0
            self.cameraNode.position.y -= deltaY * 0.7

            if self.cameraNode.position.y < minY {
                self.cameraNode.position.y = minY
            }

            if self.cameraNode.position.y > maxY {
                self.cameraNode.position.y = maxY
            }
        }
    }

    func updateLayout() {

        let viewSize = (self.view?.bounds.size)!
        let backgroundTileHeight = 812 * viewSize.width / 375

        self.safeAreaNode.updateLayout()

        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.size = CGSize(width: viewSize.width, height: backgroundTileHeight)

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

        self.backButton?.position = CGPoint(x: -100, y: -backgroundTileHeight / 2.0 + 80)
        self.purchaseButton?.position = CGPoint(x: 100, y: -backgroundTileHeight / 2.0 + 80)
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
        print("costs: \(costs)")
    }
}

