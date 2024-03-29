//
//  SafeAreaNode.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SpriteKit

// swiftlint:disable implicit_getter
class SafeAreaNode: SKEffectNode {

    override var frame: CGRect {
        get {
            return self.safeAreaFrame
        }
    }

    private var safeAreaFrame: CGRect = CGRect.zero

    func updateLayout() {

        // scene is needed and main view
        guard let scene = scene, let view = scene.view else {
            return
        }

        let scaleFactor = min(scene.size.width, scene.size.height) / min(view.bounds.width, view.bounds.height)
        let x = view.safeAreaInsets.left * scaleFactor
        let y = view.safeAreaInsets.bottom * scaleFactor
        let width = (view.bounds.size.width - view.safeAreaInsets.right - view.safeAreaInsets.left) * scaleFactor
        let height = (view.bounds.size.height - view.safeAreaInsets.bottom - view.safeAreaInsets.top) * scaleFactor
        let offsetX = scene.size.width * scene.anchorPoint.x
        let offsetY = scene.size.height * scene.anchorPoint.y

        self.safeAreaFrame = CGRect(x: x - offsetX, y: y - offsetY, width: width, height: height)
    }
}
// swiftlint:enable implicit_getter
