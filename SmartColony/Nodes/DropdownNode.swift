//
//  DropdownNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

struct DropdownItem {

    let imageName: String
    let title: String
}

protocol DropdownPanelDelegate: class {
    
    func selected(item: DropdownItem, at index: Int)
}

class DropdownPanelNode: NineGridTextureSprite {

    let items: [DropdownItem]
    var itemNodes: [SpriteButtonNode] = []
    weak var delegate: DropdownPanelDelegate?

    init(items: [DropdownItem], size: CGSize) {

        self.items = items

        super.init(imageNamed: "grid9_frame_filled", size: size)

        self.isUserInteractionEnabled = true

        var y = -26
        for item in self.items {

            let itemLabel = SpriteButtonNode(imageNamed: item.imageName, title: item.title, defaultButtonImage: "grid9_dropdown_background_normal", hoverButtonImage: "grid9_dropdown_background_hover", activeButtonImage: "grid9_dropdown_background_selected", size: CGSize(width: 180, height: 35), buttonAction: { })
            itemLabel.position = CGPoint(x: 2, y: y + 5)
            itemLabel.zPosition = self.zPosition + 1
            self.addChild(itemLabel)

            self.itemNodes.append(itemLabel)
            y = y - 40
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        //print("dropdown - began")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        for itemNode in self.itemNodes {
            // highlight / unhighlight
            itemNode.touchesMoved(touches, with: event)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch: UITouch = touches.first {

            let location: CGPoint = touch.location(in: self)

            for index in 0..<self.itemNodes.count {
                let itemNode = itemNodes[index]
                if itemNode.contains(location) {
                    
                    // unhighlight item
                    itemNode.touchesEnded(touches, with: event)
                    
                    // select item
                    self.delegate?.selected(item: items[index], at: index)
                }
            }
        }
    }
}

protocol DropdownDelegate: class {
    
    func selected(item: DropdownItem, at index: Int)
    func dropdownClicked()
}

class DropdownNode: NineGridTextureSprite {

    var selectedIndex: Int = 0

    var selectedItemLabel: SKLabelNode
    var selectedItemImage: SKSpriteNode
    var panelNode: DropdownPanelNode

    weak var delegate: DropdownDelegate?

    init(items: [DropdownItem], selectedIndex: Int, size: CGSize) {

        self.selectedItemLabel = SKLabelNode()
        self.selectedItemImage = SKSpriteNode()

        let panelSize = CGSize(width: size.width, height: CGFloat(40 * items.count))
        self.panelNode = DropdownPanelNode(items: items, size: panelSize)

        self.selectedIndex = selectedIndex
        super.init(imageNamed: "grid9_frame", size: size)

        self.isUserInteractionEnabled = true

        self.selectedItemImage.texture = SKTexture(imageNamed: items[selectedIndex].imageName)
        self.selectedItemImage.size = CGSize(width: 24, height: 16)
        self.selectedItemImage.position = CGPoint(x: self.position.x - self.size.halfWidth + 18, y: self.position.y)
        self.selectedItemImage.zPosition = self.zPosition + 3
        self.selectedItemImage.name = "selectedItemImage"
        self.addChild(self.selectedItemImage)
        
        self.selectedItemLabel.text = items[selectedIndex].title
        self.selectedItemLabel.position = CGPoint(x: self.position.x - self.size.halfWidth + 38, y: self.position.y)
        self.selectedItemLabel.zPosition = self.zPosition + 3
        self.selectedItemLabel.fontColor = UIColor.white
        self.selectedItemLabel.fontSize = 18
        self.selectedItemLabel.fontName = Globals.Fonts.customFontFamilyname
        self.selectedItemLabel.verticalAlignmentMode = .center
        self.selectedItemLabel.horizontalAlignmentMode = .left
        self.selectedItemLabel.name = "selectedItemLabel"
        self.addChild(self.selectedItemLabel)

        self.panelNode.position = CGPoint(x: self.position.x, y: self.position.y - self.size.halfHeight)
        self.panelNode.zPosition = self.zPosition + 4
        self.panelNode.anchorPoint = .upperCenter
        self.panelNode.isUserInteractionEnabled = true
        self.panelNode.isHidden = true
        self.panelNode.delegate = self
        self.addChild(self.panelNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: methods

    // MARK: action handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        //print("dropdown - began")
        self.panelNode.isHidden = false
        self.delegate?.dropdownClicked()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        //print("dropdown - moved")
        if let touch: UITouch = touches.first {

            let location: CGPoint = touch.location(in: self)
            if panelNode.contains(location) {
                self.panelNode.touchesMoved(touches, with: event)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        //print("dropdown - ended")
        self.panelNode.isHidden = true

        if let touch: UITouch = touches.first {

            let location: CGPoint = touch.location(in: self)
            if panelNode.contains(location) {
                self.panelNode.touchesEnded(touches, with: event)
            }
        }
    }
}

extension DropdownNode: DropdownPanelDelegate {
    
    func selected(item: DropdownItem, at index: Int) {
        
        self.selectedItemImage.texture = SKTexture(imageNamed: item.imageName)
        self.selectedItemLabel.text = item.title
        self.selectedIndex = index
        
        self.delegate?.selected(item: item, at: index)
    }
}
