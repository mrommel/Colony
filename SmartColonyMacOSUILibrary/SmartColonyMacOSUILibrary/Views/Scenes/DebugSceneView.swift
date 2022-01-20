//
//  BaseSceneView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 20.01.22.
//

import SwiftUI
import SpriteKit

public struct DebugSceneView: NSViewRepresentable {

    public init() {

    }

    public class Coordinator: NSObject {
        var debugScene: BaseScene?
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    public func makeNSView(context: Context) -> SKView {

        print("makeNSView")

        let view = SKView(frame: .zero)
        view.preferredFramesPerSecond = 60
        view.allowsTransparency = true

        #if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        #endif

        // init SpriteKit Scene
        let debugScene = DebugScene(size: .zero)
        debugScene.scaleMode = .resizeFill
        debugScene.backgroundColor = NSColor.clear

        context.coordinator.debugScene = debugScene

        view.presentScene(context.coordinator.debugScene)
        view.ignoresSiblingOrder = false

        return view
    }

    public func updateNSView(_ view: SKView, context: Context) {

    }
}
