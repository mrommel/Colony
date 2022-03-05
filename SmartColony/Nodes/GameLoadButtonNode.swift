//
//  GameLoadButtonNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 02.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

class GameLoadButtonNode: MessageBoxButtonNode {

    let gameName: String

    // callback
    var touchHandler: (_ gameName: String) -> Void

    init(gameNamed gameName: String, buttonAction: @escaping (_ gameName: String) -> Void) {

        self.gameName = gameName
        self.touchHandler = buttonAction

        super.init(titled: self.gameName, sized: CGSize(width: 200, height: 42), buttonAction: {})
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: touch handlers

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        // propergate to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesBegan(touches, with: event)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        // propergate to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesMoved(touches, with: event)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)

            // propergate to scrollview
            if let scrollView = self.parent?.parent as? ScrollNode {

                if scrollView.backgroundNode!.contains(location) {

                    // if self.backgroundNode!.contains(location) {
                        self.touchHandler(self.gameName)
                    // }
                }
            }
        }
    }
}
