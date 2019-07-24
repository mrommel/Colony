//
//  Dialog.swift
//  Colony
//
//  Created by Michael Rommel on 11.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Dialog: NineGridTextureSprite {
    private let dialogLevel: CGFloat = 100.0
    
    var okayHandler: (() -> Void)?
    var cancelHandler: (() -> Void)?
    
    init(from configuration: DialogConfiguration) {
        super.init(imageNamed: configuration.background,
                   size: configuration.size)
        
        self.position = configuration.position
        self.zPosition = self.dialogLevel
        
        // position of childs
        // https://stackoverflow.com/questions/33099051/how-to-position-child-skspritenodes-inside-their-parents
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        // items
        for item in configuration.items.item {
            if item.type == .button {
                let buttonItem = MessageBoxButtonNode(titled: item.title, buttonAction: { [weak self] in
                    switch item.result {
                    case .okay:
                        if let handler = self?.okayHandler {
                            handler()
                        }
                    case .cancel:
                        if let handler = self?.cancelHandler {
                            handler()
                        }
                    case .none:
                        fatalError("Button without action")
                    }
                })
                buttonItem.name = item.identifier
                buttonItem.position = item.positionIn(parent: self.size)
                buttonItem.zPosition = self.dialogLevel + 1.0
                self.addChild(buttonItem)
            }
            
            if item.type == .image {
                let texture = SKTexture(imageNamed: item.image)
                let imageItem = SKSpriteNode(texture: texture, size: item.size)
                imageItem.name = item.identifier
                imageItem.position = item.positionIn(parent: self.size)
                imageItem.zPosition = self.dialogLevel + 1.0
                self.addChild(imageItem)
            }
            
            if item.type == .label {
                let labelItem = SKLabelNode(text: item.title)
                labelItem.name = item.identifier
                labelItem.position = item.positionIn(parent: self.size)
                labelItem.zPosition = self.dialogLevel + 1.0
                labelItem.fontSize = item.fontSize
                
                self.addChild(labelItem)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(text: String, identifier: String) {
        guard let node = self.children.first(where: { $0.name == identifier }) else {
            fatalError("Can't find \(identifier)")
        }
        
        guard let label = node as? SKLabelNode else {
            fatalError("identifier does not identify a label")
        }
        
        label.text = text
    }
    
    func set(imageNamed imageName: String, identifier: String) {
        guard let node = self.children.first(where: { $0.name == identifier }) else {
            fatalError("Can't find \(identifier)")
        }
        
        guard let spriteNode = node as? SKSpriteNode else {
            fatalError("identifier does not identify a spriteNode")
        }
        
        let texture = SKTexture(imageNamed: imageName)
        
        spriteNode.texture = texture
    }
    
    func addOkayAction(handler: @escaping () -> Void) {
        self.okayHandler = handler
    }
    
    func addCancelAction(handler: @escaping () -> Void) {
        self.cancelHandler = handler
    }
    
    func close() {
        self.parent?.removeChildren(in: [self])
    }
}
