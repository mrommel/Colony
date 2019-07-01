//
//  BottomLeftBar.swift
//  Colony
//
//  Created by Michael Rommel on 30.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class BottomLeftBar: SKNode {
    
    //var backgroundNode: SKSpriteNode?
    var mapOverviewNode: MapOverviewNode?
    
    init(with map: HexagonTileMap?, sized size: CGSize) {
        
        super.init()
        
        self.zPosition = 49 // FIXME: move to constants
        
        /*let backgroundTexture = SKTexture(imageNamed: "green")
        self.backgroundNode = SKSpriteNode(texture: backgroundTexture, color: .black, size: size)
        self.backgroundNode?.anchorPoint = .lowerLeft
        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.zPosition = 50
        
        if let backgroundNode = self.backgroundNode {
            self.addChild(backgroundNode)
        }*/
        
        let mapOverviewBodyTexture = SKTexture(imageNamed: "map_overview_body")
        let mapOverviewBody = SKSpriteNode(texture: mapOverviewBodyTexture, color: .black, size: CGSize(width: 200, height: 112))
        mapOverviewBody.position = CGPoint(x: 0, y: 0)
        mapOverviewBody.zPosition = 49
        mapOverviewBody.anchorPoint = .lowerLeft
        self.addChild(mapOverviewBody)
        
        let mapOverlayTexture = SKTexture(imageNamed: "map_overlay")
        let mapOverlay = SKSpriteNode(texture: mapOverlayTexture, color: .black, size: CGSize(width: 157, height: 95))
        mapOverlay.position = CGPoint(x: 9, y: 1)
        mapOverlay.zPosition = 51
        mapOverlay.anchorPoint = .lowerLeft
        self.addChild(mapOverlay)
        
        self.mapOverviewNode = MapOverviewNode(with: map, size: CGSize(width: 157, height: 95))
        self.mapOverviewNode?.position = CGPoint(x: 9, y: 1)
        self.mapOverviewNode?.zPosition = 50
        self.mapOverviewNode?.anchorPoint = .lowerLeft
        self.addChild(self.mapOverviewNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayout() {
        
        // scene is needed and main view
        guard let scene = scene, let view = scene.view else {
            return
        }
        
        // width is view width
        //self.frame = CGRect(x: x - offsetX, y: y - offsetY, width: width, height: height)
    }
}
