//
//  BottomLeftBar.swift
//  Colony
//
//  Created by Michael Rommel on 30.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class BottomLeftBar: SizedNode {
    
    var mapOverviewBody: SKSpriteNode?
    var mapOverviewNode: MapOverviewNode?
    var mapOverlay: SKSpriteNode?
    
    init(with map: HexagonTileMap?, sized size: CGSize) {

        super.init(sized: size)
        
        self.anchorPoint = .lowerLeft
        self.zPosition = 49 // FIXME: move to constants
        
        let mapOverviewBodyTexture = SKTexture(imageNamed: "map_overview_body")
        self.mapOverviewBody = SKSpriteNode(texture: mapOverviewBodyTexture, color: .black, size: CGSize(width: 200, height: 112))
        self.mapOverviewBody?.position = CGPoint(x: 0, y: 0)
        self.mapOverviewBody?.zPosition = 49
        self.mapOverviewBody?.anchorPoint = .lowerLeft
        
        if let mapOverviewBody = self.mapOverviewBody {
            self.addChild(mapOverviewBody)
        }
        
        self.mapOverviewNode = MapOverviewNode(with: map, size: CGSize(width: 157, height: 95))
        self.mapOverviewNode?.position = CGPoint(x: 9, y: 1)
        self.mapOverviewNode?.zPosition = 50
        self.mapOverviewNode?.anchorPoint = .lowerLeft
        
        if let mapOverviewNode = self.mapOverviewNode {
            self.addChild(mapOverviewNode)
        }
        
        let mapOverlayTexture = SKTexture(imageNamed: "map_overlay")
        self.mapOverlay = SKSpriteNode(texture: mapOverlayTexture, color: .black, size: CGSize(width: 157, height: 95))
        self.mapOverlay?.position = CGPoint(x: 9, y: 1)
        self.mapOverlay?.zPosition = 51
        self.mapOverlay?.anchorPoint = .lowerLeft
        
        if let mapOverlay = self.mapOverlay {
            self.addChild(mapOverlay)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayout() {
        
        self.mapOverviewBody?.position = self.position
        self.mapOverviewNode?.position = self.position + CGPoint(x: 9, y: 1)
        self.mapOverlay?.position = self.position + CGPoint(x: 9, y: 1)
    }
}
