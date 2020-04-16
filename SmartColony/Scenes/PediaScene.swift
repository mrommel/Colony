//
//  PediaScene.swift
//  SmartColony
//
//  Created by Michael Rommel on 14.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

protocol PediaDelegate: class {

    func exit()
}

class PediaScene: BaseScene {
    
    // variables
    var backgroundNode: SKSpriteNode?
    
    var cityDialogButton: MenuButtonNode?
    
    var backButton: MenuButtonNode?
    
    // delegate
    weak var pediaDelegate: PediaDelegate?
    
    override init(size: CGSize) {
        super.init(size: size, layerOrdering: .nodeLayerOnTop)
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
        
        // city
        self.cityDialogButton = MenuButtonNode(titled: "CityDialog",
            buttonAction: {
                self.showCityDialog()
            })
        self.cityDialogButton?.zPosition = 2
        self.rootNode.addChild(self.cityDialogButton!)
        
        // back
        self.backButton = MenuButtonNode(titled: "Back",
            buttonAction: {
                self.pediaDelegate?.exit()
            })
        self.backButton?.zPosition = 2
        self.rootNode.addChild(self.backButton!)
        
        self.updateLayout()
    }
    
    override func updateLayout() {

        super.updateLayout()

        let viewSize = (self.view?.bounds.size)!

        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.aspectFillTo(size: viewSize)

        
        self.backButton?.position = CGPoint(x: 0, y: -viewSize.halfHeight + 50)
    }
    
    // MARK: dialogs
    
    func showCityDialog() {
        
        let player = Player(leader: .alexander, isHuman: false)
        player.initialize()
        
        let mapModel = PediaScene.mapFilled(with: .grass, sized: .duel)
        let gameModel = GameModel(victoryTypes: [.domination], handicap: .settler, turnsElapsed: 0, players: [player], on: mapModel)
        
        let city = City(name: "Berlin", at: HexPoint(x: 2, y: 2), capital: false, owner: player)
        city.initialize(in: gameModel)
        gameModel.add(city: city)
        
        let cityDialog = CityDialog(for: city, in: gameModel)
        cityDialog.zPosition = 250
               
        cityDialog.addCancelAction(handler: {
            cityDialog.close()
        })
        
        self.cameraNode.addChild(cityDialog)
    }
    
    static func mapFilled(with terrain: TerrainType, sized size: MapSize) -> MapModel {
        
        let mapModel = MapModel(size: size)
        
        let mapSize = mapModel.size
        for x in 0..<mapSize.width() {
            
            for y in 0..<mapSize.height() {
                
                mapModel.set(terrain: terrain, at: HexPoint(x: x, y: y))
            }
        }
        
        return mapModel
    }
}
