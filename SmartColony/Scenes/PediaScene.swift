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
    
    var interimRankingDialogButton: MenuButtonNode?
    var cityDialogButton: MenuButtonNode?
    var scienceDialogButton: MenuButtonNode?
    var civicDialogButton: MenuButtonNode?
    var diplomaticDialogButton: MenuButtonNode?
    
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
        
        // interim
        self.interimRankingDialogButton = MenuButtonNode(titled: "InterimRanking",
            buttonAction: {
                self.showInterimRaking()
            })
        self.interimRankingDialogButton?.zPosition = 2
        self.rootNode.addChild(self.interimRankingDialogButton!)
        
        // city
        self.cityDialogButton = MenuButtonNode(titled: "CityDialog",
            buttonAction: {
                self.showCityDialog()
            })
        self.cityDialogButton?.zPosition = 2
        self.rootNode.addChild(self.cityDialogButton!)
        
        // science
        self.scienceDialogButton = MenuButtonNode(titled: "ScienceDialog",
            buttonAction: {
                self.showScienceDialog()
            })
        self.scienceDialogButton?.zPosition = 2
        self.rootNode.addChild(self.scienceDialogButton!)
        
        // civic
        self.civicDialogButton = MenuButtonNode(titled: "CivicDialog",
            buttonAction: {
                self.showCivicDialog()
            })
        self.civicDialogButton?.zPosition = 2
        self.rootNode.addChild(self.civicDialogButton!)
        
        // civic
        self.diplomaticDialogButton = MenuButtonNode(titled: "DiplomaticDialog",
            buttonAction: {
                self.showDiplomaticDialog()
            })
        self.diplomaticDialogButton?.zPosition = 2
        self.rootNode.addChild(self.diplomaticDialogButton!)
        
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

        self.civicDialogButton?.position = CGPoint(x: 0, y: -50)
        self.scienceDialogButton?.position = CGPoint(x: 0, y: -100)
        self.cityDialogButton?.position = CGPoint(x: 0, y: -150)
        self.interimRankingDialogButton?.position = CGPoint(x: 0, y: -200)
        self.diplomaticDialogButton?.position = CGPoint(x: 0, y: -250)
        
        self.backButton?.position = CGPoint(x: 0, y: -viewSize.halfHeight + 50)
    }
    
    // MARK: dialogs
    
    func showCityDialog() {
        
        let player = Player(leader: .alexander, isHuman: true)
        player.initialize()
        
        var mapModel = PediaScene.mapFilled(with: .grass, sized: .duel)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(hills: true, at: HexPoint(x: 1, y: 2))
        mapModel.set(resource: .wheat, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))
        mapModel.set(resource: .iron, at: HexPoint(x: 3, y: 2))
        
        let gameModel = GameModel(victoryTypes: [.domination], handicap: .settler, turnsElapsed: 0, players: [player], on: mapModel)
        
        GameViewModel.discover(mapModel: &mapModel, by: player, in: gameModel)
        
        let city = City(name: "Berlin", at: HexPoint(x: 2, y: 2), capital: true, owner: player)
        city.initialize(in: gameModel)
        gameModel.add(city: city)
        
        city.turn(in: gameModel)
        
        // debug
        try! player.techs?.discover(tech: .masonry)
        try! player.techs?.discover(tech: .mining)
        try! city.buildings?.build(building: .monument)
        //city.startBuilding(building: .granary)
        
        let cityDialog = CityDialog(for: city, in: gameModel)
        cityDialog.zPosition = 250
               
        cityDialog.addCancelAction(handler: {
            cityDialog.close()
        })
        
        self.cameraNode.add(dialog: cityDialog)
    }
    
    func showScienceDialog() {
        
        let player = Player(leader: .alexander, isHuman: false)
        player.initialize()
        
        // debug
        try! player.techs?.discover(tech: .mining)
    
        let scienceDialog = TechDialog(with: player.techs)
        scienceDialog.zPosition = 250
               
        scienceDialog.addCancelAction(handler: {
            scienceDialog.close()
        })
        
        scienceDialog.addResultHandler(handler: { result in
            print("result: \(result) => \(result.toTech())")
            scienceDialog.close()
        })
        
        self.cameraNode.add(dialog: scienceDialog)
    }
    
    func showCivicDialog() {
        
        let player = Player(leader: .alexander, isHuman: false)
        player.initialize()
        
        // debug
        try! player.civics?.discover(civic: .codeOfLaws)
    
        let civicDialog = CivicDialog(with: player.civics)
        civicDialog.zPosition = 250
               
        civicDialog.addCancelAction(handler: {
            civicDialog.close()
        })
        
        civicDialog.addResultHandler(handler: { result in
            print("result: \(result) => \(result.toCivic())")
            civicDialog.close()
        })
        
        self.cameraNode.add(dialog: civicDialog)
    }
    
    func showInterimRaking() {
        
        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()
        
        let aiPlayer = Player(leader: .augustus, isHuman: false)
        aiPlayer.initialize()
        
        let rankingData = RankingData(players: [humanPlayer, aiPlayer])
        rankingData.add(score: 0, for: .alexander)
        rankingData.add(score: 0, for: .augustus)
        
        rankingData.add(score: 8, for: .alexander)
        rankingData.add(score: 12, for: .augustus)
        
        let interimRankingDialog = InterimRankingDialog(for: humanPlayer, with: rankingData)
        interimRankingDialog.zPosition = 250

        interimRankingDialog.addOkayAction(handler: {
            interimRankingDialog.close()
        })

        self.cameraNode.add(dialog: interimRankingDialog)
    }
    
    func showDiplomaticDialog() {
        
        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()
        
        let otherPlayer = Player(leader: .augustus, isHuman: false)
        otherPlayer.initialize()
        
        let diplomaticDialog = DiplomaticDialog(for: humanPlayer, and: otherPlayer)
        diplomaticDialog.zPosition = 250

        diplomaticDialog.addResultHandler(handler: { result in
            print("result: \(result)")
            diplomaticDialog.close()
        })

        self.cameraNode.add(dialog: diplomaticDialog)
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
