//
//  SKNode+Extension.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

public extension SKNode {

    /**
     Run an action with key & optional completion function.
     - parameter action:     `SKAction!` SpriteKit action.
     - parameter withKey:    `String!` action key.
     - parameter completion: `() -> Void?` optional completion function.
     */
    func run(_ action: SKAction!, withKey: String!, completion block: (() -> Void)?) {
        if let block = block {
            let completionAction = SKAction.run(block)
            let compositeAction = SKAction.sequence([action, completionAction])
            run(compositeAction, withKey: withKey)
        } else {
            run(action, withKey: withKey)
        }
    }
}

extension SKNode {

    var positionInScene: CGPoint? {

        if let scene = self.scene, let parent = self.parent {
            return parent.convert(self.position, to: scene)
        } else {
            return nil
        }
    }
    
    func renderNodeHierarchy() {
        self.renderNodeHierarchyFor(node: self)
    }

    func renderNodeHierarchyFor(node: SKNode, index: Int) {

        var i = 0
        var beginning = ""
        while i != index {
            beginning += "          "
            i += 1
            if i == index {
                beginning += " "
            }
        }

        print("\(beginning)Node of type \(type(of: node))\(node.name != nil ? " ('\(node.name!)')" : "") has zPosition = \(node.zPosition)\(node.children.count > 0 ? " and has children :" : ".")")
        
        for (i, child) in node.children.enumerated() {
            renderNodeHierarchyFor(node: child, index: index + 1)

            if i == node.children.count - 1 {
                print("")
            }
        }
    }

    func renderNodeHierarchyFor(node: SKNode) {
        renderNodeHierarchyFor(node: node, index: 0)
    }
}

extension SKSpriteNode {

    func addGlow(radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        self.addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": radius])
    }
}
