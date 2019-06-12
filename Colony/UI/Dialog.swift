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
        self.zPosition = dialogLevel
        
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
                        break
                    case .cancel:
                        if let handler = self?.cancelHandler {
                            handler()
                        }
                        break
                    case .none:
                        fatalError("Button without action")
                    }
                })
                buttonItem.position = item.positionIn(parent: self.size)
                buttonItem.zPosition = dialogLevel + 1.0
                self.addChild(buttonItem)
            }
            
            if item.type == .image {
                let texture = SKTexture(imageNamed: item.image)
                let imageItem = SKSpriteNode(texture: texture, size: item.size)
                imageItem.position = item.positionIn(parent: self.size)
                imageItem.zPosition = dialogLevel + 1.0
                self.addChild(imageItem)
            }
            
            if item.type == .label {
                let labelItem = SKLabelNode(text: item.title)
                labelItem.position = item.positionIn(parent: self.size)
                labelItem.zPosition = dialogLevel + 1.0
                self.addChild(labelItem)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
