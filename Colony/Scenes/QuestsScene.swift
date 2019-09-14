//
//  MenuScene.swift
//  Colony
//
//  Created by Michael Rommel on 01.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit


protocol QuestsDelegate {

    func start(level url: URL?)
    func restart(game: Game?)
   
    func quitQuests()
}

class QuestsScene: BaseScene {

    // MARK: Variables
    var questsDelegate: QuestsDelegate?

    var colonyTitleLabel: SKSpriteNode?
    var backgroundNode2: SKSpriteNode?
    var backgroundNode1: SKSpriteNode?
    var backgroundNode0: SKSpriteNode?
    var copyrightLabel: SKLabelNode?
    var backButton: MenuButtonNode?

    let gameUsecase: GameUsecase?

    override init(size: CGSize) {

        self.gameUsecase = GameUsecase()

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        super.didMove(to: view)

        let viewSize = (self.view?.bounds.size)!

        self.backgroundNode0 = SKSpriteNode(imageNamed: "menu_background0")
        self.backgroundNode0?.position = CGPoint(x: 0.0, y: 0.0)
        self.backgroundNode0?.zPosition = 0
        self.backgroundNode0?.size = viewSize
        self.rootNode.addChild(self.backgroundNode0!)

        self.backgroundNode1 = SKSpriteNode(imageNamed: "menu_background1")
        self.backgroundNode1?.position = CGPoint(x: 0.0, y: (self.backgroundNode0?.frame.height)!)
        self.backgroundNode1?.zPosition = 0
        self.backgroundNode1?.size = viewSize
        self.rootNode.addChild(self.backgroundNode1!)
        
        self.backgroundNode2 = SKSpriteNode(imageNamed: "menu_background2")
        self.backgroundNode2?.position = CGPoint(x: 0.0, y: (self.backgroundNode0?.frame.height)! * 2)
        self.backgroundNode2?.zPosition = 0
        self.backgroundNode2?.size = viewSize
        self.rootNode.addChild(self.backgroundNode2!)
        
        // colony label
        let colonytexture = SKTexture(imageNamed: "ColonyText")
        self.colonyTitleLabel = SKSpriteNode(texture: colonytexture, color: .black, size: CGSize(width: 228, height: 87))
        self.colonyTitleLabel?.zPosition = 1
        self.cameraNode.addChild(self.colonyTitleLabel!)

        let levelManager = LevelManager()
        for level in levelManager.levels {

            let levelButton = LevelButtonNode(titled: "\(level.number)", difficulty: level.difficulty, buttonAction: {

                self.questsDelegate?.start(level: level.resource)
            })
            levelButton.position = CGPoint(x: self.frame.width * level.position.x - self.frame.halfWidth, y: self.frame.height * level.position.y - self.frame.halfHeight)
            levelButton.zPosition = 1
            self.rootNode.addChild(levelButton)

            // add level score here
            var levelScoreValue = LevelScore.none
            if let levelScore = self.gameUsecase?.levelScore(for: Int32(level.number)) {
                levelScoreValue = levelScore
            }

            let starTexture = SKTexture(imageNamed: levelScoreValue.buttonName)
            let starSprite = SKSpriteNode(texture: starTexture, color: .black, size: CGSize(width: 20, height: 20))
            starSprite.position = CGPoint(x: self.frame.width * level.position.x - self.frame.halfWidth + 20, y: self.frame.height * level.position.y - self.frame.halfHeight + 20)
            starSprite.zPosition = 2
            self.rootNode.addChild(starSprite)
        }

        /*let generateButton = LevelButtonNode(titled: "G", difficulty: .easy, buttonAction: {

            self.requestMapType()
        })
        generateButton.position = CGPoint(x: self.frame.width * 0.9 - self.frame.halfWidth, y: self.frame.height * 0.8 - self.frame.halfHeight)
        generateButton.zPosition = 1
        self.addChild(generateButton)*/

        // copyright
        self.copyrightLabel = SKLabelNode(text: "Copyright 2019 MiRo & MaRo")
        self.copyrightLabel?.zPosition = 1
        self.copyrightLabel?.fontSize = 12
        self.cameraNode.addChild(self.copyrightLabel!)
        
        // back
        self.backButton = MenuButtonNode(titled: "Back",
                                         sized: CGSize(width: 150, height: 42),
                                         buttonAction: {
                                            self.questsDelegate?.quitQuests()
        })
        self.backButton?.zPosition = 1
        self.rootNode.addChild(self.backButton!)

        self.updateLayout()
        
        // debug
        /*let ddsFile = DDSFile(url: R.file.mapgermany512Dds())
        let texture = ddsFile.texture()
        
        let debugLabel = SKSpriteNode(texture: texture)
        debugLabel.zPosition = 25
        debugLabel.position = CGPoint(x: 0, y: 0)
        self.cameraNode.addChild(debugLabel)*/
        // debug

        // check if we have a user
        let userUsecase = UserUsecase()

        if !userUsecase.isCurrentUserExisting() {

            // ... ask the user if he wants to create a new user ...
            if let playerInputDialog = UI.playerInputDialog() {
                playerInputDialog.addOkayAction(handler: {

                    let username = playerInputDialog.getTextFieldInput()

                    if UserUsecase.isValid(name: username) {

                        //guard let currentUserCivilization = userUsecase.currentUser()?.civilization else {
                        //    fatalError("Can't get current users civilization")
                        //}
                        let currentUserCivilization: Civilization = .english

                        if userUsecase.createCurrentUser(named: username, civilization: currentUserCivilization) { // FIXME
                            playerInputDialog.close()
                        } else {
                            print("can't create user")
                        }
                    }
                })

                self.cameraNode.add(dialog: playerInputDialog)
            }
        }

        let gameUsecase = GameUsecase()

        // ask if user wants to continue last game
        // check if a backup exists ...
        if let game = gameUsecase.restoreGame() {

            // ... ask the user if he wants ...
            if let continueDialog = UI.continueDialog() {
                continueDialog.addOkayAction(handler: {

                    // ... and try to start it
                    self.questsDelegate?.restart(game: game)
                    continueDialog.close()
                })

                self.cameraNode.addChild(continueDialog)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self.backgroundNode0!)
            let previousLocation = touch.previousLocation(in: self.backgroundNode0!)

            let deltaY = (location.y) - (previousLocation.y)

            self.cameraNode.position.x = 0.0
            self.cameraNode.position.y -= deltaY * 0.7

            if self.cameraNode.position.y < 0 {
                self.cameraNode.position.y = 0
            }

            if self.cameraNode.position.y > (self.backgroundNode0?.frame.height)! * 2 {
                self.cameraNode.position.y = (self.backgroundNode0?.frame.height)! * 2
            }
        }
    }

    override func updateLayout() {

        super.updateLayout()

        let viewSize = (self.view?.bounds.size)!
        let backgroundTileHeight = 812 * viewSize.width / 375

        self.colonyTitleLabel?.position = CGPoint(x: 0, y: self.frame.halfHeight - 80)

        self.backgroundNode0?.position = CGPoint(x: 0.0, y: 0.0)
        self.backgroundNode0?.size = CGSize(width: viewSize.width, height: backgroundTileHeight)

        self.backgroundNode1?.position = CGPoint(x: 0.0, y: backgroundTileHeight)
        self.backgroundNode1?.size = CGSize(width: viewSize.width, height: backgroundTileHeight)

        self.backgroundNode2?.position = CGPoint(x: 0.0, y: 2 * backgroundTileHeight)
        self.backgroundNode2?.size = CGSize(width: viewSize.width, height: backgroundTileHeight)

        self.copyrightLabel?.position = CGPoint(x: 0, y: -self.frame.halfHeight + 18)
        
        self.backButton?.position = CGPoint(x: 100, y: -backgroundTileHeight / 2.0 + 80)
    }
}
