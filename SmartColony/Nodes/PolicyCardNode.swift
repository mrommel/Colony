//
//  PolicyCardNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 22.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class PolicyCardNode: SKNode {

    // nodes
    var backgroundNode: SKSpriteNode?
    var nameLabel: SKLabelNode?
    //var shadowNameLabel: SKLabelNode?
    var bonusLabel: SKLabelNode?
    
    // MARK: constructors
    
    init(policyCard: PolicyCardType) {
        
        super.init()
        
        let size = CGSize(width: 100, height: 100)
        
        let texture = SKTexture(imageNamed: policyCard.iconTexture())
        self.backgroundNode = SKSpriteNode(texture: texture, color: .black, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)

        self.nameLabel = SKLabelNode(text: policyCard.name())
        self.nameLabel?.fontSize = 12
        self.nameLabel?.fontColor = .black
        self.nameLabel?.zPosition = self.zPosition + 10
        self.nameLabel?.verticalAlignmentMode = .center
        self.nameLabel?.position = CGPoint(x: size.halfWidth, y: -20)
        self.addChild(self.nameLabel!)
        
        let tmpText = policyCard.bonus()
        let bonusText: NSMutableAttributedString
        do {
            let regex = try NSRegularExpression(pattern: "(Civ6Production|Civ6Gold|Civ6StrengthIcon)", options: NSRegularExpression.Options())
            let splits = regex.split(tmpText)

            let attText = NSMutableAttributedString()
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .backgroundColor: UIColor.red,
                .font: UIFont.boldSystemFont(ofSize: 10)
            ]
            
            for split in splits {
                
                if split == "Civ6StrengthIcon" {
                    let attachment = NSTextAttachment()
                    attachment.image = UIImage(named: "StrengthIcon")!.resize(to: CGSize(width: 32, height: 32))
                    attachment.bounds = CGRect(x: 0, y: 0, width: 32, height: 32)
                    attText.append(NSAttributedString(attachment: attachment))
                } else {
                    attText.append(NSAttributedString(string: split, attributes: attributes))
                }
            }
            
            bonusText = attText
            
        } catch {
            print("failed")
            bonusText = NSMutableAttributedString(string: policyCard.bonus())
        }
        
        self.bonusLabel = SKLabelNode(attributedText: bonusText)
        self.bonusLabel?.fontSize = 8
        self.bonusLabel?.fontColor = .black
        self.bonusLabel?.zPosition = self.zPosition + 10
        self.bonusLabel?.verticalAlignmentMode = .center
        self.bonusLabel?.numberOfLines = 0
        self.bonusLabel?.preferredMaxLayoutWidth = 60
        self.bonusLabel?.position = CGPoint(x: size.halfWidth, y: -60)
        
        if let attributedText = self.bonusLabel?.attributedText {
          attributedText.enumerateAttribute(NSAttributedString.Key.attachment, in: NSRange(location: 0, length: attributedText.length), options: []) { (value, range, stop) in
                if value is NSTextAttachment {
                    if let attachment = value as? NSTextAttachment {
                        
                        if let image = attachment.image {
                            let texture = SKTexture(image: image)
                            let imageSpriteNode = SKSpriteNode(texture: texture)
                            print("attachment.bounds: \(attachment.bounds)")
                            self.bonusLabel?.addChild(imageSpriteNode)
                        }
                    }
                }
            }
        }
        
        self.addChild(self.bonusLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
