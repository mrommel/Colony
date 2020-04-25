//
//  CivicDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 18.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary
import SpriteKit

class CivicDialog: Dialog {

    // nodes
    var scrollNode: ScrollNode?
    
    // MARK: Constructors
    
    init(with civics: AbstractCivics?) {
        let uiParser = UIParser()
        guard let civicDialogConfiguration = uiParser.parse(from: "CivicDialog") else {
            fatalError("cant load CivicDialog configuration")
        }

        super.init(from: civicDialogConfiguration)
        
        self.check(civics: civics)
        
        self.setupScrollView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: private methods
    
    private func check(civics: AbstractCivics?) {
        
        guard let civics = civics else {
            fatalError("Cant get techs")
        }
        
        let possibleCivics = civics.possibleCivics()
        
        for item in self.children {
            
            if let civicDisplayNode = item as? CivicDisplayNode {
                
                if civics.currentCivic() == civicDisplayNode.civicType {
                    civicDisplayNode.select()
                } else if civics.has(civic: civicDisplayNode.civicType) {
                    civicDisplayNode.activate()
                } else if !possibleCivics.contains(civicDisplayNode.civicType) {
                    civicDisplayNode.disable()
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
            
            if let civicDisplayNode = item as? CivicDisplayNode {
                civicDisplayNode.removeFromParent()
            
                self.scrollNode?.addScrolling(child: civicDisplayNode)
            }
        }
    }
}
