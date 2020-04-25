//
//  ScienceDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 17.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary
import SpriteKit

class ScienceDialog: Dialog {
    
    // nodes
    var scrollNode: ScrollNode?
    
    // MARK: Constructors

    init(with techs: AbstractTechs?) {
        let uiParser = UIParser()
        guard let scienceDialogConfiguration = uiParser.parse(from: "ScienceDialog") else {
            fatalError("cant load ScienceDialog configuration")
        }

        super.init(from: scienceDialogConfiguration)
        
        self.check(techs: techs)
        
        self.setupScrollView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: private methods
    
    private func check(techs: AbstractTechs?) {
        
        guard let techs = techs else {
            fatalError("Cant get techs")
        }
        
        let possibleTechs = techs.possibleTechs()
        
        for item in self.children {
            
            if let techDisplayNode = item as? TechDisplayNode {
                
                if techs.currentTech() == techDisplayNode.techType {
                    techDisplayNode.select()
                } else if techs.has(tech: techDisplayNode.techType) {
                    techDisplayNode.activate()
                } else if !possibleTechs.contains(techDisplayNode.techType) {
                    techDisplayNode.disable()
                }
            }
        }
    }
    
    private func setupScrollView() {
        
        // scroll area
        self.scrollNode = ScrollNode(size: CGSize(width: 350, height: 500), contentSize: CGSize(width: 350, height: 800))
        self.scrollNode?.position = CGPoint(x: 0, y: -410)
        self.scrollNode?.zPosition = self.zPosition + 1
        self.addChild(self.scrollNode!)
        
        for item in self.children {
            
            if let techDisplayNode = item as? TechDisplayNode {
                techDisplayNode.removeFromParent()
            
                self.scrollNode?.addScrolling(child: techDisplayNode)
            }
        }
    }
}
