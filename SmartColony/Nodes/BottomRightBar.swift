//
//  BottomRightBar.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

protocol BottomRightBarDelegate: class {
    
    func focus(on point: HexPoint)
    
    func showYields()
    func hideYields()
}

class BottomRightBar: SizedNode {

    var backgroundBodyNode: SKSpriteNode?
    var mapOverviewNode: MapOverviewNode?
    var mapOverlay: SKSpriteNode?
    var yieldsButton: SKSpriteNode?
    var yieldsShown: Bool = false
    
    let mapSize: CGSize!
    weak var delegate: BottomRightBarDelegate?
    
    init(for gameModel: GameModel?, sized size: CGSize) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        self.mapSize = CGSize(width: gameModel.mapSize().width(), height: gameModel.mapSize().height()) 
        
        super.init(sized: size)

        self.anchorPoint = .lowerRight
        self.zPosition = Globals.ZLevels.sceneElements
        
        let backgroundTexture = SKTexture(imageNamed: "unit_selector_body")
        self.backgroundBodyNode = SKSpriteNode(texture: backgroundTexture, color: .black, size: size)
        self.backgroundBodyNode?.anchorPoint = .lowerLeft
        self.backgroundBodyNode?.zPosition = self.zPosition + 0.1
        self.addChild(self.backgroundBodyNode!)
        
        self.mapOverviewNode = MapOverviewNode(with: gameModel, size: CGSize(width: 157, height: 95))
        self.mapOverviewNode?.zPosition = self.zPosition + 0.2
        self.mapOverviewNode?.anchorPoint = .lowerLeft
        self.addChild(self.mapOverviewNode!)
        
        let mapOverlayTexture = SKTexture(imageNamed: "map_overlay")
        self.mapOverlay = SKSpriteNode(texture: mapOverlayTexture, color: .black, size: CGSize(width: 157, height: 95))
        self.mapOverlay?.zPosition = self.zPosition + 0.3
        self.mapOverlay?.anchorPoint = .lowerLeft
        self.addChild(self.mapOverlay!)
        
        let mapOptionYieldsTexture = SKTexture(imageNamed: "map_option_yields_disabled")
        self.yieldsButton = SKSpriteNode(texture: mapOptionYieldsTexture, size: CGSize(width: 43, height: 37))
        self.yieldsButton?.zPosition = self.zPosition + 0.3
        self.yieldsButton?.anchorPoint = .lowerLeft
        self.addChild(self.yieldsButton!)
        
        self.updateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        
        guard let mapOverviewNode = self.mapOverviewNode else {
            return
        }
        
        let location = touch.location(in: self)
        let innerLocation = location - mapOverviewNode.position
        
        if self.yieldsButton?.contains(location) ?? false {
            // print("inside yields")
            if self.yieldsShown {
                self.delegate?.showYields()
                self.yieldsButton?.texture = SKTexture(imageNamed: "map_option_yields")
                self.yieldsShown = false
            } else {
                self.delegate?.hideYields()
                self.yieldsButton?.texture = SKTexture(imageNamed: "map_option_yields_disabled")
                self.yieldsShown = true
            }
            return
        }
        
        let imageWidth = mapOverviewNode.frame.height * self.mapSize.width / self.mapSize.height
        let x = innerLocation.x / imageWidth * self.mapSize.width
        let y = self.mapSize.height - (innerLocation.y / mapOverviewNode.frame.height * self.mapSize.height)
        let newFocus = HexPoint(x: Int(x), y: Int(y))
        print("BottomRightBar: newFocus = \(newFocus)")
        self.delegate?.focus(on: newFocus)
    }
    
    override func updateLayout() {
        
        self.backgroundBodyNode?.position = self.position
        self.mapOverviewNode?.position = self.position + CGPoint(x: 59, y: 1)
        self.mapOverlay?.position = self.position + CGPoint(x: 59, y: 1)
        self.yieldsButton?.position = self.position + CGPoint(x: 135, y: 90)
    }
    
    func update(tile: AbstractTile?) {
        
        if let tile = tile {

            self.mapOverviewNode?.changed(at: tile.point)
        }
    }
}
