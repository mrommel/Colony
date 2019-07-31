//
//  Dialog.swift
//  Colony
//
//  Created by Michael Rommel on 11.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import UIKit

class Dialog: NineGridTextureSprite {
    
    var okayHandler: (() -> Void)?
    var cancelHandler: (() -> Void)?
    
    fileprivate var didAddTo: ((_ scene: SKScene?) -> Void)?
    
    var textField: UITextField?
    
    init(from configuration: DialogConfiguration) {
        super.init(imageNamed: configuration.background,
                   size: configuration.size)
        
        self.position = configuration.position
        self.zPosition = GameScene.Constants.ZLevels.dialogs
        
        // position of childs
        // https://stackoverflow.com/questions/33099051/how-to-position-child-skspritenodes-inside-their-parents
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        // items
        for item in configuration.items.item {
            
            switch item.type {
            case .button:
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
                buttonItem.zPosition = GameScene.Constants.ZLevels.dialogs + 1.0
                self.addChild(buttonItem)
                
            case .image:
                let texture = SKTexture(imageNamed: item.image)
                let imageItem = SKSpriteNode(texture: texture, size: item.size)
                imageItem.name = item.identifier
                imageItem.position = item.positionIn(parent: self.size)
                imageItem.zPosition = GameScene.Constants.ZLevels.dialogs + 1.0
                self.addChild(imageItem)
                
            case .label:
                let labelItem = SKLabelNode(text: item.title)
                labelItem.name = item.identifier
                labelItem.position = item.positionIn(parent: self.size)
                labelItem.zPosition = GameScene.Constants.ZLevels.dialogs + 1.0
                labelItem.fontSize = item.fontSize
                labelItem.numberOfLines = 0
                labelItem.preferredMaxLayoutWidth = item.size.width
                self.addChild(labelItem)
                
            case .textfield:
                
                let texture = SKTexture(imageNamed: "grid9_textfield")
                let imageItem = SKSpriteNode(texture: texture, size: item.size)
                imageItem.centerRect = CGRect.init(x: 0.3333, y: 0.3333, width: 0.3333, height: 0.3333) // 9 grid
                imageItem.name = "textField"
                imageItem.position = item.positionIn(parent: self.size)
                imageItem.zPosition = GameScene.Constants.ZLevels.dialogs + 1.0
                self.addChild(imageItem)
                
                self.didAddTo = { scene in
                    self.replaceTextFields(on: scene?.view)
                }
                
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func replaceTextFields(on view: SKView?) {
        
        if let node = self.childNode(withName: "textField") as? SKSpriteNode, let view = view  {
            
            if let positionInScene = node.positionInScene {
            
                let pos = view.convert(positionInScene, from: view.scene!)
                
                let textFieldSize = node.size.reduced(dx: 10, dy: 10)
                let rect = CGRect(origin: pos - textFieldSize.half, size: textFieldSize)
                
                self.textField = UITextField(frame: rect)
                self.textField?.backgroundColor = .clear
                self.textField?.tintColor = .white
                self.textField?.textColor = .white
                self.textField?.font = Formatters.Fonts.systemFont
                self.textField?.delegate = self

                if let textField = self.textField {
                    view.addSubview(textField)
                }
                
                self.textField?.becomeFirstResponder()
            }
        }
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
    
    func getTextFieldInput(for identifier: String = "textField") -> String {
        
        if let text = self.textField?.text {
            return text
        }
        
        return ""
    }
    
    func addOkayAction(handler: @escaping () -> Void) {
        self.okayHandler = handler
    }
    
    func addCancelAction(handler: @escaping () -> Void) {
        self.cancelHandler = handler
    }
    
    func close() {
        self.removeFromParent()
        
        if self.textField?.superview != nil {
            self.textField?.removeFromSuperview()
        }
    }
}

extension Dialog: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = self.textField?.text {
            print("text input: \(text)")
        }
    }
}

extension SKNode {
    
    func add(dialog: Dialog?) {
        
        if let dialog = dialog {
            self.addChild(dialog)
            
            dialog.didAddTo?(self.scene)
        }
    }
}
