//
//  AIPlayerTurnDialog.swift
//  Colony
//
//  Created by Michael Rommel on 25.11.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class AIPlayerTurnDialog: Dialog {
    
    override init(from dialogConfiguration: DialogConfiguration) {
        super.init(from: dialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(for civilization: Civilization) {

        self.set(text: "Current turn \(civilization)", identifier: "summary")
    }
}
