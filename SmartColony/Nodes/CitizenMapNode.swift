//
//  CitizenMapNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 08.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

protocol CitizenMapNodeDelegate: class {
    
    func clicked(on point: HexPoint)
}

class CitizenMapNode: SKNode {

    // MARK: layer

    var terrainLayer: TerrainLayer
    var featureLayer: FeatureLayer
    var resourceLayer: ResourceLayer
    var boardLayer: BoardLayer
    var riverLayer: RiverLayer

    // can be shown by map options
    var yieldLayer: YieldLayer
    var waterLayer: WaterLayer

    var unitLayer: UnitLayer
    var cityLayer: CityLayer
    var improvementLayer: ImprovementLayer
    var borderLayer: BorderLayer
    
    var citizenLayer: CitizenLayer
    
    // MARK: properties

    private var game: GameModel?
    
    // MARK: delegate
    
    weak var delegate: CitizenMapNodeDelegate?

    // MARK: constructors
    
    init(for city: AbstractCity?, in game: GameModel?) {

        self.game = game
        
        guard let game = self.game else {
            fatalError("cant get game")
        }
        
        let humanPlayer = game.humanPlayer()

        self.terrainLayer = TerrainLayer(player: humanPlayer)
        self.terrainLayer.populate(with: self.game)
        self.terrainLayer.zPosition = Globals.ZLevels.terrain
        
        self.borderLayer = BorderLayer(player: humanPlayer)
        self.borderLayer.populate(with: self.game)
        self.borderLayer.zPosition = Globals.ZLevels.border

        self.featureLayer = FeatureLayer(player: humanPlayer)
        self.featureLayer.populate(with: self.game)
        self.featureLayer.zPosition = Globals.ZLevels.feature
        
        self.resourceLayer = ResourceLayer(player: humanPlayer)
        self.resourceLayer.populate(with: self.game)
        self.resourceLayer.zPosition = Globals.ZLevels.resource

        self.boardLayer = BoardLayer(player: humanPlayer)
        self.boardLayer.populate(with: self.game)
        self.boardLayer.zPosition = Globals.ZLevels.caldera

        self.riverLayer = RiverLayer(player: humanPlayer)
        self.riverLayer.populate(with: self.game)
        
        self.unitLayer = UnitLayer(player: humanPlayer)
        self.unitLayer.populate(with: self.game)
        self.unitLayer.zPosition = Globals.ZLevels.unit
        
        self.cityLayer = CityLayer(player: humanPlayer)
        self.cityLayer.populate(with: self.game)
        self.cityLayer.zPosition = Globals.ZLevels.city
        
        self.improvementLayer = ImprovementLayer(player: humanPlayer)
        self.improvementLayer.populate(with: self.game)
        self.improvementLayer.zPosition = Globals.ZLevels.improvement

        self.yieldLayer = YieldLayer(player: humanPlayer)
        self.yieldLayer.populate(with: self.game)
        self.yieldLayer.zPosition = Globals.ZLevels.yields
        
        self.waterLayer = WaterLayer(player: humanPlayer)
        self.waterLayer.populate(with: self.game)
        self.waterLayer.zPosition = Globals.ZLevels.water
        
        self.citizenLayer = CitizenLayer(city: city)
        self.citizenLayer.populate(with: self.game)
        self.citizenLayer.zPosition = Globals.ZLevels.citizen
        
        super.init()
        
        self.zPosition = 0
        self.xScale = 2.0
        self.yScale = 2.0

        self.addChild(self.terrainLayer)
        self.addChild(self.featureLayer)
        self.addChild(self.resourceLayer)
        self.addChild(self.boardLayer)
        self.addChild(self.riverLayer)
        self.addChild(self.unitLayer)
        self.addChild(self.cityLayer)
        self.addChild(self.improvementLayer)
        self.addChild(self.yieldLayer)
        self.addChild(self.borderLayer)
        
        // add citizen
        self.addChild(self.citizenLayer)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func center(on point: HexPoint) {
        
        let point = HexPoint.toScreen(hex: point)
        let shift = CGPoint(x: -(point.x + 24), y: -(point.y + 28))
        
        self.terrainLayer.position = shift
        self.terrainLayer.position = shift
        self.featureLayer.position = shift
        self.resourceLayer.position = shift
        self.boardLayer.position = shift
        self.riverLayer.position = shift
        self.unitLayer.position = shift
        self.cityLayer.position = shift
        self.improvementLayer.position = shift
        self.borderLayer.position = shift
        self.yieldLayer.position = shift
        self.citizenLayer.position = shift
    }
    
    func refresh() {
        
        self.citizenLayer.refresh()
    }
    
    // MARK: touch handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // propergate to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // propergate to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)

            // propergate to scrollview
            if let scrollNode = self.parent?.parent as? ScrollNode {
                
                let scrollNodeLocation: CGPoint = touch.location(in: scrollNode)
                let scrollNodeFrame = CGRect(origin: CGPoint(x: -scrollNode.size.halfWidth, y: -scrollNode.size.halfHeight), size: scrollNode.size)
                
                if scrollNodeFrame.contains(scrollNodeLocation) {
                
                    let selectedPoint = HexPoint(screen: location - self.terrainLayer.position)
                    self.delegate?.clicked(on: selectedPoint)
                }
            }
        }
    }
}
