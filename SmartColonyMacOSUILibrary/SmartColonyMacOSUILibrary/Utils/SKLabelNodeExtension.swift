//
//  SKLabelNodeExtension.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit

extension SKLabelNode {

    func fitToWidth(maxWidth: CGFloat) {

        while frame.size.width >= maxWidth {
            self.fontSize -= 1.0
        }
    }
}
