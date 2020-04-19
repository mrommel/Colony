//
//  CivicDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 18.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class CivicDialog: Dialog {

    init(with civics: AbstractCivics?) {
        let uiParser = UIParser()
        guard let civicDialogConfiguration = uiParser.parse(from: "CivicDialog") else {
            fatalError("cant load CivicDialog configuration")
        }

        super.init(from: civicDialogConfiguration)
        
        self.check(civics: civics)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func check(civics: AbstractCivics?) {
        
        guard let civics = civics else {
            fatalError("Cant get techs")
        }
        
        let possibleCivics = civics.possibleCivics()
        
        for item in self.children {
            
            if let civicDisplayNode = item as? CivicDisplayNode {
                
                if civics.has(civic: civicDisplayNode.civicType) {
                    civicDisplayNode.activate()
                } else if !possibleCivics.contains(civicDisplayNode.civicType) {
                    civicDisplayNode.disable()
                }
            }
        }
    }
}
