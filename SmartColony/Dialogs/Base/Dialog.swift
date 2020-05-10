//
//  Dialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 11.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import UIKit
import SmartAILibrary

class Dialog: NineGridTextureSprite {

    fileprivate var okayHandler: (() -> Void)?
    fileprivate var cancelHandler: (() -> Void)?
    fileprivate var resultHandler: ((_ type: DialogResultType) -> Void)?

    fileprivate var didAddTo: ((_ scene: SKScene?) -> Void)?

    var textField: UITextField?
    var selectedItem: DropdownItem? = nil
    var selectedIndex: Int? = nil

    init(from configuration: DialogConfiguration) {
        super.init(imageNamed: configuration.background, size: configuration.size)

        self.position = configuration.position()
        self.anchorPoint = configuration.anchorPoint()
        self.zPosition = Globals.ZLevels.dialogs

        // items
        for item in configuration.items.item {

            switch item.type {
                
            case .button:
                
                var buttonItem: MessageBoxButtonNode
                
                let callback = { [weak self] in
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
                    default:
                        if let handler = self?.resultHandler {
                            handler(item.result)
                        }
                    }
                }
                
                if let imageName = item.image {
                    buttonItem = MessageBoxButtonNode(imageNamed: imageName, title: item.title, sized: item.size, buttonAction: callback)
                } else {
                    buttonItem = MessageBoxButtonNode(titled: item.title, sized: item.size, buttonAction: callback)
                }
                    
                buttonItem.name = item.identifier
                buttonItem.position = item.position()
                buttonItem.zPosition = Globals.ZLevels.dialogs + 1.0
                if !item.active {
                    buttonItem.disable()
                }
                self.addChild(buttonItem)

            case .image:
                
                if let imageName = item.image {
                    let texture = SKTexture(imageNamed: imageName)
                    let imageItem = SKSpriteNode(texture: texture, size: item.size)
                    imageItem.name = item.identifier
                    imageItem.anchorPoint = item.anchorPoint()
                    imageItem.position = item.position()
                    imageItem.zPosition = Globals.ZLevels.dialogs + 1.0
                    self.addChild(imageItem)
                } else {
                    fatalError("Image without texture")
                }

            case .label:
                
                let labelItem = SKLabelNode(text: item.title)
                labelItem.name = item.identifier
                labelItem.position = item.position()
                labelItem.zPosition = Globals.ZLevels.dialogs + 1.0
                labelItem.fontSize = item.fontSize
                labelItem.fontName = Globals.Fonts.customFontFamilyname
                labelItem.numberOfLines = 0
                labelItem.horizontalAlignmentMode = item.textAlign.toHorizontalAlignmentMode()
                labelItem.preferredMaxLayoutWidth = item.size.width
                self.addChild(labelItem)

            case .textfield:

                let texture = SKTexture(imageNamed: "grid9_textfield")
                let imageItem = SKSpriteNode(texture: texture, size: item.size)
                imageItem.centerRect = CGRect.init(x: 0.3333, y: 0.3333, width: 0.3333, height: 0.3333) // 9 grid
                imageItem.name = "textField"
                imageItem.position = item.position()
                imageItem.anchorPoint = item.anchorPoint()
                imageItem.zPosition = Globals.ZLevels.dialogs + 1.0
                self.addChild(imageItem)

                self.didAddTo = { scene in
                    self.replaceTextFields(on: scene?.view)
                }

            case .progressbar:
                
                let progressBar = ProgressBarNode(size: item.size)
                progressBar.set(progress: 0.0)
                progressBar.name = item.identifier
                progressBar.position = item.position()
                progressBar.zPosition = Globals.ZLevels.dialogs + 1.0
                self.addChild(progressBar)
                
            case .dropdown:
                
                guard let dropdownItems = item.items, let dropdownSelectedIndex = item.selectedIndex else {
                    fatalError("no items or selectedIndex for dropdown found")
                }
                
                var items: [DropdownItem] = []
                for dropdownItem in dropdownItems.item {
                    items.append(DropdownItem(imageName: dropdownItem, title: dropdownItem))
                }
                
                let dropdown = DropdownNode(items: items, selectedIndex: dropdownSelectedIndex, size: item.size)
                dropdown.name = item.identifier
                dropdown.position = item.position()
                dropdown.anchorPoint = item.anchorPoint()
                dropdown.zPosition = Globals.ZLevels.dialogs + 1.0
                dropdown.delegate = self
                self.addChild(dropdown)
                
                self.selectedIndex = dropdownSelectedIndex
                self.selectedItem = items[dropdownSelectedIndex]
                
            case .yieldInfo:
                
                let yieldInfo = YieldDisplayNode(for: item.yieldType, value: 0.0, size: item.size)
                yieldInfo.name = item.identifier
                yieldInfo.position = item.position()
                //yieldInfo.anchorPoint = item.anchorPoint()
                yieldInfo.zPosition = Globals.ZLevels.dialogs + 1.0
                self.addChild(yieldInfo)
                
            case .techInfo:
                
                let techInfo = TechDisplayNode(techType: item.techType, size: item.size)
                techInfo.name = item.identifier
                techInfo.position = item.position()
                techInfo.zPosition = Globals.ZLevels.dialogs + 1.0
                techInfo.touchHandler = {
                    if let handler = self.resultHandler {
                        handler(item.result)
                    }
                }
                self.addChild(techInfo)
                
            case .civicInfo:
            
                let civicInfo = CivicDisplayNode(civicType: item.civicType, size: item.size)
                civicInfo.name = item.identifier
                civicInfo.position = item.position()
                civicInfo.zPosition = Globals.ZLevels.dialogs + 1.0
                civicInfo.touchHandler = {
                    if let handler = self.resultHandler {
                        handler(item.result)
                    }
                }
                self.addChild(civicInfo)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func replaceTextFields(on view: SKView?) {

        if let node = self.childNode(withName: "textField") as? SKSpriteNode, let view = view {

            if let positionInScene = node.positionInScene {

                let pos = view.convert(positionInScene, from: view.scene!)

                let textFieldSize = node.size.reduced(dx: 10, dy: 10)
                let rect = CGRect(origin: pos - textFieldSize.half, size: textFieldSize)

                self.textField = UITextField(frame: rect)
                self.textField?.backgroundColor = .clear
                self.textField?.tintColor = .white
                self.textField?.textColor = .white
                self.textField?.font = Globals.Fonts.customFont
                self.textField?.delegate = self

                if let textField = self.textField {
                    view.addSubview(textField)
                }

                //self.textField?.becomeFirstResponder()
            }
        }
    }
    
    func resignActive() {
        
        self.textField?.resignFirstResponder()
    }
    
    func item(with identifier: String) -> SKNode? {
        
        if let node = self.children.first(where: { $0.name == identifier }) {
            return node
        }
        
        fatalError("Can't find \(identifier)")
    }
    
    func button(with identifier: String) -> MessageBoxButtonNode? {
        
        if let node = self.children.first(where: { $0.name == identifier }) {
            return node as? MessageBoxButtonNode
        }
        
        fatalError("Can't find \(identifier)")
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
            fatalError("identifier does not identify a SKSpriteNode")
        }

        let texture = SKTexture(imageNamed: imageName)

        spriteNode.texture = texture
    }
    
    func set(progress: Double, identifier: String) {
        
        guard let node = self.children.first(where: { $0.name == identifier }) else {
            fatalError("Can't find \(identifier)")
        }
        
        guard let progressBarNode = node as? ProgressBarNode else {
            fatalError("identifier does not identify a ProgressBarNode")
        }
        
        progressBarNode.set(progress: progress)
    }
    
    func set(yieldValue: Double, identifier: String) {
        
        guard let node = self.children.first(where: { $0.name == identifier }) else {
            fatalError("Can't find \(identifier)")
        }
        
        guard let yieldDisplayNode = node as? YieldDisplayNode else {
            fatalError("identifier does not identify a YieldDisplayNode")
        }
        
        yieldDisplayNode.set(yieldValue: yieldValue)
    }
    
    func set(textFieldInput: String, for identifier: String = "textField") {
        
        self.textField?.text = textFieldInput
    }

    func getTextFieldInput(for identifier: String = "textField") -> String {

        if let text = self.textField?.text {
            return text
        }

        return ""
    }
    
    // maybe String?
    func getSelectedDropdown() -> String {
        
        if let selectedItem = self.selectedItem {
            return selectedItem.title
        }
        
        return ""
    }

    func addOkayAction(handler: @escaping () -> Void) {
        self.okayHandler = handler
    }

    func addCancelAction(handler: @escaping () -> Void) {
        self.cancelHandler = handler
    }

    func addResultHandler(handler: @escaping (_ type: DialogResultType) -> Void) {
        self.resultHandler = handler
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //scene?.view?.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
}

extension Dialog: DropdownDelegate {
    
    func dropdownClicked() {
        
        self.resignActive()
    }

    func selected(item: DropdownItem, at index: Int) {
        
        self.selectedItem = item
        self.selectedIndex = index
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
