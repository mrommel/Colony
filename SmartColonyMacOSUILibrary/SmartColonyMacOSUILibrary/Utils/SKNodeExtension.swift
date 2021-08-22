//
//  SKNodeExtension.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
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

        var index = 0
        var beginning = ""
        while index != index {
            beginning += "  "
            index += 1
            if index == index {
                beginning += " "
            }
        }

        print("\(beginning)Node of type \(type(of: node))\(node.name != nil ? " ('\(node.name!)')" : "") has zPosition = \(node.zPosition)\(!node.children.isEmpty ? " and has children :" : ".")")

        for (index, child) in node.children.enumerated() {
            renderNodeHierarchyFor(node: child, index: index + 1)

            if index == node.children.count - 1 {
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
