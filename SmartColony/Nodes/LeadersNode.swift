//
//  LeadersNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 03.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

protocol LeadersDelegate: class {
    
    func handleClicked(on leader: LeaderType)
}

class LeadersNode: SizedNode {
    
    // TODO: model?
    var leaders: [LeaderType] = []
    
    // nodes
    var leaderBagdeNodes: [SKSpriteNode?] = []
    var leaderIconNodes: [TouchableSpriteNode?] = []
    
    weak var delegate: LeadersDelegate?
    
    // MARK: constructors
    
    override init(sized size: CGSize) {

        super.init(sized: size)
    
        self.anchorPoint = .upperRight
        self.zPosition = Globals.ZLevels.sceneElements
        
        self.rebuildLeaderBadges()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: public methods
    
    func add(leader: LeaderType) {
        
        self.leaders.append(leader)
        self.rebuildLeaderBadges()
    }
    
    override func updateLayout() {
        
        for (index, leaderBagdeNode) in self.leaderBagdeNodes.enumerated() {
            leaderBagdeNode?.position = self.position + CGPoint(x: 48, y: 210 - (index * 65))
        }
        for (index, leaderIconNode) in self.leaderIconNodes.enumerated() {
            leaderIconNode?.position = self.position + CGPoint(x: 48 - 4, y: 210 - 4 - (index * 65))
        }
    }
    
    func handleTouches(_ touches: Set<UITouch>, with event: UIEvent?) -> Bool {
    
        let touch = touches.first!
    
        let location = touch.location(in: self)
        
        for (index, leaderBagdeNode) in self.leaderBagdeNodes.enumerated() {
            
            if leaderBagdeNode!.frame.contains(location) {
                let leader = self.leaders[index]
                self.delegate?.handleClicked(on: leader)
                return true
            }
        }
        
        return false
    }
    
    // MARK: private methods
    
    private func rebuildLeaderBadges() {
    
        // ensure that this runs on UI thread
        DispatchQueue.main.async {
            
            for leaderBagdeNode in self.leaderBagdeNodes {
                leaderBagdeNode?.removeFromParent()
            }
            
            for leaderIconNode in self.leaderIconNodes {
                leaderIconNode?.removeFromParent()
            }
            
            self.leaderBagdeNodes.removeAll()
            self.leaderIconNodes.removeAll()
            
            for leader in self.leaders {
                
                let leaderBadgeTexture = SKTexture(imageNamed: "diplo_frame")
                let leaderBadgeNode = SKSpriteNode(texture: leaderBadgeTexture, color: .black, size: CGSize(width: 48, height: 48))
                leaderBadgeNode.zPosition = self.zPosition + 0.1
                leaderBadgeNode.anchorPoint = .upperRight
                self.addChild(leaderBadgeNode)
                
                self.leaderBagdeNodes.append(leaderBadgeNode)
                
                let buttonIconTextureName = leader.iconTexture()
                let leaderIconNode = TouchableSpriteNode(imageNamed: buttonIconTextureName, size: CGSize(width: 38, height: 38))
                leaderIconNode.zPosition = self.zPosition + 0.2
                leaderIconNode.anchorPoint = .upperRight
                self.addChild(leaderIconNode)
                
                self.leaderIconNodes.append(leaderIconNode)
            }
            
            self.updateLayout()
        }
    }
}
