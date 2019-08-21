//
//  BattleDialog.swift
//  Colony
//
//  Created by Michael Rommel on 20.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class BattleDialog: Dialog {
    
    override init(from dialogConfiguration: DialogConfiguration) {
        super.init(from: dialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(prediction: BattleResult, for target: GameObject?) {
        
        guard let targetUnit = target else {
            return
        }
        
        self.set(text: "Do you want to fight with \(targetUnit)?", identifier: "summary")
        self.set(text: "Prediction\nyou: \(prediction.attackerDamage) losses\nenemy: \(prediction.defenderDamage) losses", identifier: "description")
    }
}
