//
//  ScienceDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 17.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class ScienceDialog: Dialog {

    init(with techs: AbstractTechs?) {
        let uiParser = UIParser()
        guard let scienceDialogConfiguration = uiParser.parse(from: "ScienceDialog") else {
            fatalError("cant load ScienceDialog configuration")
        }

        super.init(from: scienceDialogConfiguration)
        
        self.check(techs: techs)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func check(techs: AbstractTechs?) {
        
        guard let techs = techs else {
            fatalError("Cant get techs")
        }
        
        let possibleTechs = techs.possibleTechs()
        
        for item in self.children {
            
            if let techDisplayNode = item as? TechDisplayNode {
                
                if techs.has(tech: techDisplayNode.techType) {
                    techDisplayNode.activate()
                } else if !possibleTechs.contains(techDisplayNode.techType) {
                    techDisplayNode.disable()
                }
            }
        }
    }
}
