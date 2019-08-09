//
//  MapLoadingDialog.swift
//  Colony
//
//  Created by Michael Rommel on 08.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class MapLoadingDialog: Dialog {
    
    override init(from dialogConfiguration: DialogConfiguration) {
        super.init(from: dialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showProgress(value: CGFloat, text: String) {
        
        self.set(progress: value, identifier: "progress")
        self.set(text: text, identifier: "text")
    }
}
