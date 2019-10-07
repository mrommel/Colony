//
//  LevelIntroductionDialog.swift
//  Colony
//
//  Created by Michael Rommel on 23.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class LevelIntroductionDialog: Dialog {
    
    override init(from dialogConfiguration: DialogConfiguration) {
        super.init(from: dialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayIntroductionFor(levelMeta: LevelMeta?) {
        
        if let levelMeta = levelMeta {
            self.set(text: levelMeta.title, identifier: "title")
            self.set(text: levelMeta.summary, identifier: "summary")
        } else {
            self.set(text: "Free playing", identifier: "title")
            self.set(text: "Please play free", identifier: "summary")
        }
    }
}
