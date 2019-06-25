//
//  SafeAreaNode.swift
//  Colony
//
//  Created by Michael Rommel on 25.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class SafeAreaNode: SKNode {

    override var frame: CGRect {
        get {
            return self._frame
        }
    }

    private var _frame: CGRect = CGRect.zero

    func refresh() {
        guard let scene = scene, let view = scene.view else { return }
        let scaleFactor = min(scene.size.width, scene.size.height) / min(view.bounds.width, view.bounds.height)
        let x = view.safeAreaInsets.left * scaleFactor
        let y = view.safeAreaInsets.bottom * scaleFactor
        let width = (view.bounds.size.width - view.safeAreaInsets.right - view.safeAreaInsets.left) * scaleFactor
        let height = (view.bounds.size.height - view.safeAreaInsets.bottom - view.safeAreaInsets.top) * scaleFactor
        let offsetX = scene.size.width * scene.anchorPoint.x
        let offsetY = scene.size.height * scene.anchorPoint.y
        self._frame = CGRect(x: x - offsetX, y: y - offsetY, width: width, height: height)
    }
}
