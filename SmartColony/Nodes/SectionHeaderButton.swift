//
//  SectionHeaderButton.swift
//  SmartColony
//
//  Created by Michael Rommel on 21.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

class SectionHeaderButton: SpriteButtonNode {

    var expanded: Bool = true
    
    init(titled title: String, sized size: CGSize = CGSize(width: 200, height: 42), buttonAction: @escaping () -> Void) {

        super.init(titled: title,
                   enabledButtonImage: "segment_button",
                   disabledButtonImage: "segment_button",
                   size: size,
                   buttonAction: buttonAction)
        
        self.fontColor = SKColor(hex: "#16344f")
    }
    
    /**
    Required so XCode doesn't throw warnings
    */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle() {
        
        self.expanded = !self.expanded
    }
}
