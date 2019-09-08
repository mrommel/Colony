//
//  ClickableLabelNode.swift
//  Colony
//
//  Created by Michael Rommel on 02.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class ClickableLabelNode: SKLabelNode {

    var action: () -> Void

    init(text: String?, buttonAction: @escaping () -> Void) {

        self.action = buttonAction

        super.init()

        self.text = text
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {

        self.action = { }

        super.init()
        self.isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let _ = touches.first {
           self.action()
        }
    }
}
