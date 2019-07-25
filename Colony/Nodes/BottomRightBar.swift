//
//  BottomRightBar.swift
//  Colony
//
//  Created by Michael Rommel on 30.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol BottomRightBarDelegate: class {
    
    func focus(on point: HexPoint)
}

class BottomRightBar: SizedNode {

    var backgroundBodyNode: SKSpriteNode?
    var mapOverviewNode: MapOverviewNode?
    var mapOverlay: SKSpriteNode?
    
    let mapSize: CGSize!
    weak var delegate: BottomRightBarDelegate?
    
    init(for level: Level?, sized size: CGSize) {

        self.mapSize = level?.map.size
        
        super.init(sized: size)

        self.anchorPoint = .lowerRight
        self.zPosition = 49 // FIXME: move to constants
        
        let backgroundTexture = SKTexture(imageNamed: "unit_selector_body")
        self.backgroundBodyNode = SKSpriteNode(texture: backgroundTexture, color: .black, size: size)
        self.backgroundBodyNode?.anchorPoint = .lowerLeft
        self.backgroundBodyNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundBodyNode?.zPosition = 50
        
        if let backgroundBodyNode = self.backgroundBodyNode {
            self.addChild(backgroundBodyNode)
        }
        
        self.mapOverviewNode = MapOverviewNode(with: level?.map, size: CGSize(width: 157, height: 95))
        self.mapOverviewNode?.position = CGPoint(x: 9, y: 1)
        self.mapOverviewNode?.zPosition = 51 // FIXME: move to constants
        self.mapOverviewNode?.anchorPoint = .lowerLeft
        
        if let mapOverviewNode = self.mapOverviewNode {
            self.addChild(mapOverviewNode)
        }
        
        let mapOverlayTexture = SKTexture(imageNamed: "map_overlay")
        self.mapOverlay = SKSpriteNode(texture: mapOverlayTexture, color: .black, size: CGSize(width: 157, height: 95))
        self.mapOverlay?.position = CGPoint(x: 9, y: 1)
        self.mapOverlay?.zPosition = 52 // FIXME: move to constants
        self.mapOverlay?.anchorPoint = .lowerLeft
        
        if let mapOverlay = self.mapOverlay {
            self.addChild(mapOverlay)
        }
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
        print("BottomRightBar: location = \(location)")
        let innerLocation = location - mapOverviewNode.position
        print("BottomRightBar: innerLocation = \(innerLocation)")
        
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
    }
}
