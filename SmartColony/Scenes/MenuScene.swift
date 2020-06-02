//
//  MenuScene.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

protocol MenuDelegate: class {

    func startTutorials()
    func resume(game: GameModel?)
    func startWith(map: MapModel?, leader: LeaderType, handicap: HandicapType)
    func startOptions()
    func startStore()
    
    func startPedia()
}

class MenuScene: BaseScene {
    
    // variables
    var backgroundNode: SKSpriteNode?
    var colonyTitleLabel: SKSpriteNode?
    
    var tutorialButton: MenuButtonNode?
    var resumeButton: MenuButtonNode?
    var freePlayButton: MenuButtonNode?
    var loadGameButton: MenuButtonNode?
    var optionsButton: MenuButtonNode?
    var storeButton: MenuButtonNode?
    var pediaButton: MenuButtonNode?
    
    var copyrightLabel: SKLabelNode?
    
    // view model
    var viewModel: MenuSceneViewModel?
    
    // delegate
    weak var menuDelegate: MenuDelegate?
    
    override init(size: CGSize) {
        
        super.init(size: size, layerOrdering: .nodeLayerOnTop)
        
        self.viewModel = MenuSceneViewModel(scene: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        super.didMove(to: view)

        let viewSize = (self.view?.bounds.size)!

        // background
        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode?.zPosition = 0
        self.backgroundNode?.size = viewSize
        self.rootNode.addChild(self.backgroundNode!)

        // colony label
        let colonytexture = SKTexture(imageNamed: "banner")
        self.colonyTitleLabel = SKSpriteNode(texture: colonytexture, color: .black, size: CGSize(width: 250, height: 92))
        self.colonyTitleLabel?.zPosition = 1
        self.rootNode.addChild(self.colonyTitleLabel!)

        // tutorial
        self.tutorialButton = MenuButtonNode(imageNamed: "tutorials", title: "Tutorials",
            buttonAction: {
                //self.menuDelegate?.startTutorials()
            })
        self.tutorialButton?.zPosition = 2
        self.tutorialButton?.disable() // FIXME
        self.rootNode.addChild(self.tutorialButton!)

        // quests
        self.resumeButton = MenuButtonNode(imageNamed: "quests", title: "Resume",
            buttonAction: {
                
                let currentGame = GameStorage.loadCurrentGame()
                self.menuDelegate?.resume(game: currentGame)
            })
        self.resumeButton?.zPosition = 2
        if !GameStorage.hasCurrentGame() {
            self.resumeButton?.disable()
        }
        self.rootNode.addChild(self.resumeButton!)

        // quests
        self.freePlayButton = MenuButtonNode(imageNamed: "free_play", title: "Setup Game",
            buttonAction: {
                self.rootNode.blurWith(completion: {
                    self.requestLeader()
                })
            })
        self.freePlayButton?.zPosition = 2
        self.rootNode.addChild(self.freePlayButton!)
        
        // load
        self.loadGameButton = MenuButtonNode(imageNamed: "free_play", title: "Load Game",
            buttonAction: {
                self.handleLoadButtonClicked()
            })
        self.loadGameButton?.zPosition = 2
        if GameStorage.listGames().isEmpty {
            self.loadGameButton?.disable()
        }
        self.rootNode.addChild(self.loadGameButton!)

        // options
        self.optionsButton = MenuButtonNode(imageNamed: "settings", title: "Settings",
            buttonAction: {
                self.menuDelegate?.startOptions()
            })
        self.optionsButton?.zPosition = 2
        self.optionsButton?.disable() // FIXME
        self.rootNode.addChild(self.optionsButton!)

        // shop
        self.storeButton = MenuButtonNode(imageNamed: "cart", title: "Store",
            buttonAction: {
                self.menuDelegate?.startStore()
            })
        self.storeButton?.zPosition = 2
        self.storeButton?.disable() // FIXME
        self.rootNode.addChild(self.storeButton!)
        
        // pedia
        self.pediaButton = MenuButtonNode(imageNamed: "pedia", title: "Pedia",
            buttonAction: {
                self.menuDelegate?.startPedia()
            })
        self.pediaButton?.zPosition = 2
        self.rootNode.addChild(self.pediaButton!)

        // copyright
        self.copyrightLabel = SKLabelNode(text: "Copyright 2020 MiRo & MaRo")
        self.copyrightLabel?.zPosition = 1
        self.copyrightLabel?.fontSize = 12
        self.rootNode.addChild(self.copyrightLabel!)

        self.updateLayout()
        
        // self.checkUserExists()
    }
    
    // moving the menu content around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self.backgroundNode!)
            let previousLocation = touch.previousLocation(in: self.backgroundNode!)
            
            let deltaY = (location.y) - (previousLocation.y)
            let height = (self.backgroundNode?.frame.height)! * 2 // << == change here
            
            self.cameraNode.position.x = 0.0
            self.cameraNode.position.y -= deltaY * 0.7
            
            if self.cameraNode.position.y < -height {
                self.cameraNode.position.y = -height
            }
            
            if self.cameraNode.position.y > 0 {
                self.cameraNode.position.y = 0
            }
        }
    }
    
    override func updateLayout() {

        super.updateLayout()

        let viewSize = (self.view?.bounds.size)!

        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.aspectFillTo(size: viewSize)

        self.colonyTitleLabel?.position = CGPoint(x: 0, y: self.frame.halfHeight - 80)

        // buttons
        self.tutorialButton?.position = CGPoint(x: 0, y: 100)
        self.resumeButton?.position = CGPoint(x: 0, y: 50)
        self.freePlayButton?.position = CGPoint(x: 0, y: 0)
        self.loadGameButton?.position = CGPoint(x: 0, y: -50)
        self.optionsButton?.position = CGPoint(x: 0, y: -100)
        self.storeButton?.position = CGPoint(x: 0, y: -150)
        self.pediaButton?.position = CGPoint(x: 0, y: -220)

        // copyright
        self.copyrightLabel?.position = CGPoint(x: 0, y: -self.frame.halfHeight + 18)
    }
    
    // MARK: handlers
    
    func handleLoadButtonClicked() {
        
        self.rootNode.blurWith(completion: {
            self.viewModel?.handleLoadGameClicked()
        })
    }
}
